return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = { "windwp/nvim-ts-autotag" },
  config = function()
    require("nvim-treesitter").setup()

    local ensure_installed = {
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
    }

    -- install whatever's missing on startup
    local installed = require("nvim-treesitter.config").get_installed()
    local to_install = vim.iter(ensure_installed)
      :filter(function(p) return not vim.tbl_contains(installed, p) end)
      :totable()
    if #to_install > 0 then
      require("nvim-treesitter").install(to_install)
    end

    local max_filesize = 100 * 1024
    local function file_too_big(buf)
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      return ok and stats and stats.size > max_filesize
    end

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        -- install the parser for whatever filetype you just opened
        local lang = vim.treesitter.language.get_lang(args.match) or args.match
        pcall(function() require("nvim-treesitter").install({ lang }) end)

        -- indent enable = true
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        -- highlight = enable = true
        if not file_too_big(args.buf) then
          pcall(vim.treesitter.start)
        end
      end,
    })

    require("nvim-ts-autotag").setup()
  end,
}
