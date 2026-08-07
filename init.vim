" Omarchy Vim configuration
" Source this file as ~/.vimrc or ~/.config/nvim/init.vim.

" --------------------------------------------------------
" Future AI assistant support strategy
"
" Intent:
" - Keep AI features optional and off by default.
" - Preserve the existing native/ALE completion path when AI features are off.
" - Preserve the option to keep existing completion on <Tab> even when an AI
"   assistant is enabled, because Copilot plans can have limited completion
"   quotas and because local completion is faster for simple symbols.
" - Prefer popular, focused, lower-risk plugins over broad integrations that
"   install extra tooling or take over unrelated editor behavior.
" - Leave a clean path for future assistants such as Codex, Cline, OpenCode,
"   and local OpenAI-compatible models.
"
" GitHub Copilot plan:
" - First implementation should use github/copilot.vim behind a flag such as
"   g:omarchy_use_copilot. It is the official Vim/Neovim inline-suggestion
"   integration and works with this Vimscript config style.
" - Set g:copilot_no_tab_map = v:true by default. Map Copilot accept to a
"   dedicated key such as <C-J>, and add an explicit suggest key under the
"   <Leader>a namespace. Do not replace this config's <Tab> completion unless
"   a separate opt-in flag explicitly asks for that behavior.
" - Expose filetype controls through a user override such as
"   g:omarchy_copilot_filetypes so sensitive, prose, generated, or low-value
"   filetypes can be disabled without editing this file.
" - Avoid risky defaults such as disabling SSL verification or always pulling
"   the latest Copilot language server at startup.
"
" Chat and agent plan:
" - Treat chat as a separate capability from inline completion. If added, use a
"   separate flag such as g:omarchy_use_copilot_chat and guard it with has('nvim')
"   because current rich chat plugins are Neovim-oriented.
" - Prefer a separate <Leader>a key namespace for AI commands:
"     <Leader>as  suggest
"     <Leader>ac  chat
"     <Leader>aa  ask about selection/current buffer
"     <Leader>an  new agent session
"     <Leader>ar  restore agent session
" - For future agentic sessions, consider a Neovim-only ACP client behind its
"   own flag so Codex, Cline, OpenCode, Copilot, and local-model agents can be
"   added without entangling them with completion or ALE.
" --------------------------------------------------------

" 1. Flags ---------------------------------------------------------------------
let s:config_file = resolve(expand('<sfile>:p'))
let g:omarchy_use_fugitive = get(g:, 'omarchy_use_fugitive', 0)
let g:omarchy_use_gitgutter = get(g:, 'omarchy_use_gitgutter', 0)
let g:omarchy_fzf_min_version = get(g:, 'omarchy_fzf_min_version', '0.54.0')
let g:omarchy_python_format_imports = get(g:, 'omarchy_python_format_imports', 1)
let g:omarchy_python_keyword_completion = get(g:, 'omarchy_python_keyword_completion', 1)
let g:omarchy_python_keyword_completion_min_chars = get(g:, 'omarchy_python_keyword_completion_min_chars', 3)
let s:python_dictionary_file = fnamemodify(s:config_file, ':h') . '/python-complete.txt'
let s:python_dictionary_fallback_words = [
      \ 'False', 'None', 'True', 'and', 'as', 'assert', 'async', 'await',
      \ 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except',
      \ 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is',
      \ 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try',
      \ 'while', 'with', 'yield'
      \ ]

" ALE completion must be enabled before ALE loads.
let g:ale_completion_enabled = get(g:, 'ale_completion_enabled', 1)
let g:ale_completion_delay = get(g:, 'ale_completion_delay', 100)

" Disable gitgutter's default maps before the plugin loads.
let g:gitgutter_map_keys = 0
function! s:VersionAtLeast(found, required) abort
  if empty(a:found)
    return 0
  endif
  let l:found = map(split(a:found, '\.'), 'str2nr(v:val)')
  let l:required = map(split(a:required, '\.'), 'str2nr(v:val)')
  for l:index in range(0, 2)
    let l:left = get(l:found, l:index, 0)
    let l:right = get(l:required, l:index, 0)
    if l:left > l:right
      return 1
    elseif l:left < l:right
      return 0
    endif
  endfor
  return 1
endfunction

function! s:FzfVersion() abort
  if !executable('fzf')
    return ''
  endif
  let l:version = systemlist('fzf --version')
  if v:shell_error || empty(l:version)
    return ''
  endif
  return matchstr(l:version[0], '\d\+\.\d\+\.\d\+')
