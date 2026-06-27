return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  dependencies = { "windwp/nvim-ts-autotag" },
  config = function()
    require("nvim-treesitter").setup()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua",
        "luadoc",
        "vim",
        "vimdoc",
        "python",
        "requirements",
        "groovy",
        "bash",
        "dockerfile",
        "markdown",
        "markdown_inline",
        "tmux",
        "toml",
        "git_config",
        "gitcommit",
        "gitignore",
        "json",
        "yaml",
        "sql",
        "jinja",
      },
      auto_install = true,
      highlight = {
        enable = true,
        disable = function(_, buf)
          local max_filesize = 100 * 1024
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > max_filesize
        end,
      },
      indent = { enable = true },
    })

    require("nvim-ts-autotag").setup()
  end,
}
