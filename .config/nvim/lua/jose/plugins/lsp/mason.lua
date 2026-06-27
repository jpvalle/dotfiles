return {
  "williamboman/mason.nvim",
  lazy = false,
  dependencies = {
    "neovim/nvim-lspconfig",
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
        "pyright",
        "ruff",
        "bashls",
        "yamlls",
        "jsonls",
        "dockerls",
        "html",
        "cssls",
        "lua_ls",
      },
      automatic_enable = {
        exclude = { "stylua", "pylsp" },
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier",
        "stylua",
        "autopep8",
        "flake8",
        "eslint_d",
        "shellcheck",
        "shfmt",
      },
      run_on_start = false,
    })
  end,
}
