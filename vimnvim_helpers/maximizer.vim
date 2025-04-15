" #### SECTION: CONFIGURE MAXIMIZER
" :MaximizerToggle
" When the current window is not in maximized state, Vim-Maximizer saves dimensions and positions of all windows
" in the current tab, and then it performs maximization of the active window.
" The second time the command is invoked, Maximizer restores all windows to the previously saved positions.
" :MaximizerToggle!
" The bang version forces the restoration of previously saved state (if any).
" It can be used in case you did some changes in the maximized state layout
" and the current window is not maximized anymore.
" Despite that, the bang version force restoration anyway.

nnoremap <silent><Leader>m :MaximizerToggle!<CR>
vnoremap <silent><Leader>m :MaximizerToggle!<CR>gv
" Dont do this because it interferes with typing
" inoremap <silent><Leader>m <C-o>:MaximizerToggle!<CR>

"let g:maximizer_restore_on_winleave = 0
let g:maximizer_set_mapping_with_bang = 1
let g:maximizer_set_default_mapping = 1
let g:maximizer_default_mapping_key = '<F3>'

" ====END WINDOW MAXIMIZER =================================="
