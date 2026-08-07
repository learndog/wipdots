# GitHub Copilot Implementation Specification

## 1. Goals

Implement GitHub Copilot support while preserving the existing design philosophy of this Vim configuration:

- Keep the configuration in one `init.vim` / `.vimrc`.
- Support both Vim and Neovim wherever practical.
- Keep the plugin count small.
- Prefer official, mature components.
- Minimize security and supply-chain exposure.
- Keep AI functionality optional.
- Preserve the existing ALE/Vim completion system.
- Copilot must not take over `<Tab>`.
- The editor must remain fully usable if Copilot is disabled, unavailable, unauthenticated, or not installed.
- Inline AI completion and agentic/chat functionality should be separate capabilities.
- Avoid building a large Neovim-specific AI stack merely to provide chat or agent functionality.

The desired architecture is:

```text
Traditional completion
    Vim native completion + ALE

Inline AI suggestions
    official github/copilot.vim

AI chat / planning / agentic coding
    official GitHub Copilot CLI
```

Do not introduce `nvim-cmp`, CopilotChat.nvim, an ACP framework, or another completion framework as part of this implementation.

---

# 2. Architectural decisions

## 2.1 Use the official `github/copilot.vim` plugin for inline completion

Add:

```vim
Plug 'github/copilot.vim'
```

behind an installation/configuration flag.

`github/copilot.vim` is GitHub's official Vim/Neovim plugin and supports current Vim and Neovim installations.

Its responsibility in this configuration should remain narrow:

- display Copilot inline suggestions
- explicitly request a suggestion
- accept or dismiss a suggestion
- enable/disable inline Copilot

It should not replace ALE or native Vim completion.

### Rationale

The existing configuration already has a working completion architecture. Adding another completion framework would make the configuration harder to understand and maintain and would increase the dependency surface for little benefit.

Copilot's ghost-text suggestions are complementary to ordinary completion when their controls are kept separate.

---

# 3. Separate installation from runtime enablement

Do not use a single setting such as:

```vim
g:omarchy_use_copilot
```

to mean both:

1. whether Copilot is installed, and
2. whether Copilot is currently producing automatic suggestions.

Those are different decisions.

Use settings along these lines:

```vim
let g:omarchy_install_copilot =
      \ get(g:, 'omarchy_install_copilot', 0)

let g:omarchy_copilot_suggestions_start_enabled =
      \ get(g:, 'omarchy_copilot_suggestions_start_enabled', 0)
```

Recommended defaults:

```text
install Copilot:              OFF
automatic suggestions:       OFF
```

A distribution or personal setup that wants Copilot installed by default can override `g:omarchy_install_copilot`.

`g:omarchy_copilot_suggestions_start_enabled` refers only to whether automatic inline suggestions start enabled when Vim starts. It does **not** mean "turn on Copilot" globally. Copilot installation, authentication, explicit suggestion requests, and Copilot CLI sessions are separate concerns.

Retire any older `g:omarchy_copilot_start_enabled` name rather than preserving a compatibility alias. This keeps the configuration surface smaller and avoids carrying ambiguous wording forward.

### Why distinguish them?

A user may want Copilot installed and authenticated but normally disabled.

That permits three useful states:

```text
1. Copilot not installed

2. Copilot installed, automatic suggestions disabled

3. Copilot installed, automatic suggestions enabled
```

State 2 is especially valuable. The user can retain a completely traditional editing experience but turn automatic Copilot inline suggestions on immediately when desired.

---

# 4. Preserve `<Tab>` for existing completion

This is a hard requirement.

Before Copilot loads:

```vim
let g:copilot_no_tab_map = v:true
```

The existing configuration currently assigns `<Tab>` to `s:TabComplete()`, which invokes local/native/ALE completion after a word and otherwise inserts a tab. That behavior must remain unchanged.

Use a dedicated Copilot acceptance key:

```vim
imap <silent><script><expr> <C-J> copilot#Accept('')
```

Use the empty-string fallback intentionally.

This means:

```text
Ctrl-J + visible Copilot suggestion
    Accept the suggestion.

Ctrl-J + no Copilot suggestion
    Do nothing.
```

Do not use:

```vim
copilot#Accept("\<CR>")
```

