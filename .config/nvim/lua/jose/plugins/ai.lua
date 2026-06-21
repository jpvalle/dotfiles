return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: If you use nvim-cmp for autocomplete menus
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        -- Chat sidebar uses the local llama-server
        chat = {
          adapter = "llama_cpp",
        },
        -- Inline ghost text and refactoring uses the local llama-server
        inline = {
          adapter = "llama_cpp",
        },
      },
      adapters = {
        llama_cpp = function()
          return require("codecompanion.adapters").extend("openai", {
            env = {
              -- Overwrite the base URL to point directly to your local background server port
              url = "http://localhost:8080",
            },
            schema = {
              model = {
                -- Informing Neovim of your newly downloaded Q6 model parameters
                default = "qwen2.5-coder-7b-instruct-q6_k",
              },
              -- Set lower temperature for strict, syntax-accurate code generations
              temperature = {
                default = 0.1,
              },
            },
          })
        end,
      },
    })

    -- Handy keymaps to trigger the AI interfaces instantly
    vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle AI Chat Sidebar" })
    vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanion<cr>", { desc = "Inline AI Actions / Refactor" })
    vim.keymap.set("v", "<leader>ae", "<cmd>CodeCompanionChat Add<cr>", { desc = "Send Selected Code to Chat" })
  end,
}
