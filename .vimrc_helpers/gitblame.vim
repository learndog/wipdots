" #### SECTION: GitBlame
" Use command :Blame to get a split window with all lines of the code prefixed with the git blame
function! GitBlame()
   let l:filename = expand('%')
   let l:dirname = expand('%:p:h')
   let l:blame = system('cd ' . l:dirname . ' && git blame ' . l:filename)
"    let l:blame = system('cd ' . ' && git blame ' . l:filename)
   vnew
   setlocal buftype=nofile
   setlocal bufhidden=hide
   setlocal noswapfile
   call setline(1, split(l:blame, '\n'))
endfunction

command! Blame call GitBlame()