for this configuration, because that would make `<C-J>` insert a newline when Copilot has nothing to accept.

GitHub explicitly supports using a separate expression mapping and setting `g:copilot_no_tab_map`, and documents that an empty string means there is no fallback action.

### Resulting completion controls

```text
<Tab>        Existing local/ALE/native completion
<S-Tab>      Previous normal completion candidate
<CR>         Accept normal popup completion
<C-Space>    Explicit traditional completion
<M-/>        Explicit traditional completion
<C-J>        Accept Copilot inline suggestion
```

Copilot must never silently replace any of the existing completion mappings.

---

# 5. Automatic local completion and Copilot should not compete

The existing Python implementation automatically invokes local keyword/buffer completion on `TextChangedI`.

When automatic Copilot inline suggestions are enabled, suppress this automatic Python popup.

The desired behavior is:

```text
COPILOT AUTOMATIC SUGGESTIONS OFF

Python local auto-popup       ON
ALE/native completion         available
Manual completion             available
Copilot ghost text            OFF
```

```text
COPILOT AUTOMATIC SUGGESTIONS ON

Python local auto-popup       OFF
ALE/native completion         available
Manual completion             available
Copilot ghost text            ON
```

Important: turning Copilot on must disable only the automatic Python keyword popup.

It must NOT disable:

```text
<Tab>
<C-Space>
<M-/>
ALEComplete
omnifunc
completefunc
```

The user should always be able to explicitly request traditional completion.

### Rationale

Two asynchronous systems attempting to display completion UI while the user types can interfere with each other and create unpredictable behavior.

The clean model is:

```text
one automatic suggestion mechanism
+
multiple explicitly invoked completion mechanisms
```

---

# 6. Implement a runtime Copilot toggle

Provide a simple user-facing command:

```text
:CopilotToggle
```

Optionally also expose:

```text
:CopilotOn
:CopilotOff
```

If these names conflict with plugin commands or future upstream commands, use clearly namespaced alternatives such as:

```text
:OmarchyCopilotToggle
:OmarchyCopilotOn
:OmarchyCopilotOff
```

The namespaced form is preferable for long-term maintainability.

Recommended mapping:

```text
<Leader>at    Toggle automatic Copilot suggestions
```

The toggle must coordinate both systems.

### On

Conceptually:

```vim
Copilot enable
let g:omarchy_copilot_runtime_enabled = 1
```

and automatic Python keyword popup logic should return without opening its popup.

### Off

Conceptually:

```vim
Copilot disable
let g:omarchy_copilot_runtime_enabled = 0
```

and normal Python automatic keyword completion should resume.

Do not tear down ALE mappings, completion functions, omnifunc, or completefunc.

---

# 7. Startup behavior

If:

```vim
g:omarchy_copilot_suggestions_start_enabled == 0
```

then Copilot should start with automatic suggestions disabled.

Do this after the plugin has loaded, not by preventing the plugin from being declared.

The implementation should gracefully handle all of these cases:

```text
Copilot not installed
Copilot installed but Node unavailable
Copilot installed but unauthenticated
Copilot authenticated but disabled
Copilot enabled
```

Normal editor startup must not fail in any of them.

`:OmarchyCopilotToggle` should display a useful message if the plugin is unavailable, for example:

```text
GitHub Copilot is not installed. Enable g:omarchy_install_copilot and run :PlugInstall.
```

Do not generate Vim errors merely because optional AI functionality is unavailable.

---

# 8. Explicit suggestion command

Provide an easy way to explicitly request a Copilot suggestion.

Suggested mapping:

```text
<Leader>as    Request Copilot suggestion
```

Use Copilot's existing `<Plug>(copilot-suggest)` functionality rather than reimplementing suggestion generation.

An explicit suggestion is useful even when automatic suggestions are disabled.

This produces a particularly useful operating mode:

```text
Automatic AI suggestions: OFF

Normal completion:
    behaves normally

When AI is wanted:
    <Leader>as

Accept result:
    <C-J>
```

This mode may also help users conserve limited Copilot completion quotas.

---

# 9. AI key namespace

Reserve:

```text
<Leader>a...
```

for AI functionality.

The current configuration uses some `<Leader>a...` mappings for ALE diagnostics and commands. Move those to the existing `<Leader>l...` language namespace.