endfunction

" 2. vim-plug ------------------------------------------------------------------
let s:plug_home = has('nvim') ? stdpath('data') . '/site' : expand('~/.vim')
let s:plug_file = s:plug_home . '/autoload/plug.vim'
let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

function! s:BootstrapPlug() abort
  if filereadable(s:plug_file)
    execute 'source ' . fnameescape(s:plug_file)
    return exists('*plug#begin')
  endif

  if !executable('curl')
    echohl ErrorMsg
    echom 'vim-plug is missing and curl is not installed. Install curl, restart, then run :PlugInstall.'
    echohl None
    return 0
  endif

  call mkdir(fnamemodify(s:plug_file, ':h'), 'p')
  let l:cmd = 'curl -fL --retry 3 -o ' . shellescape(s:plug_file) . ' ' . shellescape(s:plug_url)
  let l:output = system(l:cmd)
  if v:shell_error || !filereadable(s:plug_file)
    echohl ErrorMsg
    echom 'vim-plug bootstrap failed. Run this in your shell:'
    echom 'curl -fLo ' . s:plug_file . ' --create-dirs ' . s:plug_url
    if !empty(l:output)
      echom l:output
    endif
    echohl None
    return 0
  endif

  execute 'source ' . fnameescape(s:plug_file)
  return exists('*plug#begin')
endfunction

function! s:PlugInstallFallback() abort
  silent! delcommand PlugInstall
  if !s:BootstrapPlug()
    echohl ErrorMsg
    echom 'vim-plug is still unavailable. See :messages and omarchy/vim/README.md.'
    echohl None
    return
  endif
  execute 'source ' . fnameescape(s:config_file)
  if exists(':PlugInstall') == 2
    PlugInstall
  else
    echohl ErrorMsg
    echom 'vim-plug loaded, but :PlugInstall was not created. Check :messages.'
    echohl None
  endif
endfunction

command! OmarchyPlugBootstrap call <SID>BootstrapPlug()
call s:BootstrapPlug()
if exists(':PlugInstall') != 2 && !exists('*plug#begin')
  command! PlugInstall call <SID>PlugInstallFallback()
endif
if exists('*plug#begin')
  call plug#begin(s:plug_home . '/plugged')
  Plug 'dense-analysis/ale'
  if s:VersionAtLeast(s:FzfVersion(), g:omarchy_fzf_min_version)
    Plug 'junegunn/fzf'
  else
    Plug 'junegunn/fzf', { 'do': './install --bin' }
  endif
  Plug 'junegunn/fzf.vim'
  if g:omarchy_use_gitgutter
    Plug 'airblade/vim-gitgutter'
  endif
  if g:omarchy_use_fugitive
    Plug 'tpope/vim-fugitive'
  endif
  call plug#end()
endif

" 3. Core settings --------------------------------------------------------------
set nocompatible
filetype plugin indent on
syntax enable

set encoding=utf-8
set fileencoding=utf-8
set number
set relativenumber
set ruler
set hidden
set mouse=a
if has('clipboard') || has('nvim')
  set clipboard^=unnamed,unnamedplus
endif
set splitbelow
set splitright
set updatetime=300
set timeoutlen=350
set signcolumn=yes
set wildmenu
set wildmode=list:longest,full
set ignorecase
set smartcase
set incsearch
set hlsearch
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
set linebreak
set textwidth=0
set colorcolumn=
set backspace=indent,eol,start
set completeopt=menu,menuone,noselect,noinsert
set shortmess+=c

if has('termguicolors')
  set termguicolors
endif

" 4. Leader and buffers ---------------------------------------------------------
let mapleader = ' '
let maplocalleader = ' '
nnoremap <Space> <Nop>
xnoremap <Space> <Nop>

function! s:BufferOnly() abort
  let l:current = bufnr('%')
  for l:buf in range(1, bufnr('$'))
    if l:buf != l:current && buflisted(l:buf)
      execute 'silent! bdelete ' . l:buf
    endif
  endfor
endfunction

" 5. command helpers ------------------------------------------------------------
function! s:CommandExists(name) abort
  return exists(':' . a:name) == 2
endfunction

function! s:RunCommand(command) abort
  let l:name = matchstr(a:command, '^\S\+')
  if s:CommandExists(l:name)
    execute a:command
  else
    echo l:name . ' is not available. Run :PlugInstall or check the README.'
  endif
