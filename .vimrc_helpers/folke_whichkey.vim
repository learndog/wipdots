" Configure FOLKE which-key.nvim

"Required by which-key. Default is 1000 (one sec)
set timeoutlen=500

lua << EOF
require("which-key").setup({
  event = "VeryLazy",
})
EOF

" nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
" 
" 
" " nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
" " nnoremap <silent> <localleader> :<c-u>WhichKey  '<Space>'<CR>
" 
" nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
" vnoremap <silent> <leader> :WhichKeyVisual '<Space>'<CR>
" nnoremap <silent> <localleader> :WhichKey  '<Space>'<CR>
" 
