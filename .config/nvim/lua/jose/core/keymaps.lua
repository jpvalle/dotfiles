-- jk remap already made in top level init.lua

-- set leader key to space
vim.g.mapleader = " "

local k = vim.keymap

-- Highlights
k.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- X-crement numbers
k.set("n", "<leader>+", "<C-a>", { desc = "Increment number in focus" })
k.set("n", "<leader>-", "<C-x>", { desc = "Decrement number in focus" })

-- Split window shortcuts
k.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
k.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
k.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
k.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Tab window shortcuts
k.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
k.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
k.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
k.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
k.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in tab" })

-- Diagnostic navigation (enhanced for Python development)
k.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
k.set("n", "[e", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
k.set("n", "]e", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
k.set("n", "<leader>E", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Go to next error" })
k.set("n", "<leader>W", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Go to next warning" })
