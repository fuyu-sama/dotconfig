local M = {}

local my_note = vim.fn.expand("~/.config/nvim/MY_NVIM_NOTES.md")

function M.open_float()
    local buf = vim.api.nvim_create_buf(false, true)
    local lines = vim.fn.readfile(my_note)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    vim.bo[buf].filetype = "markdown"
    vim.bo[buf].modifiable = false
    vim.bo[buf].bufhidden = "wipe"

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = " My NVIM Notes ",
        title_pos = "center",
    })

    local function close_win()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end

    vim.keymap.set("n", "q", close_win, { buffer = buf, silent = true })
    vim.keymap.set("n", "<Esc>", close_win, { buffer = buf, silent = true })
    vim.keymap.set("n", "<F1>", close_win, { buffer = buf, silent = true })
end

function M.edit()
    vim.cmd("edit " .. my_note)
end

return M