# Feature Addition Plan B

Status: implemented after review. The implemented changes are in
`omarchy/vim/init.vim` and `omarchy/vim/README.md`.

Scope:

- `omarchy/vim/init.vim`
- `omarchy/vim/README.md`
- wrapper files only if a new option must be exposed in examples

Primary recommendation: make a focused quality-of-life pass rather than a broad
editor rewrite. The current config already has the right overall shape: one
Vimscript file, explicit plugin install/update commands, ALE for Python, optional
FZF, built-in Netrw, built-in diffs, and fallback pickers. The best next changes
are to reduce accidental destructive editing, make split/diff workflows simpler,
add a small general terminal toggle, improve non-Python filetype support without
toolchain creep, and fully document the user model in the README.

References checked:

- `omarchy/vim/init.vim`
- `omarchy/vim/README.md`
- `omarchy/vim/backlog.md`
- `https://github.com/smnatale/nvim_native`
- `https://raw.githubusercontent.com/smnatale/nvim_native/main/init.lua`
- `https://github.com/smnatale/nvim_native/blob/main/lua/find.lua`
- `https://github.com/smnatale/nvim_native/blob/main/lua/grep.lua`
- `https://github.com/smnatale/nvim_native/blob/main/lua/lsp.lua`
- `https://github.com/smnatale/nvim_native/blob/main/lua/formatting.lua`
- `https://github.com/junegunn/fzf`
- `https://manpages.debian.org/bookworm/fzf/fzf.1.en.html`
- `https://github.com/junegunn/vim-plug/wiki/tutorial`

## Current Context

- `<Leader>` is Space.
- `<Space><Space>` opens the buffer picker through `:OmarchyBuffers`.
- `<Leader>fk` shows config-declared mappings from `MAP:` comments.
- `<Leader>fm` delegates to fzf.vim `:Maps`, but that path requires FZF and is
  documented as normal-mode maps rather than a reliable all-mode keymap browser.
- `<Leader>fr` already provides project-wide grep. With FZF, `rg`, and fzf.vim
  available it runs `:Rg`; otherwise it prompts for a pattern and falls back to
  `rg --vimgrep` or recursive `grep` in a scratch picker.
- `<Leader>fs` already provides a current-file symbol picker for Python classes
  and functions through `:PythonSymbols`.
- `<Leader>s*` is used for built-in sessions:
  - `<Leader>ss` save session
  - `<Leader>sr` restore session
  - `<Leader>sl` list sessions
  - `<Leader>sd` delete session
- There is no exact `<Leader>s` mapping. Because `s` is Vim's normal-mode
  substitute command, an incomplete or mistyped `<Leader>s...` sequence can fall
  through into editing behavior after timeout or mismatch.
- Visual paste has no custom mapping today. Normal Vim visual `p` replaces the
  selection and changes the unnamed register to the replaced text. That is often
  surprising when pasting the same text over multiple selections.
- FZF is optional and currently guarded against plugin-managed binary downloads.
- `timeoutlen=350` is already explicit but not easy for a user to tune with
  documented fast/medium/slow profiles. `ttimeoutlen` is not explicit.
- Netrw uses `:Lexplore` and scans for existing Netrw windows. It mostly works,
  but the behavior can be ambiguous when invoked from a right-hand split.
- Built-in diffs currently cover current buffer versus saved file and current
  buffer versus git `HEAD`; they do not yet cover "pick another open buffer" or
  3/4-buffer diff sessions.
- The README is already detailed, but the next implementation should do a full
  pass so the README becomes the complete user guide for these new workflows.

## Feedback Update

The follow-up suggestions are practical if kept small:

- Next/previous diff navigation already exists natively as `]c` and `[c`. The
  plan should keep those native keys and add only discoverable aliases/help under
  `<Leader>d*`.
- Statusline mode coloring is worth attempting because Vim statuslines support
  highlight-group switches such as `%#GroupName#`. Keep it optional and simple:
  if highlight handling becomes brittle across Vim/Neovim or colorschemes, skip
  it rather than adding a custom color subsystem.
- Current-file symbol picking already exists for Python. Extend it only if a
  small regex-based generic symbol picker can cover common filetypes without
  pretending to be a complete semantic outline.
- `:PythonSymbols` must remain supported. `:Symbols` may wrap or extend it, but
  must not remove or break the Python-specific command. Both commands should
  fail gently outside their supported filetypes.
- Project-wide grep already exists. The implementation pass should mainly
  improve README visibility and maybe rename/add a command alias if the current
  `<Leader>fr` behavior is not obvious.
- `<Leader>/` and `<Leader>//` were requested as duplicate slash-style comment
  maps. They already existed in normal and visual mode and had no conflicting
  config mappings, so implementation kept them unchanged and documented them.
- `:OmarchyTerminal` should launch a login Bash shell by default
  (`bash --login -i`) so Linux, GCP Debian JupyterLab, and Git Bash startup-file
  behavior follows normal Bash login-shell rules.
- `undofile`, `autoread`, and `checktime` are good built-in improvements, but
  they should be documented with their real behavior and caveats.

## Recommendation Summary

Implement:

- Add an exact `<Leader>s` no-op mapping while preserving existing session maps.
- Add visual paste preservation, preferably behind a small option and documented
  clearly.
- Document FZF's built-in exact search syntax, and optionally add exact-mode FZF
  variants only where the current config owns the picker implementation.
