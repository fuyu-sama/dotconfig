-- lua/config/keymaps.lua

local note = require("core.mynote")

vim.keymap.set("n", "<F1>", note.open_float, {
	noremap = true,
	silent = true,
	desc = "Open notes in floating window",
})
vim.keymap.set("n", "<leader>he", note.edit, {
	desc = "Edit my nvim notes",
})

-- jump between cells
vim.keymap.set('n', ']c', function()
  vim.fn.search('^# %%', 'W')   -- 'W' 表示不绕回、不报错
  vim.cmd('normal! zt')         -- 把当前行滚到屏幕顶部（可选）
end, { desc = 'next cell' })

vim.keymap.set('n', '[c', function()
  vim.fn.search('^# %%', 'bW')
  vim.cmd('normal! zt')
end, { desc = 'previous cell' })

vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<F11>", ":nohls<CR>")

vim.keymap.set("t", "<C-w>N", [[<C-\><C-n>]], { desc = "Terminal to normal mode" })
vim.keymap.set("t", "<C-w>h", [[<C-\><C-n><C-w>h]], { desc = "Terminal window left" })
vim.keymap.set("t", "<C-w>j", [[<C-\><C-n><C-w>j]], { desc = "Terminal window down" })
vim.keymap.set("t", "<C-w>k", [[<C-\><C-n><C-w>k]], { desc = "Terminal window up" })
vim.keymap.set("t", "<C-w>l", [[<C-\><C-n><C-w>l]], { desc = "Terminal window right" })
vim.keymap.set("t", "<C-w><Left>", [[<C-\><C-n><C-w>h]], { desc = "Terminal window left" })
vim.keymap.set("t", "<C-w><Down>", [[<C-\><C-n><C-w>j]], { desc = "Terminal window down" })
vim.keymap.set("t", "<C-w><Up>", [[<C-\><C-n><C-w>k]], { desc = "Terminal window up" })
vim.keymap.set("t", "<C-w><Right>", [[<C-\><C-n><C-w>l]], { desc = "Terminal window right" })

vim.keymap.set("n", "<leader>t", function()
	vim.cmd("botright split")
	local qf_height = vim.o.previewheight or 12
	vim.cmd(string.format("resize %d", qf_height))
	vim.cmd("terminal")
	vim.cmd("startinsert")
end, { desc = "Open terminal at bottom" })
