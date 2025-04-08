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
   elseif current_col == last_non_ws_col || current_col == last_non_ws_col+1
      " The +1 is to cover the movement for insert mode cycles
      normal! $
   else
      normal! 0
   endif
endfunction

function! InsertOrAppend()
    stopinsert
    call ToggleZero()
    if col('.') == 1
        " First column
        startinsert
    elseif col('.') >= col('$')-1
        " Near or at last column, use 'A' to append correctly
        call feedkeys('A', 'n')
    elseif col('.') == match(getline('.'), '\S\zs\s*$')
        " Last non-whitespace column
        call feedkeys('a', 'n')
    else
        " Other positions
        startinsert
    endif
endfunction

lua << EOF
local helpers = require("lazy_config_helpers")
helpers.register_keymaps({
    { mode = "n", keys = ";;", command = ":call ToggleZero()<CR>", opts = { description = "Toggle line position" } },
    { mode = "n", keys = "0", command = ":call ToggleZero()<CR>", opts = { description = "Toggle line position" } },
    { mode = "i", keys = ";;", command = "<C-O>:call InsertOrAppend()<CR>", opts = { description = "Insert Or Append" } },
})
EOF


" NOTE: These functions can be simplified by combining them, and adding an argument for i or n (supplied by the keymap)
