-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- colorscheme command
-- vim.cmd [[colorscheme habamax]]
function ColorMyCanvas(color)
	color = color or habamax
	vim.cmd.colorscheme(color)

--	vim.api.nvim_set_hl(0, "Normal", { bg="none"})
--	vim.api.nvim_set_hl(0, "NormalFloat", { bg="none" })

end

ColorMyCanvas()
