-- Pull in the wezterm API
local wezterm = require("wezterm")

-- color scheme follows system (does not work with the mux)
function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return 'Catppuccin Mocha'
    else
        return 'Catppuccin Latte'
    end
end

function scheme_for_gradient(appearance)
    local gradient = {
        orientation = 'Vertical',
        interpolation = 'CatmullRom'
    }
    if appearance:find 'Dark' then
        gradient.orientation = { Linear = { angle = -60.0 } }
        gradient.colors = {
            '#11111b',
            '#181825',
            '#1e1e2e',
            '#313244'
        }
        gradient.colors = { '#000000' }
    else
        gradient.orientation = { Radial = { radius = 1.15 } }
        gradient.colors = {
            '#eff1f5',
            '#dce0e8'
        }
    end
    return gradient
end

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = scheme_for_appearance(get_appearance())

config.window_background_gradient = scheme_for_gradient(get_appearance())

config.font = wezterm.font("SauceCodePro Nerd Font Mono")
config.font_size = 20

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.window_background_opacity = 1.0
config.macos_window_background_blur = 100

-- Configure your leader key (recommended to avoid conflicts)
config.leader = { key = "a", mods = "CTRL" }  -- Use Ctrl+a instead of default Ctrl+b

-- Apply wez-tmux plugin with optional configuration
require("plugins.wez-tmux.plugin").apply_to_config(config, {
    -- Optional: Customize tab index base (0-based or 1-based)
    tab_and_split_indices_are_zero_based = false 
})

-- and finally, return the configuration to wezterm
return config
