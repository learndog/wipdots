# Omarchy Vim Configuration Strategy

- Status: Draft v0.4, web-verified on 2026-08-05
- Scope: `omarchy/vim/init.vim` plus `omarchy/vim/README.md`
- Primary target: Vim 9 on Debian 12
- Secondary targets: Vim/Neovim on Arch, and Neovim where the same Vimscript file loads cleanly
- Hard constraint: no Node.js, Rust, or Go toolchains required

This strategy is intentionally small. It should be enough to implement the real config and README without adding separate high-level design and implementation documents.

## 1. Goal

Build one readable Vimscript config that provides:

- ALE diagnostics, Python LSP navigation, completion, and format-on-demand.
- fzf file, git-file, text, buffer, line, keymap, and symbol pickers.
- `Space` as leader; `<Space><Space>` opens buffers.
- A simple status line with file, position, time, ALE counts, and git branch.
- Practical editing helpers: comments, line movement, basic pairs, diff helpers, and window mappings.
- A README that makes a fresh Debian 12 install reproducible.

## 2. Web Verification Summary

Checked current upstream docs before revising this plan:

- ALE still documents Vim 8 job/channel/timer requirements, `g:ale_completion_enabled`, `:ALEGoToDefinition`, `:ALEFindReferences`, `:ALEHover`, `:ALERename`, `:ALECodeAction`, and `:ALEFix`.
- Current ALE docs do not document `:ALEOutline` or call-hierarchy commands. Do not plan around them.
- ALE has a built-in Python `pylsp` linter/server integration. Keep `pylsp` as the only default Python LSP.
- Current `fzf.vim` requires fzf `0.54.0+`. Debian 12 packages fzf `0.38.0`, so Debian's `apt install fzf` is not a safe fallback for current `fzf.vim`.
- `fzf#install()` is still the recommended vim-plug hook and installs/updates the fzf binary without requiring a Go toolchain.
- Debian 12 package corrections:
  - Vim: `vim` 9.0.x.
  - Neovim: `neovim` 0.7.2, not 0.8+.
  - Python LSP: package is `python3-pylsp`, not `python3-lsp-server`.
  - bat executable is renamed to `batcat`.

Sources:

