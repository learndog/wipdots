" Configure vim-which-key

" highlight Normal ctermfg=grey ctermbg=darkblue
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :WhichKeyVisual '<Space>'<CR>

autocmd FileType which_key highlight WhichKey ctermbg=17 ctermfg=7
autocmd FileType which_key highlight WhichKeySeperator ctermbg=17 ctermfg=7
autocmd FileType which_key highlight WhichKeyGroup cterm=bold ctermbg=17 ctermfg=7
autocmd FileType which_key highlight WhichKeyDesc ctermbg=17 ctermfg=7
autocmd FileType which_key highlight WhichKeyFloating ctermbg=17 ctermfg=7
