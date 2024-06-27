" VIM CONFIGURATION - Python microIDE
"    ~/.vimrc
"    ~/.vimrc_helpers

" See bottom of this file for more information
"     including suggested setup on WLS Ubuntu 24.04LTS

" ###################################################################################
" #### USER FEATURE SELECTION <<<<CHANGE ME!!!!>>>>
" ###################################################################################
" Select functionality... choose a value
   let g:install_plug_lsp = 'coc'                   " Options: 'disable', 'ale', 'coc'
   let g:install_plug_vimwhichkey = 'vim-which-key' " disable, which-key, vim-which-key
   let g:install_plug_filetree = 'netrw'            " netrw, nvimtree
   let g:install_plug_fzf = 1                       " 0 or 1 (for true or false)
      let g:install_plug_fzfbat = 1                 " 0 or 1 (for true or false)
   let g:install_plug_comments = 'manual'           " manual or commentary
   let g:install_plug_gitcmds = 'disable'           " disable, fugitive
" ###################################################################################

" Requirements:
" * Vim 8.2.3555+ with +python3
" * python3... pip install black pyright
" * linux...   nodejs, npm, fzf, bat (batcat), rg (ripgrep), delta
" * pyright -> pip install pyright (for coc python linting)
" * Debian 11+ or Ubuntu 22+ preferred

" Tips:
" * Copy paste from sys clipboard variations...
"         select: visual mode or select with mouse
"         copy:   Ctrl-c | Ctrl+Insert | Shift+Insert
"         copy:   SHIFT select your text, then copy with CTRL+SHIFT+C (from WSL/CA to Windows)
"         cut: Shift+Del
"         paste:  Ctrl-v | Shift RightClick | middle mouse button
"         replace: copy and then visual select the destination text to replace, then p
"         
"         If you paste from system clipboard into vim and get ^M at end of line,
"         try instead to enter INSERT mode first, and use Ctrl-v to paste. (Probably a Windows->Linux thing.)

" ###################################################################################
" #### START VIM CONFIGURATION
" ###################################################################################
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
" ###################################################################################
" #### END VIM CONFIGURATION
" ###################################################################################

" PRIORITIES
" * Reorg keymaps by helper file (including overwrites to document keymap and add whichkey text)
"       Confirm that disable, which-key and vim-which-key have compatible formats
"

" BUGS
" * Block move lines in visual mode with Shift > and Shift <
" * Visual mode <space> up, down, right, left (odd multiline behavior)
" * Lightline only updates the time when the mode changes.
" * autopair brackets - in config file, if {<CR> slowly, it fills in with funny stuff - stop it!

" KEYMAPS
" * Add organize imports with coc with keymap for ":call CocAction('runCommand', 'editor.action.organizeImport')"
" * Add :e $VIMRC
" * Add :echo $VIMRC
" * Add block alignment script and keymap
"           esp for docstrings like 'parameter:      mytext'
" * Page (or 1/2 or 2/3 page) up and down keeping cursor in middle of page (see old configs)
"           or simply add "M" after full page scroll
" * Remove keymaps that cause muscle memory to change text
" * Keymap to set a .vimrc paramter for color theme
" * Use del key to delete without yank (and update copypaste hint at top of this .vimrc file)
" * Add a keymap to trigger WhichKey from visual line mode
"
" FZF SEARCH
" * Help file content
" * Keymap and verbose(where keybind def) keymap searches using vim-which-key. 
"         See https://jay-baker.com/posts/vim-1-which-key/
" * :[b|p|d]Lines and :[b|p|d]Files  (b=curr buffer, bb=open buff files, p=project, d=specify dir)
" * LINES and FILES searches by regex
" * :Commits and :BCommits commands as in
"         https://bluz71.github.io/2018/12/04/fuzzy-finding-in-vim-with-fzf.html
"         Try other fzf - pattern match, key maps, MRU files sorted by MRU or alpha, 
"         diagnostiics, current buffer files, file content etc
"         MRU or same dir files...  nnoremap <silent> <Space>. :Files <C-r>=expand("%:h")<CR>/<CR>
" * Add :verbose map 
" * fzf key bindings (and verbose version of fzf keymaps)

" GIT
" * Integrate with git diff? What is fzf.vim :GF?
" * git mergetool keymap for select local/remote/base (OR lazygit? magit? github.com/mkchoi212/fac?)
" * Synch scroll for git blame sidebar

" FILE EXPLORER
" * Open file explorer using vim cwd OR curr buff file dir OR proj dir
" * :cd to project top level folder or to current buffer file location
" * TUI FIle manager... https://terminaltrove.com/superfile/, ranger, mc,...  (outside of VIM can launch in vim?)
" * launch external file TUI at curr dir / proj folder 
" * Add nvim-tree.lua for nvim (https://github.com/nvim-tree/nvim-tree.lua) no deps but nice

