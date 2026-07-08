-- Pull in the wezterm API
local wezterm = require("wezterm")

local function read_theme_state()
	local path = wezterm.config_dir .. "/../.local/state/theme/current.json"
	local home = os.getenv("HOME") or ""
	path = home .. "/.local/state/theme/current.json"

	local file = io.open(path, "r")
	if not file then
		return nil
	end

	local contents = file:read("*a")
	file:close()

	local ok, data = pcall(wezterm.json_parse, contents)
	if ok then
		return data
	end
	return nil
end

function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

function scheme_for_appearance(appearance)
	local state = read_theme_state()
	if state and state.tools and state.tools.wezterm then
		return state.tools.wezterm
	end

	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	end
	return "Catppuccin Latte"
end

function scheme_for_gradient(appearance)
	local gradient = {
		orientation = "Vertical",
		interpolation = "CatmullRom",
	}
	if appearance:find("Dark") then
		gradient.orientation = { Linear = { angle = -60.0 } }
		gradient.colors = {
			"#000000",
		}
	else
		gradient.orientation = { Radial = { radius = 1.15 } }
		gradient.colors = {
			"#fffffb",
		}
	end
	return gradient
end

local config = wezterm.config_builder()

config.color_scheme = scheme_for_appearance(get_appearance())
config.window_background_gradient = scheme_for_gradient(get_appearance())

config.font = wezterm.font("SauceCodePro Nerd Font Mono")
config.font_size = 20

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.window_background_opacity = 1.0
config.macos_window_background_blur = 100

config.front_end = "Software"

return config
