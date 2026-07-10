return {
	"rose-pine/neovim",
	name = "rose-pine",
	priority = 1000,
	lazy = true,
	config = function()
		require("rose-pine").setup({
			dark_variant = "moon",
		})
	end,
}
