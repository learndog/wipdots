# GitHub Copilot Implementation Plan

Date: 2026-08-07

## Summary

The recommendation document is directionally strong and worth implementing, with a few refinements. The best idea is the separation of responsibilities:

- Vim native completion and ALE remain the normal completion system.
- `github/copilot.vim` is used only for optional inline suggestions.
- GitHub Copilot CLI is used for chat, planning, and agentic coding.

This fits the current `init.vim` philosophy: one Vimscript file, optional plugins, low startup risk, no AI-first editor stack, and clear failure behavior when tools are missing.

The current `init.vim` already has a partial Copilot implementation:

- `g:omarchy_install_copilot` gates `Plug 'github/copilot.vim'`.
- `g:copilot_no_tab_map` is set when Copilot is enabled.
- `g:copilot_enabled` defaults from `g:omarchy_copilot_suggestions_start_enabled`.
- `g:copilot_version = v:false` is already used.
- `<C-J>` accepts Copilot suggestions with an empty fallback.
- `<Leader>at` toggles Copilot inline suggestions.
- Automatic Python keyword popup completion is suppressed while Copilot inline suggestions are enabled.

That partial implementation is mostly right. The implementation work should clean up naming, add missing explicit suggestion and CLI functionality, update key namespaces, and document the split clearly.

## Current External Facts Checked

Primary sources checked on 2026-08-07:

- GitHub's `github/copilot.vim` repository describes `copilot.vim` as the Vim/Neovim plugin for GitHub Copilot and shows it as an active, mainstream GitHub-owned repository with about 11.7k stars and current repository activity: https://github.com/github/copilot.vim
- GitHub's official Copilot install docs still recommend `github/copilot.vim` for Vim/Neovim inline suggestions: https://docs.github.com/en/copilot/how-tos/set-up/install-copilot-extension?tool=vimneovim
- GitHub's official Copilot suggestion docs list Vim/Neovim support and say the plugin provides inline suggestions as you type: https://docs.github.com/en/copilot/how-tos/get-code-suggestions/get-ide-code-suggestions?tool=vimneovim
- `:help copilot` from `copilot.vim` documents `:Copilot enable`, `:Copilot disable`, `:Copilot setup`, `:Copilot status`, `g:copilot_no_tab_map`, `copilot#Accept()`, `<Plug>(copilot-suggest)`, `g:copilot_filetypes`, `b:copilot_enabled`, and `g:copilot_version`: https://raw.githubusercontent.com/github/copilot.vim/release/doc/copilot.txt
- GitHub Copilot CLI is now a separate `copilot` executable, available with all Copilot plans subject to organization policy, and supports interactive chat plus agentic capabilities: https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-getting-started
- GitHub Copilot CLI supports interactive use, programmatic `-p`, plan mode, autopilot mode, tool permissions, MCP, plugins, skills, and custom agents: https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference
- GitHub's older `gh-copilot` extension was deprecated in favor of the new GitHub Copilot CLI: https://github.blog/changelog/2025-09-25-upcoming-deprecation-of-gh-copilot-cli-extension/

Conclusion: `github/copilot.vim` is still the right mainstream plugin for Vim/Neovim inline suggestions. It is official GitHub software, not a third-party Copilot plugin. GitHub is owned by Microsoft, but the directly relevant publisher/support boundary here is GitHub, and GitHub's current docs still point to this plugin.

## Honest Evaluation Of The Specification

Worth implementing:

- Preserve `<Tab>` for existing completion. This should remain a hard rule.
- Use `<C-J>` for Copilot accept with `copilot#Accept('')`, so no newline or fallback text is inserted when there is no visible suggestion.
- Keep automatic Copilot suggestions off by default.
- Suppress only the automatic Python keyword popup while Copilot automatic suggestions are enabled. Keep manual `<Tab>`, `<C-Space>`, `<M-/>`, ALE, `omnifunc`, and `completefunc` available.
- Prefer Copilot's native `g:copilot_filetypes` and `b:copilot_enabled` rather than adding another Omarchy wrapper.
- Keep `g:copilot_version = v:false` by default. GitHub documents that the normal/default version constraint may use `npx`, and `"latest"` fetches the latest language server at startup. The static embedded language server is a better default for this repo's low-network-startup and supply-chain goals.
- Do not disable TLS verification by default.
- Do not add `CopilotChat.nvim`, `nvim-cmp`, ACP client plumbing, or a broad AI abstraction in the first implementation.
- Use the official `copilot` CLI for chat, planning, and agentic work.

