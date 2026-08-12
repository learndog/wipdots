" Omarchy Vim configuration
" Source this file as ~/.vimrc or ~/.config/nvim/init.vim.

" --------------------------------------------------------
" Goals
"
" - Keep this as one readable Vimscript file.
" - Prefer built-in Vim behavior over plugins when the built-in behavior is
"   good enough.
" - Keep dependencies few, popular, focused, and optional where practical.
" - Keep startup low-risk: opening Vim should not download or update software.
" - Keep plugin actions manual: only explicit commands such as
"   :OmarchyPlugBootstrap, :PlugInstall, :PlugUpdate, :PlugClean, and
"   :PlugUpgrade should download, install, update, clean, or upgrade plugin
"   code. Optional plugin declarations are controlled only by flags set before
"   sourcing this config.
" - Preserve wide Vim/Neovim compatibility and graceful degradation when tools
"   are missing.
" - Keep maintenance simple. Add complexity only when the runtime benefit is
"   clear, bounded, and easy to reason about.
"
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
" - Use github/copilot.vim only for optional inline suggestions, behind
"   g:omarchy_install_copilot. It is the official Vim/Neovim inline-suggestion
"   integration and works with this Vimscript config style, but it requires
"   Vim 9.0.0185+ or Neovim 0.6+ and Node.js.
" - Set g:copilot_no_tab_map = v:true by default. Map Copilot accept to a
"   dedicated key such as <C-J>. Do not replace this config's <Tab> completion.
" - Start automatic Copilot inline suggestions disabled unless
"   g:omarchy_copilot_suggestions_start_enabled is set. That flag controls
"   only automatic inline suggestions, not installation, authentication,
"   explicit suggestion requests, or Copilot CLI sessions.
" - Expose filetype controls through Copilot's native g:copilot_filetypes so
"   sensitive, prose, generated, or low-value filetypes can be disabled without
"   another abstraction layer.
" - Avoid risky defaults such as disabling SSL verification or always pulling
"   the latest Copilot language server at startup.
"
" Chat and agent plan:
" - Treat chat and agentic work as separate from inline completion. Prefer the
"   official copilot CLI in a terminal over a Neovim-only chat plugin.
" - Keep the CLI terminal mapping behind g:omarchy_enable_copilot_cli_mapping,
"   and never launch it with blanket automatic permissions.
" - Do not add editor-integrated agent tooling until the CLI path proves
"   insufficient and the extra permissions/configuration surface is justified.
" --------------------------------------------------------

" 1. Flags ---------------------------------------------------------------------
let s:config_file = resolve(expand('<sfile>:p'))
let s:plug_home = has('nvim') ? stdpath('data') . '/site' : expand('~/.vim')
let s:ale_plugin_dir = s:plug_home . '/plugged/ale'
let g:omarchy_use_fugitive = get(g:, 'omarchy_use_fugitive', 0)
let g:omarchy_use_gitgutter = get(g:, 'omarchy_use_gitgutter', 0)
" Reduce the enablement check to allow 0.38.0. It appears to provide the basic picker functionality
" at least for the Aug 2026 version of fzf.vim.
" let g:omarchy_fzf_min_version = get(g:, 'omarchy_fzf_min_version', '0.54.0')
let g:omarchy_fzf_min_version = get(g:, 'omarchy_fzf_min_version', '0.38.0')
let g:omarchy_use_fzf = get(g:, 'omarchy_use_fzf', -1)
let g:omarchy_python_format_imports = get(g:, 'omarchy_python_format_imports', 1)
let g:omarchy_python_keyword_completion = get(g:, 'omarchy_python_keyword_completion', 1)
let g:omarchy_python_keyword_completion_min_chars = get(g:, 'omarchy_python_keyword_completion_min_chars', 3)
let g:omarchy_python_keyword_completion_max_lines = get(g:, 'omarchy_python_keyword_completion_max_lines', 5000)
let g:omarchy_timeoutlen = get(g:, 'omarchy_timeoutlen', 350)
let g:omarchy_ttimeoutlen = get(g:, 'omarchy_ttimeoutlen', 50)
let g:omarchy_visual_paste_preserve_register = get(g:, 'omarchy_visual_paste_preserve_register', 1)
let g:omarchy_statusline_mode_colors = get(g:, 'omarchy_statusline_mode_colors', 1)
let g:omarchy_file_explorer_focus = get(g:, 'omarchy_file_explorer_focus', 0)
let g:omarchy_terminal_root_strategy = get(g:, 'omarchy_terminal_root_strategy', 'project')
let g:omarchy_terminal_height = get(g:, 'omarchy_terminal_height', 15)
let g:omarchy_terminal_command = get(g:, 'omarchy_terminal_command', executable('bash') ? 'bash --login -i' : '')

" Python tooling profile: default no-Node setup.
" Dependencies: python-lsp-server and ruff, usually installed with pip/pipx.
" Install: python -m pip install "python-lsp-server[rope]" ruff
" Optional extra pylsp code actions: python -m pip install pylsp-rope
" Arch: sudo pacman -S python-lsp-server python-rope ruff
" Debian stable: sudo apt install python3-pylsp python3-rope python3-pylsp-rope pipx; pipx install ruff
" Tradeoff: keeps the toolchain Python-only. The LSP starts asynchronously
" after a Python buffer opens, after cheap ALE/server prerequisite checks.
let g:omarchy_python_lsp = get(g:, 'omarchy_python_lsp', 'pylsp')
let g:omarchy_python_linters = get(g:, 'omarchy_python_linters', ['ruff'])
let g:omarchy_python_lsp_on_open = get(g:, 'omarchy_python_lsp_on_open', 1)
let g:omarchy_python_lint_on_open = get(g:, 'omarchy_python_lint_on_open', 0)
let g:omarchy_python_lint_on_open_delay = get(g:, 'omarchy_python_lint_on_open_delay', 500)
let g:omarchy_python_references_command = get(g:, 'omarchy_python_references_command', 'ALEFindReferences -quickfix')
let g:omarchy_python_tools_env = get(g:, 'omarchy_python_tools_env', expand('~/.venvs/vim-tools'))
let g:omarchy_python_project_env = get(g:, 'omarchy_python_project_env', '')

" Python tooling profile: basic Node-available setup.
" Dependencies: pyright-langserver from npm, ruff from the editor tools env.
" Install: npm install -g pyright; ~/.venvs/vim-tools/bin/python -m pip install ruff
" Arch: sudo pacman -S pyright ruff
" Debian stable: sudo apt install nodejs npm pipx; sudo npm install -g pyright; pipx install ruff
" Tradeoff: Pyright generally gives stronger type-aware navigation and
" diagnostics than pylsp, while ruff keeps linting fast.
" let g:omarchy_python_lsp = 'pyright'
" let g:omarchy_python_linters = ['ruff']
" let g:omarchy_python_lsp_on_open = 1
" let g:omarchy_python_lint_on_open = 0
" let g:omarchy_python_lint_on_open_delay = 500
" let g:omarchy_python_references_command = 'ALEFindReferences -quickfix'

" Python tooling profile: stronger Python analysis.
" Dependencies: pyright-langserver from npm, ruff and pylint from the editor tools env.
" Install: npm install -g pyright; ~/.venvs/vim-tools/bin/python -m pip install ruff pylint
" Arch: sudo pacman -S pyright ruff python-pylint
" Debian stable: sudo apt install nodejs npm pylint pipx; sudo npm install -g pyright; pipx install ruff
" Tradeoff: more complete diagnostics, but pylint can be slow and noisy. Prefer
" this for larger projects or when the environment has already proven fast.
" let g:omarchy_python_lsp = 'pyright'
" let g:omarchy_python_linters = ['ruff', 'pylint']
" let g:omarchy_python_lsp_on_open = 1
" let g:omarchy_python_lint_on_open = 0
" let g:omarchy_python_lint_on_open_delay = 500
" let g:omarchy_python_references_command = 'ALEFindReferences -quickfix'

let g:omarchy_install_copilot = get(g:, 'omarchy_install_copilot', 0)
let g:omarchy_copilot_suggestions_start_enabled = get(g:, 'omarchy_copilot_suggestions_start_enabled', 0)
let g:omarchy_enable_copilot_cli_mapping = get(g:, 'omarchy_enable_copilot_cli_mapping', 0)
let s:python_dictionary_file = fnamemodify(s:config_file, ':h') . '/python-complete.txt'
let s:pylsp_msys_wrapper = fnamemodify(s:config_file, ':h') . '/pylsp-msys.py'
let s:python_dictionary_fallback_words = [
      \ 'False', 'None', 'True', 'and', 'as', 'assert', 'async', 'await',
      \ 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except',
      \ 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is',
      \ 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try',
      \ 'while', 'with', 'yield'
      \ ]
let s:python_dictionary_words = []
let s:python_dictionary_loaded = 0
let s:debug_log = []
let s:project_picker_root = ''

" ALE completion must be enabled before ALE loads.
let g:ale_completion_enabled = get(g:, 'ale_completion_enabled', 1)
let g:ale_completion_delay = get(g:, 'ale_completion_delay', 100)
let g:ale_lint_on_enter = get(g:, 'ale_lint_on_enter', 0)
let g:ale_lint_on_filetype_changed = get(g:, 'ale_lint_on_filetype_changed', 0)
let g:ale_lint_on_text_changed = get(g:, 'ale_lint_on_text_changed', 'never')
let g:ale_lint_on_insert_leave = get(g:, 'ale_lint_on_insert_leave', 0)
let g:ale_lint_on_save = get(g:, 'ale_lint_on_save', 1)
let g:ale_references_show_contents = get(g:, 'ale_references_show_contents', 0)
" ALE's Python root scan can block for 20+ seconds at the MSYS filesystem root.
" Ruff receives the input filename and finds configuration itself, so skip
" ALE's root-changing scan.
let g:ale_python_ruff_change_directory = get(g:, 'ale_python_ruff_change_directory', 0)

" Disable gitgutter's default maps before the plugin loads.
let g:gitgutter_map_keys = 0

if g:omarchy_install_copilot
  let g:copilot_no_tab_map = get(g:, 'copilot_no_tab_map', v:true)
  let g:copilot_enabled = get(g:, 'copilot_enabled', g:omarchy_copilot_suggestions_start_enabled ? 1 : 0)
  let g:copilot_version = get(g:, 'copilot_version', v:false)
  let g:copilot_filetypes = get(g:, 'copilot_filetypes', {
        \ 'python': v:true,
        \ 'gitcommit': v:false,
        \ 'markdown': v:true,
        \ 'text': v:true,
        \ 'help': v:false,
        \ })
endif

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

function! s:NormalizePath(path) abort
  return tolower(substitute(a:path, '\\', '/', 'g'))
endfunction

function! s:IsPluginManagedFzf(path) abort
  let l:normalized = s:NormalizePath(a:path)
  let l:plugged_fzf = s:NormalizePath(s:plug_home . '/plugged/fzf/bin/')
  return stridx(l:normalized, l:plugged_fzf) == 0 || l:normalized =~# '/plugged/fzf/bin/'
endfunction

function! s:FzfPathCandidates() abort
  let l:candidates = []

  if exists('*exepath')
    let l:path = exepath('fzf')
    if !empty(l:path)
      call add(l:candidates, l:path)
    endif
  endif

  if executable('sh')
    let l:paths = systemlist('sh -c "command -v fzf 2>/dev/null"')
    if !v:shell_error
      call extend(l:candidates, filter(l:paths, '!empty(v:val)'))
    endif
  endif

  return l:candidates
endfunction

function! s:ListUnique(items) abort
  let l:seen = {}
  let l:result = []
  for l:item in a:items
    if empty(l:item) || has_key(l:seen, l:item)
      continue
    endif
    let l:seen[l:item] = 1
    call add(l:result, l:item)
  endfor
  return l:result
endfunction

function! s:FindUpwards(start) abort
  let l:dir = empty(a:start) ? getcwd() : fnamemodify(a:start, ':p')
  let l:dirs = []
  while !empty(l:dir)
    call add(l:dirs, l:dir)
    let l:parent = fnamemodify(l:dir, ':h')
    if l:parent ==# l:dir
      break
    endif
    let l:dir = l:parent
  endwhile
  return l:dirs
endfunction

function! s:PythonVirtualenvNames() abort
  return get(g:, 'ale_virtualenv_dir_names', ['.venv', 'env', 've', 'venv', 'virtualenv', '.env'])
endfunction

function! s:PathInList(path, paths) abort
  let l:normalized = s:NormalizePath(resolve(expand(a:path)))
  for l:path in a:paths
    if s:NormalizePath(resolve(expand(l:path))) ==# l:normalized
      return 1
    endif
  endfor
  return 0
endfunction

function! s:PathUnderRoot(path, root) abort
  if empty(a:path) || empty(a:root)
    return 0
  endif
  let l:path = s:NormalizePath(resolve(expand(a:path)))
  let l:root = substitute(s:NormalizePath(resolve(expand(a:root))), '/$', '', '')
  return l:path ==# l:root || stridx(l:path, l:root . '/') == 0
endfunction

function! s:PathUnderAnyRoot(path, roots) abort
  for l:root in a:roots
    if s:PathUnderRoot(a:path, l:root)
      return 1
    endif
  endfor
  return 0
endfunction

function! s:PythonEnvList(value) abort
  let l:items = []
  if type(a:value) == v:t_list
    let l:items = copy(a:value)
  elseif type(a:value) == v:t_string && !empty(a:value)
    let l:items = [a:value]
  endif
  return map(filter(l:items, 'type(v:val) == v:t_string && !empty(v:val)'), 'expand(v:val)')
endfunction

function! s:PythonToolEnvRoots() abort
  return filter(s:PythonEnvList(get(g:, 'omarchy_python_tools_env', '')), 'isdirectory(v:val)')
endfunction

function! s:PythonEnvToolCandidates(root, tool) abort
  let l:candidates = []
  for l:path in [
        \ a:root . '/Scripts/' . a:tool . '.exe',
        \ a:root . '/Scripts/' . a:tool . '.cmd',
        \ a:root . '/Scripts/' . a:tool,
        \ a:root . '/bin/' . a:tool,
        \ a:root . '/' . a:tool . '.exe',
        \ a:root . '/' . a:tool,
        \ ]
    if filereadable(l:path)
      call add(l:candidates, l:path)
    endif
  endfor
  return l:candidates
endfunction

function! s:PythonEnvInterpreter(root) abort
  for l:path in [
        \ a:root . '/Scripts/python.exe',
        \ a:root . '/Scripts/python',
        \ a:root . '/bin/python',
        \ a:root . '/bin/python3',
        \ a:root . '/python.exe',
        \ a:root . '/python',
        \ ]
    if filereadable(l:path)
      return l:path
    endif
  endfor
  return ''
endfunction

function! s:ExternalPythonPath(path) abort
  let l:path = expand(a:path)
  if has('win32unix')
    let l:drive = matchlist(l:path, '^/\([A-Za-z]\)\(/\|$\)')
    if !empty(l:drive)
      return toupper(l:drive[1]) . ':' . strpart(l:path, 2)
    endif

    let l:cygdrive = matchlist(l:path, '^/cygdrive/\([A-Za-z]\)\(/\|$\)')
    if !empty(l:cygdrive)
      return toupper(l:cygdrive[1]) . ':' . strpart(l:path, 11)
    endif
  endif
  return l:path
endfunction

function! s:VimInternalPath(path) abort
  let l:path = substitute(a:path, '\\', '/', 'g')
  if has('win32unix')
    let l:drive = matchlist(l:path, '^\([A-Za-z]\):\(/\|$\)')
    if !empty(l:drive)
      return '/' . tolower(l:drive[1]) . strpart(l:path, 2)
    endif
  endif
  return a:path
endfunction

