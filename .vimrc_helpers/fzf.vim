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
  try
    " Save current window layout
    let save_win_view = winsaveview()
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

    " Extract keybinding lines
    let keybind_lines = []
    let in_section = 0

    " Iterate over help_lines with index
    let idx = 0
    while idx < len(help_lines)
      let line = help_lines[idx]
      " Output the current line for debugging
"       echom 'Line ' . (idx + 1) . ': ' . line

      " Check for the start of the keybindings section
      if line =~# '^tag\s\+char\s\+note\s\+action in Normal mode\s*\~$'
        " Check if the next line is a line of hyphens
        if idx + 1 < len(help_lines) && help_lines[idx + 1] =~# '^\-*$'
          let in_section = 1
          echom 'Entering keybindings section at line ' . (idx + 1)
          " Skip the hyphens line
          let idx += 2
          continue
        else
          echom 'Hyphens line not found after start marker at line ' . (idx + 2)
        endif
      endif

      " Check for the end of the keybindings section
      if in_section && line =~# '^\s*=*\s*$'
        if idx + 1 < len(help_lines) && help_lines[idx + 1] =~# '^\s*2\.1\s\+Text objects'
          let in_section = 0
          echom 'Exiting keybindings section at line ' . (idx + 1)
          break
        endif
      endif

      if in_section
        " Skip empty lines and separator lines
        if line =~# '^\s*$' || line =~# '^\-*$' || line =~# '^\s*=*\s*$'
          let idx += 1
          continue
        endif

        " Output the line being processed
"         echom 'Processing line: ' . line

        " Split the line into columns based on tabs
        let columns = split(line, '\t\+')

        " Ensure there are at least two columns
        if len(columns) < 2
"           echom 'Skipping line due to insufficient columns at line ' . (idx + 1)
          let idx += 1
          continue
        endif

        " Remove vertical bars '|' from columns[0] and columns[1]
        let columns[0] = substitute(columns[0], '[|]', '', 'g')
        let columns[1] = substitute(columns[1], '[|]', '', 'g')

        " Reconstruct the line
        let new_line = join(columns, '  ')

        " Add the line to the keybindings list
        call add(keybind_lines, new_line)
"         echom 'Added keybinding: ' . new_line
      endif

      let idx += 1
    endwhile

    if empty(keybind_lines)
      echoerr "Could not extract keybindings from help content."
      return
    endif

    " Output the total number of keybindings extracted
    echom 'Total keybindings extracted: ' . len(keybind_lines)

    " Sort the keybind_lines alphabetically
    call sort(keybind_lines)

    " Use fzf to display and filter the keybindings
    call fzf#run(fzf#wrap({
          \ 'source': keybind_lines,
          \ 'sink*': function('s:OpenHelpForKeybind'),
          \ 'options': '--exact --prompt="Normal Mode Keybind> "',
          \ 'placeholder': 'Type to filter keybindings...',
          \}))
  catch /.*/
    echoerr "An error occurred: " . v:exception
    echoerr "Error at line number: " . v:lnum
  endtry
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
" Find builtin normal mode keybinds (g and brackets and windows maps - see help index)
nnoremap <Leader>fmb :NormalModeKeybinds<CR>
nnoremap <Leader>fmh :help index<CR>

" Vim theme selection (from fzf, set colorscheme)
nnoremap <Leader>vt :Colors<CR>

" END - FUZZY FIND KEY MAPS
" ############# END FUZZY FIND SETUP (NON-LSP)
