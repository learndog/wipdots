" #### SECTION: CONFIGURE NVIM-TREE
" #### Dependencies: vim 0.8.0
" #### Optional: nvim-web-devicons and patched font in terminal

lua << EOF
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
EOF

" Initialize nvim-tree
lua << EOF
require("nvim-tree").setup({
   sort_by = "case_sensitive",
   view = {
      width = 40,
      side = 'left',
   },
   renderer = {
      group_empty = true,
      },
      filters = {
         dotfiles = false,
      },
})
EOF

" =========================================================================================


" Note that g? toggles help when NvimTree is active
nnoremap <Leader>ee :NvimTreeToggle<CR>
nnoremap <Leader>ef :NvimTreeFocus<CR>
nnoremap <Leader>eh :NvimTreeFindFile<CR>
nnoremap <Leader>ec :NvimTreeCollapse<CR>