function! s:PythonProjectEnvRoots(buffer) abort
  let l:roots = []
  let l:filename = bufexists(a:buffer) ? fnamemodify(bufname(a:buffer), ':p') : ''
  let l:start = empty(l:filename) ? getcwd() : fnamemodify(l:filename, ':h')
  let l:project_root = s:PythonProjectRoot(a:buffer)
  let l:tool_roots = s:PythonToolEnvRoots()

  let l:explicit = getbufvar(a:buffer, 'omarchy_python_project_env', get(g:, 'omarchy_python_project_env', ''))
  call extend(l:roots, s:PythonEnvList(l:explicit))

  for l:dir in s:FindUpwards(l:start)
    for l:name in s:PythonVirtualenvNames()
      let l:root = l:dir . '/' . l:name
      if isdirectory(l:root)
        call add(l:roots, l:root)
      endif
    endfor
    if s:NormalizePath(resolve(l:dir)) ==# s:NormalizePath(l:project_root)
      break
    endif
  endfor

  if !empty($VIRTUAL_ENV) && isdirectory($VIRTUAL_ENV)
    call add(l:roots, $VIRTUAL_ENV)
  endif
  if !empty($CONDA_PREFIX) && isdirectory($CONDA_PREFIX)
    call add(l:roots, $CONDA_PREFIX)
  endif

  let l:result = []
  for l:root in s:ListUnique(l:roots)
    if !s:PathInList(l:root, l:tool_roots)
      call add(l:result, l:root)
    endif
  endfor
  return l:result
endfunction

function! s:PythonProjectInterpreter(buffer) abort
  for l:root in s:PythonProjectEnvRoots(a:buffer)
    let l:python = s:PythonEnvInterpreter(l:root)
    if !empty(l:python)
      return s:ExternalPythonPath(l:python)
    endif
  endfor
  return ''
endfunction

function! s:PythonToolCandidates(buffer, tool) abort
  let l:candidates = []

  for l:root in s:PythonToolEnvRoots()
    call extend(l:candidates, s:PythonEnvToolCandidates(l:root, a:tool))
  endfor

  if exists('*exepath')
    let l:path = exepath(a:tool)
    if !empty(l:path) && filereadable(l:path)
      call add(l:candidates, l:path)
    endif
  endif

  for l:root in s:PythonProjectEnvRoots(a:buffer)
    call extend(l:candidates, s:PythonEnvToolCandidates(l:root, a:tool))
  endfor

  return s:ListUnique(l:candidates)
endfunction

function! s:PythonExecutableCandidates(buffer, tool) abort
  " Candidates are exact readable files. Avoid executable() here: Git for
  " Windows Vim can spend seconds checking each nonexistent MSYS path.
  return s:PythonToolCandidates(a:buffer, a:tool)
endfunction

function! s:PythonResolvedTool(buffer, tool) abort
  let l:candidates = s:PythonExecutableCandidates(a:buffer, a:tool)
  return empty(l:candidates) ? '' : l:candidates[0]
endfunction

function! s:PythonInterpreterForTool(buffer, tool_path) abort
  for l:root in s:PythonToolEnvRoots() + s:PythonProjectEnvRoots(a:buffer)
    if s:PathUnderRoot(a:tool_path, l:root)
      let l:python = s:PythonEnvInterpreter(l:root)
      if !empty(l:python)
        return l:python
      endif
    endif
  endfor
  return s:PythonResolvedTool(a:buffer, 'python')
endfunction

function! s:PythonConfigurePylspProjectEnv(buffer) abort
  let l:python = s:PythonProjectInterpreter(a:buffer)
  if empty(l:python)
    return
  endif
  " If pylsp itself is already running from the project env, Jedi's default
  " environment is the right one. Avoid adding an unnecessary override.
  if s:PathUnderAnyRoot(s:PythonResolvedTool(a:buffer, 'pylsp'), s:PythonProjectEnvRoots(a:buffer))
    return
  endif

  let l:config = deepcopy(getbufvar(a:buffer, 'ale_python_pylsp_config',
        \ get(g:, 'ale_python_pylsp_config', {})))
  if type(l:config) != v:t_dict
    let l:config = {}
  endif
  if !has_key(l:config, 'pylsp') || type(l:config.pylsp) != v:t_dict
    let l:config.pylsp = {}
  endif
  if !has_key(l:config.pylsp, 'plugins') || type(l:config.pylsp.plugins) != v:t_dict
    let l:config.pylsp.plugins = {}
  endif
  if !has_key(l:config.pylsp.plugins, 'jedi') || type(l:config.pylsp.plugins.jedi) != v:t_dict
    let l:config.pylsp.plugins.jedi = {}
  endif
  if !has_key(l:config.pylsp.plugins.jedi, 'environment')
    let l:config.pylsp.plugins.jedi.environment = l:python
    call setbufvar(a:buffer, 'ale_python_pylsp_config', l:config)
  endif
endfunction

function! s:PythonConfigurePyrightProjectEnv(buffer) abort
  let l:python = s:PythonProjectInterpreter(a:buffer)
  if empty(l:python)
    return
  endif

  let l:config = deepcopy(getbufvar(a:buffer, 'ale_python_pyright_config',
        \ get(g:, 'ale_python_pyright_config', {})))
  if type(l:config) != v:t_dict
    let l:config = {}
  endif
  if !has_key(l:config, 'python') || type(l:config.python) != v:t_dict
    let l:config.python = {}
  endif
  if !has_key(l:config.python, 'pythonPath')
    let l:config.python.pythonPath = l:python
    call setbufvar(a:buffer, 'ale_python_pyright_config', l:config)
  endif
endfunction

function! s:ConfigurePythonLspProjectEnv(buffer) abort
  call s:PythonConfigurePylspProjectEnv(a:buffer)
  call s:PythonConfigurePyrightProjectEnv(a:buffer)
endfunction

function! s:PythonProjectMarkers() abort
  return [
        \ 'pyproject.toml', 'setup.cfg', 'tox.ini', 'MANIFEST.in',
        \ 'mypy.ini', '.mypy.ini', 'pycodestyle.cfg', '.flake8', '.flake8rc',
        \ 'pylama.ini', 'pylintrc', '.pylintrc', 'pyrightconfig.json',
        \ 'pyrightconfig.toml', 'Pipfile', 'Pipfile.lock', 'poetry.lock',
        \ 'ty.toml', '.tool-versions', 'uv.lock',
        \ ]
endfunction

function! s:PythonProjectRoot(buffer) abort
  let l:filename = bufexists(a:buffer) ? fnamemodify(bufname(a:buffer), ':p') : ''
  let l:start = empty(l:filename) ? getcwd() : fnamemodify(l:filename, ':h')
  let l:fallback = resolve(l:start)

  for l:dir in s:FindUpwards(l:start)
    " Never probe the MSYS or drive root. On Git for Windows those checks can
    " block for tens of seconds and may resolve to the Git installation tree.
    let l:parent = fnamemodify(l:dir, ':h')
    if l:parent ==# l:dir || l:dir ==# '/' || l:dir =~# '^[A-Za-z]:[/\\]\?$'
      break
    endif

    for l:marker in s:PythonProjectMarkers()
      if filereadable(l:dir . '/' . l:marker)
        return resolve(l:dir)
      endif
    endfor

    if isdirectory(l:dir . '/.git') || filereadable(l:dir . '/.git')
      return resolve(l:dir)
    endif
  endfor

  " A standalone script is a one-file project. Its directory is a valid pylsp
  " root and avoids an unbounded filesystem walk.
  return l:fallback
endfunction

function! s:ConfigurePythonAleTools(buffer) abort
  if !bufexists(a:buffer) || getbufvar(a:buffer, '&filetype') !=# 'python'
    return
  endif

  call s:ConfigurePythonLspProjectEnv(a:buffer)

  let l:tool_names = [tolower(get(g:, 'omarchy_python_lsp', ''))]
  call extend(l:tool_names, copy(get(g:, 'omarchy_python_linters', [])))
  call extend(l:tool_names, copy(get(get(g:, 'ale_fixers', {}), 'python', [])))
  let l:tools = {
        \ 'pylsp': 'pylsp',
        \ 'pyright': 'pyright-langserver',
        \ 'ruff': 'ruff',
        \ 'ruff_format': 'ruff',
        \ 'flake8': 'flake8',
        \ 'pylint': 'pylint',
        \ }
  let l:resolved = {}
  for l:ale_name in s:ListUnique(l:tool_names)
    if !has_key(l:tools, l:ale_name)
      continue
    endif
    let l:variable = 'ale_python_' . l:ale_name . '_executable'
    if has('win32unix') && l:ale_name ==# 'pylsp'
      " ALE otherwise combines cmd.exe syntax with MSYS paths. Run the
      " Python interpreter that owns pylsp through a small URI adapter instead.
      let l:pylsp = s:PythonResolvedTool(a:buffer, 'pylsp')
      let l:python = s:PythonInterpreterForTool(a:buffer, l:pylsp)
      if !empty(l:pylsp) && !empty(l:python) && filereadable(s:pylsp_msys_wrapper)
        let l:options = getbufvar(a:buffer, 'omarchy_python_pylsp_original_options', v:null)
        if l:options is v:null
          let l:options = getbufvar(a:buffer, 'ale_python_pylsp_options',
                \ get(g:, 'ale_python_pylsp_options', ''))
          call setbufvar(a:buffer, 'omarchy_python_pylsp_original_options', l:options)
        endif
        call setbufvar(a:buffer, 'omarchy_python_pylsp_server_executable', l:pylsp)
        call setbufvar(a:buffer, l:variable, l:python)
        call setbufvar(a:buffer, 'ale_python_pylsp_options',
              \ shellescape(s:pylsp_msys_wrapper) . (empty(l:options) ? '' : ' ' . l:options))
      endif
      continue
    endif
    let l:existing = getbufvar(a:buffer, l:variable, '')
    if !empty(l:existing) && filereadable(l:existing)
      continue
    endif
    let l:tool = l:tools[l:ale_name]
    if !has_key(l:resolved, l:tool)
      let l:resolved[l:tool] = s:PythonResolvedTool(a:buffer, l:tool)
    endif
    let l:path = l:resolved[l:tool]
    if !empty(l:path)
      call setbufvar(a:buffer, l:variable, l:path)
    endif
  endfor
endfunction

function! s:ConfigurePythonAleShell(buffer) abort
  if !has('win32unix')
    return
  endif
  " exepath('bash') can resolve to the Windows System32 WSL shim here.
  " Git Bash Vim always exposes its own shell at this MSYS path.
  if filereadable('/usr/bin/bash')
    call setbufvar(a:buffer, 'ale_shell', '/usr/bin/bash')
    call setbufvar(a:buffer, 'ale_shell_arguments', '-c')
  endif
endfunction

" Override only the Python LSP roots. Preserve a user-supplied string root or
" any existing per-linter root callbacks.
let g:ale_root = get(g:, 'ale_root', {})
if type(g:ale_root) == v:t_dict
  if !has_key(g:ale_root, 'pylsp')
    let g:ale_root.pylsp = function('<SID>PythonProjectRoot')
  endif
  if !has_key(g:ale_root, 'pyright')
    let g:ale_root.pyright = function('<SID>PythonProjectRoot')
  endif
endif

function! s:ExternalFzfPath() abort
  for l:path in s:FzfPathCandidates()
    if !s:IsPluginManagedFzf(l:path)
      return l:path
    endif
  endfor
  return ''
endfunction

function! s:SystemFzfVersion() abort
  let l:path = s:ExternalFzfPath()
  if empty(l:path)
    return ''
  endif
  let l:version = systemlist(shellescape(l:path) . ' --version')
  if v:shell_error || empty(l:version)
    return ''
  endif
  return matchstr(l:version[0], '\d\+\.\d\+\.\d\+')
endfunction

function! s:ResolveFzfFlag() abort
  if g:omarchy_use_fzf == 0
    return
  endif

  let l:version = s:SystemFzfVersion()
  let l:available = s:VersionAtLeast(l:version, g:omarchy_fzf_min_version)

  if g:omarchy_use_fzf == -1
    let g:omarchy_use_fzf = l:available
  elseif g:omarchy_use_fzf && !l:available
    let g:omarchy_use_fzf = 0
    echohl WarningMsg
    if empty(l:version)
      echom 'g:omarchy_use_fzf was set to 1, but external fzf ' . g:omarchy_fzf_min_version . '+ was not found on PATH.'
    else
      echom 'g:omarchy_use_fzf was set to 1, but external fzf is too old: ' . l:version . ' found; ' . g:omarchy_fzf_min_version . '+ required.'
    endif
    echom 'FZF integration has been disabled for this session; built-in fallback views will be used.'
    echom 'Install fzf ' . g:omarchy_fzf_min_version . '+ on PATH and rerun :PlugInstall to enable fzf.vim.'
    echohl None
  endif
endfunction

function! s:Debug(message) abort
  call add(s:debug_log, strftime('%H:%M:%S') . ' ' . a:message)
  if len(s:debug_log) > 200
    call remove(s:debug_log, 0, len(s:debug_log) - 201)
  endif
endfunction

function! s:BufferNamed(name) abort
  for l:buf in range(1, bufnr('$'))
    if bufexists(l:buf) && bufname(l:buf) ==# a:name
      return l:buf
    endif
  endfor
  return -1
endfunction

function! s:OpenScratch(title, lines) abort
  let l:title = a:title
  let l:index = 2
  while s:BufferNamed(l:title) != -1
    let l:title = a:title . ' (' . l:index . ')'
    let l:index += 1
  endwhile
  botright new
  execute 'file ' . fnameescape(l:title)
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  setlocal modifiable
  call setline(1, empty(a:lines) ? [''] : a:lines)
  setlocal nomodifiable nomodified
  normal! gg
  nnoremap <buffer><silent> q :close<CR>
endfunction

function! s:OpenPickerScratch(title, lines, sink, ...) abort
  call s:OpenScratch(a:title, a:lines)
  let b:omarchy_picker_sink = a:sink
  let b:omarchy_picker_root = get(a:, 1, '')
  nnoremap <buffer><silent> <CR> :call call(b:omarchy_picker_sink, [getline('.')])<CR>
endfunction

function! s:ClosePickerScratch() abort
  if !exists('b:omarchy_picker_sink')
    return
  endif
  let l:buf = bufnr('%')
  if winnr('$') > 1
    close
  else
    enew
  endif
  if bufexists(l:buf)
    execute 'silent! bwipeout! ' . l:buf
  endif
endfunction

function! s:WarnFzfFallback(feature) abort
  echohl WarningMsg
  echom a:feature . ': fzf is not enabled; using an unfiltered scratch-buffer fallback.'
  echom 'Install external fzf ' . g:omarchy_fzf_min_version . '+ on PATH and rerun :PlugInstall for filtering.'
  echohl None
endfunction

function! s:FzfExecutableAvailable() abort
  return s:VersionAtLeast(s:SystemFzfVersion(), g:omarchy_fzf_min_version)
endfunction

function! s:HasFzf() abort
  let l:result = g:omarchy_use_fzf && s:FzfExecutableAvailable()
        \ && (exists('*fzf#run') || exists(':FZF') == 2)
  call s:Debug('HasFzf=' . string(l:result)
        \ . ' use=' . string(g:omarchy_use_fzf)
        \ . ' executable=' . string(s:FzfExecutableAvailable())
        \ . ' fzf#run=' . string(exists('*fzf#run'))
        \ . ' :FZF=' . string(exists(':FZF') == 2))
  return l:result
endfunction

function! OmarchyFzfStatus() abort
  echo 'g:omarchy_use_fzf=' . string(g:omarchy_use_fzf)
  echo 'fzf candidates=' . string(s:FzfPathCandidates())
  echo 'fzf path=' . (empty(s:ExternalFzfPath()) ? 'none' : s:ExternalFzfPath())
  echo 'fzf version=' . (empty(s:SystemFzfVersion()) ? 'none' : s:SystemFzfVersion())
  echo 'fzf usable=' . string(s:HasFzf())
endfunction
command! OmarchyFzfStatus call OmarchyFzfStatus()

