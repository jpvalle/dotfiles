return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    
    -- Check if mason-lspconfig is available
    local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not mason_lspconfig_ok then
      vim.notify("mason-lspconfig not found, setting up LSP servers manually", vim.log.levels.WARN)
    end

    local keymap = vim.keymap

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- LSP keybindings
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end,
    })

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Enhanced diagnostic configuration for LSP (using modern API)
    vim.diagnostic.config({
      virtual_text = {
        source = "always",
        spacing = 4,
        prefix = "●",
        format = function(diagnostic)
          local code = diagnostic.code or (diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.code)
          if code then
            return string.format("[%s] %s", code, diagnostic.message)
          end
          return diagnostic.message
        end,
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        }
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        focusable = false,
        format = function(diagnostic)
          local code = diagnostic.code or (diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.code)
          if code then
            return string.format("[%s] %s", code, diagnostic.message)
          end
          return diagnostic.message
        end,
      },
    })

    -- Setup LSP servers
    if mason_lspconfig_ok and mason_lspconfig.setup_handlers then
      mason_lspconfig.setup_handlers({
        function(server_name)
          -- Skip pylsp if pyright is available
          if server_name == "pylsp" then
            return
          end
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["pyright"] = function()
          lspconfig["pyright"].setup({
            capabilities = capabilities,
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "off", -- Disable all type checking
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  autoImportCompletions = true,
                  diagnosticMode = "off", -- Disable all Pyright diagnostics
                  -- Disable ALL Pyright diagnostics
                  diagnosticSeverityOverrides = {
                    reportGeneralTypeIssues = "none",
                    reportOptionalMemberAccess = "none",
                    reportOptionalSubscript = "none",
                    reportPrivateImportUsage = "none",
                    reportUnusedImport = "none",
                    reportUnusedVariable = "none",
                    reportUndefinedVariable = "none",
                    reportAttributeAccessIssue = "none",
                    reportOperatorIssue = "none",
                    reportIndexIssue = "none",
                    reportInvalidTypeVarUse = "none",
                    reportCallIssue = "none",
                    reportArgumentType = "none",
                    reportAssignmentType = "none",
                    reportReturnType = "none",
                    reportInconsistentConstructor = "none",
                    reportFunctionMemberAccess = "none",
                    reportIncompatibleMethodOverride = "none",
                    reportIncompatibleVariableOverride = "none",
                    reportOverlappingOverload = "none",
                    reportConstantRedefinition = "none",
                    reportDeprecated = "none",
                    reportDuplicateImport = "none",
                    reportWildcardImportFromLibrary = "none",
                    reportAbstractUsage = "none",
                    reportUnsupportedDunderAll = "none",
                    reportUnusedCoroutine = "none",
                    reportUnnecessaryIsInstance = "none",
                    reportUnnecessaryCast = "none",
                    reportUnnecessaryComparison = "none",
                    reportUnnecessaryContains = "none",
                    reportImplicitStringConcatenation = "none",
                    reportInvalidStubStatement = "none",
                    reportIncompleteStub = "none",
                    reportUnsupportedDunderAll = "none",
                    reportUnusedCallResult = "none",
                  },
                },
              },
            },
          })
        end,
        ["lua_ls"] = function()
          lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          })
        end,
      })
    else
      -- Fallback: manually setup common LSP servers
      local servers = { "pyright", "lua_ls", "bashls", "yamlls", "jsonls" }
      
      for _, server in ipairs(servers) do
        if server == "pyright" then
          lspconfig[server].setup({
            capabilities = capabilities,
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "off", -- Disable all type checking
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  autoImportCompletions = true,
                  diagnosticMode = "off", -- Disable all Pyright diagnostics
                  -- Disable ALL Pyright diagnostics
                  diagnosticSeverityOverrides = {
                    reportGeneralTypeIssues = "none",
                    reportOptionalMemberAccess = "none",
                    reportOptionalSubscript = "none",
                    reportPrivateImportUsage = "none",
                    reportUnusedImport = "none",
                    reportUnusedVariable = "none",
                    reportUndefinedVariable = "none",
                    reportAttributeAccessIssue = "none",
                    reportOperatorIssue = "none",
                    reportIndexIssue = "none",
                    reportInvalidTypeVarUse = "none",
                    reportCallIssue = "none",
                    reportArgumentType = "none",
                    reportAssignmentType = "none",
                    reportReturnType = "none",
                    reportInconsistentConstructor = "none",
                    reportFunctionMemberAccess = "none",
                    reportIncompatibleMethodOverride = "none",
                    reportIncompatibleVariableOverride = "none",
                    reportOverlappingOverload = "none",
                    reportConstantRedefinition = "none",
                    reportDeprecated = "none",
                    reportDuplicateImport = "none",
                    reportWildcardImportFromLibrary = "none",
                    reportAbstractUsage = "none",
                    reportUnsupportedDunderAll = "none",
                    reportUnusedCoroutine = "none",
                    reportUnnecessaryIsInstance = "none",
                    reportUnnecessaryCast = "none",
                    reportUnnecessaryComparison = "none",
                    reportUnnecessaryContains = "none",
                    reportImplicitStringConcatenation = "none",
                    reportInvalidStubStatement = "none",
                    reportIncompleteStub = "none",
                    reportUnsupportedDunderAll = "none",
                    reportUnusedCallResult = "none",
                  },
                },
              },
            },
          })
        elseif server == "lua_ls" then
          lspconfig[server].setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          })
        else
          lspconfig[server].setup({
            capabilities = capabilities,
          })
        end
      end
    end
  end,
}
