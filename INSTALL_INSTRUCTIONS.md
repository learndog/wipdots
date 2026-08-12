# Omarchy Vim Install Instructions

This file contains setup, dependency, plugin, and upgrade information for
`omarchy/vim/init.vim`. The main `README.md` is the feature and daily-use
reference.

## Install Summary

Minimum to load and edit:

- Vim 8.2+ with `+job`, `+channel`, and `+timers`, or Neovim.
- `git` for vim-plug plugin installs, git file search, git branch display, and
  git diff helpers.
- `curl` only when running `:OmarchyPlugBootstrap`.

Recommended but optional:

- `ripgrep` (`rg`) for `<Leader>fr`, `:OmarchyGrep`, and `:Rg`.
- `bat` or `batcat` for FZF previews.
- `bash` for FZF previews and `:OmarchyTerminal`.
- External `fzf` `0.38.0+` for interactive FZF pickers.

Optional Python tooling:

- `python-lsp-server` / `python3-pylsp` for the default no-Node Python LSP.
- `ruff` for default lint/fix/format.
- `pyright-langserver` for optional stronger Python analysis; requires Node.js.
- `flake8`, `pylint`, `black`, and `isort` for custom Python profiles.

Optional non-Python language tools:

- `shellcheck`: shell diagnostics through ALE when already installed.
- `shfmt`: shell formatting through `:ALEFix` when already installed.
- `sqlfluff`: SQL/BigQuery diagnostics and formatting through ALE when already
  installed.
- `luacheck`: Lua diagnostics through ALE when already installed.
- `vint`: Vimscript diagnostics through ALE when already installed.

No new language tool is required to start Vim. Node.js is needed only for the
optional Pyright or GitHub Copilot profiles. Rust and Go toolchains are not
required.

## Files

- `init.vim`: canonical config.
- `python-complete.txt`: native Python keyword/builtin completion dictionary.
- `pylsp-msys.py`: Git Bash/MSYS URI adapter for native Windows pylsp.
- `use_this_wrapper_for_nvim_init_vim/*.vim`: wrapper presets for both Vim and
  Neovim. Copy one to `~/.vimrc` or `~/.config/nvim/init.vim`.
- `vim_strategy.md`: historical strategy and risk notes.
- `README.md`: feature and daily-use reference.
- `INSTALL_INSTRUCTIONS.md`: this setup reference.

## Version Notes

Versions below are package versions checked from official package pages when
this config was documented. Debian 12 is stable, while Arch is rolling. Use the
check commands below to see what your machine actually has. Where no strict
minimum is listed, the config only needs the command-line behavior described.

### Debian 12 Bookworm

| Package | Checked package version | Minimum for this config | Required for / gained functionality |
| --- | --- | --- | --- |
| `vim` | `2:9.0.1378-2+deb12u2` | Vim 8.2+ with `+job`, `+channel`, and `+timers`; Copilot needs Vim 9.0.0185+ | Primary Vim runtime. Required unless you use Neovim only. Enables the whole config, ALE async jobs, terminal/editor workflows, and Copilot inline suggestions when enabled. |
| `neovim` | `0.7.2-7` | Neovim 0.6+ for Copilot | Optional Neovim runtime. Enables using this same Vimscript config as `~/.config/nvim/init.vim`. |
| `git` | `1:2.39.5-0+deb12u3` | No config-pinned minimum | Required for vim-plug plugin clones, git file search, git branch display, diff helpers, gitgutter signs, fugitive commands, and read-only plugin update checks. |
| `curl` | `7.88.1-10+deb12u15` | No config-pinned minimum; must support HTTPS downloads | Required only for `:OmarchyPlugBootstrap` to download vim-plug. |
| `nodejs` | `18.20.4+dfsg-1~deb12u2` | Node.js 18+ | Required for optional Pyright and `github/copilot.vim`. |
| `npm` | `9.2.0~ds1-1` | Bundled/package version is fine with Node.js 18+ | Recommended with Node.js for Copilot tooling compatibility and Node package-manager workflows. |
| `python3` | `3.11.2-1 and others` | No config-pinned minimum | Runtime for Python tools. Not needed to start Vim or use native Python keyword completion. |
| `python3-pylsp` | `1.7.1-1` | No config-pinned minimum | Enables Python LSP features through ALE. |
| `python3-rope` | Distribution version | No config-pinned minimum | Improves pylsp rename and refactoring support. |
| `ruff` | Not packaged in Debian 12 stable | No config-pinned minimum | Default fast Python linter and fixer/formatter; install with pipx or the editor tools env. |
| `flake8` | `5.0.4-4` | No config-pinned minimum | Optional traditional Python lint diagnostics through ALE. |
| `pylint` | `2.16.2-2` | No config-pinned minimum | Optional deeper Python diagnostics; generally slower and noisier than Ruff. |
| `black` | `23.1.0-1` | No config-pinned minimum | Optional formatter when selected with a custom `g:ale_fixers`. |
| `isort` | `5.6.4-1` | No config-pinned minimum | Optional import sorter when selected with a custom `g:ale_fixers`. |
| `ripgrep` | `13.0.0-4` | No config-pinned minimum | Enables fast project text search for `:Rg`, `:OmarchyGrep`, and `<Leader>fr`. |
| `bat` | `0.22.1-4` | No config-pinned minimum | Enables highlighted FZF previews; Debian's executable is `batcat`. |
| `fzf` | `0.38.0-1` | `0.38.0+` | Enables interactive FZF pickers; fallback scratch-buffer pickers are used when unavailable. |

