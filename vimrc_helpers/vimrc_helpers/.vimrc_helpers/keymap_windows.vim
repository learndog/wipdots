" #### SECTION: WINDOWS
" WARN: Some term emulators can distinguish Ctrl-shift, but not all.
"       So place <C-S- > mappings before the non-shift equivalent is mapped.

" Resize as increase or decrease - needs repeatable keystroke. Keep this before <C-hjkl>!
nnoremap <M-LEFT>  :vertical resize -10<CR>
nnoremap <M-RIGHT> :vertical resize +10<CR>
nnoremap <M-UP>    :resize +5<CR>
nnoremap <M-DOWN>  :resize -5<CR>

" Move to Window - Redundant but explicit
nnoremap <C-w><LEFT> <C-w><LEFT>
nnoremap <C-w><DOWN> <C-w><DOWN>
nnoremap <C-w><UP> <C-w><UP>
nnoremap <C-w><RIGHT> <C-w><RIGHT>
nnoremap <C-w>h <C-w>h
nnoremap <C-w>j <C-w>j
nnoremap <C-w>k <C-w>k
nnoremap <C-w>l <C-w>l

" Split to specified direction 
nnoremap <C-w>hh :vertical topleft split<CR>
nnoremap <C-w>jj :vertical belowright split<CR>
nnoremap <C-w>kk :belowright split<CR>
nnoremap <C-w>ll :topleft split<CR>

nnoremap <Leader>wh :vertical topleft split<CR>
nnoremap <Leader>wj :vertical belowright split<CR>
nnoremap <Leader>wk :belowright split<CR>
nnoremap <Leader>wl :topleft split<CR>

" Close the last window
nnoremap <Leader>wc :close<CR>

" Keep only the active window open
nnoremap <Leader>wo :only<CR>

" Close preview window (eg after Hover)
nnoremap <Leader>lcp :pclose<CR>

noremap <C-w><C-w> <C-w><C-w>

