-- Bridge to ~/.config/theme/bin/theme-sync for tools launched from Neovim.
local M = {}

function M.run()
  vim.fn.system({ vim.fn.expand("~/.config/theme/bin/theme-sync"), "--quiet" })
end

function M.lazygit_config_paths()
  return {
    vim.fn.expand("~/.config/lazygit/config.yml"),
    vim.fn.expand("~/.config/theme/generated/lazygit-gui.yml"),
  }
end

function M.refresh_lazygit()
  M.run()
  local paths = M.lazygit_config_paths()
  vim.g.lazygit_config_file_path = paths
  vim.env.LG_CONFIG_FILE = table.concat(paths, ",")
end

return M