- Add a general terminal launcher/toggle using project-root-first directory
  selection, with an override option.
- Make `<Leader>ee` deterministic: always create or reuse a far-left Netrw tree
  and restore focus predictably.
- Add simple right-vsplit workflows from current buffer, file picker, buffer
  picker, and Netrw.
- Add buffer/file diff pickers for 2-way diffs, plus a buffer-based 3/4-way diff
  command. Keep multi-file diff based on already-open buffers to reduce cognitive
  load.
- Add a small diff help command and a few low-risk navigation aliases, but keep
  native `do`, `dp`, `:diffget`, and `:diffput` as the core merge workflow.
- Optionally color the mode segment of the statusline using small highlight
  groups, guarded so it can be disabled or skipped if colorscheme interaction is
  poor.
- Keep the existing Python symbol picker and optionally generalize it to a
  conservative current-file symbol picker for common filetypes.
- Keep existing project-wide grep and document it more prominently.
- Expand filetype, syntax, linting, and optional LSP support for markdown, shell,
  BigQuery SQL, Lua, Vimscript, and web languages without requiring Node/Rust/Go
  in the default path.
- Add an all-mappings browser separate from the config-declared keymap browser.
- Add an explicit plugin policy command or README section that states startup
  never installs, updates, cleans, or upgrades plugins.
- Add a no-update plugin update checker that reads remote refs without modifying
  plugin working trees.
- Add explicit timeout variables with documented fast/medium/slow values.
- Add simple built-in persistence improvements from `nvim_native` where portable:
  persistent undo, `autoread`, and a `checktime` autocmd.

Do not implement:

- Do not port the `nvim_native` config structure. It is Lua and Neovim 0.11+,
  while this config intentionally targets Vim 9 plus Neovim compatibility.
- Do not add Tree-sitter. It is Neovim-oriented and adds parser/runtime
  management that does not fit the current Vim-compatible approach.
- Do not make LSP for TypeScript/HTML/CSS/JS part of the no-Node default. Those
  practical language servers are Node-based.
- Do not add a full visual merge UI. Vim's native diff commands are powerful and
  already standard; this config should make them discoverable, not hide them
  behind a fragile custom abstraction.

## Item-by-Item Analysis

### 1. `<Leader>s` accidentally enters insert mode

Recommendation: fix.

Reasoning: `<Leader>s` is a session prefix, but bare normal-mode `s` means
substitute character and enter insert mode. A mistyped `<Leader>sk` can be
interpreted partly as normal input after mapping resolution fails. That is a
bad failure mode because it edits the buffer.

Implementation plan:

- Add a non-`<nowait>` exact mapping:

```vim
" MAP: <Leader>s | Session prefix guard; no-op on incomplete session key
nnoremap <silent> <Leader>s <Nop>
```

- Keep `<Leader>ss`, `<Leader>sr`, `<Leader>sl`, and `<Leader>sd`.
- Do not use `<nowait>` on `<Leader>s`; that would prevent the longer session
  maps from resolving.
- Add a README note that `<Leader>s` alone is intentionally inert.

### 2. Visual paste preservation

Recommendation: implement, but document the behavior because it changes a common
Vim default.

What it means: in visual mode, Vim's `p` replaces the selected text with the
current register, and the deleted selection becomes the unnamed register. That
means the next `p` may paste the text you just replaced instead of the text you
originally wanted to paste.

About `@r`: `@r` is the contents of register `r`. The common issue is usually
the unnamed register (`@"`) and system clipboard registers (`+`/`*` when
`clipboard` includes them), not a named register like `r`. If a named register
is used explicitly, the concern is still preserving the pasted text for repeated
replacement.

Implementation plan:

- Add:

```vim
let g:omarchy_visual_paste_preserve_register = get(g:, 'omarchy_visual_paste_preserve_register', 1)
if g:omarchy_visual_paste_preserve_register
  " MAP: p | Visual paste without replacing the unnamed register
  xnoremap <silent> p "_dP
endif
```

- Consider adding `<Leader>p` for the preserving behavior and leaving visual `p`
  native if review decides default Vim behavior matters more than convenience.
- README must explain native visual `p`, preserving visual `p`, and how to opt
  out.

### 3. Literal search for fuzzy find commands

Recommendation: document FZF's built-in syntax first; add exact-mode variants
only if they remain simple.

FZF already supports literal/exact search in the search box:

- Prefix a term with a single quote for exact contains matching, for example
  `'README`.
- Use `^term` for exact prefix matching.
- Use `term$` for exact suffix matching.
- Use `!term` for inverse exact matching.
- Use `--exact` / `-e` to make exact matching the default for a picker.

Implementation plan:

- Update README with the FZF exact search syntax above.
- Add exact-mode variants for Omarchy-owned FZF calls if easy:
  - `<Leader>fF`: exact project files
  - `<Leader>fG`: exact git files
  - `<Leader>fL`: exact current-buffer lines
  - `<Leader>fK`: all maps or exact keymaps depending on final key decision
- Prefer `F` uppercase over `<Leader>fx` unless the user strongly prefers `x`.
  Uppercase variants are easier to relate to the existing lowercase finder keys.
- Avoid reimplementing all of fzf.vim's `:Files`/`:GFiles` behavior just to pass
  `--exact`. If exact variants get complex, stop at documentation because FZF's
  single-quote syntax already solves the main problem.

### 4. Terminal launcher/toggle directory

Recommendation: add a general terminal toggle with explicit root strategy.