The configured minimum is fzf `0.38.0`. A newer external release is preferable
when practical, but Debian 12's package is accepted. The config does not run
the fzf repository's `./install --bin` hook or treat a plugin-managed binary as
an external fzf installation.

### Arch Linux

| Package | Checked package version | Minimum for this config | Required for / gained functionality |
| --- | --- | --- | --- |
| `vim` | `9.2.0849-1` | Vim 8.2+ with `+job`, `+channel`, and `+timers`; Copilot needs Vim 9.0.0185+ | Primary Vim runtime. Required unless you use Neovim only. |
| `neovim` | `0.12.4-1` | Neovim 0.6+ for Copilot | Optional Neovim runtime. |
| `git` | `2.55.0-1` | No config-pinned minimum | Required for plugin clones, git helpers, statusline branch, diffs, and plugin update checks. |
| `curl` | `8.21.0-1` | No config-pinned minimum; must support HTTPS downloads | Required only for `:OmarchyPlugBootstrap`. |
| `nodejs` | `26.5.0-1` | Node.js 18+ | Required for optional Pyright and Copilot. |
| `npm` | `12.0.1-1` | Bundled/package version is fine with Node.js 18+ | Recommended with Node.js. |
| `python` | `3.14.6-1` | No config-pinned minimum | Runtime for Python tools. |
| `python-lsp-server` | `1.15.0-1` | No config-pinned minimum | Enables Python LSP features through ALE. |
| `python-rope` | Rolling package | No config-pinned minimum | Improves pylsp rename and refactoring support. |
| `ruff` | Rolling package | No config-pinned minimum | Default fast Python linter and fixer/formatter. |
| `pyright` | Rolling package | No config-pinned minimum | Optional stronger type-aware Python LSP; requires Node.js. |
| `python-flake8` | `1:7.3.0-2` | No config-pinned minimum | Optional traditional Python lint diagnostics. |
| `python-pylint` | `4.0.6-1` | No config-pinned minimum | Optional deeper Python diagnostics. |
| `python-black` | `26.5.1-1` | No config-pinned minimum | Optional formatter when selected with a custom `g:ale_fixers`. |
| `python-isort` | `9.0.0b1-1` | No config-pinned minimum | Optional import sorter when selected with a custom `g:ale_fixers`. |
| `ripgrep` | `15.2.0-1` | No config-pinned minimum | Enables fast project text search. |
| `bat` | `0.26.1-2` | No config-pinned minimum | Enables highlighted FZF previews. |
| `fzf` | `0.74.2-1` | `0.38.0+` | Enables interactive FZF file, git-file, text, buffer, line, symbol, and keymap pickers. |

## Git Bash On Windows

Git for Windows includes an MSYS Vim. This config should load there, but FZF
integration is not enabled unless an external `fzf` `0.38.0+` is already on
`PATH`. This avoids fzf.vim's interactive binary download prompt and keeps
plugin installation explicit. The non-FZF fallback views, including `:Keymaps`
and `<Leader>fk`, remain available.