function! OmarchyDebug() abort
  if &filetype ==# 'python'
    call s:ConfigurePythonAleTools(bufnr('%'))
  endif
  let l:lines = [
        \ 'Omarchy debug',
        \ '',
        \ 'config_file=' . s:config_file,
        \ 'config_readable=' . string(filereadable(s:config_file)),
        \ 'plug_home=' . s:plug_home,
        \ 'ale_plugin_dir=' . s:ale_plugin_dir,
        \ 'ale_plugin_dir_exists=' . string(isdirectory(s:ale_plugin_dir)),
        \ 'cwd=' . getcwd(),
        \ 'shell=' . &shell,
        \ 'shellcmdflag=' . &shellcmdflag,
        \ 'shellslash=' . string(&shellslash),
        \ 'g:omarchy_use_fzf=' . string(g:omarchy_use_fzf),
        \ 'g:omarchy_python_lsp=' . string(g:omarchy_python_lsp),
        \ 'g:omarchy_python_linters=' . string(g:omarchy_python_linters),
        \ 'g:omarchy_python_lsp_on_open=' . string(g:omarchy_python_lsp_on_open),
        \ 'g:omarchy_python_lint_on_open=' . string(g:omarchy_python_lint_on_open),
        \ 'g:omarchy_python_references_command=' . string(g:omarchy_python_references_command),
        \ 'g:omarchy_python_tools_env=' . string(g:omarchy_python_tools_env),
        \ 'g:omarchy_python_project_env=' . string(g:omarchy_python_project_env),
        \ '$VIRTUAL_ENV=' . $VIRTUAL_ENV,
        \ '$CONDA_PREFIX=' . $CONDA_PREFIX,
        \ 'python project root=' . s:PythonProjectRoot(bufnr('%')),
        \ 'python tools env roots=' . string(s:PythonToolEnvRoots()),
        \ 'python project env roots=' . string(s:PythonProjectEnvRoots(bufnr('%'))),
        \ 'python project interpreter=' . s:PythonProjectInterpreter(bufnr('%')),
        \ 'buffer ALE shell=' . getbufvar(bufnr('%'), 'ale_shell', ''),
        \ 'buffer pylsp executable=' . getbufvar(bufnr('%'), 'ale_python_pylsp_executable', ''),
        \ 'buffer pylsp server executable=' . getbufvar(bufnr('%'), 'omarchy_python_pylsp_server_executable', ''),
        \ 'buffer pylsp config=' . string(getbufvar(bufnr('%'), 'ale_python_pylsp_config', get(g:, 'ale_python_pylsp_config', {}))),
        \ 'buffer pyright executable=' . getbufvar(bufnr('%'), 'ale_python_pyright_executable', ''),
        \ 'buffer pyright config=' . string(getbufvar(bufnr('%'), 'ale_python_pyright_config', get(g:, 'ale_python_pyright_config', {}))),
        \ 'pylsp MSYS wrapper=' . s:pylsp_msys_wrapper,
        \ 'buffer ruff executable=' . getbufvar(bufnr('%'), 'ale_python_ruff_executable', ''),
        \ 'pylsp tool candidates=' . string(s:PythonToolCandidates(bufnr('%'), 'pylsp')),
        \ 'pylsp executable candidates=' . string(s:PythonExecutableCandidates(bufnr('%'), 'pylsp')),
        \ 'ruff tool candidates=' . string(s:PythonToolCandidates(bufnr('%'), 'ruff')),
        \ 'ruff executable candidates=' . string(s:PythonExecutableCandidates(bufnr('%'), 'ruff')),
        \ 'g:ale_linters=' . string(g:ale_linters),
        \ 'g:ale_lint_on_enter=' . string(g:ale_lint_on_enter),
        \ 'g:ale_lint_on_filetype_changed=' . string(g:ale_lint_on_filetype_changed),
        \ 'g:ale_lint_on_text_changed=' . string(g:ale_lint_on_text_changed),
        \ 'g:ale_lint_on_insert_leave=' . string(g:ale_lint_on_insert_leave),
        \ 'g:ale_references_show_contents=' . string(g:ale_references_show_contents),
        \ ':ALEInfo command exists=' . string(exists(':ALEInfo') == 2),
        \ ':ALEGoToDefinition command exists=' . string(exists(':ALEGoToDefinition') == 2),
        \ ':ALEFindReferences command exists=' . string(exists(':ALEFindReferences') == 2),
        \ 'pylsp executable=' . string(executable('pylsp')) . ' path=' . exepath('pylsp'),
        \ 'pyright-langserver executable=' . string(executable('pyright-langserver')) . ' path=' . exepath('pyright-langserver'),
        \ 'node executable=' . string(executable('node')) . ' path=' . exepath('node'),
        \ 'ruff executable=' . string(executable('ruff')) . ' path=' . exepath('ruff'),
        \ 'pylint executable=' . string(executable('pylint')) . ' path=' . exepath('pylint'),
        \ 'fzf candidates=' . string(s:FzfPathCandidates()),
        \ 'fzf path=' . (empty(s:ExternalFzfPath()) ? 'none' : s:ExternalFzfPath()),
        \ 'fzf version=' . (empty(s:SystemFzfVersion()) ? 'none' : s:SystemFzfVersion()),
        \ 'fzf executable available=' . string(s:FzfExecutableAvailable()),
        \ 'fzf#run exists=' . string(exists('*fzf#run')),
        \ ':FZF command exists=' . string(exists(':FZF') == 2),
        \ 's:HasFzf=' . string(s:HasFzf()),
        \ '',
        \ 'Recent log:',
        \ ]
  call extend(l:lines, empty(s:debug_log) ? ['(empty)'] : copy(s:debug_log))
  call s:OpenScratch('[Omarchy debug]', l:lines)
endfunction
command! OmarchyDebug call OmarchyDebug()

" 2. vim-plug ------------------------------------------------------------------
let s:plug_file = s:plug_home . '/autoload/plug.vim'
let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

function! s:LoadPlug(...) abort
  if filereadable(s:plug_file)
    execute 'source ' . fnameescape(s:plug_file)
    return exists('*plug#begin')
  endif

  if !get(a:, 1, 0)
    echohl WarningMsg
    echom 'vim-plug is missing. Run :OmarchyPlugBootstrap to download it, then run :PlugInstall.'
    echohl None
  endif
  return 0
endfunction

function! s:BootstrapPlug() abort
  if s:LoadPlug(1)
    return 1
  endif

  if !executable('curl')
    echohl ErrorMsg
    echom 'vim-plug is missing and curl is not installed. Install curl, then run :OmarchyPlugBootstrap.'
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
  if exists('*plug#begin')
    silent! delcommand PlugInstall
    echom 'vim-plug installed. Reloading config so :PlugInstall is available.'
    execute 'source ' . fnameescape(s:config_file)
    return 1
  endif

  echohl ErrorMsg
  echom 'vim-plug was downloaded, but plug#begin was not created. Check :messages.'
  echohl None
  return 0
endfunction

function! s:PlugInstallFallback() abort
  echohl WarningMsg
  echom 'vim-plug is missing. Run :OmarchyPlugBootstrap first, then run :PlugInstall.'
  echohl None
endfunction

command! OmarchyPlugBootstrap call <SID>BootstrapPlug()
call s:LoadPlug()
call s:ResolveFzfFlag()
if exists(':PlugInstall') != 2 && !exists('*plug#begin')
  command! PlugInstall call <SID>PlugInstallFallback()
endif
if exists('*plug#begin')
  call plug#begin(s:plug_home . '/plugged')
  Plug 'dense-analysis/ale'
  if g:omarchy_use_fzf
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
  endif
  if g:omarchy_install_copilot
    Plug 'github/copilot.vim'
  endif
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
execute 'set timeoutlen=' . g:omarchy_timeoutlen
set ttimeout
execute 'set ttimeoutlen=' . g:omarchy_ttimeoutlen
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
set autoindent
set linebreak
set textwidth=0
set colorcolumn=
set foldenable
set foldlevelstart=99
set foldnestmax=10
set backspace=indent,eol,start
set completeopt=menu,menuone,noselect,noinsert
set shortmess+=c
set autoread

if has('persistent_undo')
  let s:undo_dir = has('nvim') ? stdpath('data') . '/undo' : expand('~/.vim/undo')
  if !isdirectory(s:undo_dir)
    silent! call mkdir(s:undo_dir, 'p')
  endif
  if isdirectory(s:undo_dir)
    execute 'set undodir=' . fnameescape(s:undo_dir)
  endif
  set undofile
endif

if has('termguicolors')
  set termguicolors
endif

function! s:DefineStatuslineHighlights() abort
  if !g:omarchy_statusline_mode_colors
    return
  endif
  highlight OmarchyModeNormal ctermfg=White guifg=#d0d0d0
  highlight OmarchyModeInsert ctermfg=Yellow guifg=#ff9e2c
  highlight OmarchyModeVisual ctermfg=Blue guifg=#5fafff
  highlight OmarchyModeOther ctermfg=Green guifg=#87d787
endfunction

call s:DefineStatuslineHighlights()

augroup omarchy_statusline_colors
  autocmd!
  autocmd ColorScheme * call <SID>DefineStatuslineHighlights()
augroup END

augroup omarchy_checktime
  autocmd!
  autocmd BufEnter,CursorHold * silent! checktime
  if exists('##FocusGained')
    autocmd FocusGained * silent! checktime
  endif
augroup END

augroup omarchy_filetypes
  autocmd!
  autocmd BufRead,BufNewFile *.bash setfiletype bash
  autocmd BufRead,BufNewFile *.bq.sql,*.bigquery.sql setfiletype sql
augroup END

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
  if index(['Buffers', 'BLines', 'Files', 'GFiles', 'Maps', 'Rg'], l:name) >= 0
        \ && !s:HasFzf()
    echo 'fzf is not enabled. Install external fzf ' . g:omarchy_fzf_min_version . '+ on PATH and rerun :PlugInstall.'
    return
  endif
  if s:CommandExists(l:name)
    execute a:command
  else
    echo l:name . ' is not available. Run :PlugInstall or check the README.'
  endif
endfunction

function! s:InGitRepo() abort
  return executable('git') && system('git rev-parse --is-inside-work-tree 2>/dev/null') =~# 'true'
endfunction

function! s:GitRootForDir(dir) abort
  if !executable('git')
    return ''
  endif
  try
    let l:root = systemlist('git -C ' . shellescape(a:dir) . ' rev-parse --show-toplevel 2>/dev/null')
  catch
    return ''
  endtry
  if v:shell_error || empty(l:root) || empty(l:root[0]) || l:root[0] ==# '-1'
    return ''
  endif
  let l:root = s:VimInternalPath(l:root[0])
  return isdirectory(l:root) ? l:root : ''
endfunction

function! s:OpenFileSink(line) abort
  let l:file = matchstr(a:line, '^\s*\zs.\{-}\ze\s*$')
  if empty(l:file)
    return
  endif
  if exists('b:omarchy_picker_root') && !empty(b:omarchy_picker_root)
        \ && fnamemodify(l:file, ':p') !=# l:file
    let l:file = b:omarchy_picker_root . '/' . l:file
  endif
  execute 'edit ' . fnameescape(l:file)
endfunction

function! s:OpenFileRight(file, focus_new) abort
  if empty(a:file)
    return
  endif
  let l:origin = exists('*win_getid') ? win_getid() : -1
  execute 'rightbelow vertical split ' . fnameescape(a:file)
  if !a:focus_new && l:origin > 0 && exists('*win_gotoid')
    call win_gotoid(l:origin)
  endif
endfunction

function! s:OpenBufferRight(buffer, focus_new) abort
  if a:buffer <= 0 || !bufexists(a:buffer)
    echo 'Buffer does not exist.'
    return
  endif
  let l:origin = exists('*win_getid') ? win_getid() : -1
  execute 'rightbelow vertical sbuffer ' . a:buffer
  if !a:focus_new && l:origin > 0 && exists('*win_gotoid')
    call win_gotoid(l:origin)
  endif
endfunction

function! s:OpenCurrentBufferRight() abort
  call s:OpenBufferRight(bufnr('%'), 1)
endfunction

function! s:OpenFileRightSink(line) abort
  let l:file = matchstr(a:line, '^\s*\zs.\{-}\ze\s*$')
  if empty(l:file)
    return
  endif
  let l:root = exists('b:omarchy_picker_root') && !empty(b:omarchy_picker_root)
        \ ? b:omarchy_picker_root
        \ : s:project_picker_root
  if !empty(l:root)
        \ && fnamemodify(l:file, ':p') !=# l:file
    let l:file = l:root . '/' . l:file
  endif
  call s:ClosePickerScratch()
  call s:OpenFileRight(l:file, 1)
endfunction

function! s:OpenBufferLineSink(line) abort
  let l:lnum = str2nr(matchstr(a:line, '^\s*\zs\d\+'))
  if l:lnum <= 0
    return
  endif
  execute l:lnum
  normal! zvzz
endfunction

function! s:OpenGrepSink(line) abort
  let l:parts = matchlist(a:line, '^\(.\{-}\):\(\d\+\):')
  if empty(l:parts)
    return
  endif
  execute 'edit ' . fnameescape(l:parts[1])
  execute str2nr(l:parts[2])
  normal! zvzz
endfunction

function! s:FzfRun(spec) abort
  if !s:HasFzf()
    call s:Debug('FzfRun skipped')
    return 0
  endif
  if !exists('*fzf#run') || !exists('*fzf#wrap')
    call s:Debug('FzfRun skipped; fzf#run/fzf#wrap missing')
    return 0
  endif
  try
    call s:Debug('FzfRun entering fzf#run')
    call fzf#run(fzf#wrap(a:spec))
    call s:Debug('FzfRun returned success')
    return 1
  catch
    call s:Debug('FzfRun caught error: ' . v:exception)
    return 0
  endtry
endfunction

function! s:BufferPickerLine(buffer) abort
  let l:name = bufname(a:buffer)
  if empty(l:name)
    let l:name = '[No Name]'
  else
    let l:name = fnamemodify(l:name, ':~:.')
  endif
  let l:current = a:buffer == bufnr('%') ? '%' : ' '
  let l:modified = getbufvar(a:buffer, '&modified') ? '+' : ' '
  return printf('%3d %s%s %s', a:buffer, l:current, l:modified, l:name)
endfunction

function! s:BufferPickerSink(line) abort
  let l:buffer = str2nr(matchstr(a:line, '^\s*\zs\d\+'))
  if l:buffer <= 0 || !bufexists(l:buffer)
    return
  endif
  call s:ClosePickerScratch()
  execute 'buffer ' . l:buffer
endfunction

function! s:BufferPickerSplitSink(line) abort
  let l:buffer = str2nr(matchstr(a:line, '^\s*\zs\d\+'))
  if l:buffer <= 0 || !bufexists(l:buffer)
    return
  endif
  call s:ClosePickerScratch()
  call s:OpenBufferRight(l:buffer, 1)
endfunction

function! s:BufferPicker() abort
  if s:HasFzf() && s:CommandExists('Buffers')
    Buffers
    return
  endif

  let l:items = []
  for l:buffer in range(1, bufnr('$'))
    if buflisted(l:buffer)
      call add(l:items, s:BufferPickerLine(l:buffer))
    endif
  endfor
  if empty(l:items)
    echo 'No listed buffers.'
    return
  endif
  if !s:HasFzf()
    call s:WarnFzfFallback('Buffers')
  endif
  call s:OpenPickerScratch('[Omarchy buffers]', l:items, function('<SID>BufferPickerSink'))
endfunction

function! s:BufferPickerWithSink(prompt, sink) abort
  let l:items = []
  for l:buffer in range(1, bufnr('$'))
    if buflisted(l:buffer)
      call add(l:items, s:BufferPickerLine(l:buffer))
    endif
  endfor
  if empty(l:items)
    echo 'No listed buffers.'
    return
  endif
  if s:FzfRun({
        \ 'source': l:items,
        \ 'sink': a:sink,
        \ 'options': '--prompt="' . a:prompt . '> " --no-multi'
        \ })
    return
  endif
  call s:OpenPickerScratch('[Omarchy ' . tolower(a:prompt) . ']', l:items, a:sink)
