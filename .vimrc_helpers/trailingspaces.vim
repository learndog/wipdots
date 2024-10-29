" Remove all the trailing spaces in a file

" With vim search replace
" nnoremap <silent> <Leader>lt :%s\+$//e<CR>

" With vim search and a command for visibility in which key
command! RmTrailSp :%s/\s\+$//e
nnoremap <silent> <Leader>lt :RmTrailSp<CR>

" Using bash command (Not yet tested)
"nnoremap <silent> <Leader>lt :w !sed -i 's/[[:space:]]\+$//' %<CR>:e<CR>