If a previous run downloaded `~/.vim/plugged/fzf/bin/fzf.exe`, reopen Vim with
this config and run:

```vim
:PlugClean
```

Accept removal of `fzf` and `fzf.vim` if they are no longer declared. The config
does not treat that plugin-managed binary as an acceptable FZF executable.

If Git Bash still finds that binary, check shell startup files such as
`~/.bashrc` and remove any PATH entry pointing at `~/.vim/plugged/fzf/bin`.
Inside Vim, run `:OmarchyFzfStatus` to see FZF candidates, the accepted external
path, version, and whether FZF integration is usable.

Without FZF, picker commands use unfiltered scratch-buffer fallback pickers or
clear built-in prompts. The Netrw file explorer maps under `<Leader>e` are built
in and do not require FZF. Install an external `fzf` `0.38.0+` and rerun
`:PlugInstall` to enable filtering.

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
  black isort flake8 pylint rg batcat bat fzf shellcheck shfmt sqlfluff luacheck vint bash; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '%-22s ' "$cmd"
    "$cmd" --version 2>/dev/null | head -n 1 || echo installed
  else
    printf '%-22s missing\n' "$cmd"
  fi
done
```

Check Vim feature requirements:

```sh
vim --version | grep -E '\+(job|channel|timers)'
```

Expected: `+job`, `+channel`, and `+timers` appear. Debian's full `vim` package
should satisfy this; `vim-tiny` is not the target.

### Arch

Check package install status and versions:

```sh
pacman -Q \
  vim neovim git curl nodejs npm python python-lsp-server python-rope ruff pyright \
  python-black python-isort python-flake8 python-pylint ripgrep bat fzf \
  shellcheck shfmt sqlfluff lua-language-server luacheck vint \
  2>/dev/null || true
```

Check commands on `PATH`:

```sh
for cmd in vim nvim git curl node npm python pylsp pyright-langserver ruff \
  black isort flake8 pylint rg bat fzf shellcheck shfmt sqlfluff luacheck vint bash; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '%-22s ' "$cmd"
    "$cmd" --version 2>/dev/null | head -n 1 || echo installed
  else
    printf '%-22s missing\n' "$cmd"
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

`python3-pynvim` is not required for this config because the config is Vimscript
and does not use Python-hosted Neovim plugins. Install it only if you add plugins
later that require Neovim's Python provider.

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

### Optional Non-Python Language Tools

Install these only when you want the related diagnostics or formatting:

```sh
sudo apt install shellcheck shfmt
pipx install sqlfluff
pipx install vim-vint
```

Debian/Ubuntu packages vary by release; use distro packages when available and
use `pipx` for Python-packaged tools when packages are unavailable.

```sh
sudo pacman -S --needed shellcheck shfmt sqlfluff luacheck vint
```

## Python Tooling Setup

The README keeps daily Python usage notes; setup and dependency details live
here.

ALE provides the editor integration, but language intelligence, linting, and
fixing are separate functions:

- The selected LSP provides definitions, references, hover, rename, code
  actions, semantic diagnostics, and completion.
- Ruff, Flake8, and Pylint provide external lint diagnostics.
- Ruff is also the default fixer and formatter used by `:ALEFix`.
- Native buffer/dictionary completion remains available without ALE or Python.

### Profiles And Dependencies

Keep the editor tools separate from project dependencies:

```text
editor tools env:
  contains pylsp, ruff, optional flake8/pylint, and optional pyright

project env:
  contains numpy, pandas, django, requests, your package, and other runtime deps
```

The recommended editor tools env is `~/.venvs/vim-tools`, which matches the
default `g:omarchy_python_tools_env`. Vim and Neovim prefer executables from
that env first, then fall back to `PATH`, then project envs only as a
compatibility fallback. This means opening Vim from a project shell should not
force you to install `pylsp` or `ruff` into that project's `.venv`.

Zero-configuration still works. If `~/.venvs/vim-tools` does not exist, or if
it exists but does not contain the requested tool, the config keeps looking.
That means a user can still activate a project `.venv`, install `pylsp` and
`ruff` there, open Vim from that shell, and get the default `pylsp + ruff`
profile without setting any Omarchy options. This is supported as the simple
fallback path, even though the dedicated editor tools env is the cleaner
long-term setup.

