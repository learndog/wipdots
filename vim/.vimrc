" .vimrc    - WIP unfinished version 

    " Vim coc-pyright config for Python on Debian 11+ or Ubuntu 22+ (others may also work)   
" * Single file configuration with few dependencies
" * Configure which plugins to install or disable

" Requirements
" * Vim 8.2.3555+ with +python3 (see www.reddit.com/r/vim/comments/qub6j9/comment/hsi5rgq/)
"       Check python3 support with vim --version or :echo has('python3')
"       It should also work on Vim 7, but will not modify the default status line
"       coc.nvim requires at least Vim 8.1.1719 or Neovim 0.4.0
" * python3 -> sudo apt install python3 python3-pip
"       Try pyenv for a robust Python setup
" * black -> pip install black
" * fzf -> sudo apt install fzf (eg to switch buffers, open files)
"       [opt] bat (batcat) for fzf syntax highlights -> sudo apt install bat
"       [opt] ripgrep (rg) for fzf Rg command -> sudo apt-get install ripgrep
"       [opt] delta for git diff formatting (see github.com/dandavison/delta)
" * nodejs, npm -> sudo apt install nodejs npm (or install with NVM)
" * pyright -> pip install pyright (for coc python linting)
"       Note: pip install will automatically install node (microsoft.github.io/pyright/#/installation)

" Install Instructions for vim configuration
" * Save this file as ~/.vimrc
" * Edit it if you like... eg choose to disable (and not install) some plugins
" * Restart vim
" Note: The first time you run vim, it should do :PlugInstall and :CocInstall coc-pyright
" Note: There may be some differences running inside tmux, so you may have to adjust your tmux config and/or .vimrc
"       Check if tmux is active from vimscript... exists('$TMUX')
"       In windows you may not be able to find key control codes for your terminal with Ctrl-v. Try ctrl-q instead.

" Update Instructions
" :PlugUpdate to update all plugins
" :PlugUpdate <my-plugin> to update one plugin
" :PlugUpdate | PlugUpgrade to update all plugins and to upgrade vim-plug (but don't run 2nd without 1st)

" Restore vim to pristine just-installed condition
"   1. Delete the entire ~/.vim directory
"   2. Remove this .vimrc file

" Install current VIM from source
" Doesn't seem to work on gcp vertex AI vm. Try https://richrose.dev/posts/linux/vim/vim-compile/
"    sudo apt remove vim vim-tiny vim-common vim-gui-common vim-nox  vim-runtime gvim
"    cd && git clone https://github.com/vim/vim.git   # Current vim 9 seems to work!
"    cd vim && git pull
"    cd src && make distclean                      # Clean config files and all generated files
"    sudo apt install libncurses-dev python3-dev
"    # configure statement assumes python 3.7 with python3 cmd to run python
"    # You may need to modify the config stmt with-python-config-dir=my-python-header-files-dir
"    #     where the dir can be found with find /usr -name Python.h
"    #     For vertexai gcp, try 
"    #       make distclean                        # make clean would only remove intermed files and libs
"    #       --with-python-config-dir=/usr/include/python3.7m
"    ./configure --with-features=huge --enable-rubyinterp --enable-python3interp --with-python-config-dir=$(python3-config --configdir) --with-python3-command=python3 --enable-perlinterp --enable-gui=gtk2 --enable-cscope --enable-luainterp --enable-multibyte
"    make
"    sudo make install
"    make distclean              # Clean up uneeded configure files and make files after install

" Bonus Info... SSH Key Pair Setup
"   # For remote git repositories and/or ssh from terminal emulator to a server
"   ssh-keygen -t ed25519 -C "your_email@example.com"      # https://github.com/settings/keys
"   eval "$(ssh-agent -s)"                                 # Add private key to ssh agent. May vary by OS
"   ssh-add ~/.ssh/id_ed25519
"   # For linux server, also add public key to ~/.ssh/authorized_keys
"   # For github.com, go to settings to add public key

" Bonus Info... Stow instructions
"     # Assumes a github repository user/dotfiles with config file dotfiles/vim/.vimrc
"     sudo apt-get install stow
"     cd ~ && git clone git@github.com/github_user/github_repository
"     cd ~/dotfiles
"     stow -t ~ vim               # Create symlink(s) in ~/ pointing to each file INSIDE dotfiles/vim/

" Bonus Info... TMUX
"     # See https://github.com/gpakosz/.tmux for oh my tmux (requires tmux 2.4)
"     # Or a basic simple config at https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
"     # This .vimrc saves Alt-a for tmux prefix (map as <M-a>)

" Bonus Info... Git
"     # To see changes in a vim buffer not yet saved, use <Leader>ds
"     # To see changes in a local saved, unstaged file vs previous commit, use $ git diff
"     # To see changes in a local saved, staged file vs previous commit, use $ git diff --staged
"     # To compare two local branches (or remote) use git fetch, and git diff branch1 branch2
"     # To compare committed changes in a local branch vs remote branch changes between branches use
"       git, fetch and git diff my_local_branch origin/my_local_branch
"     # To compare two commits use git diff commit1 commit2 
"       Use HEAD for last commit. HEAD^ or HEAD~1 for the previous commit.
"       HEAD~2, HEAD~3, etc before that. 
"       HEAD^2 refers to the 2nd parent of the current commit.
"              It is NOT the grandparent of the current commit, and it is only valid for merge commits.
"

" Bonus Info... Install Python with pyenv
" Note: Your dotfiles may already have the content contained below in .bashrc
" # Install pyenv and latest python version using github.com/pyenv/pyenv#installation
" ! [ -d "~/temp_install/" ] && mkdir ~/temp_install && cd ~/temp_install      # Create install dir if doesn't exist
" git clone --depth 1 https://github.com/pyenv/pyenv.git ~/.pyenv
" echo $BASH_ENV                                                                  # Ensure BASH_ENV DOES NOT point to .bashrc (could create infinite loop)
" echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
" echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
" echo 'eval "$(pyenv init -)"' >> ~/.bashrc
" exec "$SHELL"                                                                   # Restart shell for PATH changes to be in effect
" sudo apt install build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev # Python build dependencies
" pyenv install 3.11.3                                                            # Install latest python. Use pyenv install -l to find latest available
" pyenv global 3.11.3                                                             # Install python as the global version
" pyenv versions                                                                  # Confirm it
" python -m venv --system-site-packages ~/venvs/nvim                              # Set up nvim and myproject envs in ~/venvs/
" python -m venv --system-site-packages ~/venvs/myproject                         # See docs.python.org/3/library/venv.html
" cp ~/venvs/myproject/bin/activate ~/venvs/activate_myproject                    # Make the activate script easy to call
" cp ~/venvs/nvim/bin/activate ~/venvs/activate_nvim                              # Make the activate script easy to call
" source ~/venvs/activate_nvim                                                    # Activate nvim before the neovim install and config
" python --version
" which python
" pip --version


" TODO: Colorscheme - See https://vimcolorschemes.com/ for more options
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

" CURRENT TIDY UP
" TODO: Move plugin repos to a work fork and disable vim-which-key by default
" TODO: Fix git diff (<Leader>dg)
" TODO: Quirks to fix
"         Commenting should start at first nonws char, not col pos 1
"         First position " in new line creates an Autopair
"         coc CR to accept selected completion (but <C-g>u breaks current undo)
"         jl from insert mode doesn't jump out of parentheses for quotes. Also add jh to jump left?
"         autopair brackets - if {<CR> slowly, it fills in with funny stuff - stop it!
"         move selected (indent or move up) text loses selection so cant repeat. Honors indents?
" TODO: Fix Ctrl-arrows and status line colors for vim running in tmux

" BACKLOG FEATURES
" TODO: Add toggle for light / dark color theme (or a .vimrc paramter to set color theme)
" TODO: Map jh to move left inside braces
" TODO: Better splits and windows - see https://github.com/Aster89/WinZoZ/tree/main
" TODO: Fuzzy find file in same dir as buffer
" TODO: Use coc boilerplate example to be more precise about versions needed for statusline
" TODO: :Commits and :BCommits commands as in
"         https://bluz71.github.io/2018/12/04/fuzzy-finding-in-vim-with-fzf.html
"         Try other fzf - pattern match, MRU files, etc
"         MRU or same dir files...  nnoremap <silent> <Space>. :Files <C-r>=expand("%:h")<CR>/<CR>
" TODO: File and git and notebook diffs and git merge both in Vim and on command line
"         See locally saved discussion: vim+fzf File Diff
"         See github.com/dandavison/delta and difftastic and vimdiff
"         See github.com/mkchoi212/fac  for merge conflict resolution
"         Also see github.com/whiteinge/diffconflicts for vim-diffconflicts
" TODO: Add vim-ipython-cell (run cells inside .py files in Vim)
"       and/or jupyter console with script to start kernel and connect to it (lastest one)
"         See locally saved discussion
"         and see code.visualstudio.com/docs/python/jupyter-support-py
"         and see stackoverflow.com/questions/64730660/how-do-i-find-excute-python-interactive-mode-in-visual-studio-code
"         and https://github.com/luk400/vim-jukit
"         and https://github.com/jpalardy/vim-slime
" TODO: Code Runners, Test Runners
" TODO: Quick switch between code and unit test, Python REPL
" TODO: Debug python in terminal
"         See www.reddit.com/r/vim/comments/jg91dt/using_termdebug_for_pythons_pdb_examples/
" TODO: Nvim compatibility
" TODO: Use forked fugitive, maximizer, tmuxvimnavigator, whichkey, autoformat, ...
"       Try this...
"         To ensure that the forked versions of coc.nvim and coc-pyright are installed,
"         you can specify the URL of your forked repositories in your .vimrc file.
"         Here’s an example of how you can do this:
"           Replace 'your-username' with your GitHub username
"           Plug 'your-username/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
"           Plug 'your-username/coc-pyright', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
"           or Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile'}
"         After updating your .vimrc file, you can run :PlugInstall to install the plugins from your forked
"         repositories. You don’t need to run :CocInstall coc-pyright since you have already
"         specified the forked repositories in your .vimrc file.
"
" Out of scope but needed: Git TUI tools or Vim integration
"         For git TUI tools, see dev.to/mainendra/terminal-ui-for-git-283p
"         and github.com/frontaid/git-cli-tools
"         and github.com/rhysd/conflict-marker.vim

