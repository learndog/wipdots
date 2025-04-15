" #### SECTION: Buffer Selection
" There are three main buffer pickers in this config
" 1. This set of keymaps with :ls extended for selection (<Leader>b)
" 2. This function (<Leader>bb - typed fast)
" 3. fzf/fzf.vim has a builtin buffer selector (<Leader><Space>) - see non-lsp fzf config

" 1. Use this <Leader>b only if the fzf version is not avail
nnoremap <Leader>b :ls<CR>:b<Space>
nnoremap <Leader>bn :bn<CR>
nnoremap <Leader>bp :bp<CR>
nnoremap <Leader>bf :bf<CR>
nnoremap <Leader>bl :bl<CR>

" 2. A new command :B
command! -nargs=0 B call ListBuffers()
" Without fzf
" nnoremap <Leader>bb :B<CR>
" vnoremap <Leader>bb :B<CR>
" With fzf
nnoremap <Leader>bb :Buffer<CR>
vnoremap <Leader>bb :Buffer<CR>
function! ListBuffers()
    let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    let i = 1
    let buffer_list = []
    for buffer in buffers
        let buffer_list += [printf("%d: %s", i, bufname(buffer))]
        let i += 1
    endfor
    let choice = inputlist(['Select a buffer:'] + buffer_list)
    if choice > 0 && choice <= len(buffers)
        execute 'buffer' buffers[choice - 1]
    endif
endfunction

