-- Auto theme switching based on macOS appearance
local M = {}

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
  if appearance == "dark" then
    vim.cmd.colorscheme("catppuccin-mocha")
    -- Update the catppuccin flavor setting
    require("catppuccin").setup({
      flavor = "mocha",
      styles = {
        comments = { "italic" },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      transparent_background = true,
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.01,
      },
      term_colors = true,
    })
    vim.cmd("redraw!")  -- Force redraw to apply theme immediately
  else
    vim.cmd.colorscheme("catppuccin-latte")
    -- Update the catppuccin flavor setting
    require("catppuccin").setup({
      flavor = "latte",
      styles = {
        comments = { "italic" },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      transparent_background = true,
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.01,
      },
      term_colors = true,
    })
    vim.cmd("redraw!")  -- Force redraw to apply theme immediately
  end
end

-- Function to setup named socket for external communication
local function setup_socket()
  local socket_dir = "/tmp/nvim-sockets"
  local socket_name = "nvim-" .. vim.fn.getpid()
  local socket_path = socket_dir .. "/" .. socket_name
  
  -- Create socket directory
  vim.fn.system("mkdir -p " .. socket_dir)
  
  -- Set up server with named socket
  if vim.fn.has('nvim') == 1 then
    local ok, result = pcall(vim.fn.serverstart, socket_path)
    if not ok then
      -- Fallback to default serverstart if named socket fails
      pcall(vim.fn.serverstart)
    end
  end
  
  -- Clean up socket on exit
  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
      vim.fn.system("rm -f " .. socket_path)
    end,
  })
end

-- Function to setup auto theme switching
function M.setup()
  -- Setup named socket for external communication
  setup_socket()
  
  -- Set initial theme based on current appearance
  local current_appearance = get_macos_appearance()
  set_theme_for_appearance(current_appearance)
  
  -- Create an autocommand that checks appearance when Neovim gains focus
  vim.api.nvim_create_autocmd({"FocusGained", "VimEnter"}, {
    group = vim.api.nvim_create_augroup("AutoTheme", { clear = true }),
    callback = function()
      local appearance = get_macos_appearance()
      set_theme_for_appearance(appearance)
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
