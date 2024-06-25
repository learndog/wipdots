" #### SECTION: Line Number Cycling
function! CycleLineNumbers()
   if &number && &relativenumber
      set nonumber norelativenumber
   elseif &number
      set relativenumber
   elseif &relativenumber
      set nonumber norelativenumber
   else
      set number
   endif
endfunction
nnoremap <F8> :call CycleLineNumbers()<CR>
nnoremap <Leader>n :call CycleLineNumbers()<CR>
