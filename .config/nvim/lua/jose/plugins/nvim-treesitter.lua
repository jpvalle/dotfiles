return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
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
        "jinja_inline",
        "yaml",
      },
      auto_install = true,
      highlight = {
        enable = true,
        disable = function(lang, buf)
          local ft = vim.bo[buf].filetype
          -- ansible-vim handles treesitter for playbooks; vim syntax for *.j2 templates
          if ft == "ansible" or ft:match("jinja2") then
            return true
          end
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
