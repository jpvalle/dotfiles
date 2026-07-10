-- Bridge to ~/.config/theme/bin/theme-sync for tools launched from Neovim.
local M = {}

local function theme_sync_cmd()
  return { vim.fn.expand("~/.config/theme/bin/theme-sync"), "--quiet" }
end

function M.run()
  vim.fn.system(theme_sync_cmd())
end

--- Non-blocking theme sync; optional callback runs on the main loop after exit.
function M.run_async(callback)
  vim.system(theme_sync_cmd(), {}, function(res)
    vim.schedule(function()
      if callback then
        callback(res.code == 0)
      end
    end)
  end)
end

function M.lazygit_config_paths()
  return {
    vim.fn.expand("~/.config/lazygit/config.yml"),
    vim.fn.expand("~/.config/theme/generated/lazygit-gui.yml"),
  }
end

local function apply_lazygit_paths()
  local paths = M.lazygit_config_paths()
  vim.g.lazygit_config_file_path = paths
  vim.env.LG_CONFIG_FILE = table.concat(paths, ",")
end

--- Set LG_CONFIG_FILE for lazygit without blocking on theme-sync when state exists.
function M.refresh_lazygit(callback)
  local function finish()
    apply_lazygit_paths()
    if callback then
      callback()
    end
  end

  -- theme-sync already runs from zsh precmd / auto-theme; avoid ~3s python on every open.
  if vim.fn.filereadable(vim.fn.expand("~/.local/state/theme/current.json")) == 1 then
    finish()
    return
  end

  M.run_async(function()
    finish()
  end)
end

return M
