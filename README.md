# Omarchy Vim

Single-file Vim configuration for Vim 9 on Debian 12, with Neovim and Arch support.

The config uses Vimscript, vim-plug, ALE, and optional fzf/fzf.vim. It does not require Node.js, Rust, or Go toolchains unless you opt in to GitHub Copilot. Python is not required to start the editor or use the non-Python features; Python packages are only needed for Python LSP, linting, and formatting.

## Files

- `init.vim`: canonical config.
- `vim_strategy.md`: strategy and risk notes.
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
- `fzf` `0.54.0+`: enables fzf/fzf.vim integration when found on `PATH`.

Python-only tools:

- `python3`/`python`: runtime for Python tooling.
- `pylsp`: Python LSP server used by ALE.
- `black`, `isort`, `flake8`, `pylint`: Python formatters/linters configured in ALE.

Without Python installed, this config should still load and the editor, statusline, keymap reference, comments, diffs, and window/buffer helpers should still work. Python LSP/completion/lint/fix features will be absent or degraded. FZF commands require a current `fzf` executable and are disabled by default when one is not found.

## Version Tables

Versions below were checked from official package pages on 2026-08-06. Debian 12 is stable, while Arch is rolling; use the check commands below to see what your machine actually has.

### Debian 12 Bookworm

| Package | Version | Role | Required? |
| --- | --- | --- | --- |
| `vim` | `2:9.0.1378-2+deb12u2` | primary editor target | yes, unless using Nvim only |
| `neovim` | `0.7.2-7` | optional Nvim target | optional |
| `git` | `1:2.39.5-0+deb12u3` | plugin install + git features | yes |
| `curl` | `7.88.1-10+deb12u15` | vim-plug bootstrap | yes |
| `python3` | `3.11.2-1 and others` | Python tooling runtime | Python only |
| `python3-pylsp` | `1.7.1-1` | Python LSP | Python only |
| `black` | `23.1.0-1` | Python formatter | Python only |
| `isort` | `5.6.4-1` | Python import sorter | Python only |
| `flake8` | `5.0.4-4` | Python linter | Python only |
| `pylint` | `2.16.2-2` | Python linter | Python only |
| `ripgrep` | `13.0.0-4` | text search | recommended |
| `bat` | `0.22.1-4` | fzf previews; executable is `batcat` | recommended |
| `fzf` | `0.38.0-1` | shell fzf only; too old for current `fzf.vim` | do not rely on this for Vim |

Current `fzf.vim` requires fzf `0.54.0+`. Debian 12 packages fzf `0.38.0`, so Debian users should install a current `fzf` binary through another trusted channel if they want Vim FZF commands. The config no longer runs the fzf repository's `./install --bin` hook or enables fzf.vim by default without a current external `fzf`.

### Arch Linux

| Package | Version | Role | Required? |
| --- | --- | --- | --- |
| `vim` | `9.2.0849-1` | Vim target | yes, unless using Nvim only |
| `neovim` | `0.12.4-1` | Nvim target | optional |
| `git` | `2.55.0-1` | plugin install + git features | yes |
| `curl` | `8.21.0-1` | vim-plug bootstrap | yes |
| `python` | `3.14.6-1` | Python tooling runtime | Python only |
| `python-lsp-server` | `1.15.0-1` | Python LSP | Python only |
| `python-black` | `26.5.1-1` | Python formatter | Python only |
| `python-isort` | `9.0.0b1-1` | Python import sorter | Python only |
| `python-flake8` | `1:7.3.0-2` | Python linter | Python only |
| `python-pylint` | `4.0.6-1` | Python linter | Python only |
| `ripgrep` | `15.2.0-1` | text search | recommended |
| `bat` | `0.26.1-2` | fzf previews; executable is `bat` | recommended |
| `fzf` | `0.74.2-1` | shell fzf; new enough for current `fzf.vim` | optional |

Arch's packaged `fzf` is current enough. The config lets vim-plug clone the Vim wrapper only and does not run an fzf binary install hook.

### Git Bash On Windows

Git for Windows includes an MSYS Vim. This config should load there, but FZF integration is not enabled by default unless an external `fzf` `0.54.0+` is already on `PATH`. This avoids fzf.vim's interactive binary download prompt and keeps plugin installation explicit. The non-FZF fallback views, including `:Keymaps` and `<Leader>fk`, remain available.

If a previous run downloaded `~/.vim/plugged/fzf/bin/fzf.exe`, reopen Vim with this config and run:

