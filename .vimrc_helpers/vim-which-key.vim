" Configure vim-which-key

" highlight Normal ctermfg=grey ctermbg=darkblue
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :WhichKeyVisual '<Space>'<CR>

autocmd FileType which_key highlight WhichKey ctermbg=12 ctermfg=7
autocmd FileType which_key highlight WhichKeySeperator ctermbg=12 ctermfg=7
autocmd FileType which_key highlight WhichKeyGroup cterm=bold ctermbg=12 ctermfg=7
autocmd FileType which_key highlight WhichKeyDesc ctermbg=12 ctermfg=7
autocmd FileType which_key highlight WhichKeyFloating ctermbg=12 ctermfg=7