Best default directory: project root. For terminal tasks launched from an editor,
the project root is the least surprising default for build/test/git commands.

Fallback order:

1. Current buffer's git root.
2. Current buffer's directory.
3. Current Vim working directory.

Implementation plan:

- Add options:

```vim
let g:omarchy_terminal_root_strategy = get(g:, 'omarchy_terminal_root_strategy', 'project')
let g:omarchy_terminal_height = get(g:, 'omarchy_terminal_height', 15)
```

- Supported `g:omarchy_terminal_root_strategy` values:
  - `'project'`: git root, then buffer directory, then `:pwd`
  - `'buffer'`: buffer directory, then `:pwd`
  - `'cwd'`: always `:pwd`
- Add `:OmarchyTerminal [cmd]`.
- Add `<Leader>tt` to toggle a bottom terminal.
- Add `<Leader>tT` to open a new terminal split even if one already exists.
- Use `:terminal` only when available; otherwise echo a clear message.
- Keep the Copilot CLI terminal mapping separate but let it reuse the same root
  resolution helper.

### 5. `<Leader>ee` from a right-hand split

Recommendation: fix deterministic Netrw placement.

Current risk: `:Lexplore` can behave differently depending on the current split,
existing explorer state, and Netrw globals. The desired model is simpler: one
tree, far left, fixed width, with focus behavior controlled by the command.

Implementation plan:

- Replace or wrap the current `s:NetrwOpen()` behavior so it:
  - closes/reuses any existing Netrw tree in the current tab,
  - opens `topleft vertical` at `abs(g:netrw_winsize)` columns,
  - runs `Explore` or `edit` on the target directory inside that left window,
  - applies Netrw buffer-local safety mappings,
  - returns focus to the original editing window by default.
- Add:

```vim
let g:omarchy_file_explorer_focus = get(g:, 'omarchy_file_explorer_focus', 0)
```

- Keep `<Leader>ee` as toggle.
- Keep `<Leader>eE` as reveal current file; for reveal, focus can reasonably
  remain in the tree because the user asked to inspect a path.
- Add tests from left, middle, and right splits.

### 6. Open file/buffer/current buffer in right vsplit

Recommendation: add explicit right-vsplit commands with consistent focus rules.

Use cases:

- From current buffer: duplicate/open current buffer in a split to the right.
- From file tree: open selected file to the right of the current editing window.
- From file picker: pick a file and open it to the right.
- From buffer picker: pick a buffer and open it to the right.

Implementation plan:

- Add split helpers:
  - `s:OpenCurrentBufferRight(focus_new)`
  - `s:OpenFileRight(file, focus_new)`
  - `s:OpenBufferRight(bufnr, focus_new)`
- Add commands:
  - `:OmarchyCurrentBufferVsplit`
  - `:OmarchyFilesVsplit`
  - `:OmarchyBuffersVsplit`
- Add maps:
  - `<Leader>wV`: open current buffer in a right split and focus it.
  - `<Leader>fV`: pick a file and open it in a right split.
  - `<Leader>bV`: pick a buffer and open it in a right split.
- Optional keep-focus variants can use lowercase/uppercase distinction only if
  it stays memorable:
  - `V` focuses the new right split.
  - `v` opens but returns to the original window.
- In Netrw, map:
  - `v`: open file in right split and focus file.
  - `V`: open file in right split and return focus to tree/origin, if reliable.
- Do not depend on terminal `<C-v>` for this workflow because browser-hosted
  terminals and some terminal configurations intercept control keys.

### 7. Simple 2-way diff with picked file or buffer

Recommendation: implement two direct 2-way diff commands.

Implementation plan:

- Add:
  - `:DiffFile` / `<Leader>df`: diff current buffer against a picked file.
  - `:DiffBuffer` / `<Leader>db`: diff current buffer against a picked listed
    buffer.
- For `:DiffFile`, use `rightbelow vertical diffsplit {file}` or equivalent,
  then ensure current/new orientation remains easy to understand.
- For `:DiffBuffer`, open the selected buffer in a right split, then run
  `diffthis` in both windows.
- Preserve existing:
  - `<Leader>ds`: diff current buffer against saved file.
  - `<Leader>dg`: diff current buffer against git `HEAD`.
  - `<Leader>dq`: close Omarchy diff.
- Make all Omarchy-created diff sessions closable with `<Leader>dq`.
- Avoid overloading Fugitive's `<Leader>gd`; keep it Fugitive-owned when enabled.

### 8. 3-file and 4-file diff views

Recommendation: support 3/4-way diffs from open buffers, not arbitrary files.

Reasoning: choosing 3 or 4 files from the filesystem, deciding order, and
placing focus creates a lot of UI complexity. The simpler low-cognitive-load
workflow is: open the files first, then pick the buffers to diff.

Implementation plan:

- Add `:DiffBuffers` and `<Leader>dB`.
- With FZF available:
  - use a multi-select listed-buffer picker,
  - current buffer is included automatically,
  - allow selecting 1-3 additional buffers.
- Without FZF:
  - prompt for buffer numbers, comma-separated.
- Open selected buffers in vertical splits in order.
- Run `diffthis` on all selected windows.
- Document that Vim supports multi-window diffs, but readability drops quickly
  after 3 panes; 4 is useful mostly for short files or wide terminals.
- Add `:DiffOff` / `<Leader>dQ` to run `diffoff!` for all windows in the tab.

