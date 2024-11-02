# Vim Setup

" Required files
  "    ~/.vimrc                                                                                                            
  "    ~/.vimrc_helpers                                                                                                    
                                                                                                                           
  " See bottom of this file for more information                                                                           
  "     including suggested setup on WLS Ubuntu 24.04LTS                                                                   

" Requirements:                                                                                                          
" * Vim 8.2.3555+ with +python3                                                                                          
" * python3... pip install black pyright                                                                                 
" * linux...   nodejs, npm, fzf, bat (batcat), rg (ripgrep), delta                                                       
" * pyright -> pip install pyright (for coc python linting)                                                              
" * Debian 11+ or Ubuntu 22+ preferred
" * 


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
  "     required: { node: '^18.18.0 || >=20.0.0' }
                                                                                                                           
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
  "     coc.vim requires at least Vim 8.1.1719 or Neovim 0.4.0                                                            
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
  
  "     Install simply from release package on Debian
  "         Which release to install depends on the version of glibc (with $ ldd --version)
  "         > Older linux like Debian 10 (Buster)... https://github.com/neovim/neovim-releases (built on glibc 2.17)
  "         > Recent versions... https://github.com/neovim/neovim/releases/   (glibc 2.31 or newer is required)
  "           Note that Ubuntu 24.04.1 LTS has 2.39, so it can use the regular Debian nvim release package
  "         Install process
  "         > Download nvim-linux64.tar.gz
  "         > Extract: tar xzvf nvim-linux64.tar.gz
  "         > Run ./nvim-linux64/bin/nvim
  
  "     Install nvim on Debian 10 (Buster) with appimage
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

  " Install node with NVM
    https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script
    command -v nvm       (should output nvm if installed successfully)
    nvm install node
    nvm use node
    
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
