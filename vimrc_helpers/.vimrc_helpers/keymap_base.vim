" #### SECTION: GENERAL KEY MAPPINGS

" <ESC> from INSERT mode (use jj and/or jk)
" jj is more natural, but jk may be immediate
inoremap jj <ESC>
" Avoid jk to allow jiggling the cursor to close autocomplete dropdown
" inoremap jk <ESC>

" Jump past closing bracket or quote in NORMAL or INSERT mode (stay in same mode)
inoremap jl <ESC>%%a
nnoremap jl %%l

" To replace the lost defeault <C-L> mapping
nnoremap <Leader>wr :redraw!<CR>

" Open a file (finish in command line). Maybe can use $(fzf)?
nnoremap <Leader>of :open .<CR>
" Save <Leader>f... for find things?

" #### SECTION: Duplicate Inert Keymaps just to document
" TBD

" Enter visual block mode
" To type text in front of all lines in the block,
" Enter visual block mode with :Vb
" Use arrows to highlight the lines to act on
" Shift-i to type the text to insert
" <ESC> to act on all the lines
command! Vb normal! <C-V>



" For which key to map in vim, see vimdoc.sourceforge.net/htmldoc/map.html#map-which-keys
" Detailed how to map keys in vim, see vim.fandom.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_1)
"

