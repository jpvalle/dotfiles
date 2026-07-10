-- File tree: nvim-tree + oil; disable netrw so `nvim .` does not hijack startup.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
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

require("jose.core.nvim-server").setup()

require("jose.core") -- ~/.config/nvim/lua/jose/core/init.lua
require("jose.lazy") -- ~/.config/nvim/lua/jose/lazy.lua

-- Setup automatic theme switching from ~/.config/theme/manifest.toml
require("jose.core.auto-theme").setup()
-- Use :ThemeSync to manually sync with the central theme manifest
