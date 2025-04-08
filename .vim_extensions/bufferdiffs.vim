" #### SECTION: BUFFER DIFFS
" Diff with saved and git checked out version
" From https://vim.fandom.com/wiki/Diff_current_buffer_and_the_original_file
" To exit diff view, use :diffoff command
function! s:DiffWithGITCheckedOut()  " Only on Linux?
   let filetype=&ft
   diffthis
   vnew | exe "%!git diff " . fnameescape( expand("#:p") ) . "| patch -p 1 -Rs -o /dev/stdout"
   exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
   diffthis
endfunction
com! DiffGIT call s:DiffWithGITCheckedOut()

function! s:DiffWithSaved()
   let filetype=&ft
   diffthis
   vnew | r # | normal! 1Gdd
   diffthis
   exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

nnoremap <Leader>dg :DiffGIT<CR> 
nnoremap <Leader>ds :DiffSaved<CR>
