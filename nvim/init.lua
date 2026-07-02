-- ================
-- Neovim init.lua
-- ================

-- env gate
local enable_rc = vim.env.NVIM_ENABLERC
if enable_rc == "0" then
	return
end

-- basic
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.ruler = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.background = "dark"
vim.opt.signcolumn = "number"
vim.opt.scrolloff = 3

vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99

require("config.keymaps")
require("config.lsp")

local enable_plug = vim.env.NVIM_ENABLEPLUG
if enable_plug == "0" then
	return
end
require("config.lazy")

vim.cmd.colorscheme("catppuccin-macchiato")
vim.api.nvim_set_hl(0, "LineNr", { fg = "#6e738d" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#cad3f5", bold = true })
vim.api.nvim_set_hl(0, "Visual", { bg = "#6c7086" })
vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = "#6c7086", bold = true })

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		if vim.bo.buftype == "terminal" then
			vim.cmd("startinsert")
		end
	end,
})
