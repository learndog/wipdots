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
         \ "python.linting.pylintEnabled": 1,
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Function to select symbols of given kind
"
function! CocShowFilteredSymbols(kind)
    " Get document symbols using CocAction
    let l:symbols = CocAction('documentSymbols')

    " Check if the result is null or not a list
    if type(l:symbols) != type([]) || l:symbols == v:null
        echo "No symbols found in the current document"
        return
    endif

    " Filter symbols based on the kind provided (e.g., 'Function', 'Variable', 'Class')
    let l:filtered_symbols = filter(l:symbols, {_, v -> has_key(v, 'kind') && v.kind == a:kind})

    " If there are no symbols of the specified kind, display a message
    if empty(l:filtered_symbols)
        echo "No symbols of the specified kind found"
        return
    endif

    " Create a new scratch buffer for filtered symbols
    new
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal noswapfile

    " Populate the new buffer with filtered symbols
    for l:symbol in l:filtered_symbols
        " Extract the required information
        if has_key(l:symbol, 'range') && has_key(l:symbol, 'text')
            let l:line = l:symbol.range.start.line + 1
            let l:col = l:symbol.range.start.character + 1
            let l:text = l:symbol.text
            call append('$', printf('Line %d, Col %d: %s', l:line, l:col, l:text))
        else
            echo "Skipping symbol due to missing keys"
        endif
    endfor

    " Move cursor to the top
    normal! gg

    " Allow jumping to symbol locations when pressing Enter on a line
    nnoremap <buffer> <CR> :call CocJumpToSymbol()<CR>
endfunction

function! CocJumpToSymbol()
    " Get the line under the cursor
    let l:line = getline('.')

    " Extract the line number and column number from the line
    let l:parts = matchlist(l:line, 'Line \(\d\+\), Col \(\d\+\):')
    if len(l:parts) < 3
        echo "Invalid line format"
        return
    endif
    let l:lnum = str2nr(l:parts[1])
    let l:col = str2nr(l:parts[2])

    " Jump to the specified location
    execute l:lnum
    execute 'normal!' l:col . '|'
endfunction

nnoremap <Leader>loo :call CocShowFilteredSymbols('Function')<CR> " Functions
nnoremap <Leader>lof :call CocShowFilteredSymbols('Function')<CR> " Functions
nnoremap <Leader>lov :call CocShowFilteredSymbols('Variable')<CR> " Variables
nnoremap <Leader>loc :call CocShowFilteredSymbols('Class')<CR>  " Classes
" List of some coc symbol values available for filtering
"    File
"    Module
"    Namespace
"    Package
"    Class
"    Method
"    Property
"    Field
"    Constructor
"    Enum
"    Interface
"    Function
"    Variable
"    Constant
"    String
"    Number
"    Boolean
"    Array
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Deactivate coc-implementation (Not available for jedi, and conflicts with goto last insert pos)
"nmap <silent> gi <Plug>(coc-implementation)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Define a custom command :Format
command! Format call CocAction('format')
nnoremap <leader>lf :call CocAction('format')<CR>
" Add `:Format` command to format current buffer
" command! -nargs=0 Format :call CocActionAsync('format')
" nmap <leader>f :Format<CR>

" HOVER
" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

" Use CTRL-lrs for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-lrs> <Plug>(coc-range-select)
xmap <silent> <C-lrs> <Plug>(coc-range-select)

" Mappings for CoCList
" Manage extensions
nnoremap <silent><nowait> <Leader>le  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <Leader>lc  :<C-u>CocList commands<cr>
" Show all diagnostics
nnoremap <silent><nowait> <Leader>la  :<C-u>CocList diagnostics<cr>
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nnoremap <F4> :CocFirst<CR>
nnoremap <F5> :CocPrev<CR>
nnoremap <F6> :CocNext<CR>
nnoremap <F7> :CocLast<CR>

" SEARCH SHOW PICK GOTO
" Find symbol of current document
" nnoremap <silent><nowait> <Leader>lo  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <Leader>lo  :CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <Leader>ls  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <Leader>lj  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <Leader>lk  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <Leader>lp  :<C-u>CocListResume<CR>

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

noremap <leader>ld :call CocAction('jumpDefinition')<CR>
nnoremap <leader>lr :call CocAction('jumpReferences')<CR>
nnoremap <leader>ln :call CocActionAsync('rename')<CR>
nnoremap <leader>la :call CocAction('codeAction')<CR>
nnoremap <leader>li :call CocAction('showIncomingCalls')<CR>
nnoremap gi :call CocAction('showIncomingCalls')<CR>
nnoremap <leader>lI :call CocAction('showOutgoingCalls')<CR>
nnoremap go :call CocAction('showOutgoingCalls')<CR>
nnoremap <silent><nowait> <Leader>ll  :<C-u>CocList outline<cr>
nnoremap <leader>ly :call CocAction('runCommand', 'editor.action.organizeImport')<CR>

"Note: <Plug>(coc-rename) causes timeout because not async

" ACTIONS

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>la  <Plug>(coc-codeaction-selected)
nmap <leader>la  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>lac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>las  <Plug>(coc-codeaction-source)

" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>lqf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>lre <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>lr  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>lr  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>lcl  <Plug>(coc-codelens-action)


" Nvim commands - delete these?
" nnoremap <Leader>gd :CocDefinition<CR>
" nnoremap <Leader>gi :CocImplementation<CR>
" nnoremap <Leader>gt :CocTypeDefinition<CR>
" nnoremap <Leader>fr :CocReferences<CR>
" nnoremap <Leader>hh :CocHover<CR>
" nnoremap <Leader>ar :CocRename<CR>
" coc.nvim code actions
" nnoremap <Leader>ca :CocAction<CR>

" END - KEYMAPS FOR LSP
" ################ END COC SETUP LINES
