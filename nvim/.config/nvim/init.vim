" .vimrc
"          learndog/dotfiles/vim/.vimrc
"          Usually stowed to... 
"              .vimrc -> dotfiles/vim/.vimrc
"              .vimrc_helpers -> dotfiles/vimrc_helpers/.vimrc_helpers
"
" Description:    
" * Python coc-pyright mini-IDE on Debian 11+ or Ubuntu 22+ (others may also work)
" * Single file configuration plus helper files
" * Few dependencies
" * Configurable plugin selection
" * Non-plugin alternative configurations are available for most core functionality!

" Requirements:
" 
" GENERAL
" 
" * Vim 8.2.3555+ with +python3 (see www.reddit.com/r/vim/comments/qub6j9/comment/hsi5rgq/)
" 
"     Check python3 support with vim --version or :echo has('python3')
"       It should also work on Vim 7, but will not modify the default status line
"       coc.nvim requires at least Vim 8.1.1719 or Neovim 0.4.0

"     Debian 11 package manager has Vim 9.0.1378-2 (sudo apt install vim) 
"       Supports +python3 and +lua. 
"       Enable the +python3 feature in Vim by installing the vim-gtk package.

"     Update the plugins on first run of the config
"          :PlugUpdate to update all plugins
"          :PlugUpdate <my-plugin> to update one plugin
"          :PlugUpdate | PlugUpgrade to update all plugins and to upgrade vim-plug (but don't run 2nd without 1st)

"     Optionally install current VIM from source
"        # May not work on gcp vertex AI vm. Try https://richrose.dev/posts/linux/vim/vim-compile/
"        sudo apt remove vim vim-tiny vim-common vim-gui-common vim-nox  vim-runtime gvim
"        cd && git clone https://github.com/vim/vim.git   # Current vim 9 seems to work!
"        cd vim && git pull
"        cd src && make distclean                      # Clean config files and all generated files
"        sudo apt install libncurses-dev python3-dev
"        # configure statement assumes python 3.7 with python3 cmd to run python
"        # You may need to modify the config stmt with-python-config-dir=my-python-header-files-dir
"        #     where the dir can be found with find /usr -name Python.h
"        #     For vertexai gcp, try 
"        #       make distclean                        # make clean would only remove intermed files and libs
"        #       --with-python-config-dir=/usr/include/python3.7m
"        ./configure --with-features=huge --enable-rubyinterp --enable-python3interp --with-python-config-dir=$(python3-config --configdir) --with-python3-command=python3 --enable-perlinterp --enable-gui=gtk2 --enable-cscope --enable-luainterp --enable-multibyte
"        make
"        sudo make install
"        make distclean              # Clean up uneeded configure files and make files after install

"     Optionally install VIM or NVIM with snap

"     Optionally install NEOVIM instead..."
"         Install nvim on Debian 10 (Buster)
"         Following https://github.com/neovim/neovim/wiki/Installing-Neovim
"         # NOTE: Don't install FUSE because requires a privileged container
"
"         Install neovim
"           cd && mkdir usr && cd usr
"           curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
"           chmod 755 nvim.appimage
"           # Because older version of Ubuntu
"           ./nvim.appimage --appimage-extract
"           ./squashfs-root/AppRun --version
"           # Make it available globally
"           sudo mv squashfs-root /squashfs-root
"           sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
"           cd && nvim -v
"           rm nvim.appimage && nvim -v
"     
"     if using nvim, change the stow for .config/nvim/config/nvim/init.vim and also stow .vimrc_helpers
"
"     And with nvim, might be better to move from coc with the node requirement to a native solution in nvim
"        * See https://www.reddit.com/r/neovim/comments/14pvyo4/why_is_nobody_using_coc_anymore/
"        * Try none-ls.nvim, mason.nvim, nvim-cmp and something like LuaSnip. May need nvim-lspconfig.

