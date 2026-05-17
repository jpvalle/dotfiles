return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        "pyright", -- Python LSP
        "ruff", -- Python linting/formatting (renamed from ruff_lsp)
        "bashls", -- Bash LSP
        "yamlls", -- YAML LSP
        "jsonls", -- JSON LSP
        "dockerls", -- Docker LSP
        "html", -- HTML LSP
        "cssls", -- CSS LSP
        "lua_ls", -- Lua LSP
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- JS/TS/JSON formatter
        "stylua", -- Lua formatter
        "autopep8", -- PEP8-compliant Python formatter
        "flake8", -- Python linter that includes PEP8 checking (replaces pycodestyle)
        "eslint_d", -- JS linter
        "shellcheck", -- Shell script linter
        "shfmt", -- Shell script formatter
      },
    })
  end,
}
