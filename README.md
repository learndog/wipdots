# Omarchy Vim

Single-file Vim configuration for Vim 9 on Debian 12, with Neovim, Arch, and
Git Bash support.

The config uses Vimscript, vim-plug, ALE, and optional fzf/fzf.vim. Node.js is
needed only for the optional Pyright or GitHub Copilot profiles. Rust and Go
toolchains are not required. Python is needed only for Python language-server,
linting, and formatting features; the editor and native completion fallback
still work without it.

## Install And Setup

Install, dependency, wrapper, plugin, upgrade, and removal instructions live in [INSTALL_INSTRUCTIONS.md](INSTALL_INSTRUCTIONS.md).

Daily-use reference stays in this README:

- [User Feature Reference](#user-feature-reference)
- [Main Keys](#main-keys)
- [Python Tooling](#python-tooling)
- [Other Filetypes](#other-filetypes)
- [Project Grep And Finders](#project-grep-and-finders)
- [Current File Symbols](#current-file-symbols)
- [Quickfix Navigation](#quickfix-navigation)
- [Diffs](#diffs)
- [Test Matrix](#test-matrix)
- [Troubleshooting](#troubleshooting)

## User Feature Reference

Use this as the short map of what the config can do. The sections below provide
the detailed behavior, caveats, and setup notes.

| Feature | Main keys / commands | Details |
| --- | --- | --- |
| Open-buffer picker | `<Leader><Leader>` / `<Space><Space>`, `:OmarchyBuffers` | Uses FZF when available; otherwise uses a built-in scratch picker. |
| Right-split opening | `<Leader>wV`, `<Leader>fV`, `<Leader>bV` | Open the current buffer, a picked file, or a picked buffer in a right vertical split. |
| File explorer | `<Leader>ee`, `<Leader>eE`, `<Leader>eh` | Built-in far-left Netrw tree, no plugin required. |
| Project/file search | `<Leader>ff`, `<Leader>fg`, `<Leader>fr`, `<Leader>fl`, `<Leader>fs`, `:OmarchyGrep` | FZF-backed when available, with documented fallbacks for supported pickers. |
| Symbols | `<Leader>fs`, `:Symbols`, `:PythonSymbols` | Current-file symbol picker; Python class/function support is preserved. |
| Keymap lookup | `<Leader>fk`, `<Leader>fK`, `:Keymaps`, `:OmarchyAllMaps` | Shows config-defined maps and all live Vim mappings. |
| Python LSP actions | `<Leader>ld`, `<Leader>lr`, `<Leader>lh`, `<Leader>ln`, `<Leader>la` | ALE-backed definition, references, hover, rename, and code actions. |
| Diagnostics and quickfix | `<Leader>lj`, `<Leader>lk`, `<Leader>lf`, `<Leader>li`, `]q`, `[q`, `<Leader>lq` | ALE diagnostics plus Vim quickfix navigation. |
| Insert completion | `<Tab>`, `<S-Tab>`, `<CR>`, `<M-/>`, `<C-x><C-o>` | Native/ALE completion, with optional Copilot kept separate. |
| Delimiter jumps | `jl`, `jh` in normal or insert mode | Jump around brackets and quotes, useful with auto-pairs. |
| Jump history | `<C-o>`, `<C-i>`, `''`, `` `. `` | Built-in Vim jumps to older/newer positions, including across files. |
| Line-position cycle | Normal `0` | Cycles first column, first text, last text, and last column. |
| Display/status toggles | `<Leader>nn`, `<F8>`, `<Leader>nh` | Cycle line numbers, toggle search highlighting, and color the statusline mode label. |
| Comments and line moves | `<Leader>/`, `<Leader>//`, `<M-j>`, `<M-k>` | Toggle/force comments and move lines/selections. |
| Visual paste | visual `p` | Paste over a selection without replacing the unnamed register, unless disabled. |
| Browser-safe windows | `<Leader>w...`, especially `<Leader>wm` / `<Leader>ww` | Split, focus, close, resize, and maximize without relying on `<C-w>`. |
| Folding | `<Leader>zz`, `<Leader>z0`-`<Leader>z9` | Built-in folds; Python uses indent folding. |
| Terminal | `<Leader>tt`, `<Leader>tT`, `:OmarchyTerminal` | Opens a project-aware login Bash terminal when Bash is available. |
| Built-in diffs | `<Leader>ds`, `<Leader>dg`, `<Leader>df`, `<Leader>db`, `<Leader>dB`, `<Leader>dq` | Saved/HEAD/file/buffer diff helpers plus 2-4 way buffer diffs. |
| Interactive merge help | `<Leader>dh`, `<Leader>dn`, `<Leader>dN`, `<Leader>du`, `<Leader>dQ` | Documents and aliases native diff hunk navigation and merge commands. |
| Git and blame | `<Leader>gb`, `<Leader>gg`, `<Leader>gd`, `<Leader>gh`, `<Leader>gs`, `<Leader>gu` | Fugitive/gitgutter integrations when enabled, with blame fallback. |
| Sessions | `<Leader>s`, `<Leader>ss`, `<Leader>sr`, `<Leader>sl`, `<Leader>sd` | Built-in sessions; bare `<Leader>s` is a guard that does nothing. |
| Persistence | `undofile`, `autoread`, `checktime` | Persistent undo and external file-change checks using built-in Vim features. |
| Plugin policy | `:OmarchyPluginPolicy`, `:OmarchyPlugCheckUpdates` | Manual plugin actions only; update check is read-only. |
| Copilot, optional | `<Leader>at`, `<Leader>as`, `<Leader>ac`, insert `<C-J>` | Available only when the relevant Copilot flags/tools are enabled. |

`<Leader>` is Space. For a complete flat list of mappings, use the table below
or run `<Leader>fk` inside Vim.

## Main Keys

| Key | Action |
| --- | --- |
| `<Space><Space>` / `<Leader><Leader>` | pick open buffer; uses FZF when available, otherwise a built-in scratch picker |
| `<Leader>bV` | pick an open buffer and open it in a right vertical split |
| `<Leader>ee` | toggle the left file explorer |
| `<Leader>eE` | reveal the current file's directory in the explorer |
| `<Leader>eh` | open Netrw file explorer help |
| `<Leader>ff` | find project files |
| `<Leader>fV` | find a project file and open it in a right vertical split |
| `<Leader>fg` | find git-tracked files |
| `<Leader>fr` | search text recursively under Vim's current working directory |
| `<Leader>fl` | search current-buffer lines |
| `<Leader>fs` | list current-file symbols; Python classes/functions use the preserved `:PythonSymbols` implementation |
| `<Leader>fk` | show config keymap reference |
| `<Leader>fK` | show all live key mappings |
| `<Leader>ld` | ALE go to definition |
| `<Leader>lr` | ALE find references |
| `<Leader>lh` | ALE hover |
| `<Leader>ln` | ALE rename |
| `<Leader>la` | ALE code action |
| `<Leader>lj` | next ALE diagnostic |
| `<Leader>lk` | previous ALE diagnostic |
| `<Leader>lf` | run ALE fixers |
| `<Leader>li` | show ALE info |
| `]q` | next quickfix item |
| `[q` | previous quickfix item |
| `]Q` | last quickfix item |
| `[Q` | first quickfix item |
| `<Leader>lq` | open quickfix list |
| `<Leader>lc` | close quickfix list |
| `<Leader>at` | toggle Copilot inline suggestions, when `g:omarchy_install_copilot = 1` |
| `<Leader>as` | request a Copilot inline suggestion, when `g:omarchy_install_copilot = 1` |
| `<Leader>ac` | open Copilot CLI, when `g:omarchy_enable_copilot_cli_mapping = 1` |
| Python insert text | show Python completions after 3 typed characters |
| Insert `<Tab>` | complete after a word, otherwise insert a tab |
| Insert `<S-Tab>` | previous completion menu item |
| Insert `<CR>` | accept visible completion menu item |
| Insert `<M-/>` | trigger completion |
| Insert `<C-J>` | accept Copilot inline suggestion, when `g:omarchy_install_copilot = 1` |
| Normal/insert `jl` | jump just past the next closing bracket or quote |
| Normal/insert `jh` | jump just past the nearest previous left bracket or quote |
| `<C-o>` | jump to older cursor position in the jumplist, across files |
| `<C-i>` | jump to newer cursor position in the jumplist; same keycode as `<Tab>` in some terminals |
| `''` | jump to the previous cursor position's line |
| `` `. `` | jump to the exact previous cursor position |
| `g;` | jump to older change position |
| `g,` | jump to newer change position |
| Normal `0` | cycle first column, first text, last text, and last column |
| `<Leader>nn` / `<F8>` | cycle line-number display |
| `<Leader>nh` | toggle search highlighting |
| `<C-L>` | refresh screen |
| `<Leader>rr` | refresh screen |
| `<Leader>/` | toggle comment |
| `<Leader>//` | force comment |
| Visual `p` | paste over selection without replacing the unnamed register |
| `<Leader>tt` | toggle a project-aware login Bash terminal |
| `<Leader>tT` | open a new project-aware login Bash terminal |
| `<Leader>wh` / `<Leader>wv` | open a vertical split |
| `<Leader>wV` | open the current buffer in a right vertical split |
| `<Leader>wj` / `<Leader>ws` | open a horizontal split |
| `<Leader>w<Left>` | focus the window to the left |
| `<Leader>w<Down>` | focus the window below |
| `<Leader>w<Up>` | focus the window above |
| `<Leader>w<Right>` | focus the window to the right |
| `<Leader>wp` | close preview window |
| `<Leader>wm` / `<Leader>ww` | toggle current-window maximize |
| `<Leader>wc` | close window |
| `<Leader>wo` | keep only current window |
| `<Leader>zz` | toggle all folds open or closed |
| `<Leader>z0`-`<Leader>z9` | set fold level 0-9 |
| `<Leader>gb` | show git blame; uses fugitive when available, otherwise git CLI fallback |
| `K` | show the blamed commit's short hash and subject, inside a Fugitive blame buffer |
| `<Leader>gg` | open fugitive Git status, when `g:omarchy_use_fugitive = 1` |
| `<Leader>gd` | open fugitive diff split, when `g:omarchy_use_fugitive = 1` |
| `<Leader>gh` | preview gitgutter hunk, when `g:omarchy_use_gitgutter = 1` |
| `<Leader>gs` | stage gitgutter hunk, when `g:omarchy_use_gitgutter = 1` |
| `<Leader>gu` | undo gitgutter hunk, when `g:omarchy_use_gitgutter = 1` |
| `<Leader>ds` | diff against saved file |
| `<Leader>dg` | diff against git HEAD |
| `<Leader>df` | pick a project file to diff against the current buffer |
| `<Leader>db` | pick an open buffer to diff against the current buffer |
| `<Leader>dB` | pick open buffers for a 2-4 way diff |
| `<Leader>dh` | show diff and merge help |
| `<Leader>dn` | next diff hunk |
| `<Leader>dN` | previous diff hunk |
| `<Leader>du` | update diff view |
| `<Leader>dq` | close active Omarchy diff or disable diff mode |
| `<Leader>dQ` | turn off diff mode in the current tab |
| `<Leader>s` | session prefix guard; intentionally does nothing |
| `<Leader>ss` | save current session |
| `<Leader>sr` | restore a saved session |
| `<Leader>sl` | list saved sessions |
| `<Leader>sd` | delete a saved session |

`<Leader>` is Space.


## Python Tooling

ALE provides Python editor integration when the optional Python tools are installed. Daily Python workflow:

- `<Leader>ld`: go to definition.
- `<Leader>lr`: find references through quickfix.
- `<Leader>lh`: hover.
- `<Leader>ln`: rename symbol.
- `<Leader>la`: code action.
- `<Leader>lj` / `<Leader>lk`: next/previous diagnostic.
- `<Leader>lf`: run configured fixers.
- `<Leader>li`: show `:ALEInfo`.
- `<Leader>fs`: current-file symbols; Python uses the preserved `:PythonSymbols` scanner.

Native buffer/dictionary completion remains available without ALE or Python. With Python tooling installed, ALE/LSP completion is also available through omnifunc and `:ALEComplete`. In insert mode, `<Tab>` completes after a word, `<S-Tab>` moves backward through the popup menu, `<CR>` accepts a visible completion menu item, and `<M-/>` triggers completion manually.

Detailed Python setup, dependency profiles, editor-tools env guidance, project-env detection, MSYS/Git Bash notes, and all Python settings are in [INSTALL_INSTRUCTIONS.md](INSTALL_INSTRUCTIONS.md#python-tooling-setup).
## Other Filetypes

Vim filetype plugins and syntax highlighting are enabled globally with:

```vim
filetype plugin indent on
syntax enable
```

The config adds a small amount of filetype help for common names:

- `*.bash` is treated as Bash.
- `*.bq.sql` and `*.bigquery.sql` are treated as SQL for BigQuery-oriented files.

Markdown, Bash, SQL, Lua, Vimscript, TypeScript, HTML, CSS, and JavaScript use
Vim's built-in filetype/syntax support where available. Comment toggling also
knows about Markdown/HTML comments, SQL `--`, Lua `--`, Vimscript `"`, shell
`#`, and common `//` languages.

ALE support beyond Python is optional and tool-detected. If these commands are
already on `PATH`, the config wires them into ALE defaults:

| Filetype | Optional diagnostics | Optional fixer |
| --- | --- | --- |
| Shell/Bash | `shellcheck` | `shfmt` |
| SQL/BigQuery | `sqlfluff` | `sqlfluff` |
| Lua | `luacheck` | none by default |
| Vimscript | `vint` | none by default |

No new language tool is required to start Vim. TypeScript, HTML, CSS, and
JavaScript LSP support is not enabled by default because practical language
servers for those filetypes generally require Node.js.

## Editing Navigation Helpers

`jl` and `jh` are no-plugin delimiter jumps for both normal and insert mode.
They are intended for auto-pair workflows, but work as general line/file
navigation helpers.

- `jl` jumps just past the next closing delimiter: `)`, `]`, `}`, `>`, `"`,
  `'`, or backtick.
- `jh` jumps just past the nearest previous left delimiter: `(`, `[`, `{`, `<`,
  `"`, `'`, or backtick.
- Searches do not wrap. If there is no matching delimiter in the requested
  direction, the cursor stays where it was.

Normal-mode `0` intentionally overrides Vim's default first-column motion. It
cycles through first column, first non-space column, last non-space column, and
last column. Use `^`, `g_`, and `$` directly when you want Vim's individual
native motions.

Vim also keeps a native jump history that works across files. Use `<C-o>` to
move to older cursor positions and `<C-i>` to move forward again. `''` jumps to
the previous cursor position's line, while `` `. `` jumps to the exact previous
position. For edit locations rather than cursor jumps, use `g;` for older
changes and `g,` for newer changes. Some terminals send the same keycode for
`<C-i>` and `<Tab>`, so `<C-i>` may be terminal-dependent.

## Display Toggles

`<Leader>nn` and `<F8>` cycle line-number display between absolute plus
relative numbers, absolute numbers only, and no numbers. `<Leader>nh` toggles
search highlighting and echoes the new state. The config also runs
`set shortmess-=S` at the end where supported, so `/` and `?` searches show the
current match position.

The statusline colors only the mode label when
`g:omarchy_statusline_mode_colors = 1`, which is the default:

- NORMAL: light gray.
- INSERT: orange.
- VISUAL, V-LINE, and V-BLOCK: blue.
- Other modes: green.

Set this before sourcing `init.vim` to keep the mode label uncolored:

```vim
let g:omarchy_statusline_mode_colors = 0
```

## Key Timing

Multi-key mappings use explicit timing settings:

```vim
let g:omarchy_timeoutlen = 350
let g:omarchy_ttimeoutlen = 50
```

`timeoutlen` controls how long Vim waits for mapping sequences such as `jj`,
`jk`, `jl`, `jh`, `<Leader>fk`, and `<Leader>ss`. Practical values:

- Fast: `250`-`300`
- Medium: `400`-`500`
- Slow: `700`-`1000`

`ttimeoutlen` controls terminal key-code timing for keys such as Escape,
arrows, and Alt/meta combinations. Keep it shorter than `timeoutlen` so terminal
keys remain responsive.

## Persistence And External Changes

When Vim supports persistent undo, this config enables `undofile` and stores
undo history under a Vim/Neovim data undo directory. That means you can close a
file, reopen it later, and still undo previous edits. Undo files are editor
metadata; they do not change the file being edited.

The config also enables `autoread` and calls `checktime` on focus changes,
buffer entry, and `CursorHold`. `autoread` reloads a buffer when the file
changed on disk and the buffer has no unsaved local edits. `checktime` is the
explicit check that notices those external changes. If a buffer has unsaved
local edits, Vim should warn rather than silently replacing your work.

## Visual Paste

Visual `p` is configured to paste over the selected text without replacing the
unnamed register. This makes repeated replacement paste work as expected: yank
once, select text, press `p`, select another range, press `p` again, and paste
the same original text.

Native Vim visual paste replaces the selection and stores the replaced text in
the unnamed register. That native behavior is useful sometimes, but it often
surprises users who expect paste text to stay reusable. To restore native visual
paste behavior:

```vim
let g:omarchy_visual_paste_preserve_register = 0
```

The comment mappings were checked for conflicts and are already present in both
normal and visual mode:

```text
<Leader>/   toggle comment
<Leader>//  force comment
```

## Windows And Folds

The window maps under `<Leader>w` provide browser-safe alternatives for common
`<C-w>` workflows. This matters in browser-hosted terminals such as GCP
JupyterLab, where `<C-w>` may be intercepted by the browser.

`<Leader>wm` and `<Leader>ww` toggle a no-plugin current-window maximize. The
first press stores the current tab layout and maximizes the active window; the
second press restores the stored layout. Existing Alt-arrow resize maps remain
available when the terminal sends those keys.

Right-split helpers:

```text
<Leader>wV  open the current buffer in a right vertical split
<Leader>fV  pick a project file and open it in a right vertical split
<Leader>bV  pick an open buffer and open it in a right vertical split
```

The file and buffer pickers use FZF when available and built-in scratch picker
fallbacks otherwise.

## Terminal

`<Leader>tt` toggles a bottom terminal, and `<Leader>tT` opens a new one. The
stable command forms are:

```vim
:OmarchyTerminal
:OmarchyTerminalToggle
```

When Bash is available, the default terminal command is:

```vim
let g:omarchy_terminal_command = 'bash --login -i'
```

That starts an interactive login Bash shell, matching the startup path used by
normal Linux terminals, GCP Debian JupyterLab terminal sessions, and Git Bash.
In Bash terms, login startup files such as `~/.bash_profile`,
`~/.bash_login`, or `~/.profile` are handled by Bash's normal rules. If your
login profile sources `~/.bashrc`, the terminal inside Vim will see that setup
too.

Terminal working directory selection is controlled by:

```vim
let g:omarchy_terminal_root_strategy = 'project'
let g:omarchy_terminal_height = 15
```

Root strategies:

- `'project'`: current buffer's git root, then current buffer directory, then
  Vim's current working directory.
- `'buffer'`: current buffer directory, then Vim's current working directory.
- `'cwd'`: always Vim's current working directory.

If Bash is unavailable, set `g:omarchy_terminal_command` before sourcing the
config or use an external terminal.

## Folding

Folding uses built-in Vim folding. Python buffers use indent folds, startup
keeps folds open with `foldlevelstart=99`, and native fold keys such as `za`,
`zR`, and `zM` are preserved. Omarchy adds:

```vim
:OmarchyToggleAllFolds
:OmarchyFoldLevel 0
```

`<Leader>zz` toggles all folds open/closed. `<Leader>z0` through `<Leader>z9`
set `foldlevel`. ALE, pylsp, and Pyright may expose language-server folding
data, but this config intentionally keeps folding built-in and maintainable.

## File Explorer

The file explorer uses Vim's built-in Netrw. It is configured as a simple
far-left tree panel with the full Netrw banner hidden. It requires no plugin,
FZF, Node.js, or shell command, and works in Vim and Neovim.

Global maps and commands:

| Key / Command | Action |
| --- | --- |
| `<Leader>ee` / `:FileExplorer` | Toggle the far-left explorer. In a git worktree it starts at the git root; otherwise it starts at the current file's directory or `:pwd`. By default focus returns to the editing window. |
| `<Leader>eE` / `:FileExplorerReveal` | Open the explorer at the current file's directory and search to the current file name. |
| `<Leader>eh` / `:FileExplorerHelp` | Open Netrw's quick map help. |

No bare `e` or `ee` normal-mode map is installed. Vim's native `e` motion keeps
its default behavior.

Inside the explorer:

| Key | Action |
| --- | --- |
| `<CR>` or `l` | Open the file under the cursor, or expand/collapse a directory. Files open in the previous editing window. |
| `h` or `-` | Go up one directory. |
| `/` | Search names in the visible Netrw listing. Use `n` and `N` for next/previous match. |
| `R` or `<C-L>` | Refresh the listing. `R` is refresh here, not rename. |
| `?` | Open Netrw quick map help. |
| `<F1>` | Open the full Netrw help. |
| `q` | Close the explorer. |

The explorer intentionally disables several Netrw file-operation keys in its
buffer: `D`, `<Del>`, `d`, `%`, `x`, `O`, `m`, and `cd`. These cover common
delete, create, execute/obtain, mark-prefix, and current-directory-changing
paths that are easy to hit by accident. Use explicit Ex commands after reading
`:help netrw` if you intentionally want those Netrw operations.

Default Netrw settings:

```vim
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_altfile = 1
let g:netrw_winsize = -30
let g:netrw_keepdir = 1
```

You can override these before sourcing `omarchy/vim/init.vim`. Negative
`g:netrw_winsize` values are treated as fixed columns; the default is a
30-column left panel.

Use this if you want `<Leader>ee` to leave focus in the tree after opening it:

```vim
let g:omarchy_file_explorer_focus = 1
```

> Ref: https://vimhelp.org/pi_netrw.txt.html

## Project Grep And Finders

`<Leader>fr` and `:OmarchyGrep` provide project-wide text search from Vim's
current working directory. With FZF, fzf.vim, and `rg` available, this uses
fzf.vim's `:Rg`. Without FZF, it prompts for a pattern and opens matching
`rg --vimgrep` or recursive `grep` results in a scratch picker.

Check the current search scope with:

```vim
:pwd
```

Change scope with Vim's normal `:cd` or start Vim from the desired project
directory. File finders:

```text
<Leader>ff  find project files
<Leader>fg  find git-tracked files
<Leader>fV  find project file and open in right vertical split
<Leader>fl  search current-buffer lines
```

Inside FZF prompts you can use FZF's exact-search syntax:

```text
'term   exact contains match
^term   exact prefix match
term$   exact suffix match
!term   inverse exact match
```

## Current File Symbols

`<Leader>fs` runs `:Symbols`, a lightweight current-file symbol picker. It uses
FZF when available and a scratch picker otherwise. It is regex-based and does
not require LSP, Tree-sitter, ctags, Node.js, Rust, or Go.

Python support is preserved through the existing `:PythonSymbols` implementation:
it finds `class`, `def`, and `async def` lines and jumps to the selected line.
`:PythonSymbols` remains available directly and does not fail badly in a
non-Python file; it simply reports when no Python-style symbols are found.

`:Symbols` currently adds conservative detectors for Vimscript, Lua, shell,
JavaScript, TypeScript, and Markdown headings. If a filetype has no detector or
no matches, it reports that clearly instead of pretending to provide a semantic
outline.

## Keymap Lookup

There are two keymap browsers:

```text
<Leader>fk  :Keymaps          config-declared maps from MAP: comments
<Leader>fK  :OmarchyAllMaps   all live mappings from :verbose map
```

Use `<Leader>fk` for the curated Omarchy cheat sheet. Use `<Leader>fK` when you
need to debug every active Vim mapping, including plugin and filetype mappings.

## Quickfix Navigation

Quickfix is Vim's built-in list for locations. This config uses it for
LSP references by default, and other Vim commands may use it for grep results,
compiler errors, test failures, or diagnostics.

When you run `<Leader>lr`, ALE asks the Python LSP for references, writes all
returned locations to the quickfix list, and jumps to the first item. Open the
list with `<Leader>lq` to see all references. Move through them with `]q` and
`[q`; jump to the last or first item with `]Q` and `[Q`. Close the list with
`<Leader>lc`.

Equivalent built-in commands:

```vim
:copen
:cnext
:cprevious
:clast
:cfirst
:cclose
```

## Diffs

Built-in Omarchy diffs do not require Fugitive:

```vim
:DiffSaved
:DiffGitHead
:DiffFile
:DiffBuffer
:DiffBuffers
:DiffHelp
:DiffClose
:DiffOff
```

`<Leader>ds` opens a diff between the saved file and the current buffer.
`<Leader>dg` opens a diff between git `HEAD` and the current buffer for tracked
files. These Omarchy diff windows place the saved/HEAD base on the left and the
current buffer on the right, matching the common old-left/new-right side-by-side
layout. Close the active Omarchy diff with `q` from the scratch diff window or
`<Leader>dq` from either side.

Additional built-in diff helpers:

| Key / Command | Action |
| --- | --- |
| `<Leader>df` / `:DiffFile` | Pick a project file and open a side-by-side diff against the current buffer. |
| `<Leader>db` / `:DiffBuffer` | Pick an open buffer and diff it against the current buffer. |
| `<Leader>dB` / `:DiffBuffers` | Diff the current buffer with 1-3 selected open buffers in a new tab. |
| `<Leader>dh` / `:DiffHelp` | Open a scratch help buffer for diff and merge commands. |
| `<Leader>dq` / `:DiffClose` | Close an Omarchy scratch diff when active, otherwise turn off diff mode in the current tab. |
| `<Leader>dQ` / `:DiffOff` | Turn off diff mode in the current tab. |

For 3- or 4-way diffs, open the files first so they are listed buffers, then
run `<Leader>dB`. This keeps the workflow simple and avoids a complicated
multi-file filesystem picker. Multi-window diffs are most readable with two or
three files; four files need a wide terminal and short lines.

Native Vim diff navigation and merge commands remain the core merge workflow:

```text
]c  next diff hunk
[c  previous diff hunk
do  obtain change from the other window (:diffget)
dp  put change into the other window (:diffput)
```

Omarchy adds these aliases without replacing the native keys:

```text
<Leader>dn  next diff hunk
<Leader>dN  previous diff hunk
<Leader>du  :diffupdate
<Leader>dQ  :diffoff!
```

When Fugitive is enabled with `g:omarchy_use_fugitive = 1`, `<Leader>gd` still
runs Fugitive's `:Gdiffsplit`. Fugitive owns that command's detailed behavior.

## Git And Blame

`<Leader>gb` shows blame for the current tracked file.

When Fugitive is installed, `<Leader>gb` runs:

```vim
:Git blame
```

Fugitive opens an interactive blame split. The blamed lines are aligned with
the current file; move in the file or blame window to inspect commits. Use
Fugitive's normal help from inside that window with `g?`. That is Fugitive's
own help mapping, so this config does not reuse it for commit summaries.

Inside a Fugitive blame window:

```text
K    echo the blamed commit's short hash and one-line subject
<CR> open the full commit/patch for the blamed line
g?   open Fugitive's blame help
gq   close the blame view
```

The blame column itself stays compact: commit hash, author, and timestamp fit
there reasonably well, but commit subjects often make the split too wide to be
useful. Use `K` when you only need the oneline subject for the current line.
Use `<CR>` when you need the commit message, diff, or surrounding patch.
Close the blame window like a normal Vim split with `:close` or the window
keymaps.

When Fugitive is not installed, `<Leader>gb` falls back to:

```sh
git blame --date=short -w -- current-file
```

The fallback opens an unfiltered scratch buffer with the blame output. It is
not as interactive as Fugitive, but it works without any Vim git plugin.

FZF does not control blame. FZF affects picker commands such as file search,
git-tracked file search, text search, buffer selection, symbols, sessions, and
keymap lookup. Blame is either Fugitive-backed or plain Git CLI-backed.

Fugitive-only mappings:

```text
<Leader>gg  Git status
<Leader>gd  Fugitive diff split
```

Gitgutter mappings are separate from blame:

```text
<Leader>gh  preview current hunk
<Leader>gs  stage current hunk
<Leader>gu  undo current hunk
```

## Sessions

Session save/restore is built into this config using Vim's `:mksession` and `:source`; no plugin is required.

Sessions are stored as `.vim` files in `~/.vim/sessions` by default. Override with `g:omarchy_session_dir` before sourcing `init.vim`. Sessions are enabled by default; set `g:omarchy_use_sessions = 0` before sourcing `init.vim` to disable the commands and keymaps below.

Usage:

- `<Leader>s` alone intentionally does nothing. It is a guard for the session
  prefix so a mistyped session key does not fall through to Vim's normal `s`
  substitute command and enter insert mode.
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

Upgrade and plugin-update instructions are in
[INSTALL_INSTRUCTIONS.md](INSTALL_INSTRUCTIONS.md#upgrade). The short version:
`:OmarchyPlugCheckUpdates` checks availability without changing local plugin
repos, and `:PlugUpdate` performs a manual plugin update.

## Removal

Removal instructions are in
[INSTALL_INSTRUCTIONS.md](INSTALL_INSTRUCTIONS.md#removal).
