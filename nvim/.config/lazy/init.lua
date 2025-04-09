-- Symlink to this wipdots file with
-- ln -s ~/wipdots/nvim/.config/lazy/init.lua ~/.config/lazy/init.lua

-- Suggested gitconfig settings (plus email, name if contributing)

-- TODO
-- Keymaps for jl jh
-- Keymap for reload config (or maybe it autoreloads)
-- Keymap to start the dashboard from nvim session
-- colorscheme with better contrast on VertexAI jupyterlab
-- Use LazyExtra to add mini.move
-- Improved commenting keymap
-- Keymaps ,, and ,,, as Buffers and Files

-- [core]
--     editor = nvim
--
-- [merge]
--     tool = vimdiff
--     conflictstyle = zdiff3
--
-- [mergetool "vimdiff"]
--     cmd = nvim -d $LOCAL $BASE $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'
--
-- [mergetool]
--     keepBackup = true
--
-- [diff]
--     tool = vimdiff
--
-- [difftool "vimdiff"]
--     cmd = vimdiff -u NONE "$LOCAL" "$REMOTE"
--     prompt = false

-- Set nvim python version
vim.g.python3_host_prog = os.getenv("HOME") .. "/.venvs/nvim/bin/python"

--------------------------------------------------------------------------
--- CONFIG HELPER FILES
--------------------------------------------------------------------------
-- vim.opt.runtimepath:append(vim.fn.expand("$HOME/.vim_extensions")) -- Optionally add helper dir to nvim path

-- VimScript helper files
-- vim.cmd("source " .. vim.fn.expand("$HOME/.vim_helpers/my_helper.vim"))

-- Lua helper files
-- require("lazy_helper").setup() -- OR... local helper = require("lazy_helper"); helper.setup()

-- -----------------------------------------------
-- BOOTSTRAP LAZYVIM - bootstrap lazy.nvim, LazyVim and your plugins
-- -----------------------------------------------
require("config.lazy")

-- -----------------------------------------------
-- SET COLORSCHEME
-- -----------------------------------------------
-- vim.cmd("colorscheme lunaperche")
--vim.g.catppuccin_flavour = "mocha"
--vim.cmd("colorscheme catppuccin")
vim.opt.background = "dark"
vim.g.tokyonight_style = "moon"
-- vim.g.tokyonight_style = "night"
vim.cmd("colorscheme tokyonight")

-- ===============================================
-- SET OPTIONS
-- ===============================================

-- Disable smooth scrolling
vim.g.snacks_animate = false

-- ===============================================
-- KEYMAPS
-- ===============================================
-- Example delete mapping... vim.keymap.del("n", ",")

vim.g.maplocalleader = "\\" -- single escaped backslash

-- Example keymaps for whichkey with groups
-- require("lazy").setup({
--   {
--     "folke/which-key.nvim",
--     config = function()
--       local wk = require("which-key")
--       wk.add({
--         ["<leader>f"] = {
--           e = { "<cmd>edit<CR>", "Edit file" },
--           s = { "<cmd>w<CR>", "Save file" },
--         },
--         ["<leader>p"] = {
--           f = { "<cmd>Telescope find_files<CR>", "Find files" },
--           g = { "<cmd>Telescope live_grep<CR>", "Live grep" },
--         },
--         ["<localleader>e"] = { "<ESC>", "Escape from insert mode" },
--       }, { prefix = "<leader>" })
--     end,
--   },
-- })

vim.keymap.set("n", "<localleader>e", "<ESC>", { noremap = true, silent = true, desc = "esc from insert mode" })

vim.keymap.set("i", "jj", "<ESC>", { noremap = true, silent = true, desc = "esc from insert mode" })

