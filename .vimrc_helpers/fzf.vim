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
