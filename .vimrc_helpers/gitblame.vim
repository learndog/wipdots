" #### SECTION: GitBlame
" Use command :Blame to get a split window with all lines of the code prefixed with the git blame
function! GitBlame()
  let l:filename = resolve(expand('%:p'))
  let l:blame = system('git -C ' . fnameescape(fnamemodify(l:filename, ':h')) . ' blame ' . fnameescape(l:filename))
  vnew
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  call setline(1, split(l:blame, '\n'))
endfunction
command! Blame call GitBlame()

