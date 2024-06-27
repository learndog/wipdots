" Toggle search highlighting (use :noh for current search only)
let g:highlighting = 1
function! ToggleHighlighting()
   if g:highlighting
      set nohlsearch
      let g:highlighting = 0
   else
      set hlsearch
      let g:highlighting = 1
   endif
endfunction
nnoremap <Leader>h :call ToggleHighlighting()<CR>