- [ALE docs](https://raw.githubusercontent.com/dense-analysis/ale/master/doc/ale.txt)
- [ALE pylsp integration](https://raw.githubusercontent.com/dense-analysis/ale/master/ale_linters/python/pylsp.vim)
- [fzf.vim README](https://raw.githubusercontent.com/junegunn/fzf.vim/master/README.md)
- [fzf Vim integration](https://raw.githubusercontent.com/junegunn/fzf/master/README-VIM.md)
- [fzf README](https://raw.githubusercontent.com/junegunn/fzf/master/README.md)
- [Debian Vim](https://packages.debian.org/bookworm/vim)
- [Debian Neovim](https://packages.debian.org/bookworm/neovim)
- [Debian fzf](https://packages.debian.org/bookworm/fzf)
- [Debian python3-pylsp](https://packages.debian.org/bookworm/python3-pylsp)
- [Debian bat](https://packages.debian.org/bookworm/bat)
- [Arch python-lsp-server](https://archlinux.org/packages/extra/any/python-lsp-server/)
- [Arch python-black](https://archlinux.org/packages/extra/any/python-black/)
- [Arch python-isort](https://archlinux.org/packages/extra/any/python-isort/)
- [Arch python-flake8](https://archlinux.org/packages/extra/any/python-flake8/)
- [Arch python-pylint](https://archlinux.org/packages/extra/any/python-pylint/)
- [vim-fugitive docs](https://raw.githubusercontent.com/tpope/vim-fugitive/master/doc/fugitive.txt)
- [vim-gitgutter README](https://raw.githubusercontent.com/airblade/vim-gitgutter/master/README.mkd)

## 3. Required Plugins

Keep the baseline to four plugins:

| Plugin | Use | Notes |
| --- | --- | --- |
| `junegunn/vim-plug` | plugin manager | single bootstrap script |
| `dense-analysis/ale` | diagnostics, Python LSP, completion, fixers | Vimscript; no Node |
| `junegunn/fzf` | fzf Vim wrapper and binary install | use `{ 'do': { -> fzf#install() } }` |
| `junegunn/fzf.vim` | `:Files`, `:GFiles`, `:Rg`, `:BLines`, `:Buffers`, `:Maps` | requires fzf `0.54.0+` |

Optional, off by default:

| Plugin | Flag | Use | Constraints |
| --- | --- | --- | --- |
| `airblade/vim-gitgutter` | `g:omarchy_use_gitgutter = 1` | git added/changed/removed signs | set `g:gitgutter_map_keys = 0` and define only our maps |
| `tpope/vim-fugitive` | `g:omarchy_use_fugitive = 1` | richer Git commands/status | use current commands: `:Git`, `:Git blame`, `:Gdiffsplit`; avoid deprecated `:Gstatus`, `:Gblame`, `:Gdiff` |

Do not add coc.nvim, vim-which-key, treesitter, CtrlP, airline/lightline, or a commenting/autopair plugin for the first version.

## 4. Runtime And Packages

Minimum runtime:

- Vim: 8.2+ with `+job`, `+channel`, and `+timers`; Debian 12 `vim` is the main target.
- Neovim: best effort on Debian 12 `0.7.2`; better on Arch/current Neovim. Do not rely on Neovim-only APIs.

Debian 12 package path:

```sh
sudo apt update
sudo apt install vim git curl python3-pylsp black isort flake8 pylint ripgrep bat
```

Notes:

- Do not list `fzf` as a Debian requirement for the Vim plugin path because Debian 12's fzf is too old for current `fzf.vim`. Let `fzf#install()` install a current binary during `:PlugInstall`.
- `ripgrep` and `bat` are binary packages, not toolchains. This keeps the "no Rust/Go toolchain" requirement intact.
- On Debian, preview should find `batcat`; current `fzf.vim` preview script checks both `batcat` and `bat`.
- Arch package path can use `sudo pacman -S vim neovim fzf ripgrep bat python-lsp-server python-black python-isort python-flake8 python-pylint`.

## 5. Config Shape

Target `init.vim` size: 500-700 lines. Absolute ceiling: 900 lines.

Recommended sections:

1. Header, compatibility guards, flags.
2. vim-plug bootstrap and plugin list.
3. Core settings: encoding, numbers, search, tabs, split behavior, mouse, clipboard, signcolumn.
4. Leader and buffer mappings.
5. fzf configuration and finder mappings.
6. ALE configuration and mappings.
7. Python symbol picker.
8. Status line.
9. Keymap reference.
10. Editing helpers.
11. Diff/window helpers.

Use one mapping comment convention:

```vim
" MAP: <Leader>ff | Find files
nnoremap <silent> <Leader>ff :Files<CR>
```

`README.md` should include install, upgrade, removal, flags, troubleshooting, and the smoke-test checklist. Do not duplicate the full strategy in the README.

## 6. Feature Decisions

### ALE

- Enable ALE completion before ALE loads:

```vim
let g:ale_completion_enabled = 1
let g:ale_completion_delay = 100
```

- Use `pylsp` as the default Python LSP:

```vim
let g:ale_linters = {'python': ['pylsp', 'flake8', 'pylint']}
let g:ale_fixers = {'python': ['isort', 'black']}
let g:ale_fix_on_save = 0
```

- Do not include `jedi-language-server` in v1. ALE's current tree does not expose it as a built-in Python linter in the same direct way as `pylsp`. It can be added later only if a small custom ALE linter definition is tested.
- Keep LSP maps leader-prefixed to avoid clobbering Vim's native `g*` motions:

| Key | Command |
| --- | --- |
| `<Leader>ld` | `:ALEGoToDefinition` |
| `<Leader>lr` | `:ALEFindReferences -contents` |
| `<Leader>lh` | `:ALEHover` |
| `<Leader>ln` | `:ALERename` |
| `<Leader>la` | `:ALECodeAction` |
| `<Leader>aj` / `<Leader>ak` | `:ALENextWrap` / `:ALEPreviousWrap` |
| `<Leader>af` | `:ALEFix` |
| `<Leader>ai` | `:ALEInfo` |

### fzf

- Use `fzf#install()` in vim-plug. Current `fzf.vim` requires fzf `0.54.0+`; Debian 12's packaged `fzf` is not enough.
- Use `fzf#vim#with_preview()` instead of hand-rolled preview strings where practical.
- Primary maps:

| Key | Command |
| --- | --- |
| `<Space><Space>` | `:Buffers` |
| `<Leader>ff` | files |
| `<Leader>fg` | git files |
| `<Leader>fr` | ripgrep text search |
| `<Leader>fl` | current-buffer lines |
| `<Leader>fm` | fzf.vim `:Maps` or custom live maps |
| `<Leader>fk` | config-defined keymap reference |

If `rg` is missing, `<Leader>fr` should show a clear message or use a simple grep fallback. Do not silently fail.

### Symbols

Replace the old `:ALEOutline` plan.

Implement a small `:PythonSymbols` command that scans the current buffer for:

- `class Name`
- `def name`
- `async def name`

Show results through fzf when available, otherwise a scratch list. Selecting an item jumps to the line. This is simpler, deterministic, and does not depend on undocumented ALE outline APIs.

Optional later: add `:ALESymbolSearch` for workspace symbols if it proves useful. Do not call it an outline.

### References

Use `:ALEFindReferences -contents` as the default. ALE documents `-contents`, `-quickfix`, `-loclist`, and `-fzf`; keep `-contents` as the reliable baseline and consider `-fzf` only after smoke testing with current fzf.

Do not include call hierarchy in v1. It is not documented in current ALE help and is not needed for the requested baseline.

### Status Line

Use Vim's built-in `statusline`.

Include:

- mode
- file path
- modified/readonly flags
- line/column/percent
- filetype, encoding, fileformat, tab width
- time
- ALE error/warning counts, guarded by `exists('*ale#statusline#Count')`
- git branch, cached from a small original helper that calls `git branch --show-current` or `git rev-parse --abbrev-ref HEAD`

Avoid large borrowed statusline blobs. If any borrowed code remains, include attribution and license notes in `init.vim` and README.

### Git

- Baseline: git branch in statusline using a tiny original helper.
- Git change signs: optional `vim-gitgutter`, off by default.
- Fugitive: optional, off by default. If enabled, document current commands and avoid deprecated aliases.

### Editing Helpers

Keep only helpers that are easy to test:

- `jj` and `jk` leave insert mode.
- `<Leader>/` toggles comments for line/visual selection.
- `<Leader>//` force-comments line/visual selection.
- Alt-j/k moves line or visual selection, with terminal caveat in README.
- Visual `<` and `>` keep the selection with `gv`.
- Basic insert-mode pairs for `()`, `[]`, `{}` only. Skip quote autopairs in v1; quote handling caused bugs in prior attempts.
- Diff helpers: `:DiffSaved` and `:DiffGitHead`, guarded by file/readability/git checks.

## 7. Test Matrix

Required smoke tests:

1. `vim -Nu omarchy/vim/init.vim` loads with no errors in `:messages`.
2. `nvim -u omarchy/vim/init.vim` loads, if Neovim is installed.
3. `:PlugInstall` completes without Node/Rust/Go toolchains.
4. `:Files`, `:GFiles`, `:Buffers`, `:BLines`, and `:Rg` work; previews use `batcat` or degrade cleanly.
5. `<Space><Space>` opens buffers.
6. Python file: ALE starts `pylsp`; `:ALEInfo` shows the expected linters; diagnostics appear.
7. Python file: `<Leader>ld`, `<Leader>lr`, `<Leader>lh`, `<Leader>ln`, `<Leader>la`, and `<Leader>af` do not error.
8. `:PythonSymbols` lists classes/functions and jumps correctly.
9. Statusline renders with ALE absent, git absent, fugitive off, and gitgutter off.
10. Comment toggle, line move, visual indent, and diff helpers pass manual tests.
11. Optional flags work independently: fugitive on/off and gitgutter on/off.
12. `:Keymaps` or `<Leader>fk` reflects mappings from the current config, not a static cheat sheet.

## 8. Risks

| Risk | Likelihood | Impact | Mitigation |
| --- | --- | --- | --- |
| Debian 12 fzf is too old for current `fzf.vim` | High | Medium | Make `fzf#install()` the supported path; document manual current fzf binary for offline installs |
| ALE outline/call-hierarchy assumptions were stale | Confirmed | Medium | Remove them; use custom Python symbol picker and `ALEFindReferences` |
| Python LSP depends on project environment quality | Medium | Medium | Default to `python3-pylsp`; document `:ALEInfo`; keep `flake8`/`pylint` diagnostics separate |
| ALE completion is less polished than coc.nvim | Medium | Low | Use ALE completion plus `<C-x><C-o>`/`:ALEComplete`; document expectation |
| Terminal keys vary (`<C-Space>`, Alt keys) | High | Low | Provide fallbacks and `:verbose map` troubleshooting |
| Optional plugins increase moving parts | Low-Medium | Low | Keep off by default and guard every reference |
| Statusline can throw during redraw | Medium | Low | Guard plugin functions and cache git branch |
| Config bloat returns | Medium | High | Enforce 500-700 line target and no separate plugin for small helpers |
| Supply chain: plugins downloaded from GitHub | Low | High | Use only official mainstream repos; README documents update/audit commands |
| Windows host differs from Linux target | Medium | Low | Test in Debian/Arch or WSL; keep Unix install docs primary |

Overall readiness: medium-high. The plan is sound after the corrections above, but it should not be treated as final until the first `init.vim` smoke test runs against real Vim/ALE/fzf installs.

## 9. Success Criteria

Ready means:

- Fresh Debian 12 VM can follow README and load Vim without errors.
- No Node/Rust/Go toolchains are installed or required.
- fzf commands work with current fzf installed by `fzf#install()`.
- ALE diagnostics, Python LSP navigation, references, hover, rename, code actions, and format-on-demand work on a simple Python project.
- `:PythonSymbols` and keymap help work without static drift.
- Optional fugitive and gitgutter can be enabled independently.
- `init.vim` stays under 900 lines and is readable in one sitting.

## 10. Next Step

Do not create `design.md` or `implementation.md` now. For a single-file Vim config, that is overkill.

Best path:

1. Implement `init.vim` directly from this strategy.
2. Write `README.md` alongside it.
3. Run the test matrix.
4. Only add a short `implementation_notes.md` if real testing uncovers decisions that do not belong in the README.
