return {
    { "navarasu/onedark.nvim", priority = 1000, lazy = false, config = function() require("config.onedark") end },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false , config = function() require("config.catppuccin") end },
    { "folke/tokyonight.nvim", priority = 1000, lazy = false, config = function() require("config.tokyonight") end }
}