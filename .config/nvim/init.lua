vim.cmd("let g:netrw_liststyle = 3") -- easier navigation with :Explore
vim.cmd([[autocmd FileType * set formatoptions-=cro]]) -- stop autocommenting next line
vim.keymap.set("i", "jk", "<ESC>", { noremap = true, desc = "Exit insert mode with jk" })
vim.opt.termguicolors = true

-- Disable unnecessary providers to clean up health warnings
vim.g.loaded_perl_provider = 0 -- Disable Perl provider
vim.g.loaded_ruby_provider = 0 -- Disable Ruby provider

local python3 = vim.fn.exepath("python3.13")
if python3 == "" then
  python3 = vim.fn.exepath("python3")
end
if python3 ~= "" then
  vim.g.python3_host_prog = python3
end

-- -- Setup server for remote editing BEFORE loading plugins
-- -- This ensures lazygit can connect to this Neovim instance
-- if vim.fn.has('nvim') == 1 then
--   -- Start server if not already running
--   if vim.v.servername == '' or vim.v.servername == nil then
--     vim.fn.serverstart()
--   end
--   
--   -- Set environment variables for child processes (like lazygit)
--   vim.env.NVIM = "1"
--   vim.env.NVIM_SERVER = vim.v.servername
--   vim.env.NVIM_LISTEN_ADDRESS = vim.v.servername
--   
--   -- Configure neovim-remote for lazygit integration (from plugin docs)
--   if vim.fn.executable('nvr') == 1 then
--     vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
--   end
-- end

require("jose.core") -- ~/.config/nvim/lua/jose/core/init.lua
require("jose.lazy") -- ~/.config/nvim/lua/jose/lazy.lua

-- Setup automatic theme switching based on macOS appearance
require("jose.core.auto-theme").setup()
-- Manual theme switching is now handled by auto-theme module
-- Use :ThemeSync command to manually sync with macOS appearance
-- Or call require("jose.core.auto-theme").set_theme("dark") or .set_theme("light")
