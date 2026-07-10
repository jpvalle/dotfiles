return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>lg",
      function()
        require("jose.core.nvim-server").export_env()
        require("jose.core.theme-sync").refresh_lazygit(function()
          vim.cmd("LazyGit")
        end)
      end,
      desc = "Open LazyGit",
    },
    {
      "<leader>lf",
      function()
        require("jose.core.nvim-server").export_env()
        require("jose.core.theme-sync").refresh_lazygit(function()
          vim.cmd("LazyGitCurrentFile")
        end)
      end,
      desc = "LazyGit Current File",
    },
    { "<leader>lc", "<cmd>LazyGitConfig<cr>", desc = "LazyGit Config" },
  },
  config = function()
    vim.g.lazygit_floating_window_winblend = 0
    vim.g.lazygit_floating_window_scaling_factor = 0.9
    vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
    vim.g.lazygit_floating_window_use_plenary = 0
    vim.g.lazygit_use_neovim_remote = 1

    vim.g.lazygit_use_custom_config_file_path = 1
    require("jose.core.theme-sync").refresh_lazygit()
    require("jose.core.lazygit-edit").setup()
  end,
}