Needs refinement:

- Rename `g:omarchy_use_copilot` to `g:omarchy_install_copilot` because installation and runtime suggestion state are different decisions. Retire the old name rather than preserving a compatibility alias.
- Add a separate CLI flag such as `g:omarchy_enable_copilot_cli_mapping`. The CLI can read, edit, and execute commands, so the Vim mapping should be opt-in even if inline suggestions are installed.
- Do not call the old GitHub CLI extension path "the CLI". The old `gh-copilot` extension is retired; the current tool is the `copilot` executable. `gh copilot` can launch/install it, but the Vim integration should look for `copilot`.
- Move existing ALE `<Leader>a...` mappings to `<Leader>l...` and do not keep aliases. This keeps `<Leader>a...` reserved for AI and avoids carrying compatibility mappings that the user does not want.

## Proposed Design

### Flags

Use these flags near the existing flag section:

```vim
let g:omarchy_install_copilot = get(g:, 'omarchy_install_copilot', 0)
let g:omarchy_copilot_suggestions_start_enabled =
      \ get(g:, 'omarchy_copilot_suggestions_start_enabled', 0)
let g:omarchy_enable_copilot_cli_mapping =
      \ get(g:, 'omarchy_enable_copilot_cli_mapping', 0)
```

Do not preserve compatibility aliases for the old Copilot flag names. The implementation should use the clear names only.

Defaults:

- `g:omarchy_install_copilot = 0`
- `g:omarchy_copilot_suggestions_start_enabled = 0`
- `g:omarchy_enable_copilot_cli_mapping = 0`

### Inline Copilot Setup

When `g:omarchy_install_copilot` is true, set Copilot options before `plug#begin()`:

```vim
let g:copilot_no_tab_map = get(g:, 'copilot_no_tab_map', v:true)
let g:copilot_enabled =
      \ get(g:, 'copilot_enabled',
      \   g:omarchy_copilot_suggestions_start_enabled ? 1 : 0)
let g:copilot_version = get(g:, 'copilot_version', v:false)
let g:copilot_filetypes = get(g:, 'copilot_filetypes', {
      \ 'gitcommit': v:false,
      \ 'markdown': v:false,
      \ 'text': v:false,
      \ 'help': v:false,
      \ })
```

Declare the plugin only when install is enabled:

```vim
if g:omarchy_install_copilot
  Plug 'github/copilot.vim'
endif
```

### Completion Interaction

Keep the existing split:

- `<Tab>` remains `s:TabComplete()`.
- `<S-Tab>` remains previous popup item.
- `<CR>` accepts native popup completion only when `pumvisible()`.
- `<M-/>`, `<C-Space>`, and `<C-@>` remain manual traditional completion triggers.
- `<C-J>` accepts Copilot only.

Replace the current predicate name with a more explicit one:

```vim
function! s:CopilotAutoSuggestionsEnabled() abort
  return g:omarchy_install_copilot && get(g:, 'copilot_enabled', 0)
endfunction
```

Use it only in `s:MaybeAutoPythonKeywordComplete()`. This keeps Copilot-specific logic out of the Python completion implementation.

### User Commands

Keep namespaced commands:

```vim
:OmarchyCopilotOn
:OmarchyCopilotOff
:OmarchyCopilotToggle
:OmarchyCopilotStatus
:OmarchyCopilotSuggest
:OmarchyCopilotChat
```

Do not add short unnamespaced commands like `:CopilotToggle`; upstream may add commands later.

`OmarchyCopilotSuggest` should call Copilot's native `<Plug>(copilot-suggest)` path rather than implementing suggestion logic.

`OmarchyCopilotChat` should:

1. Check `executable('copilot')`.
2. Check `exists(':terminal') == 2`.
3. Choose a working directory:
   - current git root,
   - else current buffer directory,
   - else `getcwd()`.
4. Open `copilot` in a terminal split from that directory.
5. Launch only `copilot`, with no blanket permission flags.

If the executable is missing, print:

```text
GitHub Copilot CLI is not installed. Install the `copilot` command and run it from a terminal, or enable the Vim mapping after installation.
```

If terminal support is missing, print:

```text
This Vim build does not support :terminal. Run `copilot` from a terminal in the project directory.
```

### Keymaps

Recommended final keymap:

```text
Traditional completion

<Tab>        Complete / next completion candidate
<S-Tab>      Previous completion candidate
<CR>         Accept native popup completion
<C-Space>    Trigger native/ALE completion
<M-/>        Trigger native/ALE completion

GitHub Copilot inline suggestions

<C-J>        Accept visible Copilot suggestion
<Leader>as   Explicitly request Copilot suggestion
<Leader>at   Toggle automatic Copilot suggestions

GitHub Copilot CLI

<Leader>ac   Open Copilot CLI, only when g:omarchy_enable_copilot_cli_mapping = 1

Language / ALE

<Leader>ld   Definition
<Leader>lr   References
<Leader>lh   Hover
<Leader>ln   Rename
<Leader>la   Code action
<Leader>lj   Next diagnostic
<Leader>lk   Previous diagnostic
<Leader>lf   Fix
<Leader>li   ALE info
```

The ALE diagnostic mappings currently using `<Leader>aj`, `<Leader>ak`, `<Leader>af`, and `<Leader>ai` should move to the language namespace without old aliases.

### CLI Workflow

The CLI workflow is reasonable and probably the best maintainable choice:

- It avoids binding Vim to a fast-changing chat/agent protocol.
- It lets GitHub evolve Copilot CLI independently.
- It keeps classic Vim compatibility.
- It keeps agent permissions in the terminal tool where GitHub documents trust prompts, tool permissions, plan mode, and autopilot.
- It avoids a broad Neovim-only plugin stack.

The Vim integration should be intentionally thin: open the CLI in the right directory and then get out of the way.

### Security Defaults

The implementation should not:

- Set `g:copilot_proxy_strict_ssl = v:false`.
- Set `NODE_TLS_REJECT_UNAUTHORIZED=0`.
- Set `g:copilot_version = 'latest'`.
- Launch `copilot` with `--allow-all`, `/allow-all`, `/yolo`, `--allow-all-tools`, or equivalent broad authorization.
- Install or update software during normal Vim startup.
- Try to synchronize unsaved buffers into the CLI.

The README should explicitly state that:

- `copilot.vim` provides inline suggestions.
- `copilot` CLI is an agent that may read files, edit files, and execute tools/commands depending on granted permissions.
- Turning off inline Copilot does not stop an already running CLI session.
- `g:omarchy_copilot_suggestions_start_enabled` controls only whether automatic inline suggestions start enabled. It does not install Copilot, authenticate Copilot, enable explicit suggestion requests, or start the Copilot CLI.

## Implementation Steps

