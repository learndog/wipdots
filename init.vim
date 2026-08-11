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
set autoindent
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
  let l:root = systemlist('git -C ' . shellescape(a:dir) . ' rev-parse --show-toplevel 2>/dev/null')
  return v:shell_error || empty(l:root) ? '' : l:root[0]
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
  if s:HasFzf() && s:CommandExists('GFiles') && s:InGitRepo()
    GFiles
  elseif s:HasFzf() && s:CommandExists('Files')
    Files
  else
    call s:FallbackProjectFiles()
  endif
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
  let l:root = s:GitRootForDir(getcwd())
  if !empty(l:root)
    let l:files = systemlist('git -C ' . shellescape(l:root) . ' ls-files')
    if !v:shell_error && !empty(l:files)
      call s:OpenPickerScratch('[project files]', l:files, function('<SID>OpenFileSink'), l:root)
      return
    endif
  endif

  let l:files = s:FallbackFindFiles()
  if empty(l:files)
    echo 'No files found.'
    return
  endif
  call s:OpenPickerScratch('[project files]', l:files, function('<SID>OpenFileSink'))
endfunction

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
" MAP: <Leader>fg | Find git-tracked files
nnoremap <silent> <Leader>fg :call <SID>GitFiles()<CR>
" MAP: <Leader>fr | Search text with ripgrep
nnoremap <silent> <Leader>fr :call <SID>Ripgrep()<CR>
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

let g:ale_linters = get(g:, 'ale_linters', {'python': s:PythonAleLinters()})
if !exists('g:ale_fixers')
  let g:ale_fixers = {'python': (g:omarchy_python_format_imports ? ['ruff', 'ruff_format'] : ['ruff_format'])}
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

function! s:CopilotCliRoot() abort
  let l:bufdir = expand('%:p:h')
  if !empty(l:bufdir) && isdirectory(l:bufdir)
    let l:root = s:GitRootForDir(l:bufdir)
    return empty(l:root) ? l:bufdir : l:root
  endif

  let l:root = s:GitRootForDir(getcwd())
  return empty(l:root) ? getcwd() : l:root
endfunction

function! s:OpenCopilotCli() abort
  if !executable('copilot')
    echo 'GitHub Copilot CLI is not installed. Install the copilot command, then run :OmarchyCopilotChat or run copilot from a terminal.'
    return
  endif

  if exists(':terminal') != 2
    echo 'This Vim build does not support :terminal. Run copilot from a terminal in the project directory.'
    return
  endif

  let l:root = s:CopilotCliRoot()
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
command! OmarchyCopilotOn call <SID>SetCopilotEnabled(1)
command! OmarchyCopilotOff call <SID>SetCopilotEnabled(0)
command! OmarchyCopilotToggle call <SID>ToggleCopilot()
command! OmarchyCopilotStatus call <SID>CopilotStatus()
command! OmarchyCopilotSuggest call <SID>CopilotSuggest()
command! OmarchyCopilotChat call <SID>OpenCopilotCli()
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
  let l:left = ' ' . OmarchyMode() . ' %f%m%r '
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

" 13. Sessions ----------------------------------------------------------------
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

  " MAP: <Leader>ss | Save current session
  nnoremap <silent> <Leader>ss :SessionSave<CR>
  " MAP: <Leader>sr | Restore a saved session
  nnoremap <silent> <Leader>sr :SessionRestore<CR>
  " MAP: <Leader>sl | List saved sessions
  nnoremap <silent> <Leader>sl :SessionList<CR>
  " MAP: <Leader>sd | Delete a saved session
  nnoremap <silent> <Leader>sd :SessionDelete<CR>
endif
