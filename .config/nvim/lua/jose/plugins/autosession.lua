return {
  "rmagatti/auto-session",
  lazy = false,
  config = function()
    local auto_session = require("auto-session")
    local session_guard = require("jose.core.session-guard")

    auto_session.setup({
      auto_restore = false,
      auto_save = true,
      auto_create = true,
      lazy_support = true,

      suppressed_dirs = {
        "~/",
        "~/Downloads",
        "~/Documents",
        "~/Desktop/",
        "/tmp",
        "/",
      },

      session_lens = {
        buftypes_to_ignore = {},
        load_on_setup = false,
        picker_opts = { border = true },
        previewer = false,
      },

      git_use_branch_name = false,

      cwd_change_handling = true,
      post_cwd_changed_cmds = {
        function()
          require("auto-session").SaveSession()
        end,
      },

      log_level = "warn",

      pre_restore_cmds = {
        function()
          session_guard.enter()
        end,
      },

      pre_save_cmds = {
        function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then
              pcall(vim.api.nvim_win_close, win, false)
            end
          end
        end,
        function()
          pcall(vim.cmd, "TroubleClose")
        end,
        function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) then
              local ft = vim.bo[buf].filetype
              local buftype = vim.bo[buf].buftype
              if ft == "NvimTree" or ft == "lazygit" or buftype == "terminal" then
                pcall(vim.api.nvim_buf_delete, buf, { force = true })
              end
            end
          end
        end,
      },

      post_restore_cmds = {
        function()
          session_guard.leave()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
              local buftype = vim.bo[buf].buftype
              local ft = vim.bo[buf].filetype
              if buftype == "directory" or ft == "netrw" then
                pcall(vim.api.nvim_buf_delete, buf, { force = true })
              end
            end
          end
        end,
      },

      root_dir = vim.fn.stdpath("data") .. "/sessions/",

      bypass_save_filetypes = {
        "alpha",
        "dashboard",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "Trouble",
        "trouble",
        "NvimTree",
        "lazygit",
      },
    })

    if vim.env.TMUX then
      local interval_ms = 15 * 60 * 1000
      local timer = vim.uv.new_timer()
      timer:start(interval_ms, interval_ms, vim.schedule_wrap(function()
        pcall(auto_session.auto_save_session)
      end))
    end

    local k = vim.keymap

    k.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
    k.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
    k.set("n", "<leader>wf", "<cmd>SessionSearch<CR>", { desc = "Find sessions" })
    k.set("n", "<leader>wd", "<cmd>SessionDelete<CR>", { desc = "Delete session" })

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

    k.set("n", "<leader>wi", function()
      local session_dir = require("auto-session.lib").current_session_name()
      print("Current session: " .. (session_dir or "none"))
      print("Session dir: " .. vim.fn.stdpath("data") .. "/sessions/")
    end, { desc = "Show session info" })
  end,
}
