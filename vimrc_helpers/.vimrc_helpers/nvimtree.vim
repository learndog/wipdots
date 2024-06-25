" SECTION: CONFIGURE NVIM-TREE
lua << EOF
-- Configure nvim-tree file explorer
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
-- Some options
require("nvim-tree").setup({
sort_by = "case_sensitive",
view = {
   width = 40,
   },
   renderer = {
      group_empty = true,
      },
      filters = {
         dotfiles = false,
         },
})
EOF

" Note that g? toggles help when NvimTree is active
nnoremap <Leader>ee :NvimTreeToggle<CR>
nnoremap <Leader>ef :NvimTreeFocus<CR>
nnoremap <Leader>eh :NvimTreeFindFile<CR>
nnoremap <Leader>ec :NvimTreeCollapse<CR>

