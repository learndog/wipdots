" #### SECTION: Save and restore sessions

" Create the sessions directory if it doesn't exist
if !isdirectory(expand("~/.vim/sessions"))
   call mkdir(expand("~/.vim/sessions"), "p")
endif

" Function to save the current session
function! SessionSave()
   " Ask the user for a session name
   let l:session_name = input("Enter session name: ")
   " Check if the session file already exists
   if filereadable(expand("~/.vim/sessions/" . l:session_name . ".save"))
      " Ask the user for confirmation before overwriting the file
      echo "Session file already exists. Overwrite? (Y/N)"
      let l:choice = nr2char(getchar())
      while index(['Y', 'N'], l:choice) == -1
         echo "Please enter Y or N"
         let l:choice = nr2char(getchar())
      endwhile
      if l:choice == 'N'
         " User chose not to overwrite the file, so return without saving
         return
      endif
   endif
   " Save the session to a file
   execute "mksession! ~/.vim/sessions/" . l:session_name . ".save"
endfunction

" Function to restore a saved session
function! SessionRestore()
   " Get a list of session files
   let l:session_files = glob("~/.vim/sessions/*.save", 0, 1)
   " Extract the session names from the session files
   let l:session_names = map(l:session_files, 'fnamemodify(v:val, ":t:r")')
   " Create a numbered list of session names
   let l:session_list = map(copy(l:session_names), '(v:key + 1) . ". " . v:val')
   " Ask the user to select a session name
   let l:index = inputlist(["Select a session:"] + l:session_list)
   " Check if a valid session name was selected
   if l:index > 0 && l:index <= len(l:session_names)
      " Load the selected session file
      execute "source ~/.vim/sessions/" . l:session_files[l:index - 1] . '.save'
   endif
endfunction

" Fix <C-r> mapping (Coc overwrites this, maybe because one config setting can lose redo chain?)
nnoremap <C-r> :redo<CR>

" Map keys to save and restore sessions
nnoremap <leader>ss :call SessionSave()<CR>
nnoremap <leader>sr :call SessionRestore()<CR>

" Map key for reload vimrc into current session
nnoremap <Leader>vr :source $MYVIMRC<CR>
nnoremap <leader>ve :edit $MYVIMRC
