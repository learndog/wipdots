" #### SECTION: BASIC SETTINGS

" auto-reload vimrc
autocmd! bufwritepost vimrc source ~/.vim/vimrc

set noerrorbells               " Alarm style needs to be set/disabled in term emulator
set novisualbell               " For MS Term with WSL change in settings per target OS
set timeoutlen=300             " So it doesn't wait too long for a keymap sequence
set ttimeoutlen=50             " Time after an ESC waiting for key sequence. Short is good to exit INSERT mode.
" Too small could cause emulator or remote connection problems
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
"set clipboard=unnamedplus      " Enable clipboard support (req vim compiled +clipboard)
set clipboard+=unnamedplus     " Always use clipboard for All operations (not + and/or * explicitly)
set mouse=v                    " Enable mouse support (a chgs on click to visual in vim, try v in nvim)
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
set noshowmode                " Don't show the mode word. (Not needed if status line shows it)
set signcolumn=yes

