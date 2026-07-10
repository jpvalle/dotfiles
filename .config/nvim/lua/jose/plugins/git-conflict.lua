return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("git-conflict").setup({
      default_mappings = true, -- disable buffer local mapping created by this plugin
      default_commands = true, -- disable commands created by this plugin
      disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
      list_opener = 'copen', -- command or function to open the conflicts list
      highlights = { -- They must have background color, otherwise the default color will be used
        incoming = 'DiffAdd',
        current = 'DiffText',
      }
    })
    
    -- Custom keymaps for conflict resolution
    vim.keymap.set('n', '<leader>gco', '<Plug>(git-conflict-ours)', { desc = 'Choose Ours (Current)' })
    vim.keymap.set('n', '<leader>gct', '<Plug>(git-conflict-theirs)', { desc = 'Choose Theirs (Incoming)' })
    vim.keymap.set('n', '<leader>gcb', '<Plug>(git-conflict-both)', { desc = 'Choose Both' })
    vim.keymap.set('n', '<leader>gc0', '<Plug>(git-conflict-none)', { desc = 'Choose None' })
    vim.keymap.set('n', '<leader>gcn', '<Plug>(git-conflict-next-conflict)', { desc = 'Next Conflict' })
    vim.keymap.set('n', '<leader>gcP', '<Plug>(git-conflict-prev-conflict)', { desc = 'Previous Conflict' })
  end,
}