" * Install the vim config
"     
"     Save this file as ~/.vimrc
"     Edit it if you like... eg choose to disable (and not install) some plugins
"     Restart vim
"         
"     The first time you run vim, do :PlugInstall and :CocInstall coc-pyright coc-jedi
"     There may be some differences running inside tmux, so you may have to adjust your tmux config and/or .vimrc
"     Check if tmux is active from vimscript... exists('$TMUX')
"     In windows you may not be able to find key control codes for your terminal with Ctrl-v. Try ctrl-q instead.

"     If you get a coc error about a yarn install, then
"       :call coc#util#install()      from vim command line
"       OR in terminal
"       cd ~/.local/share/nvim/plugged/coc.nvim (or equivalent where coc is installed)
"       OR in vim
"       cd ~/.vim/plugged/coc.nvim && npm install
"       Install dependencies with $ yarn install or $ npm install
"       Restart nvim

"     Restore vim to pristine just-installed condition
"       1. Delete the entire ~/.vim directory
"       2. Remove this .vimrc file and .vimrc_helpers (unstow them)

" * python3 -> sudo apt install python3 python3-pip
"       Try pyenv for a robust Python setup
       
" * black -> pip install black

" * fzf -> sudo apt install fzf (eg to switch buffers, open files)
"       [opt] bat (batcat) for fzf syntax highlights -> sudo apt install bat
"       [opt] ripgrep (rg) for fzf Rg command -> sudo apt-get install ripgrep
"       [opt] delta for git diff formatting (see github.com/dandavison/delta)

" * node, npm -> sudo apt install nodejs npm (or install with NVM)

" * pyright -> pip install pyright (for coc python linting)
"       Note: pip install will automatically install node (microsoft.github.io/pyright/#/installation)
"       Note: Config for coc-pyright can be found at https://github.com/fannheyward/coc-pyright
"       See capabilities at https://github.com/microsoft/pyright/blob/main/docs/features.md

" BY CAPABILITY
 
"   vim-plug
"     https://github.com/junegunn/vim-plug/wiki/requirements
"     master branch
"     neovim or vim 0.8+ (or vim 0.7+ plus python or ruby)
"     git 1.7+ (1.7.10+ for plugins with tags)
"     curl

"   coc
"     https://github.com/neoclide/coc.nvim
"     release branch
"     Vim 8.1.1719+ or Neovim 0.4.0+
"     nodejs 14.14+

"     If you get this coc error
"        Error: javascript bundle not found, please compile code of coc.nvim by esbuild.
"        then run... node esbuild.js in the coc.nvim directory
"        Note: npm install should take care of this also 

"   ale
"     https://github.com/dense-analysis/ale
"     NeoVim 0.2.0+ or Vim 8.0+

"   folke which-key
"     main branch
"     https://github.com/folke/which-key.nvim
"     Note: Also includes functionality for marks, registers, spelling, etc

" CopyPasteFromSystemClipboard: Seems to vary by platform. Try...
"    select: visual mode or select with mouse
"    copy:   Ctrl-c | Ctrl+Insert | Shift+Insert
"    copy:   SHIFT select your text, then copy with CTRL+SHIFT+C (from WSL/CA to Windows)
"    cut: Shift+Del
"    paste:  Ctrl-v | Shift RightClick | middle mouse button
"    replace: copy and then visual select the destination text to replace, then p
"    Tip: If you paste from system clipboard into vim and get ^M at end of line,
"         try instead to enter INSERT mode first, and use Ctrl-v to paste. (Probably a Windows->Linux thing.)
"
" Bonus:
 
" SSH Key Pair Setup
"   # For remote git repositories and/or ssh from terminal emulator to a server
"   ssh-keygen -t ed25519 -C "your_email@example.com"      # https://github.com/settings/keys
"   eval "$(ssh-agent -s)"                                 # Add private key to ssh agent. May vary by OS
"   ssh-add ~/.ssh/id_ed25519
"   # For linux server, also add public key to ~/.ssh/authorized_keys
"   # For github.com, go to settings to add public key

