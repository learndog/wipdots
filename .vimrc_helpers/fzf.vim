" #### SECTION: FUZZY FIND NON-LSP SETUP

nnoremap <Leader>b :Buffer<CR>
nnoremap <Leader><space> :Buffer<CR>

" fzf, fzf.vim configuration
" NOTE: If delta is available, GF?, Commits and BCommits will use it to format git diff output.
let g:fzf_preview_command = 'bat --color "always" {}'
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
" fzf configuration #2
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.6 } }
" Set fzf to use bat for syntax highlighting
"let $FZF_DEFAULT_OPTS = '--preview "bat --color=always {}"'

" BEGIN - FUZZY FIND KEY MAPS
" First a function with a fuzzy finder
function! FuzzyFindKeyMappings()
   " Redirect the output of the :map command to a variable
   redir => mappings
   silent map
   redir END

   " Split the mappings into a list of lines
   let lines = split(mappings, '\n')

   " Use fzf#run to search through the list of lines
   call fzf#run({
            \ 'source': lines,
            \ 'sink': 'e',
            \ 'options': '--preview-window right:50%',
            \ 'down': '40%'
            \})
endfunction
" Now a function that does literal string searches for key maps
function! LiteralFindKeyMappings()
   " Redirect the output of the :map command to a variable
   redir => mappings
   silent map
   redir END

   " Split the mappings into a list of lines
   let lines = split(mappings, '\n')

   " Use fzf#run to search through the list of lines
   call fzf#run({
            \ 'source': lines,
            \ 'sink': 'e',
            \ 'options': '--exact --preview-window right:50%',
            \ 'down': '40%'
            \})
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fuzzy find built in keymaps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:NormalModeIndexFzf()
  " Save current window layout
  let save_win_view = winsaveview()
  try
    " Open the help for normal-index in a scratch buffer
    execute 'silent noswapfile keepjumps keepalt help normal-index'

    " Get the buffer number of the help buffer
    let help_bufnr = bufnr('%')

    " Get all lines from the help buffer
    let help_lines = getbufline(help_bufnr, 1, '$')

    " Close the help buffer
    execute 'bdelete! ' . help_bufnr

    " Restore the original window layout
    call winrestview(save_win_view)
  catch /E149/  " Catch "No help for normal-index" error
    echoerr "Could not open help for normal-index."
    return
  endtry

  " Extract keybinding lines
  let keybind_lines = []

  for line in help_lines
    " Skip empty lines
    if line =~# '^\s*$'
      continue
    endif

    " Skip separator lines
    if line =~# '^\s*[-=]\{3,\}\s*$'
      continue
    endif

    " Skip lines starting with specific non-keybinding words
    if line =~# '^\s*\(CHAR\|WORD\|N\|Nmove\|SECTION\|note:\|tag\)\>'
      continue
    endif

    " Split the line into columns based on at least two spaces
    let columns = split(line, '\s\{2,\}')

    " Ensure there are at least two columns
    if len(columns) < 2
      continue
    endif

    " The second column should not be empty
    if empty(columns[1])
      continue
    endif

    " Add the line to the keybindings list
    call add(keybind_lines, line)
  endfor

  if empty(keybind_lines)
    echoerr "Could not extract keybindings from help content."
    return
  endif

  " Use fzf to display and filter the keybindings
  call fzf#run(fzf#wrap({
        \ 'source': keybind_lines,
        \ 'sink*': function('s:OpenHelpForKeybind'),
        \ 'options': '--prompt="Normal Mode Keybind> "',
        \ 'placeholder': 'Type to filter keybindings...',
        \}))
endfunction

function! s:OpenHelpForKeybind(selected)
  for line in a:selected
    " Split the line into columns
    let columns = split(line, '\s\{2,\}')
    if len(columns) >= 2
      " Use the second column as the keybinding
      let keybind = columns[1]
      " Open the help page for the keybinding
      execute 'help' keybind
    endif
  endfor
endfunction

command! NormalModeKeybinds call s:NormalModeIndexFzf()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""






" ONLY IF FUGITIVE IS AVAILABLE
" Configure for :BCommits and :Commits
" let g:fzf_commits_log_options = '--graph --color=always
"   \ --format="%C(yellow)%h%C(red)%d%C(reset)
"   \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'


" " Keymaps for fuzzy searches
nnoremap <C-p> :Files<CR>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fg :GFiles<CR>

nnoremap <C-s> :BLines<CR>
nnoremap <Leader>fb :BLines<CR>

" Map <leader>fm to call LiteralFindKeyMappings or FuzzyFindKeyMappings
nnoremap <leader>fml :call LiteralFindKeyMappings()<CR>
nnoremap <leader>fmf :call FuzzyFindKeyMappings()<CR>

" Vim theme selection (from fzf, set colorscheme)
nnoremap <Leader>vt :Colors<CR>

" END - FUZZY FIND KEY MAPS
" ############# END FUZZY FIND SETUP (NON-LSP)