endfunction

function! s:InGitRepo() abort
  return executable('git') && system('git rev-parse --is-inside-work-tree 2>/dev/null') =~# 'true'
endfunction

function! s:HasFzf() abort
  return exists('*fzf#run') || s:CommandExists('FZF')
endfunction

function! s:FzfRun(spec) abort
  if !s:HasFzf()
    return 0
  endif
  try
    call fzf#run(fzf#wrap(a:spec))
    return 1
  catch
    return 0
  endtry
endfunction

" MAP: <Space><Space> | Pick open buffer
nnoremap <silent> <Space><Space> :call <SID>RunCommand('Buffers')<CR>
" MAP: <Leader>bn | Next buffer
nnoremap <silent> <Leader>bn :bnext<CR>
" MAP: <Leader>bp | Previous buffer
nnoremap <silent> <Leader>bp :bprevious<CR>
" MAP: <Leader>bd | Delete current buffer
nnoremap <silent> <Leader>bd :bdelete<CR>
" MAP: <Leader>bo | Keep only current buffer
nnoremap <silent> <Leader>bo :call <SID>BufferOnly()<CR>

" 6. fzf -----------------------------------------------------------------------
if exists('g:fzf_vim')
  let g:fzf_vim.preview_window = ['right,50%,<70(up,40%)', 'ctrl-/']
else
  let g:fzf_vim = {'preview_window': ['right,50%,<70(up,40%)', 'ctrl-/']}
endif

function! s:ProjectFiles() abort
  if s:CommandExists('GFiles') && s:InGitRepo()
    GFiles
  elseif s:CommandExists('Files')
    Files
  else
    echo 'fzf.vim is not installed. Run :PlugInstall.'
  endif
endfunction

function! s:GitFiles() abort
  if s:InGitRepo()
    call s:RunCommand('GFiles')
  else
    call s:ProjectFiles()
  endif
endfunction

function! s:Ripgrep() abort
  if s:CommandExists('Rg') && executable('rg')
    Rg
  elseif executable('grep')
    let l:pattern = input('grep pattern: ')
    if !empty(l:pattern)
      execute 'grep! -RIn ' . shellescape(l:pattern) . ' .'
      copen
    endif
  else
    echo 'Install ripgrep for :Rg, or grep for fallback search.'
  endif
endfunction

" MAP: <Leader>ff | Find project files
nnoremap <silent> <Leader>ff :call <SID>ProjectFiles()<CR>
" MAP: <Leader>fg | Find git-tracked files
nnoremap <silent> <Leader>fg :call <SID>GitFiles()<CR>
" MAP: <Leader>fr | Search text with ripgrep
nnoremap <silent> <Leader>fr :call <SID>Ripgrep()<CR>
" MAP: <Leader>fl | Search current buffer lines
nnoremap <silent> <Leader>fl :call <SID>RunCommand('BLines')<CR>
" MAP: <Leader>fm | Search normal-mode maps
nnoremap <silent> <Leader>fm :call <SID>RunCommand('Maps')<CR>

" 7. ALE -----------------------------------------------------------------------
let g:ale_linters = get(g:, 'ale_linters', {'python': ['pylsp', 'flake8', 'pylint']})
if !exists('g:ale_fixers')
  let g:ale_fixers = {'python': (g:omarchy_python_format_imports ? ['isort', 'black'] : ['black'])}
endif
let g:ale_fix_on_save = get(g:, 'ale_fix_on_save', 0)
let g:ale_sign_error = get(g:, 'ale_sign_error', 'E')
let g:ale_sign_warning = get(g:, 'ale_sign_warning', 'W')
let g:ale_echo_msg_format = get(g:, 'ale_echo_msg_format', '[%linter%] %s [%severity%]')
let g:ale_hover_to_preview = get(g:, 'ale_hover_to_preview', 1)

function! s:SetAleOmnifunc() abort
  setlocal omnifunc=ale#completion#OmniFunc
endfunction

function! s:PythonCompleteStart() abort
  let l:line = getline('.')
  let l:start = col('.') - 1
  while l:start > 0 && strpart(l:line, l:start - 1, 1) =~# '[A-Za-z0-9_]'
    let l:start -= 1
  endwhile
  return l:start
endfunction

