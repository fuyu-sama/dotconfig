local iron = require("iron.core")
local view = require("iron.view")
local common = require("iron.fts.common")

iron.setup({
	config = {
		-- Whether a repl should be discarded or not
		scratch_repl = true,
		-- Your repl definitions come here
		repl_definition = {
			sh = {
				command = { "zsh" },
			},
			python = {
				command = { "ptpython" },
				format = common.bracketed_paste_python,
				block_dividers = { "# %%", "#%%" },
				env = { PYTHON_BASIC_REPL = "1" }, --this is needed for python3.13 and up.
			},
			r = {
				command = { "R", "--no-save" },
				block_dividers = { "# %%", "#%%" },
			},
		},
		-- Send selections to the DAP repl if an nvim-dap session is running.
		dap_integration = true,
		-- How the repl window will be displayed
		repl_open_cmd = view.split.vertical.botright(0.5),
	},
	keymaps = {
		toggle_repl = "<leader>r", -- toggles the repl open and closed.
		-- If repl_open_command is a table as above, then the following keymaps are
		-- available
		-- toggle_repl_with_cmd_1 = "<space>rv",
		-- toggle_repl_with_cmd_2 = "<space>rh",
		--restart_repl = "<leader>R", -- calls `IronRestart` to restart the repl
		--send_motion = "<space>sc",
		visual_send = "<leader>w",
		--send_file = "<space>sf",
		send_line = "<leader>w",
		--send_paragraph = "<space>sp",
		--send_until_cursor = "<space>su",
		--send_mark = "<space>sm",
		send_code_block = "<leader>e",
		--send_code_block_and_move = "<space>sn",
		--mark_motion = "<space>mc",
		--mark_visual = "<space>mc",
		--remove_mark = "<space>md",
		--cr = "<space>s<cr>",
		--interrupt = "<space>s<space>",
		--exit = "<space>sq",
		--clear = "<space>cl",
	},
	-- If the highlight is on, you can change how it looks
	-- For the available options, check nvim_set_hl
	highlight = {
		italic = false,
	},
	ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
})

vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
