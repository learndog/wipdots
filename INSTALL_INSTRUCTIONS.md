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
:OmarchyPluginPolicy
:OmarchyPlugCheckUpdates
```

Expected: `:OmarchyPlugBootstrap` installs vim-plug if needed, and
`:PlugInstall` installs ALE. It installs fzf/fzf.vim only when an external fzf
`0.38.0+` is found and FZF is enabled or auto-detected. Setting
`g:omarchy_use_fzf = 1` without it should warn and select fallback mode. No
plugin hook should install an fzf binary. Node is required only for an enabled
Pyright or Copilot profile; Rust and Go are not required.
`:OmarchyPluginPolicy` documents the manual plugin policy.
`:OmarchyPlugCheckUpdates` may use network access for `git ls-remote`, but it
must not fetch, pull, checkout, merge, or modify local plugin repositories.

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

- `<Space><Space>` opens buffers. With FZF enabled it opens the FZF buffer
  picker; with FZF disabled it opens the built-in scratch-buffer picker.
- `<Leader>ff` finds files.
- `<Leader>fV` finds a file and opens it in a right vertical split.
- `<Leader>fr` searches text recursively under Vim's current working directory. Check `:pwd` if the scope is unclear.
- `<Leader>fk` shows config-defined mappings.
- `<Leader>fK` shows all live mappings.

### 4. File Explorer

Inside Vim or Neovim:

```vim
:FileExplorer
:FileExplorerReveal
:FileExplorerHelp
```

Key checks:

- `<Leader>ee` opens a left Netrw tree and pressing it again closes that tree.
- From a right-hand split, `<Leader>ee` still opens or reuses the far-left tree
  and returns focus to the editing window unless
  `g:omarchy_file_explorer_focus = 1`.
- `<Leader>eE` opens the explorer at the current file's directory and searches to the current file name.
- In the explorer, `<CR>` and `l` open files or expand/collapse directories, while `h` and `-` go up one directory.
- In the explorer, `/` searches visible names; `n` and `N` move through matches.
- In the explorer, `R` and `<C-L>` refresh the listing.
- In the explorer, `?` and `<F1>` open Netrw help.
- In the explorer, `q` closes the tree.
- In the explorer, accidental file-operation keys such as `D`, `<Del>`, `d`, `%`, `x`, `O`, `m`, and `cd` should echo a disabled-key message instead of performing the native Netrw action.

### 5. Python Tooling

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
  paths from `g:omarchy_python_tools_env` when that env has been created, or
  from Vim's inherited `PATH` otherwise.
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

### 6. Symbols

Inside the same Python file:

```vim
:PythonSymbols
:Symbols
```

Expected: `Greeter`, `hello`, and `unused` appear. Selecting one jumps to its line.

These commands are regex-based and do not require `pylsp`, but they are useful
to test alongside Python files. `:PythonSymbols` is preserved for Python
class/function scanning. `:Symbols` wraps that behavior for Python and adds
lightweight detectors for supported non-Python filetypes. In an unsupported
filetype it should report a clear message, not error.

### 7. Statusline

Open a tracked file in this repo:

```sh
vim -Nu omarchy/vim/init.vim omarchy/vim/init.vim
```

Expected statusline includes mode, file, position, filetype/encoding info, time,
ALE counts when ALE is loaded, and git branch when `git` is available. With
`g:omarchy_statusline_mode_colors = 1`, NORMAL is light gray, INSERT is orange,
VISUAL modes are blue, and other modes are green. If colors are unreadable with
your colorscheme, set the flag to `0`.

### 8. Editing Helpers

Manual checks:

- `jj` and `jk` leave insert mode.
- Normal and insert `jl` jump just past the next `)`, `]`, `}`, `>`, quote, or
  backtick without jumping to an opener.
- Normal and insert `jh` jump just past the nearest previous `(`, `[`, `{`, `<`,
  quote, or backtick.
- Normal `0` cycles through first column, first non-space column, last
  non-space column, and last column. Check indented, unindented, blank, and
  trailing-space lines.
- `<Leader>nn` and `<F8>` cycle line numbers.
- `<Leader>nh` toggles search highlighting and reports the new state.
- `<Leader>/` toggles comments on one line and visual selections.
- `<Leader>//` comments without toggling off.
- Visual `p` pastes over a selection without replacing the unnamed register.
- With `let g:omarchy_visual_paste_preserve_register = 0`, visual `p` uses
  native Vim behavior.
- `<Leader>s` alone does nothing; `<Leader>sk` should not edit the buffer.
- Alt-j/k moves lines or visual selections if your terminal sends those keys.
- Visual `<` and `>` keep the visual selection.
- `<C-L>` and `<Leader>rr` refresh the screen.
- `/` searches show the current match position where Vim/Neovim supports
  `shortmess-=S`.
- `<Leader>wm` and `<Leader>ww` maximize the current window and then restore the
  previous tab layout.
- `<Leader>w<Left>`, `<Leader>w<Down>`, `<Leader>w<Up>`, and
  `<Leader>w<Right>` move between windows without relying on browser-sensitive
  `<C-w>`.
- `<Leader>wV` opens the current buffer in a right vertical split.
- `<Leader>bV` picks a buffer and opens it in a right vertical split.
- `<Leader>tt` opens a bottom terminal with `bash --login -i` when Bash is
  available; `echo $0` and login-profile effects should match your normal shell
  expectations.
- In a Python file, `<Leader>zz` toggles all folds open/closed and
  `<Leader>z0` through `<Leader>z9` set fold levels.
- `<Leader>ds` opens a diff against the saved file.
- `<Leader>dg` opens a diff against `HEAD` for a tracked file.
- `<Leader>df` picks a project file to diff against the current buffer.
- `<Leader>db` picks an open buffer to diff against the current buffer.
- `<Leader>dB` creates a 2-4 way diff from open buffers.
- `]c`, `[c`, `<Leader>dn`, and `<Leader>dN` move between diff hunks.
- `do` and `dp` perform native diff get/put merge actions.
- `<Leader>dh` opens diff help.
- Built-in Omarchy diffs show saved/HEAD content on the left and the current
  buffer on the right.
- `q` or `<Leader>dq` closes an Omarchy diff and returns to the original buffer.
- `<Leader>dQ` disables diff mode in the current tab.

### 9. Optional Flags

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

### 10. GitHub Copilot

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

### 11. Sessions

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
- All-maps diagnosis: use `<Leader>fK` or `:OmarchyAllMaps` to inspect every
  live mapping when a key behaves differently from the curated `<Leader>fk`
  reference.
- `Post-update hook for fzf ... /usr/share/vim/vimfiles/install not found` on Arch: update this repo and rerun `:PlugInstall` or `:PlugUpdate fzf`. The config no longer declares an fzf post-install hook.
- `:Rg` fails: install `ripgrep`.
- `<Leader>fr` search scope is surprising: run `:pwd`. The grep fallback
  searches under Vim's current working directory.
- previews are plain text: install `bat`; on Debian the executable is `batcat`.
- visual paste replaced your expected paste text: the config preserves the
  unnamed register for visual `p` by default. Set
  `g:omarchy_visual_paste_preserve_register = 0` before sourcing the config if
  you want native Vim visual paste behavior.
- `<Leader>s` appears to do nothing: that is intentional. It protects the
  session prefix from falling through to Vim's normal `s` editing command.
- terminal startup files are not what you expect: `:OmarchyTerminal` runs
  `bash --login -i` by default when Bash is available. Bash login files follow
  Bash's normal precedence, so a `~/.bash_profile` can prevent `~/.profile` from
  being read unless it sources it. Override with
  `g:omarchy_terminal_command` if your environment needs a different shell.
- ALE has no Python LSP commands: run `:PlugInstall` in the Vim/Neovim instance
  you use and confirm that `:ALEInfo` exists. Installing Python packages does
  not install the ALE editor plugin.
- pylsp is missing: install `python3-pylsp python3-rope` on Debian,
  `python-lsp-server python-rope` on Arch, or
  `~/.venvs/vim-tools/bin/python -m pip install "python-lsp-server[rope]"`
  in the editor tools env, then restart Vim.
- Python tools are installed but ALE cannot see them: run `:ALEInfo` and
  `:OmarchyDebug`, then check `g:omarchy_python_tools_env`, the reported
  candidate paths, and
  `command -v python pylsp pyright-langserver ruff flake8 pylint`.
- Git Bash pylsp navigation fails or stalls: confirm `/usr/bin/bash` and the
  resolved `.venv/Scripts/python.exe` and `pylsp.exe` paths in
  `:OmarchyDebug`. The MSYS adapter is used only for Git Bash Vim with pylsp.
- terminal keys fail: use `:verbose imap <key>` and check terminal/tmux key handling. Insert `<Tab>` after a word is the most reliable manual completion trigger; `<M-/>` is optional and terminal-dependent. `<C-x><C-o>` remains the built-in omnifunc fallback. In browser-hosted terminals that intercept `<C-w>`, use the `<Leader>w...` window maps instead.
- optional plugin maps say a command is unavailable: the flag is probably enabled but `:PlugInstall` has not been rerun yet.
- Copilot commands say the plugin is unavailable: set `g:omarchy_install_copilot = 1` before sourcing `init.vim`, run `:PlugInstall`, restart, then run `:Copilot setup`.
- `:OmarchyCopilotChat` says the CLI is missing: install the separate GitHub Copilot CLI so the `copilot` executable is on `PATH`, or run `copilot` directly from a terminal after installation.
- `:OmarchyCopilotChat` says `:terminal` is unavailable: use an external terminal. Terminal integration is feature-detected and may differ between Vim, Neovim, terminal Vim, GUI Vim, Windows, WSL, and Unix-like shells.


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
