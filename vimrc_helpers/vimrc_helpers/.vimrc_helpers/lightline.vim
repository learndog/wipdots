" #### SECTION: LIGHTLINE SETUP
" #### Dependencies: None 
let g:lightline = {
    \ 'active': {
    \     'left': [ [ 'bufferstatus', 'mode', 'cocstatus', 'gitbranch', 'filepath', 'filename' ] ],
    \     'right': [ ['venv', 'cwd', 'fileformat', 'fileencoding', 'datetime', 'percent', 'lineinfo' ] ],
    \ },
    \ 'component_function': {
    \   'bufferstatus': 'LightlineBufferStatus',
    \   'gitbranch': 'FugitiveHead',
    \   'filepath': 'LightlineFilepath',
    \   'cocstatus': 'LightlineCocStatus',
    \   'venv': 'LightlineVenv',
    \   'datetime': 'LightlineDatetime',
    \   'cwd': 'LightlineCwd',
    \ },
    \ 'priority': {
    \   'bufferstatus': 10,
    \   'mode': 20,
    \   'cocstatus': 30,
    \   'gitbranch': 40,
    \   'filepath': 120,
    \   'filename': 50,
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
  return get(b:, 'coc_current_function', '')
endfunction

function! LightlineVenv()
  let l:venv = $VIRTUAL_ENV
  return l:venv !=# '' ? fnamemodify(l:venv, ':t') : ''
endfunction

function! LightlineDatetime()
  return strftime('%Y-%m-%d %H:%M:%S')
endfunction

function! LightlineCwd()
  return fnamemodify(getcwd(), ':~')
endfunction

function! LightlineFilepath()
  return expand('%:p:h')
endfunction

" #### End LightLine configuration