```vim
:PlugClean
```

Accept removal of `fzf` and `fzf.vim` if they are no longer declared. The config does not treat that plugin-managed binary as an acceptable FZF executable.

If Git Bash still finds that binary, check shell startup files such as `~/.bashrc` and remove any PATH entry pointing at `~/.vim/plugged/fzf/bin`. Inside Vim, run `:OmarchyFzfStatus` to see FZF candidates, the accepted external path, version, and whether FZF integration is usable.

Without FZF, `<Leader>ff`, `<Leader>fg`, `<Leader>fr`, `<Leader>fl`, `<Leader>fs`, and `<Leader>fk` use unfiltered scratch-buffer fallback pickers. Press `<CR>` on an item to open/jump and `q` to close the picker. The fallback prints a reminder to install external `fzf` `0.54.0+` on `PATH` and rerun `:PlugInstall` for interactive filtering.

## Check What Is Installed

### Debian/Ubuntu Style

Check package install status and versions:

```sh
dpkg-query -W -f='${binary:Package}\t${Version}\n' \
  vim neovim git curl python3 python3-pylsp black isort flake8 pylint ripgrep bat fzf \
  2>/dev/null || true
```

Check commands on `PATH`:

```sh
for cmd in vim nvim git curl python3 pylsp black isort flake8 pylint rg batcat bat fzf; do
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
  vim neovim git curl python python-lsp-server python-black python-isort \
  python-flake8 python-pylint ripgrep bat fzf \
  2>/dev/null || true
```

Check commands on `PATH`:

```sh
for cmd in vim nvim git curl python pylsp black isort flake8 pylint rg bat fzf; do
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
sudo apt install vim git curl python3-pylsp black isort flake8 pylint ripgrep bat
```

### Debian 12: Vim And Neovim Plus Python Support

```sh
sudo apt update
sudo apt install vim neovim git curl python3-pylsp black isort flake8 pylint ripgrep bat
```

`python3-pynvim` is not required for this config because the config is Vimscript and does not use Python-hosted Neovim plugins. Install it only if you add plugins later that require Neovim's Python provider.

### Arch: Vim Only

```sh
sudo pacman -S --needed vim git curl ripgrep bat fzf
```

### Arch: Vim Plus Python Support

```sh
sudo pacman -S --needed \
  vim git curl ripgrep bat fzf \
  python-lsp-server python-black python-isort python-flake8 python-pylint
```

### Arch: Vim And Neovim Plus Python Support