" ### SECTION: CHOOSE WHICH PLUGINS TO INSTALL OR DISABLE (if disabled and not present, it will not be installed)
" 0 to disable but not uninstall; 1 to install/enable (Also disables/enables the related config code)
let g:install_plug_fzf = 1        " Also controls fxf.vim and bat (closely integrated with fzf)
let g:install_plug_coc = 1        " Also controls coc-related configuration for fzf
let g:install_plug_gitgutter = 1
let g:install_plug_vimwhichkey = 1 " Could probably use whichkey.nvim but vim may not support lua


" #### SECTION: BASIC SETTINGS

" Set leader to <space>
"let mapleader = "\<Space>"
let g:mapleader = " "
let g:maplocalleader = ' '     " Added for vim-which-key (default was ,)
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  '<Space>'<CR>

set noerrorbells               " Alarm style needs to be set/disabled in term emulator
set novisualbell               " For MS Term with WSL change in settings per target OS
set timeoutlen=300             " So it doesn't wait too long for a keymap sequence
"                              " vim-which-key requirement: DO NOT set notimeout
set ttimeoutlen=50             " Time after an ESC waiting for key sequence. Short is good to exit INSERT mode.
" Too small could cause emulator or remote connection problems
highlight WhichKey ctermbg=gray guibg=gray
highlight WhichKeySeperator ctermbg=gray guibg=gray
highlight WhichKeyGroup ctermbg=green guibg=green
highlight WhichKeyFloating ctermbg=gray guibg=gray
highlight WhichKeyDesc ctermbg=gray guibg=gray
set encoding=utf-8
set nobackup
set nowritebackup
set showcmd                    " display incomplete commands at the bottom
set shortmess+=c               " Recommended setting for coc.nvim
set shortmess-=S               " show the current match position
set updatetime=300
set number                     " Enable line numbers
set tabstop=3                  " Set the tab width
set shiftwidth=3
set expandtab
set ttyfast                    " make laggy connections work faster
set nowrap                     " Disable line wrapping
"set gdefault                   " Set global replace (all occurances) for substitute
set clipboard=unnamedplus      " Enable clipboard support (req vim compiled +clipboard)
set mouse=a                    " Enable mouse support
set hlsearch
set incsearch
set ignorecase
set smartcase
set textwidth=120
set whichwrap=bs<>[]           " Be able to arrow key and backspace across newlines
syntax enable                  " Enable syntax highlighting
set autoindent                 " Enable auto-indentation
set splitright                 " For :new
set smartindent                " Sometimes adds one extra level
set smarttab                   " Tab behavior, eg deleting at start of line
set encoding=utf-8             " Set the encoding to UTF-8
set ruler                      " Enable line and column numbers
set title                      " Show the filename in the window titlebar
set background=dark            " Or use light
set laststatus=2               " Enable the status line
if has("mouse_sgr")            " Allow mouse clicks anywhere (eg past column 88) if supported
   set ttymouse=sgr
else
   set ttymouse=xterm2
end
set signcolumn=yes

" auto-reload vimrc
" autocmd! bufwritepost vimrc source ~/.vim/vimrc

" #### SECTION: VIM-PLUG

" BEGIN vim-plug autominstall if missing. Add before plug#begin. Audit the script before running.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
   silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" END  vim-plug autoinstall

" Install included plugins
call plug#begin()
if g:install_plug_fzf == 1
   Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
   Plug 'junegunn/fzf.vim'
   Plug 'sharkdp/bat'
endif
if g:install_plug_coc == 1         | Plug 'neoclide/coc.nvim', {'branch': 'release'} | endif
if g:install_plug_gitgutter == 1   | Plug 'learndog/vim-gitgutter', {'branch': 'release'} | endif
if g:install_plug_vimwhichkey == 1 | Plug 'learndog/vim-which-key', {'branch': 'release'} | endif

call plug#end()

" #### VIMWHICHKEY SETUP
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" #### SECTION: COC SETUP (and coc fuzzy finders)
if g:install_plug_coc == 1

   " coc.nvim configuration
   set nocompatible
   filetype plugin indent on
   syntax on
   set hidden

   " Install the coc-jedi and coc-pyright extensions
   let g:coc_global_extensions = ['coc-jedi', 'coc-pyright']

   " Use <Leader>ls instead. Conflicts with fuzzy search (within lines)
   " nnoremap <C-s> :CocList symbols<CR>
   " Use <leader>lr instead. Conflicts with Redo.
   " nnoremap <C-r> :CocList references<CR>

   let g:coc_user_config = {
            \ "python.linting.enabled": 1,
            \ }
"      \ "python.formatting.provider": "autopep8",
"      \ "coc.preferences.codeLens.enable": 1,
"      \ "python.jediEnabled": 1,
"      \ "python.codelens.enabled": 1,
   "   \ "coc.preferences.maxHeight": 30
   "   \ "pyright.enable": 1,
   "   \ "jedi.diagnostics.enable": 1,
   "   \ "jedi.diagnostics.didOpen": 1,
   "   \ "jedi.diagnostics.didChange": 1,
   "   \ "jedi.diagnostics.didSave": 1


   " BEGIN - KEYMAPS FOR LSP

   " coc.nvim navigation commands
   nnoremap <F4> :CocPrev<CR>
   nnoremap <F5> :CocNext<CR>
   nnoremap <F6> :CocFirst<CR>
   nnoremap <F7> :CocLast<CR>
   " coc.nvim go-to commands DELETE THESE???
   " nnoremap <Leader>gd :CocDefinition<CR>
   " nnoremap <Leader>gi :CocImplementation<CR>
   " nnoremap <Leader>gt :CocTypeDefinition<CR>
   " nnoremap <Leader>fr :CocReferences<CR>
   " nnoremap <Leader>hh :CocHover<CR>
   " nnoremap <Leader>ar :CocRename<CR>
   " coc.nvim code actions
   " nnoremap <Leader>ca :CocAction<CR>

   " From another coc vimrc - almost finished
   noremap <leader>ld :call CocAction('jumpDefinition')<CR>
   nnoremap <leader>lr :call CocAction('references')<CR>
   nnoremap <leader>ln :call CocAction('rename')<CR>
   nnoremap <leader>la :call CocAction('codeAction')<CR>
   nnoremap <leader>lk :call CocAction('doHover')<CR>
   nnoremap <leader>f :call CocAction('format')<CR>
   " Add `:Format` command to format current buffer
   " command! -nargs=0 Format :call CocActionAsync('format')
   " nmap <leader>f :Format<CR>


   " END - KEYMAPS FOR LSP


endif
" ################ END CONDITIONAL COC SETUP LINES

if 1==1
   "if g:install_plug_fzf == 1
   " #### SECTION: FUZZY FIND NON-LSP SETUP

   nnoremap <Leader>b :Buffer<CR>
   nnoremap <Leader><space> :Buffer<CR>

   " fzf, fzf.vim configuration
   " NOTE: If delta is available, GF?, Commits and BCommits will use it to format git diff output.
   let g:fzf_preview_command = 'bat --color "always" {}'
   let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
   " fzf configuration #2
   let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.6 } }
   " Set fzf to use bat for syntax highlighting
   "let $FZF_DEFAULT_OPTS = '--preview "bat --color=always {}"'
   " " Keymaps for fuzzy searches
   nnoremap <C-p> :Files<CR>
   nnoremap <C-s> :BLines<CR>

   " BEGIN - FUZZY FIND KEY MAPS
   " First a function with a fuzzy finder
   function! FuzzyFindKeyMappings()
      " Redirect the output of the :map command to a variable
      redir => mappings
      silent map
      redir END

      " Split the mappings into a list of lines
      let lines = split(mappings, '\n')

      " Use fzf#run to search through the list of lines
      call fzf#run({
               \ 'source': lines,
               \ 'sink': 'e',
               \ 'options': '--preview-window right:50%',
               \ 'down': '40%'
               \})
   endfunction
   " Now a function that does literal string searches for key maps
   function! LiteralFindKeyMappings()
      " Redirect the output of the :map command to a variable
      redir => mappings
      silent map
      redir END

      " Split the mappings into a list of lines
      let lines = split(mappings, '\n')

      " Use fzf#run to search through the list of lines
      call fzf#run({
               \ 'source': lines,
               \ 'sink': 'e',
               \ 'options': '--exact --preview-window right:50%',
               \ 'down': '40%'
               \})
   endfunction

   " Map <leader>fm to call LiteralFindKeyMappings or FuzzyFindKeyMappings
   nnoremap <leader>fm :call LiteralFindKeyMappings()<CR>
   "nnoremap <leader>fm :call FuzzyFindKeyMappings()<CR>

   " END - FUZZY FIND KEY MAPS
