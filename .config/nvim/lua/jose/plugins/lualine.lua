return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine_require = require("lualine_require")
		lualine_require.require = require

		vim.o.laststatus = vim.g.lualine_laststatus

		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- Custom components for DTEX development
		local function python_venv()
			local venv = vim.env.VIRTUAL_ENV
			if venv then
				return "🐍 " .. vim.fn.fnamemodify(venv, ":t")
			end
			return ""
		end

		local function git_status()
			local git_status = vim.b.gitsigns_status_dict
			if git_status then
				local added = git_status.added or 0
				local modified = git_status.changed or 0
				local removed = git_status.removed or 0
				
				local result = {}
				if added > 0 then table.insert(result, "+" .. added) end
				if modified > 0 then table.insert(result, "~" .. modified) end
				if removed > 0 then table.insert(result, "-" .. removed) end
				
				return table.concat(result, " ")
			end
			return ""
		end

		local function lsp_status()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then
				return ""
			end
			
			local client_names = {}
			for _, client in ipairs(clients) do
				table.insert(client_names, client.name)
			end
			return "LSP: " .. table.concat(client_names, ", ")
		end

		local function diagnostics_count()
			local diagnostics = vim.diagnostic.get(0)
			local errors = 0
			local warnings = 0
			local hints = 0
			local info = 0
			
			for _, diagnostic in ipairs(diagnostics) do
				if diagnostic.severity == vim.diagnostic.severity.ERROR then
					errors = errors + 1
				elseif diagnostic.severity == vim.diagnostic.severity.WARN then
					warnings = warnings + 1
				elseif diagnostic.severity == vim.diagnostic.severity.HINT then
					hints = hints + 1
				elseif diagnostic.severity == vim.diagnostic.severity.INFO then
					info = info + 1
				end
			end
			
			local result = {}
			if errors > 0 then table.insert(result, "E:" .. errors) end
			if warnings > 0 then table.insert(result, "W:" .. warnings) end
			if hints > 0 then table.insert(result, "H:" .. hints) end
			if info > 0 then table.insert(result, "I:" .. info) end
			
			return table.concat(result, " ")
		end

		local function session_name()
			local session = require("auto-session.lib").current_session_name()
			if session and session ~= "" then
				return "📁 " .. vim.fn.fnamemodify(session, ":t")
			end
			return ""
		end

		lualine.setup({
			options = {
				theme = "auto",
				globalstatus = vim.o.laststatus == 3,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { 
					{ "mode", fmt = function(str) return str:sub(1,1) end } -- Shorter mode display
				},
				lualine_b = { 
					"branch",
					{
						git_status,
						color = { fg = "#98be65" },
					}
				},
				lualine_c = { 
					{
						"filename",
						path = 1, -- Show relative path
						symbols = {
							modified = " ●",
							readonly = " ",
							unnamed = "[No Name]",
						}
					},
					{
						python_venv,
						color = { fg = "#51afef" },
					},
					{
						session_name,
						color = { fg = "#c678dd" },
					}
				},
				lualine_x = {
					{
						lsp_status,
						color = { fg = "#98be65" },
					},
					{
						diagnostics_count,
						color = { fg = "#ff6c6b" },
					},
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ecbe7b" },
					},
					{ "encoding", fmt = string.upper },
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
				},
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					{
						function()
							return " " .. os.date("%H:%M")
						end,
						color = { fg = "#51afef" },
					},
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "nvim-tree", "lazy", "mason", "trouble" },
		})
	end,
}
