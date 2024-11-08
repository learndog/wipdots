" Various vim admin functions
"
" #### SECTION: Save and restore sessions

" WARNING - THIS IS BROKEN FOR NVIM AND CAN CORRUP SAVED SESSIONS 

" "Make sure nvim uses the same session directory
" if has('nvim')
"   let $VIMSESSION = g:session_directory
" endif

" Define the session directory paths (Should includ a trailing slash)
let g:vim_session_directory = expand('~/.vim/sessions/')
let g:nvim_session_directory = expand('~/.config/nvim/sessions/')

" Set the session directory based on the editor
if has('nvim')
  let g:session_directory = g:nvim_session_directory
else
  let g:session_directory = g:vim_session_directory
endif

" Create the sessions directory if it doesn't exist
if !isdirectory(g:session_directory)
  call mkdir(g:session_directory, 'p')
endif

" if !isdirectory(expand("~/.vim/sessions"))
"    call mkdir(expand("~/.vim/sessions"), "p")
" endif

" Function to save the current session
function! SessionSave()

  " List existing session files
  let l:session_files = split(globpath(g:session_directory, '*.save'), "\n")
  if !empty(l:session_files)
    " Alphabetize the session file names
    call sort(l:session_files)

    echo "Existing sessions:"
    for file in l:session_files
      echo '  ' . fnamemodify(file, ':t:r')
    endfor
  else
    echo "No existing sessions."
  endif

   " Ask the user for a session name
   let l:session_name = input("Enter session name: ")
   " Check if the session file already exists
   if filereadable(g:session_directory . l:session_name . ".save")
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
   execute "mksession! " . g:session_directory . l:session_name . ".save"
endfunction

" Function to restore a saved session
function! SessionRestore()
   " Get a list of session files
   let l:session_files = split(glob(g:session_directory . '/*.save'), "\n")
"    let l:session_files = glob(g:session_directory, 0, 1)
   " Extract the session names from the session files
   let l:session_names = map(l:session_files, 'fnamemodify(v:val, ":t:r")')
   " Create a numbered list of session names
   let l:session_list = map(copy(l:session_names), '(v:key + 1) . ". " . v:val')
   " Ask the user to select a session name
   let l:index = inputlist(["Select a session:"] + l:session_list)
   " Check if a valid session name was selected
   if l:index > 0 && l:index <= len(l:session_names)
      " Load the selected session file
      execute "source " . g:session_directory . l:session_files[l:index - 1] . '.save'
   endif
endfunction

" Fix <C-r> mapping (Coc overwrites this, maybe because one config setting can lose redo chain?)
nnoremap <C-r> :redo<CR>

" Map keys to save and restore sessions (vim..config..save/restore)
nnoremap <leader>vss :call SessionSave()<CR>
nnoremap <leader>vsr :call SessionRestore()<CR>

" Map key for reload vimrc into current session (vim..config..restore/edit)
" nnoremap <Leader>vcr :source $MYVIMRC<CR>
nnoremap <Leader>vcr :source $MYVIMRC \| nohlsearch<CR>
nnoremap <leader>vce :edit $MYVIMRC<CR>
nnoremap <leader>vcv :view $MYVIMRC<CR>

" Show help files as read only

" Assumes that files are located in $HOME/wipdots/
nnoremap <Leader>vhh :execute 'view ' . expand('$HOME') . '/wipdots/vim/basic_usage.md'<CR>
nnoremap <Leader>vhk :execute 'view ' . expand('$HOME') . '/wipdots/vim/keymap_overview.txt'<CR>
nnoremap <Leader>vhs :execute 'view ' . expand('$HOME') . '/wipdots/vim/setup.md'<CR>
nnoremap <Leader>vht :execute 'view ' . expand('$HOME') . '/wipdots/vim/todo.txt'<CR>

" And also offer options to edit them with Leader-ve*
nnoremap <Leader>veh :execute 'edit ' . expand('$HOME') . '/wipdots/vim/basic_usage.md'<CR>
nnoremap <Leader>vek :execute 'edit ' . expand('$HOME') . '/wipdots/vim/keymap_overview.txt'<CR>
nnoremap <Leader>ves :execute 'edit ' . expand('$HOME') . '/wipdots/vim/setup.md'<CR>
nnoremap <Leader>vet :execute 'edit ' . expand('$HOME') . '/wipdots/vim/todo.txt'<CR>

" " Assumes that files are located in $HOME/wipdots/
" nnoremap <Leader>vhh :view $HOME/wipdots/vim/basic_usage.md<CR>
" nnoremap <Leader>vhk :view $HOME/wipdots/vim/keymap_overview.txt<CR>
" nnoremap <Leader>vhs :view $HOME/wipdots/vim/setup.md<CR>
" nnoremap <Leader>vht :view $HOME/wipdots/vim/todo.txt<CR>
" 
" " And also offer options to edit them with Leader-ve*
" nnoremap <Leader>veh :edit $HOME/wipdots/vim/basic_usage.md<CR>
" nnoremap <Leader>vek :edit $HOME/wipdots/vim/keymap_overview.txt<CR>
" nnoremap <Leader>ves :edit $HOME/wipdots/vim/setup.md<CR>
" nnoremap <Leader>vet :edit $HOME/wipdots/vim/todo.txt<CR>



