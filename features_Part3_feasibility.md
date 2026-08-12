# Features Part 3 Feasibility

Status: preliminary analysis only. Do not implement these items until reviewed.

Scope:

- Current-buffer path visibility in the statusline or nearby UI.
- IDE-like editor tabs.
- Debug/DAP support and UI.

## Recommendation Summary

- Current-buffer path: implement a simple path reveal first. The lowest-risk
  feature is a command/key that echoes the full current buffer path and copies it
  to a register or clipboard when available. A statusline full-path toggle is
  also feasible, but less important because it consumes horizontal space.
- IDE-like tabs: do not make one Vim tabpage per buffer. That fights Vim's model.
  If desired, implement or install a bufferline/tabline that displays buffers as
  editor tabs while keeping Vim tabpages available for layouts.
- Debug support: feasible only as optional functionality. For Vim and Neovim
  compatibility, `puremourning/vimspector` is the most practical first choice.
  For Neovim-only, `mfussenegger/nvim-dap` plus `nvim-dap-ui` is stronger, but
  it does not fit this shared Vimscript config as cleanly.

## Current-Buffer Path Visibility

### Current State

The statusline currently shows `%f`, which is Vim's file name display. Depending
on how the file was opened and the current working directory, this may be a
relative path or just enough of the path to identify the buffer. It is not a
reliable answer when multiple open files share the same basename.

Useful built-in commands already exist:

```vim
:echo expand('%:p')   " full path
:echo expand('%:~')   " home-relative path
:pwd                 " current working directory
:file                " current buffer name/status
```

### Recommendation

Implement a temporary reveal command first:

```vim
:OmarchyPath
<Leader>fp
```

Suggested behavior:

- Echo the full path for the current buffer.
- If the buffer has no file name, echo `[No Name]`.
- Use home-relative display in the message if it is shorter and clearer.
- Also set a register such as `@+` when clipboard is available, or `@"` as a
  safe fallback only if that does not conflict with visual paste goals.
- Do not change the statusline by default.

This is simple, works in Vim and Neovim, and does not compete with limited
statusline width.

### Optional Statusline Toggle

A statusline full-path toggle is feasible:

```vim
let g:omarchy_statusline_path = get(g:, 'omarchy_statusline_path', 'relative')
:OmarchyStatuslinePathToggle
<Leader>up
```

Possible modes:

- `short`: basename only.
- `relative`: current `%f` style.
- `full`: full path.
- `home`: `~`-relative path.

Recommendation: only implement this after the reveal command if it still feels
needed. Full paths can make the statusline noisy on narrow terminals.

### Breadcrumbs

Breadcrumbs are not recommended for the first pass. True breadcrumbs are usually
semantic and work best with LSP document symbols or Tree-sitter. A path-only
breadcrumb such as `project > dir > file` is possible, but it adds formatting
complexity without solving much more than a good path reveal command.

## IDE-Like Editor Tabs

### Important Vim Model Distinction

Vim tabpages are layout containers, not file tabs. A tabpage can contain multiple
windows and buffers. Forcing one Vim tabpage per buffer usually creates friction:

- Splits become awkward.
- Diff layouts become awkward.
- Sessions become noisier.
- Built-in commands and plugins often assume tabpages are layouts.

Recommendation: do not use one Vim tabpage per buffer.

### Better Approach: Bufferline In The Tabline

A bufferline displays open buffers in the top tabline area, making buffers feel
like IDE editor tabs while preserving Vim tabpages for layouts.

No-plugin implementation is feasible:

- Use `set showtabline=2`.
- Set `tabline=%!OmarchyBufferline()`.
- Render listed buffers in a stable order.
- Highlight current, modified, readonly, and hidden buffers.
- Add keys:
  - `<Leader>1` through `<Leader>9`: jump to visible buffer slot.
  - `<Leader>bn` / `<Leader>bp`: next/previous buffer, already present.
  - `<Leader>bd`: delete current buffer, already present.
  - `<Leader>bV`: open buffer in right split, already present.
  - optional `<Leader>b,` / `<Leader>b.`: move buffer left/right in a custom
    display order.

Mouse click support may be possible with tabline click handlers, but it should
be treated as optional after keyboard behavior works. Drag-and-drop reorder is
not a realistic no-plugin target.

### Reordering

Vim does not have a native "buffer order" concept as strong as IDE tabs. A
custom no-plugin bufferline can maintain a script-local buffer order list and
move the current buffer left/right. This is feasible but adds state:

- Must remove deleted buffers from the order.
- Must add newly listed buffers.
- Must stay sane across sessions.
- Must avoid corrupting hidden/terminal/help buffers.

Recommendation: start without custom reorder. Add keyboard reorder later only if
the bufferline proves useful.

### Plugin Option

If a plugin is acceptable, prefer a mature Vim-compatible bufferline over a
Neovim-only Lua bufferline. Candidate:

