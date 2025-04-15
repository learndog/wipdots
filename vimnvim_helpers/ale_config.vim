" BEGIN - ALE configuration for linting
" Check ALE status with :ALEInfo
"let g:ale_python_pyright_config = '/path/to/pyrightconfig.json' " Optional Pyright config file
let g:ale_linters = {'python': ['pylint', 'pyright']}   
"or try ['flake8', 'pyright', 'pylint']
let g:ale_fixers = {'python': ['pyright', 'black', 'isort']}
let g:ale_completion_enabled = 1   " Enable completion where available.
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1
"let g:ale_fix_on_save = 1                     " Automatically run fixers when you save a file
"let g:ale_python_black_options = ''           " Use this to pass options to Black
"let g:ale_python_black_use_global = 1
let g:ale_python_isort_options = ''            " isort available but disabled
let g:ale_python_isort_use_global = 0
"let g:ale_linters_explicit = 1

let g:ale_list_vertical = 1
let g:ale_list_window_size = 10

let g:ale_echo_msg_error_str = 'E'   " Chg error msg to E
let g:ale_echo_msg_warning_str = 'W' " Chg warn msg to W
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = 'E'         " Chg gutter error sign to E
let g:ale_sign_warning = 'W'       " Chg gutter warning sign to W
highlight ALEErrorSign ctermfg=darkred guifg=darkred      " Use darkred for more subtle error highlighting
highlight ALEError ctermbg=darkgrey guibg=darkgrey
highlight ALEWarning ctermbg=darkgrey guibg=darkgrey

" Turn on quickfix. Optionally disable loclist also.
" let g:ale_set_loclist = 0
" let g:ale_set_quickfix = 1

" END - ALE configuration for linting



" BEGIN - KEYMAPS FOR ALE

" ALE navigation commands
nnoremap <F2> :ALEPrevious<CR>
nnoremap <F3> :ALENext<CR>
nnoremap <F4> :ALEFirst<CR>
nnoremap <F5> :ALELast<CR>

" ALE error/warning navigation
nnoremap <Leader>ep :ALEPrevious -error<CR>
nnoremap <Leader>ew :ALEPrevious -warning<CR>
nnoremap <Leader>en :ALENext -error<CR>
nnoremap <Leader>ew :ALENext -warning<CR>

" ALE wrap navigation
nnoremap <Leader>wp :ALEPreviousWrap<CR>
nnoremap <Leader>wn :ALENextWrap<CR>
nnoremap <Leader>wep :ALEPrevious -wrap -error<CR>
nnoremap <Leader>wew :ALEPrevious -wrap -warning<CR>
nnoremap <Leader>wen :ALENext -wrap -error<CR>
nnoremap <Leader>wew :ALENext -wrap -warning<CR>

" ALE toggle commands
nnoremap <Leader>at :ALEToggle<CR>
nnoremap <Leader>ae :ALEEnable<CR>
nnoremap <Leader>ad :ALEDisable<CR>
nnoremap <Leader>ar :ALEReset<CR>
nnoremap <Leader>atb :ALEToggleBuffer<CR>
nnoremap <Leader>aeb :ALEEnableBuffer<CR>
nnoremap <Leader>adb :ALEDisableBuffer<CR>
nnoremap <Leader>arb :ALEResetBuffer<CR>

" ALE linting and fixing
nnoremap <Leader>al :ALELint<CR>
nnoremap <Leader>af :ALEFix<CR>

" ALE go-to commands
nnoremap <Leader>gd :ALEGoToDefinition<CR>
nnoremap <Leader>gt :ALEGoToTypeDefinition<CR>
nnoremap <Leader>gi :ALEGoToImplementation<CR>
nnoremap <Leader>gtt :ALEGoToDefinition -tab<CR>
nnoremap <Leader>gts :ALEGoToDefinition -split<CR>
nnoremap <Leader>gtv :ALEGoToDefinition -vsplit<CR>
nnoremap <Leader>gtd :ALEGoToTypeDefinition -tab<CR>
nnoremap <Leader>gts :ALEGoToTypeDefinition -split<CR>
nnoremap <Leader>gtv :ALEGoToTypeDefinition -vsplit<CR>
nnoremap <Leader>git :ALEGoToImplementation -tab<CR>
nnoremap <Leader>gis :ALEGoToImplementation -split<CR>
nnoremap <Leader>giv :ALEGoToImplementation -vsplit<CR>

" ALE references and hover
nnoremap <Leader>fr :ALEFindReferences<CR>
nnoremap <Leader>hh :ALEHover<CR>
nnoremap <Leader>pc :pclose<CR> " Close preview window after Hover

" ALE documentation and completion
nnoremap <Leader>hd :ALEDocumentation<CR>

" ALE import and rename
nnoremap <Leader>ai :ALEImport<CR>
nnoremap <Leader>ar :ALERename<CR>
nnoremap <Leader>afn :ALEFileRename<CR>

" ALE code action
nnoremap <Leader>ca :ALECodeAction<CR>
nnoremap <Leader>rs :ALERepeatSelection<CR>


" END - KEYMAPS FOR ALE

