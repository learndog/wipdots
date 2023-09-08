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
" " Keymaps for fuzzy searches
nnoremap <C-p> :Files<CR>
nnoremap <C-s> :BLines<CR>

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

" Map <leader>fm to call LiteralFindKeyMappings or FuzzyFindKeyMappings
nnoremap <leader>fm :call LiteralFindKeyMappings()<CR>
"nnoremap <leader>fm :call FuzzyFindKeyMappings()<CR>

" END - FUZZY FIND KEY MAPS
" ############# END FUZZY FIND SETUP (NON-LSP)