" Stow instructions
"     # Assumes a github repository user/dotfiles with config file dotfiles/vim/.vimrc
"     sudo apt-get install stow
"     cd ~ && git clone git@github.com/github_user/github_repository
"     cd ~/dotfiles
"     stow -t ~ vim               # Create symlink(s) in ~/ pointing to each file INSIDE dotfiles/vim/

" TMUX
"     # See https://github.com/gpakosz/.tmux for oh my tmux (requires tmux 2.4)
"     # Or a basic simple config at https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
"     # This .vimrc saves Alt-a for tmux prefix (map as <M-a>)

" Git
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

" Install Python with pyenv
"     Your .bashrc or .profile may already contain the 'echo' content
"     # Install pyenv and latest python version using github.com/pyenv/pyenv#installation
"     ! [ -d "~/temp_install/" ] && mkdir ~/temp_install && cd ~/temp_install      # Create install dir if doesn't exist
"     git clone --depth 1 https://github.com/pyenv/pyenv.git ~/.pyenv
"     #### IF NEEDED ####
"      echo $BASH_ENV                                                                  # Ensure BASH_ENV DOES NOT point to .bashrc (could create infinite loop)
"      echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
"      echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
"      echo 'eval "$(pyenv init -)"' >> ~/.bashrc
"      exec "$SHELL"                                                                   # Restart shell for PATH changes to be in effect
"     ###################
"     sudo apt install build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev # Python build dependencies
"     pyenv install 3.11.3                                                            # Install latest python. Use pyenv install -l to find latest available
"     pyenv global 3.11.3                                                             # Install python as the global version
"     pyenv versions                                                                  # Confirm it
"     python -m venv --system-site-packages ~/venvs/nvim                              # Set up nvim and myproject envs in ~/venvs/
"     python -m venv --system-site-packages ~/venvs/myproject                         # See docs.python.org/3/library/venv.html
"     cp ~/venvs/myproject/bin/activate ~/venvs/activate_myproject                    # Make the activate script easy to call
"     cp ~/venvs/nvim/bin/activate ~/venvs/activate_nvim                              # Make the activate script easy to call
"     source ~/venvs/activate_nvim                                                    # Activate nvim before the neovim install and config
"     python --version
"     which python
"     pip --version

" BUGS

" KEYMAPS
" TODO: Full set of netrw file explorer keymaps
" TODO: Add organize imports with coc with keymap for ":call CocAction('runCommand', 'editor.action.organizeImport')"
" TODO: Add a keymap for :e $VIMRC  and one to just echo $VIMRC (vim or nvim - does it work?)
" TODO: BLock alignment script and keymap - for docstrings like 'parameter:      info'
" TODO: Page up and down keeping curson in middle of page (see old configs)
" TODO: Find and remove keymaps that cause harmless muscle memory to change text
" TODO: help navigation/search
" TODO: Add :verbose map (shows where the keybinding was defined)

" GIT
" TODO: Integrate with git diff commands? What is fzf.vim :GF?
" TODO: git merge both in Vim?
" TODO: External git merge tool... lazygit? magit? github.com/mkchoi212/fac?

" FILE EXPLORER
" TODO: TUI FIle manager... https://terminaltrove.com/superfile/, ranger, mc,...  (outside of VIM can launch in vim?)
" TODO: launch external file TUI at curr dir / proj folder 
" TODO: Add nvim-tree.lua for nvim (https://github.com/nvim-tree/nvim-tree.lua) no deps but nice
" TODO: Open file in new split or tab