```sh
sudo pacman -S --needed \
  vim neovim git curl ripgrep bat fzf \
  python-lsp-server python-black python-isort python-flake8 python-pylint
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

### Vim Wrapper With Optional Plugin Flags

Use a wrapper if you want to enable optional plugins without editing `init.vim`:

```sh
cat > ~/.vimrc <<EOF
let g:omarchy_use_gitgutter = 1
let g:omarchy_use_fugitive = 1
execute 'source ' . fnameescape('$DOTFILES/omarchy/vim/init.vim')
EOF
```

Normal startup remains:

```sh
vim
vim path/to/file.py
```

### Neovim Wrapper With Optional Plugin Flags

For Neovim, the wrapper goes at `~/.config/nvim/init.vim`:

```sh
mkdir -p ~/.config/nvim
cat > ~/.config/nvim/init.vim <<EOF
let g:omarchy_use_gitgutter = 1
let g:omarchy_use_fugitive = 1
execute 'source ' . fnameescape('$DOTFILES/omarchy/vim/init.vim')
EOF
```

Normal startup remains:

```sh
nvim
nvim path/to/file.py
```

### Install Vim Plugins

The safe first-run order is:

1. Install platform packages first. At minimum install `vim`, `git`, and `curl`. Install `fzf` `0.54.0+` before opening Vim if you want FZF integration enabled on first plugin install.
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
- fzf/fzf.vim are declared by default only when external `fzf` `0.54.0+` is already on `PATH`.
- Copilot, gitgutter, and fugitive are declared only when their flags are set before sourcing `init.vim`.

Close and reopen the editor after plugin installation. If you install `fzf` later, reopen Vim and run `:PlugInstall` again so vim-plug sees the updated plugin list. If you enabled optional plugins after the first install, run `:PlugInstall` again so vim-plug installs them.

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

Optional plugins are off by default:

- `g:omarchy_use_fzf = 1` requests `junegunn/fzf` and `junegunn/fzf.vim`. If external `fzf` `0.54.0+` is not found on `PATH`, the config resets this to `0`, shows a warning, and uses the fallback views. By default this is enabled automatically when `fzf` `0.54.0+` is found.
- `g:omarchy_use_gitgutter = 1` enables `airblade/vim-gitgutter` for added/changed/removed signs.
- `g:omarchy_use_fugitive = 1` enables `tpope/vim-fugitive` for `:Git`, `:Git blame`, and `:Gdiffsplit`.
- `g:omarchy_install_copilot = 1` installs `github/copilot.vim` for optional inline suggestions. It requires Vim 9.0.0185+ or Neovim 0.6+ and Node.js.
- `g:omarchy_copilot_suggestions_start_enabled = 1` starts automatic Copilot inline suggestions enabled. The default is `0`.
- `g:omarchy_enable_copilot_cli_mapping = 1` enables `<Leader>ac` to open the separate GitHub Copilot CLI in a terminal split. The default is `0`.
- `g:omarchy_python_format_imports = 0` formats Python with `black` only. The default is `1`, which runs `isort` and then `black`.
- `g:omarchy_python_keyword_completion = 0` disables automatic native Python keyword completion.
- `g:omarchy_python_keyword_completion_min_chars = 3` controls how many typed keyword characters are needed before the Python fallback menu opens automatically.
- `g:omarchy_python_keyword_completion_max_lines = 5000` disables automatic Python keyword popup completion in larger buffers. Manual completion still works.

Set the flags before `source .../init.vim`. The wrapper examples above are the preferred way for both Vim and Neovim. Do not put the flags after the `source` line; by then the plugin list has already been built.

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

`<Leader>` is Space.

## Completion Usage

Python buffers have three completion paths:

- The config's Python `completefunc` scans the current buffer with exact-case matching, so typing `hel` can show a local `hello` without also matching `Hello`.
- A Python dictionary file at `omarchy/vim/python-complete.txt` feeds keywords/builtins into that same completion function, so typing `imp` can show `import`. The config resolves symlinked startup files back to the real repo path and has a small keyword fallback if the dictionary file is unavailable.
- ALE/LSP completion remains configured through omnifunc and `:ALEComplete` when `pylsp` is installed and running.

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

Inline suggestions use GitHub's official `github/copilot.vim` plugin. Enable plugin installation before sourcing this config:

```vim
let g:omarchy_install_copilot = 1
```

Then start Vim or Neovim and install plugins:

```vim
:PlugInstall
```

Restart the editor, then authenticate the plugin:

```vim
:Copilot setup
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

Expected: `:OmarchyPlugBootstrap` installs vim-plug if needed, and `:PlugInstall` installs ALE. It installs fzf/fzf.vim only when a current external `fzf` is found. Setting `g:omarchy_use_fzf = 1` without external `fzf` `0.54.0+` should produce a warning and reset FZF integration to fallback mode. No plugin post-install hook should run the fzf binary installer. Node, Rust, and Go toolchains should not be installed or required unless you opted in to Copilot.

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

### 4. Python ALE

Skip this section if you intentionally installed no Python support.

Create a small test file:

```sh
mkdir -p /tmp/omarchy-vim-test
cat >/tmp/omarchy-vim-test/sample.py <<'PY'
import os

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

- `:ALEInfo` shows `pylsp`, `flake8`, and `pylint` for Python.
- diagnostics appear if the tools report issues.
- `:ALEFix` runs `isort` and `black` by default, or only `black` when `g:omarchy_python_format_imports = 0`.

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
- `g:omarchy_use_fzf was set to 1...`: the config did not find external `fzf` `0.54.0+` on `PATH`, so it reset FZF integration to `0` for this session and will use fallback views.
- FZF diagnosis: run `:OmarchyFzfStatus` inside Vim.
- Keymap picker diagnosis: after pressing `<Leader>fk`, run `:OmarchyDebug` to see whether the picker entered FZF or fallback.
- `Post-update hook for fzf ... /usr/share/vim/vimfiles/install not found` on Arch: update this repo and rerun `:PlugInstall` or `:PlugUpdate fzf`. The config no longer declares an fzf post-install hook.
- `:Rg` fails: install `ripgrep`.
- previews are plain text: install `bat`; on Debian the executable is `batcat`.
- ALE has no Python LSP: install `python3-pylsp` on Debian or `python-lsp-server` on Arch, then restart Vim.
- Python tools are installed but ALE cannot see them: check `:ALEInfo` and `command -v pylsp black isort flake8 pylint`.
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
