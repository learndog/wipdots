# Omarchy Vim

Single-file Vim configuration for Vim 9 on Debian 12, with Neovim, Arch, and
Git Bash support.

The config uses Vimscript, vim-plug, ALE, and optional fzf/fzf.vim. Node.js is
needed only for the optional Pyright or GitHub Copilot profiles. Rust and Go
toolchains are not required. Python is needed only for Python language-server,
linting, and formatting features; the editor and native completion fallback
still work without it.

## Files

- `init.vim`: canonical config.
- `python-complete.txt`: native Python keyword/builtin completion dictionary.
- `pylsp-msys.py`: Git Bash/MSYS URI adapter for native Windows pylsp.
- `use_this_wrapper_for_nvim_init_vim/*.vim`: wrapper presets for both Vim
  and Neovim. Copy one to `~/.vimrc` or `~/.config/nvim/init.vim`.
- `vim_strategy.md`: historical strategy and risk notes; this README is the
  current setup reference.
- `README.md`: install and test instructions.

## Requirements

Minimum to load and edit with the config:

- Vim 8.2+ with `+job`, `+channel`, and `+timers`, or Neovim.
- `curl`, only when running the explicit `:OmarchyPlugBootstrap` command.
- `git`, for vim-plug plugin installs, git file search, git branch display, and git diff helpers.
- Network access to GitHub for first plugin install unless you preinstall vim-plug and plugin repos manually.

Recommended tools:

- `ripgrep` (`rg`): powers `:Rg` and `<Leader>fr`.
- `bat`/`batcat`: syntax-highlighted fzf previews.
- `bash`: fzf.vim preview support. Debian and Arch normally have it.
- `fzf` `0.38.0+`: enables fzf/fzf.vim integration when found on `PATH`.

Python tooling:

- `python3`/`python`: runtime for Python tooling.
- `pylsp`: default no-Node language server, provided by
  `python-lsp-server`/`python3-pylsp`.
- `ruff`: default fast linter and fixer/formatter.
- `pyright-langserver`: optional stronger type-aware language server; requires
  Node.js.
- `flake8` and `pylint`: optional alternative or additional linters.
- `black` and `isort`: supported through a custom `g:ale_fixers` override, but
  are not selected by the current defaults.

Without Python installed, this config should still load and the editor,
statusline, native completion, keymap reference, comments, diffs, sessions, and
window/buffer helpers should still work. Python LSP, LSP-backed completion,
linting, and fixing will be unavailable. FZF commands require a suitable fzf
executable and otherwise use fallback pickers.

Session save/restore uses only built-in Vim functionality (`:mksession` and `:source`) and requires no additional tools.

## Version Tables

Versions below are package versions checked from official package pages. Debian
12 is stable, while Arch is rolling; use the check commands below to see what
your machine actually has. The minimum column is the minimum for this config's
documented functionality. Where no strict minimum is listed, the config only
needs the command-line behavior described in the final column.

### Debian 12 Bookworm

| Package | Checked package version | Minimum for this config | Required for / gained functionality |
| --- | --- | --- | --- |
| `vim` | `2:9.0.1378-2+deb12u2` | Vim 8.2+ with `+job`, `+channel`, and `+timers`; Copilot needs Vim 9.0.0185+ | Primary Vim runtime. Required unless you use Neovim only. Enables the whole config, ALE async jobs, terminal/editor workflows, and Copilot inline suggestions when the Copilot flag is enabled. |
| `neovim` | `0.7.2-7` | Neovim 0.6+ for Copilot | Optional Neovim runtime. Enables using this same Vimscript config as `~/.config/nvim/init.vim`. |
| `git` | `1:2.39.5-0+deb12u3` | No config-pinned minimum; needs standard `git` CLI behavior | Required for vim-plug plugin clones, git file search, git branch display, diff helpers, gitgutter signs, and fugitive commands. |
| `curl` | `7.88.1-10+deb12u15` | No config-pinned minimum; must support HTTPS downloads | Required only for `:OmarchyPlugBootstrap` to download vim-plug. |
| `nodejs` | `18.20.4+dfsg-1~deb12u2` | Node.js 18+ | Required for the optional Pyright and `github/copilot.vim` profiles. |
| `npm` | `9.2.0~ds1-1` | Bundled/package version is fine with Node.js 18+ | Recommended with Node.js for Copilot tooling compatibility and any Node package-manager workflows. |
| `python3` | `3.11.2-1 and others` | No config-pinned minimum | Runtime for Python tools. Not needed to start Vim or use native Python keyword completion. |
| `python3-pylsp` | `1.7.1-1` | No config-pinned minimum | Enables Python LSP features through ALE. |
| `python3-rope` | Distribution version | No config-pinned minimum | Improves pylsp rename and refactoring support. |
| `ruff` | Not packaged in Debian 12 stable | No config-pinned minimum | Default fast Python linter and fixer/formatter; install with pipx or a project virtualenv. |
| `flake8` | `5.0.4-4` | No config-pinned minimum | Optional traditional Python lint diagnostics through ALE. |
| `pylint` | `2.16.2-2` | No config-pinned minimum | Optional deeper Python diagnostics; generally slower and noisier than Ruff. |
| `black` | `23.1.0-1` | No config-pinned minimum | Optional formatter when selected with a custom `g:ale_fixers`. |
| `isort` | `5.6.4-1` | No config-pinned minimum | Optional import sorter when selected with a custom `g:ale_fixers`. |
| `ripgrep` | `13.0.0-4` | No config-pinned minimum | Enables fast project text search for `:Rg` and `<Leader>fr`. |
| `bat` | `0.22.1-4` | No config-pinned minimum | Enables highlighted FZF previews; Debian's executable is `batcat`. |
| `fzf` | `0.38.0-1` | `0.38.0+` | Enables interactive FZF pickers; fallback scratch-buffer pickers are used when unavailable. |

The configured minimum is fzf `0.38.0`. A newer external release is preferable
when practical, but Debian 12's package is accepted. The config does not run
the fzf repository's `./install --bin` hook or treat a plugin-managed binary as
an external fzf installation.

### Arch Linux

