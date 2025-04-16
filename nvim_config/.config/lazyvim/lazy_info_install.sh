# LAZYVIM INSTALL INSTRUCTIONS
# Last updated 2025-04-15

############################################################
############ INSTALL NEOVIM    #############################
############################################################

# ---------------------------------------------------
# NVIM INSTALL - DEBIAN 
# ---------------------------------------------------
# IMPORTANT NOTE THAT APPLIES TO GCP VERTEX AI VMS ON BUSTER...
# Minimum glibc version to run these releases is 2.31. People requiring releases
# that work on older glibc versions can find them at
# https://github.com/neovim/neovim-releases and https://github.com/neovim/neovim-releases/releases

# See https://github.com/nvim-lua/kickstart.nvim?tab=readme-ov-file#Install-Recipes
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip curl fzf lazygit fd-find # Binary is fdfind
cd ~/temp_install
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
#OR curl -LO https://github.com/neovim/neovim-releases/releases/download/v0.11.0/nvim-linux-x86_64.tar.gz # Built with glibc 2.17 
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/

	# ---------------------------------------------------
	# NVIM INSTALL - UBUNTU
	# ---------------------------------------------------
	# See https://github.com/nvim-lua/kickstart.nvim?tab=readme-ov-file#Install-Recipes
	sudo add-apt-repository ppa:neovim-ppa/unstable -y
	sudo apt update
	sudo apt install make gcc ripgrep unzip git xclip neovim
	sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/

##########################################################
###########  INSTALL LAZYVIM  ############################
##########################################################

# ---------------------------------------------------
# UNINSTALL LAZYVIM 
# ---------------------------------------------------
	# Optionally backup first
	mv ~/.config/lazyvim{,.bak}
	mv ~/.local/share/lazyvim{,.bak}
	mv ~/.local/state/lazyvim{,.bak}
	mv ~/.cache/lazyvim{,.bak}

# Delete everything in the nvim install and cache
rm -rf ~/.config/lazyvim
rm -rf ~/.local/share/lazyvim
rm -rf ~/.local/state/lazyvim
rm -rf ~/.cache/lazyvim

# ---------------------------------------------------
# INSTALL LAZYVIM - with wipdots customization
# ---------------------------------------------------
git clone git@github.com:learndog/wipdots.git ~/wipdots

# Link to wipdots customized lazyvim config
ln -s ~/wipdots/nvim_config/.config/lazyvim/ ~/.config/lazyvim

# ---------------------------------------------------
# CONFIGURE .PROFILE
# ---------------------------------------------------
# In .profile... Set nvim to use lazy config
export XDG_CONFIG_HOME="$HOME/.config"
export NVIM_APPNAME="lazy"
# Check it from nvim cmd line
echo $XDG_CONFIG_HOME
echo stdpath('config')
# Check it from init.lua file
print("Loading init.lua from " .. vim.fn.stdpath('config'))

############################################################
############ INSTALL NERDFONTS #############################
############################################################

------------------------------------------------------------------------------------------
# Nerd Font Install - Windows
------------------------------------------------------------------------------------------
# Download CaskaydiaCove Nerd Font
  # from https://www.nerdfonts.com/font-downloads
  # into C:\Users\me\Fonts\CaskaydiaCoveNerdFonts\
# Select all tts files (not readme or license) and right mouse click to install

	# OR
	# ------------------------------------------------------------------------------------------
	# Nerd Font Install - JupyterLab
	# ------------------------------------------------------------------------------------------
	# Install the font in debian
	wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/CascadiaCode.zip
	cd ~/.local/share/fonts
	unzip CascadiaCode.zip
	rm CascadiaCode.zip
	fc-cache -fv


# ------------------------------------------------------------------------------------------
# Configure Nerd Font in Terminal - JupyterLab
# ------------------------------------------------------------------------------------------
# JupyterLab and go to Settings > Advanced Settings Editor...
# In the Terminal section, add or modify the following JSON configuration:
# ```
{
  "fontFamily": "'Cascadia Code Nerd Font', 'Cascadia Code', monospace",
  "fontSize": 13
}
# ```
# Save the changes and restart your JupyterLab session.
# Note: To determine the font names, try using fc-list | grep Cove

############################################################
###########  CREATE AN NVIM PYTHON ENV  ####################
############################################################
# Assumes the location of .venvs and nvim env as below
# First install desired python 3.10+ if not already available
# See  below for activating it in init.lua for neovim
deactivate
python3 -m venv ~/.venvs/nvim
pip install neovim

############################################################
############ LAZYVIM FIRST TIME SETUP ######################
############################################################
# With :LazyExtra
# * Add lang.python (provides LSP:ruff, pyright, nvim-cmp, LINT:ruff, FORMAT:ruff, DAP:nvim_dap_python, TEST:neotest)
# * Add lang.sql
# * Add lang.docker
# * Add lang.git
# * Add lang.java
# * Add lang.json
# * Add lang.markdown
# * Add lang.typescript
# * Add lang.yaml
# * Add coding.mini-comment  (provides gcc for toggle comment of curr or selected line)

############################################################
############ LAZYVIM OPTIONAL SETUP ########################
############################################################

# ----------------------------------------------------------
# Install luarocks
# ----------------------------------------------------------
TBD