Project imports are handled separately. For project envs named `.venv`, `venv`,
or `env`, the config detects the project Python and passes it to the selected
LSP for import analysis. For conda or micromamba projects, activate the project
env before launching Vim or set `g:omarchy_python_project_env`/the buffer-local
`b:omarchy_python_project_env` to that environment root.

| Profile | Settings | Dependencies | Use when |
| --- | --- | --- | --- |
| Default no-Node | `g:omarchy_python_lsp = 'pylsp'`, `g:omarchy_python_linters = ['ruff']` | `python-lsp-server[rope]`, Ruff | Recommended general setup; fast linting and no Node.js requirement. |
| Basic Node | `g:omarchy_python_lsp = 'pyright'`, `g:omarchy_python_linters = ['ruff']` | Node.js, Pyright, Ruff | Stronger type-aware language intelligence. |
| Stronger analysis | Pyright with `['ruff', 'pylint']` | Node.js, Pyright, Ruff, Pylint | Larger projects where deeper, slower diagnostics are useful. |
| Traditional linting | pylsp or Pyright with `['flake8']` | Selected LSP plus Flake8 | Existing projects standardized on Flake8. |

Ruff is the recommended editor linter. Pylint provides deeper semantic/design
checks but is slower and often noisier. Running both Flake8 and Pylint is
usually redundant; use the combination only when a project requires both.

Install the default profile in the dedicated editor tools env:

```sh
python -m venv ~/.venvs/vim-tools
~/.venvs/vim-tools/bin/python -m pip install -U pip
~/.venvs/vim-tools/bin/python -m pip install -U "python-lsp-server[rope]" pylsp-rope ruff
```

On Windows-native Python, replace `bin/python` with `Scripts/python.exe`.

For the Node profile, install Pyright globally and keep Ruff in the editor
tools env:

```sh
npm install -g pyright
```

Optional linters can be installed in the same environment:

```sh
~/.venvs/vim-tools/bin/python -m pip install -U flake8 pylint
```

If you prefer conda or micromamba for editor tools, create one dedicated env
and point `g:omarchy_python_tools_env` at the environment root:

```vim
let g:omarchy_python_tools_env = expand('~/mambaforge/envs/vim-tools')
```

Use the equivalent root for your machine. It is the directory that contains
`bin/python` on Linux/macOS or `python.exe` and `Scripts/` on Windows. Project
dependencies do not belong in this env; install them in the project env.

The Debian and Arch package-oriented default installs are listed in
[INSTALL_INSTRUCTIONS.md](INSTALL_INSTRUCTIONS.md). System-package or `pipx`
installs work too because the config falls back to Vim's inherited `PATH` when a
tool is not found in `g:omarchy_python_tools_env`.

### Project Env Detection

There are two different paths involved:

```text
g:omarchy_python_tools_env:
  env root where editor tools are installed

project env:
  env root where project packages are installed
```

For `g:omarchy_python_tools_env` and `g:omarchy_python_project_env`, provide
the environment root, not the Python executable path. Examples:

```text
~/.venvs/vim-tools
/home/me/work/app/.venv
/opt/conda/envs/myproject
C:/Users/me/.venvs/vim-tools
C:/Users/me/mambaforge/envs/myproject
```

To identify a currently active environment, run:

```sh
python -c "import sys; print(sys.executable)"
```

If the output is `/home/me/work/app/.venv/bin/python`, the env root is
`/home/me/work/app/.venv`. If the output is
`C:\Users\me\work\app\.venv\Scripts\python.exe`, the env root is
`C:\Users\me\work\app\.venv`. If the output is from conda or micromamba and
looks like `/opt/conda/envs/myproject/bin/python` or
`C:\Users\me\mambaforge\envs\myproject\python.exe`, use the corresponding
`.../envs/myproject` directory as the root.

For normal projects, prefer a project-local env named `.venv`:

```sh
cd myproject
python -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt
```

On Windows-native Python, activation and executable paths use `Scripts` instead
of `bin`.

If a project's environment is not located under the project directory, set the
project env root before sourcing `init.vim`:

```vim
let g:omarchy_python_project_env = expand('~/mambaforge/envs/myproject')
```

For a one-off buffer-local override, set:

```vim
let b:omarchy_python_project_env = expand('~/mambaforge/envs/myproject')
```

