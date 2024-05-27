" #### coc.nvim configuration
" #### Dependencies: node 14.14
set nocompatible
filetype plugin indent on
syntax on
set hidden

" Install the coc-jedi and coc-pyright extensions
"let g:coc_global_extensions = ['coc-jedi', 'coc-pyright']
let g:coc_global_extensions = ['coc-pyright']

" Use <Leader>ls instead. Conflicts with fuzzy search (within lines)
" nnoremap <C-s> :CocList symbols<CR>
" Use <leader>lr instead. Conflicts with Redo.
" nnoremap <C-r> :CocList references<CR>

let g:coc_user_config = {
         \ "python.linting.enabled": 1,
         \ }
" Alternate configs...
"      \ "python.formatting.provider": "autopep8",
"      \ "coc.preferences.codeLens.enable": 1,
"      \ "python.jediEnabled": 1,
"      \ "python.codelens.enabled": 1,
"   \ "coc.preferences.maxHeight": 30
"   \ "pyright.enable": 1,
"   \ "jedi.diagnostics.enable": 1,
"   \ "jedi.diagnostics.didOpen": 1,
"   \ "jedi.diagnostics.didChange": 1,
"   \ "jedi.diagnostics.didSave": 1


" BEGIN - KEYMAPS FOR LSP

" coc.nvim navigation commands
nnoremap <F4> :CocPrev<CR>
nnoremap <F5> :CocNext<CR>
nnoremap <F6> :CocFirst<CR>
nnoremap <F7> :CocLast<CR>
nnoremap <leader>j :CocNext<CR>
nnoremap <leader>k :CocPrev<CR>
" coc.nvim go-to commands DELETE THESE???
" nnoremap <Leader>gd :CocDefinition<CR>
" nnoremap <Leader>gi :CocImplementation<CR>
" nnoremap <Leader>gt :CocTypeDefinition<CR>
" nnoremap <Leader>fr :CocReferences<CR>
" nnoremap <Leader>hh :CocHover<CR>
" nnoremap <Leader>ar :CocRename<CR>
" coc.nvim code actions
" nnoremap <Leader>ca :CocAction<CR>

noremap <leader>ld :call CocAction('jumpDefinition')<CR>
nnoremap <leader>lr :call CocAction('jumpReferences')<CR>
nnoremap <leader>lc :call CocAction('references')<CR>
nnoremap <leader>ln :call CocAction('rename')<CR>
nnoremap <leader>la :call CocAction('codeAction')<CR>
nnoremap <leader>lf :call CocAction('format')<CR>
nnoremap <leader>lI :call CocAction('showOutgoingCalls')<CR>
nnoremap <silent><nowait> <space>ll  :<C-u>CocList outline<cr>
nnoremap <leader>li :call CocAction('showIncomingCalls')<CR>
nnoremap <leader>ly :call CocAction('runCommand', 'editor.action.organizeImport')<CR>


" Define a custom command :Format
command! Format call CocAction('format')

" Add `:Format` command to format current buffer
" command! -nargs=0 Format :call CocActionAsync('format')
" nmap <leader>f :Format<CR>

" END - KEYMAPS FOR LSP
" ################ END COC SETUP LINES
