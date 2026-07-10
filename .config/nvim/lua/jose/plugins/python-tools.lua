return {
  -- Python debugging and testing
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
  },
  
  -- Python virtual environment detection
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    opts = {
      name = {
        "venv",
        ".venv",
        "env",
        ".env",
        "mcp-venv", -- For your dtex-mcp-servers
      },
    },
    event = "CursorMoved",
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    },
  },

  -- Better Python indentation
  {
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
  },

  -- Python docstring generation
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    keys = {
      { "<leader>nf", "<cmd>Neogen func<cr>", desc = "Generate function docstring" },
      { "<leader>nc", "<cmd>Neogen class<cr>", desc = "Generate class docstring" },
    },
  },
}
