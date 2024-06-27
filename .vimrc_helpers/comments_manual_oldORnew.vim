" #### SECTION: COMMENTING

" BEGIN - Comment without plugin - visual and normal mode - toggle comments with <Ctrl-/> or <Leader-/>
" This version also unhighlights after <Leader>// and keeps the visual selection after toggling comments
" Instructions...
" Pressing <Ctrl-/>, <Ctrl-Shift-/>, or <Leader>/ will toggle the comment state of lines,
" while pressing <Leader>// will always comment lines

function! ConditionalCommentUncomment(start, end)
   " Check the first non-space/non-tab character of the first line of the visual selection
   let firstChar = matchstr(getline(a:start), '^\s*\zs.')
   if firstChar == b:comment_symbol[0]
      " Uncomment action
      silent execute a:start.','.a:end.'s#^\(\s*\)' . escape(b:comment_symbol, '#') . '\s\?#\1#'
   else
      " Comment action
      silent execute a:start.','.a:end.'s#^#'.escape(b:comment_symbol, '#').' #'
   endif
endfunction


" function! ConditionalCommentUncomment(start, end)
"    " Check the first non-space/non-tab character of the first line of the visual selection
"    let firstChar = matchstr(getline(a:start), '^\s*\zs.')
"    if firstChar == b:comment_symbol[0]
"       " Uncomment action
"       silent execute a:start.','.a:end.'s#^\(\s*\)' . b:comment_symbol . '\s\?#\1#'
"    else
"       " Comment action
"       silent execute a:start.','.a:end.'s#^#'.b:comment_symbol.' #'
"    endif
" endfunction

function! VisualCommentUncomment()
   " Save the current visual selection
   let saved_reg = @@
   normal! gv"ay

   " Call the ConditionalCommentUncomment function on the visual selection
   call ConditionalCommentUncomment(line("'<"), line("'>"))

   " Restore the visual selection
   let @@ = saved_reg
   normal! gv

   " Clear search highlighting
   nohlsearch
endfunction

function! VisualComment()
   " Save the current visual selection
   let saved_reg = @@
   normal! gv"ay

   " Comment the visual selection
   silent execute ":'<,'>s#^#".b:comment_symbol." #"

   " Restore the visual selection
   let @@ = saved_reg
   normal! gv

   " Clear search highlighting
   nohlsearch
endfunction

augroup visual_commenting
   autocmd!
   autocmd FileType c,cpp,java,rust  let b:comment_symbol = '//'
   autocmd FileType vim              let b:comment_symbol = '"'
   autocmd FileType python,sh,yaml   let b:comment_symbol = '#'
   autocmd FileType sql              let b:comment_symbol = '--'
   autocmd FileType tex              let b:comment_symbol = '%'
   autocmd BufEnter * silent! vnoremap <silent> <C-_> :<C-u>call VisualCommentUncomment()<CR>
   autocmd BufEnter * silent! nnoremap <silent> <C-_> :call ConditionalCommentUncomment(line('.'), line('.'))<CR>
   "     autocmd BufEnter * silent! vnoremap <silent> <C-?> :<C-u>call VisualCommentUncomment()<CR>
   "     autocmd BufEnter * silent! nnoremap <silent> <C-?> :call ConditionalCommentUncomment(line('.'), line('.'))<CR>
   autocmd BufEnter * silent! vnoremap <silent> <Leader>/ :<C-u>call VisualCommentUncomment()<CR>
   autocmd BufEnter * silent! nnoremap <silent> <Leader>/ :call ConditionalCommentUncomment(line('.'), line('.'))<CR>
   autocmd BufEnter * silent! vnoremap <silent> <Leader>// :<C-u>call VisualComment()<CR>
   autocmd BufEnter * silent! nnoremap <silent> <Leader>// :s/^/\=b:comment_symbol . ' '/<CR>:nohlsearch<CR>
augroup END