Wrong-setting behavior:

- If `g:omarchy_python_tools_env` points to a missing directory, it is ignored.
  If it points to an existing env that does not contain `pylsp`, `ruff`, or the
  requested tool, the config falls back to `PATH` and then project envs.
- If `g:omarchy_python_project_env` points to a missing directory or a directory
  without Python, project env detection continues. If it points to a real but
  wrong env with Python, the LSP will trust it; Vim cannot know which import
  environment you intended. Leave this option unset unless auto-detection cannot
  find the right project env.

What happens internally:

- For `pylsp`, if `pylsp` itself is running from the project env, the config
  leaves Jedi's environment alone. That preserves the simple project-venv
  workflow. If `pylsp` is running from a separate editor tools env, the config
  sets `pylsp.plugins.jedi.environment` to the detected project Python
  executable. `pylsp` uses Jedi for completion, go-to-definition, hover,
  references, signatures, and symbols. This tells Jedi, "resolve imports using
  the project interpreter," even though the `pylsp` executable itself came from
  the editor tools env. In Git Bash/MSYS Vim, the config converts MSYS paths
  such as `/c/Users/me/app/.venv/Scripts/python.exe` to native-style paths such
  as `C:/Users/me/app/.venv/Scripts/python.exe` before sending that setting to
  native Windows `pylsp`.
- For Pyright, the config sets `python.pythonPath` to the detected project
  Python executable. Pyright then analyzes imports against the project env while
  `pyright-langserver` still runs from the editor tools env or `PATH`. The same
  MSYS-to-native path conversion is applied when needed.
- Ruff, Flake8, and Pylint are run as editor tools. Ruff normally reads project
  config from `pyproject.toml`/Ruff config files and does not need to be
  installed in the project env. Pylint is more likely to need project imports,
  so it is intentionally opt-in rather than the default.

Scope is tool-specific. ALE is the Vim/Neovim client; the selected server or
linter decides how much code it analyzes after ALE gives it a file and, for
LSPs, a workspace root. This config gives `pylsp` and Pyright the nearest
Python project marker found above the current file, or the nearest `.git`
directory, as the LSP root. If neither exists, the current file's directory is
treated as a small standalone project.

LSP navigation and refactoring are therefore project-root scoped, not just
current-file scoped. `<Leader>ld`, `<Leader>lr`, `<Leader>lh`, `<Leader>ln`,
and `<Leader>la` ask `pylsp` or Pyright about the workspace rooted as described
above and imports visible through the detected project Python. Definitions,
references, and rename can cross files under that root when
the language server can resolve the relationship. They are not limited to open
buffers or git-tracked files, but they are also not a textual grep of every
file. Dynamic imports, generated code, missing package metadata, unusual
`sys.path` setup, ignored folders, or a weak server-side index can produce
misses.

Rename is an LSP symbol rename, not a general filesystem refactor. If a server
returns edits for dependent files, ALE applies them, so renaming a function,
class, variable, or resolvable import can update other files in the LSP
workspace. Module/package file renames are more server-dependent; for `pylsp`,
installing Rope support and `pylsp-rope` improves refactoring support, but you
should still review the quickfix/edit result before trusting a broad rename.
Manually renaming `foo.py` outside the LSP rename flow will not automatically
rewrite `import foo` elsewhere.

Ruff linting through ALE is narrower. With this config, save-time linting and
`:ALELint` run the configured linter for the current Python buffer/file, while
`:ALEFix` fixes/formats the current buffer. Ruff still discovers the nearest
`pyproject.toml`, `ruff.toml`, or `.ruff.toml` relevant to that file and uses
project settings such as import classification, but ALE is not asking Ruff to
lint the whole repository. Run `ruff check .` or `ruff check path/to/project`
outside Vim when you want a complete project pass.

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
| `g:omarchy_python_tools_env` | `expand('~/.venvs/vim-tools')` | Preferred editor tools env. Put `pylsp`, `ruff`, optional `flake8`/`pylint`, and optional Python-packaged `pyright` here. |
| `g:omarchy_python_project_env` | `''` | Optional project env root override when the project env is not discoverable as `.venv`, `venv`, `env`, `$VIRTUAL_ENV`, or `$CONDA_PREFIX`. Prefer `b:omarchy_python_project_env` for per-project overrides. |
| `g:omarchy_python_lsp_on_open` | `1` | Starts the selected LSP asynchronously after cheap dependency checks when a Python buffer opens. |
| `g:omarchy_python_lint_on_open` | `0` | Queues a separate ALE lint pass, including configured external linters, when a Python buffer opens. |
| `g:omarchy_python_lint_on_open_delay` | `500` | Delay in milliseconds for the optional open-time lint pass. |
| `g:omarchy_python_references_command` | `'ALEFindReferences -quickfix'` | Uses ALE's quickfix reference list without requiring fzf. |
| `g:ale_references_show_contents` | `0` | Keeps ALE's quickfix reference path from reading every referenced line; this avoids list-index errors from stale/out-of-range LSP locations. Use `ALEFindReferences -contents` only when you want inline reference text. |
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


