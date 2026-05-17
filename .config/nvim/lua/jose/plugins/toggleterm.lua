return {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup({
			-- Dynamic sizing - always 50% of screen height
			size = function(term)
				if term.direction == "horizontal" then
					return math.floor(vim.o.lines * 0.5)
				elseif term.direction == "vertical" then
					return math.floor(vim.o.columns * 0.5)
				end
			end,
			direction = "horizontal",
			-- Other useful options
			open_mapping = [[<leader>;]],
			hide_numbers = true,
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = false, -- Don't persist size between sessions
			close_on_exit = true,
			shell = vim.o.shell,
		})

		local k = vim.keymap

		-- Manual keybinding (will use the size function above)
		k.set("n", "<leader>;", "<cmd>:ToggleTerm direction=horizontal<CR>", { desc = "Toggle terminal (50% height)" })

		-- Additional terminal keybindings
		k.set("n", "<leader>tv", "<cmd>:ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal (50% width)" })
		k.set("n", "<leader>tf", "<cmd>:ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })

		local function set_terminal_keymaps()
			local opts = { buffer = 0 }
			vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
		end

		-- Apply mapping to all terminals
		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = [[term://*toggleterm#*]],
			callback = set_terminal_keymaps,
		})

		-- Create a custom Q Chat terminal
		local Terminal = require('toggleterm.terminal').Terminal
		local qchat = Terminal:new({
			cmd = "q chat -r",
			hidden = true,
			direction = "horizontal",
			-- Use the same dynamic sizing as the main config
			size = function(term)
				if term.direction == "horizontal" then
					return math.floor(vim.o.lines * 0.5)
				elseif term.direction == "vertical" then
					return math.floor(vim.o.columns * 0.5)
				end
			end,
		})

		function _QCHAT_TOGGLE()
			qchat:toggle()
		end

		-- Set up keybinding for Q Chat terminal
		k.set("n", "<leader>tc", "<cmd>lua _QCHAT_TOGGLE()<CR>", { desc = "Toggle Q Chat terminal" })
	end,
}