Recommended migration:

```text
OLD             NEW

<Leader>aj      <Leader>lj    next diagnostic
<Leader>ak      <Leader>lk    previous diagnostic
<Leader>af      <Leader>lf    fix
<Leader>ai      <Leader>li    ALE info
```

Existing mappings such as:

```text
<Leader>ld      definition
<Leader>lr      references
<Leader>lh      hover
<Leader>ln      rename
<Leader>la      code action
```

already fit this convention.

Then use:

```text
<Leader>at      toggle automatic AI suggestions
<Leader>as      request inline AI suggestion
<Leader>ac      launch Copilot CLI/chat
```

Do not populate the namespace with numerous speculative mappings initially.

Add more only when there is demonstrated user value.

---

# 10. Copilot filetype configuration

Prefer Copilot's native configuration interface instead of introducing an unnecessary Omarchy wrapper.

Use:

```vim
let g:copilot_filetypes = get(g:, 'copilot_filetypes', {
      \ 'gitcommit': v:false,
      \ })
```

or another conservative default as appropriate.

Copilot itself supports:

```vim
let g:copilot_filetypes = {
      \ '*': v:false,
      \ 'python': v:true,
      \ }
```

for allow-list behavior.

It also supports:

```vim
let b:copilot_enabled = v:false
```

for per-buffer control.

Document these native options in the README rather than adding another abstraction such as `g:omarchy_copilot_filetypes`.

---

# 11. Copilot Language Server security/update policy

For a reproducible and lower-network-activity configuration, strongly prefer:

```vim
let g:copilot_version = v:false
```

unless compatibility testing finds a compelling reason not to.

This tells `copilot.vim` to use the language-server version embedded in the plugin rather than using `npx` to resolve/update another compatible server version.

The important security/update boundary becomes:

```text
User explicitly runs :PlugUpdate
        ↓
copilot.vim is updated
        ↓
embedded compatible server changes
```

rather than ordinary editor startup potentially resolving newer server code.

Do NOT configure:

```vim
let g:copilot_version = 'latest'
```

by default.

GitHub documents that `"latest"` causes `npx` to fetch the newest language-server version at startup.

Also:

- Do not disable SSL verification.
- Do not set `NODE_TLS_REJECT_UNAUTHORIZED=0`.
- Do not set `g:copilot_proxy_strict_ssl = v:false` as a general workaround.

If a corporate proxy requires special handling, document that as an explicit site-specific exception.

---

# 12. Chat and agentic functionality

Do NOT add a Vim/Neovim chat plugin in the first implementation.

Use the official GitHub Copilot CLI:

```text
copilot
```

for:

- conversational coding assistance
- questions about a project
- planning
- multi-file changes
- debugging
- command execution
- agentic coding
- autonomous workflows where the user explicitly chooses them

The Copilot CLI currently supports interactive operation, plan mode, file changes, shell/tool usage, custom agents, and more advanced autonomous workflows.

### Rationale

This keeps responsibilities clean:

```text
Vim/ALE
    normal editing and code intelligence

copilot.vim
    inline suggestions

Copilot CLI
    conversation and agency
```

It avoids adding a large Neovim-only chat stack and maintains substantially better classic Vim compatibility.

---

# 13. Vim integration with Copilot CLI

Provide only lightweight integration.

Recommended command:

```text
:OmarchyCopilotChat
```

Recommended mapping:

```text
<Leader>ac
```

Behavior:

1. Verify that the `copilot` executable exists.
2. If Vim/Neovim has usable terminal support, open `copilot` in a terminal split.
3. Start it in the current project/repository directory when practical.
4. Otherwise display:

```text
Copilot CLI is not available in this Vim build. Run `copilot` from a terminal.
```

Do not add platform-specific terminal emulators or complicated process-management code merely to support this mapping.

A basic `:terminal` integration is sufficient.

### Project directory

When starting Copilot CLI, prefer:

1. current Git repository root, if available
2. otherwise current buffer directory
3. otherwise current working directory

This matters because Copilot CLI asks the user to trust the working directory and may read, modify, or execute files beneath it.

---

# 14. Agent security

Do not automatically launch Copilot CLI with broad automatic permissions.

In particular, do not make the default integration invoke unrestricted modes such as:

```text
--allow-all
```

