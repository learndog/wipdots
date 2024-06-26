" #### SECTION: GENERAL KEY MAPPINGS

" <ESC> from INSERT mode (use jj and/or jk)
" jj is more natural, but jk may be immediate
inoremap jj <ESC>
" Avoid jk to allow jiggling the cursor to close autocomplete dropdown
" inoremap jk <ESC>

" Command line
nnoremap ; :

" Jump past closing bracket or quote in NORMAL or INSERT mode (stay in same mode)
inoremap <expr> jl getline('.')[col('.')-1] =~ '[)"'']' && col('.') == col('$')-1 ? '<ESC>A' : '<ESC>%%a'
nnoremap jl %%l

" Jump to first character after left paren before cursor
inoremap <expr> jh getline('.')[col('.')-1] =~ '[)"'']' && col('.') == col('$')-1 ? '<ESC>A' : '<ESC>F(l'
nnoremap jh F(l

" To replace the lost defeault <C-L> mapping
nnoremap <Leader>wr :redraw!<CR>

" Open a file (finish in command line). Maybe can use $(fzf)?
nnoremap <Leader>of :open .<CR>
" Save <Leader>f... for find


" #### SECTION: Move blocks around (and preserve selection)
vnoremap <C-UP> xkP`[V`]
vnoremap <C-DOWN> xp`[V`]
vnoremap <C-LEFT> <<`[V`]
vnoremap <C-RIGHT> >>`[V`]
" Alternative mappings in case these are intercepted by codeanywhere
vnoremap <leader><UP> xkP`[V`]
vnoremap <leader><DOWN> xp`[V`]
vnoremap <leader><LEFT> <<`[V`]
vnoremap <leader><RIGHT> >>`[V`]

" Note: Only <C-_> keymaps to upper/lower alphabet are reliable
"       Intent is to use <C-up/down> for other things in normal mode, but move lines in visual select.

" #### SECTION: Duplicate Inert Keymaps just to document
" TBD

" Enter visual block mode
" To type text in front of all lines in the block,
" Enter visual block mode with :Vb (or without the command defn, use <C-V>)
" Use arrows to highlight the lines to act on
" Shift-i to type the text to insert
" <ESC> to act on all the lines
command! Vb normal! <C-V>

" For which key to map in vim, see vimdoc.sourceforge.net/htmldoc/map.html#map-which-keys
" Detailed how to map keys in vim, see vim.fandom.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_1)
" Sample config... https://jay-baker.com/posts/vim-1-which-key/

" Note: in Visual Block mode, use V or vv to return to nonrmal mode.
"       But in visual mode (not block) SINGLE v