# ----------------------------------------------------------
# Install lazygit
# ----------------------------------------------------------
TBD

# ----------------------------------------------------------
# Install newer version of fd-find (fd, fdfind)
# ----------------------------------------------------------
# Expected fd 8.4 but found 8.2.1
# 8.4 is needed for searching with Snacks.picker.explorer()
# NOTE: On vertexai, get error about unknown compression on control.tar.zst
# https://github.com/sharkdp/fd?tab=readme-ov-file#installation
wget https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-musl_10.2.0_amd64.deb
	# Optionally check out the pkg and dependencies
	dpkg-deb --info fd-musl_10.2.0_amd64.deb # Inspect pkg metadata - versions and dependencies
	dpkg-deb --contents fd-musl_10.2.0_amd64.deb # List package content
	sudo dpkg --dry-run -i fd-musl_10.2.0_amd64.deb # Simulate install without making chgs
sudo dpkg -i fd-musl_10.2.0_amd64.deb
sudo apt-get install -f # Fix any dependency issues if nec


# ----------------------------------------------------------
# Install Snacks.image dependencies
# ----------------------------------------------------------
# Kitty|wezterm|ghostty and needed to support kitty graphics protocol
# magick|convert
# gs tool needs to be installed
# latex treesitter parser needed to render LaTeX expressions
# mmdc needed to support Mermaid diagrams
TBD


############################################################
############ LAZYVIM MAINTENANCE   #########################
############################################################
# From :Lazy do (S) to clean, install, upgrade LazyVim and its plugins
# From :LazyExtras do (S) to clean, install, upgrade extras
# :LazyHealth
# :CheckHealth

############################################################
##### TODO - LAZYVIM CUSTOMIZATION  ########################
############################################################
# * jj, jh, jl for insert mode esc to normal, jump to first letter after left grouper, jump outside next char closer (lookup to match)
# * Remap <leader><leader> to <leader><leader><leader><leader> for cwd files to something else easy so I can use <leader><leader> for all my maps
# * Map <leader><leader><leader> to "<leader>," for buffers - because <leader><leader> is no longer available
# * Add 0$ cycle
# * Folds
# * Indent and move up/down
# * Show this install file by a command
# * Show usage tips and keymap info by a command
# * Show and search keymaps
# * Save, restore and delete sessions
# * Windows - eg faster or repeatable window sizing & maximizer
# * <leader><leader> Convenience and personal stability mappings
#   Same consistent personal interface under <leader><leader> 
#   but leave other stuff the same
#   Will need to...
#     * Map <leader><leader><leader> to "<leader>," for buffers - because <leader><leader> is no longer available
#     * Remap <leader><leader> to <leader><leader>somethingElse for easy access to cwd files fzf (that was the lazyvim default mapping)
#     * Map <leader><leader> to all my maps. Set a variable if possible instead of <leader><leader> in case I want to trigger differently
#     * Map <leader><leader> for symbols/references
#     * Call require("helpers").load_helpers() in your LazyVim file with 
	local M = {}
	function M.load_helpers()
	    vim.cmd("source $HOME/wipdots/.vim_helpers/folding.vim")
	    vim.cmd("source $HOME/wipdots/.vim_helpers/mappings.vim")
	end
	return M
#     * Lazy load my helpers like this...
	vim.keymap.set("n", "<leader>fold", function()
	    vim.cmd("source $HOME/wipdots/.vim_helpers/folding.vim")
	end, { desc = "Load Folding Configurations" })
 #      or simple load them like this...
	vim.cmd([[
	source $HOME/wipdots/.vim_helpers/folding.vim
	source $HOME/wipdots/.vim_helpers/other_helpers.vim
	]])
 #      which will dynamically source files only when a command or keymap is triggered
#     * Consider migrating critical performance items to lua, eg
# 	vim.opt.foldmethod = "indent"
# 	vim.opt.foldlevel = 2


 

############# DEFAULT KEYMAPS
# https://www.lazyvim.org/keymaps



############## SETUP NVIM
# WARNING! This needs work - not usable as-is.

# Set nvim as default editor (or use vim and alias to nvim)
git config --global core.editor "nvim"
alias nvimdiff='nvim -d'
# Set nvimdiff, ie nvim -d, as the diff and merge tool
git config --global difftool.nvimdiff.cmd "nvim -d \"$LOCAL\" \"$REMOTE\""
git config --global mergetool.nvimdiff.cmd "nvim -d \"$LOCAL\" \"$REMOTE\" \"$BASE\" \"$MERGED\""
git config --global diff.tool nvimdiff # Set as default tool
git config --global difftool.prompt false  # Git will launch without prompting
git config --global merge.tool nvimdiff # Set as default tool
git difftool <commit1> <commit2> # Test it
git mergetool # Test it

# Open files for comparison
git difftool # Compare LOCAL and REMOTE
nvim -d file1 file2
nvimdiff file1 file2 # with alias

# View comparisons (e.g., commits, branches, files)
git diff <file1> <file2>  # Compare two files
git diff <commit-hash> <file> # Compare working dir to a specific commit
git diff <commit1> <commit2> <file> # Compare commits for a file (or can compare branches)
git diff <commit-hash> <file> # Compare to a commit for a file