or equivalent blanket authorization.

The normal interactive CLI should retain its permission and trust prompts.

The README should explicitly distinguish the security capabilities:

```text
copilot.vim
    primarily provides inline suggestions.

Copilot CLI
    is an agent and may read files, edit files, and execute tools/commands
    within the permissions the user grants.
```

The fact that both are branded "Copilot" should not hide this important difference.

---

# 15. Do not unnecessarily synchronize Vim and the agent

Do not build custom mechanisms to continuously synchronize editor buffers with Copilot CLI.

The CLI should work on ordinary project files.

If the CLI changes a file currently open in Vim, normal Vim behavior should apply.

Optionally provide or document:

```vim
:checktime
```

for detecting externally modified files.

Do not introduce file watchers, RPC infrastructure, ACP clients, or an editor-agent protocol solely for this feature.

That can be reconsidered later if a concrete use case justifies it.

---

# 16. Plugin declaration

The intended structure should be roughly:

```vim
let g:omarchy_install_copilot =
      \ get(g:, 'omarchy_install_copilot', 0)

let g:omarchy_copilot_suggestions_start_enabled =
      \ get(g:, 'omarchy_copilot_suggestions_start_enabled', 0)

if g:omarchy_install_copilot
  let g:copilot_no_tab_map = v:true
  let g:copilot_version = v:false
  let g:copilot_enabled =
        \ get(g:, 'copilot_enabled',
        \   g:omarchy_copilot_suggestions_start_enabled ? 1 : 0)
endif
```

Inside vim-plug setup:

```vim
if g:omarchy_install_copilot
  Plug 'github/copilot.vim'
endif
```

Do not copy this pseudocode blindly if ordering requirements in `vim-plug` or Copilot require adjustment. The important requirements are:

- Copilot configuration variables must exist before Copilot initializes.
- the plugin is optional
- missing Copilot must never break startup.

---

# 17. Suggested final keymap

Document this in both comments and README:

```text
Traditional completion

<Tab>        Complete / next completion candidate
<S-Tab>      Previous completion candidate
<CR>         Accept native completion
<C-Space>    Trigger native/ALE completion
<M-/>        Trigger native/ALE completion

GitHub Copilot

<C-J>        Accept visible Copilot suggestion
<Leader>as   Explicitly request Copilot suggestion
<Leader>at   Toggle automatic Copilot suggestions
<Leader>ac   Open Copilot CLI

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

Do not assign Copilot to `<Tab>`.

---

# 18. README material

Add a section similar to the following.

## GitHub Copilot

GitHub Copilot support is optional and consists of two independent components.

### Inline suggestions

Inline suggestions use GitHub's official `github/copilot.vim` plugin.

Enable installation before the plugin section is evaluated:

```vim
let g:omarchy_install_copilot = 1
```

Then install plugins:

```vim
:PlugInstall
```

The first time Copilot is used, authenticate with:

```vim
:Copilot setup
```

Automatic inline suggestions are disabled by default unless:

```vim
let g:omarchy_copilot_suggestions_start_enabled = 1
```

is configured.

This flag controls only startup behavior for automatic inline suggestions. It does not install Copilot, authenticate Copilot, enable the Copilot CLI, or start an agentic session.

Runtime controls:

```text
<Leader>at    Toggle automatic suggestions
<Leader>as    Explicitly request a suggestion
<C-J>         Accept a displayed suggestion
```

Copilot deliberately does **not** use `<Tab>` in this configuration.

`<Tab>`, `<C-Space>`, and the normal popup completion interface continue to use the existing Vim/ALE completion system.

When automatic Copilot suggestions are active, the configuration suppresses its automatic Python keyword popup so that two completion interfaces do not compete. Traditional completion remains available manually at all times.

### Filetype control

Copilot supports its normal native configuration:

```vim
let g:copilot_filetypes = {
      \ 'gitcommit': v:false,
      \ }
```

To enable Copilot only for selected filetypes:

```vim
let g:copilot_filetypes = {
      \ '*': v:false,
      \ 'python': v:true,
      \ 'javascript': v:true,
      \ }