" BUFFERS AND TABS
" * Close buffer (:bd)
" * Keymaps for next and previous tab... gt or gT
" * Buffer and tab rename
" * Open buffers as new tabs (if not already a tab)
" * Close all tabs (wihtout error on last one) but keep buffers
" * Open file in new split or tab (after selecting in netrw also?)

" LANGUAGE SERVER
" * Diagnostics: Show list and do Previous/Next or fzf search
" * format or format on save or format from project folder
" * coc working folders (and see other items in :CocList)

" FILE DIFFS
" * Integrate with external diff, colordiff, nbdiff, difftastic, vimdiff, github.com/dandavison/delta 
"         Also see github.com/whiteinge/diffconflicts for vim-diffconflicts

" TERMINALS
" * Keymaps for :terminal, :vertical terminal, :vertical <modifier> terminal,
"       where <modifier> is... lefta[bove], abo[veleft], bel[owright], rightb[elow]
"       See https://www.baeldung.com/linux/vim-terminal-open-position
" * Keymaps for :tab terminal

" SNIPPETS
" * Simple manual snippets (and keep in git - manual updates get pushed, no on-the-fly additions) 

" OLD VIM VERSIONS
" * fix sign column toggle for vim 7.4-
"       see https://stackoverflow.com/questions/18319284/vim-sign-column-toggle
" * Add support for old (cavim) versions, eg https://github.com/ctrlpvim/ctrlp.vim

" NATIVE NVIM
" * Nvim compatibility
" * Commenting should start at first nonws char, not col pos 1 (works in vim)
" * Ensure coc organize imports works - See https://github.com/neoclide/coc.nvim/issues/4372
" * Try debug capabilities

" TMUX SUPPORT
" * Fix Ctrl-arrows and status line colors for vim running in tmux

" WINDOWS
" * Better splits and windows - see https://github.com/Aster89/WinZoZ/tree/main
" * Add a <leader> version of <C-W> commands

" TESTS
" * Code and unit test - fast process

" DEBUG
" * Debug python in terminal
"         See www.reddit.com/r/vim/comments/jg91dt/using_termdebug_for_pythons_pdb_examples/
" * Try vimspector... https://github.com/puremourning/vimspector

" IPYTHON
" * Add vim-ipython-cell (run cells inside .py files in Vim)
"       and/or jupyter console with script to start kernel and connect to it (lastest one)
"         See locally saved discussion
"         and see code.visualstudio.com/docs/python/jupyter-support-py
"         and see stackoverflow.com/questions/64730660/how-do-i-find-excute-python-interactive-mode-in-visual-studio-code
"         and https://github.com/luk400/vim-jukit
"         and https://github.com/jpalardy/vim-slime
"
"       Edit and run Jupyter notebooks from Vim or Neovim
"          1. **Molten and Quarto**: Molten is a plugin that enables a notebook-like code running experience¹. It can start Jupyter kernels or attach to already running kernels, run code with those kernels, and show the output right below the code that was run¹. Quarto is a tool for writing and publishing literate programming documents¹. The Neovim plugin `quarto-nvim` provides LSP Autocomplete, formatting, diagnostics, go to definition, and other LSP features for code cells in markdown documents¹.
"          2. **Jupyter-Vim**: This is a two-way integration between Vim and Jupyter². It allows you to develop code on a Jupyter notebook without leaving the terminal². You can send lines from Vim to a Jupyter qtconsole and have a MATLAB-like "cell-mode"².
"          3. **Vim-Notebook**: This plugin allows you to edit `.ipynb` files locally using Vim³.
"          4. **Vimpyter**: This is another plugin that allows you to edit your Jupyter notebooks in Vim/Neovim⁴.
"          5. **Jupytext.vim**: This Vim plugin allows you to edit Jupyter `.ipynb` files⁵. Make sure that you have the `jupytext` CLI program installed (`pip install jupytext`)⁵.
"         Sources
"          (1) How to: Edit Jupyter Notebooks in Neovim (with very few ... - Reddit. https://www.reddit.com/r/neovim/comments/17ynpg2/how_to_edit_jupyter_notebooks_in_neovim_with_very/.
"          (2) A two-way integration between Vim and Jupyter - Python Awesome. https://pythonawesome.com/a-two-way-integration-between-vim-and-jupyter/.
"          (3) Hack of the day: edit and run Python notebook inside vim(neovim). https://medium.com/@teddy23ai/hack-of-the-day-edit-and-run-python-notebook-inside-vim-neovim-19970436b2cd.
"          (4) szymonmaszke/vimpyter: Edit your Jupyter notebooks in Vim/Neovim - GitHub. https://github.com/szymonmaszke/vimpyter.
"          (5) GitHub - goerz/jupytext.vim: Vim plugin for editing Jupyter ipynb files .... https://github.com/goerz/jupytext.vim.
"          (6) undefined. https://github.com/jupyter-vim/jupyter-vim.git.
"          (7) undefined. https://github.com/jupyter-vim/vim-notebook.git.