endfunction

function! s:BuffersVsplit() abort
  call s:BufferPickerWithSink('Buffers vsplit', function('<SID>BufferPickerSplitSink'))
endfunction

command! OmarchyBuffers call <SID>BufferPicker()
command! OmarchyBuffersVsplit call <SID>BuffersVsplit()
command! OmarchyCurrentBufferVsplit call <SID>OpenCurrentBufferRight()
" MAP: <Space><Space> | Pick open buffer; falls back without FZF
nnoremap <silent> <Space><Space> :OmarchyBuffers<CR>
" MAP: <Leader>bn | Next buffer
nnoremap <silent> <Leader>bn :bnext<CR>
" MAP: <Leader>bp | Previous buffer
nnoremap <silent> <Leader>bp :bprevious<CR>
" MAP: <Leader>bd | Delete current buffer
nnoremap <silent> <Leader>bd :bdelete<CR>
" MAP: <Leader>bo | Keep only current buffer
nnoremap <silent> <Leader>bo :call <SID>BufferOnly()<CR>
" MAP: <Leader>bV | Pick buffer and open in right vertical split
nnoremap <silent> <Leader>bV :OmarchyBuffersVsplit<CR>

" 6. files and explorer --------------------------------------------------------
let g:netrw_liststyle = get(g:, 'netrw_liststyle', 3)
let g:netrw_banner = get(g:, 'netrw_banner', 0)
let g:netrw_browse_split = get(g:, 'netrw_browse_split', 4)
let g:netrw_altfile = get(g:, 'netrw_altfile', 1)
let g:netrw_winsize = get(g:, 'netrw_winsize', -30)
let g:netrw_keepdir = get(g:, 'netrw_keepdir', 1)

function! s:NetrwWindow() abort
  for l:winnr in range(1, winnr('$'))
    let l:buf = winbufnr(l:winnr)
    if l:buf > 0 && getbufvar(l:buf, '&filetype') ==# 'netrw'
      return l:winnr
    endif
  endfor
  return -1
endfunction

function! s:NetrwCloseWindow(winnr) abort
  let l:current = winnr()
  execute a:winnr . 'wincmd w'
  if winnr('$') > 1
    close
  else
    enew
  endif
  if l:current <= winnr('$') && l:current != a:winnr
    execute l:current . 'wincmd w'
  endif
endfunction

function! s:NetrwDefaultDir() abort
  let l:file = expand('%:p')
  let l:start = !empty(l:file) ? fnamemodify(l:file, ':h') : getcwd()
  let l:root = s:GitRootForDir(l:start)
  return empty(l:root) ? l:start : l:root
endfunction

function! s:NetrwOpen(dir, ...) abort
  let l:dir = empty(a:dir) ? getcwd() : a:dir
  let l:focus_tree = a:0 ? a:1 : g:omarchy_file_explorer_focus
  let l:origin = exists('*win_getid') ? win_getid() : -1
  if !s:CommandExists('Explore')
    silent! runtime plugin/netrwPlugin.vim
  endif
  if !s:CommandExists('Explore')
    echo 'Netrw is not available in this Vim runtime.'
    return
  endif

  let l:existing = s:NetrwWindow()
  if l:existing > 0
    execute l:existing . 'wincmd w'
  else
    topleft vertical new
  endif

  execute 'Explore ' . fnameescape(l:dir)
  if g:netrw_winsize < 0
    execute 'vertical resize ' . abs(g:netrw_winsize)
  endif
  if !l:focus_tree && l:origin > 0 && exists('*win_gotoid')
    call win_gotoid(l:origin)
  endif
endfunction

function! s:NetrwToggle() abort
  let l:winnr = s:NetrwWindow()
  if l:winnr > 0
    call s:NetrwCloseWindow(l:winnr)
    return
  endif
  call s:NetrwOpen(s:NetrwDefaultDir(), g:omarchy_file_explorer_focus)
endfunction

