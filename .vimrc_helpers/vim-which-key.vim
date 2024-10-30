" Configure vim-which-key

" Set the timeout (default is 1000ms, ie 1 sec)
set timeoutlen=500

" highlight Normal ctermfg=grey ctermbg=darkblue
autocmd FileType which_key highlight WhichKey ctermbg=17 ctermfg=7
autocmd FileType which_key highlight WhichKeySeperator ctermbg=17 ctermfg=7
autocmd FileType which_key highlight WhichKeyGroup cterm=bold ctermbg=17 ctermfg=7
autocmd FileType which_key highlight WhichKeyDesc ctermbg=17 ctermfg=7
autocmd FileType which_key highlight WhichKeyFloating ctermbg=17 ctermfg=7

nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
