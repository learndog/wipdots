### Current backlog
* Fix: <Leader>sk enters insert mode (why). Map it to noop incase I confuse <Leader>s with <Leader>f.
* Functionality from previous helpers
  - fixvisualpaste? (don't overwrite @r); I need clarity on what the means and why it might be needed
  - Literal search option for fuzzy find commands (eg first char literal symbol)? ff vs f for literal? fx instead of f for literal (x is "fixed not fuzzy")?
  - Terminal launcher/toggle
* Fix: How to <Leader>ee when in a rhs window split?
* How to open/select a buffer and show in a new split? Ideally can open as a new split to right. How to swap sides?
* How to nvim diff side by side two files? (Ideally in a multiselect fzf file list)
  Maybe open side by side and keymap to toggle diff mode or just map each of `do :windo diffthis` and `do :windo diffoff` 
  Or from one buffer diff another file with `:vert diffsplit path/to/file`
* Also add support for interactive merging, and 3 or 4 way diffs?
* Turn on all filetypes and then turn off exceptions (currently the whole list is set manually in init.vim)
* For fzf 0.38.0+ but below 0.54.0, provide a warning that it is not fully supported (instead of the current fallback message)
* Do analysis of keymaps and update as appropriate
* Support nvim config switching. Is it worth the complexity? It might allow either mult configs or an easy way to try it before committing to anything. But setup would be well-known if user already does this, and confusing to someone who doesn't want complexity. So not clear it should be implemented, unless it can be done simply and cleverly to meet the needs of both.
* Compare this config with https://github.com/smnatale/nvim_native and see if there are any good ideas that are
  1. Compatible with the current min requirements for vim and nvim, or
  2. Can be useful as nvim-only functionality that only gets invoked when nvim used
  3. Otherwise useful ideas to improve the current config without too much new complexity or risk
  (Keep licensing clean so can still be shared.)


### Cleanup

### Later
* Clean up all the repetitive content in the readme, and break out the getting started and install and dependency info into a new file omarchy\vim\INSTALL_INSTRUCTIONS.md, while still keeping it clear and organized and easy to scan, at the same level of detail (don't lose info). Eg the fzf version is repeated over and over. Important info but not easy to maintain when repeated in too many places for no good reason. Clean that up. Keep it readable, but include all the information, even if it's not specific to this config (but relevant and needed for the user here - it might be how you use vim for that kind of feature, such as the quickfix list navigation which is still important for the user to see in the README even if it's truly a vim thing.)
* If not sufficiently covered in the readme, call out moves to last or next position (which is across files, and using existing vim functionality, I think)
* TAB functionality
* Breadcrumbs - what would that do and how would it work?
* Tabs - how would that work? Is there a simple way to do that without plugins? Compatible with mouse? Reorderable? Renameable? fuzzy pickable?
* DAP and DAP UI Debug functionality for python? Can it be done simply? With good user experience and where the needed icons work properly? Also with simple configuration and setup (in the past I found it painful to figure out how to configure a debugger to get it ready to be used). Should be optional to include.
  Note: For Debug, I am willing to add some (optionally installed and activated) plugins, and I even suspect it will be necessary for a good user experience.

### AI Support - needs some thinking
* How to support codex in vim/nvim?
* Cline?
* Local?

### Maybe
* (Optionally installed and activated) support for ipynb notebooks in vim and/or nvim. Plugins okay here if the plugin is popular and low security/maintenance risk. I don't expect this to be viable and simple, but want to at least give it a look.



### Interesting references
* https://github.com/smnatale/nvim_native 