-- ===============================================
-- KEYMAPS WITH SUPPORTING FUNCTION DEFINITIONS
-- ===============================================
-- Define a function to jump just after the previous opening bracket
local function jump_to_prev_opening()
  -- Define a Vim pattern matching any of the opening brackets: ( [ {
  -- The pattern uses a character class; note that ( and [ are escaped.
  local pattern = [[[\(\[\{]]
  -- 'b' flag: search backwards; 'W' flag: do not wrap around the file.
  local pos = vim.fn.searchpos(pattern, "bW")
  if pos[1] == 0 then
    print("No opening bracket found")
    return
  end
  -- Move one column to the right of the found character.
  pos[2] = pos[2] + 1
  vim.api.nvim_win_set_cursor(0, pos)
end

-- Define a function to jump just after the next closing bracket
local function jump_to_next_closing()
  -- Define a Vim pattern matching any of the closing brackets: ) ] }
  local pattern = [[[\)\]\}]]
  -- 'W' flag: search forward without wrapping.
  local pos = vim.fn.searchpos(pattern, "W")
  if pos[1] == 0 then
    print("No closing bracket found")
    return
  end
  -- Move one column to the right of the found closing bracket.
  pos[2] = pos[2] + 1
  vim.api.nvim_win_set_cursor(0, pos)
end

-- Map the functions to "jh" and "jl" in both normal and insert modes.
-- The 'desc' field is used by folke which-key to display a description.
vim.keymap.set(
  { "n", "i" },
  "jh",
  jump_to_prev_opening,
  { noremap = true, silent = true, desc = "Jump after previous opening bracket" }
)
vim.keymap.set(
  { "n", "i" },
  "jl",
  jump_to_next_closing,
  { noremap = true, silent = true, desc = "Jump after next closing bracket" }
)

-- test(asdaf)

-- ==========================================================================================
-- * EXAMPLE vimscript helper file
-- ==========================================================================================
-- ```
-- " File: ~/.vim_helpers/my_helper.vim
-- " Has basic keymaps with descriptions for both Vimscript and Lua
-- " but lua is required to set desc for folke which-key
--
-- " Normal mode mappings
-- nnoremap <leader>a :echo 'Key A in VimScript'<CR> " desc: Leader Key A
-- nnoremap <localleader>b :echo 'Key B in VimScript'<CR> " desc: Local Leader Key B
--
-- " Visual mode mappings
-- vnoremap <leader>c :echo 'Key C in VimScript'<CR> " desc: Leader Key C
--
-- " Use Lua if additional options like keymap 'desc' are needed
--
-- " VERSION 1 - STANDARD KEYMAPPING
-- " Define keymap using Lua's vim.keymap.set like this
-- " vim.keymap.set("MODE", "KEYS", "CMD", { noremap = true, silent = true, desc = "WHICHKEY DESCRIPTION" })
-- lua << EOF
-- vim.keymap.set("n", "<leader>a", ":echo 'Key A in VimScript'<CR>", { noremap = true, silent = true, desc = "Leader Key A" })
-- EOF
--
-- " VERSION 2 - ALTERNATE KEYMAPPING
-- " Define keymaps another way
-- lua << EOF
-- local keymaps = {
--     { mode = "n", keys = "<leader>d", command = ":echo 'Key D from Lua'<CR>", opts = { desc = "Leader Key D in VimScript" } },
--     { mode = "v", keys = "<leader>e", command = ":echo 'Key E from Lua'<CR>", opts = { desc = "Leader Key E in VimScript" } },
-- }
-- for _, map in ipairs(keymaps) do
--     vim.keymap.set(map.mode, map.keys, map.command, map.opts)
-- end
--
--
-- EOF
-- ```

-- ==========================================================================================
-- * EXAMPLE1 lua helper file - lazyvim keymaps bootstrap
-- ==========================================================================================
-- ```
-- -- File: $HOME/.vim_helpers/lazy_keymaps_bootstrap.lua
-- -- allows offloading bulk config into a separate bootstrap lua file
-- local M = {}
--
-- function M.setup()
--     local lazy_config_helpers = require("lazy_config_helpers")
--     lazy_config_helpers.register_keymaps({
--         { mode = "n", keys = "<leader>a", command = ":echo 'Lazy Keymaps A!'<CR>", opts = { description = "Echo Lazy A" } },
--         { mode = "v", keys = "<leader>b", command = ":echo 'Lazy Keymaps B!'<CR>", opts = { description = "Echo Lazy B" } },
--         { mode = "i", keys = "<C-c>", command = "<ESC>:echo 'Insert Keymap!'<CR>", opts = { description = "Insert Keymap Example" } },
--     })
-- end
--
-- return M
-- ```
--
--
-- ==========================================================================================
-- * EXAMPLE2 lua helper file -  lua based configuration
-- ==========================================================================================
-- ```
-- -- File: $HOME/.vim_helpers/lazy_helpers.lua
-- -- sample lua based configuration helper
-- -- note that we can split the key mappings between init.lua and here and other helpers
-- local M = {}
--
-- function M.setup()
--     -- Configure key mappings
--     local keymaps = {
--         { mode = "n", keys = "<leader>a", command = ":echo 'Helper Keymaps A!'<CR>", opts = { desc = "Echo Helper A", noremap = true, silent = true } },
--         { mode = "v", keys = "<leader>b", command = ":echo 'Helper Keymaps B!'<CR>", opts = { desc = "Echo Helper B", noremap = true, silent = true } },
--     }
--
--     for _, map in ipairs(keymaps) do
--         vim.keymap.set(map.mode, map.keys, map.command, map.opts)
--     end
--
--     -- Plugin configuration
--     vim.cmd([[packadd some_plugin]]) -- Example plugin loading
--
--     -- Set global preferences
--     vim.opt.shiftwidth = 4  -- Indentation width
--     vim.opt.expandtab = true  -- Use spaces instead of tabs
--     vim.opt.tabstop = 4 -- Tab width
-- end
--
-- return M
-- ```
--
