require("nvim-tree").setup({})
local nvim_tree = require("nvim-tree.api")
vim.keymap.set("n", "<F12>", nvim_tree.tree.toggle)
