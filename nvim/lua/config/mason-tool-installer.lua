require('mason-tool-installer').setup {
    ensure_installed = {
        --{ "pyright" },
        { "python-lsp-server" },
        { "r-languageserver" },
        { "lua-language-server" },
        { "ruff" },
        { "stylua" },
        { "tree-sitter-cli" }
    },
}
