#echo "BEGIN .profile EXECUTION"

# .bashrc should include this deactivate section (duplicating .profile)
# and should call .profile to accomodate nvim terminal sessions
# which use .bashrc by default instead of .profile

#################################################################################
## DEACTIVATE CONDA AND VENV ENVIRONMENTS
#################################################################################

# export CONDA_AUTO_ACTIVATE_BASE=false
# Deactivate all conda environments
while [ -n "$CONDA_DEFAULT_ENV" ]; do
  conda deactivate &
  conda deactivate
  # echo "Deactivated conda - with while loop"
done

deactivate && deactivate
export VIRTUAL_ENV=""

## FZF

# Enable fuzzy fzf completion, eg cd **TAB
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#################################################################################
# NODE SETUP
#################################################################################

## NVM

# Configure and load NVM
export PATH=$PATH:/home/jupyter/.nvm/versions/node/v23.1.0/bin/
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

#################################################################################
# PYTHON SETUP
#################################################################################

## PYTHON SHORTCUTS

alias python="python3"
alias pip="pip3"

## PYTHON - UV

# export PATH="~/.venvs/myenv310/bin:"$HOME/.local/bin/env":$PATH"
# source $HOME/.local/bin/env
# alias pip="uv pip"

## PYTHON - PYENV

# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$HOME/.pyenv/shims:$PATH"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

## PYTHON - FROM SOURCE

export PATH="$HOME/.local/python-3.10.16/bin:$PATH"
# export PATH="$HOME/.local/python-3.10.14/bin:$PATH"
# export PATH="$HOME/.local/python-3.12.8/bin:$PATH"

# Add path to sqlite3 in the library path (needed if python compiled from source with link to sqlite3)
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

#################################################################################
#  VIM AND NVIM SETUP
#################################################################################

## VIM

# Configure vim
export "PATH=$PATH:/usr/local/bin/vim"
export MYVIMRC=$HOME/.vimrc

## NVIM ##################################

#export PATH="$PATH:/opt/nvim-linux64/bin/nvim"
#export PATH="$PATH:/opt/nvim-linux64/bin"
export XDG_CONFIG_HOME="$HOME/.config"
export NVIM_APPNAME="lazyvim"
# alias vim='nvim'

#################################################################################
# PROJECT SPECIFIC SETTINGS - CHOOSE ONE TO UNCOMMENT AS DEFAULT ENV
#################################################################################

# SCRATCH312 -  Misc python 3.12 projects including L1 Support

source ~/dev/activate_scratch312
cd ~/dev/scratch_pdm/

# -------------------------------------------------------------------------------

# DQA - Data Quality Assessment

# OLD - Reserved as THE dqa environment when ready. May not exist.
# source ~/dev/activate_dqa
# cd ~/dqa_devpipeline

# CURR - Fallback until 310 is ready
# source ~/dev/activate_dqa37
# cd ~/dqa_devpipeline

# source ~/dev/activate_dqa310
# cd ~/dqa_devpipeline

# Set the DQA environment variables
export ENV_NAME='dev'
export PROJECT_ID='dna-huboutbnd-mobius-dev1-8460'

# -------------------------------------------------------------------------------

# MOBIUS - Mobius standard environment.

# MISSING -  Will recreate as pdm310
# source ~/dev/activate_scratch_pdm37
# cd ~/dev/scratch_pdm/

# -------------------------------------------------------------------------------

# DOCCHAT - GenAI RAG application

# source ~/dev/activate_docchat
# cd ~/dev/docchat1/

# -------------------------------------------------------------------------------

#################################################################################
# VISUAL COMMAND LINE CUSTOMIZATION
#################################################################################

# -------------------------------------------------------
# DEPRECATED - SET CUSTOM PROMPT WITH GIT BRANCH
# -------------------------------------------------------
# #  Support function for prompt - git branch
# parse_git_branch() {
#       git branch 2>/dev/null | grep '*' | sed 's/* //'
# }
# # Support function for prompt - only last part of $VIRTUAL_ENV
# function venv_name {
#       if [[ -n "$VIRTUAL_ENV" ]]; then
#       echo "($(basename $VIRTUAL_ENV))"
#       fi
# }
# # Set the prompt
# export PS1="${debian_chroot:+($debian_chroot)}\[\033[35m\]$(venv_name)[\$(parse_git_branch)] \n\[\033[32m\]\w\[\033[33m\]\[\033[00m\]$ "
# -------------------------------------------------------

# -------------------------------------------------------
# SET CUSTOM PROMPT WITH GIT BRANCH - set_prompt
# -------------------------------------------------------
# Support function for prompt - git branch
parse_git_branch() {
  git branch 2>/dev/null | grep '*' | sed 's/* //'
}

# Support function for prompt - only last part of $VIRTUAL_ENV
venv_name() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "($(basename $VIRTUAL_ENV))"
  fi
}

# Function to set the prompt
set_prompt() {
  export PS1="${debian_chroot:+($debian_chroot)}\[\033[35m\]$(venv_name)[\$(parse_git_branch)] \n\[\033[32m\]\w\[\033[33m\]\[\033[00m\]$ "
}

# Initialize prompt for the first time
set_prompt

# -------------------------------------------------------

#################################################################################
# USER CONVENIENCE TOOLS
#################################################################################
# -------------------------------------------------------
# BASH HISTORY FZF WITH CTRL-r
# -------------------------------------------------------
fzf_history_widget() {
  local selected
  # Use `fzf` to interactively search through your Bash history
  selected=$(history | awk '{$1=""; print $0}' | fzf --height 40% --reverse --border --query "$READLINE_LINE")
  if [ -n "$selected" ]; then
    READLINE_LINE="$selected"        # Populate the command to the prompt
    READLINE_POINT=${#READLINE_LINE} # Set the cursor to the end
  fi
}
bind -x '"\C-r": fzf_history_widget'
# -------------------------------------------------------

# -------------------------------------------------------
# FZF INLINE FILENAME COMPLETION WITH CTRL-f
# -------------------------------------------------------
# BROKEN # bind '"\C-f": "$(ls | fzf | tr -d \'\r\n\')"'

# -------------------------------------------------------
# FZF FIND FILE FUNCTION - find_file
# -------------------------------------------------------
# TODO

#########################################################
### END STUFF
#########################################################
echo ".profile complete"
