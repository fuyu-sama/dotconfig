require("lualine").setup({
    options = {
        theme = "tomorrow_night"
    },
    tabline = {
        lualine_a = {
            {
                "buffers",
                show_filename_only = false,
                hide_filename_extension = false,
                mode = 2,
                max_length = vim.o.columns * 2 / 3,
                symbols = {
                    modified = " ●",
                    alternate_file = "",
                    directory = "",
                },
            }
        },
        lualine_b = {},
        lualine_c = { { function() return "%=" end } },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
            {
                "tabs",
                mode = 2,
                max_length = vim.o.columns / 3,
            }
        },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
})

for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function()
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })
        if bufs[i] then
            vim.api.nvim_set_current_buf(bufs[i].bufnr)
        end
    end, { desc = "Go to buffer " .. i })
end

for i = 1, 9 do
    vim.keymap.set("n", "<leader><F" .. i .. ">", function()
        local tab_count = vim.fn.tabpagenr("$")
        if i <= tab_count then
            vim.cmd("tabnext " .. i)
        end
    end, { desc = "Go to tab " .. i })
end