function! s:AddPythonCompletionMatch(matches, seen, word, menu, kind, base) abort
  if a:word !~# '^[A-Za-z_][A-Za-z0-9_]*$'
        \ || a:word ==# a:base
        \ || stridx(a:word, a:base) != 0
        \ || has_key(a:seen, a:word)
    return
  endif

  let a:seen[a:word] = 1
  call add(a:matches, {
        \ 'word': a:word,
        \ 'menu': a:menu,
        \ 'kind': a:kind,
        \ 'dup': 0,
        \ })
endfunction

function! s:PythonBufferCompletionMatches(base, matches, seen) abort
  for l:line in getline(1, '$')
    for l:word in split(l:line, '[^A-Za-z0-9_]\+')
      call s:AddPythonCompletionMatch(a:matches, a:seen, l:word, '[buffer]', 'w', a:base)
    endfor
  endfor
endfunction

function! s:PythonDictionaryCompletionMatches(base, matches, seen) abort
  if !filereadable(s:python_dictionary_file)
    for l:word in s:python_dictionary_fallback_words
      call s:AddPythonCompletionMatch(a:matches, a:seen, l:word, '[python]', 'k', a:base)
    endfor
    return
  endif

  for l:word in readfile(s:python_dictionary_file)
    call s:AddPythonCompletionMatch(a:matches, a:seen, l:word, '[python]', 'k', a:base)
  endfor
endfunction

function! s:PythonCompletionMatches(base) abort
  let l:matches = []
  let l:seen = {}
  call s:PythonBufferCompletionMatches(a:base, l:matches, l:seen)
  call s:PythonDictionaryCompletionMatches(a:base, l:matches, l:seen)
  return l:matches
endfunction

function! OmarchyPythonComplete(findstart, base) abort
  if a:findstart
    return s:PythonCompleteStart()
  endif

  return s:PythonCompletionMatches(a:base)
endfunction

function! s:TriggerPythonKeywordCompletion(min_chars) abort
  if !g:omarchy_python_keyword_completion || &filetype !=# 'python' || &paste
    return 0
  endif

  let l:start = s:PythonCompleteStart()
  let l:prefix = strpart(getline('.'), l:start, col('.') - 1 - l:start)
  if strlen(l:prefix) < a:min_chars
    return 0
  endif

  if l:start > 1 && strpart(getline('.'), l:start - 2, 1) ==# '.'
    return 0
  endif

  if empty(s:PythonCompletionMatches(l:prefix))
    return 0
  endif

  call feedkeys("\<C-x>\<C-u>", 'n')
  return 1
endfunction

function! s:MaybeAutoPythonKeywordComplete() abort
  if mode() ==# 'i' && !pumvisible()
    call s:TriggerPythonKeywordCompletion(g:omarchy_python_keyword_completion_min_chars)
  endif
endfunction

function! s:SetupPythonCompletion() abort
  call s:SetAleOmnifunc()
  setlocal completefunc=OmarchyPythonComplete
  augroup omarchy_python_keyword_completion
    autocmd! * <buffer>
    autocmd TextChangedI <buffer> call <SID>MaybeAutoPythonKeywordComplete()
  augroup END
endfunction

augroup omarchy_ale_omnifunc
  autocmd!
  autocmd FileType python call <SID>SetupPythonCompletion()
augroup END

function! s:ManualComplete() abort
  if s:TriggerPythonKeywordCompletion(1)
    return ''
  elseif s:CommandExists('ALEComplete')
    execute 'ALEComplete'
  elseif !empty(&omnifunc)
    call feedkeys("\<C-x>\<C-o>", 'n')
  else
    call feedkeys("\<C-n>", 'n')
  endif
  return ''
endfunction

function! s:TabComplete() abort
  if pumvisible()
    return "\<C-n>"
  endif
  let l:col = col('.') - 1
  if l:col > 0 && strpart(getline('.'), l:col - 1, 1) =~# '\k'
    return s:ManualComplete()
  endif
  return "\<Tab>"
endfunction

