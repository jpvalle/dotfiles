local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative is on)

-- tabs & indentation
opt.tabstop = 4 -- number of spaces for tabs
opt.shiftwidth = 4 -- num spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting a new line

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true -- Mixed case implies case-sensitive search

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
opt.termguicolors = true -- turn on termguicolors
opt.background = "light" -- default for colorschemes that have either dark or light
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, eol, or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfiles
opt.swapfile = false

-- Session options for better session restoration
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Diagnostic configuration - COMPLETELY DISABLED
vim.diagnostic.config({
  virtual_text = false, -- No inline text
  signs = false, -- No gutter signs
  underline = false, -- No underlines
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    focusable = false,
  },
})

-- Completely disable all LSP diagnostics for Python files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.diagnostic.enable(false, { bufnr = 0 }) -- Disable diagnostics for current buffer
  end,
})

-- Automatically set syntax for certain containerfile extensions and filenames
vim.filetype.add({
    filename = {
        ["Containerfile"] = "dockerfile",
    },
    extension = {
        ["containerfile"] = "dockerfile",
    },
    pattern = {
        ["docker%-compose%.ya?ml"] = "yaml.docker-compose",
        ["%.gitlab%-ci%.ya?ml"] = "yaml.gitlab",
        ["values%.ya?ml"] = "yaml.helm-values",
    },
})