| Package | Checked package version | Minimum for this config | Required for / gained functionality |
| --- | --- | --- | --- |
| `vim` | `9.2.0849-1` | Vim 8.2+ with `+job`, `+channel`, and `+timers`; Copilot needs Vim 9.0.0185+ | Primary Vim runtime. Required unless you use Neovim only. Enables the whole config, ALE async jobs, terminal/editor workflows, and Copilot inline suggestions when the Copilot flag is enabled. |
| `neovim` | `0.12.4-1` | Neovim 0.6+ for Copilot | Optional Neovim runtime. Enables using this same Vimscript config as `~/.config/nvim/init.vim`. |
| `git` | `2.55.0-1` | No config-pinned minimum; needs standard `git` CLI behavior | Required for vim-plug plugin clones, git file search, git branch display, diff helpers, gitgutter signs, and fugitive commands. |
| `curl` | `8.21.0-1` | No config-pinned minimum; must support HTTPS downloads | Required only for `:OmarchyPlugBootstrap` to download vim-plug. |
| `nodejs` | `26.5.0-1` | Node.js 18+ | Required for the optional Pyright and `github/copilot.vim` profiles. |
| `npm` | `12.0.1-1` | Bundled/package version is fine with Node.js 18+ | Recommended with Node.js for Copilot tooling compatibility and any Node package-manager workflows. |
| `python` | `3.14.6-1` | No config-pinned minimum | Runtime for Python tools. Not needed to start Vim or use native Python keyword completion. |
| `python-lsp-server` | `1.15.0-1` | No config-pinned minimum | Enables Python LSP features through ALE. |
| `python-rope` | Rolling package | No config-pinned minimum | Improves pylsp rename and refactoring support. |
| `ruff` | Rolling package | No config-pinned minimum | Default fast Python linter and fixer/formatter. |
| `pyright` | Rolling package | No config-pinned minimum | Optional stronger type-aware Python LSP; requires Node.js. |
| `python-flake8` | `1:7.3.0-2` | No config-pinned minimum | Optional traditional Python lint diagnostics through ALE. |
| `python-pylint` | `4.0.6-1` | No config-pinned minimum | Optional deeper Python diagnostics. |
| `python-black` | `26.5.1-1` | No config-pinned minimum | Optional formatter when selected with a custom `g:ale_fixers`. |
| `python-isort` | `9.0.0b1-1` | No config-pinned minimum | Optional import sorter when selected with a custom `g:ale_fixers`. |
| `ripgrep` | `15.2.0-1` | No config-pinned minimum | Enables fast project text search for `:Rg` and `<Leader>fr`. |
| `bat` | `0.26.1-2` | No config-pinned minimum | Enables highlighted FZF previews. |
| `fzf` | `0.74.2-1` | `0.38.0+` | Enables interactive FZF file, git-file, text, buffer, line, symbol, and keymap pickers. |

Arch's packaged `fzf` is current enough. The config lets vim-plug clone the Vim wrapper only and does not run an fzf binary install hook.

### Git Bash On Windows

Git for Windows includes an MSYS Vim. This config should load there, but FZF
integration is not enabled unless an external `fzf` `0.38.0+` is already on
`PATH`. This avoids fzf.vim's interactive binary download prompt and keeps
plugin installation explicit. The non-FZF fallback views, including `:Keymaps`
and `<Leader>fk`, remain available.

If a previous run downloaded `~/.vim/plugged/fzf/bin/fzf.exe`, reopen Vim with this config and run:

```vim
:PlugClean
```

Accept removal of `fzf` and `fzf.vim` if they are no longer declared. The config does not treat that plugin-managed binary as an acceptable FZF executable.

If Git Bash still finds that binary, check shell startup files such as `~/.bashrc` and remove any PATH entry pointing at `~/.vim/plugged/fzf/bin`. Inside Vim, run `:OmarchyFzfStatus` to see FZF candidates, the accepted external path, version, and whether FZF integration is usable.

Without FZF, `<Leader>ff`, `<Leader>fg`, `<Leader>fr`, `<Leader>fl`,
`<Leader>fs`, and `<Leader>fk` use unfiltered scratch-buffer fallback pickers.
Press `<CR>` on an item to open/jump and `q` to close the picker. Install an
external `fzf` `0.38.0+` and rerun `:PlugInstall` to enable filtering.

## Check What Is Installed

### Debian/Ubuntu Style

Check package install status and versions:

```sh
dpkg-query -W -f='${binary:Package}\t${Version}\n' \
  vim neovim git curl nodejs npm python3 python3-pylsp python3-rope pipx \
  black isort flake8 pylint ripgrep bat fzf \
  2>/dev/null || true
```

Check commands on `PATH`:

```sh
for cmd in vim nvim git curl node npm python3 pylsp pyright-langserver ruff \
  black isort flake8 pylint rg batcat bat fzf; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '%-8s ' "$cmd"
    "$cmd" --version 2>/dev/null | head -n 1 || echo installed
  else
    printf '%-8s missing\n' "$cmd"
  fi
done
```

Check Vim feature requirements:

```sh
vim --version | grep -E '\+(job|channel|timers)'
```

Expected: `+job`, `+channel`, and `+timers` appear. Debian's full `vim` package should satisfy this; `vim-tiny` is not the target.

### Arch

Check package install status and versions:

```sh
pacman -Q \
  vim neovim git curl nodejs npm python python-lsp-server python-rope ruff pyright \
  python-black python-isort python-flake8 python-pylint ripgrep bat fzf \
  2>/dev/null || true
```

Check commands on `PATH`:

```sh
for cmd in vim nvim git curl node npm python pylsp pyright-langserver ruff \
  black isort flake8 pylint rg bat fzf; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '%-8s ' "$cmd"
    "$cmd" --version 2>/dev/null | head -n 1 || echo installed
  else
    printf '%-8s missing\n' "$cmd"
  fi
done
```

## Install Missing Requirements

### Debian 12: Vim Only

```sh
sudo apt update
sudo apt install vim git curl ripgrep bat
```

### Debian 12: Vim Plus Python Support

```sh
sudo apt update
sudo apt install vim git curl python3-pylsp python3-rope pipx ripgrep bat
pipx ensurepath
pipx install ruff
```

### Debian 12: Vim And Neovim Plus Python Support

```sh
sudo apt update
sudo apt install vim neovim git curl python3-pylsp python3-rope pipx ripgrep bat
pipx ensurepath
pipx install ruff
```

`python3-pynvim` is not required for this config because the config is Vimscript and does not use Python-hosted Neovim plugins. Install it only if you add plugins later that require Neovim's Python provider.

### Debian 12: Add Copilot Inline Suggestions

```sh
sudo apt update
sudo apt install nodejs npm
```

