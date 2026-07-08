return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		require("gruvbox").setup({
			contrast = "hard",
			transparent_mode = false,
		})
	end,
}
