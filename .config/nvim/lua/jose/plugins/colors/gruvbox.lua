return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	lazy = true,
	config = function()
		require("gruvbox").setup({
			contrast = "hard",
			transparent_mode = false,
		})
	end,
}
