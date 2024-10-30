" VIM CONFIGURATION - Python microIDE
"
" ###################################################################################
" #### USER FEATURE SELECTION
" ###################################################################################
" Select functionality... choose a value
   let g:install_plug_lsp = 'coc'                   " Options: ['coc'], 'disable', 'ale'
   let g:install_plug_fzf = 1                       " [1] or 0 (for true or false)
      let g:install_plug_fzfbat = 1                 " [1] or 0 (for true or false)
   let g:install_plug_comments = 'manual'           " [manual] or commentary
   let g:install_plug_gitcmds = 'disable'           " [disable], fugitive
   let g:install_plug_vimwhichkey = 'enable'        " [enable], disable - (will be autoconfigured later)
" ###################################################################################

"Auto configure features based on vim or nvim
if has('nvim')
   if g:install_plug_vimwhichkey == 'enable'
      let g:install_plug_vimwhichkey = 'which-key' " [vim-which-key], disable, which-key
   endif
   let g:install_plug_filetree = 'nvimtree'   " [netrw], nvimtree
elseif !has('nvim')
   if g:install_plug_vimwhichkey == 'enable'
      let g:install_plug_vimwhichkey = 'vim-which-key' " [vim-which-key], disable, which-key
   endif
   let g:install_plug_filetree = 'netrw'   " [netrw], nvimtree
else
   let g:install_plug_vimwhichkey = 'disable'   " [vim-which-key], disable, which-key
   let g:install_plug_filetree = 'netrw'   " [netrw], nvimtree
endif

" ###################################################################################
" #### START VIM CONFIGURATION
" ###################################################################################
"
" Set leader to <space>
"let mapleader = '\<Space>'
let g:mapleader = ' '
let g:maplocalleader = ' '     " Added for vim-which-key (default was ,)

" Allow mouse clicks anywhere (eg past column 88) if supported
" xterm2 has been removed in nvim
" if has("mouse_sgr")
"    set ttymouse=sgr
" else
"    set ttymouse=xterm2
" end

" Choose theme - See https://vimcolorschemes.com/ for more options
" colorscheme [space] [Ctrl+d]
" colorscheme blue
" colorscheme darkblue
" colorscheme default
" colorscheme delek
" colorscheme desert
" colorscheme elflord
" colorscheme evening
" colorscheme industry
" colorscheme koehler
" colorscheme morning
" colorscheme murphy
" colorscheme pablo
" colorscheme peachpuff
" colorscheme ron
" colorscheme shine
colorscheme slate
" colorscheme zellner

" auto-reload vimrc
" autocmd! bufwritepost vimrc source ~/.vim/vimrc

" Required VimPlug Autoinstall
source $HOME/.vimrc_helpers/vimplug_autoinstall.vim

" Install the selected plugins
call plug#begin()
   if g:install_plug_lsp == 'coc' | Plug 'neoclide/coc.nvim' | endif
   if g:install_plug_lsp == 'ale' | Plug 'dense-analysis/ale'      | endif
   "if g:install_plug_fzf          | Plug 'learndog/fzf', { 'do': { -> fzf#install() } } | endif
   if g:install_plug_fzf          | Plug 'junegunn/fzf' | endif
   if g:install_plug_fzf          | Plug 'junegunn/fzf.vim' | endif
   if g:install_plug_fzfbat       | Plug 'sharkdp/bat' | endif
   if g:install_plug_vimwhichkey == 'which-key' | Plug 'folke/which-key.nvim' | endif
   if g:install_plug_vimwhichkey == 'vim-which-key' | Plug 'liuchengxu/vim-which-key', {'branch': 'release'} | endif
   if g:install_plug_filetree == 'nvimtree' | Plug 'nvim-tree/nvim-tree.lua'  | endif
   if g:install_plug_gitcmds == 'fugitive' | Plug 'tpope/vim-fugitive' | endif
   Plug 'learndog/vim-maximizer'  "From szw/vim-maximizer to secure old repos content
"    Plug 'learndog/vim-gitgutter', {'branch': 'release'} "From airblade/vim-gitgutter to secure repos content
   Plug 'learndog/vim-gitgutter', {'branch': 'main'} "From airblade/vim-gitgutter to secure repos content
   Plug 'learndog/lightline.vim' "From itchyny/lightline.vim to secure repos content
   if g:install_plug_comments == 'commentary' | Plug 'tpope/vim-commentary' | endif
call plug#end()

" Run the associated helper code for selected configuration
source $HOME/.vimrc_helpers/config_base.vim
if g:install_plug_vimwhichkey == 'which-key' | source $HOME/.vimrc_helpers/folke_whichkey.vim | endif
if g:install_plug_vimwhichkey == 'vim-which-key' | source $HOME/.vimrc_helpers/vim-which-key.vim | endif
if g:install_plug_filetree == 'netrw' | source $HOME/.vimrc_helpers/netrw.vim | endif
if g:install_plug_filetree == 'nvimtree' | source $HOME/.vimrc_helpers/nvimtree.vim | endif
if g:install_plug_lsp == 'coc' | source $HOME/.vimrc_helpers/coc1_config.vim | endif
if g:install_plug_lsp == 'ale' | source $HOME/.vimrc_helpers/ale_config.vim | endif
if g:install_plug_fzf          | source $HOME/.vimrc_helpers/fzf.vim | endif
if g:install_plug_lsp == 'coc' | source $HOME/.vimrc_helpers/coc2_boilerplate.vim | endif
if g:install_plug_lsp == 'ale' && g:install_plug_fzf | source $HOME/.vimrc_helpers/alefzf_config.vim | endif
source $HOME/.vimrc_helpers/keymap_base.vim
if g:install_plug_comments == 'commentary' | source $HOME/.vimrc_helpers/commentary.vim | endif
if g:install_plug_comments == 'manual' | source $HOME/.vimrc_helpers/comments_manual.vim | endif
source $HOME/.vimrc_helpers/lightline.vim
source $HOME/.vimrc_helpers/linenumbers.vim
source $HOME/.vimrc_helpers/maximizer.vim
source $HOME/.vimrc_helpers/gitblame.vim
source $HOME/.vimrc_helpers/folding.vim
  source $HOME/.vimrc_helpers/foldingcoc.vim
source $HOME/.vimrc_helpers/autopairs.vim
source $HOME/.vimrc_helpers/fixvisualpaste.vim
source $HOME/.vimrc_helpers/keymap_windows.vim
source $HOME/.vimrc_helpers/bufferselect.vim
" source $HOME/.vimrc_helpers/bufferdiffs.vim
source $HOME/.vimrc_helpers/tmux.vim
source $HOME/.vimrc_helpers/togglezero.vim
source $HOME/.vimrc_helpers/togglehighlight.vim
source $HOME/.vimrc_helpers/sessions.vim
source $HOME/.vimrc_helpers/terminal.vim
source $HOME/.vimrc_helpers/trailingspaces.vim
source $HOME/.vimrc_helpers/config_endstuff.vim
" ###################################################################################
" #### END VIM CONFIGURATION
" ###################################################################################
