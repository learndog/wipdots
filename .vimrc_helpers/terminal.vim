"Manual terminal functionality

"These keymaps work if the default profile is good (or add blurb below to call a profile conditionally)
nnoremap <Leader>t :term<CR>
nnoremap <Leader>th :term<CR>
nnoremap <Leader>tv :vsplit term<CR>
nnoremap <Leader>tt :tab term<CR>


" "Choose profile ['~/.profile' | 'default' ]
" let g:terminal_profile='~/.profile'
" " let g:terminal_profile='default'
" 
" if g:terminal_profile == '~/.profile'
"    " .profile keymaps
"    nnoremap <Leader>t :term bash --noprofile --rcfile ~/.profile<CR>
"    nnoremap <Leader>th :term bash --noprofile --rcfile ~/.profile<CR>
"    nnoremap <Leader>tv :vsplit term bash --noprofile --rcfile ~/.profile<CR>
"    nnoremap <Leader>tt :tab term bash --noprofile --rcfile ~/.profile<CR>
" else
"    nnoremap <Leader>t :term<CR>
"    nnoremap <Leader>th :term<CR>
"    nnoremap <Leader>tv :vsplit term<CR>
"    nnoremap <Leader>tt :tab term<CR>
" endif

"Notes
"  * You can control which file is sourced above, but you may have to do :bd after $ exit
"  * Alternatively, you can add the following lines to your .bashrc (or whichever default runs for a new vim term)
"       # Source .profile if in a Vim terminal
"       if [ "$VIM_TERMINAL" = "1" ]; then
"           [ -f ~/.profile ] && . ~/.profile
"       fi
"  * Or you could try something like this to close buffer after terminal windows are closed (untested)...
"       autocmd BufWinLeave term://* if getbufvar(bufnr('%', '&buftype' == 'terminal' && !bufexists(bufnr('%')) | exe
"       'bdelete!' | endif
"
