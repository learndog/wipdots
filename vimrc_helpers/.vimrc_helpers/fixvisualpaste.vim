" ### SECTION: FIX PASTE CLIPBOARD
" This supports "rp that replaces the selection by the contents of @r
" stackoverflow.com/questions/290465/how-to-paste-over-without-overwriting-register/290723#290723
" and stackoverflow.com/questions/290465/how-to-paste-over-without-overwriting-register/4446608#4446608
function! s:Repl()
   let s:restore_reg = @"
   return "p@=RestoreRegister()\<cr>"
endfunction
function! RestoreRegister()
   let @" = s:restore_reg
   if &clipboard == "unnamed"
      let @* = s:restore_reg
   elseif &clipboard == "unnamedplus"
      let @+ = s:restore_reg
   endif
   return ''
endfunction
vnoremap <silent> <expr> p <sid>Repl()

