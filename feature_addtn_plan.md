# Feature Addition Plan

This plan covers the requested Vim feature additions for `omarchy/vim/init.vim`
and the matching `omarchy/vim/README.md` documentation update. Do not add any
plugins and keep the Vim configuration as a single file.

## Current Context

- `init.vim` is the canonical single-file config.
- `<Leader>` is Space.
- `<Space><Space>` currently calls `s:RunCommand('Buffers')`, but `s:RunCommand()`
  blocks `:Buffers` when FZF is unavailable. This needs a real built-in fallback.
- Search highlighting already has `<Leader>nh` mapped to `:set hlsearch!`, but it
  is undocumented as a named feature and does not echo state.
- Diff helpers already exist:
  - `:DiffSaved` / `<Leader>ds`
  - `:DiffGitHead` / `<Leader>dg`
  - `:DiffClose` / `<Leader>dq`
  - Fugitive `:Gdiffsplit` / `<Leader>gd` when `g:omarchy_use_fugitive = 1`
- The current custom diff layout appears to place the current buffer on the left
  and the saved/HEAD scratch buffer on the right. For side-by-side diffs, old/base
  on the left and current/new on the right is common and matches the requested
  preference, so change the custom Omarchy diff layout accordingly.
- Existing window maps include `<Leader>wh`, `<Leader>wj`, `<Leader>wc`,
  `<Leader>wo`, and Alt-arrow resize maps. Avoid depending on `<C-w>` because
  browser-hosted terminals such as GCP JupyterLab can intercept it.
- `zarchive/vimrc_helpers/.vimrc_helpers` contains useful older snippets, but do
  not import them wholesale because some keys conflict with current maps and some
  implementations can be made simpler or safer.

## Implementation Plan

### 1. Add bracket and quote jump helpers

Add small script-local functions in the "Editing helpers" section.

Planned behavior:

- Normal `jl`: jump to just past the next closing delimiter on or after the next
  cursor position, without matching to an opener.
- Insert `jl`: do the same and remain in insert mode.
- Normal `jh`: jump to just past the nearest left/open delimiter before the
  cursor.
- Insert `jh`: do the same and remain in insert mode.
- Closing delimiters should include `)`, `]`, `}`, `>`, `"`, `'`, and backtick.
- Left/open delimiters should include `(`, `[`, `{`, `<`, `"`, `'`, and backtick.
- Searches should not wrap around the file.
- If no delimiter is found, leave the cursor where it is and echo a short message.
- In normal mode, "past" means the character after the delimiter when possible.
  Vim cannot normally place the cursor beyond the physical end of line without
  changing `virtualedit`, so if the delimiter is the final character, leave the
  cursor on that final delimiter.
- In insert mode, use a command path that returns to insert mode at the target
  insertion point, so this works naturally with auto-pair typing.

Implementation notes:

- Use `searchpos()` with explicit delimiter patterns instead of `%`.
- Use `winsaveview()` / `winrestview()` or saved cursor variables only as needed
  to avoid accidental viewport jumps.
- Avoid changing global options such as `virtualedit`.
- Add `MAP:` comments so `:Keymaps` and `<Leader>fk` include these mappings.

### 2. Add line-number cycling

Add a script-local line-number toggle based on the archived `linenumbers.vim`,
but use current config naming and messages.

Planned behavior:

- Cycle through:
  - absolute + relative numbers
  - absolute numbers only
  - no numbers
  - back to absolute + relative numbers
- Keep the default startup state as `set number relativenumber`.
- Map `<Leader>nn` to the toggle.
- Optionally map `<F8>` too if there is no conflict, because the archived helper
  used it and it is easy to test manually.
- Do not use `<Leader>n` alone because `<Leader>nh` already exists for search
  highlighting and a shorter prefix map would introduce avoidable timeout
  behavior.

### 3. Improve search-highlight toggling

Keep the existing `<Leader>nh` key, but replace the raw option toggle with a
small function and command.

Planned behavior:

- `:OmarchyToggleHighlight` toggles `hlsearch`.
- `<Leader>nh` calls the command.
- Echo whether search highlighting is now on or off.
- Keep `<C-L>` and `<Leader>rr` as redraw/refresh mappings.

### 4. Add no-plugin window maximize toggle

Implement a minimal built-in maximizer rather than using `vim-maximizer`.

Planned behavior:

- `:OmarchyWindowMaximizeToggle` stores `winrestcmd()` in a tab-local variable,
  then maximizes the current window with `resize` and `vertical resize`.
