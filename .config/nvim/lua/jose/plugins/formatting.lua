return {
	"stevearc/conform.nvim",
	event = "CursorMoved",
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "autopep8" }, -- PEP8-only formatting
				groovy = { "npm-groovy-lint" },
				yaml = { "yamlfix", "yq" },
				json = { "jq" },
			},
			-- DISABLED: No auto-formatting on save
			-- format_on_save = {
			-- 	lsp_fallback = true,
			-- 	async = false,
			-- 	timeout_ms = 1000,
			-- },
		})

		-- Manual formatting keybinding - only format when you choose to
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
		
		-- Additional Python-specific PEP8 formatting keybinding
		vim.keymap.set({ "n", "v" }, "<leader>pf", function()
			if vim.bo.filetype == "python" then
				conform.format({
					formatters = { "autopep8" },
					async = false,
					timeout_ms = 1000,
				})
			else
				vim.notify("PEP8 formatting is only for Python files", vim.log.levels.WARN)
			end
		end, { desc = "Format Python file with PEP8 (autopep8)" })
	end,
}