### 9. Interactive merge and git diff support

Recommendation: add discoverability and a few aliases, not a custom merge UI.

Native Vim diff merge commands are standard and worth preserving:

- `]c`: next diff hunk.
- `[c`: previous diff hunk.
- `do`: obtain change from the other window (`:diffget`).
- `dp`: put change into the other window (`:diffput`).
- `:diffupdate`: rescan diffs after edits.
- `:diffoff!`: leave diff mode.

Answer to the follow-up question: yes, next/previous diff navigation is already
available with native `]c` and `[c`. That is the right primitive to document and
optionally alias. There is no need to invent another diff hunk navigation system.

Implementation plan:

- Add `:DiffHelp` / `<Leader>dh` opening a small scratch buffer with the commands
  above and the current Omarchy diff commands.
- Add low-risk aliases:
  - `<Leader>dn`: next diff hunk (`]c`)
  - `<Leader>dN`: previous diff hunk (`[c`)
  - `<Leader>du`: `:diffupdate`
  - `<Leader>dQ`: `:diffoff!`
- Do not remap native `do` or `dp`.
- For git:
  - keep `<Leader>dg` for current versus `HEAD`,
  - keep gitgutter hunk preview/stage/undo maps when `g:omarchy_use_gitgutter=1`,
  - document Fugitive's richer merge/status behavior when
    `g:omarchy_use_fugitive=1`.

### 10. Statusline mode coloring

Recommendation: attempt a small implementation, but make it easy to disable and
do not force it if it becomes brittle.

Reasoning: Vim statuslines can switch highlight groups inline with
`%#HighlightGroup#`, so color-coding the mode text should be straightforward.
The hard part is not detecting the mode; `OmarchyMode()` already does that. The
hard part is choosing colors that remain readable across terminal color modes,
Vim, Neovim, and user colorschemes.

Implementation plan:

- Add:

```vim
let g:omarchy_statusline_mode_colors = get(g:, 'omarchy_statusline_mode_colors', 1)
```

- Define small highlight groups after `termguicolors` setup:
  - `OmarchyModeNormal`: light gray
  - `OmarchyModeInsert`: orange
  - `OmarchyModeVisual`: blue
  - `OmarchyModeOther`: green
- Use both `ctermfg` and `guifg` so terminal and GUI/truecolor modes have a
  reasonable chance of matching.
- Add a helper such as `s:ModeHighlightGroup()` and render:

```vim
%#OmarchyModeInsert# INSERT %#StatusLine#
```

- Reset back to `StatusLine` immediately after the mode label.
- Add `:OmarchyStatuslineColors` or include statusline color state in
  `:OmarchyHealth` only if debugging is needed.
- If testing shows the groups are frequently overwritten by colorscheme loading,
  add an autocmd on `ColorScheme` to redefine the groups.
- If that still behaves poorly, skip the feature and document the reason in the
  plan/README rather than building a larger theme layer.

### 11. Current-file symbol picker

Recommendation: keep the existing Python symbol picker and consider a small
generic `:Symbols` command if it stays regex-based and honest about limits.

Current behavior:

- `:PythonSymbols` and `<Leader>fs` scan the current buffer for Python `class`,
  `def`, and `async def` lines.
- The picker uses FZF when available and a scratch-buffer fallback otherwise.
- This is already the requested "find symbol and pick to navigate" workflow for
  Python.

Implementation plan:

- Rename or wrap the existing command as:
  - `:Symbols`
  - `<Leader>fs`
- Keep `:PythonSymbols` as a compatibility alias.
- For Python, keep the current class/function detection.
- Add conservative regex detectors for:
  - Vimscript: `function`, `command`, and maybe augroup headings.
  - Lua: `function name`, `local function name`, and `name = function`.
  - Shell: `name() {` and `function name`.
  - JavaScript/TypeScript: `function name`, `class Name`, common method lines,
    and simple `const name = (...) =>` patterns.
  - Markdown: headings as symbols.
- Do not attempt a full parser, Tree-sitter, ctags integration, or LSP document
  symbol integration in this pass. Those are more powerful but add dependency or
  compatibility complexity.
- If a filetype has no detector, show a clear "No symbols for this filetype"
  message rather than noisy false positives.
- README should describe it as a lightweight current-file outline, not semantic
  LSP navigation.

### 12. Project-wide grep

Recommendation: keep existing implementation and improve documentation.

Current behavior:

- `<Leader>fr` calls `s:Ripgrep()`.
- If FZF, fzf.vim `:Rg`, and `rg` are available, it opens the project-wide FZF
  ripgrep picker.
- Otherwise it prompts for a search pattern and uses `rg --vimgrep` when
  available, or recursive `grep` when `rg` is not installed.
- Results open through the existing scratch picker fallback.

Implementation plan:

- Keep `<Leader>fr`.
- Add or document `:Rg` for FZF-backed grep when available.
- Consider adding `:OmarchyGrep` as a stable command name that always uses the
  same fallback logic as `<Leader>fr`.
- README should state clearly that grep scope is Vim's current working directory
  and that `:pwd` / `:cd` control it, unless the implementation later changes to
  use git-root scope.
- Optional future improvement: use git root as grep scope by default, with an
  explicit option. Do not change scope silently unless the README and command
  messages make it obvious.

### 13. LSP and syntax for markdown, bash, BigQuery SQL, Lua, Vimscript, web

Recommendation: split this into "syntax/filetype always" and "tools optional".

