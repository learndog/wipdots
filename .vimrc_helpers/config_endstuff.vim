" #### SECTION: End of config cleanup 
" All the stuff that doesn't work unless it's at the end
set shortmess-=S               " show the current match position (Wont work at top of file)

set colorcolumn=+1             " Automatic highlighting char in col 81
highlight ColorColumn ctermbg=darkgrey guibg=lightgrey
" TODO: Add toggle for color column

" Reset the <C-hjkl|arrow> mappings as safety measure
nnoremap <S-LEFT> B
nnoremap <S-RIGHT> W
nnoremap <S-DOWN> <C-f>
nnoremap <S-UP> <C-b>
"nnoremap <S-H> B
"nnoremap <S-L> W
" nnoremap <S-J> <C-f>
" nnoremap <S-K> <C-b> "NO!!!! This is hover
" Match to <S-...> list for cross-platform compatibility
nnoremap <C-h> B
nnoremap <C-l> W
nnoremap <C-j> <C-f> 
nnoremap <C-k> <C-b> 
nnoremap <C-LEFT> B
nnoremap <C-RIGHT> W
nnoremap <C-DOWN> <C-f>
nnoremap <C-UP> <C-b>

