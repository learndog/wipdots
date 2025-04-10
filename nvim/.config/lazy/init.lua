-- Symlink to this wipdots file with
-- ln -s ~/wipdots/nvim/.config/lazy/init.lua ~/.config/lazy/init.lua

-- Suggested gitconfig settings (plus email, name if contributing)

-- TODO
-- Keymap for reload config
-- Keymap to start the dashboard from nvim session
-- colorscheme with better contrast on VertexAI jupyterlab (preferrably dark)
-- Use LazyExtra to add mini.move
-- Improved folds
-- Default to show hidden files in Explorer
-- Keymaps ,, and ,,, and ,,,, as Files, Buffers and Grep Buffers
-- Submenu for search
-- Submenu for lsp
-- Submenu for windows
-- Add window maximizer
-- Add copilot
-- Add toggle gutter stuff (for easy copy paste)
-- Add find vim swap files
-- Quick duplicate/bkup shapshot of file
-- LazyVim setup
-- Breadcrumbs with toggle or cycle for brevity
-- Split a tob to right window
--      and move a tab up down right left (create or remove window as appropriate)
-- List of plugins
-- Add which-key groups to custom keymaps

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

-- ===============================================
-- BOOTSTRAP LAZYVIM - bootstrap lazy.nvim, LazyVim and your plugins
-- ===============================================
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

-- -- ===============================================
-- -- CONFIGURE PLUGINS - BROKEN
-- -- ===============================================

-- -----------------------------------------------
-- -- Configure snacks - but no impact maybe because lazy loaded
-- -----------------------------------------------

require("snacks").setup({
  explorer = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    -- Include other explorer option overrides here.
  },
})

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
--
-- -----------------------------------------------
-- MOVE AROUND OPEN CLOSE CHARACTERS
-- -----------------------------------------------
vim.cmd([[
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: jh and jl will end up to the right of the previous or following quote or bracket
"       Vim will look for an opening bracket or quote, or a closing bracket or quote
"       One odd behaviour will be cursor after closing quote because open and close is the same
"       So if asdf"fasdfasdf"|asdfasdfa, then backward will not move. Forward will look for next one.
"       Not sure yet if backward should look for another open quote also. Might cause unwanted moves.
" Function to skip backward in normal mode to just after the first opening character to the left

function! s:SkipBackwardToOpening()
    " Get the current line
    let s:line = getline('.')
    
    " Get the current cursor column (1-based index)
    let s:col = col('.')
    
    " Special case: check for double quotes or single quotes just before the cursor
    if s:col > 2
        let s:char_before = s:line[s:col - 2] " Character before the current cursor position
        let s:char_before_prev = s:line[s:col - 3] " Character two positions before the cursor
        if s:char_before == s:char_before_prev && s:char_before =~# '["'']'
            " If two identical quotes are found, move the cursor inside the quotes
            call cursor(line('.'), s:col - 1)
            return
        endif
    endif
    
    " Iterate backward from current column to find the first opening character
    while s:col > 1
        let s:col -= 1
        let s:char = s:line[s:col - 1] " Note: Vim index is 0-based, col() is 1-based
        " Check if the character is one of the specified opening characters
        if s:char =~# '[("''$"''{]'
            " Move cursor to just after the found opening character
            call cursor(line('.'), s:col + 1)
            return
        endif
    endwhile
endfunction


" Function to skip forward to just after the first closing character to the right
function! s:SkipForwardPastClosing()
  " Get the current line
  let l:line = getline('.')
  " Get the current cursor column (1-based index)
  let l:col = col('.')
  " Get the length of the line
  let l:line_length = len(l:line)
  " Iterate forward from current column to find the first closing character
  while l:col <= l:line_length
    let l:char = l:line[l:col - 1] " Note: Vim index is 0-based, col() is 1-based
    " Check if the character is one of the specified closing characters
    if l:char =~# '[)"''\]"''}]'
      " Move cursor to just after the found closing character
      call cursor(line('.'), l:col + 1)
      return
    endif
    " Move to the next column
    let l:col += 1
  endwhile
endfunction
nnoremap <silent> jl :call <SID>SkipForwardPastClosing()<CR>
nnoremap <silent> jh :call <SID>SkipBackwardToOpening()<CR>
inoremap <silent> jl <C-o>:call <SID>SkipForwardPastClosing()<CR>
inoremap <silent> jh <C-o>:call <SID>SkipBackwardToOpening()<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
]])

-- -----------------------------------------------
-- TOGGLE ZERO - CYCLE AROUND BEGIN AND END OF LINE
-- -----------------------------------------------
vim.cmd([[
function! ToggleZero(mode)
   " Get the current cursor position
   let current_col = col('.')
   " Search for the first/last non-whitespace character on the current line
   let first_non_ws_col = match(getline('.'), '\S') + 1
   let last_non_ws_col = match(getline('.'), '\S\zs\s*$')
   " Get last col position on the current line
   let last_col_pos = col('$') -1
   " Move based on cursor location
   echo "current col: " . current_col . " last pos: " . last_col_pos
   if current_col == last_col_pos
      normal! 0
   elseif current_col == 1 && current_col != first_non_ws_col
      normal! ^
   elseif current_col == first_non_ws_col
      normal! g_
   elseif current_col == last_non_ws_col || current_col == last_non_ws_col+1
      " The +1 is to cover the movement for insert mode cycles
      normal! $
   else
      normal! 0
   endif

   if a:mode == 'i'
      stopinsert
      if col('.') == 1
         " First column
         startinsert
      elseif col('.') >= col('$')-1
         " Near or at last column, use 'A' to append correctly
         call feedkeys('A', 'n')
      elseif col('.') == match(getline('.'), '\S\zs\s*$')
         " Last non-whitespace column
         call feedkeys('a', 'n')
      else
         " Other positions
         startinsert
      endif
   endif
endfunction

nnoremap 0 :call ToggleZero('n')<CR>
nnoremap ;; :call ToggleZero('n')<CR>
inoremap ;; <C-o>:call ToggleZero('i')<CR>
]])

--
--
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
