return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	config = function()
		vim.opt.termguicolors = true
		require("bufferline").setup({
			options = {
				mode = "tabs", -- set to "tabs" to only show tabpages instead
				themable = false, -- allows highlight groups to be overriden i.e. sets highlights as default
				color_icons = false,
				diagnostics = false,
				separator_style = "padded_slant", -- "(padded_)slanted" | "(padded_)slope" | "thick" | "thin" | { 'any', 'any' },
				auto_toggle_bufferline = false,
				show_tab_indicators = true,
				view = "multiwindow",
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
					},
				},
			},
		})
	end,
}
