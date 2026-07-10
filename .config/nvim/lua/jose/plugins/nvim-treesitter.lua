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

local function attach_treesitter(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not treesitter_enabled(buf) then
    return
  end

  local visible = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      visible = true
      break
    end
  end

  if not visible then
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      buffer = buf,
      once = true,
      callback = function()
        vim.schedule(function()
          attach_treesitter(buf)
        end)
      end,
    })
    return
  end

  local ok = pcall(vim.treesitter.start, buf)
  if ok then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = "CursorMoved",
  build = ":TSUpdate",
  dependencies = { "windwp/nvim-ts-autotag" },
  config = function()
    if require("jose.core.session-guard").active() then
      return
    end

    require("nvim-treesitter").setup({
      ensure_installed = parsers,
    })

    local group = vim.api.nvim_create_augroup("jose-treesitter", { clear = true })
    vim.api.nvim_create_autocmd({ "FileType", "BufReadPost" }, {
      group = group,
      callback = function(args)
        if require("jose.core.session-guard").active() then
          return
        end
        vim.schedule(function()
          attach_treesitter(args.buf or vim.api.nvim_get_current_buf())
        end)
      end,
    })

    vim.schedule(function()
      attach_treesitter(vim.api.nvim_get_current_buf())
    end)
    require("nvim-ts-autotag").setup()
  end,
}
