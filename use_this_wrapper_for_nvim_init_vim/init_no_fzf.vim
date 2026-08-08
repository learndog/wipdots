" Omarchy Vim wrapper: full feature set except FZF.
" Copy this file to ~/.vimrc for Vim or ~/.config/nvim/init.vim for Neovim.
" Keep this path pointed at the git repo copy of omarchy/vim/init.vim.
let s:omarchy_vim_init = expand('~/dev_windows/dotfiles/omarchy/vim/init.vim')

let g:omarchy_use_fzf = 0
let g:omarchy_use_gitgutter = 1
let g:omarchy_use_fugitive = 1

let g:omarchy_install_copilot = 1
let g:omarchy_copilot_suggestions_start_enabled = 1
let g:omarchy_enable_copilot_cli_mapping = 1

let g:omarchy_python_format_imports = 1
let g:omarchy_python_keyword_completion = 1

execute 'source ' . fnameescape(s:omarchy_vim_init)