" MAP: <Leader>ld | ALE go to definition
nnoremap <silent> <Leader>ld :call <SID>RunCommand('ALEGoToDefinition')<CR>
" MAP: <Leader>lr | ALE find references
nnoremap <silent> <Leader>lr :call <SID>RunCommand('ALEFindReferences -contents')<CR>
" MAP: <Leader>lh | ALE hover
nnoremap <silent> <Leader>lh :call <SID>RunCommand('ALEHover')<CR>
" MAP: <Leader>ln | ALE rename symbol
nnoremap <silent> <Leader>ln :call <SID>RunCommand('ALERename')<CR>
" MAP: <Leader>la | ALE code action
nnoremap <silent> <Leader>la :call <SID>RunCommand('ALECodeAction')<CR>
" MAP: <Leader>aj | Next ALE diagnostic
nnoremap <silent> <Leader>aj :call <SID>RunCommand('ALENextWrap')<CR>
" MAP: <Leader>ak | Previous ALE diagnostic
nnoremap <silent> <Leader>ak :call <SID>RunCommand('ALEPreviousWrap')<CR>
" MAP: <Leader>af | Run ALE fixers
nnoremap <silent> <Leader>af :call <SID>RunCommand('ALEFix')<CR>
" MAP: <Leader>ai | Show ALE info
nnoremap <silent> <Leader>ai :call <SID>RunCommand('ALEInfo')<CR>
" MAP: <Tab> | Complete after a word, otherwise insert a tab
inoremap <silent><expr> <Tab> <SID>TabComplete()
" MAP: <S-Tab> | Previous completion menu item
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" MAP: <CR> | Accept completion menu item
inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
" MAP: <M-/> | Trigger insert completion
inoremap <silent><expr> <M-/> <SID>ManualComplete()
" MAP: <C-Space> | Trigger insert completion
inoremap <silent><expr> <C-Space> <SID>ManualComplete()
" MAP: <C-@> | Trigger insert completion fallback
inoremap <silent><expr> <C-@> <SID>ManualComplete()

" 8. Python symbols -------------------------------------------------------------
let s:python_symbol_origin = -1

function! s:PythonSymbolSink(line) abort
  let l:lnum = str2nr(matchstr(a:line, '^\s*\zs\d\+'))
  if l:lnum <= 0
    return
  endif
  if bufexists(s:python_symbol_origin)
    execute 'buffer ' . s:python_symbol_origin
  endif
  execute l:lnum
  normal! zvzz
endfunction

function! s:PythonSymbols() abort
  let s:python_symbol_origin = bufnr('%')
  let l:items = []
  for lnum in range(1, line('$'))
    let l:line = getline(lnum)
    if l:line =~# '^\s*\(class\|async\s\+def\|def\)\s\+[A-Za-z_][A-Za-z0-9_]*'
      let l:name = matchstr(l:line, '^\s*\zs\(class\|async\s\+def\|def\)\s\+[A-Za-z_][A-Za-z0-9_]*')
      call add(l:items, printf('%5d  %s', lnum, l:name))
    endif
  endfor

  if empty(l:items)
    echo 'No Python classes or functions found.'
    return
  endif

  if s:FzfRun({
        \ 'source': l:items,
        \ 'sink': function('<SID>PythonSymbolSink'),
        \ 'options': '--prompt="Python symbols> " --no-multi'
        \ })
    return
  endif

  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  call setline(1, l:items)
  nnoremap <buffer> <CR> :call <SID>PythonSymbolSink(getline('.'))<CR>
endfunction

command! PythonSymbols call <SID>PythonSymbols()
" MAP: <Leader>fs | Pick Python class/function
nnoremap <silent> <Leader>fs :PythonSymbols<CR>

" 9. Status line ---------------------------------------------------------------
function! OmarchyMode() abort
  let l:mode = mode()
  return get({
        \ 'n': 'NORMAL',
        \ 'i': 'INSERT',
        \ 'v': 'VISUAL',
        \ 'V': 'V-LINE',
        \ "\<C-v>": 'V-BLOCK',
        \ 'c': 'COMMAND',
        \ 'R': 'REPLACE',
        \ }, l:mode, toupper(l:mode))
endfunction

function! OmarchyAleCounts() abort
  if exists('*ale#statusline#Count')
    let l:counts = ale#statusline#Count(bufnr(''))
    return printf('E:%d W:%d', get(l:counts, 'error', 0), get(l:counts, 'warning', 0))
  endif
  return ''
endfunction

let s:git_branch_cache = {}
function! OmarchyGitBranch() abort
  if !executable('git') || empty(expand('%:p'))
    return ''
  endif
  let l:dir = expand('%:p:h')
  let l:root = systemlist('git -C ' . shellescape(l:dir) . ' rev-parse --show-toplevel 2>/dev/null')
  if v:shell_error || empty(l:root)
    return ''
  endif
  let l:key = l:root[0]
  if has_key(s:git_branch_cache, l:key)
    return s:git_branch_cache[l:key]
  endif
  let l:branch = systemlist('git -C ' . shellescape(l:key) . ' branch --show-current 2>/dev/null')
  if v:shell_error || empty(l:branch) || empty(l:branch[0])
    let l:branch = systemlist('git -C ' . shellescape(l:key) . ' rev-parse --abbrev-ref HEAD 2>/dev/null')
  endif
  let s:git_branch_cache[l:key] = v:shell_error || empty(l:branch) ? '' : '[' . l:branch[0] . ']'
  return s:git_branch_cache[l:key]
