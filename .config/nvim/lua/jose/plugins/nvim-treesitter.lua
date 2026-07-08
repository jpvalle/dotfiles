local parsers = {
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
}

local function treesitter_enabled(buf)
  local ft = vim.bo[buf].filetype
  -- ansible-vim handles treesitter for playbooks; vim syntax for *.j2 templates
  if ft == "ansible" or ft:match("jinja2") then
    return false
  end

  local max_filesize = 100 * 1024
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return false
  end

  return true
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = { "windwp/nvim-ts-autotag" },
  config = function()
    require("nvim-treesitter").setup()
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("jose-treesitter", { clear = true }),
      callback = function(args)
        local buf = args.buf
        if not treesitter_enabled(buf) then
          return
        end

        local ok = pcall(vim.treesitter.start, buf)
        if ok then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    require("nvim-ts-autotag").setup()
  end,
}