- Calling it again restores the saved tab layout.
- If the layout changed enough that restore fails imperfectly, the command should
  still leave Vim usable and clear its stored state.
- Map `<Leader>wm` to the toggle.
- Also map `<Leader>ww` to the same maximize toggle if it does not conflict.
- Do not add an insert-mode mapping; maximizing is a window command, not text
  input.

### 5. Add a real `<Leader><Leader>` buffer picker fallback

Replace the current `<Space><Space>` mapping with an Omarchy buffer picker
function.

Planned behavior:

- If FZF is enabled and usable, keep using fzf/fzf.vim's `:Buffers`.
- If FZF is unavailable, open an unfiltered scratch picker using existing
  `s:OpenPickerScratch()` infrastructure.
- The fallback list should include listed buffers only and show enough detail to
  select confidently:
  - buffer number
  - current-buffer marker
  - modified marker
  - file name or `[No Name]`
- Pressing `<CR>` on a fallback item switches to that buffer and closes the
  picker.
- Pressing `q` closes the picker, matching other fallback scratch views.
- Add a command such as `:OmarchyBuffers` for testability and documentation.
- Keep `<Space><Space>` as the primary map because `<Leader>` is Space, so it is
  already the requested `<Leader><Leader>`.

### 6. Add normal-mode `0` line-position cycling

Add a robust version of the archived `togglezero.vim` behavior.

Planned behavior:

- Normal `0` cycles through:
  - first column of line
  - first non-space column of line
  - last non-space column of line
  - last column of line
  - back to first column
- Blank and all-whitespace lines should behave predictably, cycling between the
  first and last available columns without errors.
- Do not map insert-mode `0`, because that would break typing literal zeroes.
- Add `MAP:` comments and README documentation so users know this intentionally
  overrides Vim's default normal-mode `0` motion.

### 7. Add browser-safe window mappings

Yes, leader-based window mappings are feasible and are the right direction for
browser-hosted terminals where `<C-w>` may close the browser tab/window.

Planned approach:

- Keep existing lowercase `<Leader>w*` maps where possible to avoid breaking
  current users:
  - `<Leader>wh`: vertical split
  - `<Leader>wj`: horizontal split
  - `<Leader>wc`: close window
  - `<Leader>wo`: only current window
- Add non-conflicting browser-safe focus maps:
  - `<Leader>w<Left>`: move focus left
  - `<Leader>w<Down>`: move focus down
  - `<Leader>w<Up>`: move focus up
  - `<Leader>w<Right>`: move focus right
- Add optional mnemonic aliases if they do not conflict after reviewing final
  keymap table:
  - `<Leader>ww`: next window
  - `<Leader>wp`: close preview window
  - `<Leader>wv`: vertical split alias
  - `<Leader>ws`: horizontal split alias
- Keep the existing Alt-arrow resize maps.
- Add a code comment in the window-mapping area: `Do not add broad <C-h/j/k/l>
  remaps from config_endstuff.vim; they are terminal-sensitive and would conflict
  with the existing <C-L> refresh map.`

### 8. Add folding support

Use built-in Vim folding only. Do not add an LSP folding implementation unless
ALE exposes a simple, stable command that works in both Vim and Neovim.

Planned behavior:

- Set conservative defaults:
  - `set foldenable`
  - `set foldlevelstart=99`
  - `set foldnestmax=10`
- Use filetype-local folding where it is known to be useful:
  - Python: `foldmethod=indent`
  - Vimscript: likely `foldmethod=marker` or `syntax` only if it behaves well
    with this file after manual testing
- Add:
  - `:OmarchyToggleAllFolds`
  - `:OmarchyFoldLevel {0-9}`
  - `<Leader>zz`: open all folds if any fold is closed, otherwise close all folds
  - `<Leader>z0` through `<Leader>z9`: set `foldlevel`
- Preserve native Vim folding keys like `za`, `zR`, and `zM`.
- Document that pylsp/pyright may provide folding ranges at the protocol level,
  but this config intentionally avoids a custom ALE/LSP folding bridge because
  the simple built-in indent folds are easier to maintain and work without
  plugins.

### 9. Add `shortmess-=S` near the end

Add an end-of-config finalization section if one does not already exist.

Planned behavior:

- Use `silent! set shortmess-=S` near the end of `init.vim` so Vim/Neovim show
  the current search match position when supported.
- Keep `set shortmess+=c` near the normal option setup because it controls
  completion messages.