Default, no new toolchain:

- Keep `filetype plugin indent on` and `syntax enable`.
- Add filetype detection for common extensions that Vim may not classify well:
  - `*.bash` -> `bash`
  - `*.bq.sql`, `*.bigquery.sql` -> `sql`
  - project-specific SQL names if needed later
- Add comments support for markdown and SQL in `s:CommentPrefix()`.
- Set SQL dialect hints if Vim's SQL syntax supports them without breaking
  normal SQL. BigQuery should be documented as best-effort syntax unless a
  dedicated plugin is accepted later.

Optional tools, no Node/Rust/Go toolchain required:

- Bash:
  - diagnostics through `shellcheck` via ALE if installed.
  - formatter through `shfmt` if installed. `shfmt` is a Go-written binary, but
    the user does not need a Go toolchain if installed from a package manager.
- SQL/BigQuery:
  - diagnostics/format through `sqlfluff` with dialect `bigquery`; Python-based
    install path is acceptable if the user wants it.
- Lua:
  - diagnostics through `luacheck` if installed.
  - LSP through `lua-language-server` only when a package/binary exists; no
    source build should be required by this config.
- Vimscript:
  - syntax is built in.
  - linting through `vint` is possible but should be optional and documented as
    Python-tooling based; do not make it default.
- Markdown:
  - syntax is built in.
  - avoid default markdown LSP because common choices add Rust or Node.

TypeScript, HTML, CSS, JavaScript:

- Add/confirm syntax and filetype behavior.
- Do not enable LSP by default because practical servers generally require Node
  (`typescript-language-server`, `vscode-langservers-extracted`, etc.).
- Add an optional Node profile section in README only if the user accepts Node
  for web languages.

Implementation plan:

- Generalize ALE configuration from Python-only defaults to mergeable per-filetype
  maps without starting tools unless they are installed.
- Add `:OmarchyToolsStatus` or extend `:OmarchyDebug` to show optional tool
  availability by filetype.
- Keep Python behavior unchanged.

### 14. FZF all mappings

Recommendation: add a separate all-maps command.

Current distinction:

- `<Leader>fk` is valuable because it shows this config's explicit `MAP:`
  comments. Keep it.
- `<Leader>fm` delegates to fzf.vim `:Maps` and may not provide a complete,
  fallback-friendly, all-mode map browser.

Implementation plan:

- Add `:OmarchyAllMaps` and `<Leader>fK`.
- Collect output from:
  - `:nmap`
  - `:xmap`
  - `:imap`
  - `:omap`
  - `:cmap`
  - `:tmap` where supported
- Prefer `:verbose map` data if the output remains readable, because source
  locations are useful when debugging conflicts.
- Use FZF when available; otherwise open a scratch buffer.
- Keep `<Leader>fk` for curated config maps.
- Consider remapping `<Leader>fm` to `:OmarchyAllMaps` and documenting fzf.vim
  `:Maps` as an implementation detail only if testing shows it is better.

### 15. Plugin install/update policy

Recommendation: keep current policy and make it more explicit.

Current config already avoids startup installs and updates. It downloads
vim-plug only through `:OmarchyPlugBootstrap`; plugins are installed only by
`:PlugInstall`; updates are only by `:PlugUpdate`.

Implementation plan:

- Add this explicit goal near the top of `init.vim`:
  - Opening Vim must never install, update, clean, upgrade, or download plugins.
  - `:OmarchyPlugBootstrap` may download only vim-plug.
  - `:PlugInstall`, `:PlugUpdate`, `:PlugClean`, and `:PlugUpgrade` are manual.
  - Optional plugins are declared only when their flags are set before sourcing
    `init.vim`.
  - No vim-plug `on` or `for` lazy-loading triggers are used unless documented.
  - No post-update hook should download extra binaries unless explicitly
    documented and manually triggered through vim-plug commands.
- Add `:OmarchyPluginPolicy` or include this in `:OmarchyDebug`.
- README should have a dedicated "Plugin Policy" section.

### 16. Check plugin updates without updating

Recommendation: add a read-only remote update report, but do not rely on
vim-plug for dry-run behavior.

vim-plug provides `:PlugStatus`, `:PlugUpdate`, `:PlugDiff`, and related
commands. `:PlugStatus` checks local plugin status; `:PlugUpdate` updates.
There is no simple documented "dry-run update all plugins and only report
available remote commits" command in the standard workflow.

Implementation plan:

- Add `:OmarchyPlugCheckUpdates`.
- For each declared and installed plugin:
  - read local `HEAD` with `git -C plugin rev-parse HEAD`,
  - read configured upstream URL,
  - use `git ls-remote` to inspect the remote branch or HEAD,
  - compare hashes,
  - show `up-to-date`, `update available`, `not installed`, or `unknown`.
- This command uses network but does not fetch, checkout, merge, or update local
  refs.
- If a plugin is pinned to a commit/tag/branch later, report that clearly.
- README should distinguish:
  - `:PlugStatus`: local status.
  - `:OmarchyPlugCheckUpdates`: remote availability check, no working-tree update.
  - `:PlugUpdate`: actual update.
  - `:PlugDiff`: review after update.

### 17. Holistic keymap review

Recommendation: make a few small consistency fixes, but avoid churn.

Good current conventions:

- `<Leader>f*` for find/search is reasonable.
- `<Leader>l*` for LSP/diagnostic actions is reasonable.
- `<Leader>d*` for diff is reasonable.
- `<Leader>g*` for git is reasonable.
- `<Leader>e*` for explorer is reasonable.
- `<Leader>b*` for buffers is reasonable.
- `<Leader><Leader>` for buffers is common and fast.

Odd or risky current conventions:

- `<Leader>s` as an unmapped prefix is risky because normal `s` edits text.
  Fix with prefix no-op.
- `jl` and `jh` in insert mode are useful but can surprise users who type those
  letters quickly. Keep them because this config already uses `jj`/`jk` escape,
  but document how to disable them if an option is added.
- Normal `0` overriding Vim's native first-column motion is high-surprise for a
  new Vim user. It is useful, but README must keep pointing users to native
  `^`, `g_`, and `$`. Consider adding
  `g:omarchy_override_zero_motion = 1` so users can opt out.
- `<Leader>ww` usually means "next window" in many configs, but here it toggles
  maximize. Prefer `<Leader>wm` as the primary maximize map. Consider changing
  `<Leader>ww` to `wincmd w` only if breaking the existing map is acceptable.
- `<Leader>wj` for horizontal split is not mnemonic unless read as "split below."
  Keep it for compatibility, but emphasize `<Leader>ws` as the clearer alias.
- `<Leader>fm` and `<Leader>fk` are close enough to confuse. Add `<Leader>fK`
  for all keymaps and make the README distinction explicit.

### 18. `smnatale/nvim_native` opportunities

Recommendation: borrow ideas, not code.

Useful and portable:

- Netrw as the file tree: already aligned with this config.
- Quickfix-based grep: already aligned with fallback text search and should be
  emphasized more in README.
- Smart statusline with git/diagnostics/filetype: already aligned.
- Persistent undo and autoread from its options are worth adding here. See the
  detailed explanation in the "Other simple improvements" section below.

Useful but Neovim-only or not aligned:

- `vim.lsp.enable()` requires modern Neovim and does not fit Vim 9.
- Native LSP completion through `vim.lsp.completion.enable()` is Neovim-only.
- `findfunc` plus `matchfuzzy()` is interesting, but current FZF/fallback picker
  code is more consistent across Vim and Neovim. Consider only as a Neovim-only
  optional experiment later.
- Formatting on save is intentionally not the default here. This config favors
  explicit `:ALEFix` to avoid surprising edits.
- `cmdheight=0` and `laststatus=3` are Neovim-specific UI preferences. Do not
  add them to the shared Vimscript config.

### 19. Explicit timeout settings

Recommendation: implement.

Implementation plan:

- Replace direct `set timeoutlen=350` with:

```vim
" Multi-key mapping timeout.
" Fast: 250-300 ms. Medium: 400-500 ms. Slow: 700-1000 ms.
" This affects mappings such as jj, jk, jl, jh, <Leader>fk, and <Leader>ss.
let g:omarchy_timeoutlen = get(g:, 'omarchy_timeoutlen', 350)
execute 'set timeoutlen=' . g:omarchy_timeoutlen

" Terminal key-code timeout. Keep shorter than timeoutlen so Esc and arrow/meta
" keycodes feel responsive.
let g:omarchy_ttimeoutlen = get(g:, 'omarchy_ttimeoutlen', 50)
set ttimeout
execute 'set ttimeoutlen=' . g:omarchy_ttimeoutlen
```

- README should explain the tradeoff:
  - shorter is safer for accidental `jj`/leader timeouts,
  - longer is better for slower multi-key entry,
  - `ttimeoutlen` should usually stay low.

### 20. Other simple improvements

Recommendation: add only low-risk built-ins.

Candidates:

- Persistent undo:

```vim
if has('persistent_undo')
  set undofile
endif
```

  Explanation: `undofile` persists Vim's undo history to disk, so after closing
  and reopening a file you can still undo older edits. This is local editor
  metadata, not a change to the edited file. Vim stores the undo data under its
  configured undo directory; if no usable undo directory exists, support varies
  by build and platform. Implementation should create a config-owned undo
  directory when practical, for example under `~/.vim/undo` for Vim and the
  equivalent data path for Neovim, and should degrade quietly if persistent undo
  is unavailable.

- Autoread external file changes:

```vim
set autoread
augroup omarchy_checktime
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold * silent! checktime
augroup END
```

  Explanation: `autoread` tells Vim to reload a buffer when the file changes on
  disk and the buffer has no unsaved local edits. Vim does not constantly poll
  every file in the background, so `checktime` asks Vim to check whether open
  files changed since they were read. The autocmd calls `checktime` when focus
  returns, when entering buffers, and periodically on `CursorHold`. This is useful
  when git, formatters, generators, or another editor modify files externally.
  If the buffer has unsaved changes, Vim should warn instead of silently
  replacing local edits.

- Add `:OmarchyHealth` as a shorter user-facing status command separate from
  verbose `:OmarchyDebug`.
- Add README cleanup while preserving all details. The current README repeats
  some FZF/plugin install points; the update should reduce drift without losing
  user-critical setup information.

## Implementation Phases

### Phase 1: Safety and timing

- Add `<Leader>s` no-op guard.
- Add visual paste preservation with an opt-out variable.
- Add explicit `g:omarchy_timeoutlen` and `g:omarchy_ttimeoutlen`.
- Add persistent undo and autoread/checktime.
- Update `:Keymaps` data via `MAP:` comments.

### Phase 2: Explorer, terminal, and split workflows

