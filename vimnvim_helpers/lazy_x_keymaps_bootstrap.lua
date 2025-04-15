-- File: $HOME/.vim_helpers/lazy_keymaps_bootstrap.lua
local M = {}

function M.setup()
	local lazy_config_helpers = require("lazy_config_helpers")
	lazy_config_helpers.register_keymaps({
		{
			mode = "n",
			keys = "<leader>a",
			command = ":echo 'Lazy Keymaps A!'<CR>",
			opts = { description = "Echo Lazy A" },
		},
		{
			mode = "v",
			keys = "<leader>b",
			command = ":echo 'Lazy Keymaps B!'<CR>",
			opts = { description = "Echo Lazy B" },
		},
		{
			mode = "i",
			keys = "<C-c>",
			command = "<ESC>:echo 'Insert Keymap!'<CR>",
			opts = { description = "Insert Keymap Example" },
		},
	})
end

return M
