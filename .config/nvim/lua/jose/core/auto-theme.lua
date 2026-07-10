-- Auto theme switching from ~/.config/theme/manifest.toml (via theme-sync state)
local M = {}

local last_applied = nil

local FAMILY_PLUGINS = {
	catppuccin = "catppuccin",
	dracula = "dracula",
	gruvbox = "gruvbox.nvim",
	["rose-pine"] = "rose-pine",
	tokyonight = "tokyonight.nvim",
	nord = "nord-vim",
	solarized = "solarized.nvim",
}

local function ensure_theme_plugin(theme)
	local plugin = FAMILY_PLUGINS[theme.family]
	if not plugin then
		return
	end

	local ok, lazy = pcall(require, "lazy")
	if ok then
		lazy.load({ plugins = { plugin } })
	end
end

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
      family = "catppuccin",
    }
  end
  return {
    appearance = "light",
    background = "light",
    colorscheme = "catppuccin-latte",
    p10k = "latte",
    family = "catppuccin",
  }
end

local function resolve_theme(state)
  local os_appearance = get_macos_appearance()

  if state and state.tools then
    local colorscheme = state.tools.nvim or "catppuccin-mocha"
    local appearance = state.appearance or os_appearance
    local background = state.tools.nvim_background or appearance

    if state.mode == "system" then
      appearance = os_appearance
      background = os_appearance
      if state.family == "catppuccin" or colorscheme:match("^catppuccin%-") then
        colorscheme = os_appearance == "dark" and "catppuccin-mocha" or "catppuccin-latte"
      end
    end

    return {
      appearance = appearance,
      background = background,
      colorscheme = colorscheme,
      p10k = state.tools.p10k,
      family = state.family,
    }
  end
  return fallback_theme()
end

--- Set `background` from macOS before plugins load (~30ms, non-blocking for UX).
function M.bootstrap()
  vim.o.background = get_macos_appearance()
end

function M.apply(theme)
  theme = theme or resolve_theme(read_theme_state())
  ensure_theme_plugin(theme)

  local key = theme.appearance .. ":" .. theme.colorscheme .. ":" .. theme.background
  if key == last_applied then
    return
  end
  last_applied = key

  vim.o.background = theme.background
  pcall(vim.cmd.colorscheme, theme.colorscheme)

  if package.loaded["lualine"] then
    vim.schedule(function()
      require("lualine").refresh({ force = true })
    end)
  end
end

function M.setup()
  M.apply(resolve_theme(read_theme_state()))

  vim.api.nvim_create_autocmd("FocusGained", {
    group = vim.api.nvim_create_augroup("AutoTheme", { clear = true }),
    callback = function()
      require("jose.core.theme-sync").run_async(function()
        last_applied = nil
        M.apply(resolve_theme(read_theme_state()))
      end)
    end,
    desc = "Sync theme from central manifest",
  })

  vim.api.nvim_create_user_command("ThemeSync", function()
    require("jose.core.theme-sync").run_async(function()
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
    end)
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
  theme.family = "catppuccin"
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