- Do not wholesale apply the archived final remaps. Only put maps here if testing
  shows an earlier plugin or autocmd overrides one of the requested maps.

### 10. Improve custom diff orientation and document diff behavior

Keep the current no-plugin custom diff helpers, but adjust orientation.

Planned behavior:

- For `:DiffSaved` and `:DiffGitHead`, put saved/HEAD/base content on the left
  and the current buffer on the right.
- Keep current/new content on the right because that is common in side-by-side
  diff tools and matches the requested preference.
- Preserve `q` and `<Leader>dq` to close Omarchy diff sessions.
- Keep Fugitive's `:Gdiffsplit` mapping unchanged unless testing shows a trivial
  Fugitive-native way to request the same orientation without surprising
  long-time Fugitive users.
- Update docs to distinguish:
  - Omarchy built-in diffs: no plugin, saved/HEAD versus current buffer.
  - Fugitive diff: optional plugin behavior owned by Fugitive.

### 11. Update README fully

Update `omarchy/vim/README.md` in the same implementation commit.

Required README changes:

- Update the feature summary near the top to mention folding, UI toggles,
  browser-safe window maps, delimiter jumps, and the no-FZF buffer picker.
- Clarify FZF fallback behavior:
  - `<Leader><Leader>` / `<Space><Space>` always opens a buffer picker.
  - With FZF, it uses the FZF buffer picker.
  - Without FZF, it uses the built-in scratch-buffer picker.
- Update the main key table with:
  - `jl` normal/insert delimiter jump right
  - `jh` normal/insert delimiter jump left/inside
  - `<Leader>nn` line-number cycle
  - `<Leader>nh` search-highlight toggle
  - `<Leader>wm` window maximize toggle
  - browser-safe window focus maps
  - `0` normal-mode line-position cycle
  - fold maps and commands
- Add a short "Editing Navigation Helpers" section for delimiter jumps and `0`.
- Add or expand a "Display Toggles" section for line numbers, search highlight,
  and search match position.
- Add or expand a "Windows" section for maximize and browser-safe leader maps.
- Add a "Folding" section describing built-in folding behavior and commands.
- Expand "Git And Blame" or add a "Diffs" subsection describing built-in diff
  orientation and Fugitive behavior.
- Update the manual test matrix:
  - verify `jl` and `jh` in normal and insert mode
  - verify `<Leader><Leader>` with and without FZF
  - verify `<Leader>nn`, `<Leader>nh`, `<Leader>wm`, and normal `0`
  - verify fold commands/maps on a Python file
  - verify `:DiffSaved` and `:DiffGitHead` show old/base left and current/new
    right
  - verify `set shortmess-=S` shows search match position where supported
- Update troubleshooting for terminal/browser key handling and note that
  leader-based window maps avoid `<C-w>`.

### 12. Validate after implementation

Run lightweight syntax/startup checks after editing.

Suggested checks:

```sh
vim -Nu omarchy/vim/init.vim -n -es +'set nomore' +':Keymaps' +qa
vim -Nu omarchy/vim/init.vim -n -es +'set nomore' +':OmarchyFzfStatus' +qa
nvim -u omarchy/vim/init.vim --headless +'set nomore' +':OmarchyFzfStatus' +qa
```

Also run manual checks inside Vim for interactive mappings that Ex mode cannot
verify cleanly:

- Insert-mode `jl` and `jh` around `()`, `[]`, `{}`, quotes, and backticks.
- Normal-mode `jl` and `jh` around the same delimiters.
- `<Leader><Leader>` buffer picker fallback with FZF disabled.
- Normal-mode `0` cycle on indented, unindented, trailing-space, blank, and
  all-whitespace lines.
- `<Leader>wm` maximize/restore across a three-window tab.
- Fold maps on a Python file.
- Diff orientation for `:DiffSaved` and `:DiffGitHead`.

### 13. Suggest a detailed commit message

After implementation and validation, suggest a detailed commit message before
committing. Draft:

```text
Add Vim navigation, window, fold, and fallback picker helpers

- add no-plugin delimiter jump mappings for jl/jh in normal and insert modes
- add line-number, search-highlight, maximize-window, and 0-position toggles
- add a built-in <Leader><Leader> buffer picker when fzf is unavailable
- add browser-safe leader window focus mappings for terminals that intercept <C-w>
- add built-in fold commands and mappings without adding LSP/plugin complexity
- show search match position with shortmess-=S where supported
- orient built-in saved/HEAD diffs with old content left and current buffer right
- document the new keys, commands, fallback behavior, diff behavior, and tests
```
