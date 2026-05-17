return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		-- Base configuration that will be updated by auto-theme
		require("catppuccin").setup({
			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { "italic" }, -- Change the style of comments
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
				-- miscs = {}, -- Uncomment to turn off hard-coded styles
			},
			-- custom_highlights = function(colors)
			--     return {
			--         Comment = { fg = colors.flamingo },
			--     }
			-- end,
			flavor = "auto", -- This will be overridden by auto-theme
			transparent_background = true,
			dim_inactive = {
				enabled = false, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.01, -- percentage of the shade to apply to the inactive window
			},
			term_colors = true,
		})
	end,
}
