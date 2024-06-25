" Beginnings and ends of line
function! ToggleZero()
   " Get the current cursor position
   let current_col = col('.')
   " Search for the first/last non-whitespace character on the current line
   let first_non_ws_col = match(getline('.'), '\S') + 1
   let last_non_ws_col = match(getline('.'), '\S\zs\s*$')
   " Get last col position on the current line
   let last_col_pos = col('$') -1
   " Move based on cursor location
   echo "current col: " . current_col . " last pos: " . last_col_pos
   if current_col == last_col_pos
      normal! 0
   elseif current_col == 1 && current_col != first_non_ws_col
      normal! ^
   elseif current_col == first_non_ws_col
      normal! g_
   elseif current_col == last_non_ws_col
      normal! $
   else
      normal! 0
   endif
endfunction
nnoremap <silent> 0 :call ToggleZero()<CR>
inoremap <silent> ;; <C-O>:call ToggleZero()<CR> 