## Set Up The Config

Pick a dotfiles path first:

```sh
DOTFILES="$PWD"
```

Run that from this repository root, or set `DOTFILES` to the absolute path of
this repo.

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
the separate open-time lint job, and lint on save.

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

## Install Vim Plugins

Safe first-run order:

1. Install platform packages first. At minimum install `vim`, `git`, and
   `curl`. Install external `fzf` `0.38.0+` before opening Vim if you want FZF
   integration enabled on first plugin install.
2. Open Vim or Neovim normally through the symlink or wrapper above.
3. If vim-plug is not installed yet, run:

```vim
:OmarchyPlugBootstrap
```

This downloads only vim-plug. It does not install ALE, FZF, Copilot, or any
other editor plugin.

4. Then run:

```vim
:PlugInstall
```

`:PlugInstall` installs the plugins declared by this config:

- ALE is declared by default.
- fzf/fzf.vim are declared only when external `fzf` `0.38.0+` is already on
  `PATH` and FZF is enabled or auto-detected.
- Copilot, gitgutter, and fugitive are declared only when their flags are set
  before sourcing `init.vim`.

Close and reopen the editor after plugin installation. If you install `fzf`
later, reopen Vim and run `:PlugInstall` again so vim-plug sees the updated
plugin list. If you switch to a wrapper that enables more optional plugins after
the first install, run `:PlugInstall` again so vim-plug installs them.

## Plugin Policy

Normal startup never installs, updates, cleans, upgrades, or downloads plugins.
Manual plugin commands:

```vim
:OmarchyPlugBootstrap
:PlugInstall
:PlugUpdate
:PlugClean
:PlugUpgrade
:OmarchyPlugCheckUpdates
:OmarchyPluginPolicy
```

`:OmarchyPlugBootstrap` downloads only vim-plug, and only when you run it.
`:PlugInstall` and `:PlugUpdate` are the install/update paths for declared
plugins. `:OmarchyPlugCheckUpdates` uses `git ls-remote` to report remote update
availability without fetching, checking out, merging, pulling, or changing local
plugin repositories. Optional plugins are declared only when their flags are set
before sourcing `init.vim`; this config does not use vim-plug `on` or `for`
lazy-load triggers.

## Optional Plugin Flags

Set these values before sourcing this config. The preferred place is the wrapper
file copied to `~/.vimrc` for Vim or `~/.config/nvim/init.vim` for Neovim.

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

## Normal Startup Vs Test Startup

Normal startup uses the standard config locations:

- Vim reads `~/.vimrc`, so start with `vim` or `vim file`.
- Neovim reads `~/.config/nvim/init.vim`, so start with `nvim` or `nvim file`.

The test matrix can use explicit startup commands to bypass any other config:

```sh
vim -Nu omarchy/vim/init.vim
nvim -u omarchy/vim/init.vim
```

Use those only for isolated testing. They are not the normal daily startup
commands after you have symlinked or wrapped the config.

## Upgrade

To check plugin update availability without updating local plugin repos:

```vim
:OmarchyPlugCheckUpdates
```

To actually update plugins:

```vim
:PlugUpdate
```

Then restart the editor and rerun the README test matrix.

## Removal

Remove direct symlinks or wrapper files:

```sh
rm -f ~/.vimrc ~/.config/nvim/init.vim
```

Plugin data lives under `~/.vim/plugged` for Vim and under Neovim's data
directory for Neovim.
