" #### SECTION: AUTOPAIRS
" Vanilla Vim Autopairs
" Comment aware: Will only double in INSERT mode if not the first non space/tab char
" Warning: Will also NOT double a first non-comment character. Won't work with set paste option


" For quotes
inoremap <expr> " col('.') > 1 && getline('.')[0:col('.')-2] =~ '[^\s]' ? '""' : '"<C-o>:noh<CR>'
inoremap <expr> ' getline('.')[0:col('.')-2] =~ '[^\s]' ? "''" : "'<C-o>:noh<CR>" "No col1 fix
inoremap <expr> ` getline('.')[0:col('.')-2] =~ '[^\s]' ? '`' : '``<left><C-o>:noh<CR>'

" For brackets - this version doesn't check first column, nor if any content to left
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

" " For brackets - this version doesn't check first column, but does check if any content to left
" inoremap <expr> ( getline('.')[0:col('.')-2] =~ '\S' ? '()<C-g>U<Left>' : '('
" inoremap <expr> [ getline('.')[0:col('.')-2] =~ '\S' ? '[]<C-g>U<Left>' : '['
" inoremap <expr> { getline('.')[0:col('.')-2] =~ '\S' ? '{}<C-g>U<Left>' : '{'

" Auto multiline pair after (quick) <CR>
inoremap (<CR> (<CR><C-o>0)<ESC><<<ESC>O<TAB>
inoremap [<CR> [<CR>]<ESC><<<ESC>O<TAB>
inoremap {<CR> {<CR>}<ESC><<<ESC>O

" END - Vanilla Vim Autopairs