endfunction

function! OmarchyStatusline() abort
  let l:left = ' ' . OmarchyMode() . ' %f%m%r '
  let l:git = OmarchyGitBranch()
  if !empty(l:git)
    let l:left .= l:git . ' '
  endif
  let l:ale = OmarchyAleCounts()
  if !empty(l:ale)
    let l:left .= l:ale . ' '
  endif
  let l:ft = empty(&filetype) ? 'none' : &filetype
  let l:enc = empty(&fileencoding) ? &encoding : &fileencoding
  let l:right = printf(' %s %s/%s ts:%d %%l:%%c %%p%%%% %s ', l:ft, l:enc, &fileformat, &tabstop, strftime('%H:%M'))
  return l:left . '%=' . l:right
endfunction

set laststatus=2
set statusline=%!OmarchyStatusline()

" 10. Keymap reference ---------------------------------------------------------
function! s:Termcodes(keys) abort
  let l:text = substitute(a:keys, '<\([^>]\+\)>', '\\<\1>', 'g')
  return eval('"' . escape(l:text, '"') . '"')
endfunction

function! s:KeymapSink(line) abort
  let l:key = matchstr(a:line, '^MAP: \zs\S\+')
  if !empty(l:key)
    call feedkeys(s:Termcodes(l:key), 'm')
  endif
endfunction

function! s:Keymaps() abort
  let l:maps = []
  for l:line in readfile(s:config_file)
    if l:line =~# '^" MAP: '
      call add(l:maps, substitute(l:line, '^" ', '', ''))
    endif
  endfor

  if s:FzfRun({
        \ 'source': l:maps,
        \ 'sink': function('<SID>KeymapSink'),
        \ 'options': '--prompt="Keymaps> " --no-multi'
        \ })
    return
  endif

  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  call setline(1, l:maps)
  nnoremap <buffer> <CR> :call <SID>KeymapSink(getline('.'))<CR>
endfunction

command! Keymaps call <SID>Keymaps()
" MAP: <Leader>fk | Show config keymap reference
nnoremap <silent> <Leader>fk :Keymaps<CR>

" 11. Editing helpers ----------------------------------------------------------
" MAP: jj | Leave insert mode
inoremap jj <Esc>
" MAP: jk | Leave insert mode
inoremap jk <Esc>

inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

function! s:CommentPrefix() abort
  return get({
        \ 'python': '#',
        \ 'sh': '#',
        \ 'bash': '#',
        \ 'zsh': '#',
        \ 'vim': '"',
        \ 'lua': '--',
        \ 'javascript': '//',
        \ 'typescript': '//',
        \ 'c': '//',
        \ 'cpp': '//',
        \ 'java': '//',
        \ 'go': '//',
        \ 'rust': '//',
        \ 'css': '/*',
        \ }, &filetype, '#')
endfunction

function! s:CommentRange(first, last, force) abort
  let l:prefix = s:CommentPrefix()
  let l:escaped = escape(l:prefix, '\.^$*~[]')
  for lnum in range(a:first, a:last)
    let l:line = getline(lnum)
    if l:prefix ==# '/*'
      if a:force || l:line !~# '^\s*/\*'
        call setline(lnum, substitute(l:line, '^\s*', '&/* ', '') . ' */')
      else
        call setline(lnum, substitute(substitute(l:line, '^\s*/\*\s*', '', ''), '\s*\*/\s*$', '', ''))
      endif
    elseif a:force || l:line !~# '^\s*' . l:escaped . '\s\?'
      call setline(lnum, substitute(l:line, '^\s*', '&' . l:prefix . ' ', ''))
    else
      call setline(lnum, substitute(l:line, '^\(\s*\)' . l:escaped . '\s\?', '\1', ''))
    endif
  endfor
endfunction