1. Rename the Copilot install flag internally to `g:omarchy_install_copilot` and retire `g:omarchy_use_copilot`.
2. Rename the automatic inline suggestion startup flag to `g:omarchy_copilot_suggestions_start_enabled` and retire `g:omarchy_copilot_start_enabled`.
3. Update the top-of-file AI strategy comments to use the new flag names, clarify that suggestion startup is not "turning on Copilot" globally, and reflect current CLI facts.
4. Keep `github/copilot.vim` behind the install flag.
5. Keep `g:copilot_no_tab_map`, `g:copilot_enabled`, `g:copilot_version`, and `g:copilot_filetypes` configured before plugin load.
6. Rename `s:CopilotInlineEnabled()` to `s:CopilotAutoSuggestionsEnabled()` and keep its only behavioral use in `s:MaybeAutoPythonKeywordComplete()`.
7. Keep `<C-J>` mapped to `copilot#Accept('')`.
8. Add `:OmarchyCopilotSuggest` and `<Leader>as` using `<Plug>(copilot-suggest)`.
9. Add `:OmarchyCopilotChat` and, if approved, `<Leader>ac` behind `g:omarchy_enable_copilot_cli_mapping`.
10. Move ALE diagnostic/fix/info mappings to `<Leader>lj`, `<Leader>lk`, `<Leader>lf`, and `<Leader>li`, without old `<Leader>a...` aliases.
11. Update README optional plugin, keymap, completion, Copilot, CLI, troubleshooting, and test matrix sections.
12. Keep the Copilot implementation grouped clearly in the existing long `init.vim`; avoid scattering unrelated Copilot conditionals outside the AI/Copilot section.
13. Document anything platform-specific or Vim/Neovim-specific, especially terminal integration and key handling.
14. Preserve the one-file Vimscript approach, readable section boundaries, optional flags, graceful degradation, and security-safe defaults from the existing config goals.
15. Test startup and keymaps in the available Vim/Neovim environment without installing Copilot.
16. Provide a detailed proposed git commit message covering user-visible behavior, intentional flag cleanup, security choices, README changes, platform/Vim/Neovim limits, and verification performed.

## Implementation Handoff Requirements

The implementation should be ready to proceed with the recommendations below. The implementor should not treat these as optional cleanup:

- Clarify in both comments and `README.md` that `g:omarchy_copilot_suggestions_start_enabled` controls only automatic inline suggestions at startup.
- Fully update `README.md`, including flags, installation, first-use setup, keymaps, completion behavior, CLI behavior, security notes, troubleshooting, and test matrix coverage.
- Be explicit if any behavior is platform-specific or Vim/Neovim-specific. The main expected caveats are terminal support and terminal key handling.
- Keep the implementation inside the existing `init.vim` file.
- Keep Copilot setup, commands, mappings, and CLI helpers grouped in a clear AI/Copilot section.
- Keep security-safe defaults: no disabled TLS verification, no startup fetch of the latest Copilot language server, no automatic CLI session, and no blanket agent permissions.
- Return a detailed git commit message when done.

## Verification Plan

Minimum local verification without network/plugin installation:

- Source `omarchy/vim/init.vim` with Copilot flags unset.
- Source with `g:omarchy_install_copilot = 1` but plugin absent.
- Confirm `<Tab>`, `<C-Space>`, `<M-/>`, and Python keyword completion still work.
- Confirm `:OmarchyCopilotStatus`, `:OmarchyCopilotToggle`, `:OmarchyCopilotSuggest`, and `:OmarchyCopilotChat` fail gracefully when plugin/CLI are absent.
- Confirm no startup attempt downloads Copilot or the language server.

Verification after optional plugin install:

- Run `:PlugInstall`.
- Run `:Copilot setup`.
- Confirm `:Copilot status`.
- Confirm `<Tab>` still uses traditional completion.
- Confirm `<C-J>` accepts a visible Copilot suggestion and does nothing when none is visible.
- Confirm `<Leader>as` can request a suggestion.
- Confirm `<Leader>at` toggles automatic suggestions.
- Confirm automatic Python keyword popup is suppressed only while automatic Copilot suggestions are enabled.

CLI verification after optional CLI install:

- Confirm `executable('copilot')`.
- Confirm `:OmarchyCopilotChat` opens `copilot` in a terminal split from the git root or buffer directory.
- Confirm the command is launched without blanket permission flags.
- Confirm missing terminal support or missing CLI reports a useful message.

## Decisions / Defaults

These choices no longer need to block implementation; use the defaults below unless the user overrides them:

- Retire `g:omarchy_use_copilot`; use `g:omarchy_install_copilot` only.
- Retire `g:omarchy_copilot_start_enabled`; use `g:omarchy_copilot_suggestions_start_enabled` only.
- Do not keep old ALE `<Leader>a...` aliases; use `<Leader>l...` only.
- Keep the CLI mapping behind `g:omarchy_enable_copilot_cli_mapping = 0` by default.
- Keep Markdown, text, gitcommit, and help disabled by default for inline suggestions.

Status: ready to implement with these defaults.
