-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- telescope keymaps

local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', telescope_builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	telescope_builtin.grep_string({ search = vim.fn.input("Grep > ")});
end)

-- vim-fugitive keymaps
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- harpoon keymaps
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)

-- undotree keymaps
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
