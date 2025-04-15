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
		opts.silent = opts.silent ~= false -- Default to true

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