GitHub Copilot for Vim/Neovim requires Node.js `18+`. Debian 12's `nodejs`
package satisfies that requirement.

### Arch: Vim Only

```sh
sudo pacman -S --needed vim git curl ripgrep bat fzf
```

### Arch: Vim Plus Python Support

```sh
sudo pacman -S --needed \
  vim git curl ripgrep bat fzf \
  python-lsp-server python-rope ruff
```

### Arch: Vim And Neovim Plus Python Support

```sh
sudo pacman -S --needed \
  vim neovim git curl ripgrep bat fzf \
  python-lsp-server python-rope ruff
```

### Arch: Add Copilot Inline Suggestions

```sh
sudo pacman -S --needed nodejs npm
```

## Set Up The Config

Pick a dotfiles path first:

```sh
DOTFILES="$PWD"
```

Run that from this repository root, or set `DOTFILES` to the absolute path of this repo.

### Vim Direct Symlink

Use this when you do not need optional plugin flags:

```sh
ln -sf "$DOTFILES/omarchy/vim/init.vim" ~/.vimrc
```

Normal startup after this:

```sh
vim
vim path/to/file.py
```

### Neovim Direct Symlink

Use this when you do not need optional plugin flags:

```sh
mkdir -p ~/.config/nvim
ln -sf "$DOTFILES/omarchy/vim/init.vim" ~/.config/nvim/init.vim
```

Normal startup after this:

```sh
nvim
nvim path/to/file.py
```

### Wrapper Presets

Use a wrapper if you want to enable optional plugins without editing
`omarchy/vim/init.vim`. The wrapper itself is the file Vim or Neovim starts
from; the wrapper then sources the canonical config from this git repo.

Current presets:

| Wrapper | FZF | Git plugins | Copilot | Python profile |
| --- | --- | --- | --- | --- |
| `init_everything.vim` | On | On | Inline suggestions and CLI on | Pyright, Ruff, and Pylint |
| `init_copilot_no_sugg.vim` | On | On | Installed; automatic suggestions start off; CLI on | pylsp and Ruff |
| `init_no_copilot_cli.vim` | On | On | Inline suggestions on; CLI mapping off | pylsp and Ruff |
| `init_no_copilot.vim` | On | On | Off | pylsp and Ruff |
| `init_no_copilot_no_fzf.vim` | Off | On | Off | pylsp and Ruff |
| `init_no_copilot_no_git.vim` | On | Off | Off | pylsp and Ruff |
| `init_minimal.vim` | Off | Off | Off | Disabled |

