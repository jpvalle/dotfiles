return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			background = { light = "latte", dark = "mocha" },
			integrations = {
				gitsigns = true,
				lualine = {},
			},
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
			flavor = "auto",
			transparent_background = true,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.01,
			},
			term_colors = true,
		})

		require("jose.core.auto-theme").apply()
	end,
}