command! -range -bang CommentToggle call <SID>CommentRange(<line1>, <line2>, <bang>0)
" MAP: <Leader>/ | Toggle comment
nnoremap <silent> <Leader>/ :CommentToggle<CR>
" MAP: <Leader>/ | Toggle comment on selection
xnoremap <silent> <Leader>/ :CommentToggle<CR>gv
" MAP: <Leader>// | Force comment
nnoremap <silent> <Leader>// :CommentToggle!<CR>
" MAP: <Leader>// | Force comment on selection
xnoremap <silent> <Leader>// :CommentToggle!<CR>gv

" MAP: <M-j> | Move line down
nnoremap <silent> <M-j> :move .+1<CR>==
" MAP: <M-k> | Move line up
nnoremap <silent> <M-k> :move .-2<CR>==
" MAP: <M-j> | Move selection down
xnoremap <silent> <M-j> :move '>+1<CR>gv=gv
" MAP: <M-k> | Move selection up
xnoremap <silent> <M-k> :move '<-2<CR>gv=gv
" MAP: > | Indent selection and keep it
xnoremap > >gv
" MAP: < | Unindent selection and keep it
xnoremap < <gv
" MAP: <Leader>nh | Toggle search highlight
nnoremap <silent> <Leader>nh :set hlsearch!<CR>
" MAP: <C-L> | Refresh screen
nnoremap <silent> <C-L> :redraw!<CR>
" MAP: <C-L> | Refresh screen from insert mode
inoremap <silent> <C-L> <C-O>:redraw!<CR>
" MAP: <Leader>rr | Refresh screen
nnoremap <silent> <Leader>rr :redraw!<CR>

" 12. Diff and windows ---------------------------------------------------------
let s:diff_sessions = {}

function! s:DiffWindowForBuffer(bufnr) abort
  for l:winnr in range(1, winnr('$'))
    if winbufnr(l:winnr) == a:bufnr
      return l:winnr
    endif
  endfor
  return -1
endfunction

function! s:CloseDiffSession(origin_buf) abort
  if !has_key(s:diff_sessions, a:origin_buf)
    return 0
  endif

  let l:session = s:diff_sessions[a:origin_buf]
  let l:current_win = winnr()
  let l:origin_win = s:DiffWindowForBuffer(a:origin_buf)
  let l:scratch_win = s:DiffWindowForBuffer(get(l:session, 'scratch_buf', -1))

  if l:origin_win > 0
    execute l:origin_win . 'wincmd w'
    diffoff
    silent! nunmap <buffer> q
    silent! nunmap <buffer> <Leader>dq
  endif

  if l:scratch_win > 0
    execute l:scratch_win . 'wincmd w'
    diffoff
    if l:origin_win > 0 || winnr('$') > 1
      close
    elseif bufexists(a:origin_buf)
      execute 'buffer ' . a:origin_buf
      diffoff
      silent! nunmap <buffer> q
      silent! nunmap <buffer> <Leader>dq
    else
      enew
    endif
  endif

  call remove(s:diff_sessions, a:origin_buf)

  if l:origin_win > 0 && bufwinnr(a:origin_buf) > 0
    execute bufwinnr(a:origin_buf) . 'wincmd w'
  elseif l:current_win <= winnr('$')
    execute l:current_win . 'wincmd w'
  endif

  return 1
endfunction

function! s:DiffClose() abort
  if get(b:, 'omarchy_diff_scratch', 0)
    if s:CloseDiffSession(get(b:, 'omarchy_diff_origin', -1))
      return
    endif
  elseif has_key(s:diff_sessions, bufnr('%'))
    if s:CloseDiffSession(bufnr('%'))
      return
    endif
  endif

  echo 'No Omarchy diff session is active for this buffer.'
endfunction

function! s:StartDiffScratch(name, lines) abort
  let l:origin_buf = bufnr('%')
  if has_key(s:diff_sessions, l:origin_buf)
    call s:CloseDiffSession(l:origin_buf)
  endif

  vert new
  execute 'file ' . fnameescape(a:name)
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodifiable
  setlocal modifiable
  call setline(1, empty(a:lines) ? [''] : a:lines)
  setlocal nomodifiable nomodified
  let b:omarchy_diff_scratch = 1
  let b:omarchy_diff_origin = l:origin_buf
  let l:scratch_buf = bufnr('%')
  nnoremap <buffer><silent> q :DiffClose<CR>
  nnoremap <buffer><silent> <Leader>dq :DiffClose<CR>
  diffthis

  wincmd p
  let b:omarchy_diff_origin = 1
  nnoremap <buffer><silent> q :DiffClose<CR>
  nnoremap <buffer><silent> <Leader>dq :DiffClose<CR>
  diffthis

  let s:diff_sessions[l:origin_buf] = {'scratch_buf': l:scratch_buf}