endif
" ############# END CONDITIONAL FUZZY FIND SETUP (NON-LSP)

" #### SECTION: Line Number Cycling
function! CycleLineNumbers()
   if &number && &relativenumber
      set nonumber norelativenumber
   elseif &number
      set relativenumber
   elseif &relativenumber
      set nonumber norelativenumber
   else
      set number
   endif
endfunction
nnoremap <F8> :call CycleLineNumbers()<CR>
nnoremap <Leader>n :call CycleLineNumbers()<CR>

" #### SECTION: STATUS LINE
" TODO: Check https://sidneyliebrand.io/blog/creating-my-own-vim-statusline
" TODO: Check https://github.com/itchyny/lightline.vim
if has('patch-8.2.3555')  " Remove status line for old vim versions

   " Get the virtual environment
   function! GetVenvName()
      " Check if the VIRTUAL_ENV variable exists
      if exists('$VIRTUAL_ENV')
         " Get the value of the VIRTUAL_ENV variable
         let venv_path = $VIRTUAL_ENV
         " Check if the value is not empty
         if !empty(venv_path)
            " Split the path into components
            let path_components = split(venv_path, '/')
            " Get the last component of the path
            let venv_name = path_components[-1]
            " Return the name of the virtual environment
            return venv_name
         else "VIRTUAL_ENV variable is empty
            return ">none<"
         endif
      else " No VIRTUAL_ENV variable exists
         return 'NoEnvVar'
      endif
   endfunction

   function! GetStatusLineFileName(win_len_break, file_break)
      let file_string = ''
      if winwidth(0)>a:win_len_break && strchars(expand('%:p')) > a:file_break
         let file_string = expand('%:p')
      elseif winwidth(0)>a:win_len_break && strchars(expand('%:p')) <= a:file_break
         let file_string = expand('%:t')
      endif
      return file_string
   endfunction

   function! GetFormattedTime(win_len_break)
      let time_string = ''
      if winwidth(0)>a:win_len_break
         let time_string = strftime('%Y-%m-%d\ %I:%M:%S')
      endif
      return time_string
   endfunction

   function! GetStatusCwd(win_len_break, cwd_break)
      let cwd_string = ''
      if winwidth(0)>a:win_len_break && strchars(getcwd())>a:cwd_break
         let cwd_string = getcwd()
      endif
      if winwidth(0)>a:win_len_break && strchars(getcwd())<=a:cwd_break
         let cwd_string = fnamemodify(getcwd(), ':t') " Remove the parent path
      endif
      return cwd_string
   endfunction

   " Get the git branch
   " From itchyny/vim-gitbranch
   " =============================================================================
   " Author: itchyny
   " License: MIT License
   " Last Change: 2021/08/20 23:05:12.
   " =============================================================================

   let s:save_cpo = &cpo
   set cpo&vim

   function! GitBranchName() abort
      if get(b:, 'gitbranch_pwd', '') !=# expand('%:p:h') || !has_key(b:, 'gitbranch_path')
         call GitBranchDetect(expand('%:p:h'))
      endif
      if has_key(b:, 'gitbranch_path') && filereadable(b:gitbranch_path)
         let branch = get(readfile(b:gitbranch_path), 0, '')
         if branch =~# '^ref: '
            return substitute(branch, '^ref: \%(refs/\%(heads/\|remotes/\|tags/\)\=\)\=', '', '')
         elseif branch =~# '^\x\{20\}'
            return branch[:6]
         endif
      endif
      return ''
   endfunction

   function! GitBranchDir(path) abort
      let path = a:path
      let prev = ''
      let git_modules = path =~# '/\.git/modules/'
      while path !=# prev
         let dir = path . '/.git'
         let type = getftype(dir)
         if type ==# 'dir' && isdirectory(dir.'/objects') && isdirectory(dir.'/refs') && getfsize(dir.'/HEAD') > 10
            return dir
         elseif type ==# 'file'
            let reldir = get(readfile(dir), 0, '')
            if reldir =~# '^gitdir: '
               return simplify(path . '/' . reldir[8:])
            endif
         elseif git_modules && isdirectory(path.'/objects') && isdirectory(path.'/refs') && getfsize(path.'/HEAD') > 10
            return path
         endif
         let prev = path
         let path = fnamemodify(path, ':h')
      endwhile
      return ''
   endfunction

   function! GitBranchDetect(path) abort
      unlet! b:gitbranch_path
      let b:gitbranch_pwd = expand('%:p:h')
      let dir = GitBranchDir(a:path)
      if dir !=# ''
         let path = dir . '/HEAD'
         if filereadable(path)
            let b:gitbranch_path = path
         endif
      endif
   endfunction

   let &cpo = s:save_cpo
   unlet s:save_cpo

   " =============================================================================
   " Author: itchyny
   " License: MIT License
   " Last Change: 2015/05/12 08:16:47.
   " =============================================================================

   if exists('g:loaded_gitbranch') || v:version < 700
      finish
   endif
   let g:loaded_gitbranch = 1

   let s:save_cpo = &cpo
   set cpo&vim

   augroup GitBranch
      autocmd!
      autocmd BufNewFile,BufReadPost * call GitBranchDetect(expand('<amatch>:p:h'))
      autocmd BufEnter * call GitBranchDetect(expand('%:p:h'))
   augroup END

   let &cpo = s:save_cpo
   unlet s:save_cpo

   " END - Git branch code

   " Define the highlight groups for each mode
   "Orange may be 202
   hi NormalColor guifg=Black guibg=Green ctermbg=Red ctermfg=0
   hi NormalHeadColor guifg=Green guibg=Gray ctermbg=Green ctermfg=0
   hi NormalTailColor guifg=Black guibg=Gray ctermbg=Gray ctermfg=0
   hi InsertColor guifg=Black guibg=Orange ctermbg=Red ctermfg=0
   hi ReplaceColor guifg=Black guibg=Yellow ctermbg=LightRed ctermfg=0
   hi VisualColor guifg=Black guibg=Orange ctermbg=LightBlue ctermfg=0
   hi OtherColor guifg=Black guibg=Orange ctermbg=Yellow ctermfg=0
   hi ModifiedColor ctermbg=LightYellow ctermfg=0
   hi UnmodifiedColor ctermbg=Gray ctermfg=0

   function! SetStatusLine()

      " Modified
      let sl='%#ModifiedColor#%{(&modified)?''[+]'':''''}'
      let sl.='%{(!&modified)?'''':''''}'

      " Mode name
      " let sl.='%{coc#status()}'

      if g:install_plug_coc == 1
         let sl.='%{coc#status()}%{get(b:,''coc_current_function'','''')}'
      endif
      let sl.='%#NormalHeadColor#%{(mode()==''n'')?''\ \ NORMAL\ '':''''}'
      let sl.='%#InsertColor#%{(mode()==''i'')?''\ \ INSERT\ '':''''}'
      let sl.='%#ReplaceColor#%{(mode()==''R'')?''\ \ REPLACE\ '':''''}'
      let sl.='%#VisualColor#%{(mode()==''v'')?''\ \ VISUAL\ '':''''}'

      " Main content - Left
      let sl1='\ \[%{GitBranchName()}\]'
      let sl1.= GetStatusLineFileName(70, 25)
      "let sl1.='%<%f\'
      let sl1.='%h%m%r%w\ '

      " Main content - Right
      let sl2='%=\ \[%{GetVenvName()}\]'
      let sl2.='\ ' . GetStatusCwd(80,30)
      let sl2.='\ ' . GetFormattedTime(70)
      let sl2.='\ \|\ %l/%L\[%{line(''.'')*100/line(''$'')}%%]%3v'

      let fullsl = ''
      if mode() == 'n'
         let fullsl= sl . '%#NormalTailColor#' . sl1 . sl2
      elseif mode()  == 'i'
         let fullsl= sl . '%#InsertColor#' . sl1 . sl2
      elseif mode()== 'v'   " || mode() == '<C-V>' || mode() == 's' || mode() == '^S'
         let fullsl= sl . '%#VisualColor#' . sl1 . sl2
      elseif mode() == 'R'   " || mode() == 'Rv'
         let fullsl = sl . '%#ReplaceColor#' . sl1 . sl2
      else
         return
      endif
      set statusline=
      execute 'set statusline='.fullsl
   endfunction

   " Call once for the initial status line
   call SetStatusLine()

   " autocmd InsertEnter * set statusline+=%#InsertColor#
   augroup NormalModeEvent
      autocmd!
      autocmd ModeChanged *:n call SetStatusLine()
      autocmd ModeChanged n:* call SetStatusLine()
      autocmd VimResized * :call SetStatusLine()
   augroup END

   if g:install_plug_coc == 1
      autocmd User CocStatusChange redrawstatus
   endif

   call timer_start(1000, {-> execute(':let &stl=&stl')}, {'repeat': -1})

   " ########### END STATUS LINE CONFIGURATION #############################
