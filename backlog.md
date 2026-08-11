### Current backlog
* Netrw as side panel but with better (and non-dangerous) keymaps (see the file explorer implementation in https://github.com/smnatale/nvim_native for ideas)
* If not breaking std expectations, switch the right/left for git diff with <Space>dg. RHS new file is nicer.
* Fix: <Leader>sk enters import mode (why). Map it to noop incase I confuse <Leader>s with <Leader>f.
* Check Scope: How local or global in a project is the lsp info (eg does rename symbol cross file boundaries - if chg in module, do dependent files chg?) Add to the documentation. (I think rn global to the dir vim ran from, and lr?)
* Functionality from previous helpers
  - jh and jl to move before after (or just after) nearest bracket on that side, eg after autoclose
  - config_endstuff?
  - 0 and maybe "'" or CTRL-' cycle navigation in line: start first last end
  - folding functionality - zz and z N? Integrate with ALE?
  - Fix windows, split keymaps (add | & \, or | and -, or - and +) -> What will people expect for the keymaps? What does lazyvim use?
  - fixvisualpaste? (don't overwrite @r); get clarity on what the means and why needed
  - Literal search option for fuzzy find commands (eg first char literal symbol)? ff vs f for literal? fx instead of f for literal (x is "fixed not fuzzy")?
  - Terminal launcher/toggle

* Set optional plugins/functionality to default ON.
* Fix: down arrow past the end of the buffer leaves garbled terminal output and needs refresh (only in GCP JupyterLab terminal, it seems)

### AI Support - needs some thinking
* How to support codex in vim/nvim?
* Cline?
* Local?

### Cleanup
* Turn on all filetypes and then turn off exceptions (currently the whole list is set manually in init.vim)
* For fzf 0.38.0+ but below 0.54.0, provide a warning that it is not fully supported (instead of the current fallback message)

### Later
* Fallback buffer selector (:buffer sufficient? Maybe use previous helper?) and keymap. Works even if fzf not avail. Can replace or add to keymap.
* Incorporate more base config items? Other sample 0 plugin config examples? <DO THIS MANUALLY, NOT VIA preferences of an LLM>
* Clean up all the repetitive content in the readme, while still keeping it clear and organized and easy to scan, with all the same detail. Eg the fzf version is repeated over and over. Important info but not easy to maintain when repeated in too many places for no good reason.
* Confirm that nothing is being updated (plugins or other installs like language servers or fzf) unless :PlugUpdate is called. (Or, of course, the original :PlugInstall). I want to manually control updates rather than be exposed to every new version at release time. Also it would be nice to implement a :CheckForUpdates command that looks at vim/nvim, plugins and any other dependency to see if updates are available (for manual install; and to also be aware of changes when doing a new install on another computer)
* Do analysis of keymaps and update as appropriate
* Remove all omarchy references, but keep naming that allows use of a different config, eg a clean modern nvim lua no-plugin config, maybe as nvim/, and maybe another as lazyvim/
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
* Debug and debug ui for python?
* Other functionality from previous config attempts
  - Mine zarchive\vimrc_ale\.vimrc_ale for features
