return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    -- Configuration options
    position = "bottom",
    height = 12, -- Increased height for better visibility
    width = 50,
    icons = true,
    mode = "workspace_diagnostics", -- Default to workspace diagnostics
    fold_open = "",
    fold_closed = "",
    group = true,
    padding = true,
    cycle_results = true, -- Cycle through results with next/prev
    action_keys = {
      close = "q",
      cancel = "<esc>",
      refresh = "r",
      jump = { "<cr>", "<tab>" },
      open_split = { "<c-x>" },
      open_vsplit = { "<c-v>" },
      open_tab = { "<c-t>" },
      jump_close = { "o" },
      toggle_mode = "m",
      toggle_preview = "P",
      hover = "K",
      preview = "p",
      close_folds = { "zM", "zm" },
      open_folds = { "zR", "zr" },
      toggle_fold = { "zA", "za" },
      previous = "k",
      next = "j"
    },
    multiline = true, -- Show multiline diagnostics
    indent_lines = true,
    win_config = { border = "rounded" }, -- Rounded borders
    auto_open = false,
    auto_close = false,
    auto_preview = true,
    auto_fold = false,
    auto_jump = { "lsp_definitions" },
    include_declaration = {
      "lsp_references",
      "lsp_implementations",
      "lsp_definitions"
    },
    signs = {
      error = "",
      warning = "",
      hint = "",
      information = "",
      other = "﫠"
    },
    use_diagnostic_signs = true -- Use the same signs as defined in LSP config
  },
  keys = {
    {
      "<leader>xx",
      "<cmd>TroubleToggle<cr>",
      desc = "Toggle Trouble"
    },
    {
      "<leader>xw",
      "<cmd>TroubleToggle workspace_diagnostics<cr>",
      desc = "Workspace Diagnostics"
    },
    {
      "<leader>xd",
      "<cmd>TroubleToggle document_diagnostics<cr>",
      desc = "Document Diagnostics"
    },
    {
      "<leader>xl",
      "<cmd>TroubleToggle loclist<cr>",
      desc = "Location List"
    },
    {
      "<leader>xq",
      "<cmd>TroubleToggle quickfix<cr>",
      desc = "Quickfix List"
    },
    {
      "gR",
      "<cmd>TroubleToggle lsp_references<cr>",
      desc = "LSP References"
    },
    -- Additional keymaps for Python development
    {
      "<leader>xe",
      "<cmd>TroubleToggle workspace_diagnostics<cr>",
      desc = "Show All Errors"
    },
    {
      "<leader>xp",
      function()
        require("trouble").toggle("document_diagnostics")
        -- Focus on Python files if available
        vim.cmd("TroubleRefresh")
      end,
      desc = "Python File Diagnostics"
    },
  },
}
