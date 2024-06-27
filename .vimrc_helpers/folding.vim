" #### BEGIN - CODE FOLDING (vanilla)
set foldlevelstart=99
highlight Folded guifg=white guibg=grey30 ctermfg=white ctermbg=lightgrey
autocmd FileType python setlocal foldmethod=indent
" END - CODE FOLDING (vanilla)

" #### BEGIN - CUSTOM CODE FOLDING FEATURES
function! SafeToggleFold()
   " Check if the current line is foldable
   if foldlevel('.') == 0
      " Toggle fold if foldable
      normal! za
   endif
endfunction
"nnoremap <Space> :call SafeToggleFold()<CR>

" Toggle folds

function! ToggleAllFolds()
   " Initialize variable to false
   let l:hasClosedFold = 0

   " Loop through each line in the buffer
   for l:line in range(1, line('$'))
      if foldclosed(l:line) != -1
         " Found a closed fold
         let l:hasClosedFold = 1
         break
      endif
   endfor

   if l:hasClosedFold
      " Open all folds
      normal! zR
      echo "All folds have been opened"
   else
      " Close all folds
      normal! zM
      echo "All folds have been closed"
   endif
endfunction

nnoremap <Leader>z :call ToggleAllFolds()<CR>

" Fold everything below the specified level

function! SafeFoldToLevel(...)
   " Determine the context: normal mode vs command-line mode
   if a:0 == 0
      " Normal mode: get the next character
      let l:level = nr2char(getchar())
   else
      " Command-line mode: use the provided argument
      let l:level = a:1
   endif

   " Ensure the input is numeric and between 0 to 9
   if l:level =~ '^[0-9]$'
      execute 'set foldlevel=' . l:level
      echo "Fold level set to " . l:level
   else
      echo "Invalid fold level: " . l:level . ". Acceptable values are 0 to 9."
   endif
endfunction

" Normal mode mapping
"nnoremap zl :call SafeFoldToLevel()<CR>

" Command-line mode mapping
command! -nargs=* Z call SafeFoldToLevel(<f-args>) " Set fold level (0-9)

" Universal folding behavior
set foldmethod=indent

" Note: z0-z9 are available to be mapped (but calls to SafeFold didnt work)

" Use 'zR' to open all folds and 'zM' to close all folds
" END - CUSTOM CODE FOLDING FEATURES