All Python-enabled wrappers start the selected LSP on Python-buffer open, skip
the separate open-time lint job, and lint on save. See [Python Tooling](#python-tooling)
for timing and dependency details.

Each wrapper contains this line:

```vim
let s:omarchy_vim_init = expand('~/dev/dotfiles/omarchy/vim/init.vim')
```

Keep that path pointed at the git repo copy of `omarchy/vim/init.vim`. If your
repo lives somewhere else, edit the copied wrapper before using it.

### Vim Wrapper

Copy the chosen wrapper to `~/.vimrc`:

```sh
WRAPPER="$DOTFILES/omarchy/vim/use_this_wrapper_for_nvim_init_vim/init_no_copilot.vim"

if [ -L ~/.vimrc ]; then
  rm ~/.vimrc
elif [ -e ~/.vimrc ]; then
  mv ~/.vimrc ~/.vimrc.bkup
fi

cp "$WRAPPER" ~/.vimrc
```

Normal startup remains:

```sh
vim
vim path/to/file.py
```

### Neovim Wrapper

For Neovim, copy the chosen wrapper to `~/.config/nvim/init.vim`:

```sh
mkdir -p ~/.config/nvim
WRAPPER="$DOTFILES/omarchy/vim/use_this_wrapper_for_nvim_init_vim/init_no_copilot.vim"

if [ -L ~/.config/nvim/init.vim ]; then
  rm ~/.config/nvim/init.vim
elif [ -e ~/.config/nvim/init.vim ]; then
  mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.bkup
fi

cp "$WRAPPER" ~/.config/nvim/init.vim
```

Normal startup remains:

```sh
nvim
nvim path/to/file.py
```

### Install Vim Plugins

The safe first-run order is:

1. Install platform packages first. At minimum install `vim`, `git`, and
   `curl`. Install `fzf` `0.38.0+` before opening Vim if you want FZF
   integration enabled on first plugin install.
2. Open Vim or Neovim normally through the symlink or wrapper above.
3. If vim-plug is not installed yet, run:

```vim
:OmarchyPlugBootstrap
```

This downloads only vim-plug. It does not install ALE, FZF, Copilot, or any other editor plugin.

4. Then run:

```vim
:PlugInstall
```

`:PlugInstall` installs the plugins declared by this config:

- ALE is declared by default.
- fzf/fzf.vim are declared only when external `fzf` `0.38.0+` is already on
  `PATH` and FZF is enabled or auto-detected.
- Copilot, gitgutter, and fugitive are declared only when their flags are set before sourcing `init.vim`.

Close and reopen the editor after plugin installation. If you install `fzf` later, reopen Vim and run `:PlugInstall` again so vim-plug sees the updated plugin list. If you switch to a wrapper that enables more optional plugins after the first install, run `:PlugInstall` again so vim-plug installs them.

## Normal Startup Vs Test Startup

Normal startup uses the standard config locations:

- Vim reads `~/.vimrc`, so start with `vim` or `vim file`.
- Neovim reads `~/.config/nvim/init.vim`, so start with `nvim` or `nvim file`.

The test matrix uses explicit startup commands to bypass any other config:

```sh
vim -Nu omarchy/vim/init.vim
nvim -u omarchy/vim/init.vim
```

Use those only for isolated testing. They are not the normal daily startup commands after you have symlinked or wrapped the config.

## Optional Plugins

Set these values before `source .../init.vim`. The preferred place is the
chosen wrapper file copied to `~/.vimrc` for Vim or `~/.config/nvim/init.vim`
for Neovim. You may also set them directly in your own `.vimrc` or `init.vim`,
as long as the settings appear before the line that sources
`omarchy/vim/init.vim`.

| Flag | Enable / use value | Disable / alternate value | Default | Effect | Dependencies and notes |
| --- | --- | --- | --- | --- | --- |
| `g:omarchy_use_fzf` | `1` | `0` | Auto: `1` only when external `fzf` is usable, otherwise `0` | Requests `junegunn/fzf` and `junegunn/fzf.vim`. | Requires external `fzf` `0.38.0+` on `PATH`. If unavailable, the config disables FZF, warns once, and uses fallback views. |
| `g:omarchy_use_gitgutter` | `1` | `0` | `0` | Enables `airblade/vim-gitgutter` for added/changed/removed signs. | Requires `git` on `PATH`, a git worktree for useful signs, and `:PlugInstall` after enabling the flag. |
| `g:omarchy_use_fugitive` | `1` | `0` | `0` | Enables `tpope/vim-fugitive` for `:Git`, `:Git blame`, and `:Gdiffsplit`. | Requires `git` on `PATH` and `:PlugInstall` after enabling the flag. |
| `g:omarchy_install_copilot` | `1` | `0` | `0` | Installs `github/copilot.vim` for optional inline suggestions. | Requires Vim 9.0.0185+ or Neovim 0.6+, Node.js, and `:PlugInstall` after enabling the flag. |
| `g:omarchy_copilot_suggestions_start_enabled` | `1` | `0` | `0` | Starts automatic Copilot inline suggestions enabled. | Only has an effect when `g:omarchy_install_copilot = 1`; it does not install Copilot by itself. |
| `g:omarchy_enable_copilot_cli_mapping` | `1` | `0` | `0` | Enables `<Leader>ac` to open the separate GitHub Copilot CLI in a terminal split. | Does not require `g:omarchy_install_copilot = 1`. Requires the separate `copilot` executable on `PATH` and Vim/Neovim `:terminal` support. |

Optional plugin checks after enabling flags:

```vim
:PlugInstall
:Git
:Git blame
:Gdiffsplit
:GitGutterPreviewHunk
:OmarchyCopilotStatus
:OmarchyCopilotSuggest
:OmarchyCopilotChat
```

## Python Tooling

ALE provides the editor integration, but language intelligence, linting, and
fixing are separate functions:

- The selected LSP provides definitions, references, hover, rename, code
  actions, semantic diagnostics, and completion.
- Ruff, Flake8, and Pylint provide external lint diagnostics.
- Ruff is also the default fixer and formatter used by `:ALEFix`.
- Native buffer/dictionary completion remains available without ALE or Python.

### Profiles And Dependencies

| Profile | Settings | Dependencies | Use when |
| --- | --- | --- | --- |
| Default no-Node | `g:omarchy_python_lsp = 'pylsp'`, `g:omarchy_python_linters = ['ruff']` | `python-lsp-server[rope]`, Ruff | Recommended general setup; fast linting and no Node.js requirement. |
| Basic Node | `g:omarchy_python_lsp = 'pyright'`, `g:omarchy_python_linters = ['ruff']` | Node.js, Pyright, Ruff | Stronger type-aware language intelligence. |
| Stronger analysis | Pyright with `['ruff', 'pylint']` | Node.js, Pyright, Ruff, Pylint | Larger projects where deeper, slower diagnostics are useful. |
| Traditional linting | pylsp or Pyright with `['flake8']` | Selected LSP plus Flake8 | Existing projects standardized on Flake8. |

Ruff is the recommended editor linter. Pylint provides deeper semantic/design
checks but is slower and often noisier. Running both Flake8 and Pylint is
usually redundant; use the combination only when a project requires both.

Install the default profile in a virtualenv:

```sh
python -m pip install "python-lsp-server[rope]" ruff
```

For the Node profile, install Pyright and Ruff:

```sh
npm install -g pyright
python -m pip install ruff
```

Optional linters can be installed in the same environment:

```sh
python -m pip install flake8 pylint
```

The Debian and Arch package-oriented default installs are listed under
[Install Missing Requirements](#install-missing-requirements). The config uses
the inherited `PATH` and active `VIRTUAL_ENV`, and also searches upward from a
Python buffer for project virtualenvs such as `.venv`, `venv`, and `env`. Both
Unix `bin` and Windows `Scripts` layouts are supported.

Git Bash Vim uses an MSYS path model while project virtualenvs contain native
Windows executables. The config uses `/usr/bin/bash` and
`pylsp-msys.py` for that specific combination so pylsp receives native Windows
file URIs. Neither Node.js nor fzf is needed for pylsp definitions or
quickfix-based references. Native Vim, Neovim, Linux, and macOS invoke pylsp
directly.

### Settings

Set options before sourcing `omarchy/vim/init.vim`; wrapper values therefore
override defaults without modifying the canonical config.

| Setting | Default | Purpose |
| --- | --- | --- |
| `g:omarchy_python_lsp` | `'pylsp'` | Selects `pylsp`, `pyright`, or an empty string/`'none'` to disable Python LSP actions. |
| `g:omarchy_python_linters` | `['ruff']` | Selects external Python linters. Supported built-ins are Ruff, Flake8, and Pylint. |
| `g:omarchy_python_lsp_on_open` | `1` | Starts the selected LSP asynchronously after cheap dependency checks when a Python buffer opens. |
| `g:omarchy_python_lint_on_open` | `0` | Queues a separate ALE lint pass, including configured external linters, when a Python buffer opens. |
| `g:omarchy_python_lint_on_open_delay` | `500` | Delay in milliseconds for the optional open-time lint pass. |
| `g:omarchy_python_references_command` | `'ALEFindReferences -quickfix'` | Uses ALE's quickfix reference list without requiring fzf. |
| `g:omarchy_python_format_imports` | `1` | Historical name: runs Ruff lint fixes/import cleanup before `ruff format`; `0` runs only `ruff format`. |
| `g:omarchy_python_keyword_completion` | `1` | Enables Vim-native Python keyword and buffer completion. |
| `g:omarchy_python_keyword_completion_min_chars` | `3` | Characters typed before the automatic native completion menu opens. |
| `g:omarchy_python_keyword_completion_max_lines` | `5000` | Skips automatic popup scanning in larger buffers; `0` removes the limit. |

`g:ale_linters` is ALE's lower-level override. When it is not set explicitly,
the config derives Python's enabled linter list once from
`g:omarchy_python_lsp` and `g:omarchy_python_linters`. Set the Omarchy options
before sourcing the config; use `g:ale_linters` directly only when you intend
to replace that derived list.

### When Linting Runs

The default schedule avoids editor-start and typing-time linter processes while
still checking saved files:

| Event | Default | Controlling setting |
| --- | --- | --- |
| Open a Python buffer | Start the LSP; do not queue the separate Ruff pass | `g:omarchy_python_lsp_on_open = 1`, `g:omarchy_python_lint_on_open = 0` |
| Enter a buffer or change filetype | No ALE lint pass | `g:ale_lint_on_enter = 0`, `g:ale_lint_on_filetype_changed = 0` |
| Change text or leave insert mode | No ALE lint pass | `g:ale_lint_on_text_changed = 'never'`, `g:ale_lint_on_insert_leave = 0` |
| Save | Run enabled ALE linters, including Ruff by default | `g:ale_lint_on_save = 1` |
| Request manually | Run enabled linters for the current buffer | `:ALELint` |
| Fix manually | Apply configured Ruff fixers/formatter | `:ALEFix` or `<Leader>lf` |

The selected LSP can publish its own diagnostics after it starts. Those are LSP
messages, not evidence that the separate Ruff open-time pass ran. Likewise,
`g:ale_fix_on_save = 0` by default, so lint-on-save reports diagnostics but does
not rewrite the file.

On-demand linting is always available:

```vim
:ALELint
:ALELintStop
```

It is usually unnecessary with fast Ruff save-time linting, but is useful for
unsaved changes, when save-time linting is disabled, or when expensive tools
such as Pylint should run only by request. To add a mapping, place it after the
line that sources the canonical config:

```vim
nnoremap <silent> <Leader>ll :ALELint<CR>
```

For a fully manual external-lint workflow, set both scheduling options before
sourcing the config:

```vim
let g:omarchy_python_lint_on_open = 0
let g:ale_lint_on_save = 0
```

This does not disable LSP navigation or prevent the LSP from publishing its own
diagnostics. Use `:ALEInfo` to inspect enabled linters and executable paths, and
`:OmarchyDebug` for resolved project, virtualenv, shell, and prerequisite data.

## Main Keys

| Key | Action |
| --- | --- |
| `<Space><Space>` | pick open buffer |
| `<Leader>ff` | find project files |
| `<Leader>fg` | find git-tracked files |
| `<Leader>fr` | search text recursively under Vim's current working directory |
| `<Leader>fl` | search current-buffer lines |
| `<Leader>fs` | list Python classes/functions |
| `<Leader>fk` | show config keymap reference |
| `<Leader>ld` | ALE go to definition |
| `<Leader>lr` | ALE find references |
| `<Leader>lh` | ALE hover |
| `<Leader>ln` | ALE rename |
| `<Leader>la` | ALE code action |
| `<Leader>lj` | next ALE diagnostic |
| `<Leader>lk` | previous ALE diagnostic |
| `<Leader>lf` | run ALE fixers |
| `<Leader>li` | show ALE info |
| `<Leader>at` | toggle Copilot inline suggestions, when `g:omarchy_install_copilot = 1` |
| `<Leader>as` | request a Copilot inline suggestion, when `g:omarchy_install_copilot = 1` |
| `<Leader>ac` | open Copilot CLI, when `g:omarchy_enable_copilot_cli_mapping = 1` |
| Python insert text | show Python completions after 3 typed characters |
| Insert `<Tab>` | complete after a word, otherwise insert a tab |
| Insert `<S-Tab>` | previous completion menu item |
| Insert `<CR>` | accept visible completion menu item |
| Insert `<M-/>` | trigger completion |
| Insert `<C-J>` | accept Copilot inline suggestion, when `g:omarchy_install_copilot = 1` |
| `<C-L>` | refresh screen |
| `<Leader>rr` | refresh screen |
| `<Leader>/` | toggle comment |
| `<Leader>//` | force comment |
| `<Leader>ds` | diff against saved file |
| `<Leader>dg` | diff against git HEAD |
| `<Leader>dq` | close active diff |
| `<Leader>ss` | save current session |
| `<Leader>sr` | restore a saved session |
| `<Leader>sl` | list saved sessions |
| `<Leader>sd` | delete a saved session |

`<Leader>` is Space.

## Sessions

Session save/restore is built into this config using Vim's `:mksession` and `:source`; no plugin is required.

Sessions are stored as `.vim` files in `~/.vim/sessions` by default. Override with `g:omarchy_session_dir` before sourcing `init.vim`. Sessions are enabled by default; set `g:omarchy_use_sessions = 0` before sourcing `init.vim` to disable the commands and keymaps below.

Usage:

- `<Leader>ss` or `:SessionSave [name]` saves the current window layout, buffers, and (with the default `sessionoptions`) working directory. It prompts for a name, defaulting to the current buffer name, else the working-directory basename. `:SessionSave!` overwrites without asking; a plain `:SessionSave` prompts before overwriting an existing session.
- `<Leader>sr` or `:SessionRestore [name]` restores a session. With a name it restores that session directly; without one it shows a picker backed by fzf when available, otherwise an unfiltered scratch-buffer fallback.
- `<Leader>sl` or `:SessionList` opens a read-only list of saved sessions and their full paths.
- `<Leader>sd` or `:SessionDelete` opens the same picker and deletes the chosen session after confirmation.
- `:OmarchySessionStatus` echoes the session flags, directory, and saved-session count.

Sessions are saved per-name and restored with `:source`, so they behave the same in Vim and Neovim and are shared between them by default. No Node.js, Rust, Go, or Python tooling is required.

## Completion Usage

Python buffers have three completion paths:

- The config's Python `completefunc` scans the current buffer with exact-case matching, so typing `hel` can show a local `hello` without also matching `Hello`.
- A Python dictionary file at `omarchy/vim/python-complete.txt` feeds keywords/builtins into that same completion function, so typing `imp` can show `import`. The config resolves symlinked startup files back to the real repo path and has a small keyword fallback if the dictionary file is unavailable.
- ALE/LSP completion remains configured through omnifunc and `:ALEComplete`
  when the selected language server is installed and running.

In insert mode:

- Type at least three keyword characters in a Python file, such as `hel` or `imp`, to open the Python completion menu automatically.
- In buffers larger than `g:omarchy_python_keyword_completion_max_lines`, automatic Python keyword completion is skipped to avoid repeated whole-buffer scans while typing.
- Press `<Tab>` after a word to trigger completion manually, or press `<Tab>` while the menu is visible to move to the next item.
- Press `<S-Tab>` while the menu is visible to move to the previous item.
- Press `<CR>` while the menu is visible to accept the selected item.
- Press `<M-/>` to trigger completion manually without using the two-key `<C-x><C-o>` chord.

When Copilot is installed with `g:omarchy_install_copilot = 1`, automatic inline suggestions are off by default unless `g:omarchy_copilot_suggestions_start_enabled = 1` is set. That flag controls only whether automatic inline suggestions start enabled; it does not install Copilot, authenticate Copilot, enable explicit suggestion requests, or start any Copilot CLI session. Use `:OmarchyCopilotOn`, `:OmarchyCopilotOff`, `:OmarchyCopilotToggle`, or `<Leader>at` to control automatic inline suggestions. Use `<Leader>as` or `:OmarchyCopilotSuggest` to explicitly request one inline suggestion without permanently enabling automatic suggestions. Copilot never owns `<Tab>`; use insert `<C-J>` to accept a visible Copilot suggestion. Automatic Python keyword popup completion is paused while Copilot inline suggestions are enabled, but manual `<Tab>`, `<C-Space>`, and `<M-/>` completion remain available.

## GitHub Copilot

Copilot support is optional and split into two separate tools.

Inline suggestions use GitHub's official `github/copilot.vim` plugin:
https://github.com/github/copilot.vim

Requirements for inline suggestions:

- Vim 9.0.0185+ or Neovim 0.6+.
- Node.js 18+ on `PATH`.
- `git` on `PATH` for vim-plug to clone the plugin.
- A GitHub account with Copilot access.

Check the local versions from the same shell that starts Vim or Neovim:

```sh
git --version
node --version
npm --version
vim --version | head -n 1
nvim --version | head -n 1
```

Enable plugin installation before sourcing this config:

```vim
let g:omarchy_install_copilot = 1
```

Then start Vim or Neovim and confirm the flag was set early enough:

```vim
:echo g:omarchy_install_copilot
```

Expected: `1`.

Install plugins:

```vim
:PlugInstall
```

If `github/copilot.vim` does not appear in the vim-plug install window or
`:PlugStatus`, the flag was not set before `omarchy/vim/init.vim` was sourced
or the chosen wrapper has Copilot disabled. If it appears but fails to install,
read the vim-plug install window and then run:

```vim
:messages
:PlugStatus
```

Node.js is normally not needed for the `:PlugInstall` clone step itself; it is
needed when the plugin runs. Missing or too-old Node.js usually shows up during
`:Copilot setup` or runtime status checks.

Restart the editor after plugin installation, then authenticate the plugin:

```vim
:Copilot setup
:OmarchyCopilotStatus
```

Automatic inline suggestions stay off by default. To start them enabled:

```vim
let g:omarchy_copilot_suggestions_start_enabled = 1
```

Practical inline-suggestion workflow:

- Use normal `<Tab>`, `<C-Space>`, and `<M-/>` completion for Vim/ALE completion.
- Press `<Leader>as` when you want Copilot to suggest inline text on demand.
- Press `<Leader>at` to toggle automatic inline suggestions for the session.
- Press insert `<C-J>` to accept a visible Copilot suggestion.
- Run `:OmarchyCopilotStatus` when setup or authentication is unclear.

When automatic Copilot suggestions are enabled globally but disabled for the current buffer or filetype through Copilot's native settings, the automatic Python keyword popup is allowed to run normally.

Copilot filetype control uses the plugin's native options. For example:

```vim
let g:copilot_filetypes = {
      \ 'gitcommit': v:false,
      \ 'markdown': v:false,
      \ 'text': v:false,
      \ 'help': v:false,
      \ }
```

To allow only selected filetypes:

```vim
let g:copilot_filetypes = {
      \ '*': v:false,
      \ 'python': v:true,
      \ 'javascript': v:true,
      \ }
```

For one buffer:

```vim
let b:copilot_enabled = v:false
```

Chat, planning, and agentic coding use the separate official GitHub Copilot CLI, not another Vim plugin. Install the `copilot` command using GitHub's supported installation path. Run it directly from a terminal:

```sh
copilot
```

Optionally enable a Vim mapping:

```vim
let g:omarchy_enable_copilot_cli_mapping = 1
```

Then use `<Leader>ac` or `:OmarchyCopilotChat` to open `copilot` in a terminal split. The command starts from the current git root when available, otherwise the current buffer directory, otherwise Vim's current working directory.

Platform notes:

- Git Bash uses the same `github/copilot.vim` plugin. Start Vim from Git Bash
  after confirming `git`, `node`, and `npm` are visible in that shell.
- `:OmarchyCopilotChat` requires a Vim/Neovim build with `:terminal`.
- Terminal key handling varies by terminal, tmux, GUI Vim, Vim, and Neovim. `<Tab>` is the most reliable traditional completion key; `<M-/>` and other Alt mappings are terminal-dependent.
- The CLI mapping only launches `copilot`; it does not pass broad authorization flags.

Security notes:

- This config does not disable TLS verification.
- This config sets `g:copilot_version = v:false` by default when installing `copilot.vim`, so ordinary startup does not fetch the latest Copilot language server through `npx`.
- `copilot.vim` provides inline suggestions. The `copilot` CLI is a separate agentic tool that may read files, edit files, and execute commands depending on permissions you grant in the CLI.
- Turning off inline Copilot does not stop an already running Copilot CLI session.

## Test Matrix

Run these from the repository root unless noted.

### 1. Runtime Load

Isolated Vim load:

```sh
vim -Nu omarchy/vim/init.vim
```

Inside Vim:

```vim
:messages
:version
```

Expected: no config errors. Vim should report `+job`, `+channel`, and `+timers`.

Isolated Neovim load, if installed:

```sh
nvim -u omarchy/vim/init.vim
```

Expected: no config errors. Debian 12 Neovim is older than Arch/current Neovim, so treat Debian Nvim as best effort.

Normal-load check after setup:

```sh
vim omarchy/vim/init.vim
nvim omarchy/vim/init.vim
```

Expected: the same config loads through `~/.vimrc` and/or `~/.config/nvim/init.vim`.

### 2. Plugin Install

Inside Vim or Neovim:

```vim
:OmarchyPlugBootstrap
:PlugInstall
```

Expected: `:OmarchyPlugBootstrap` installs vim-plug if needed, and
`:PlugInstall` installs ALE. It installs fzf/fzf.vim only when an external fzf
`0.38.0+` is found and FZF is enabled or auto-detected. Setting
`g:omarchy_use_fzf = 1` without it should warn and select fallback mode. No
plugin hook should install an fzf binary. Node is required only for an enabled
Pyright or Copilot profile; Rust and Go are not required.

Optional check:

```sh
for cmd in node rustc go; do
  command -v "$cmd" >/dev/null 2>&1 && "$cmd" --version || echo "$cmd missing; OK"
done
```

### 3. fzf Commands

Inside Vim or Neovim after `:PlugInstall`:

```vim
:Files
:GFiles
:Buffers
:BLines
:Rg
```

Expected: each opens fzf when fzf integration is enabled and a current `fzf` executable is available. `:Rg` requires `rg`. Previews should use `batcat` on Debian, `bat` on Arch, or degrade cleanly.

Key checks:

- `<Space><Space>` opens buffers.
- `<Leader>ff` finds files.
- `<Leader>fr` searches text recursively under Vim's current working directory. Check `:pwd` if the scope is unclear.
- `<Leader>fk` shows config-defined mappings.

### 4. Python Tooling

Skip this section if you intentionally installed no Python support.

Create a small test file:

```sh
mkdir -p /tmp/omarchy-vim-test
cat >/tmp/omarchy-vim-test/sample.py <<'PY'
import os
import sys

class Greeter:
    def hello(self, name):
        print("hello", name)

def unused():
    return os.getcwd()
PY
vim -Nu omarchy/vim/init.vim /tmp/omarchy-vim-test/sample.py
```

Inside Vim:

```vim
:ALEInfo
:ALELint
:ALEFix
```

Expected:

- `:ALEInfo` shows `pylsp` and `ruff` for the default profile, with executable
  paths from the active or project virtualenv when applicable.
- opening the file starts pylsp but does not queue a separate Ruff open-time
  pass; saving or running `:ALELint` reports the unused `sys` import.
- `:ALEFix` runs Ruff lint fixes/import cleanup followed by `ruff format` by
  default. With `g:omarchy_python_format_imports = 0`, it runs only
  `ruff format`.
- no Node.js or fzf installation is needed for `<Leader>ld` or `<Leader>lr`
  with pylsp.

Key checks on a symbol:

- `<Leader>ld` go to definition.
- `<Leader>lr` find references.
- `<Leader>lh` hover.
- `<Leader>ln` rename.
- `<Leader>la` code action.
- `<Leader>lj` next diagnostic.
- `<Leader>lk` previous diagnostic.
- `<Leader>lf` run fixers.
- `<Leader>li` show ALE info.
- Typing `hel` in insert mode shows a local `hello` symbol when the buffer contains one.
- Typing `imp` in insert mode shows a dictionary completion for `import`.
- Insert mode `<C-x><C-o>` triggers omnifunc completion.
- Insert mode `<Tab>` after a word and `<M-/>` trigger completion without the two-key control sequence.
- Insert mode `<Tab>`, `<S-Tab>`, and `<CR>` navigate or accept the visible completion menu.

### 5. Python Symbols

Inside the same Python file:

```vim
:PythonSymbols
```

Expected: `Greeter`, `hello`, and `unused` appear. Selecting one jumps to its line.

This command is regex-based and does not require `pylsp`, but it is useful to test alongside Python files.

### 6. Statusline

Open a tracked file in this repo:

```sh
vim -Nu omarchy/vim/init.vim omarchy/vim/init.vim
```

Expected statusline includes mode, file, position, filetype/encoding info, time, ALE counts when ALE is loaded, and git branch when `git` is available.

### 7. Editing Helpers

Manual checks:

- `jj` and `jk` leave insert mode.
- `<Leader>/` toggles comments on one line and visual selections.
- `<Leader>//` comments without toggling off.
- Alt-j/k moves lines or visual selections if your terminal sends those keys.
- Visual `<` and `>` keep the visual selection.
- `<C-L>` and `<Leader>rr` refresh the screen.
- `<Leader>ds` opens a diff against the saved file.
- `<Leader>dg` opens a diff against `HEAD` for a tracked file.
- `q` or `<Leader>dq` closes an Omarchy diff and returns to the original buffer.

### 8. Optional Flags

Create a temporary wrapper for Vim:

```sh
cat >/tmp/omarchy-vim-wrapper.vim <<EOF
let g:omarchy_use_gitgutter = 1
let g:omarchy_use_fugitive = 1
let g:omarchy_python_format_imports = 0
execute 'source ' . fnameescape('$PWD/omarchy/vim/init.vim')
EOF
vim -Nu /tmp/omarchy-vim-wrapper.vim omarchy/vim/init.vim
```

Create a temporary wrapper for Neovim:

```sh
cat >/tmp/omarchy-nvim-wrapper.vim <<EOF
let g:omarchy_use_gitgutter = 1
let g:omarchy_use_fugitive = 1
let g:omarchy_python_format_imports = 0
execute 'source ' . fnameescape('$PWD/omarchy/vim/init.vim')
EOF
nvim -u /tmp/omarchy-nvim-wrapper.vim omarchy/vim/init.vim
```

Inside the editor:

```vim
:PlugInstall
:Git
:Git blame
:Gdiffsplit
:GitGutterPreviewHunk
```

Expected: fugitive commands work. Gitgutter signs appear after editing a tracked file.

### 9. GitHub Copilot

Without Copilot enabled, startup should not require Node.js and the editor should behave as though Copilot is absent:

```sh
vim -Nu omarchy/vim/init.vim omarchy/vim/test.py
```

Expected:

- `<Tab>`, `<C-Space>`, and `<M-/>` still use traditional completion.
- `:OmarchyCopilotStatus` reports that Copilot is not installed by this config.
- `:OmarchyCopilotToggle` reports that `g:omarchy_install_copilot = 1` is required.
- `:OmarchyCopilotChat` reports a missing `copilot` executable unless the GitHub Copilot CLI is installed.

To test inline suggestions, create a temporary wrapper:

```sh
cat >/tmp/omarchy-vim-copilot-wrapper.vim <<EOF
let g:omarchy_install_copilot = 1
execute 'source ' . fnameescape('$PWD/omarchy/vim/init.vim')
EOF
vim -Nu /tmp/omarchy-vim-copilot-wrapper.vim omarchy/vim/test.py
```

Inside Vim:

```vim
:PlugInstall
:Copilot setup
:OmarchyCopilotStatus
:OmarchyCopilotSuggest
```

Expected:

- `github/copilot.vim` installs only after the flag is set and `:PlugInstall` is run.
- Automatic inline suggestions are off unless `g:omarchy_copilot_suggestions_start_enabled = 1` is set before sourcing `init.vim`.
- `<Leader>as` explicitly requests an inline suggestion.
- `<Leader>at` toggles automatic inline suggestions.
- Insert `<C-J>` accepts a visible Copilot suggestion and has no fallback action when no suggestion is visible.
- `<Tab>` still uses traditional Vim/ALE completion.
- Automatic Python keyword popup completion is suppressed only while automatic Copilot suggestions are enabled.

To test the Copilot CLI mapping, install the separate `copilot` command, then use a wrapper with:

```vim
let g:omarchy_enable_copilot_cli_mapping = 1
```

Expected:

- `<Leader>ac` and `:OmarchyCopilotChat` open `copilot` in a terminal split when `:terminal` support exists.
- The terminal starts in the current git root when possible, otherwise the buffer directory, otherwise Vim's working directory.
- The config launches only `copilot`; it does not pass blanket permission flags.
- Vim/Neovim builds without `:terminal` report that `copilot` should be run from an external terminal.

### 10. Sessions

Sessions are built in and need no plugins. From the dotfiles repo, start a clean Vim:

```sh
vim -Nu omarchy/vim/init.vim
```

Inside Vim:

```vim
:SessionSave smoke
:SessionList
:SessionSave smoke   " prompts before overwrite unless :SessionSave! is used
:SessionRestore smoke
:SessionDelete
```

Expected:

- `:SessionSave smoke` writes `~/.vim/sessions/smoke.vim`; `:SessionList` shows it.
- Re-saving with the same name prompts for confirmation; `:SessionSave! smoke` does not.
- `:SessionRestore smoke` reopens the saved layout; `<Leader>sr` shows a fzf picker when fzf is enabled, otherwise an unfiltered scratch-buffer fallback.
- `:SessionDelete` removes the session file after confirmation.
- `:OmarchySessionStatus` reports the flags, directory, and count.
- No plugin, Node, Rust, Go, or Python requirement is added.

To keep test artifacts out of `~/.vim/sessions`, run against a temporary directory:

```sh
cat >/tmp/omarchy-sessions-wrapper.vim <<EOF
let g:omarchy_session_dir = expand('$TMPDIR') . '/omarchy-sessions-test'
execute 'source ' . fnameescape('$PWD/omarchy/vim/init.vim')
EOF
vim -Nu /tmp/omarchy-sessions-wrapper.vim
```

## Troubleshooting

- `E492: Not an editor command: PlugInstall`: vim-plug did not load. Run `:OmarchyPlugBootstrap`, then run `:PlugInstall`.
  For Neovim on Arch, check the expected file:

  ```sh
  test -f ~/.local/share/nvim/site/autoload/plug.vim && echo vim-plug-present || echo vim-plug-missing
  ```

  If missing, install it manually:

  ```sh
  sudo pacman -S --needed curl git
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim
  ```

  Then run `:PlugInstall`. Startup intentionally does not download vim-plug by itself.
- fzf commands fail: check that a current external `fzf` executable is on `PATH`, then rerun `:PlugInstall`. This config does not run fzf's `./install --bin` hook and does not use `~/.vim/plugged/fzf/bin/fzf.exe` as an implicit fallback. On Git Bash, leave `g:omarchy_use_fzf` unset unless you explicitly want to test FZF there.
- `g:omarchy_use_fzf was set to 1...`: the config did not find external fzf
  `0.38.0+` on `PATH`, so it reset FZF integration to `0` for this session and
  selected fallback views.
- FZF diagnosis: run `:OmarchyFzfStatus` inside Vim.
- Keymap picker diagnosis: after pressing `<Leader>fk`, run `:OmarchyDebug` to see whether the picker entered FZF or fallback.
- `Post-update hook for fzf ... /usr/share/vim/vimfiles/install not found` on Arch: update this repo and rerun `:PlugInstall` or `:PlugUpdate fzf`. The config no longer declares an fzf post-install hook.
- `:Rg` fails: install `ripgrep`.
- previews are plain text: install `bat`; on Debian the executable is `batcat`.
- ALE has no Python LSP commands: run `:PlugInstall` in the Vim/Neovim instance
  you use and confirm that `:ALEInfo` exists. Installing Python packages does
  not install the ALE editor plugin.
- pylsp is missing: install `python3-pylsp python3-rope` on Debian,
  `python-lsp-server python-rope` on Arch, or
  `python -m pip install "python-lsp-server[rope]"` in the active/project
  virtualenv, then restart Vim.
- Python tools are installed but ALE cannot see them: run `:ALEInfo` and
  `:OmarchyDebug`, then check
  `command -v python pylsp pyright-langserver ruff flake8 pylint`. Vim inherits
  an activated virtualenv and also searches common project virtualenv names.
- Git Bash pylsp navigation fails or stalls: confirm `/usr/bin/bash` and the
  resolved `.venv/Scripts/python.exe` and `pylsp.exe` paths in
  `:OmarchyDebug`. The MSYS adapter is used only for Git Bash Vim with pylsp.
- terminal keys fail: use `:verbose imap <key>` and check terminal/tmux key handling. Insert `<Tab>` after a word is the most reliable manual completion trigger; `<M-/>` is optional and terminal-dependent. `<C-x><C-o>` remains the built-in omnifunc fallback.
- optional plugin maps say a command is unavailable: the flag is probably enabled but `:PlugInstall` has not been rerun yet.
- Copilot commands say the plugin is unavailable: set `g:omarchy_install_copilot = 1` before sourcing `init.vim`, run `:PlugInstall`, restart, then run `:Copilot setup`.
- `:OmarchyCopilotChat` says the CLI is missing: install the separate GitHub Copilot CLI so the `copilot` executable is on `PATH`, or run `copilot` directly from a terminal after installation.
- `:OmarchyCopilotChat` says `:terminal` is unavailable: use an external terminal. Terminal integration is feature-detected and may differ between Vim, Neovim, terminal Vim, GUI Vim, Windows, WSL, and Unix-like shells.

## Upgrade

Inside Vim or Neovim:

```vim
:PlugUpdate
```

Then restart the editor and rerun the test matrix.

## Removal

Remove direct symlinks or wrapper files:

```sh
rm -f ~/.vimrc ~/.config/nvim/init.vim
```

Plugin data lives under `~/.vim/plugged` for Vim and under Neovim's data directory for Neovim.
