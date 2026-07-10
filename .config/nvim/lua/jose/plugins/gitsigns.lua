return {
	"lewis6991/gitsigns.nvim",
	-- Load when buffers open (not VeryLazy) so files from lazygit get highlights immediately.
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "▁" },
			topdelete = { text = "▁" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		signs_staged = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "▁" },
			topdelete = { text = "▁" },
			changedelete = { text = "▎" },
		},
		signcolumn = true,
		numhl = true,
		linehl = false,
		word_diff = true,
		word_diff_opts = { char_len = true },
		watch_gitdir = {
			enable = true,
			follow_files = true,
		},
		auto_attach = true,
		attach_to_untracked = true,
		current_line_blame = true,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 250,
			ignore_whitespace = false,
		},
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> • <summary>",
		preview_config = {
			border = "rounded",
			style = "minimal",
		},
		on_attach = function(bufnr)
			local gs = require("gitsigns")

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			map("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.nav_hunk("next")
				end)
			end, "Next git hunk")

			map("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.nav_hunk("prev")
				end)
			end, "Previous git hunk")

			map("n", "<leader>gp", function()
				gs.preview_hunk()
			end, "Preview git hunk")
			map("n", "<leader>gs", function()
				gs.stage_hunk()
			end, "Stage git hunk")
			map("n", "<leader>gr", function()
				gs.reset_hunk()
			end, "Reset git hunk")
			map("v", "<leader>gs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Stage selected git hunk")
			map("v", "<leader>gr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Reset selected git hunk")
			map("n", "<leader>gS", function()
				gs.stage_buffer()
			end, "Stage buffer")
			map("n", "<leader>gR", function()
				gs.reset_buffer()
			end, "Reset buffer")
			map("n", "<leader>gu", function()
				gs.undo_stage_hunk()
			end, "Undo stage hunk")
			map("n", "<leader>gt", function()
				gs.toggle_current_line_blame()
			end, "Toggle git blame line")
			map("n", "<leader>gtd", function()
				gs.diffthis()
			end, "Diff buffer against index")
		end,
	},
	config = function(_, opts)
		require("gitsigns").setup(opts)

		local group = vim.api.nvim_create_augroup("jose-gitsigns", { clear = true })
		vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
			group = group,
			callback = function()
				if vim.bo.buftype ~= "" or vim.bo.filetype == "lazygit" then
					return
				end
				pcall(require("gitsigns").refresh)
			end,
		})
	end,
}
