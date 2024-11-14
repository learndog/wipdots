# Vim Setup

" Required files
  "    ~/.vimrc                                                                                                            
  "    ~/.vimrc_helpers                                                                                                    
                                                                                                                           
" Required location of wipdots... ~/wipdots

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
                                                                                                                           
  " * Optionally install NEOVIM instead..."                                                                                
  
  "     Install simply from release package on Debian
  "         Which release to install depends on the version of glibc (with $ ldd --version)
  "         > Older linux like Debian 10 (Buster)... https://github.com/neovim/neovim-releases (built on glibc 2.17)
  "         > Recent versions... https://github.com/neovim/neovim/releases/   (glibc 2.31 or newer is required)
  "           Note that Ubuntu 24.04.1 LTS has 2.39, so it can use the regular Debian nvim release package
  "         Install process
  "         > cd /opt
  "         > Download into /opt wget nvim-linux64.tar.gz
  "         > Extract: tar xzvf nvim-linux64.tar.gz
  "         > Remove temp: rm nvim-linux64.tar.gz
  "         > Run ./nvim-linux64/bin/nvim
  "         > Add to path in .bashrc or .profile
  "           export PATH="$PATH:/opt/nvim/bin"
  "         > Run (after resourcing the profile) from anywhere with $ nvim
  "         Note: Or may need to extract into temp_install and then move it

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
                                                                                                                           
  " * Use .vimrc for nvim
  " rm ~/.config/nvim/init.vim   # if necessary (but make a backup first)
  " mkdir -p ~/.config/nvim
  " ln -s ~/.vimrc ~/.config/nvim/init.vim


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
  " PUDB - TUI Debugger for Python - UNTESTED
  """""""""""""""""""""""""""""""""""""""""""""""                                                                          
  https://github.com/inducer/pudb
  https://documen.tician.de/pudb/misc.html
  For a tool survey, see https://python.plainenglish.io/cracking-the-code-a-guide-to-python-debugging-tools-70ecc351a457

  Setup
   * Install... $ pip install pudb
   * Put this line in .bashrc (Python 3.7+ only)
        export PYTHONBREAKPOINT="pudb.set_trace()"
     so breakpoints can be set in source with... set breakpoint()

  Set breakpoints in the source code with
   * set breakpoint()  # OR pudb.set_trace() if Python <3.7 or PYTHONBREAKPOIN not set
         
  To debug
    * Run script with... python -m pudb.run my_script.py
      OR run normally adding one of the following imports to the code being debugged...
           from pudb import set_trace; set_trace()
           import pudb; pu.db  # Same thing in abbreviated form

  Interactive debug shell
    * At any point while debugging, 
            Press Ctrl-x to switch to the built in interactive shell.
            From here, you can execute Python commands at the current point of the debugger.
            Press Ctrl-x again to move back to the debugger.
    * Keyboard shortcuts defined in the internal shell:
            Enter: Execute the current command
            Ctrl-v: Insert a newline (for multiline commands)
            Ctrl-n/p: Browse command history
            Up/down arrow: Select history
            TAB: Tab completion
            +/-: grow/shrink the shell (when a history item is selected)
            _/=: minimize/maximize the shell (when a history item is selected)

  To use pudb to debug test failures in pytest, run the test like this:
      $ pytest --pdbcls pudb.debugger:Debugger --pdb --capture=no  # -capture=no (or equiv with... -s) is necessary

  OPTION 1a... With Jupyter
    * pip install pudb
    * import into script or Jupyter cell as before
    * Use pudb.set_trace() to trigger debugging

  OPTION 1b... With iPython
    * from an iPython terminal, just run the script containing pudb.set_trace()
      and when the debugger is invoked, you will see the TUI for PuDB
    * use all the usual commands to inspect vars, step thru code, etc  

  OPTION 2... using %debug in iPythona
    This allows more flexibility when you hit an error in an iPython or Jupyter nootebook and want to dive deeper
    * Add the following config in an iPython session to load PuDB as the default debugger
    ```
    from IPython.core.debugger import set_trace
    import pudb
    set_trace = pudb.set_trace
    ```
    Now, whenever you use %devug after an error, it will use PuDB as the debugging tool instead of the default.

  OPTION 3a... using PuDB in term while running Jupyter Notebook
    Not generally well suited for Jupyter Notebook because it's a TUI, but can use PuDB in a term while running jupyter
    * Run your code within a function and set a breakpoint with pudb.set_trace()
    * Execute the code block, and once it hits the breakpoint, PuDB will launch in term where Jupyter was started

  OPTION 3b... with %pudb... using PuDB in term while running Jupyter Notebook
    Use magic command to drop into PuDB debugger when a cell has some suspicious code.
    This isn't avail by default, but you can install an extension or define it yourself
    For example
    ```
    from IPython.core.magic import register_line_magic
    import pudb

    @register_line_magic
    def pudb(line)
        return pudb.set_trace()

    # Then in your Jupyter cell, use...
    %pudb
    ```

  Features
    * Syntax-highlighted UI
      - Source, the stack, breakpoints and variables are all visible at once and continuously updated.
      - This helps you be more aware of what's going on in your program.
      - Variable displays can be expanded, collapsed and have various customization options.
    * Pre-bundled themes
      - Including dark themes via "Ctrl-P".
    * Keyboard-based navigation.
      - PuDB understands cursor-keys and Vi shortcuts for navigation.
      - Other keys are inspired by the corresponding pdb commands.
    * Find relevant source code with search
      or use "m" to invoke the module browser
        - shows loaded modules
        - lets you load new ones
          and reload existing ones.
    * Breakpoints can be set just by pointing at a source line and hitting "b"
      and then edited visually in the breakpoints window.
      - Or hit "t" to run to the line under the cursor.
    * Drop to a Python shell in the current environment by pressing "!".
      - Or open a command prompt alongside the source-code via "Ctrl-X".
    * PuDB places special emphasis on exception handling.
      - A post-mortem mode makes it easy to retrace a crashing program's last steps.
    * Control the debugger from a separate terminal.
    * IPython integration (see wiki)
    * Should work with Python 3.6 and newer.
      - Versions 2019.2 and older continue to support Python 2.7.

  Tips
  * If need to go back to source window from Variables/Stack/Breakpoints view, press left arrow key
  * If screen content gets messed up, type "reset" (even if you can''t see what you are typing 
  * At the programming language level, it's the same as pdb command line
    except pudb instead of pdb, and run is called runstatement
    
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

  " Install pylint and black...
  " pip install pylint black
  " 
    
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
                                                                                                                           
  " Note that you might be able to fix a rename timeout from pyright (id with :CocOpenLog) by doing...
  " npm install -g pyright

  " Reset vim to pristine newly installed condition                                                                        
  "       1. Delete the entire ~/.vim directory                                                                            
  "       2. Remove this .vimrc file and .vimrc_helpers (unstow or remove the symlinks)                                    