" FZF SEARCH
" TODO: Fuzzy find file in same dir as buffer
" TODO: Find text in files inside project folder (git proj folder or manual setting)
" TODO: :Commits and :BCommits commands as in
"         https://bluz71.github.io/2018/12/04/fuzzy-finding-in-vim-with-fzf.html
"         Try other fzf - pattern match, key maps, MRU files sorted by MRU or alpha, 
"         diagnostiics, current buffer files, file content etc
"         MRU or same dir files...  nnoremap <silent> <Space>. :Files <C-r>=expand("%:h")<CR>/<CR>
" TODO: Search help, buffer text, search by grep(?), 
" TODO: :Lines and :BLines ??
" TODO: https://jay-baker.com/posts/vim-1-which-key/  has example searches using vim-which-key
" TODO: fzf key bindings

" BUFFERS AND TABS
" TODO: Close buffer (:bd)
" TODO: Keymaps for next and previous tab... gt or gT
" TODO: Buffer and tab rename

" LANGUAGE SERVER
" TODO: Diagnostics: Show list and do Previous/Next or fzf search
" TODO: format or format on save or format from project folder
" TODO: coc working folders (and see other items in :CocList)

" FILE DIFFS
" TODO: Integrate with external diff, colordiff, nbdiff, difftastic, vimdiff, github.com/dandavison/delta 
"         Also see github.com/whiteinge/diffconflicts for vim-diffconflicts

" TERMINALS
" TODO: Keymaps for :terminal, :vertical terminal, :vertical <modifier> terminal,
"       where <modifier> is... lefta[bove], abo[veleft], bel[owright], rightb[elow]
"       See https://www.baeldung.com/linux/vim-terminal-open-position
" TODO: Keymaps for :tab terminal

" SNIPPETS
" TODO: Simple manual snippets (and keep in git - manual updates get pushed, no on-the-fly additions) 

" STATUS LINE
" TODO: Add filetype and if available, coc lsp status info like loaded lsps, linters, formatters

" OLD VIM VERSIONS
" TODO: fix sign column toggle for vim 7.4-
"       see https://stackoverflow.com/questions/18319284/vim-sign-column-toggle
" TODO: Add support for old (cavim) versions, eg https://github.com/ctrlpvim/ctrlp.vim

" NATIVE NVIM
" TODO: Nvim compatibility
" TODO: Commenting should start at first nonws char, not col pos 1 (works in vim)
" TODO: Ensure coc organize imports works - See https://github.com/neoclide/coc.nvim/issues/4372

" TMUX SUPPORT
" TODO: Fix Ctrl-arrows and status line colors for vim running in tmux

" WINDOWS
" INFO: Better splits and windows - see https://github.com/Aster89/WinZoZ/tree/main
" TODO: Add a <leader> version of <C-W> commands

" THEMES
" TODO: Toggle for light / dark color theme (or a .vimrc paramter to set color theme)
" TODO: Better coloring in vim whichkey

" TESTS
" TODO: Code and unit test - fast process

" DEBUG
" TODO: Debug python in terminal
"         See www.reddit.com/r/vim/comments/jg91dt/using_termdebug_for_pythons_pdb_examples/
" TODO: Try vimspector... https://github.com/puremourning/vimspector

" IPYTHON
" TODO: Add vim-ipython-cell (run cells inside .py files in Vim)
"       and/or jupyter console with script to start kernel and connect to it (lastest one)
"         See locally saved discussion
"         and see code.visualstudio.com/docs/python/jupyter-support-py
"         and see stackoverflow.com/questions/64730660/how-do-i-find-excute-python-interactive-mode-in-visual-studio-code
"         and https://github.com/luk400/vim-jukit
"         and https://github.com/jpalardy/vim-slime

" PLUGIN MANAGEMENT
" TODO: Use specified commit or version for plugins
" TODO: Use forked fugitive, maximizer, tmuxvimnavigator, whichkey, autoformat, ...
" INFO: To ensure that the forked versions of coc.nvim and coc-pyright are installed,
"         you can specify the URL of your forked repositories in your .vimrc file.
"         Here’s an example of how you can do this:
"           Replace 'your-username' with your GitHub username
"           Plug 'your-username/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
"           Plug 'your-username/coc-pyright', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
"           or Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile'}
"         After updating your .vimrc file, you can run :PlugInstall to install the plugins from your forked
"         repositories. You don’t need to run :CocInstall coc-pyright since you have already
"         specified the forked repositories in your .vimrc file.

