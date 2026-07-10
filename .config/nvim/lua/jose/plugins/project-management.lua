return {
  -- Project management for multiple repos
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "setup.py", "pyproject.toml" },
        ignore_lsp = {},
        exclude_dirs = {},
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = 'global',
      })
      require('telescope').load_extension('projects')
    end,
    keys = {
      { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Find projects" },
    },
  },

  -- Better file explorer
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = false, -- Keep nvim-tree as default
        columns = {
          "icon",
          "permissions",
          "size",
          "mtime",
        },
        buf_options = {
          buflisted = false,
          bufhidden = "hide",
        },
        win_options = {
          wrap = false,
          signcolumn = "no",
          cursorcolumn = false,
          foldcolumn = "0",
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = "nvic",
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = "actions.select_vsplit",
          ["<C-h>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
        },
        use_default_keymaps = true,
        view_options = {
          show_hidden = false,
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
          end,
          is_always_hidden = function(name, bufnr)
            return false
          end,
        },
      })
    end,
    keys = {
      { "<leader>o", "<cmd>Oil<cr>", desc = "Open Oil file explorer" },
    },
  },

  -- Harpoon for quick file switching (perfect for multi-repo work)
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>a", function() require("harpoon"):list():append() end, desc = "Harpoon mark file" },
      { "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon quick menu" },
      { "<C-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
      { "<C-t>", function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
      { "<C-n>", function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
      { "<C-s>", function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
      { "<C-S-P>", function() require("harpoon"):list():prev() end, desc = "Harpoon previous" },
      { "<C-S-N>", function() require("harpoon"):list():next() end, desc = "Harpoon next" },
    },
    config = function()
      require("harpoon"):setup()
    end,
  },
}
