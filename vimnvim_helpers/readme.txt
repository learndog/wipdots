This dir is being created to hold new versions of helper files
that work in vim or nvim and also register folke which-key.

Lazy will get its own custom extended personalized configuration

* ln -sf $HOME/wipdots/.vim_helpers ~/.vim_helpers

* Edit ~/.config/lazy/init.lua
```  
-- Extend the runtimepath to include the helper directory
vim.opt.runtimepath:append(vim.fn.expand("$HOME/.vim_helpers"))

-- Move LEADER to \\ and move LOCAL LEADER to <space> and prevent remapping
-- Do this in ~/.config/lazy/init.lua
-- This will allow keeping all the lazy leader keymaps
-- and add <localleader> custom keymaps as an integrated extension.
vim.g.mapleader = "\\"
vim.g.maplocalleader = " "
vim.keymap.set("", "<leader>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("", "<localleader>", "<Nop>", { noremap = true, silent = true })

-- Load the helper functions module
local helpers = require("lazy_config_helpers")

-- Load VimScript helper files
helpers.load_vim_helper("$HOME/.vim_helpers/my_helper.vim")

-- Load and execute Lua keymaps bootstrap
local lua_keymaps = helpers.load_lua_helper("lazy_keymaps_bootstrap")
if lua_keymaps then
    lua_keymaps.setup()
end
```

* Create this file
```
-- File: $HOME/.vim_helpers/lazy_config_helpers.lua 
local M = {}

-- Function to register Lua keymaps and integrate with which-key if in Neovim
function M.register_keymaps(mappings)
    local is_nvim = vim.fn.has("nvim") == 1
    local ok, wk = pcall(require, "which-key") -- Try loading which-key if in Neovim

    for _, map in ipairs(mappings) do
        local mode = map.mode or "n" -- Default to normal mode
        local keys = map.keys
        local command = map.command
        local opts = map.opts or {}

        opts.noremap = opts.noremap ~= false -- Default to true
        opts.silent = opts.silent ~= false  -- Default to true

        -- Create the keymap (works in both Vim and Neovim)
        vim.keymap.set(mode, keys, command, opts)

        -- If in Neovim and which-key is available, register the keymap with which-key
        if is_nvim and ok and opts.description then
            wk.register({
                [keys] = { command, opts.description },
            }, { mode = mode })
        end
    end
end

* Create lua helper files
```
-- File: $HOME/.vim_helpers/lazy_keymaps_bootstrap

```
local M = {}

function M.setup()
    local lazy_config_helpers = require("lazy_config_helpers")
    lazy_config_helpers.register_keymaps({
        { mode = "n", keys = "<leader>a", command = ":echo 'Lazy Keymaps A!'<CR>", opts = { description = "Echo Lazy A" } },
        { mode = "v", keys = "<leader>b", command = ":echo 'Lazy Keymaps B!'<CR>", opts = { description = "Echo Lazy B" } },
        { mode = "i", keys = "<C-c>", command = "<ESC>:echo 'Insert Keymap!'<CR>", opts = { description = "Insert Keymap Example" } },
    })
end

return M
```

* Create vimscript helper files ~/.vim_helpers/my_helper.vim

```
" Add any desired configuration and the associated keymaps 
" Define basic keymaps that work in both Vim and Neovim

" Call the Lua function to handle both keymap creation and which-key registration
lua << EOF
local helpers = require("lazy_config_helpers")

helpers.register_keymaps({
    { mode = "n", keys = "<leader>a", command = ":echo 'Key A in VimScript'<CR>", opts = { description = "Leader: Key A" } },
    { mode = "n", keys = "<localleader>b", command = ":echo 'Key B in VimScript'<CR>", opts = { description = "Local Leader: Key B" } },
    { mode = "v", keys = "<leader>c", command = ":echo 'Key C in VimScript'<CR>", opts = { description = "Leader: Key C" } },
})
EOF
```