" BACKLOG
" TODO: Use coc boilerplate example to be more precise about versions needed for statusline
" TODO: autopair brackets - in config file, if {<CR> slowly, it fills in with funny stuff - stop it!
" TODO: Check licensing so can distribute
" TODO: git clone dotfiles (or equiv) plus readme with instructions to symlink  ~/.vimrc and helpers (no stow)

" GIT SUPPORT
"         For git TUI tools, see dev.to/mainendra/terminal-ui-for-git-283p
"         and github.com/frontaid/git-cli-tools
"         and github.com/rhysd/conflict-marker.vim
"
" #### START CONFIGURATION

" Set leader to <space>
"let mapleader = "\<Space>"
let g:mapleader = " "
let g:maplocalleader = ' '     " Added for vim-which-key (default was ,)
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  '<Space>'<CR>

" Allow mouse clicks anywhere (eg past column 88) if supported
" xterm2 has been removed in nvim
" if has("mouse_sgr")            
"    set ttymouse=sgr
" else
"    set ttymouse=xterm2
" end

" See https://vimcolorschemes.com/ for more options
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


" #### SECTION: VIM-PLUG PLUGINS

" Select plugin functionality using paramter values
let g:install_plug_lsp = 'coc'                   " Options: 'disable', 'ale', 'coc'
let g:install_plug_vimwhichkey = 'vim-which-key' " disable, which-key, vim-which-key
let g:install_plug_filetree = 'netrw'            " netrw, nvimtree
let g:install_plug_fzf = 1                       " 0 or 1 (for true or false)
   let g:install_plug_fzfbat = 1                    " 0 or 1 (for true or false)
let g:install_plug_comments = 'manual'           " manual or commentary
let g:install_plug_gitcmds = 'disable'           " disable, fugitive

" Required VimPlug Autoinstall
source $HOME/.vimrc_helpers/vimplug_autoinstall.vim

" Install the selected plugins
call plug#begin()
   if g:install_plug_lsp == 'coc' | Plug 'learndog/coc.nvim' | endif
   if g:install_plug_lsp == 'ale' | Plug 'learndog/ale'      | endif
   "if g:install_plug_fzf          | Plug 'learndog/fzf', { 'do': { -> fzf#install() } } | endif
   if g:install_plug_fzf          | Plug 'learndog/fzf' | endif
   if g:install_plug_fzf          | Plug 'learndog/fzf.vim' | endif
   if g:install_plug_fzfbat       | Plug 'learndog/bat' | endif
   if g:install_plug_vimwhichkey == 'which-key' | Plug 'learndog/which-key.nvim' | endif
   if g:install_plug_vimwhichkey == 'vim-which-key' | Plug 'learndog/vim-which-key', {'branch': 'release'} | endif
   if g:install_plug_filetree == 'nvimtree' | Plug 'learndog/nvim-tree.lua'  | endif
   if g:install_plug_gitcmds == 'fugitive' | Plug 'learndog/vim-fugitive' | endif
   Plug 'learndog/vim-maximizer'
   Plug 'learndog/vim-gitgutter', {'branch': 'release'}
   Plug 'learndog/lightline.vim'
   if g:install_plug_comments == 'commentary' | Plug 'learndog/vim-commentary' | endif
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
source $HOME/.vimrc_helpers/tmux.vim
source $HOME/.vimrc_helpers/togglezero.vim
source $HOME/.vimrc_helpers/togglehighlight.vim
source $HOME/.vimrc_helpers/sessions.vim
source $HOME/.vimrc_helpers/config_endstuff.vim