endif

" ============================================
" From https://github.com/szw/vim-maximizer
" vim-maximizer - Maximizes and restores the current window
" License:
" Copyright (c) 2012-2015 Szymon Wrozynski and Contributors.
" Distributed under the same terms as Vim itself.
" No changes
" Maintainer:   Szymon Wrozynski
" Version:      1.0.5
" ============================================
"
" :MaximizerToggle
" When the current window is not in maximized state, Vim-Maximizer saves dimensions and positions of all windows
" in the current tab, and then it performs maximization of the active window.
" The second time the command is invoked, Maximizer restores all windows to the previously saved positions.
"
" :MaximizerToggle!
" The bang version forces the restoration of previously saved state (if any).
" It can be used in case you did some changes in the maximized state layout
" and the current window is not maximized anymore.
" Despite that, the bang version force restoration anyway.
" Notice, the bang version can be set as the default one in your mappings.
"
" Works in any mode, not just normal mode

nnoremap <silent><Leader>m :MaximizerToggle!<CR>
vnoremap <silent><Leader>m :MaximizerToggle!<CR>gv
" Don't do this because it interferes with typing
"inoremap <silent><Leader>m <C-o>:MaximizerToggle!<CR>

let g:maximizer_restore_on_winleave = 0
let g:maximizer_default_mapping_key = '<F3>'

command! -bang -nargs=0 -range MaximizerToggle :call s:toggle(<bang>0)

fun! s:maximize()
   let t:maximizer_sizes = { 'before': winrestcmd() }
   vert resize | resize
   let t:maximizer_sizes.after = winrestcmd()
   normal! ze
endfun

fun! s:restore()
   if exists('t:maximizer_sizes')
      silent! exe t:maximizer_sizes.before
      if t:maximizer_sizes.before != winrestcmd()
         wincmd =
      endif
      unlet t:maximizer_sizes
      normal! ze
   end
endfun

fun! s:toggle(force)
   if exists('t:maximizer_sizes') && (a:force || (t:maximizer_sizes.after == winrestcmd()))
      call s:restore()
   elseif winnr('$') > 1
      call s:maximize()
   endif
endfun

if g:maximizer_restore_on_winleave
   augroup maximizer
      au!
      au WinLeave * call s:restore()
   augroup END
endif
" ====END WINDOW MAXIMIZER =================================="


" #### SECTION: GitBlame
" Use command :Blame to get a split window with all lines of the code prefixed with the git blame
function! GitBlame()
   let l:filename = expand('%')
   let l:dirname = expand('%:p:h')
   let l:blame = system('cd ' . l:dirname . ' && git blame ' . l:filename)
   vnew
   setlocal buftype=nofile
   setlocal bufhidden=hide
   setlocal noswapfile
   call setline(1, split(l:blame, '\n'))
endfunction

command! Blame call GitBlame()


" #### SECTION: GOTO (ERROR) POSITION

function! GoToPosition()
   " Prompt the user for the position
   let l:user_input = input("Enter target position as line [character]: ")

   " Remove tabs
   let l:user_input = substitute(l:user_input, '\t', '', 'g')

   " Strip leading and trailing spaces
   let l:user_input = substitute(l:user_input, '^\s\+', '', '')
   let l:user_input = substitute(l:user_input, '\s\+$', '', '')

   " Split the input into words using space
   let l:parts = split(l:user_input, ' ')

   " Extract line number and optionally character position
   let l:line_num = l:parts[0]
   let l:char_pos = (len(l:parts) > 1) ? l:parts[1] : 1

   " Check if line number is a valid number
   if l:line_num !~ '^\d\+$' || (len(l:parts) > 1 && l:char_pos !~ '^\d\+$')
      echo "Line and character should be positive numbers"
      return
   endif

   " If the line number is past the end of the file, move to the last line
   if l:line_num > line("$")
      let l:line_num = line("$")
   endif

   " Move to the line number
   execute l:line_num

   " If the character position is greater than the last character position in the line, move to the last position
   if l:char_pos > col("$") - 1
      let l:char_pos = col("$") - 1
   endif

   " Move to the character position
   normal! 0
   execute "normal! " . l:char_pos . "l"
endfunction

" Map <Leader>ge to call the function in normal mode
nnoremap <Leader>ge :call GoToPosition()<CR>

" END - GOTO (ERROR) POSITION


" #### BEGIN - CODE FOLDING (vanilla)
set foldlevelstart=99
highlight Folded guifg=white guibg=grey30 ctermfg=white ctermbg=lightgrey
autocmd FileType python setlocal foldmethod=indent
" END - CODE FOLDING (vanilla)

" #### BEGIN - CUSTOM CODE FOLDING FEATURES
function! SafeToggleFold()
   " Check if the current line is foldable
   if foldlevel('.') == 0
      " Toggle fold if foldable
      normal! za
   endif
endfunction
"nnoremap <Space> :call SafeToggleFold()<CR>

" Toggle folds

function! ToggleAllFolds()
   " Initialize variable to false
   let l:hasClosedFold = 0

   " Loop through each line in the buffer
   for l:line in range(1, line('$'))
      if foldclosed(l:line) != -1
         " Found a closed fold
         let l:hasClosedFold = 1
         break
      endif
   endfor

   if l:hasClosedFold
      " Open all folds
      normal! zR
      echo "All folds have been opened"
   else
      " Close all folds
      normal! zM
      echo "All folds have been closed"
   endif
endfunction

nnoremap <Leader>z :call ToggleAllFolds()<CR>

" Fold everything below the specified level

function! SafeFoldToLevel(...)
   " Determine the context: normal mode vs command-line mode
   if a:0 == 0
      " Normal mode: get the next character
      let l:level = nr2char(getchar())
   else
      " Command-line mode: use the provided argument
      let l:level = a:1
   endif

   " Ensure the input is numeric and between 0 to 9
   if l:level =~ '^[0-9]$'
      execute 'set foldlevel=' . l:level
      echo "Fold level set to " . l:level
   else
      echo "Invalid fold level: " . l:level . ". Acceptable values are 0 to 9."
   endif
endfunction


" Normal mode mapping
"nnoremap zl :call SafeFoldToLevel()<CR>

" Command-line mode mapping
command! -nargs=* Z call SafeFoldToLevel(<f-args>) " Set fold level (0-9)

" Universal folding behavior
set foldmethod=indent

if g:install_plug_coc == 1
   " BEGIN - COC FOLDING ONLY
   " Add `:Fold` command to fold current buffer
   "command! -nargs=? Fold :call     CocAction('fold', <f-args>)
   " END - COC FOLDING ONLY
endif

" Note: z0-z9 are available to be mapped (but calls to SafeFold didnt work)

" Use 'zR' to open all folds and 'zM' to close all folds
" END - CUSTOM CODE FOLDING FEATURES

" #### SECTION: Diff with saved and git checked out version
" From https://vim.fandom.com/wiki/Diff_current_buffer_and_the_original_file
" To exit diff view, use :diffoff command
function! s:DiffWithGITCheckedOut()  " Only on Linux?
   let filetype=&ft
   diffthis
   vnew | exe "%!git diff " . fnameescape( expand("#:p") ) . "| patch -p 1 -Rs -o /dev/stdout"
   exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
   diffthis
endfunction
com! DiffGIT call s:DiffWithGITCheckedOut()

function! s:DiffWithSaved()
   let filetype=&ft
   diffthis
   vnew | r # | normal! 1Gdd
   diffthis
   exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

nnoremap <Leader>dg :DiffGIT<CR> 
nnoremap <Leader>ds :DiffSaved<CR>

" #### SECTION: AUTOPAIRS
" Vanilla Vim Autopairs
" Comment aware: Will only double in INSERT mode if not the first non space/tab char
" Warning: Will also NOT double a first non-comment character. Won't work with set paste option

" For quotes
inoremap <expr> " getline('.')[0:col('.')-2] =~ '[^\s]' ? '"' : '""<left><C-o>:noh<CR>'
inoremap <expr> ' getline('.')[0:col('.')-2] =~ '[^\s]' ? "'" : "''<left><C-o>:noh<CR>"
inoremap <expr> ` getline('.')[0:col('.')-2] =~ '[^\s]' ? '`' : '``<left><C-o>:noh<CR>'