- `ap/vim-buftabline`: popular, simple, Vim-compatible, no heavy dependency.

Recommendation: no-plugin first if the desired behavior is modest. Optional
plugin only if the no-plugin tabline becomes too much code for too little value.

### Interaction With Breadcrumbs

Tabs and breadcrumbs compete for top-of-screen space. If a bufferline is added,
path visibility should stay in the statusline or a reveal command rather than a
second top bar. The simplest layout is:

- Top tabline: buffer names.
- Statusline: mode, file/path mode, git, diagnostics, position.
- Command echo: full path reveal on demand.

## Debug/DAP Support

### Feasibility

Good debug support is possible, but not "small" in the same way as the current
editing helpers. Debugging needs three layers:

- Editor UI.
- DAP client/plugin.
- Language-specific debug adapter.

For Python, the adapter is usually `debugpy`. For JavaScript/TypeScript, Node
debug adapters are typical. Other languages have their own adapters and setup
quirks.

### Vim-Compatible Recommendation

For a shared Vim/Neovim config, the practical option is:

- Optional plugin: `puremourning/vimspector`.
- Optional Python adapter: `debugpy`.
- Start with Python only.
- Keep all debug plugin installation behind a flag such as:

```vim
let g:omarchy_use_debug = 0
```

Why Vimspector:

- Supports Vim and Neovim.
- Provides a DAP UI with panes, breakpoints, variables, stack, watches, and REPL.
- Avoids writing a DAP client from scratch.
- Has documented launch configuration files.

Tradeoffs:

- It is a substantial plugin.
- Setup can still be confusing because DAP requires per-project launch
  configuration.
- Adapter installation is separate from plugin installation.
- Some UI signs/icons assume fonts or glyphs unless configured carefully.

### Neovim-Only Alternative

For Neovim-only setups:

- `mfussenegger/nvim-dap`
- `rcarriga/nvim-dap-ui`
- `theHamsta/nvim-dap-virtual-text` optionally

This is a strong ecosystem and often feels more modern than Vimspector, but it
is Lua/Neovim-only and does not fit the current "one Vimscript config for Vim
and Neovim" goal.

Recommendation: do not choose this unless the config explicitly accepts a
Neovim-only debug profile.

### Icons And Fonts

Do not require Nerd Fonts. Debug signs should default to ASCII-safe labels:

```text
B   breakpoint
>   current execution line
x   rejected/disabled breakpoint
```

Fancy icons can be optional later. This avoids the common "icons render as boxes"
problem in terminals, browsers, and Git Bash.

### Simple Python-First Setup

Recommended first debug scope:

- Python only.
- User installs `debugpy` in the project env or editor tools env.
- Provide a template `.vimspector.json` in docs, not automatically written into
  projects.
- Provide maps only when debug flag is enabled:
  - `<Leader>dd`: launch/continue debug.
  - `<Leader>db`: toggle breakpoint. This conflicts with the current diff
    buffer map, so use a different debug prefix.
  - Recommended debug prefix: `<Leader>x*` or `<Leader>u*`.

Keymap conflict note:

- `<Leader>d*` is already diff. Do not use it for debug.
- `<Leader>x*` is available and visually suggests execution/debug without
  colliding with current maps.

Potential debug maps:

```text
<Leader>xx  launch/continue
<Leader>xb  toggle breakpoint
<Leader>xo  step over
<Leader>xi  step into
<Leader>xO  step out
<Leader>xr  restart
<Leader>xq  stop/close debug
<Leader>xe  evaluate expression
```

### User Experience Risk

Debug support is worth doing only if the setup docs are excellent. The painful
part is usually not the editor mapping; it is answering:

- Which Python interpreter is used?
- Where is `debugpy` installed?
- How does the debugger know the program entrypoint?
- What working directory is used?
- How are args/env vars configured?

Any implementation should include:

- A "Python debug quick start" doc.
- A known-good `.vimspector.json` template for a current file.
- A known-good template for module execution.
- Clear explanation of project env versus editor tools env.
- A test script and smoke test steps.

### Debug Recommendation

Do not implement debug support in the same pass as bufferline/path work. Make it
its own optional feature branch because it adds plugin, adapter, keymap, and
documentation surface.

Best first debug milestone:

1. Optional `g:omarchy_use_debug = 1`.
2. Add Vimspector only under that flag.
3. Add ASCII-safe signs and `<Leader>x*` maps.
4. Document Python `debugpy` setup only.
5. Provide templates and a smoke test.
6. Defer JavaScript/TypeScript and other languages until Python debug is proven.

## Overall Priority

Recommended order:

1. Add `:OmarchyPath` and `<Leader>fp` path reveal.
2. Consider a statusline path toggle only if the reveal command is insufficient.
3. Consider a no-plugin bufferline/tabline after path reveal.
4. Treat debug support as a separate optional plugin-backed project.

This keeps the simple, reliable path problem separate from the larger tab/debug
features.
