--vim.lsp.enable("pyright")
vim.lsp.enable("pylsp")
vim.lsp.config["pylsp"] = {
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					ignore = { "E501" },
				},
			},
		},
	},
}
vim.lsp.enable("lua_ls")
vim.lsp.enable("r_language_server")

vim.lsp.config["pyright"] = {
	settings = {
		python = {
			analysis = {
				diagnosticSeverityOverrides = {
					reportAttributeAccessIssue = "none",
					reportPrivateImportUsage = "none",
				},
			},
		},
	},
}

vim.lsp.config["lua_ls"] = {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
}

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "󰋼",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
	virtual_lines = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many",
	},
})