- Make Netrw open/reveal deterministic from any split.
- Add general terminal root helper and terminal toggle.
- Add current-buffer/file/buffer right-vsplit commands and maps.
- Add Netrw `v`/`V` split-open behavior if reliable in both Vim and Neovim.

### Phase 3: Diff and merge workflows

- Add `:DiffFile` / `<Leader>df`.
- Add `:DiffBuffer` / `<Leader>db`.
- Add `:DiffBuffers` / `<Leader>dB` for current plus 1-3 selected buffers.
- Add `:DiffHelp` / `<Leader>dh`.
- Add diff navigation/update/off aliases.
- Verify saved/HEAD diff behavior remains unchanged.

### Phase 4: Finders and keymaps

- Document FZF exact syntax.
- Add exact-mode variants only where the implementation remains small.
- Keep project-wide grep on `<Leader>fr`; add `:OmarchyGrep` only if a stable
  command name improves discoverability.
- Keep current-file symbols on `<Leader>fs`; generalize to `:Symbols` only with
  conservative regex detectors.
- Add `:OmarchyAllMaps` / `<Leader>fK`.
- Decide whether `<Leader>fm` should remain fzf.vim `:Maps` or call the new
  all-maps browser.

### Phase 5: Statusline and low-risk UI polish

- Add optional statusline mode highlight groups.
- Render only the mode label in the mode-specific color, then reset to
  `StatusLine`.
- Add a `ColorScheme` autocmd only if testing shows colors are overwritten.
- Skip this feature if cross-version highlight behavior becomes messy.

### Phase 6: Filetypes, syntax, and optional tools

- Add filetype autocmds for shell and BigQuery SQL filenames.
- Expand comment prefixes.
- Generalize optional ALE linters/fixers for shell, SQL, Lua, and Vimscript
  without making new tools required.
- Add `:OmarchyToolsStatus` or extend `:OmarchyHealth`.
- Keep TypeScript/HTML/CSS/JS syntax-only unless an optional Node profile is
  explicitly enabled.

### Phase 7: Plugin policy and update checking

- Add plugin policy text to config goals.
- Add `:OmarchyPluginPolicy` if useful.
- Add `:OmarchyPlugCheckUpdates` using `git ls-remote`.
- Document network/no-update behavior clearly.

### Phase 8: Full README update

Do a full README pass in the implementation commit. Required sections:

- Feature summary updated for:
  - session prefix guard,
  - visual paste preservation,
  - exact FZF syntax,
  - terminal launcher,
  - deterministic explorer,
  - right-vsplit workflows,
  - buffer/file/multi-buffer diff workflows,
  - merge help,
  - native next/previous diff hunk keys `]c` and `[c`,
  - optional statusline mode colors,
  - current-file symbol picker,
  - project-wide grep,
  - all-maps browser,
  - optional non-Python tooling,
  - plugin policy,
  - plugin update check,
  - timeout tuning,
  - persistent undo, autoread, and checktime.
- "Requirements" updated with optional tools:
  - `shellcheck`
  - `shfmt`
  - `sqlfluff`
  - `luacheck`
  - `lua-language-server`
  - `vint`
  - optional Node tools for web LSP only if accepted
- "Optional Plugins" updated to state no lazy `on`/`for` triggers are used.
- New "Key Timing" section with fast/medium/slow examples.
- New "Visual Paste" section with register explanation and opt-out.
- Expanded "FZF Search Syntax" section.
- Expanded "Project Grep" section covering `<Leader>fr`, `:Rg`, fallback grep,
  and search scope.
- Expanded "Current File Symbols" section covering `:Symbols`,
  `:PythonSymbols`, and regex limitations.
- New "Statusline Colors" subsection explaining the mode color option and
  colorscheme caveat.
- Expanded "File Explorer" section with split behavior and focus behavior.
- New or expanded "Terminal" section with root strategy.
- Expanded "Windows" section with right-vsplit workflows.
- Expanded "Diffs And Merging" section:
  - saved/HEAD diff,
  - diff current against picked file,
  - diff current against picked buffer,
  - 3/4 open-buffer diff,
  - native next/previous hunk keys,
  - native merge keys.
- Expanded "Keymap Lookup" section:
  - `<Leader>fk` curated config maps,
  - `<Leader>fK` all live maps,
  - `:verbose map` for deep debugging.
- New "Plugin Policy" section.
- New "Check For Plugin Updates" section.
- Test matrix updated for every new command and map.
- Troubleshooting updated for:
  - incomplete leader prefixes,
  - visual paste expectations,
  - terminal root selection,
  - explorer placement,
  - FZF exact syntax,
  - diff/merge confusion,
  - optional language tool availability.

## Validation Plan

Automated smoke checks:

```sh
vim -Nu omarchy/vim/init.vim -n -es +'set nomore' +':Keymaps' +qa
vim -Nu omarchy/vim/init.vim -n -es +'set nomore' +':OmarchyFzfStatus' +qa
vim -Nu omarchy/vim/init.vim -n -es +'set nomore' +':OmarchyDebug' +qa
nvim -u omarchy/vim/init.vim --headless +'set nomore' +':Keymaps' +qa
nvim -u omarchy/vim/init.vim --headless +'set nomore' +':OmarchyFzfStatus' +qa
```

Manual checks:

