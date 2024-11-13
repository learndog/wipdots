" #### SECTION: GENERAL KEY MAPPINGS

" <ESC> from INSERT mode (use jj and/or jk)
" jj is more natural, but jk may be immediate
inoremap jj <ESC>h
inoremap jk <ESC>h
" Avoid jk to allow jiggling the cursor to close autocomplete dropdown
" inoremap jk <ESC>

" Command line
nnoremap ; :

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: jh and jl will end up to the right of the previous or following quote or bracket
"       Vim will look for an opening bracket or quote, or a closing bracket or quote
"       One odd behaviour will be cursor after closing quote because open and close is the same
"       So if asdf"fasdfasdf"|asdfasdfa, then backward will not move. Forward will look for next one.
"       Not sure yet if backward should look for another open quote also. Might cause unwanted moves.
" Function to skip backward in normal mode to just after the first opening character to the left
function! s:SkipBackwardToOpening()
  " Get the current line
  let l:line = getline('.')
  " Get the current cursor column (1-based index)
  let l:col = col('.')
  " Special case: check for double quotes or single quotes just before the cursor
  if l:col > 2
    let l:char_before = l:line[l:col - 2] " Character before the current cursor position
    let l:char_before_prev = l:line[l:col - 3] " Character two positions before the cursor
    if l:char_before == l:char_before_prev && l:char_before =~# '["'']'
      " If two identical quotes are found, move the cursor inside the quotes
      call cursor(line('.'), l:col - 1)
      return
    endif
  endif
  " Iterate backward from current column to find the first opening character
  while l:col > 1
    let l:col -= 1
    let l:char = l:line[l:col - 1] " Note: Vim index is 0-based, col() is 1-based
    " Check if the character is one of the specified opening characters
    if l:char =~# '[("''\["''{]'
      " Move cursor to just after the found opening character
      call cursor(line('.'), l:col + 1)
      return
    endif
  endwhile
endfunction
" Function to skip forward to just after the first closing character to the right
function! s:SkipForwardPastClosing()
  " Get the current line
  let l:line = getline('.')
  " Get the current cursor column (1-based index)
  let l:col = col('.')
  " Get the length of the line
  let l:line_length = len(l:line)
  " Iterate forward from current column to find the first closing character
  while l:col <= l:line_length
    let l:char = l:line[l:col - 1] " Note: Vim index is 0-based, col() is 1-based
    " Check if the character is one of the specified closing characters
    if l:char =~# '[)"''\]"''}]'
      " Move cursor to just after the found closing character
      call cursor(line('.'), l:col + 1)
      return
    endif
    " Move to the next column
    let l:col += 1
  endwhile
endfunction
nnoremap <silent> jl :call <SID>SkipForwardPastClosing()<CR>
nnoremap <silent> jh :call <SID>SkipBackwardToOpening()<CR>
inoremap <silent> jl <C-o>:call <SID>SkipForwardPastClosing()<CR>
inoremap <silent> jh <C-o>:call <SID>SkipBackwardToOpening()<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" " Jump past closing bracket or quote in NORMAL or INSERT mode (stay in same mode)
" inoremap <expr> jl getline('.')[col('.')-1] =~ '[)"'']' && col('.') == col('$')-1 ? '<ESC>A' : '<ESC>%%a'
" nnoremap jl %%l
" 
" " Jump to first character after left paren before cursor
" inoremap <expr> jh getline('.')[col('.')-1] =~ '[)"'']' && col('.') == col('$')-1 ? '<ESC>A' : '<ESC>F(li<C-o>i'
" nnoremap jh F(l
 
" To replace the lost defeault <C-L> mapping
nnoremap <Leader>wr :redraw!<CR>

" " Use cap word motions for reverse direction - probably not a good idea to overwrite builtin, but might be convenient
" nnoremap W b
" nnoremap B w

" Non-yanking deletes (preserves the yank buffer)
nnoremap <Del> "_x
inoremap <Del> <C-o>"_x

" Jump list navigation - But what will it do in other modes?
nnoremap <Leader>i <C-i>
nnoremap <Leader>o <C-o>

" Make screen viewport shifts bigger
nnoremap zh 25zh
nnoremap zl 25zl

" Map cut paste keystrokes safely
" nnoremap <C-s>:w<CR> "Mapping broken - Doesn't seem to work - due to JupyterLab term?

" #### SECTION: Move blocks around (and preserve selection)

" Simple version to keep visual mode after indent
vnoremap > >gv
vnoremap < <gv
vnoremap <leader><RIGHT> >gv
vnoremap <leader><LEFT> <gv
vnoremap <leader><UP> xkP`[V`]
vnoremap <leader><DOWN> xp`[V`]


" vnoremap <C-UP> xkP`[V`]
" vnoremap <C-DOWN> xp`[V`]
" vnoremap <C-LEFT> <<`[V`]
" vnoremap <C-RIGHT> >>`[V`]
" Alternative mappings in case these are intercepted by codeanywhere
" vnoremap <leader><UP> xkP`[V`]
" vnoremap <leader><DOWN> xp`[V`]
" vnoremap <leader><LEFT> <<`[V`]
" vnoremap <leader><RIGHT> >>`[V`]

" Vimdiff keymaps for git merge
nnoremap <Leader>Dr :diffget REMOTE<CR>
nnoremap <Leader>Db :diffget BASE<CR>
nnoremap <Leader>Dl :diffget LOCAL<CR>

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
