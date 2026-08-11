" Omarchy Vim wrapper: all optional Omarchy features enabled.
" Copy this file to ~/.vimrc for Vim or ~/.config/nvim/init.vim for Neovim.
" Keep this path pointed at the git repo copy of omarchy/vim/init.vim.
let s:omarchy_vim_init = expand('~/dev/dotfiles/omarchy/vim/init.vim')

let g:omarchy_use_fzf = 1
let g:omarchy_use_gitgutter = 1
let g:omarchy_use_fugitive = 1

let g:omarchy_install_copilot = 1
let g:omarchy_copilot_suggestions_start_enabled = 1
let g:omarchy_enable_copilot_cli_mapping = 1

let g:omarchy_python_format_imports = 1
let g:omarchy_python_keyword_completion = 1
" Python tooling: stronger profile; requires Node pyright-langserver plus ruff/pylint.
let g:omarchy_python_lsp = 'pyright'
let g:omarchy_python_linters = ['ruff', 'pylint']
let g:omarchy_python_lsp_on_open = 1
let g:omarchy_python_lint_on_open = 0
let g:omarchy_python_references_command = 'ALEFindReferences -quickfix'

execute 'source ' . fnameescape(s:omarchy_vim_init)
