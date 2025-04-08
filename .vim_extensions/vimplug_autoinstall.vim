" BEGIN vim-plug autoinstall if missing. Add before plug#begin. Audit the script before running.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
   silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" END  vim-plug autoinstall

" See https://github.com/junegunn/vim-plug
"
" Keybindings (inside the vimplug window?)
"   D - PlugDiff
"   S - PlugStatus
"   R - Retry failed update or installation tasks
"   U - Update plugins in the selected range
"   q - Close the window
"   :PlugStatus
"       L - Load plugin
"   :PlugDiff
"       X - Revert the update

" Commands
"   PlugInstall [name ...] Install plugins
"   PlugUpdate [name ...]  Install or update plugins
"   PlugClean              Remove unlisted plugins
"   PlugUpgrade            Upgrade vim-plug itself
"   PlugStatus             Check the status of plugins
