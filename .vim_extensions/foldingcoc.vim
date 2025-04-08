" BEGIN - COC FOLDING ONLY
" Add `:Fold` command to fold current buffer
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Coc language fold method exceptions
"    Not used because pyright coc combo doesn't seem to support it
" autocmd FileType python setlocal foldmethod=manual foldlevel=1 foldenable

" Note that these are the coc folding methods
"   They seem to be used, but it is not confirmed (eg should be dynamic not status when code lines are added)
"     :call CocAction('fold', 0)     " This opens all folds using coc lsp
"     :call CocAction('fold', 1)     " This closes all folds using coc lsp

" END - COC FOLDING ONLY