- `<Leader>s` alone and `<Leader>sk` do not edit the buffer.
- `<Leader>ss`, `<Leader>sr`, `<Leader>sl`, `<Leader>sd` still work.
- Visual `p` can paste the same copied text over multiple selections.
- `g:omarchy_visual_paste_preserve_register=0` restores native behavior.
- `g:omarchy_timeoutlen` affects `jj`, `jk`, and leader maps as documented.
- `<Leader>ee` opens/toggles a far-left tree from left, middle, and right splits.
- Netrw `v` and `V` open files in right splits as documented.
- `<Leader>tt` opens/toggles a terminal in the expected directory for git,
  non-git file, and no-file buffers.
- Right-vsplit commands work from current buffer, file picker, and buffer picker.
- `:DiffFile`, `:DiffBuffer`, and `:DiffBuffers` produce correct diff windows.
- `:DiffHelp` shows native merge commands.
- `<Leader>dn`, `<Leader>dN`, `<Leader>du`, and `<Leader>dQ` work in diff mode.
- Statusline mode colors are readable in normal, insert, visual, and command
  modes, or the feature is skipped as too brittle.
- `<Leader>fs` continues to work for Python symbols; `:Symbols` works for only
  the filetypes implemented in the lightweight detector.
- `<Leader>fr` works as project/current-directory grep with FZF and via fallback.
- `<Leader>fK` shows all live mappings with and without FZF.
- FZF exact syntax works by typing `'term`, `^term`, and `term$` in the prompt.
- Optional filetype/tool checks degrade cleanly when tools are missing.
- `:OmarchyPlugCheckUpdates` reports update availability without changing plugin
  working-tree `HEAD`.

## Risks

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Mapping churn makes the config harder to remember | Medium | Keep existing maps; add new maps under existing prefixes; document distinctions clearly. |
| Visual `p` override surprises users who expect native Vim | Medium | Add opt-out variable and README explanation. |
| Netrw behavior differs between Vim and Neovim | Medium | Test both; prefer explicit window creation over relying entirely on `:Lexplore`. |
| Multi-buffer diff UI becomes too complex | Medium | Require files to be opened as buffers first for 3/4-way diff. |
| Optional language tooling creates dependency creep | High | Keep syntax/filetype default; make linters/LSPs conditional and documented as optional. |
| Plugin update checker accidentally mutates plugin repos | High | Use `git ls-remote`, not `git fetch`, checkout, merge, or pull. |
| README grows too large | Medium | Organize by workflow; reduce repeated install/plugin policy text while keeping required detail. |

## Suggested Detailed Commit Message

```text
Improve Vim safety, splits, diffs, terminals, and docs

- guard the <Leader>s session prefix so mistyped session keys do not edit text
- preserve registers on visual paste, with an opt-out setting
- expose explicit mapping timeout settings with documented fast/medium/slow values
- make Netrw explorer placement deterministic from any split
- add project-aware terminal toggle and right-vsplit open workflows
- add file, buffer, and multi-buffer diff helpers with merge guidance
- document native next/previous diff hunk navigation and add simple aliases
- optionally color the statusline mode label by current mode
- generalize the current-file symbol picker where regex-based detection is reliable
- document existing project-wide grep behavior and fallback scope
- add all-mappings lookup alongside the curated config keymap reference
- document FZF exact-search syntax and add exact finder variants where simple
- expand optional syntax/tooling support for shell, SQL, Lua, Vimscript, markdown, and web filetypes
- clarify plugin install/update policy and add a no-update plugin update check
- refresh README with complete user workflows, settings, troubleshooting, and tests
```

## Final Recommendation

Proceed with implementation in the phases above. The highest-value changes are
the `<Leader>s` guard, visual paste preservation, deterministic explorer
placement, right-vsplit opening, and simple picked-buffer/file diffs. The LSP and
language-tooling work should stay conservative and optional so the config does
not drift away from its core "few dependencies, manual plugin actions, Vim and
Neovim compatible" design.

## Implementation Summary

Implemented in this pass:

- `<Leader>s` session-prefix guard.
- Visual paste register preservation with
  `g:omarchy_visual_paste_preserve_register`.
- Explicit `g:omarchy_timeoutlen` and `g:omarchy_ttimeoutlen`.
- Persistent undo, `autoread`, and `checktime`.
- Optional statusline mode colors.
- Deterministic far-left Netrw open/reveal behavior.
- Project-aware `:OmarchyTerminal` and `:OmarchyTerminalToggle`, defaulting to
  `bash --login -i` when Bash is available.
- Right-vsplit open helpers for current buffer, picked file, and picked buffer.
- `:OmarchyGrep` alias for the existing project-wide grep behavior.
- Preserved `:PythonSymbols`; added `:Symbols` for simple current-file symbol
  picking in supported filetypes.
- `:OmarchyAllMaps` for all live mappings.
- `:OmarchyPluginPolicy` and read-only `:OmarchyPlugCheckUpdates`.
- File/buffer/multi-buffer diff helpers and diff help/navigation aliases.
- Optional ALE wiring for already-installed shell, SQL, Lua, and Vimscript tools.
- README update covering all implemented features, settings, workflows, tests,
  troubleshooting, dependencies, and plugin policy.

Not implemented deliberately:

- No Tree-sitter, ctags, or LSP document-symbol abstraction.
- No required Node/Rust/Go dependency for web-language LSP.
- No custom merge UI beyond help and aliases for native Vim diff commands.
- No additional comment slash mappings were needed because `<Leader>/` and
  `<Leader>//` already existed and had no config conflicts.
