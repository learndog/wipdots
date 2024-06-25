" #### SECTION: AUTOPAIRS
" Vanilla Vim Autopairs
" Comment aware: Will only double in INSERT mode if not the first non space/tab char
" Warning: Will also NOT double a first non-comment character. Won't work with set paste option

" For quotes
inoremap <expr> " getline('.')[0:col('.')-2] =~ '[^\s]' ? '"' : '""<left><C-o>:noh<CR>'
inoremap <expr> ' getline('.')[0:col('.')-2] =~ '[^\s]' ? "'" : "''<left><C-o>:noh<CR>"
inoremap <expr> ` getline('.')[0:col('.')-2] =~ '[^\s]' ? '`' : '``<left><C-o>:noh<CR>'

" For brackets
inoremap <expr> ( getline('.')[0:col('.')-2] =~ '[^\s]' ? '(' : '()<left>'
inoremap <expr> [ getline('.')[0:col('.')-2] =~ '[^\s]' ? '[' : '[]<left>'
inoremap <expr> { getline('.')[0:col('.')-2] =~ '[^\s]' ? '{' : '{}<left>'

inoremap (<CR> (<CR>)<ESC><<<ESC>O<TAB>
inoremap [<CR> [<CR>]<ESC><<<ESC>O<TAB>
inoremap {<CR> {<CR>}<ESC><<<ESC>O

" END - Vanilla Vim Autopairs