```

For a single buffer:

```vim
let b:copilot_enabled = v:false
```

### Chat and agentic coding

Chat and agentic functionality use the official GitHub Copilot CLI rather than another Vim plugin.

Install the Copilot CLI separately using GitHub's supported installation method.

From a terminal:

```text
copilot
```

or from Vim:

```text
<Leader>ac
```

when terminal integration is available.

The CLI is intentionally separate from inline completion. The CLI can perform substantially more powerful operations, including reading and editing project files and executing commands with user-approved permissions.

Do not assume that disabling inline Copilot disables an already running Copilot CLI session. They are separate tools.

### Security

This configuration does not disable TLS certificate verification.

The inline plugin is configured to prefer its bundled compatible Copilot Language Server rather than automatically fetching the latest server during ordinary startup.

Copilot CLI is launched without blanket automatic tool authorization. Review permission requests before allowing the agent to execute commands or modify files.

---

# 19. First-use experience

A good implementation should make the following workflow straightforward.

### User does not want Copilot

Nothing changes.

No Copilot mappings should interfere with normal completion.

### User wants Copilot

Configure:

```vim
let g:omarchy_install_copilot = 1
```

Run:

```text
:PlugInstall
:Copilot setup
```

Then either explicitly request suggestions:

```text
<Leader>as
```

or turn automatic suggestions on:

```text
<Leader>at
```

Accept a suggestion with:

```text
Ctrl-J
```

Normal `<Tab>` completion remains unchanged.

### User wants agentic coding

Install the official Copilot CLI separately and invoke:

```text
<Leader>ac
```

or run:

```text
copilot
```

from the project directory.

---

# 20. Failure behavior

Test the implementation under these conditions.

### Copilot plugin absent

Expected:

- Vim starts normally.
- ALE/native completion works.
- `<Tab>` works.
- AI commands give a useful message rather than an error.

### Copilot plugin installed but not authenticated

Expected:

- Vim works normally.
- invoking Copilot gives understandable setup/status information.
- no completion mappings are damaged.

### Node unavailable

Expected:

- Vim starts normally.
- ordinary completion works.
- Copilot failure is isolated to Copilot.

### Copilot disabled

Expected:

- no automatic AI ghost text
- Python automatic keyword completion works normally
- `<Tab>` and `<C-Space>` work normally
- explicit Copilot suggestion may still be requested if supported by the plugin

### Copilot enabled

Expected:

- Copilot ghost text appears
- Python automatic keyword popup does not automatically appear
- `<Tab>` still invokes traditional completion
- `<C-Space>` still invokes traditional completion
- `<C-J>` accepts Copilot
- turning Copilot back off restores automatic Python keyword completion

### Copilot CLI absent

Expected:

`<Leader>ac` reports that the Copilot CLI is not installed.

Vim continues normally.

### Vim without terminal support

Expected:

`<Leader>ac` tells the user to run `copilot` in an external terminal.

---

# 21. Compatibility requirements

The implementation must remain Vimscript and must not require Lua.

Do not make Neovim a requirement for inline Copilot.

Feature-detect capabilities rather than assuming them.

Examples:

```vim
exists(':Copilot')
executable('copilot')
exists(':terminal')
has('nvim')
```

Where behavior differs between Vim and Neovim, degrade gracefully instead of adding another dependency. Comments and README documentation must explicitly call out behavior that is platform-specific, Vim-specific, Neovim-specific, or dependent on terminal support.

---

# 22. Maintainability requirements

Keep the AI implementation in one clearly marked section.

Avoid spreading Copilot-specific conditionals through unrelated functions.

The one intentional interaction with the existing completion code should be a small predicate such as:

```vim
s:CopilotAutoSuggestionsEnabled()
```

or equivalent.

Then automatic Python completion can conceptually do:

```vim
if s:CopilotAutoSuggestionsEnabled()
  return