function! s:NetrwReveal() abort
  let l:file = expand('%:p')
  if empty(l:file)
    call s:NetrwOpen(s:NetrwDefaultDir(), 1)
    return
  endif

  let l:name = expand('%:t')
  let @/ = '\V' . escape(l:name, '\')
  call s:NetrwOpen(fnamemodify(l:file, ':h'), 1)
  silent! normal! n
endfunction

function! s:NetrwHelp() abort
  help netrw-quickmap
endfunction

function! s:NetrwUnsafeKey(key) abort
  echo 'Netrw file operation key "' . a:key . '" is disabled here. Use :help netrw for explicit commands.'
endfunction

function! s:NetrwBufferSetup() abort
  setlocal number norelativenumber nowrap
  setlocal statusline=netrw:\ <CR>/l\ open\ \|\ h/-\ up\ \|\ /\ search\ \|\ ?\ help\ \|\ q\ close

  nnoremap <buffer><silent> q :call <SID>NetrwCloseWindow(winnr())<CR>
  nnoremap <buffer><silent> ? :help netrw-quickmap<CR>
  nnoremap <buffer><silent> <F1> :help netrw<CR>
  nnoremap <buffer><silent> l <CR>
  nnoremap <buffer><silent> h -
  nnoremap <buffer><silent> R :edit<CR>
  nnoremap <buffer><silent> <C-L> :edit<CR>

  nnoremap <buffer><silent><nowait> D :call <SID>NetrwUnsafeKey('D')<CR>
  nnoremap <buffer><silent><nowait> <Del> :call <SID>NetrwUnsafeKey('<Del>')<CR>
  nnoremap <buffer><silent><nowait> d :call <SID>NetrwUnsafeKey('d')<CR>
  nnoremap <buffer><silent><nowait> % :call <SID>NetrwUnsafeKey('%')<CR>
  nnoremap <buffer><silent><nowait> x :call <SID>NetrwUnsafeKey('x')<CR>
  nnoremap <buffer><silent><nowait> O :call <SID>NetrwUnsafeKey('O')<CR>
  nnoremap <buffer><silent><nowait> m :call <SID>NetrwUnsafeKey('m')<CR>
  nnoremap <buffer><silent><nowait> cd :call <SID>NetrwUnsafeKey('cd')<CR>
endfunction

augroup omarchy_netrw
  autocmd!
  autocmd FileType netrw call <SID>NetrwBufferSetup()
augroup END

command! FileExplorer call <SID>NetrwToggle()
command! FileExplorerReveal call <SID>NetrwReveal()
command! FileExplorerHelp call <SID>NetrwHelp()
" MAP: <Leader>ee | Toggle left file explorer
nnoremap <silent> <Leader>ee :FileExplorer<CR>
" MAP: <Leader>eE | Reveal current file directory in explorer
nnoremap <silent> <Leader>eE :FileExplorerReveal<CR>
" MAP: <Leader>eh | Open file explorer help
nnoremap <silent> <Leader>eh :FileExplorerHelp<CR>

if exists('g:fzf_vim')
  let g:fzf_vim.preview_window = ['right,50%,<70(up,40%)', 'ctrl-/']
else
  let g:fzf_vim = {'preview_window': ['right,50%,<70(up,40%)', 'ctrl-/']}
endif

function! s:ProjectFiles() abort
  if s:HasFzf() && s:CommandExists('GFiles') && s:InGitRepo()
    GFiles
  elseif s:HasFzf() && s:CommandExists('Files')
    Files
  else
    call s:FallbackProjectFiles()
  endif
endfunction

function! s:ProjectFileCandidates() abort
  let l:root = s:GitRootForDir(getcwd())
  if !empty(l:root)
    let l:files = systemlist('git -C ' . shellescape(l:root) . ' ls-files')
    if !v:shell_error && !empty(l:files)
      return {'root': l:root, 'files': l:files}
    endif
  endif
  return {'root': '', 'files': s:FallbackFindFiles()}
endfunction

function! s:GitFiles() abort
  if s:HasFzf() && s:InGitRepo()
    GFiles
  else
    call s:FallbackGitFiles()
  endif
endfunction

function! s:Ripgrep() abort
  if s:CommandExists('Rg') && executable('rg') && s:HasFzf()
    Rg
  else
    call s:FallbackTextSearch()
  endif
endfunction

function! s:FallbackFindFiles() abort
  if executable('find')
    let l:files = systemlist('find . -type f -not -path "*/.git/*"')
    return v:shell_error ? [] : map(l:files, 'substitute(v:val, ''^\./'', '''', '''')')
  endif

  return filter(glob('**/*', 0, 1), 'filereadable(v:val) && v:val !~# ''\v(^|[\/\\])\.git([\/\\]|$)''')
endfunction

function! s:FallbackProjectFiles() abort
  call s:WarnFzfFallback('Project files')
  let l:candidates = s:ProjectFileCandidates()
  if empty(l:candidates.files)
    echo 'No files found.'
    return
  endif
  call s:OpenPickerScratch('[project files]', l:candidates.files, function('<SID>OpenFileSink'), l:candidates.root)
endfunction

function! s:ProjectFilesVsplit() abort
  let l:candidates = s:ProjectFileCandidates()
  let s:project_picker_root = l:candidates.root
  if empty(l:candidates.files)
    echo 'No files found.'
    return
  endif
  if s:FzfRun({
        \ 'source': l:candidates.files,
        \ 'sink': function('<SID>OpenFileRightSink'),
        \ 'options': '--prompt="Files vsplit> " --no-multi'
        \ })
    return
  endif
  call s:OpenPickerScratch('[project files vsplit]', l:candidates.files, function('<SID>OpenFileRightSink'), l:candidates.root)
endfunction

command! OmarchyFilesVsplit call <SID>ProjectFilesVsplit()
command! OmarchyGrep call <SID>Ripgrep()

function! s:FallbackGitFiles() abort
  let l:root = s:GitRootForDir(getcwd())
  if empty(l:root)
    call s:FallbackProjectFiles()
    return
  endif
  call s:WarnFzfFallback('Git files')

  let l:files = systemlist('git -C ' . shellescape(l:root) . ' ls-files')
  if v:shell_error || empty(l:files)
    echo 'No git-tracked files found.'
    return
  endif
  call s:OpenPickerScratch('[git files]', l:files, function('<SID>OpenFileSink'), l:root)
endfunction

function! s:BufferLines() abort
  if !s:HasFzf()
    call s:WarnFzfFallback('Buffer lines')
  endif
  let l:items = []
  for l:lnum in range(1, line('$'))
    let l:text = getline(l:lnum)
    if !empty(l:text)
      call add(l:items, printf('%5d  %s', l:lnum, l:text))
    endif
  endfor
  if empty(l:items)
    echo 'No non-empty lines in current buffer.'
    return
  endif
  call s:OpenPickerScratch('[buffer lines]', l:items, function('<SID>OpenBufferLineSink'))
endfunction

function! s:FallbackTextSearch() abort
  call s:WarnFzfFallback('Text search')
  let l:scope = getcwd()
  let l:pattern = input('search pattern under ' . l:scope . ': ')
  if empty(l:pattern)
    return
  endif

  if executable('rg')
    let l:results = systemlist('rg --vimgrep -- ' . shellescape(l:pattern))
  elseif executable('grep')
    let l:results = systemlist('grep -RIn --exclude-dir=.git -- ' . shellescape(l:pattern) . ' .')
  else
    echo 'Install ripgrep or grep for fallback search.'
    return
  endif

  if v:shell_error && empty(l:results)
    echo 'No matches.'
    return
  endif
  call s:OpenPickerScratch('[text search]', l:results, function('<SID>OpenGrepSink'))
endfunction

" MAP: <Leader>ff | Find project files
nnoremap <silent> <Leader>ff :call <SID>ProjectFiles()<CR>
" MAP: <Leader>fV | Find project file and open in right vertical split
nnoremap <silent> <Leader>fV :OmarchyFilesVsplit<CR>
" MAP: <Leader>fg | Find git-tracked files
nnoremap <silent> <Leader>fg :call <SID>GitFiles()<CR>
" MAP: <Leader>fr | Search text with ripgrep
nnoremap <silent> <Leader>fr :OmarchyGrep<CR>
" MAP: <Leader>fl | Search current buffer lines
nnoremap <silent> <Leader>fl :call <SID>BufferLines()<CR>
" MAP: <Leader>fm | Search normal-mode maps
nnoremap <silent> <Leader>fm :call <SID>RunCommand('Maps')<CR>

" 7. ALE -----------------------------------------------------------------------
function! s:PythonAleLinters() abort
  let l:linters = []
  let l:lsp = tolower(get(g:, 'omarchy_python_lsp', ''))
  if !empty(l:lsp) && l:lsp !=# 'none'
    call add(l:linters, l:lsp)
  endif
  call extend(l:linters, copy(get(g:, 'omarchy_python_linters', [])))
  return l:linters
endfunction

function! s:DefaultAleLinters() abort
  let l:linters = {'python': s:PythonAleLinters()}
  if executable('shellcheck')
    let l:linters.sh = ['shellcheck']
    let l:linters.bash = ['shellcheck']
  endif
  if executable('sqlfluff')
    let l:linters.sql = ['sqlfluff']
  endif
  if executable('luacheck')
    let l:linters.lua = ['luacheck']
  endif
  if executable('vint')
    let l:linters.vim = ['vint']
  endif
  return l:linters
endfunction

function! s:DefaultAleFixers() abort
  let l:fixers = {'python': (g:omarchy_python_format_imports ? ['ruff', 'ruff_format'] : ['ruff_format'])}
  if executable('shfmt')
    let l:fixers.sh = ['shfmt']
    let l:fixers.bash = ['shfmt']
  endif
  if executable('sqlfluff')
    let l:fixers.sql = ['sqlfluff']
  endif
  return l:fixers
endfunction

let g:ale_linters = get(g:, 'ale_linters', s:DefaultAleLinters())
if !exists('g:ale_fixers')
  let g:ale_fixers = s:DefaultAleFixers()
endif
let g:ale_fix_on_save = get(g:, 'ale_fix_on_save', 0)
let g:ale_sign_error = get(g:, 'ale_sign_error', 'E')
let g:ale_sign_warning = get(g:, 'ale_sign_warning', 'W')
let g:ale_echo_msg_format = get(g:, 'ale_echo_msg_format', '[%linter%] %s [%severity%]')
let g:ale_hover_to_preview = get(g:, 'ale_hover_to_preview', 1)
let s:python_lsp_warning_shown = {}

function! s:SetAleOmnifunc() abort
  if s:AleCommandsAvailable(0)
    setlocal omnifunc=ale#completion#OmniFunc
  endif
endfunction

function! s:PythonLspStarted(linter, details) abort
  call s:Debug('Python LSP started: ' . get(a:linter, 'name', 'unknown'))
endfunction

function! s:PythonLspInstallHint(name) abort
  if a:name ==# 'pylsp'
    return 'Install python-lsp-server in g:omarchy_python_tools_env or put pylsp on PATH; project virtualenvs are used for import analysis, not as the preferred editor tool source.'
  endif
  if a:name ==# 'pyright'
    return 'Install pyright so pyright-langserver is in g:omarchy_python_tools_env or on PATH, or use the no-Node pylsp profile.'
  endif
  return 'Install the configured language server in g:omarchy_python_tools_env or on PATH, or set g:omarchy_python_lsp = "".'
endfunction

function! s:PythonLspExecutableName(buffer, name) abort
  if a:name ==# 'pylsp'
    return getbufvar(a:buffer, 'ale_python_pylsp_executable', get(g:, 'ale_python_pylsp_executable', 'pylsp'))
  endif
  if a:name ==# 'pyright'
    return getbufvar(a:buffer, 'ale_python_pyright_executable', get(g:, 'ale_python_pyright_executable', 'pyright-langserver'))
  endif
  return a:name
endfunction

function! s:ExecutableLooksLikePath(executable_name) abort
  return a:executable_name =~# '[/\\]'
endfunction

function! s:PythonExecutableAvailable(executable_name) abort
  " Exact virtualenv paths were already resolved as readable files. Calling
  " executable() repeatedly for them is disproportionately slow in MSYS Vim.
  return s:ExecutableLooksLikePath(a:executable_name)
        \ ? filereadable(a:executable_name)
        \ : executable(a:executable_name)
endfunction

function! s:PythonConfiguredLspPrereqsAvailable(buffer, noisy) abort
  let l:name = tolower(get(g:, 'omarchy_python_lsp', ''))
  if empty(l:name) || l:name ==# 'none'
    if a:noisy
      echo 'Python LSP is disabled. Set g:omarchy_python_lsp to "pylsp" or "pyright" to enable language actions.'
    endif
    return 0
  endif

  call s:ConfigurePythonAleTools(a:buffer)
  let l:executable = s:PythonLspExecutableName(a:buffer, l:name)
  let l:candidates = s:ExecutableLooksLikePath(l:executable)
        \ ? [l:executable]
        \ : s:PythonToolCandidates(a:buffer, l:executable)
  let l:available = !empty(filter(copy(l:candidates), 's:PythonExecutableAvailable(v:val)'))

  if !l:available
    if a:noisy && !has_key(s:python_lsp_warning_shown, l:name)
      echohl WarningMsg
      echom 'Python LSP "' . l:name . '" is configured, but executable "' . l:executable . '" is not available in g:omarchy_python_tools_env, PATH, or fallback project envs. ' . s:PythonLspInstallHint(l:name)
      echohl None
      let s:python_lsp_warning_shown[l:name] = 1
    endif

    call s:Debug('Python LSP prerequisite unavailable: ' . l:name . ' executable=' . l:executable)
    return 0
  endif

  if l:name ==# 'pyright' && !executable('node')
    if a:noisy && !has_key(s:python_lsp_warning_shown, l:name . ':node')
      echohl WarningMsg
      echom 'Python LSP "pyright" requires Node.js, but executable "node" is not available. Install Node.js or use the no-Node pylsp profile.'
      echohl None
      let s:python_lsp_warning_shown[l:name . ':node'] = 1
    endif

    call s:Debug('Python LSP prerequisite unavailable: pyright requires node')
    return 0
  endif

  return 1
endfunction

function! s:AleLspInstallHint() abort
  return 'ALE is not loaded. Run :PlugInstall inside this Vim; installing pylsp/ruff with pip only installs Python tools, not the Vim ALE plugin. This config installs vim-plug plugins under ' . s:ale_plugin_dir . '.'
endfunction

function! s:AleCommandsAvailable(noisy) abort
  if exists(':ALEInfo') == 2
    return 1
  endif

  if a:noisy
    echohl WarningMsg
    echom s:AleLspInstallHint()
    echohl None
  endif

  call s:Debug('ALE commands unavailable')
  return 0
endfunction

function! s:PythonConfiguredLintPrereqsAvailable(buffer, noisy) abort
  let l:configured = copy(get(g:, 'omarchy_python_linters', []))
  if empty(l:configured)
    return 0
  endif
  if !s:AleCommandsAvailable(a:noisy)
    return 0
  endif

  call s:ConfigurePythonAleTools(a:buffer)
  let l:known_tools = {'ruff': 'ruff', 'flake8': 'flake8', 'pylint': 'pylint'}
  let l:available = 0
  let l:missing = []
  for l:name in l:configured
    if !has_key(l:known_tools, l:name)
      " Let ALE handle custom linters this config does not know how to resolve.
      let l:available = 1
      continue
    endif
    let l:variable = 'ale_python_' . l:name . '_executable'
    let l:executable = getbufvar(a:buffer, l:variable, get(g:, l:variable, l:known_tools[l:name]))
    if s:PythonExecutableAvailable(l:executable)
      let l:available = 1
    else
      call add(l:missing, l:known_tools[l:name])
    endif
  endfor

  if a:noisy && !empty(l:missing)
    echohl WarningMsg
    echom 'Python linters unavailable: ' . join(l:missing, ', ') . '. Install configured tools in g:omarchy_python_tools_env or on PATH; ALE was not invoked for missing-only linting.'
    echohl None
  endif
  return l:available
endfunction

function! s:PythonEnabledLspLinters(buffer, noisy) abort
  if !s:AleCommandsAvailable(a:noisy)
    return v:null
  endif

  try
    let l:linters = ale#lsp_linter#GetEnabled(a:buffer)
    if has('win32unix')
      for l:linter in l:linters
        if get(l:linter, 'name', '') ==# 'pylsp'
          " ALE's default cwd command uses `cd /d`, which Git Bash cannot
          " execute. pylsp receives the project root in LSP initialization.
          let l:linter.cwd = ''
        endif
      endfor
    endif
    return l:linters
  catch
    if a:noisy
      echohl WarningMsg
      echom 'ALE LSP support is not available. ' . s:AleLspInstallHint() . ' (' . v:exception . ')'
      echohl None
    endif

    call s:Debug('ALE LSP unavailable: ' . v:exception)
    return v:null
  endtry
endfunction

function! s:PythonLspExecutableAvailable(buffer, linter, noisy) abort
  let l:name = get(a:linter, 'name', tolower(get(g:, 'omarchy_python_lsp', '')))
  let l:executable = l:name

  try
    let l:executable = ale#linter#GetExecutable(a:buffer, a:linter)
  catch
    call s:Debug('ALE executable lookup failed for ' . l:name . ': ' . v:exception)
  endtry

  if empty(l:executable)
    let l:executable = l:name
  endif
  if (l:name ==# 'pylsp' || l:name ==# 'pyright') && l:executable ==# l:name
    let l:executable = s:PythonLspExecutableName(a:buffer, l:name)
  endif

  try
    let l:available = ale#engine#IsExecutable(a:buffer, l:executable)
  catch
    let l:available = executable(l:executable)
    call s:Debug('ALE executable check fallback for ' . l:executable . ': ' . v:exception)
  endtry

  if l:available
    if l:name ==# 'pyright' && !executable('node')
      if a:noisy && !has_key(s:python_lsp_warning_shown, l:name . ':node')
        echohl WarningMsg
        echom 'Python LSP "pyright" requires Node.js, but executable "node" is not available. Install Node.js or use the no-Node pylsp profile.'
        echohl None
        let s:python_lsp_warning_shown[l:name . ':node'] = 1
      endif

      call s:Debug('Python LSP unavailable: pyright requires node')
      return 0
    endif
    return 1
  endif

  if a:noisy && !has_key(s:python_lsp_warning_shown, l:name)
    echohl WarningMsg
    echom 'Python LSP "' . l:name . '" is configured, but executable "' . l:executable . '" is not available. ' . s:PythonLspInstallHint(l:name)
    echohl None
    let s:python_lsp_warning_shown[l:name] = 1
  endif

  call s:Debug('Python LSP unavailable: ' . l:name . ' executable=' . l:executable)
  return 0
endfunction

function! s:PythonLspAvailableForBuffer(buffer, noisy) abort
  if !s:PythonConfiguredLspPrereqsAvailable(a:buffer, a:noisy)
    return 0
  endif

  let l:enabled_linters = s:PythonEnabledLspLinters(a:buffer, a:noisy)
  if type(l:enabled_linters) != v:t_list
    return 0
  endif

  let l:saw_lsp = 0
  for l:linter in l:enabled_linters
    if empty(get(l:linter, 'lsp', ''))
      continue
    endif

    let l:saw_lsp = 1
    if s:PythonLspExecutableAvailable(a:buffer, l:linter, a:noisy)
      return 1
    endif
  endfor

  if a:noisy && !l:saw_lsp
    echo 'No enabled Python LSP linter found. Check g:omarchy_python_lsp and g:ale_linters.'
  endif
  return 0
endfunction

function! s:RunPythonLspCommand(command) abort
  let l:name = matchstr(a:command, '^\S\+')
  if &filetype ==# 'python'
        \ && index(['ALEGoToDefinition', 'ALEFindReferences', 'ALEHover', 'ALERename', 'ALECodeAction'], l:name) >= 0
        \ && !s:PythonLspAvailableForBuffer(bufnr(''), 1)
    return
  endif

  call s:RunCommand(a:command)
endfunction

function! s:StartPythonLspForBuffer(buffer, timer) abort
  if !g:omarchy_python_lsp_on_open
        \ || !bufexists(a:buffer)
        \ || getbufvar(a:buffer, '&filetype') !=# 'python'
        \ || !s:PythonConfiguredLspPrereqsAvailable(a:buffer, 0)
    return
  endif

  let l:enabled_linters = s:PythonEnabledLspLinters(a:buffer, 0)
  if type(l:enabled_linters) != v:t_list
    return
  endif

  for l:linter in l:enabled_linters
    if !empty(get(l:linter, 'lsp', ''))
          \ && s:PythonLspExecutableAvailable(a:buffer, l:linter, 0)
      try
        call ale#lsp_linter#StartLSP(a:buffer, l:linter, function('<SID>PythonLspStarted'))
      catch
        call s:Debug('Python LSP start failed: ' . v:exception)
      endtry
    endif
  endfor
endfunction

function! s:LintPythonBuffer(buffer, timer) abort
  if !g:omarchy_python_lint_on_open
        \ || !bufexists(a:buffer)
        \ || getbufvar(a:buffer, '&filetype') !=# 'python'
        \ || !s:PythonConfiguredLintPrereqsAvailable(a:buffer, 0)
    return
  endif

  try
    call ale#Queue(0, 'lint_file', a:buffer)
  catch
    call s:Debug('Python lint-on-open failed: ' . v:exception)
  endtry
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
  if !s:python_dictionary_loaded
    let s:python_dictionary_words = filereadable(s:python_dictionary_file)
          \ ? readfile(s:python_dictionary_file)
          \ : copy(s:python_dictionary_fallback_words)
    let s:python_dictionary_loaded = 1
  endif

  for l:word in s:python_dictionary_words
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

function! s:CopilotAutoSuggestionsEnabled() abort
  if !g:omarchy_install_copilot || !get(g:, 'copilot_enabled', 0)
    return 0
  endif
  if exists('b:copilot_enabled')
    return b:copilot_enabled
  endif

  let l:filetypes = get(g:, 'copilot_filetypes', {})
  if has_key(l:filetypes, '*') && !get(l:filetypes, '*')
    return get(l:filetypes, &filetype, 0)
  endif
  return get(l:filetypes, &filetype, 1)
endfunction

function! s:MaybeAutoPythonKeywordComplete() abort
  if g:omarchy_python_keyword_completion_max_lines > 0
        \ && line('$') > g:omarchy_python_keyword_completion_max_lines
    return
  endif

  if mode() ==# 'i' && !pumvisible() && !s:CopilotAutoSuggestionsEnabled()
    call s:TriggerPythonKeywordCompletion(g:omarchy_python_keyword_completion_min_chars)
  endif
endfunction

function! s:SetupPythonCompletion() abort
  call s:ConfigurePythonAleShell(bufnr('%'))
  call s:ConfigurePythonAleTools(bufnr('%'))
  let b:ale_completion_enabled = s:AleCommandsAvailable(0)
        \ && s:PythonConfiguredLspPrereqsAvailable(bufnr('%'), 0)
  call s:SetAleOmnifunc()
  setlocal completefunc=OmarchyPythonComplete
  if exists('*timer_start')
    call timer_start(0, function('<SID>StartPythonLspForBuffer', [bufnr('%')]))
    call timer_start(g:omarchy_python_lint_on_open_delay, function('<SID>LintPythonBuffer', [bufnr('%')]))
  else
    call s:StartPythonLspForBuffer(bufnr('%'), 0)
    call s:LintPythonBuffer(bufnr('%'), 0)
  endif
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

function! s:CopilotAvailable() abort
  return g:omarchy_install_copilot && s:CommandExists('Copilot')
endfunction

function! s:SetCopilotEnabled(enabled) abort
  if !g:omarchy_install_copilot
    echo 'Copilot is not installed by this config. Set g:omarchy_install_copilot = 1 before sourcing init.vim.'
    return
  endif

  let g:copilot_enabled = a:enabled ? 1 : 0
  if s:CopilotAvailable()
    execute 'Copilot ' . (a:enabled ? 'enable' : 'disable')
    echo 'Copilot inline suggestions ' . (a:enabled ? 'enabled.' : 'disabled.')
  else
    echo 'copilot.vim is not installed yet. Run :PlugInstall after enabling g:omarchy_install_copilot.'
  endif
endfunction

function! s:ToggleCopilot() abort
  call s:SetCopilotEnabled(!get(g:, 'copilot_enabled', 0))
endfunction

function! s:CopilotStatus() abort
  if s:CopilotAvailable()
    Copilot status
  elseif g:omarchy_install_copilot
    echo 'copilot.vim is not installed yet. Run :PlugInstall.'
  else
    echo 'Copilot is not installed by this config. Set g:omarchy_install_copilot = 1 before sourcing init.vim.'
  endif
endfunction

function! s:CopilotAccept() abort
  return exists('*copilot#Accept') ? copilot#Accept('') : ''
endfunction

function! s:CopilotSuggest() abort
  if !g:omarchy_install_copilot
    echo 'Copilot is not installed by this config. Set g:omarchy_install_copilot = 1 before sourcing init.vim.'
    return
  endif

  if !s:CopilotAvailable()
    echo 'copilot.vim is not installed yet. Run :PlugInstall.'
    return
  endif

  call feedkeys((mode() ==# 'i' ? '' : 'i') . "\<Plug>(copilot-suggest)", 'm')
endfunction

function! s:TerminalRoot() abort
  let l:bufdir = expand('%:p:h')
  if g:omarchy_terminal_root_strategy ==# 'cwd'
    return getcwd()
  elseif g:omarchy_terminal_root_strategy ==# 'buffer'
    return (!empty(l:bufdir) && isdirectory(l:bufdir)) ? l:bufdir : getcwd()
  elseif g:omarchy_terminal_root_strategy !=# 'project'
    echo 'Unknown g:omarchy_terminal_root_strategy "' . g:omarchy_terminal_root_strategy . '"; using project.'
  endif

  if !empty(l:bufdir) && isdirectory(l:bufdir)
    let l:root = s:GitRootForDir(l:bufdir)
    return empty(l:root) ? l:bufdir : l:root
  endif
  let l:root = s:GitRootForDir(getcwd())
  return empty(l:root) ? getcwd() : l:root
endfunction

function! s:TerminalWindow() abort
  for l:winnr in range(1, winnr('$'))
    let l:buf = winbufnr(l:winnr)
    if l:buf > 0 && getbufvar(l:buf, 'omarchy_terminal', 0)
      return l:winnr
    endif
  endfor
  return -1
endfunction

function! s:OpenTerminal(...) abort
  if exists(':terminal') != 2
    echo 'This Vim build does not support :terminal. Open a shell outside Vim.'
    return
  endif

  let l:cmd = a:0 && !empty(a:1) ? a:1 : g:omarchy_terminal_command
  if empty(l:cmd)
    echo 'No terminal command configured. Install bash or set g:omarchy_terminal_command.'
    return
  endif

  let l:root = s:TerminalRoot()
  execute 'botright ' . g:omarchy_terminal_height . 'split'
  execute 'lcd ' . fnameescape(l:root)
  try
    execute 'terminal ' . l:cmd
    let b:omarchy_terminal = 1
    if exists('*term_getjob') || has('nvim')
      startinsert
    endif
  catch
    echohl ErrorMsg
    echom 'Could not start terminal: ' . v:exception
    echohl None
  endtry
endfunction

function! s:ToggleTerminal() abort
  let l:winnr = s:TerminalWindow()
  if l:winnr > 0
    execute l:winnr . 'wincmd w'
    close
    return
  endif
  call s:OpenTerminal()
endfunction

command! -nargs=* OmarchyTerminal call <SID>OpenTerminal(<q-args>)
command! OmarchyTerminalToggle call <SID>ToggleTerminal()

function! s:OpenCopilotCli() abort
  if !executable('copilot')
    echo 'GitHub Copilot CLI is not installed. Install the copilot command, then run :OmarchyCopilotChat or run copilot from a terminal.'
    return
  endif

  if exists(':terminal') != 2
    echo 'This Vim build does not support :terminal. Run copilot from a terminal in the project directory.'
    return
  endif

  let l:root = s:TerminalRoot()
  botright split
  execute 'lcd ' . fnameescape(l:root)
  try
    terminal copilot
  catch
    echohl ErrorMsg
    echom 'Could not start GitHub Copilot CLI: ' . v:exception
    echohl None
  endtry
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
nnoremap <silent> <Leader>ld :call <SID>RunPythonLspCommand('ALEGoToDefinition')<CR>
" MAP: <Leader>lr | ALE find references
nnoremap <silent> <Leader>lr :call <SID>RunPythonLspCommand(g:omarchy_python_references_command)<CR>
" MAP: <Leader>lh | ALE hover
nnoremap <silent> <Leader>lh :call <SID>RunPythonLspCommand('ALEHover')<CR>
" MAP: <Leader>ln | ALE rename symbol
nnoremap <silent> <Leader>ln :call <SID>RunPythonLspCommand('ALERename')<CR>
" MAP: <Leader>la | ALE code action
nnoremap <silent> <Leader>la :call <SID>RunPythonLspCommand('ALECodeAction')<CR>
" MAP: <Leader>lj | Next ALE diagnostic
nnoremap <silent> <Leader>lj :call <SID>RunCommand('ALENextWrap')<CR>
" MAP: <Leader>lk | Previous ALE diagnostic
nnoremap <silent> <Leader>lk :call <SID>RunCommand('ALEPreviousWrap')<CR>
" MAP: <Leader>lf | Run ALE fixers
nnoremap <silent> <Leader>lf :call <SID>RunCommand('ALEFix')<CR>
" MAP: <Leader>li | Show ALE info
nnoremap <silent> <Leader>li :call <SID>RunCommand('ALEInfo')<CR>
" Quickfix navigation is used for ALE references, grep results, compiler
" errors, and other list-producing commands.
" MAP: ]q | Next quickfix item
nnoremap <silent> ]q :cnext<CR>
" MAP: [q | Previous quickfix item
nnoremap <silent> [q :cprevious<CR>
" MAP: ]Q | Last quickfix item
nnoremap <silent> ]Q :clast<CR>
" MAP: [Q | First quickfix item
nnoremap <silent> [Q :cfirst<CR>
" MAP: <Leader>lq | Open quickfix list
nnoremap <silent> <Leader>lq :copen<CR>
" MAP: <Leader>lc | Close quickfix list
nnoremap <silent> <Leader>lc :cclose<CR>
command! OmarchyCopilotOn call <SID>SetCopilotEnabled(1)
command! OmarchyCopilotOff call <SID>SetCopilotEnabled(0)
command! OmarchyCopilotToggle call <SID>ToggleCopilot()
command! OmarchyCopilotStatus call <SID>CopilotStatus()
command! OmarchyCopilotSuggest call <SID>CopilotSuggest()
command! OmarchyCopilotChat call <SID>OpenCopilotCli()
" MAP: <Leader>tt | Toggle project-aware login Bash terminal
nnoremap <silent> <Leader>tt :OmarchyTerminalToggle<CR>
" MAP: <Leader>tT | Open a new project-aware login Bash terminal
nnoremap <silent> <Leader>tT :OmarchyTerminal<CR>
if g:omarchy_install_copilot
  " MAP: <Leader>at | Toggle Copilot inline suggestions
  nnoremap <silent> <Leader>at :OmarchyCopilotToggle<CR>
  " MAP: <Leader>as | Request a Copilot inline suggestion
  nnoremap <silent> <Leader>as :OmarchyCopilotSuggest<CR>
  " MAP: <C-J> | Accept Copilot inline suggestion
  inoremap <silent><script><expr> <C-J> <SID>CopilotAccept()
endif
if g:omarchy_enable_copilot_cli_mapping
  " MAP: <Leader>ac | Open GitHub Copilot CLI in a terminal split
  nnoremap <silent> <Leader>ac :OmarchyCopilotChat<CR>
endif
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

function! s:SymbolPatterns() abort
  return get({
        \ 'python': [
        \   '^\s*\(class\|async\s\+def\|def\)\s\+[A-Za-z_][A-Za-z0-9_]*',
        \ ],
        \ 'vim': [
        \   '^\s*fu\%[nction]!\?\s\+\S\+',
        \   '^\s*com\%[mand]!\?\s\+\S\+',
        \   '^\s*aug\%[roup]\s\+\S\+',
        \ ],
        \ 'lua': [
        \   '^\s*\(local\s\+\)\?function\s\+[A-Za-z_][A-Za-z0-9_\.:\-]*',
        \   '^\s*[A-Za-z_][A-Za-z0-9_\.:\-]*\s*=\s*function',
        \ ],
        \ 'sh': [
        \   '^\s*\(function\s\+\)\?[A-Za-z_][A-Za-z0-9_]*\s*()\s*{',
        \   '^\s*function\s\+[A-Za-z_][A-Za-z0-9_]*',
        \ ],
        \ 'bash': [
        \   '^\s*\(function\s\+\)\?[A-Za-z_][A-Za-z0-9_]*\s*()\s*{',
        \   '^\s*function\s\+[A-Za-z_][A-Za-z0-9_]*',
        \ ],
        \ 'javascript': [
        \   '^\s*\(export\s\+\)\?\(async\s\+\)\?function\s\+[A-Za-z_$][A-Za-z0-9_$]*',
        \   '^\s*\(export\s\+\)\?class\s\+[A-Za-z_$][A-Za-z0-9_$]*',
        \   '^\s*\(const\|let\|var\)\s\+[A-Za-z_$][A-Za-z0-9_$]*\s*=.*=>',
        \ ],
        \ 'typescript': [
        \   '^\s*\(export\s\+\)\?\(async\s\+\)\?function\s\+[A-Za-z_$][A-Za-z0-9_$]*',
        \   '^\s*\(export\s\+\)\?class\s\+[A-Za-z_$][A-Za-z0-9_$]*',
        \   '^\s*\(const\|let\|var\)\s\+[A-Za-z_$][A-Za-z0-9_$]*\s*=.*=>',
        \ ],
        \ 'markdown': [
        \   '^#\{1,6}\s\+\S',
        \ ],
        \ }, &filetype, [])
endfunction

function! s:Symbols() abort
  if &filetype ==# 'python'
    call s:PythonSymbols()
    return
  endif

  let l:patterns = s:SymbolPatterns()
  if empty(l:patterns)
    echo 'No lightweight symbol detector for filetype "' . (empty(&filetype) ? 'none' : &filetype) . '".'
    return
  endif

  let s:python_symbol_origin = bufnr('%')
  let l:items = []
  for lnum in range(1, line('$'))
    let l:line = getline(lnum)
    for l:pattern in l:patterns
      if l:line =~# l:pattern
        call add(l:items, printf('%5d  %s', lnum, substitute(l:line, '^\s*', '', '')))
        break
      endif
    endfor
  endfor

  if empty(l:items)
    echo 'No lightweight symbols found for filetype "' . &filetype . '".'
    return
  endif

  if s:FzfRun({
        \ 'source': l:items,
        \ 'sink': function('<SID>PythonSymbolSink'),
        \ 'options': '--prompt="Symbols> " --no-multi'
        \ })
    return
  endif

  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  call setline(1, l:items)
  nnoremap <buffer> <CR> :call <SID>PythonSymbolSink(getline('.'))<CR>
endfunction

command! PythonSymbols call <SID>PythonSymbols()
command! Symbols call <SID>Symbols()
" MAP: <Leader>fs | Pick current-file symbols
nnoremap <silent> <Leader>fs :Symbols<CR>

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

function! s:ModeHighlightGroup() abort
  let l:mode = mode()
  if l:mode ==# 'n'
    return 'OmarchyModeNormal'
  elseif l:mode =~# '^\(i\|ic\|ix\)$'
    return 'OmarchyModeInsert'
  elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# "\<C-v>"
    return 'OmarchyModeVisual'
  endif
  return 'OmarchyModeOther'
endfunction

function! OmarchyAleCounts() abort
  if exists('*ale#statusline#Count')
    let l:counts = ale#statusline#Count(bufnr(''))
    return printf('E:%d W:%d', get(l:counts, 'error', 0), get(l:counts, 'warning', 0))
  endif
  return ''
endfunction

function! s:StatusEscape(text) abort
  return substitute(a:text, '%', '%%', 'g')
endfunction

let s:git_root_cache = {}
let s:git_branch_cache = {}
function! s:GitInfoForBuffer(bufnr, file) abort
  if empty(a:file)
    return {}
  endif
  let l:cached = get(s:git_root_cache, a:bufnr, {})
  if get(l:cached, 'file', '') ==# a:file
    return l:cached
  endif

  let l:dir = fnamemodify(a:file, ':p:h')
  while !empty(l:dir)
    let l:dotgit = l:dir . '/.git'
    if isdirectory(l:dotgit)
      let s:git_root_cache[a:bufnr] = {'file': a:file, 'root': l:dir, 'git_dir': l:dotgit}
      return s:git_root_cache[a:bufnr]
    elseif filereadable(l:dotgit)
      let l:lines = readfile(l:dotgit, '', 1)
      let l:match = empty(l:lines) ? [] : matchlist(l:lines[0], '^gitdir:\s*\(.\+\)$')
      if !empty(l:match)
        let l:git_dir = fnamemodify(l:match[1], ':p')
        if l:match[1] !~# '^\%(/\|[A-Za-z]:[\/\\]\)'
          let l:git_dir = fnamemodify(l:dir . '/' . l:match[1], ':p')
        endif
        let s:git_root_cache[a:bufnr] = {'file': a:file, 'root': l:dir, 'git_dir': substitute(l:git_dir, '[\/\\]$', '', '')}
        return s:git_root_cache[a:bufnr]
      endif
    endif

    let l:parent = fnamemodify(l:dir, ':h')
    if l:parent ==# l:dir
      break
    endif
    let l:dir = l:parent
  endwhile

  let s:git_root_cache[a:bufnr] = {'file': a:file, 'root': '', 'git_dir': ''}
  return s:git_root_cache[a:bufnr]
endfunction

function! s:GitRootForBuffer(bufnr, file) abort
  return get(s:GitInfoForBuffer(a:bufnr, a:file), 'root', '')
endfunction

function! OmarchyRefreshGitStatus() abort
  if has_key(s:git_root_cache, bufnr(''))
    call remove(s:git_root_cache, bufnr(''))
  endif
  let s:git_branch_cache = {}
endfunction

function! OmarchyGitBranch() abort
  let l:info = s:GitInfoForBuffer(bufnr(''), expand('%:p'))
  let l:root = get(l:info, 'root', '')
  if empty(l:root)
    return ''
  endif

  let l:key = l:root
  if has_key(s:git_branch_cache, l:key)
    return s:git_branch_cache[l:key]
  endif

  let l:head_file = get(l:info, 'git_dir', '') . '/HEAD'
  if !filereadable(l:head_file)
    let s:git_branch_cache[l:key] = ''
    return ''
  endif

  let l:head = readfile(l:head_file, '', 1)
  if empty(l:head)
    let s:git_branch_cache[l:key] = ''
    return ''
  endif

  let l:branch = matchstr(l:head[0], '^ref: refs/heads/\zs.\+')
  if empty(l:branch)
    let l:branch = strpart(l:head[0], 0, 7)
  endif
  let s:git_branch_cache[l:key] = empty(l:branch) ? '' : '[' . s:StatusEscape(l:branch) . ']'
  return s:git_branch_cache[l:key]
endfunction

augroup omarchy_git_status
  autocmd!
  autocmd BufEnter,BufWritePost * call OmarchyRefreshGitStatus()
  if exists('##FocusGained')
    autocmd FocusGained * call OmarchyRefreshGitStatus()
  endif
  if exists('##ShellCmdPost')
    autocmd ShellCmdPost * call OmarchyRefreshGitStatus()
  endif
augroup END

function! OmarchyStatusline() abort
  if g:omarchy_statusline_mode_colors
    let l:left = '%#' . s:ModeHighlightGroup() . '# ' . OmarchyMode() . ' %#StatusLine#%f%m%r '
  else
    let l:left = ' ' . OmarchyMode() . ' %f%m%r '
  endif
  let l:git = OmarchyGitBranch()
  if !empty(l:git)
    let l:left .= l:git . ' '
  endif
  let l:ale = OmarchyAleCounts()
  if !empty(l:ale)
    let l:left .= l:ale . ' '
  endif
  let l:ft = s:StatusEscape(empty(&filetype) ? 'none' : &filetype)
  let l:enc = s:StatusEscape(empty(&fileencoding) ? &encoding : &fileencoding)
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
  call s:Debug('Keymaps start')
  let l:maps = []
  if filereadable(s:config_file)
    for l:line in readfile(s:config_file)
      if l:line =~# '^" MAP: '
        call add(l:maps, substitute(l:line, '^" ', '', ''))
      endif
    endfor
  endif
  call s:Debug('Keymaps collected=' . len(l:maps) . ' config_readable=' . string(filereadable(s:config_file)))

  if !empty(l:maps) && s:HasFzf()
    call s:Debug('Keymaps attempting FZF')
    if s:FzfRun({
          \ 'source': l:maps,
          \ 'sink': function('<SID>KeymapSink'),
          \ 'options': '--prompt="Keymaps> " --no-multi'
          \ })
      return
    endif
    call s:Debug('Keymaps FZF unavailable or failed; using fallback')
  else
    call s:Debug('Keymaps using fallback without FZF')
  endif

  if empty(l:maps)
    let l:maps = [
          \ 'No keymap comments were found.',
          \ '',
          \ 'Config file: ' . s:config_file,
          \ 'Config readable: ' . string(filereadable(s:config_file)),
          \ 'g:omarchy_use_fzf: ' . string(g:omarchy_use_fzf),
          \ 'External fzf path: ' . (empty(s:ExternalFzfPath()) ? 'none' : s:ExternalFzfPath()),
          \ 'External fzf version: ' . (empty(s:SystemFzfVersion()) ? 'none' : s:SystemFzfVersion()),
          \ '',
          \ 'Run :OmarchyFzfStatus for FZF diagnostics.',
          \ ]
  endif
  call s:OpenScratch('[Omarchy keymaps]', l:maps)
  nnoremap <buffer><silent> <CR> :call <SID>KeymapSink(getline('.'))<CR>
  call s:Debug('Keymaps fallback opened')
endfunction

command! Keymaps call <SID>Keymaps()
" MAP: <Leader>fk | Show config keymap reference
nnoremap <silent> <Leader>fk :Keymaps<CR>

function! s:AllMaps() abort
  let l:lines = split(execute('verbose map'), "\n")
  if empty(l:lines)
    let l:lines = ['No mappings reported by :verbose map.']
  endif
  if s:FzfRun({
        \ 'source': l:lines,
        \ 'options': '--prompt="All maps> " --no-multi'
        \ })
    return
  endif
  call s:OpenScratch('[Omarchy all maps]', l:lines)
endfunction

command! OmarchyAllMaps call <SID>AllMaps()
" MAP: <Leader>fK | Show all live key mappings
nnoremap <silent> <Leader>fK :OmarchyAllMaps<CR>

function! s:PluginPolicy() abort
  call s:OpenScratch('[Omarchy plugin policy]', [
        \ 'Opening Vim never installs, updates, cleans, upgrades, or downloads plugins.',
        \ ':OmarchyPlugBootstrap downloads only vim-plug when you explicitly run it.',
        \ ':PlugInstall installs declared plugins only when you explicitly run it.',
        \ ':PlugUpdate updates plugins only when you explicitly run it.',
        \ ':PlugClean and :PlugUpgrade are also manual vim-plug operations.',
        \ 'Optional plugins are declared only when their flags are set before sourcing init.vim.',
        \ 'This config does not use vim-plug lazy on/for triggers.',
        \ ])
endfunction

function! s:PluginUpdateLine(name, plug) abort
  let l:dir = get(a:plug, 'dir', '')
  let l:uri = get(a:plug, 'uri', '')
  if empty(l:dir) || !isdirectory(l:dir)
    return printf('%-24s not installed', a:name)
  endif
  if !executable('git')
    return printf('%-24s unknown: git not available', a:name)
  endif

  let l:local = systemlist('git -C ' . shellescape(l:dir) . ' rev-parse HEAD 2>/dev/null')
  if v:shell_error || empty(l:local)
    return printf('%-24s unknown: could not read local HEAD', a:name)
  endif

  let l:branch = get(a:plug, 'branch', '')
  if empty(l:branch)
    let l:remote_ref = systemlist('git -C ' . shellescape(l:dir) . ' symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null')
    if !v:shell_error && !empty(l:remote_ref)
      let l:branch = substitute(l:remote_ref[0], '^origin/', '', '')
    endif
  endif
  if empty(l:branch)
    let l:branch = 'HEAD'
  endif

  if empty(l:uri)
    let l:uri_lines = systemlist('git -C ' . shellescape(l:dir) . ' config --get remote.origin.url 2>/dev/null')
    let l:uri = (!v:shell_error && !empty(l:uri_lines)) ? l:uri_lines[0] : ''
  endif
  if empty(l:uri)
    return printf('%-24s unknown: no remote URL', a:name)
  endif

  let l:remote = systemlist('git ls-remote ' . shellescape(l:uri) . ' ' . shellescape(l:branch) . ' 2>/dev/null')
  if v:shell_error || empty(l:remote)
    return printf('%-24s unknown: remote ref unavailable', a:name)
  endif
  let l:remote_hash = matchstr(l:remote[0], '^\x\+')
  if empty(l:remote_hash)
    return printf('%-24s unknown: could not parse remote ref', a:name)
  endif
  return printf('%-24s %s  local %.12s remote %.12s', a:name,
        \ l:local[0] ==# l:remote_hash ? 'up-to-date' : 'update available',
        \ l:local[0], l:remote_hash)
endfunction

function! s:PlugCheckUpdates() abort
  if !exists('g:plugs') || type(g:plugs) != v:t_dict
    echo 'vim-plug plugin metadata is unavailable.'
    return
  endif
  let l:lines = [
        \ 'Remote plugin update check. This uses git ls-remote only; it does not fetch, checkout, merge, pull, or update local plugin repos.',
        \ '',
        \ ]
  for l:name in sort(keys(g:plugs))
    call add(l:lines, s:PluginUpdateLine(l:name, g:plugs[l:name]))
  endfor
  call s:OpenScratch('[Omarchy plugin updates]', l:lines)
endfunction

command! OmarchyPluginPolicy call <SID>PluginPolicy()
command! OmarchyPlugCheckUpdates call <SID>PlugCheckUpdates()

" 11. Editing helpers ----------------------------------------------------------
" MAP: jj | Leave insert mode
inoremap jj <Esc>
" MAP: jk | Leave insert mode
inoremap jk <Esc>

inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

let s:closing_delimiter_pattern = "[])}>\"'`]"
let s:left_delimiter_pattern = "[[({<\"'`]"

function! s:MovePastDelimiter(line, column, mode) abort
  let l:last_column = max([1, col([a:line, '$']) - 1])
  if a:column < l:last_column
    call cursor(a:line, a:column + 1)
    if a:mode ==# 'insert'
      startinsert
    endif
  else
    call cursor(a:line, l:last_column)
    if a:mode ==# 'insert'
      startinsert!
    endif
  endif
endfunction

function! s:JumpPastNextClosingDelimiter(mode) abort
  let l:position = getpos('.')
  if a:mode ==# 'insert' && col('.') < col('$') - 1
    call cursor(line('.'), col('.') + 1)
  endif
  let l:match = searchpos(s:closing_delimiter_pattern, 'W')
  if l:match[0] == 0
    call setpos('.', l:position)
    echo 'No next closing bracket or quote.'
    if a:mode ==# 'insert'
      startinsert
    endif
    return
  endif
  call s:MovePastDelimiter(l:match[0], l:match[1], a:mode)
endfunction

function! s:JumpPastNearestLeftDelimiter(mode) abort
  let l:position = getpos('.')
  let l:match = searchpos(s:left_delimiter_pattern, 'bW')
  if l:match[0] == 0
    call setpos('.', l:position)
    echo 'No previous left bracket or quote.'
    if a:mode ==# 'insert'
      startinsert
    endif
    return
  endif
  call s:MovePastDelimiter(l:match[0], l:match[1], a:mode)
endfunction

" MAP: jl | Jump past next closing bracket or quote
nnoremap jl :<C-U>call <SID>JumpPastNextClosingDelimiter('normal')<CR>
" MAP: jl | Insert-mode jump past next closing bracket or quote
inoremap jl <C-O>:call <SID>JumpPastNextClosingDelimiter('insert')<CR>
" MAP: jh | Jump just inside nearest left bracket or quote
nnoremap jh :<C-U>call <SID>JumpPastNearestLeftDelimiter('normal')<CR>
" MAP: jh | Insert-mode jump just inside nearest left bracket or quote
inoremap jh <C-O>:call <SID>JumpPastNearestLeftDelimiter('insert')<CR>

function! s:CycleLineNumbers() abort
  if &number && &relativenumber
    setlocal number norelativenumber
    echo 'Line numbers: absolute'
  elseif &number
    setlocal nonumber norelativenumber
    echo 'Line numbers: off'
  else
    setlocal number relativenumber
    echo 'Line numbers: absolute + relative'
  endif
endfunction

command! OmarchyLineNumbersToggle call <SID>CycleLineNumbers()
" MAP: <Leader>nn | Cycle line numbers
nnoremap <silent> <Leader>nn :OmarchyLineNumbersToggle<CR>
" MAP: <F8> | Cycle line numbers
nnoremap <silent> <F8> :OmarchyLineNumbersToggle<CR>

function! s:ToggleSearchHighlight() abort
  set hlsearch!
  echo 'Search highlighting: ' . (&hlsearch ? 'on' : 'off')
endfunction

command! OmarchyToggleHighlight call <SID>ToggleSearchHighlight()

function! s:ToggleZero() abort
  let l:line = getline('.')
  let l:last_column = max([1, col('$') - 1])
  let l:first_non_space = match(l:line, '\S') + 1
  if l:first_non_space <= 0
    let l:first_non_space = 1
  endif
  if l:line =~# '\S'
    let l:last_non_space = match(l:line, '\s*$')
    if l:last_non_space <= 0
      let l:last_non_space = l:last_column
    endif
  else
    let l:last_non_space = l:last_column
  endif

  let l:current = col('.')
  if l:current == 1 && l:first_non_space != 1
    call cursor(line('.'), l:first_non_space)
  elseif l:current == l:first_non_space && l:last_non_space != l:first_non_space
    call cursor(line('.'), l:last_non_space)
  elseif l:current == l:last_non_space && l:last_column != l:last_non_space
    call cursor(line('.'), l:last_column)
  elseif l:current == l:last_column
    call cursor(line('.'), 1)
  else
    call cursor(line('.'), 1)
  endif
endfunction

" MAP: 0 | Cycle first column, first text, last text, and last column
nnoremap <silent> 0 :call <SID>ToggleZero()<CR>

function! s:CommentPrefix() abort
  return get({
        \ 'python': '#',
        \ 'sh': '#',
        \ 'bash': '#',
        \ 'zsh': '#',
        \ 'markdown': '<!--',
        \ 'sql': '--',
        \ 'vim': '"',
        \ 'lua': '--',
        \ 'javascript': '//',
        \ 'typescript': '//',
        \ 'html': '<!--',
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
    elseif l:prefix ==# '<!--'
      if a:force || l:line !~# '^\s*<!--'
        call setline(lnum, substitute(l:line, '^\s*', '&<!-- ', '') . ' -->')
      else
        call setline(lnum, substitute(substitute(l:line, '^\s*<!--\s*', '', ''), '\s*-->\s*$', '', ''))
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

if g:omarchy_visual_paste_preserve_register
  " MAP: p | Paste over selection without replacing the unnamed register
  xnoremap <silent> p "_dP
endif

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
nnoremap <silent> <Leader>nh :OmarchyToggleHighlight<CR>
" MAP: <C-L> | Refresh screen
nnoremap <silent> <C-L> :redraw!<CR>
" MAP: <C-L> | Refresh screen from insert mode
inoremap <silent> <C-L> <C-O>:redraw!<CR>
" MAP: <Leader>rr | Refresh screen
nnoremap <silent> <Leader>rr :redraw!<CR>

" 12. Folding -----------------------------------------------------------------
function! s:AnyClosedFold() abort
  for l:line in range(1, line('$'))
    if foldclosed(l:line) != -1
      return 1
    endif
  endfor
  return 0
endfunction

function! s:ToggleAllFolds() abort
  if s:AnyClosedFold()
    normal! zR
    echo 'All folds opened.'
  else
    normal! zM
    echo 'All folds closed.'
  endif
endfunction

function! s:SetFoldLevel(level) abort
  if a:level !~# '^[0-9]$'
    echo 'Fold level must be 0-9.'
    return
  endif
  execute 'setlocal foldlevel=' . a:level
  echo 'Fold level: ' . a:level
endfunction

command! OmarchyToggleAllFolds call <SID>ToggleAllFolds()
command! -nargs=1 OmarchyFoldLevel call <SID>SetFoldLevel(<q-args>)

augroup omarchy_folding
  autocmd!
  autocmd FileType python setlocal foldmethod=indent
augroup END

" MAP: <Leader>zz | Toggle all folds open or closed
nnoremap <silent> <Leader>zz :OmarchyToggleAllFolds<CR>
" MAP: <Leader>z0 | Set fold level 0
nnoremap <silent> <Leader>z0 :OmarchyFoldLevel 0<CR>
" MAP: <Leader>z1 | Set fold level 1
nnoremap <silent> <Leader>z1 :OmarchyFoldLevel 1<CR>
" MAP: <Leader>z2 | Set fold level 2
nnoremap <silent> <Leader>z2 :OmarchyFoldLevel 2<CR>
" MAP: <Leader>z3 | Set fold level 3
nnoremap <silent> <Leader>z3 :OmarchyFoldLevel 3<CR>
" MAP: <Leader>z4 | Set fold level 4
nnoremap <silent> <Leader>z4 :OmarchyFoldLevel 4<CR>
" MAP: <Leader>z5 | Set fold level 5
nnoremap <silent> <Leader>z5 :OmarchyFoldLevel 5<CR>
" MAP: <Leader>z6 | Set fold level 6
nnoremap <silent> <Leader>z6 :OmarchyFoldLevel 6<CR>
" MAP: <Leader>z7 | Set fold level 7
nnoremap <silent> <Leader>z7 :OmarchyFoldLevel 7<CR>
" MAP: <Leader>z8 | Set fold level 8
nnoremap <silent> <Leader>z8 :OmarchyFoldLevel 8<CR>
" MAP: <Leader>z9 | Set fold level 9
nnoremap <silent> <Leader>z9 :OmarchyFoldLevel 9<CR>

" 13. Diff and windows ---------------------------------------------------------
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

  for l:winnr in range(1, winnr('$'))
    if getwinvar(l:winnr, '&diff')
      diffoff!
      echo 'Diff mode disabled for current tab.'
      return
    endif
  endfor

  echo 'No Omarchy diff session is active for this buffer.'
endfunction

function! s:StartDiffScratch(name, lines) abort
  let l:origin_buf = bufnr('%')
  if has_key(s:diff_sessions, l:origin_buf)
    call s:CloseDiffSession(l:origin_buf)
  endif

  topleft vertical new
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

function! s:DiffFileSink(line) abort
  let l:file = matchstr(a:line, '^\s*\zs.\{-}\ze\s*$')
  if empty(l:file)
    return
  endif
  let l:root = exists('b:omarchy_picker_root') && !empty(b:omarchy_picker_root)
        \ ? b:omarchy_picker_root
        \ : s:project_picker_root
  if !empty(l:root)
        \ && fnamemodify(l:file, ':p') !=# l:file
    let l:file = l:root . '/' . l:file
  endif
  call s:ClosePickerScratch()
  execute 'rightbelow vertical diffsplit ' . fnameescape(l:file)
  nnoremap <buffer><silent> <Leader>dq :DiffClose<CR>
  wincmd p
  nnoremap <buffer><silent> <Leader>dq :DiffClose<CR>
endfunction

function! s:DiffFile() abort
  let l:candidates = s:ProjectFileCandidates()
  let s:project_picker_root = l:candidates.root
  if empty(l:candidates.files)
    echo 'No files found.'
    return
  endif
  if s:FzfRun({
        \ 'source': l:candidates.files,
        \ 'sink': function('<SID>DiffFileSink'),
        \ 'options': '--prompt="Diff file> " --no-multi'
        \ })
    return
  endif
  call s:OpenPickerScratch('[diff file]', l:candidates.files, function('<SID>DiffFileSink'), l:candidates.root)
endfunction

function! s:DiffBufferSink(line) abort
  let l:buffer = str2nr(matchstr(a:line, '^\s*\zs\d\+'))
  if l:buffer <= 0 || !bufexists(l:buffer)
    return
  endif
  call s:ClosePickerScratch()
  let l:origin = exists('*win_getid') ? win_getid() : -1
  diffthis
  call s:OpenBufferRight(l:buffer, 1)
  diffthis
  nnoremap <buffer><silent> <Leader>dq :DiffClose<CR>
  if l:origin > 0 && exists('*win_gotoid')
    call win_gotoid(l:origin)
    nnoremap <buffer><silent> <Leader>dq :DiffClose<CR>
  endif
endfunction

function! s:DiffBuffer() abort
  call s:BufferPickerWithSink('Diff buffer', function('<SID>DiffBufferSink'))
endfunction

function! s:ListedBufferNumbers() abort
  let l:buffers = []
  for l:buffer in range(1, bufnr('$'))
    if buflisted(l:buffer)
      call add(l:buffers, l:buffer)
    endif
  endfor
  return l:buffers
endfunction

function! s:DiffSelectedBuffers(buffers) abort
  let l:buffers = []
  for l:buffer in a:buffers
    if l:buffer > 0 && bufexists(l:buffer) && index(l:buffers, l:buffer) < 0
      call add(l:buffers, l:buffer)
    endif
  endfor
  if len(l:buffers) < 2
    echo 'Select at least two buffers for a multi-buffer diff.'
    return
  endif
  if len(l:buffers) > 4
    let l:buffers = l:buffers[0:3]
    echo 'Using the first four selected buffers.'
  endif

  tabnew
  execute 'buffer ' . l:buffers[0]
  diffthis
  nnoremap <buffer><silent> <Leader>dq :DiffClose<CR>
  for l:buffer in l:buffers[1:]
    execute 'rightbelow vertical sbuffer ' . l:buffer
    diffthis
    nnoremap <buffer><silent> <Leader>dq :DiffClose<CR>
  endfor
  wincmd =
endfunction

function! s:DiffBuffersFzfSink(lines) abort
  let l:buffers = [bufnr('%')]
  for l:line in a:lines
    let l:buffer = str2nr(matchstr(l:line, '^\s*\zs\d\+'))
    if l:buffer > 0
      call add(l:buffers, l:buffer)
    endif
  endfor
  call s:DiffSelectedBuffers(l:buffers)
endfunction

function! s:DiffBuffers() abort
  let l:items = []
  for l:buffer in s:ListedBufferNumbers()
    if l:buffer != bufnr('%')
      call add(l:items, s:BufferPickerLine(l:buffer))
    endif
  endfor
  if empty(l:items)
    echo 'No other listed buffers to diff.'
    return
  endif
  if s:HasFzf() && exists('*fzf#run') && exists('*fzf#wrap')
    try
      call fzf#run(fzf#wrap({
            \ 'source': l:items,
            \ 'sink*': function('<SID>DiffBuffersFzfSink'),
            \ 'options': '--prompt="Diff buffers> " --multi'
            \ }))
      return
    catch
      call s:Debug('DiffBuffers FZF failed: ' . v:exception)
    endtry
  endif

  let l:input = input('Buffer numbers to diff with current (comma-separated): ')
  if empty(l:input)
    return
  endif
  let l:buffers = [bufnr('%')]
  for l:item in split(l:input, ',')
    call add(l:buffers, str2nr(l:item))
  endfor
  call s:DiffSelectedBuffers(l:buffers)
endfunction

function! s:DiffHelp() abort
  call s:OpenScratch('[Omarchy diff help]', [
        \ 'Omarchy diff commands:',
        \ '  <Leader>ds / :DiffSaved    diff current buffer against saved file',
        \ '  <Leader>dg / :DiffGitHead  diff current buffer against git HEAD',
        \ '  <Leader>df / :DiffFile     pick a project file to diff',
        \ '  <Leader>db / :DiffBuffer   pick an open buffer to diff',
        \ '  <Leader>dB / :DiffBuffers  diff current buffer with 1-3 picked buffers',
        \ '  <Leader>dq / :DiffClose    close Omarchy scratch diff or disable diff mode',
        \ '  <Leader>dQ / :DiffOff      disable diff mode in the current tab',
        \ '',
        \ 'Native Vim diff navigation and merge:',
        \ '  ]c       next diff hunk',
        \ '  [c       previous diff hunk',
        \ '  do       obtain change from the other window (:diffget)',
        \ '  dp       put change into the other window (:diffput)',
        \ '  :diffupdate   rescan diffs after edits',
        \ '  :diffoff!     leave diff mode in all windows',
        \ ])
endfunction

function! s:GitBlame() abort
  if s:CommandExists('Git')
    Git blame
    return
  endif

  let l:file = expand('%:p')
  if !executable('git') || empty(l:file) || !filereadable(l:file)
    echo 'git and a saved file are required for :OmarchyGitBlame.'
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

  let l:lines = systemlist('git -C ' . shellescape(l:root) . ' blame --date=short -w -- ' . shellescape(l:tracked[0]))
  if v:shell_error
    echo 'git blame failed for current file.'
    return
  endif
  call s:OpenScratch('[blame] ' . fnamemodify(l:file, ':t'), l:lines)
endfunction

function! s:FugitiveBlameCommitFromLine() abort
  let l:commit = matchstr(getline('.'), '^\^\=[*?]*\zs\x\{5,\}\ze\>')
  if empty(l:commit) || l:commit =~# '^0\+$'
    return ''
  endif
  return l:commit
endfunction

function! s:FugitiveBlameShowSubject() abort
  if &filetype !=# 'fugitiveblame' || !exists('*FugitiveExecute')
    echo 'Open a Fugitive blame buffer with :Git blame first.'
    return
  endif

  let l:commit = s:FugitiveBlameCommitFromLine()
  if empty(l:commit)
    echo 'No committed blame entry under cursor.'
    return
  endif

  let l:result = FugitiveExecute(['show', '-s', '--format=%h %s', l:commit], bufnr('%'))
  if get(l:result, 'exit_status', 1)
    echo get(get(l:result, 'stderr', []), 0, 'Could not read blame commit.')
    return
  endif

  for l:line in get(l:result, 'stdout', [])
    if !empty(l:line)
      echo l:line
      return
    endif
  endfor
  echo 'Commit has no subject.'
endfunction

command! DiffSaved call <SID>DiffSaved()
command! DiffGitHead call <SID>DiffGitHead()
command! DiffFile call <SID>DiffFile()
command! DiffBuffer call <SID>DiffBuffer()
command! DiffBuffers call <SID>DiffBuffers()
command! DiffClose call <SID>DiffClose()
command! DiffOff diffoff!
command! DiffHelp call <SID>DiffHelp()
command! OmarchyGitBlame call <SID>GitBlame()
command! OmarchyFugitiveBlameSubject call <SID>FugitiveBlameShowSubject()
" MAP: <Leader>ds | Diff buffer against saved file
nnoremap <silent> <Leader>ds :DiffSaved<CR>
" MAP: <Leader>dg | Diff buffer against git HEAD
nnoremap <silent> <Leader>dg :DiffGitHead<CR>
" MAP: <Leader>df | Pick project file to diff against current buffer
nnoremap <silent> <Leader>df :DiffFile<CR>
" MAP: <Leader>db | Pick open buffer to diff against current buffer
nnoremap <silent> <Leader>db :DiffBuffer<CR>
" MAP: <Leader>dB | Pick open buffers for 2-4 way diff
nnoremap <silent> <Leader>dB :DiffBuffers<CR>
" MAP: <Leader>dh | Show diff and merge help
nnoremap <silent> <Leader>dh :DiffHelp<CR>
" MAP: <Leader>dn | Next diff hunk
nnoremap <silent> <Leader>dn ]c
" MAP: <Leader>dN | Previous diff hunk
nnoremap <silent> <Leader>dN [c
" MAP: <Leader>du | Update diff view
nnoremap <silent> <Leader>du :diffupdate<CR>
" MAP: <Leader>dq | Close active Omarchy diff
nnoremap <silent> <Leader>dq :DiffClose<CR>
" MAP: <Leader>dQ | Turn off diff mode in current tab
nnoremap <silent> <Leader>dQ :DiffOff<CR>

function! s:WindowMaximizeToggle() abort
  if exists('t:omarchy_window_restore') && !empty(t:omarchy_window_restore)
    let l:restore = t:omarchy_window_restore
    unlet t:omarchy_window_restore
    silent! execute l:restore
    echo 'Window layout restored.'
    return
  endif
  let t:omarchy_window_restore = winrestcmd()
  wincmd _
  execute 'wincmd |'
  echo 'Window maximized.'
endfunction

command! OmarchyWindowMaximizeToggle call <SID>WindowMaximizeToggle()

" Do not add broad <C-h/j/k/l> remaps from config_endstuff.vim; they are terminal-sensitive and would conflict with the existing <C-L> refresh map.
" MAP: <Leader>wh | Vertical split
nnoremap <silent> <Leader>wh :vsplit<CR>
" MAP: <Leader>wj | Horizontal split
nnoremap <silent> <Leader>wj :split<CR>
" MAP: <Leader>wv | Vertical split
nnoremap <silent> <Leader>wv :vsplit<CR>
" MAP: <Leader>wV | Open current buffer in right vertical split
nnoremap <silent> <Leader>wV :OmarchyCurrentBufferVsplit<CR>
" MAP: <Leader>ws | Horizontal split
nnoremap <silent> <Leader>ws :split<CR>
" MAP: <Leader>w<Left> | Focus window left
nnoremap <silent> <Leader>w<Left> <C-W>h
" MAP: <Leader>w<Down> | Focus window down
nnoremap <silent> <Leader>w<Down> <C-W>j
" MAP: <Leader>w<Up> | Focus window up
nnoremap <silent> <Leader>w<Up> <C-W>k
" MAP: <Leader>w<Right> | Focus window right
nnoremap <silent> <Leader>w<Right> <C-W>l
" MAP: <Leader>wp | Close preview window
nnoremap <silent> <Leader>wp :pclose<CR>
" MAP: <Leader>wm | Toggle window maximize
nnoremap <silent> <Leader>wm :OmarchyWindowMaximizeToggle<CR>
" MAP: <Leader>ww | Toggle window maximize
nnoremap <silent> <Leader>ww :OmarchyWindowMaximizeToggle<CR>
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

" MAP: <Leader>gb | Show git blame; uses fugitive when available, otherwise git CLI
nnoremap <silent> <Leader>gb :OmarchyGitBlame<CR>

augroup omarchy_fugitive_blame
  autocmd!
  " In Fugitive blame buffers, K echoes the short commit and subject under the cursor.
  autocmd FileType fugitiveblame nnoremap <buffer><silent> K :OmarchyFugitiveBlameSubject<CR>
augroup END

if g:omarchy_use_fugitive
  " MAP: <Leader>gg | Open fugitive Git status
  nnoremap <silent> <Leader>gg :call <SID>RunCommand('Git')<CR>
  " MAP: <Leader>gd | Open fugitive diff split
  nnoremap <silent> <Leader>gd :call <SID>RunCommand('Gdiffsplit')<CR>
endif

" 14. Sessions ----------------------------------------------------------------
" Built-in session save/restore via :mksession/:source. No plugin needed.
let g:omarchy_use_sessions = get(g:, 'omarchy_use_sessions', 1)
let g:omarchy_session_dir = get(g:, 'omarchy_session_dir', expand('~/.vim/sessions'))
let g:omarchy_sessionoptions = get(g:, 'omarchy_sessionoptions', 'blank,buffers,curdir,folds,help,tabpages,winsize')

let s:session_lookup = {}

function! s:SessionDir() abort
  if !isdirectory(g:omarchy_session_dir)
    call mkdir(g:omarchy_session_dir, 'p')
  endif
  return g:omarchy_session_dir
endfunction

function! s:SessionDefaultName() abort
  let l:file = expand('%:p')
  if !empty(l:file)
    return fnamemodify(l:file, ':t:r')
  endif
  let l:dir = getcwd()
  if !empty(l:dir)
    return fnamemodify(l:dir, ':t')
  endif
  return 'default'
endfunction

function! s:SessionSanitize(name) abort
  return substitute(a:name, '[\\/:*?"<>|]', '_', 'g')
endfunction

function! s:SessionPath(name) abort
  return s:SessionDir() . '/' . s:SessionSanitize(a:name) . '.vim'
endfunction

function! s:SessionFiles() abort
  return glob(s:SessionDir() . '/*.vim', 0, 1)
endfunction

function! s:SessionBuildLookup() abort
  let s:session_lookup = {}
  for l:path in s:SessionFiles()
    let l:name = fnamemodify(l:path, ':t:r')
    let s:session_lookup[l:name] = l:path
  endfor
  return sort(keys(s:session_lookup))
endfunction

function! s:SessionNamesLine(line) abort
  return matchstr(a:line, '^\s*\zs.\{-}\ze\s*$')
endfunction

function! s:SessionSave(...) abort
  let l:name = (a:0 && !empty(a:1)) ? s:SessionSanitize(a:1) : ''
  if empty(l:name)
    let l:name = input('Session name [' . s:SessionDefaultName() . ']: ', s:SessionDefaultName())
    let l:name = s:SessionSanitize(l:name)
    if empty(l:name)
      echo 'Session save cancelled.'
      return
    endif
  endif
  let l:force = (a:0 >= 2) && a:2
  let l:path = s:SessionPath(l:name)
  if filereadable(l:path) && !l:force
    if confirm(printf('Overwrite session "%s"?', l:name), "&Yes\n&No", 1) != 1
      echo 'Session save cancelled.'
      return
    endif
  endif
  call s:SessionDir()
  let l:sessionoptions = &sessionoptions
  try
    let &sessionoptions = g:omarchy_sessionoptions
    execute 'mksession! ' . fnameescape(l:path)
  finally
    let &sessionoptions = l:sessionoptions
  endtry
  call s:Debug('SessionSave wrote: ' . l:path)
  echo 'Session saved: ' . l:name
endfunction

function! s:SessionSource(path) abort
  call s:Debug('SessionRestore sourcing: ' . a:path)
  execute 'source ' . fnameescape(a:path)
endfunction

function! s:SessionRestoreSink(line) abort
  let l:name = s:SessionNamesLine(a:line)
  if !has_key(s:session_lookup, l:name)
    return
  endif
  let l:path = s:session_lookup[l:name]
  call s:ClosePickerScratch()
  call s:SessionSource(l:path)
endfunction

function! s:SessionRestore(...) abort
  if a:0 && !empty(a:1)
    let l:path = s:SessionPath(a:1)
    if !filereadable(l:path)
      echo 'No session named "' . a:1 . '" in ' . g:omarchy_session_dir . '.'
      return
    endif
    call s:SessionSource(l:path)
    return
  endif
  let l:names = s:SessionBuildLookup()
  if empty(l:names)
    echo 'No saved sessions in ' . g:omarchy_session_dir . '.'
    return
  endif
  if s:HasFzf()
    if s:FzfRun({
          \ 'source': l:names,
          \ 'sink': function('<SID>SessionRestoreSink'),
          \ 'options': '--prompt="Sessions> " --no-multi'
          \ })
      return
    endif
  endif
  call s:WarnFzfFallback('Sessions')
  call s:OpenPickerScratch('[Omarchy sessions]', l:names, function('<SID>SessionRestoreSink'))
endfunction

function! s:SessionDeleteSink(line) abort
  let l:name = s:SessionNamesLine(a:line)
  if !has_key(s:session_lookup, l:name)
    return
  endif
  if confirm(printf('Delete session "%s"?', l:name), "&Yes\n&No", 2) == 1
    call delete(s:session_lookup[l:name])
    call s:Debug('SessionDelete removed: ' . s:session_lookup[l:name])
    echo 'Session deleted: ' . l:name
  else
    echo 'Delete cancelled.'
  endif
endfunction

function! s:SessionDelete() abort
  let l:names = s:SessionBuildLookup()
  if empty(l:names)
    echo 'No saved sessions in ' . g:omarchy_session_dir . '.'
    return
  endif
  if s:HasFzf()
    if s:FzfRun({
          \ 'source': l:names,
          \ 'sink': function('<SID>SessionDeleteSink'),
          \ 'options': '--prompt="Sessions> " --no-multi'
          \ })
      return
    endif
  endif
  call s:WarnFzfFallback('Sessions delete')
  call s:OpenPickerScratch('[Omarchy sessions]', l:names, function('<SID>SessionDeleteSink'))
endfunction

function! s:SessionList() abort
  let l:names = s:SessionBuildLookup()
  if empty(l:names)
    echo 'No saved sessions in ' . g:omarchy_session_dir . '.'
    return
  endif
  let l:lines = map(l:names, 'v:val . "  ->  " . s:session_lookup[v:val]')
  call s:OpenScratch('[Omarchy sessions]', l:lines)
endfunction

function! OmarchySessionStatus() abort
  echo 'g:omarchy_use_sessions=' . string(g:omarchy_use_sessions)
  echo 'g:omarchy_session_dir=' . g:omarchy_session_dir
  echo 'g:omarchy_sessionoptions=' . g:omarchy_sessionoptions
  echo 'saved session count=' . len(s:SessionFiles())
endfunction

if g:omarchy_use_sessions
  command! -nargs=? -bang SessionSave call <SID>SessionSave(<q-args>, <bang>0)
  command! -nargs=? SessionRestore call <SID>SessionRestore(<q-args>)
  command! SessionList call <SID>SessionList()
  command! SessionDelete call <SID>SessionDelete()
  command! OmarchySessionStatus call OmarchySessionStatus()

  " MAP: <Leader>s | Session prefix guard; no-op on incomplete session key
  nnoremap <silent> <Leader>s <Nop>
  " MAP: <Leader>ss | Save current session
  nnoremap <silent> <Leader>ss :SessionSave<CR>
  " MAP: <Leader>sr | Restore a saved session
  nnoremap <silent> <Leader>sr :SessionRestore<CR>
  " MAP: <Leader>sl | List saved sessions
  nnoremap <silent> <Leader>sl :SessionList<CR>
  " MAP: <Leader>sd | Delete a saved session
  nnoremap <silent> <Leader>sd :SessionDelete<CR>
endif

" Final settings that must run after plugin and mapping setup.
silent! set shortmess-=S