" PLUGIN MANAGEMENT
" * Use specified commit or version for plugins
" * Use forked fugitive, maximizer, tmuxvimnavigator, whichkey, autoformat, ...
" * Fix or confirm proper plugin branches are available and installed in the forked repos
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

" BACKLOG
" * Which comments_manual.vim helper file has the improvements?
" * Add statusline detailed dependencies info
" * Check licensing so can distribute
" GIT SUPPORT
"         For git TUI tools, see dev.to/mainendra/terminal-ui-for-git-283p
"         and github.com/frontaid/git-cli-tools
"         and github.com/rhysd/conflict-marker.vim
"

"""""""""""""""""""""""""""""""""""""""""""""""
" DETAILED REQUIREMENTS BY PLUGIN
"""""""""""""""""""""""""""""""""""""""""""""""
"
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

"   ale
"     https://github.com/dense-analysis/ale
"     NeoVim 0.2.0+ or Vim 8.0+

"   folke which-key
"     main branch
"     https://github.com/folke/which-key.nvim
"     Also includes functionality for marks, registers, spelling, etc

"""""""""""""""""""""""""""""""""""""""""""""""
" VIM/NVIM INSTALLS: ADDITIONAL INFO: 
"""""""""""""""""""""""""""""""""""""""""""""""
" * Vim 8.2.3555+ with +python3 (see www.reddit.com/r/vim/comments/qub6j9/comment/hsi5rgq/)
"     Check python3 support with vim --version or :echo has('python3')
"     It may also work on Vim 7, but will not modify the default status line
"     coc.nvim requires at least Vim 8.1.1719 or Neovim 0.4.0
"     Debian 11 package manager has Vim 9.0.1378-2 (sudo apt install vim) +python3 +lua 
"     Ubuntu 24.04 has Vim 9.1 with +python3
"     Enable the +python3 feature in Vim by installing the vim-gtk package.

" * Optionally install current VIM from source
"     # May not work on gcp vertex AI vm. Try https://richrose.dev/posts/linux/vim/vim-compile/
"     sudo apt remove vim vim-tiny vim-common vim-gui-common vim-nox  vim-runtime gvim
"     cd && git clone https://github.com/vim/vim.git   # Current vim 9 seems to work!
"     cd vim && git pull
"     cd src && make distclean                      # Clean config files and all generated files
"     sudo apt install libncurses-dev python3-dev
"     # configure statement assumes python 3.7 with python3 cmd to run python
"     # You may need to modify the config stmt with-python-config-dir=my-python-header-files-dir
"     #     where the dir can be found with find /usr -name Python.h
"     #     For vertexai gcp, try 
"     #       make distclean                        # make clean would only remove intermed files and libs
"     #       --with-python-config-dir=/usr/include/python3.7m
"     ./configure --with-features=huge --enable-rubyinterp --enable-python3interp --with-python-config-dir=$(python3-config --configdir) --with-python3-command=python3 --enable-perlinterp --enable-gui=gtk2 --enable-cscope --enable-luainterp --enable-multibyte
"     make
"     sudo make install
"     make distclean              # Clean up uneeded configure files and make files after install

" * Optionally install VIM or NVIM with snap

" * Optionally install NEOVIM instead..."
"     Install nvim on Debian 10 (Buster)
"     Following https://github.com/neovim/neovim/wiki/Installing-Neovim
"     # NOTE: Don't install FUSE because requires a privileged container
"       Install neovim
"       cd && mkdir usr && cd usr
"       curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
"       chmod 755 nvim.appimage
"       # Because older version of Ubuntu
"       ./nvim.appimage --appimage-extract
"       ./squashfs-root/AppRun --version
"       # Make it available globally
"       sudo mv squashfs-root /squashfs-root
"       sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
"       cd && nvim -v
"       rm nvim.appimage && nvim -v
  
