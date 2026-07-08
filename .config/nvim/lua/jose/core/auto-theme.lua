-- Auto theme switching from ~/.config/theme/manifest.toml (via theme-sync state)
local M = {}

local last_applied = nil

local function state_path()
  return vim.fn.expand("~/.local/state/theme/current.json")
end

local function get_macos_appearance()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if not handle then
    return "light"
  end
  local result = handle:read("*a")
  handle:close()
  return result:match("Dark") and "dark" or "light"
end

local function read_theme_state()
  local path = state_path()
  if vim.fn.filereadable(path) ~= 1 then
    return nil
  end

  local ok, data = pcall(vim.fn.json_decode, vim.fn.readfile(path))
  if not ok or type(data) ~= "table" then
    return nil
  end
  return data
end

local function sync_theme_state()
  require("jose.core.theme-sync").run()
  return read_theme_state()
end

local function fallback_theme()
  local appearance = get_macos_appearance()
  if appearance == "dark" then
    return {
      appearance = "dark",
      background = "dark",
      colorscheme = "catppuccin-mocha",
      p10k = "mocha",
    }
  end
  return {
    appearance = "light",
    background = "light",
    colorscheme = "catppuccin-latte",
    p10k = "latte",
  }
end

local function resolve_theme(state)
  if state and state.tools then
    return {
      appearance = state.appearance or "dark",
      background = state.tools.nvim_background or state.appearance or "dark",
      colorscheme = state.tools.nvim or "catppuccin-mocha",
      p10k = state.tools.p10k,
      family = state.family,
    }
  end
  return fallback_theme()
end

function M.apply(theme)
  theme = theme or resolve_theme(read_theme_state())

  local key = theme.appearance .. ":" .. theme.colorscheme .. ":" .. theme.background
  if key == last_applied then
    return
  end
  last_applied = key

  vim.o.background = theme.background
  vim.cmd.colorscheme(theme.colorscheme)

  if package.loaded["lualine"] then
    vim.schedule(function()
      require("lualine").refresh({ force = true })
    end)
  end
end

function M.setup()
  M.apply(resolve_theme(sync_theme_state()))

  vim.api.nvim_create_autocmd("FocusGained", {
    group = vim.api.nvim_create_augroup("AutoTheme", { clear = true }),
    callback = function()
      vim.schedule(function()
        sync_theme_state()
        M.apply(resolve_theme(read_theme_state()))
      end)
    end,
    desc = "Sync theme from central manifest",
  })

  vim.api.nvim_create_user_command("ThemeSync", function()
    sync_theme_state()
    last_applied = nil
    M.apply(resolve_theme(read_theme_state()))
    local theme = resolve_theme(read_theme_state())
    print(
      string.format(
        "Theme synced: %s / %s (%s)",
        theme.family or "catppuccin",
        theme.p10k or "?",
        theme.appearance or "?"
      )
    )
  end, { desc = "Sync theme from ~/.config/theme/manifest.toml" })
end

function M.set_theme(name)
  local map = {
    dark = "dark",
    mocha = "dark",
    light = "light",
    latte = "light",
  }
  local appearance = map[name]
  if not appearance then
    print("Unknown theme: " .. name .. ". Use dark, mocha, light, or latte")
    return
  end

  local theme = resolve_theme(read_theme_state())
  theme.appearance = appearance
  theme.background = appearance
  if appearance == "dark" then
    theme.colorscheme = "catppuccin-mocha"
    theme.p10k = "mocha"
  else
    theme.colorscheme = "catppuccin-latte"
    theme.p10k = "latte"
  end

  last_applied = nil
  M.apply(theme)
end

return M