endif
```

This is preferable to teaching the entire Python completion implementation about Copilot.

Likewise, use upstream Copilot functionality wherever possible:

```text
:Copilot enable
:Copilot disable
<Plug>(copilot-suggest)
copilot#Accept()
g:copilot_filetypes
b:copilot_enabled
```

rather than recreating it.

Wrapper functions should exist only where this configuration adds behavior, particularly coordinating Copilot's automatic state with the Python automatic-completion behavior.

The implementation should preserve the long-file organization of `init.vim`: keep Copilot setup, commands, mappings, and CLI helpers grouped in an obvious AI/Copilot section, with only the small completion predicate referenced from the Python automatic-completion path.

---

# 23. Implementation handoff requirements

The implementor should treat this as part of the deliverable, not as optional cleanup:

- Update comments in `init.vim` so the difference between installed Copilot, automatic inline suggestions, explicit inline suggestion requests, and Copilot CLI sessions is clear.
- Fully update `README.md`, including optional flags, first-use workflow, keymaps, completion behavior, CLI behavior, security notes, troubleshooting, and test matrix expectations.
- Explicitly document any platform-specific or Vim/Neovim-specific behavior. In particular, terminal integration and key handling may differ between Vim, Neovim, terminal Vim, GUI Vim, Windows, WSL, and Unix-like shells.
- Keep the implementation in the existing single Vimscript config file. Do not introduce Lua, another plugin framework, a second AI plugin, or generated helper files unless a concrete blocker makes that unavoidable.
- Keep security-safe defaults: no startup downloads beyond explicit plugin installation/update, no disabled TLS checks, no blanket Copilot CLI permissions, and no automatic agent launch.
- Keep the section segregation of the long config file clear and readable. Prefer a compact, named AI/Copilot section over scattering Copilot behavior throughout the file.
- When the implementation is done, provide a detailed git commit message explaining the user-visible behavior, intentional flag cleanup, security choices, README updates, platform/Vim/Neovim limits, and verification performed.

---

# 24. Acceptance criteria

The implementation is complete only if all of these are true:

1. Vim starts successfully with Copilot disabled and/or absent.
2. Neovim starts successfully with Copilot disabled and/or absent.
3. Existing ALE completion works exactly as before with Copilot off.
4. `<Tab>` is never owned by Copilot.
5. `<C-J>` accepts Copilot without inserting unwanted text when no suggestion exists.
6. Automatic Python keyword completion works with Copilot automatic suggestions off.
7. Automatic Python keyword completion does not compete with Copilot while Copilot automatic suggestions are on.
8. Manual ALE/native completion remains available while Copilot is on.
9. Copilot automatic suggestions can be toggled without restarting Vim.
10. Explicit Copilot suggestions can be requested without permanently enabling automatic suggestions.
11. The agent/chat functionality does not require a second Vim plugin.
12. Missing Copilot CLI produces a friendly message rather than an error.
13. Copilot CLI launches in an appropriate project directory where terminal support permits.
14. The CLI is not launched with blanket automatic permissions.
15. Copilot is not configured to disable TLS verification.
16. The implementation remains entirely within the existing single configuration file.
17. README documentation clearly distinguishes traditional completion, inline Copilot, and the Copilot CLI agent.
18. README and comments clearly state that `g:omarchy_copilot_suggestions_start_enabled` controls only automatic inline suggestions at startup.
19. Any platform-specific or Vim/Neovim-specific limitations are documented.
20. The final implementation summary includes a detailed proposed git commit message.

---

# 25. Important non-goals

Do not turn this configuration into an AI-first IDE.

Specifically, this task should not:

- replace ALE
- replace Vim completion
- introduce `nvim-cmp`
- introduce Treesitter solely for Copilot
- introduce CopilotChat.nvim
- introduce an ACP client
- add a general AI plugin abstraction
- support several AI providers at once
- create a background agent
- automatically approve shell commands
- create complicated synchronization between Vim and Copilot CLI
- automatically update Copilot components on every Vim startup

Future assistants such as Codex, Cline, OpenCode, or local models can be considered independently later.

The present implementation should solve GitHub Copilot cleanly without prematurely designing a universal AI framework.

---

# 25. Design principle

The implementation should preserve this invariant:

```text
If all AI functionality is turned off,
the editor should behave essentially as though Copilot had never been added.
```

When AI is enabled, functionality should remain clearly separated:

```text
ALE/Vim                 Copilot.vim             Copilot CLI
---------               -----------             -----------
completion              inline suggestions      chat
diagnostics             ghost text              planning
navigation              explicit AI suggest     multi-file work
formatting              acceptance              agentic actions
```

This separation is the main reason for the chosen architecture. It minimizes plugin dependencies and interaction bugs while giving the user both convenient AI completion and full agentic Copilot functionality when intentionally requested.
