-- Keyboard-friendly gitsigns hunk previews.
local M = {}

local function close_float(main_win)
	require("gitsigns.popup").close("hunk")
	if vim.api.nvim_win_is_valid(main_win) then
		vim.api.nvim_set_current_win(main_win)
	end
end

--- Floating hunk preview: auto-focus + vim scroll/close keys.
function M.open_float()
	local gs = require("gitsigns")
	local main_win = vim.api.nvim_get_current_win()

	gs.preview_hunk()

	local popup = require("gitsigns.popup")
	local winid = popup.focus_open("hunk")
	if not winid then
		return
	end

	local bufnr = vim.api.nvim_win_get_buf(winid)
	local opts = { buffer = bufnr, nowait = true, silent = true }

	local function close()
		close_float(main_win)
	end

	local function walk(direction)
		close()
		vim.schedule(function()
			gs.nav_hunk(direction)
			M.open_float()
		end)
	end

	vim.keymap.set("n", "q", close, vim.tbl_extend("force", opts, { desc = "Close hunk preview" }))
	vim.keymap.set("n", "<Esc>", close, opts)
	vim.keymap.set("n", "<Tab>", function()
		walk("next")
	end, vim.tbl_extend("force", opts, { desc = "Next hunk preview" }))
	vim.keymap.set("n", "<S-Tab>", function()
		walk("prev")
	end, opts)
	-- j/k/C-d/C-u work once the float has focus; these are explicit scroll helpers.
	vim.keymap.set("n", "<C-e>", "5j", opts)
	vim.keymap.set("n", "<C-y>", "5k", opts)
end

return M
