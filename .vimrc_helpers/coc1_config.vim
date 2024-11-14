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
         \ "python.linting.lintOnSave": 1,
         \ "python.formatting.provider": "black",
         \ "python.formatting.blackPath": "black",
         \ "python.formatting.blackArgs": ["--line-length","100"],
         \ }
"          \ "coc.preferences.formatOnSaveFiletypes": ["python"]
" jedi by default is used bfor completion and type checking, but pyright should be able to do it.
"          \ "python.jediEnabled": 0,
" coc uses autopep8 by default for fomatting
"          \ "python.formatting.autopep8Path": "autopep8",
"          \ "python.formatting.provider": "autopep8",
" Alternate configs... (this syntax does not work)
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
" Turn on/off Python format on save
command! DisablePythonFormat let g:coc_user_config = coc#config('coc.preferences.formatOnSaveFiletypes', filter(g:coc_user_config['coc.preferences.formatOnSaveFiletypes'], {idx, val -> val !=# 'python'}))
" command! EnablePythonFormat let g:coc_user_config = coc#config('coc.preferences.formatOnSaveFiletypes', add(g:coc_user_config['coc.preferences.formatOnSaveFiletypes'], 'python'))
" command! TogglePythonFormat if index(get(g:coc_user_config, 'coc.preferences.formatOnSaveFiletypes', []), 'python') >= 0 | exec "DisablePythonFormat" | else | exec "EnablePythonFormat" | endif

" Turn on/off format on save for all languages
command! DisableFormat let g:coc_user_config = coc#config('coc.preferences.formatOnSaveFiletypes', [])
" command! EnableFormat let g:coc_user_config = coc#config('coc.preferences.formatOnSaveFiletypes', ['*'])
"command! ToggleFormat if get(g:coc_user_config, 'coc.preferences.formatOnSaveFiletypes', []) == [] | exec "EnableFormat" | else | exec "DisableFormat" | endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Function to select symbols of given kind
"
function! CocShowFilteredSymbols(kind)
    " Save the current buffer number (original source buffer) and window number in global variables
    let g:original_buf = bufnr('%')
    let g:original_win = winnr()

    " Get document symbols using CocAction
    let l:symbols = CocAction('documentSymbols')

    " Check if the result is null or not a list
    if type(l:symbols) != type([])
        echo "No symbols found in the current document - not a list"
        return
    endif
    if l:symbols == []
        echo "No symbols found in the current document - null list"
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
    belowright vsplit
    vertical resize 40
    enew
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal nobuflisted

    " Save the current window number of the list window
    let g:list_win = winnr()

    " Populate the new buffer with filtered symbols and store symbol information
    let b:symbol_locations = []

    " Start appending from line 0 to avoid an initial blank line
    for l:symbol in l:filtered_symbols
        if has_key(l:symbol, 'range') && has_key(l:symbol, 'text')
            let l:line = l:symbol.range.start.line + 1
            let l:col = l:symbol.range.start.character + 1
            let l:text = l:symbol.text
            let l:formatted_line = printf('%-30s Line %d, Col %d', l:text, l:line, l:col)

            " Append the formatted line to the buffer
            call append(line('$') - 1, l:formatted_line)

            " Store the line and column details for easy lookup later
            call add(b:symbol_locations, {'line': l:line, 'col': l:col})
        endif
    endfor

    " Move cursor to the top of the buffer
    normal! gg

    " Allow jumping to symbol locations when pressing Enter on a line
    nnoremap <buffer> <CR> :call CocJumpToSymbolFromBuffer()<CR>

    " Allow jumping to symbol locations when single-clicking with the mouse
    nnoremap <buffer> <LeftMouse> :call CocJumpToSymbolFromBuffer()<CR>

    " Allow jumping and closing the split when double-clicking with the mouse
    nnoremap <buffer> <2-LeftMouse> :call CocJumpToSymbolAndClose()<CR>
endfunction

function! CocJumpToSymbolFromBuffer()
    " Get the line number in the buffer where the cursor is located
    let l:current_line_num = line('.')  " Use line('.') directly, without subtracting 1

    " Retrieve the symbol location from the stored buffer list
    if l:current_line_num >= 1 && l:current_line_num <= len(b:symbol_locations)
        let l:symbol_location = b:symbol_locations[l:current_line_num - 1]  " Adjust to 0-based index
        let l:lnum = l:symbol_location['line']
        let l:col = l:symbol_location['col']

        " Switch back to the original window and buffer using the global variables
        if exists('g:original_win') && exists('g:original_buf')
            " Switch to the original window
            execute g:original_win . "wincmd w"

            " Switch to the original buffer
            execute "buffer " . g:original_buf

            " Jump to the specified location in the original buffer
            execute l:lnum
            execute 'normal!' l:col . '|'

            " Switch focus back to the symbol list window
            if exists('g:list_win')
                execute g:list_win . "wincmd w"
            endif
        else
            echo "Original window or buffer not found"
            return
        endif
    else
        echo "Invalid line number"
    endif
endfunction

function! CocJumpToSymbolAndClose()
    " Call the function to jump to the symbol location
    call CocJumpToSymbolFromBuffer()

    " Close the current split window (right-hand buffer)
    execute 'quit'
endfunction

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
" Close hover popup
nnoremap <Leader>lch :call coc#float#close_all()<CR>
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
nnoremap <silent><nowait> <Leader>lsi  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <Leader>lj  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <Leader>lk  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <Leader>lp  :<C-u>CocListResume<CR>
nnoremap <silent><nowait> <Leader>lso  :CocList outline<cr> " Everything
nnoremap <silent><nowait> <Leader>lss  :CocList outline<cr> " Everything
nnoremap <Leader>lsf :call CocShowFilteredSymbols('Function')<CR> " Functions
nnoremap <Leader>lsv :call CocShowFilteredSymbols('Variable')<CR> " Variables
nnoremap <Leader>lsc :call CocShowFilteredSymbols('Class')<CR>  " Classes
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
" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent><nowait> gs  :CocList outline<cr>

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
