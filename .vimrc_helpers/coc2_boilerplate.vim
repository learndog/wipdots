" #### SECTION: COC BOILER SETUP (neoclide/coc.nvim)

" Use tab for trigger completion
inoremap <silent><expr> <TAB>
         \ coc#pum#visible() ? coc#pum#next(1) :
         \ CheckBackspace() ? "\<Tab>" :
         \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" CR to accept selected completion (but <C-g>u breaks current undo)
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
         \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Suggested by coc.nvim
function! CheckBackspace() abort
   let col = col('.') - 1
   return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
   inoremap <silent><expr> <c-space> coc#refresh()
else
   inoremap <silent><expr> <c-@> coc#refresh()
endif

function! ShowDocumentation()
   if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
   else
      call feedkeys('K', 'in')
   endif
endfunction

augroup mygroup
   autocmd!
   " Setup formatexpr specified filetype(s)
   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
   " Update signature help on jump placeholder
   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Highlight the symbol and its references when holding the cursor (eg user not typing)
autocmd CursorHold * silent! call CocActionAsync('highlight')

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<RIGHT>"
   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<LEFT>"
   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif




" END CONFIG FROM neoclide/coc.nvim

