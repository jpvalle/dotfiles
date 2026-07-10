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

function M.refresh_lazygit(callback)
  M.run_async(function()
    local paths = M.lazygit_config_paths()
    vim.g.lazygit_config_file_path = paths
    vim.env.LG_CONFIG_FILE = table.concat(paths, ",")
    if callback then
      callback()
    end
  end)
end

return M
