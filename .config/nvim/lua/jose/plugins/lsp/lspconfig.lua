return {
  "neovim/nvim-lspconfig",
  event = "CursorMoved",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("jose-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
        end

        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("gr", vim.lsp.buf.references, "Go to references")
        map("gi", vim.lsp.buf.implementation, "Go to implementation")
        map("K", vim.lsp.buf.hover, "Hover documentation")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format buffer")
      end,
    })

    local servers = {
      "pyright",
      "ruff",
      "bashls",
      "yamlls",
      "jsonls",
      "dockerls",
      "html",
      "cssls",
    }

    for _, server in ipairs(servers) do
      vim.lsp.config(server, { capabilities = capabilities })
    end

    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    })
  end,
}