" Notes...
" - pip install pyright will automatically install node (microsoft.github.io/pyright/#/installation)
" - Config for coc-pyright can be found at https://github.com/fannheyward/coc-pyright
"       See capabilities at https://github.com/microsoft/pyright/blob/main/docs/features.md
" - If using nvim, change the stow for .config/nvim/config/nvim/init.vim and also stow .vimrc_helpers
" - With nvim, might be better to move from coc with the node requirement to a native solution in nvim
"        * See https://www.reddit.com/r/neovim/comments/14pvyo4/why_is_nobody_using_coc_anymore/
"        * Try none-ls.nvim, mason.nvim, nvim-cmp and something like LuaSnip. May need nvim-lspconfig.
"
"
"
"""""""""""""""""""""""""""""""""""""""""""""""
" MISC BONUS CHEATSHEETS 
"""""""""""""""""""""""""""""""""""""""""""""""
"
" SSH Key Pair Setup
"   ssh-keygen -t ed25519 -C "your_sanitized_email@example.com" # See 
"   eval "$(ssh-agent -s)"   # Add private key to ssh agent. May vary by OS
"   ssh-add ~/.ssh/id_ed25519
"   # For linux server, also add public key to ~/.ssh/authorized_keys
"   # For GitHub repos
"         - Also go to settings to add public key
"         - Test the key with... todo
"         - See https://github.com/settings/keys and todo... private email info
"   # With ssh config file, use entries like... todo
"
" Stow instructions
"     # Probably easier to just create the symlinks manually if not already using stow
"     # Assumes a github repository user/dotfiles with config file dotfiles/vim/.vimrc
"     sudo apt-get install stow
"     cd ~ && git clone git@github.com/github_user/github_repository
"     stow -t ~ ~/dev/wipdots/vim  # Create symlink(s) in ~/ pointing to each file INSIDE dotfiles/vim/
"     mkdir ~/.vimrc_helpers/
"     stow -t ~/.vimrc_helpers/ ~/dev/wipdots/vim/.vimrc_helpers  # Create symlinks in ~/.vimrc_helpers/ 

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

"""""""""""""""""""""""""""""""""""""""""""""""
" GETTING STARTED WITH VIM IN UBUNTU 24.04 (WITH WSL)
"""""""""""""""""""""""""""""""""""""""""""""""
" This is somewhat opinionated about pyenv, file locs, naming
"
" Install Python3
" sudo apt-get update && sudo apt-get install -y \
"  make \
"  build-essential \
"  libssl-dev \
"  zlib1g-dev \
"  libbz2-dev \
"  libreadline-dev \
"  libsqlite3-dev \
"  wget \
"  curl \
"  llvm \
"  libncurses5-dev \
"  libncursesw5-dev \
"  xz-utils \
"  #tk-dev \       # Not needed - but check it
"  #liblzma-dev    # Not needed - but check it
" pyenv install 3 && pyenv global 3.12.4 (for example)
" pip install pyright black (python lsp and formatter)

" More linux prereqs
" sudo apt install nodejs npm (or install with NVM)
" sudo apt install fzf bat ripgrep (fzf, rg, bat for cat w/highlighting - aka batcat)
" install delta for diff formatting... if desired 
"     cd ~/temp_install && wget http://... (see github.com/dandavison/delta)
"     sudo dpkg -i git-delta_0.17.0_amd64.deb

" Install Vim (recent version with python should be available already)
"     Add to .profile or .bashrc: export MYVIMRC="$HOME/.vimrc"

" Install the Vim config
"     Vim config development only - ssh key setup for GitHub, with git config privitized email, name
"     git clone wipdots into ~/dev
"     ln -s $HOME/dev/wipdots/.vimrc $HOME/.vimrc
"     ln -s $HOME/dev/wipdots/.vimrc_helpers/ $HOME/.vimrc_helpers 

" First run...
" :PlugInstall should run automatically
" :CocInstall coc-pyright coc-jedi
"       To fix the coc.nvim build/index.js not found, do yarn install, error...
"         :call coc#util#install()      from vim command line
"         OR cd ~/.vim/plugged/coc.nvim && npm install && npm audit fix
"         Restart vim
"       For nvim, use cd ~/.local/share/nvim/plugged/coc.nvim (default coc install loc)

" Update plugins... eg after changing which plugins are enabled
"     :PlugUpdate                  updates all plugins
"     :PlugUpdate <my-plugin>      updates one plugin
"     :PlugUpgrade                 upgrade vim-plug (MUST RUN :PlugUpdate first)

" Reset vim to pristine newly installed condition
"       1. Delete the entire ~/.vim directory
"       2. Remove this .vimrc file and .vimrc_helpers (unstow or remove the symlinks)

"""""""""""""""""""""""""""""""""""""""""""""""
" END OF FILE
"""""""""""""""""""""""""""""""""""""""""""""""
