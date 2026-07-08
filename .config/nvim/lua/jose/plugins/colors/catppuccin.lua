return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		local function active_family()
			local path = vim.fn.expand("~/.local/state/theme/current.json")
			if vim.fn.filereadable(path) == 1 then
				local ok, data = pcall(vim.fn.json_decode, vim.fn.readfile(path))
				if ok and type(data) == "table" and data.family then
					return data.family
				end
			end
			return "catppuccin"
		end

		if active_family() ~= "catppuccin" then
			require("jose.core.auto-theme").apply()
			return
		end

		require("catppuccin").setup({
			background = { light = "latte", dark = "mocha" },
			integrations = {
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

		-- Apply before lualine loads so catppuccin-nvim theme is available
		require("jose.core.auto-theme").apply()
	end,
}