" For brackets
inoremap <expr> ( getline('.')[0:col('.')-2] =~ '[^\s]' ? '(' : '()<left>'
inoremap <expr> [ getline('.')[0:col('.')-2] =~ '[^\s]' ? '[' : '[]<left>'
inoremap <expr> { getline('.')[0:col('.')-2] =~ '[^\s]' ? '{' : '{}<left>'

inoremap (<CR> (<CR>)<ESC><<<ESC>O<TAB>
inoremap [<CR> [<CR>]<ESC><<<ESC>O<TAB>
inoremap {<CR> {<CR>}<ESC><<<ESC>O

" END - Vanilla Vim Autopairs


" #### SECTION: COMMENTING

" BEGIN - Comment without plugin - visual and normal mode - toggle comments with <Ctrl-/> or <Leader-/>
" This version also unhighlights after <Leader>// and keeps the visual selection after toggling comments
" Instructions...
" Pressing <Ctrl-/>, <Ctrl-Shift-/>, or <Leader>/ will toggle the comment state of lines,
" while pressing <Leader>// will always comment lines

function! ConditionalCommentUncomment(start, end)
   " Check the first non-space/non-tab character of the first line of the visual selection
   let firstChar = matchstr(getline(a:start), '^\s*\zs.')
   if firstChar == b:comment_symbol[0]
      " Uncomment action
      silent execute a:start.','.a:end.'s#^\(\s*\)' . b:comment_symbol . '\s\?#\1#'
   else
      " Comment action
      silent execute a:start.','.a:end.'s#^#'.b:comment_symbol.' #'
   endif
endfunction

function! VisualCommentUncomment()
   " Save the current visual selection
   let saved_reg = @@
   normal! gv"ay

   " Call the ConditionalCommentUncomment function on the visual selection
   call ConditionalCommentUncomment(line("'<"), line("'>"))

   " Restore the visual selection
   let @@ = saved_reg
   normal! gv

   " Clear search highlighting
   nohlsearch
endfunction

function! VisualComment()
   " Save the current visual selection
   let saved_reg = @@
   normal! gv"ay

   " Comment the visual selection
   silent execute ":'<,'>s#^#".b:comment_symbol." #"

   " Restore the visual selection
   let @@ = saved_reg
   normal! gv

   " Clear search highlighting
   nohlsearch
endfunction

augroup visual_commenting
   autocmd!
   autocmd FileType c,cpp,java,rust  let b:comment_symbol = '//'
   autocmd FileType vim              let b:comment_symbol = '"'
   autocmd FileType python,sh,yaml   let b:comment_symbol = '#'
   autocmd FileType sql              let b:comment_symbol = '--'
   autocmd FileType tex              let b:comment_symbol = '%'
   autocmd BufEnter * silent! vnoremap <silent> <C-_> :<C-u>call VisualCommentUncomment()<CR>
   autocmd BufEnter * silent! nnoremap <silent> <C-_> :call ConditionalCommentUncomment(line('.'), line('.'))<CR>
   "     autocmd BufEnter * silent! vnoremap <silent> <C-?> :<C-u>call VisualCommentUncomment()<CR>
   "     autocmd BufEnter * silent! nnoremap <silent> <C-?> :call ConditionalCommentUncomment(line('.'), line('.'))<CR>
   autocmd BufEnter * silent! vnoremap <silent> <Leader>/ :<C-u>call VisualCommentUncomment()<CR>
   autocmd BufEnter * silent! nnoremap <silent> <Leader>/ :call ConditionalCommentUncomment(line('.'), line('.'))<CR>
   autocmd BufEnter * silent! vnoremap <silent> <Leader>// :<C-u>call VisualComment()<CR>
   autocmd BufEnter * silent! nnoremap <silent> <Leader>// :s/^/\=b:comment_symbol . ' '/<CR>:nohlsearch<CR>
augroup END

" ### SECTION: FIX PASTE CLIPBOARD
" This supports "rp that replaces the selection by the contents of @r
" stackoverflow.com/questions/290465/how-to-paste-over-without-overwriting-register/290723#290723
" and stackoverflow.com/questions/290465/how-to-paste-over-without-overwriting-register/4446608#4446608
function! s:Repl()
   let s:restore_reg = @"
   return "p@=RestoreRegister()\<cr>"
endfunction
function! RestoreRegister()
   let @" = s:restore_reg
   if &clipboard == "unnamed"
      let @* = s:restore_reg
   elseif &clipboard == "unnamedplus"
      let @+ = s:restore_reg
   endif
   return ''
endfunction
vnoremap <silent> <expr> p <sid>Repl()

" #### SECTION: FIX PAGE UP/DOWN SCROLL BEHAVIOR TO KEEP CURSOR IN MIDDLE
" For normal mode
" nnoremap <S-UP> <C-b><C-u>:normal! M<CR>
" nnoremap <S-DOWN> <C-f><C-d>:normal! M<CR>
" " For insert mode
" inoremap <S-UP> <C-o><C-b><C-o><C-u><C-o>:normal! M<CR>
" inoremap <S-DOWN> <C-o><C-f><C-o><C-d><C-o>:normal! M<CR>
" " For visual mode
" xnoremap <S-UP> <C-b><C-u>Mgv
" xnoremap <S-DOWN> <C-f><C-d>Mgv
" " For replace mode (R)
" inoremap <S-UP> <C-o><C-b><C-o><C-u><C-o>:normal! M<CR>
" inoremap <S-DOWN> <C-o><C-f><C-o><C-d><C-o>:normal! M<CR>
" noremap <S-UP> <C-b>M
" noremap <S-DOWN> <C-f>M
" noremap <C-UP> <S-UP>M
" noremap <C-DOWN> <S-DOWN>M

" #### SECTION: WINDOWS
" WARN: Some term emulators can distinguish Ctrl-shift, but not all.
"       So place <C-S- > mappings before the non-shift equivalent is mapped.

" Resize as increase or decrease - needs repeatable keystroke. Keep this before <C-hjkl>!
nnoremap <M-LEFT>  :vertical resize -10<CR>
nnoremap <M-RIGHT> :vertical resize +10<CR>
nnoremap <M-UP>    :resize +5<CR>
nnoremap <M-DOWN>  :resize -5<CR>

" Move to Window - Redundant but explicit
nnoremap <C-w><LEFT> <C-w><LEFT>
nnoremap <C-w><DOWN> <C-w><DOWN>
nnoremap <C-w><UP> <C-w><UP>
nnoremap <C-w><RIGHT> <C-w><RIGHT>
nnoremap <C-w>h <C-w>h
nnoremap <C-w>j <C-w>j
nnoremap <C-w>k <C-w>k
nnoremap <C-w>l <C-w>l

" Split to specified direction 
nnoremap <C-h><C-h> :vertical topleft split<CR>
nnoremap <C-l><C-l> :vertical belowright split<CR>
nnoremap <C-j><C-j> :belowright split<CR>
nnoremap <C-k><C-k> :topleft split<CR>

nnoremap <C-w>hh :vertical topleft split<CR>
nnoremap <C-w>jj :vertical belowright split<CR>
nnoremap <C-w>kk :belowright split<CR>
nnoremap <C-w>ll :topleft split<CR>

nnoremap <Leader>wh :vertical topleft split<CR>
nnoremap <Leader>wj :vertical belowright split<CR>
nnoremap <Leader>wk :belowright split<CR>
nnoremap <Leader>wl :topleft split<CR>

" Close the last window
nnoremap <Leader>wc :close<CR>

" Keep only the active window open
nnoremap <Leader>wo :only<CR>

" Close preview window (eg after Hover)
nnoremap <Leader>lcp :pclose<CR>

noremap <C-w><C-w> <C-w><C-w>


" #### SECTION: Buffer Selection
" There are three main buffer pickers in this config
" 1. This set of keymaps with :ls extended for selection (<Leader>b)
" 2. This function (<Leader>bb - typed fast)
" 3. fzf/fzf.vim has a builtin buffer selector (<Leader><Space>) - see non-lsp fzf config

" 1. Use this <Leader>b only if the fzf version is not avail
nnoremap <Leader>b :ls<CR>:b<Space>
nnoremap <Leader>bn :bn<CR>
nnoremap <Leader>bp :bp<CR>
nnoremap <Leader>bf :bf<CR>
nnoremap <Leader>bl :bl<CR>

" 2. A new command :B
command! -nargs=0 B call ListBuffers()
nnoremap <Leader>bb :B<CR>
vnoremap <Leader>bb :B<CR>
function! ListBuffers()
    let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    let i = 1
    let buffer_list = []
    for buffer in buffers
        let buffer_list += [printf("%d: %s", i, bufname(buffer))]
        let i += 1
    endfor
    let choice = inputlist(['Select a buffer:'] + buffer_list)
    if choice > 0 && choice <= len(buffers)
        execute 'buffer' buffers[choice - 1]
    endif
endfunction


" #### SECTION: GENERAL KEY MAPPING

" Make vim compatable with tmux (eg Shift-arrows/Ctrl-arrows)
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" Beginning and end of line

function! ToggleZero()
   " Get the current cursor position
   let current_col = col('.')
   " Search for the first/last non-whitespace character on the current line
   let first_non_ws_col = match(getline('.'), '\S') + 1
   let last_non_ws_col = match(getline('.'), '\S\zs\s*$')
   " Get last col position on the current line
   let last_col_pos = col('$') -1
   " Move based on cursor location
   echo "current col: " . current_col . " last pos: " . last_col_pos
   if current_col == last_col_pos
      normal! 0
   elseif current_col == 1 && current_col != first_non_ws_col
      normal! ^
   elseif current_col == first_non_ws_col
      normal! g_
   elseif current_col == last_non_ws_col
      normal! $
   else
      normal! 0
   endif
endfunction
nnoremap <silent> 0 :call ToggleZero()<CR>
inoremap <silent> ;; <C-O>:call ToggleZero()<CR> 

" To replace the lost defeault <C-L> mapping
nnoremap <Leader>wr :redraw!<CR>

" Open things
" Open a file (finish in command line). Maybe can use $(fzf)?
nnoremap <Leader>of :open .<CR>
nnoremap <Leader>oe :Explore<CR>    " Open file explorer

" Save <Leader>f... for find things?

" <ESC> from INSERT mode (use jj and/or jk)
" jj is more natural, but jk may be immediate
" jk is removed here because I like to jiggle the cursor to close the autocomplete dropdown
inoremap jj <ESC>
" inoremap jk <ESC>

" Jump past closing bracket or quote in NORMAL or INSERT mode (stay in same mode)
inoremap jl <ESC>%%a
nnoremap jl %%l

" Toggle search highlighting (use :noh for current search only)
let g:highlighting = 1
function! ToggleHighlighting()
   if g:highlighting
      set nohlsearch
      let g:highlighting = 0
   else
      set hlsearch
      let g:highlighting = 1
   endif
endfunction
nnoremap <Leader>h :call ToggleHighlighting()<CR>

" Use Esc to exit netrw
" autocmd FileType netrw nmap <silent> <buffer> <Esc> :bd<cr>

" #### SECTION: Inert Keymaps just to document
if g:install_plug_coc == 1
   " #### SECTION: COC BOILER SETUP (neoclide/coc.nvim)

   " Use tab for trigger completion
   inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
   inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

   " CR to accept selected completion (but <C-g>u breaks current undo)
   inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

   " Suggested by coc.nvim
   function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
   endfunction

   " Use <c-space> to trigger completion
   if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
   else
      inoremap <silent><expr> <c-@> coc#refresh()
   endif

   " Use `[g` and `]g` to navigate diagnostics
   " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
   nmap <silent> [g <Plug>(coc-diagnostic-prev)
   nmap <silent> ]g <Plug>(coc-diagnostic-next)

   " GoTo code navigation
   nmap <silent> gd <Plug>(coc-definition)
   nmap <silent> gy <Plug>(coc-type-definition)
   " Deactivate coc-implementation (Not available for jedi, and conflicts with goto last insert pos)
   "nmap <silent> gi <Plug>(coc-implementation)
   nmap <silent> gr <Plug>(coc-references)

   " Use K to show documentation in preview window
   nnoremap <silent> K :call ShowDocumentation()<CR>

   function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
         call CocActionAsync('doHover')
      else
         call feedkeys('K', 'in')
      endif
   endfunction

   " Highlight the symbol and its references when holding the cursor (eg user not typing)
   autocmd CursorHold * silent! call CocActionAsync('highlight')

   " Symbol renaming
   nmap <leader>rn <Plug>(coc-rename)

   augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s)
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
   augroup end

   " Applying code actions to the selected code block
   " Example: `<leader>aap` for current paragraph
   xmap <leader>la  <Plug>(coc-codeaction-selected)
   nmap <leader>la  <Plug>(coc-codeaction-selected)

   " Remap keys for applying code actions at the cursor position
   nmap <leader>lac  <Plug>(coc-codeaction-cursor)
   " Remap keys for apply code actions affect whole buffer
   nmap <leader>las  <Plug>(coc-codeaction-source)
   " Apply the most preferred quickfix action to fix diagnostic on the current line
   nmap <leader>lqf  <Plug>(coc-fix-current)

   " Remap keys for applying refactor code actions
   nmap <silent> <leader>lre <Plug>(coc-codeaction-refactor)
   xmap <silent> <leader>lr  <Plug>(coc-codeaction-refactor-selected)
   nmap <silent> <leader>lr  <Plug>(coc-codeaction-refactor-selected)

   " Run the Code Lens action on the current line
   nmap <leader>lcl  <Plug>(coc-codelens-action)

   " Map function and class text objects
   " NOTE: Requires 'textDocument.documentSymbol' support from the language server
   xmap if <Plug>(coc-funcobj-i)
   omap if <Plug>(coc-funcobj-i)
   xmap af <Plug>(coc-funcobj-a)
   omap af <Plug>(coc-funcobj-a)
   xmap ic <Plug>(coc-classobj-i)
   omap ic <Plug>(coc-classobj-i)
   xmap ac <Plug>(coc-classobj-a)
   omap ac <Plug>(coc-classobj-a)

   " Remap <C-f> and <C-b> to scroll float windows/popups
   if has('nvim-0.4.0') || has('patch-8.2.0750')
      nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<RIGHT>"
      inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<LEFT>"
      vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
   endif

   " Use CTRL-lrs for selections ranges
   " Requires 'textDocument/selectionRange' support of language server
   nmap <silent> <C-lrs> <Plug>(coc-range-select)
   xmap <silent> <C-lrs> <Plug>(coc-range-select)

   " Add `:OR` command for organize imports of the current buffer
   command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

   " Mappings for CoCList
   " Show all diagnostics
   nnoremap <silent><nowait> <space>la  :<C-u>CocList diagnostics<cr>
   " Manage extensions
   nnoremap <silent><nowait> <space>le  :<C-u>CocList extensions<cr>
   " Show commands
   nnoremap <silent><nowait> <space>lc  :<C-u>CocList commands<cr>
   " Find symbol of current document
   nnoremap <silent><nowait> <space>lo  :<C-u>CocList outline<cr>
   " Search workspace symbols
   nnoremap <silent><nowait> <space>ls  :<C-u>CocList -I symbols<cr>
   " Do default action for next item
   nnoremap <silent><nowait> <space>lj  :<C-u>CocNext<CR>
   " Do default action for previous item
   nnoremap <silent><nowait> <space>lk  :<C-u>CocPrev<CR>
   " Resume latest coc list
   nnoremap <silent><nowait> <space>lp  :<C-u>CocListResume<CR>

   " END CONFIG FROM neoclide/coc.nvim
endif


" #### SECTION: Save and restore sessions

" Create the sessions directory if it doesn't exist
if !isdirectory(expand("~/.vim/sessions"))
   call mkdir(expand("~/.vim/sessions"), "p")
endif

" Function to save the current session
function! SessionSave()
   " Ask the user for a session name
   let l:session_name = input("Enter session name: ")
   " Check if the session file already exists
   if filereadable(expand("~/.vim/sessions/" . l:session_name . ".save"))
      " Ask the user for confirmation before overwriting the file
      echo "Session file already exists. Overwrite? (Y/N)"
      let l:choice = nr2char(getchar())
      while index(['Y', 'N'], l:choice) == -1
         echo "Please enter Y or N"
         let l:choice = nr2char(getchar())
      endwhile
      if l:choice == 'N'
         " User chose not to overwrite the file, so return without saving
         return
      endif
   endif
   " Save the session to a file
   execute "mksession! ~/.vim/sessions/" . l:session_name . ".save"
endfunction

" Function to restore a saved session
function! SessionRestore()
   " Get a list of session files
   let l:session_files = glob("~/.vim/sessions/*.save", 0, 1)
   " Extract the session names from the session files
   let l:session_names = map(l:session_files, 'fnamemodify(v:val, ":t:r")')
   " Create a numbered list of session names
   let l:session_list = map(copy(l:session_names), '(v:key + 1) . ". " . v:val')
   " Ask the user to select a session name
   let l:index = inputlist(["Select a session:"] + l:session_list)
   " Check if a valid session name was selected
   if l:index > 0 && l:index <= len(l:session_names)
      " Load the selected session file
      execute "source ~/.vim/sessions/" . l:session_files[l:index - 1] . '.save'
   endif
endfunction

" Fix <C-r> mapping (Coc overwrites this, maybe because one config setting can lose redo chain?)
nnoremap <C-r> :redo<CR>

" Map keys to save and restore sessions
nnoremap <leader>ss :call SessionSave()<CR>
nnoremap <leader>sr :call SessionRestore()<CR>

" Command to enter visual block mode
" To type text in front of all lines in the block,
" Enter visual block mode with :Vb
" Use arrows to highlight the lines to act on
" Shift-i to type the text to insert
" <ESC> to act on all the lines
command! Vb normal! <C-V>


" #### SECTION: Open new buffer with a keymap cheat sheet
function! InsertText(text_string)
   " Split the string by lines into a list
   let l:string_list = split(a:text_string, '\n')
   " Create a new buffer
   vnew
   setlocal buftype=nofile
   " Insert the text
   call append(0, l:string_list)
   " execute 'write! ~/.vim/keymap_cheat.txt' " Optionally save the cheat sheet as well.
endfunction
let text_string = " File Operations:\n
         \ autocmd FileType netrw nmap <silent> <buffer> <Esc> :bd<cr>: Close file explorer with Esc\n
         \ <Leader>of: Open current directory\n
         \ <Leader>oe: Open file explorer\n
         \ <Leader>dg: Diff with git\n
         \ <Leader>ds: Diff with saved file\n
         \ \n 
         \ BUFFERS:\n
         \ nnoremap <Leader><space> :Buffer<CR>: Buffer operations\n
         \ nnoremap <Leader>b :Buffer<CR>: Buffer operations\n
         \ <Leader>b: List buffers and prompt for buffer number\n
         \ <Leader>bb: List buffers and prompt (type quickly)\n
         \ <Leader>bn: Go to the next buffer\n
         \ <Leader>bp: Go to the previous buffer\n
         \ <Leader>bf: Go to the first buffer\n
         \ <Leader>bl: Go to the last buffer\n
         \ <Leader>wc: Close the current buffer\n
         \ <Leader>wo: Close all other buffers\n
         \ \n 
         \ WINDOWS\n
         \ Resizing Windows\n
         \ <M-LEFT>:  Decrease vertical size by 10 units.\n
         \ <M-RIGHT>: Increase vertical size by 10 units.\n
         \ <M-UP>:    Increase horizontal size by 5 units.\n
         \ <M-DOWN>:  Decrease horizontal size by 5 units.\n
         \ Moving Between Windows\n
         \ <C-w><LEFT>:  Move to the window on the left.\n
         \ <C-w><DOWN>:  Move to the window below.\n
         \ <C-w><UP>:    Move to the window above.\n
         \ <C-w><RIGHT>: Move to the window on the right.\n
         \ <C-w>h: Move to the window on the left (alternative).\n
         \ <C-w>j: Move to the window below (alternative).\n
         \ <C-w>k: Move to the window above (alternative).\n
         \ <C-w>l: Move to the window on the right (alternative).\n
         \ <C-w><C-w>: Move to the next window.\n
         \ Splitting Windows\n
         \ <C-h><C-h>: Vertical split at top left.\n
         \ <C-l><C-l>: Vertical split below right.\n
         \ <C-j><C-j>: Horizontal split below right.\n
         \ <C-k><C-k>: Horizontal split at top left.\n
         \ <C-w>hh: Vertical split at top left (alternative).\n
         \ <C-w>jj:  Vertical split below right (alternative).\n
         \ <C-w>kk: Horizontal split below right (alternative).\n
         \ <C-w>ll: Horizontal split at top left (alternative).\n
         \ <Leader>wh: Vertical split at top left (alternative with leader).\n
         \ <Leader>wj: Vertical split below right (alternative with leader).\n
         \ <Leader>wk: Horizontal split below right (alternative with leader).\n
         \ <Leader>wl: Horizontal split at top left (alternative with leader).\n
         \ Window Management\n
         \ <Leader>wc: Close the current window.\n
         \ <Leader>wo: Keep only the active window open.\n
         \ <Leader>lcp: Close the preview window (e.g., after hover).-l><C-l>: Vertical split below right.\n
         \ \n 
         \ TERMINAL WINDOWS\n
         \ Open Terminal to right: :vert term\n
         \ Open Terminal above:    :term\n
         \ \n 
         \ EDITING:\n
         \ jj: Escape insert mode\n
         \ jl: Escape insert mode and append after end of line\n
         \ <C-O> will escape to normal mode only for ONE command\n
         \ <Leader>h: Toggle highlighting\n
         \ inoremap jl <ESC>%%a: Escape insert mode and append after current line\n
         \ <Leader>m: Toggle Maximizer\n
         \ <Leader>lcp: Close preview window after Hover\n
         \ \n 
         \ FOLDS:\n
         \ <Leader>z: Toggle all folds\n
         \ zM close all folds, zm fold more (decrease fold level)
         \ zc/zC close curr fold(/recursively)\n
         \ zo/zO open curr fold(/recursively)\n
         \ za/zA toggle curr fold(/recursively)\n
         \ zf/zF create manual fold(/recursively)\n
         \ 
         \ \n 
         \ COMMENTING:\n
         \ <Leader>/: Comment or uncomment line/selection\n
         \ <Leader>//: Comment line/selection\n
         \ \n 
         \ NAVIGATION:\n
         \ <C-h>: Move to the previous word (akin to pressing 'B').\n
         \ <C-j>: Scroll forward one full screen (akin to pressing <C-f>).\n
         \ <C-k>: Scroll backward one full screen (akin to pressing <C-b>).\n
         \ <C-l>: Move to the next WORD (akin to pressing 'W').\n
         \ <C-LEFT>: Move to the previous word (akin to pressing 'B').\n
         \ <C-DOWN>: Scroll forward one full screen (akin to pressing <C-f>).\n
         \ <C-UP>: Scroll backward one full screen (akin to pressing <C-b>).\n
         \ <C-RIGHT>: Move to the next WORD (akin to pressing 'W').\n
         \ <silent>0: Cycle position in line\n
         \ <Leader>ge: Go to a specific position\n
         \ <S-UP>: Scroll up a full screen\n
         \ <S-DOWN>: Scroll down a full screen\n
         \ zt, zz, zb move screen so current line is at the top, middle, bottom of the screen
         \ zh, zl scroll screen to the right, to the left\n 
         \ <Leader>n, <F8>: Call CycleLineNumbers\n
         \ \n 
         \ COC ACTIONS:\n
         \ <F4>: CocPrev\n
         \ <F5>: CocNext\n
         \ <F6>: CocFirst\n
         \ <F7>: CocLast\n
         \ <leader>ld: Jump to definition\n
         \ <leader>lr: References\n
         \ <leader>ln: Rename\n
         \ <leader>la: Code Action\n
         \ <leader>lk: Hover information\n
         \ \n 
         \ FUZZY SEARCH:\n
         \ <C-p>: Files\n
         \ <C-s>: Buffer Lines\n
         \ \n 
         \ KEY BINDINGS:\n
         \ <Leader>fm: Call LiteralFindKeyMappings\n
         \ let g:mapleader = ' ': Set the leader key to space\n
         \ let g:maplocalleader = ' ': Set the local leader key (for vim-which-key)\n
         \ \n 
         \ AUTOCOMPLETE AND BRACKETS HANDLING:\n
         \ Various inoremap mappings to handle bracket pairs and quoting\n
         \ \n 
         \ MISCELLANEOUS:\n
         \ <Leader>wr: Redraw screen\n
         \ autocmd BufEnter * silent! vnoremap <silent> <C-_> :<C-u>call VisualCommentUncomment()<CR>: Visual comment/uncomment\n
         \ nnoremap <S-UP> <C-b><C-u>:normal! zz<CR>: Scroll up\n
         \ nnoremap <S-DOWN> <C-f><C-d>:normal! zz<CR>: Scroll down\n
         \ inoremap <S-UP> <C-o><C-b><C-o><C-u><C-o>:normal! zz<CR>: Scroll up in insert mode\n
         \ inoremap <S-DOWN> <C-o><C-f><C-o><C-d><C-o>:normal! zz<CR>: Scroll down in insert mode\n
         \ \n 
         \ VIM-PLUG SETTINGS:\n
         \ PlugInstall: Install all plugins\n
         \ PlugUpdate: Update all plugins\n
         \ PlugClean: Remove unused plugins\n
         \ PlugDiff: Show plugin differences\n
         \ PlugSnapshot: Snapshot the current state of plugins\n
         \ \n 
         \ COMMANDS DEFINED IN .VIMRC FILE\n
         \ WhichKey: Show key bindings.\n
         \ CocAction: Perform COC actions.\n
         \ LiteralFindKeyMappings: Find key mappings literally.\n
         \ CycleLineNumbers: Cycle line numbers.\n
         \ MaximizerToggle: Toggle window maximizing.\n
         \ GoToPosition: Go to a specific position.\n
         \ ToggleAllFolds: Toggle all code folds.\n
         \ VisualCommentUncomment: Comment/uncomment visually selected text.\n
         \ ConditionalCommentUncomment: Comment/uncomment conditionally.\n
         \ ToggleZero: Toggle zero.\n
         \ ToggleHighlighting: Toggle highlighting.\n
         \ DiffGIT: Diff current buffer vs git file\n
         \ DiffSaved: Diff unchanged changers in current buffer with last saved file\n
         \ Vb: Visual Block mode (Select then Shift-i to add text to all rows)\n
         \ \n 
         \ ADDITIONAL NOTES:\n
         \ Run :help <command> or :h <command> to get more details on a specific Vim command\n
         \ Search .vimrc for command! to see all vimrc defined commands\n
         \ Search .vimrc for plugin to see plugins\n
         \ Search .vimrc for map to see all the key bindings (or use <Leader>fm)\n
         \ All keymaps are in :map :nmap :imap :vmap (use -u NONE for default VIM bindings only)\n
         \ Plugins will also create additional commands and key bindings\n
         \ Check an actual key value from insert mode with <C-v><C-/>.\n
         \ Note that <C-/> must be mapped as <C-_> due to a common terminal emulator oddity.\n
         \ For mac, try iiterm2 -> Prefs -> Keys + -> Send Text with 'vim' special chars. Enter ,cc\n
         \ DO NOT map <C-W>, it is often mapped to close current OS window by the OS\n
         \ \n
         \ VIM USAGE\n
         \ Search /\n
         \ SearchReplace :%s/oldtext/newtext/cgi where %,c,g,i for whole file, confirm, global, insensitive case\n
         \ \n 
         \ \n 
         \ \n 
         \ "

nnoremap <F2> :call InsertText(text_string)<CR>gg

" SECTION: Mapping limitations
" ctrl/alt/shift-key ;+-,.' cannot be mapped and ctrl upper/lower cant be distinguished
" Do not map on top of important mappings. Also preserve combos needed for tmux
" See :map for all vim key mappings (to see defaults, launch with -u NONE)
"     :nmap :vmap :imap for mode specific mappings

" ----------------------------------------------------------------------------
" VIM CONFIGURATION USAGE INFORMATION (Including basic vim usage info)
" ----------------------------------------------------------------------------

" #### MISC BASICS
" WhichKey:
"
" UndoRedo:
"    u and Ctrl-r (for branches, see vimhelp.org/usr_32.txt.html#32.3)
" Cut/Yank/Paste:
"    visual select then d / y / p (or just dd or yy to select full line, P for Paste before)
"    Y or yy will select to end of line
" Copy/PasteFromSystemClipboard: Seems to vary by platfor. Try...
"    select: visual mode or select with mouse
"    copy:   Ctrl-c | Ctrl+Insert | Shift+Insert
"    cut: Shift+Del
"    paste:  Ctrl-v | Shift RightClick | middle mouse button
"    replace: copy and then visual select the destination text to replace, then p
"    Tip: If you paste from system clipboard into vim and get ^M at end of line,
"         try instead to enter INSERT mode first, and use Ctrl-v to paste. (Probably a Windows->Linux thing.)
" Registers: For CopyPaste and storing macros
"    TODO:
" FileExplorer:
"    :Explore or vim . for built in netrw
"    :help netrw-quickmap (also see gist.github.com/t-mart/610795fcf7998559ea80)
"    vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/
" LineNumbers:
"    Toggle with...  set number! set relativenumber! (set nu! and set nu and set nonumber and set norelativenumber)
" RedrawScreen:
"    Ctrl-L (or :redraw)
" RefreshBufferFromFile:
"    :e (or :edit or :edit!)

" #### FIND / REPLACE
" FindInLine: f  For example use ft to find the next 't' on the line. Also works for brackets.
" Find: To override the default case sensitivity, use /findThis\c for case INsensitive or /findThis\C case sensitive
" FindReplace: Search with /mysearchterm<CR> then cgn and type myreplaceterm<ESC> then n/N find agn and . to repeat.
" SubstututeInCurrLine: :s/old/new/g (Curr line is the default range, g means replace all in the range instead of once)
" SubstututeInDocument:
"       :%s/old/new will search and replace ONE occurrence of old by new in the document.
"       :%s/old/new/g (iasdfasdfasdfasdffs) will search and replace all occurrences of old by new in the document.
"       :%s/old/new/gc appended with a "c" requires each change to be confirmed
"       Use :%s|old|new (or any other char) if / is in the search pattern
"       For case sensistivity pppend i(no) or I(yes)

" #### BUFFERS
" Buffers:
"     :Buffers to fuzzy find a buffer name (use up down arrows to choose a different buffer)
"     :new for new buffer in a split window (set splitbelow or set splitright)
"     :enew to edit a new unamed buffer (will fail if changes were made to existing buffer)
"     :open myfilename to open a new buffer with a file (will fail if chgs made to existing buffer)
"     Cycle with :bnext (:bn) and :bprev (:bp)
"     Pick buffer with :b or :b nbr|substr (use tab if more than one filename substring match), :ls to list buffers

" #### FOLDS
" :Zn to set folds to level n
" <Leader>z to toggle folds (Open all, close all)

" #### FILES
" FileFzf: Use :Files
" RipgrepFzf: :Rg [PATTERN] or :RG [PATTERN] (:RG will relaunch as you type)
" GitFileFzf: Use :GFiles   (  See Git status with :GFiles?  )
" MoreFzf: See github.com/junegunn/fzf.vim

" #### MOTION
" GotoLine: Move to line 123 with :123 or use :20+10 to move to line 30 (line 20+10)
" Jumps: :jumps for a list, Ctrl-o / Ctrl-i back and fwd jump, `` or '' bkwd/fwd
" MoveCursor: Shift-Up/DownArrow should page up/down. cf C-D, C-U, C-B, C-F
" ScollButKeepPosition: <C-alt-u> and <C-alt-d>
" MoveLine: :m+1 or :m-2 to move selected lines down or up one (:m+2 for two down, :m-3 for two up) or :m {linenbr}
" MoveLinesUpDown: See config above and vim.fandom.com/wiki/Moving_lines_up_or_down
" PageMotion: Ctrl-b/f to move back/fwd a page, Ctrl-u/d to move half screen up/down
" ScrollButLockCursor: To scroll up/down and keep cursor on same text, use <C-e> or <C-y>
" MoveInScreen: H M L to move cursor to top middle bottom of screen
" CenterInScreen: zt, zz, zb moves current line to top, middle, bottom of screen
" NavigatePreviousLocations: List with :jumps or cap :Jumps for fzf
"    `` or Ctrl+o navigate to the previous location in the jump list (think o as old)
"    '' or Ctrl+i navigate to the next location in the jump list (i and o are usually next to each other)
"    g; go to the previous change location
"    g, go to the newer change location
"    gi place the cursor at the same position where it was left last time in the Insert mode
"    Use :jumps to view the jump list. See :h jump-motions for more details.

" #### WINDOWS
" JumpWindow: Ctrl-w and up/down/right/left or <C-w><C-w> to cycle. WARN: OS may use <C-W> as close window
" ResizeSplit: Ctrl-w +/-/>/<
" SplitWindow: Ctrl-w v (vertical split) or Ctrl-w s (horizontal split)
" CloseWindow: Use :close
" OpenTerminal: Use :term then move it: <C-H/J/K/L>

" #### MANIPULATING TEXT
" Indent: >> or << (normal) and < or > or 2> or 2< (visual mode) - based on shiftwidth
" Increment: Ctrl-a or Ctrl-x to increment or decrement first nbr under cursor or to the right
" Autoindent: =<space> or =<arrow> to autoindent (normal or visual)
" Changes: gi - last cursor pos in insert mode, g; g, for previous or newer chg loc
" WholeWordSearch: * or Shift Click is fwd from cursor position, # is bkwd
" PartialWordSearch: g*, g# fwd and backward from cursor positiona
" UpperOrLowerCase: gU or gu (eg gue, gu$, guiw)
" DeleteAnd: s/S del char/line and insert, C del to eol and insert, R for replace mode

" #### VIM MODES
" Replace Mode: Use R to type over characters. <ESC> to exit replace mode
" Binary mode: Open a file in binary mode with -b option flag
"                 which sets textwidth and wrapmargin to 0 and turns off modeline and expantab.
"              Use :%!xxd command for editable hex dump (offset, hex bytes, ascii)
"              Then :%!xxd-r to reverse it. (Don't forget to :')
"              Note that offset is for first byte of each line. Modifications on Ascii will be IGNORED!!!!!
"

" #### LSP - COC
" <Leader>o Outline with fuzzy find

" #### BRACKETS
" FindBracketsInLine: f  For example use f( to find the next ( on the line. Not just for brackets.
"                     F  Same, but find previous bracket.
"                     % will select the matching bracket (or opening bracket if cursor is inside)
" SelectInside: vi( or vi[ or vi" etc for selecting the content inside the brackets
" ChangeInside: ci( to delete inside brackets and insert mode
" ClearHighlighting:   Use :noh
" Good Linux Terminal Utils: lazygit and github.com/ibraheemdev/modern-unix)
" FromInsideParens:
"
"


" #### KEY BINDING INFORMATION
" VIM Default Key Bindings
" :help normal-index in Vim (or insert-index, visual-index, ex-edit-index)
" for a comprehensive list of default key bindings before plugins or .vimrc files.
"
" Additional key bindings from plugins or configuration
" :map   has all, :nmap :vmap :imap for normal, visual, insert mode mappings only
"
" <Leader>fm  for fuzzy search for key bindings (can set in .vimrc to use fuzzy or literal search patterns)
"
" <Leader>    for <leader> bindings only (vim-which-key)
"
" :verbose map <Leader>;   will show all leader mappings

" #### VIM DEBUGGING
" :messages to see all error messages
" TBD

" For which key to map in vim, see vimdoc.sourceforge.net/htmldoc/map.html#map-which-keys
" Detailed how to map keys in vim, see vim.fandom.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_1)
"

" #### SECTION: All the stuff that doesn't work unlesss it's at the end
set shortmess-=S               " show the current match position (Wont work at top of file)

set colorcolumn=+1             " Automatic highlighting char in col 81
highlight ColorColumn ctermbg=darkgrey guibg=lightgrey
" TODO: Add toggle for color column

" Reset the <C-hjkl|arrow> mappings as safety measure
nnoremap <C-h> B 
nnoremap <C-l> W
nnoremap <C-j> <C-f> 
nnoremap <C-k> <C-b> 
nnoremap <C-LEFT> B
nnoremap <C-RIGHT> W
nnoremap <C-DOWN> <C-f>
nnoremap <C-UP> <C-b>

nnoremap <S-LEFT> B
nnoremap <S-RIGHT> W
nnoremap <S-DOWN> <C-f>
nnoremap <S-UP> <C-b>


