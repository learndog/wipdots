" Configure netrw

" Use Esc to exit netrw
autocmd FileType netrw nmap <silent> <buffer> <Esc> :bd<cr>

" Open netrw (first should open curr dir)
nnoremap <Leader>of :Explore<CR>
nnoremap <Leader>oe :Explore<CR>

" Set width of netrw windows (eg  for :Vexplore)
" let g:netrw_winsize=20

let g:netrw_liststyle=2 "changes the way the explorer tree looks options 0,1,2,3,4

