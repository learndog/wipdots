### Current backlog

* Session save restore functionality and keymap (use previous helper functionality from zarchive\vimrc_helpers\.vimrc_helpers\sessions.vim as example)
* Fix: Why does <Leader>sk change my buffer text (when I confuse it with <Leader>fk for find keymaps)?
* Functionality from previous helpers
  - base config items?
  - jh and jl to move to start and end of line OR before after (or just after) nearest bracket on that side
  - config_endstuff?
  - 0 cycle navigation in line: start first last end
  - fixvisualpaste? (don't overwrite @r)
  - folding functionality? Integrate with ALE?
  - Literal search option for fuzzy find commands (eg first char literal symbol)? ff vs f for literal?
  - Terminal launcher/toggle
  - Netrw as side panel with better keymaps (see the file explorer implementation in https://github.com/smnatale/nvim_native for ideas)

* Set optional plugins/functionality to default ON.
* Fix: down arrow past the end of the buffer leaves garbled terminal output and needs refresh (only in GCP JupyterLab terminal, it seems)

### AI Support - needs some thinking
* How to support codex in vim/nvim?
* Github copilot paid and free?
* Cline?
* Local?

### Later
* Confirm that nothing is being updated (plugins or other installs like language servers or fzf) unless :PlugUpdate is called. (Or, of course, the original :PlugInstall). I want to manually control updates rather than be exposed to every new version at release time. Also it would be nice to implement a :CheckForUpdates command that looks at vim/nvim, plugins and any other dependency to see if updates are available (for manual install; and to also be aware of changes when doing a new install on another computer)
* Do analysis of keymaps and update as appropriate
* Remove all omarchy references
* Add to readme that $DOTFILES should either be set or replaced by the actual dotfile location in the local wrapper copy. (is it used elsewhere?) Also clarify that nothing in the repository should change unless it is meant to be a "global" change. Customization should happen in local copies of the config and wrappers.
* Support nvim config switching. Is it worth the complexity? It might allow either mult configs or an easy way to try it before committing to anything. But setup would be well-known if user already does this, and confusing to someone who doesn't want complexity. So not clear it should be implemented, unless it can be done simply and cleverly to meet the needs of both.
* Compare this config with https://github.com/smnatale/nvim_native and see if there are any good ideas that are
  1. Compatible with the current min requirements for vim and nvim, or
  2. Can be useful as nvim-only functionality that only gets invoked when nvim used
  3. Otherwise useful ideas to improve the current config without too much new complexity or risk
  (Keep licensing clean so can still be shared.)
* Find a good way to keep the core config separate from the platform choices for what is turned on or configured special for the platform. Eg maybe that means an Omarchy wrapper and gitbash wrapper and debian gcp wrapper etc around the init file, but make sure it has all the relevant settings and they are respected in the config. Probably need all the custom wrappers in the same dotfiles location, so
  - dotfiles/vim/wrappers/omarchy_vim_wrapper_.vimrc and .../debian_gcp_wrapper_.vimrc and maybe .../bare_min_wrapper_.vimrc and .../full_functionality_wrapper_.vimrc and .../default_wrapper_.vimrc
  - also try to keep personal wrappers out of the dotfiles repos if there is anything too personal in them

### Maybe
* Other functionality from previous config attempts
  - Mine zarchive\vimrc_ale\.vimrc_ale for features