endfunction

function! s:DiffSaved() abort
  let l:file = expand('%:p')
  if empty(l:file) || !filereadable(l:file)
    echo 'No saved file to diff.'
    return
  endif
  call s:StartDiffScratch('[saved] ' . fnamemodify(l:file, ':t'), readfile(l:file))
endfunction

function! s:DiffGitHead() abort
  let l:file = expand('%:p')
  if !executable('git') || empty(l:file)
    echo 'git is required for :DiffGitHead.'
    return
  endif
  let l:dir = expand('%:p:h')
  let l:root_list = systemlist('git -C ' . shellescape(l:dir) . ' rev-parse --show-toplevel 2>/dev/null')
  if v:shell_error || empty(l:root_list)
    echo 'Current file is not in a git repository.'
    return
  endif
  let l:root = fnamemodify(l:root_list[0], ':p')
  let l:rel = substitute(fnamemodify(l:file, ':p'), '^' . escape(l:root, '\.^$*~[]'), '', '')
  let l:rel = substitute(l:rel, '\\', '/', 'g')
  let l:tracked = systemlist('git -C ' . shellescape(l:root) . ' ls-files --full-name -- ' . shellescape(l:rel))
  if v:shell_error || empty(l:tracked)
    echo 'Current file is not tracked by git.'
    return
  endif
  let l:rel = l:tracked[0]
  let l:lines = systemlist('git -C ' . shellescape(l:root) . ' show ' . shellescape('HEAD:' . l:rel))
  if v:shell_error
    echo 'Could not read file from git HEAD.'
    return
  endif
  call s:StartDiffScratch('[HEAD] ' . fnamemodify(l:file, ':t'), l:lines)
endfunction

command! DiffSaved call <SID>DiffSaved()
command! DiffGitHead call <SID>DiffGitHead()
command! DiffClose call <SID>DiffClose()
" MAP: <Leader>ds | Diff buffer against saved file
nnoremap <silent> <Leader>ds :DiffSaved<CR>
" MAP: <Leader>dg | Diff buffer against git HEAD
nnoremap <silent> <Leader>dg :DiffGitHead<CR>
" MAP: <Leader>dq | Close active Omarchy diff
nnoremap <silent> <Leader>dq :DiffClose<CR>

" MAP: <Leader>wh | Vertical split
nnoremap <silent> <Leader>wh :vsplit<CR>
" MAP: <Leader>wj | Horizontal split
nnoremap <silent> <Leader>wj :split<CR>
" MAP: <Leader>wc | Close window
nnoremap <silent> <Leader>wc :close<CR>
" MAP: <Leader>wo | Only keep current window
nnoremap <silent> <Leader>wo :only<CR>
" MAP: <M-Left> | Narrow window
nnoremap <silent> <M-Left> :vertical resize -10<CR>
" MAP: <M-Right> | Widen window
nnoremap <silent> <M-Right> :vertical resize +10<CR>
" MAP: <M-Up> | Shorten window
nnoremap <silent> <M-Up> :resize -5<CR>
" MAP: <M-Down> | Heighten window
nnoremap <silent> <M-Down> :resize +5<CR>

if g:omarchy_use_gitgutter
  " MAP: <Leader>gh | Preview git hunk
  nnoremap <silent> <Leader>gh :call <SID>RunCommand('GitGutterPreviewHunk')<CR>
  " MAP: <Leader>gs | Stage git hunk
  nnoremap <silent> <Leader>gs :call <SID>RunCommand('GitGutterStageHunk')<CR>
  " MAP: <Leader>gu | Undo git hunk
  nnoremap <silent> <Leader>gu :call <SID>RunCommand('GitGutterUndoHunk')<CR>
endif

if g:omarchy_use_fugitive
  " MAP: <Leader>gg | Open fugitive Git status
  nnoremap <silent> <Leader>gg :call <SID>RunCommand('Git')<CR>
  " MAP: <Leader>gb | Open fugitive Git blame
  nnoremap <silent> <Leader>gb :call <SID>RunCommand('Git blame')<CR>
  " MAP: <Leader>gd | Open fugitive diff split
  nnoremap <silent> <Leader>gd :call <SID>RunCommand('Gdiffsplit')<CR>
endif
