return {
  "rmagatti/auto-session",
  lazy = false, -- Load immediately to ensure session restoration works
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      -- Updated parameter names (new config format)
      auto_restore = true,
      auto_save = true,
      auto_create = true,
      
      -- Directories to suppress auto-session
      suppressed_dirs = { 
        "~/", 
        "~/Developer/", 
        "~/Downloads", 
        "~/Documents", 
        "~/Desktop/",
        "/tmp",
        "/",
      },
      
      -- Session lens for better session management
      session_lens = {
        buftypes_to_ignore = {}, 
        load_on_setup = true,
        picker_opts = { border = true },
        previewer = false,
      },
      
      -- Don't create separate sessions per git branch
      git_use_branch_name = false,
      
      cwd_change_handling = true,
      post_cwd_changed_cmds = {
        function()
          require("auto-session").SaveSession()
        end,
      },
      
      log_level = "warn",
      
      -- Pre-save hook to clean up before saving
      pre_save_cmds = {
        -- Close any floating windows before saving
        function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then
              pcall(vim.api.nvim_win_close, win, false)
            end
          end
        end,
        -- Close any trouble windows
        function()
          pcall(vim.cmd, "TroubleClose")
        end,
      },
      
      -- Post-restore hook to set up environment after session restore
      post_restore_cmds = {
        function()
          -- Refresh file tree if it exists
          pcall(vim.cmd, "NvimTreeRefresh")
        end,
      },
      
      -- Session directory
      root_dir = vim.fn.stdpath("data") .. "/sessions/",
      
      -- Bypass session save/restore for certain filetypes
      bypass_save_filetypes = {
        "alpha",
        "dashboard",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "Trouble",
        "trouble",
      },
    })

    local k = vim.keymap

    k.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
    k.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
    k.set("n", "<leader>wf", "<cmd>SessionSearch<CR>", { desc = "Find sessions" })
    k.set("n", "<leader>wd", "<cmd>SessionDelete<CR>", { desc = "Delete session" })
    
    -- Workspace-specific session management
    k.set("n", "<leader>ww", function()
      local cwd = vim.fn.getcwd()
      require("auto-session").SaveSession(cwd)
      print("Saved session for workspace: " .. vim.fn.fnamemodify(cwd, ":t"))
    end, { desc = "Save current workspace session" })
    
    k.set("n", "<leader>wl", function()
      local cwd = vim.fn.getcwd()
      require("auto-session").RestoreSession(cwd)
      print("Restored session for workspace: " .. vim.fn.fnamemodify(cwd, ":t"))
    end, { desc = "Load current workspace session" })
    
    -- Debug command to check session status
    k.set("n", "<leader>wi", function()
      local session_dir = require("auto-session.lib").current_session_name()
      print("Current session: " .. (session_dir or "none"))
      print("Session dir: " .. vim.fn.stdpath("data") .. "/sessions/")
    end, { desc = "Show session info" })
  end,
}
