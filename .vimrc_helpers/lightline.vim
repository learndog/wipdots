" #### SECTION: LIGHTLINE SETUP
" #### Dependencies: None 

" TODO: Add filetype and if available, coc lsp status info like loaded lsps, linters, formatters

" \     'right': [ ['venv', 'cwd', 'fileformat', 'fileencoding', 'datetime', 'percent', 'lineinfo' ] ],
let g:lightline = {
    \ 'active': {
    \     'left': [ [ 'bufferstatus', 'mode', 'gitbranch', 'filepath', 'filename' ] ],
    \     'right': [ ['venv', 'cwd', 'fileinfo', 'filetype', 'cocstatus', 'linterstatus', 'datetime', 'percent', 'lineinfo' ] ],
    \ },
    \ 'component_function': {
    \   'bufferstatus': 'LightlineBufferStatus',
    \   'gitbranch': 'LightlineGitBranch',
    \   'filepath': 'LightlineFilepath',
    \   'cocstatus': 'LightlineCocStatus',
    \   'venv': 'LightlineVenv',
    \   'datetime': 'LightlineDatetime',
    \   'cwd': 'LightlineCwd',
    \   'fileinfo': 'LightlineFileInfo',
    \   'filetype': 'LightlineFiletype',
    \   'linterstatus': 'LightlineLinterStatus',
    \ },
    \ 'priority': {
    \   'bufferstatus': 10,
    \   'mode': 20,
    \   'cocstatus': 130,
    \   'gitbranch': 40,
    \   'filepath': 120,
    \   'filename': 50,
    \   'filetype': 140,
    \   'fileinfo': 45,
    \   'venv': 60,
    \   'cwd': 70,
    \   'fileformat': 80,
    \   'fileencoding': 90,
    \   'datetime': 110,
    \   'percent': 110,
    \   'lineinfo': 120,
    \ },
    \ 'colorscheme': 'solarized'
    \ }

function! LightlineBufferStatus()
  if &readonly
    return '[RO]'
  elseif &modified
    return '[+]'
  elseif &previewwindow
    return '[Preview]'
  else
    return ''
  endif
endfunction

function! LightlineCocStatus()
"   return get(b:, 'coc_current_function', '')
  return coc#status()
endfunction

function! LightlineVenv()
  let l:venv = $VIRTUAL_ENV
  return l:venv !=# '' ? fnamemodify(l:venv, ':t') : ''
endfunction

function! LightlineDatetime()
  return strftime('%Y-%m-%d %H:%M:%S')
endfunction

function! LightlineCwd()
"   return fnamemodify(getcwd(), ':~')
    return 'cwd ' . fnamemodify(getcwd(), ':~')
endfunction

function! LightlineFilepath()
  return expand('%:p:h')
endfunction

function! LightlineFiletype()
  " Return the file type of the current buffer
  return &filetype != '' ? &filetype : 'No Filetype'
endfunction

function! LightlineGitBranch()
  if !isdirectory('.git')
    return ''
  endif
  let l:branch_name = system('git rev-parse --abbrev-ref HEAD 2>/dev/null')
  return v:shell_error ? '' : substitute(l:branch_name, '\n\+$', '', '')
endfunction

" Combine file format and encoding (unix and utf-8)
function! LightlineFileInfo()
  let l:format = &fileformat
  let l:encoding = &fileencoding
  return l:format . ':' . l:encoding
endfunction

" Show linting progress from coc
function! LightlineLinterStatus()
  " Return an indication if linting is in progress
  let l:status = get(b:, 'coc_diagnostic_running', 0)
  return l:status ? 'Linting...' : 'Linting Done'
endfunction

" #### End LightLine configuration
