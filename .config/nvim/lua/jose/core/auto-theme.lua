-- Auto theme switching based on macOS appearance
local M = {}

local last_appearance = nil

-- Function to get macOS appearance
local function get_macos_appearance()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    -- If the command returns "Dark", we're in dark mode
    -- If it returns nothing or errors, we're in light mode
    return result:match("Dark") and "dark" or "light"
  end
  return "light" -- fallback to light mode
end

-- Function to set theme based on appearance
local function set_theme_for_appearance(appearance)
  if appearance == last_appearance then
    return
  end
  last_appearance = appearance

  if appearance == "dark" then
    vim.o.background = "dark"
    vim.cmd.colorscheme("catppuccin-mocha")
  else
    vim.o.background = "light"
    vim.cmd.colorscheme("catppuccin-latte")
  end
end

-- Function to setup auto theme switching
function M.setup()
  -- Set initial theme based on current appearance
  local current_appearance = get_macos_appearance()
  set_theme_for_appearance(current_appearance)
  
  -- Sync when focus returns; defer so treesitter isn't forced during VimEnter
  vim.api.nvim_create_autocmd("FocusGained", {
    group = vim.api.nvim_create_augroup("AutoTheme", { clear = true }),
    callback = function()
      vim.schedule(function()
        set_theme_for_appearance(get_macos_appearance())
      end)
    end,
    desc = "Auto switch theme based on macOS appearance"
  })
  
  -- Also create a command to manually trigger theme check
  vim.api.nvim_create_user_command("ThemeSync", function()
    local appearance = get_macos_appearance()
    set_theme_for_appearance(appearance)
    print("Theme synced to macOS appearance: " .. appearance)
  end, { desc = "Sync theme with macOS appearance" })
  
  -- Command to start the background daemon
  vim.api.nvim_create_user_command("ThemeDaemonStart", function()
    vim.fn.system("~/Developer/users/jose.valle/sandbox/nvim-theme-daemon.sh start &")
    print("Theme daemon started")
  end, { desc = "Start background theme monitoring daemon" })
  
  -- Command to stop the background daemon
  vim.api.nvim_create_user_command("ThemeDaemonStop", function()
    vim.fn.system("~/Developer/users/jose.valle/sandbox/nvim-theme-daemon.sh stop")
    print("Theme daemon stopped")
  end, { desc = "Stop background theme monitoring daemon" })
  
  -- Command to check daemon status
  vim.api.nvim_create_user_command("ThemeDaemonStatus", function()
    local output = vim.fn.system("~/Developer/users/jose.valle/sandbox/nvim-theme-daemon.sh status")
    print(output)
  end, { desc = "Check theme daemon status" })
end

-- Function to manually set theme
function M.set_theme(theme)
  if theme == "dark" or theme == "mocha" then
    set_theme_for_appearance("dark")
  elseif theme == "light" or theme == "latte" then
    set_theme_for_appearance("light")
  else
    print("Unknown theme: " .. theme .. ". Use 'dark', 'mocha', 'light', or 'latte'")
  end
end

return M
