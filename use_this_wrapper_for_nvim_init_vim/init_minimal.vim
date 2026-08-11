" Omarchy Vim wrapper: optional Omarchy flags explicitly disabled.
" Copy this file to ~/.vimrc for Vim or ~/.config/nvim/init.vim for Neovim.
" Keep this path pointed at the git repo copy of omarchy/vim/init.vim.
let s:omarchy_vim_init = expand('~/dev/dotfiles/omarchy/vim/init.vim')

let g:omarchy_use_fzf = 0
let g:omarchy_use_gitgutter = 0
let g:omarchy_use_fugitive = 0

let g:omarchy_install_copilot = 0
let g:omarchy_copilot_suggestions_start_enabled = 0
let g:omarchy_enable_copilot_cli_mapping = 0

let g:omarchy_python_format_imports = 0
let g:omarchy_python_keyword_completion = 0
" Python tooling: disabled for the minimal wrapper.
let g:omarchy_python_lsp = ''
let g:omarchy_python_linters = []
let g:omarchy_python_lsp_on_open = 0
let g:omarchy_python_lint_on_open = 0
let g:omarchy_python_references_command = 'ALEFindReferences -quickfix'

execute 'source ' . fnameescape(s:omarchy_vim_init)
