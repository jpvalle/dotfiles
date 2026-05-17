-- Session debugging utilities
local M = {}

function M.debug_session()
  local cwd = vim.fn.getcwd()
  local session_dir = vim.fn.stdpath("data") .. "/sessions"
  local session_name = cwd:gsub("/", "%%2F") .. ".vim"
  local session_file = session_dir .. "/" .. session_name
  
  print("=== Session Debug Info ===")
  print("Current directory: " .. cwd)
  print("Session directory: " .. session_dir)
  print("Expected session file: " .. session_file)
  print("Session file exists: " .. (vim.fn.filereadable(session_file) == 1 and "YES" or "NO"))
  
  if vim.fn.filereadable(session_file) == 1 then
    local file_info = vim.fn.getfperm(session_file)
    local file_time = vim.fn.getftime(session_file)
    print("Session file permissions: " .. file_info)
    print("Session file modified: " .. os.date("%Y-%m-%d %H:%M:%S", file_time))
  end
  
  -- Check auto-session status
  local auto_session_ok, auto_session = pcall(require, "auto-session")
  if auto_session_ok then
    print("Auto-session plugin: LOADED")
    print("Auto-restore enabled: " .. tostring(require("auto-session.config").auto_restore_enabled))
  else
    print("Auto-session plugin: NOT LOADED")
  end
  
  -- List all session files
  print("\n=== Available Sessions ===")
  local sessions = vim.fn.glob(session_dir .. "/*.vim", false, true)
  for _, session in ipairs(sessions) do
    local name = vim.fn.fnamemodify(session, ":t:r"):gsub("%%2F", "/")
    print("  " .. name)
  end
end

-- Create command
vim.api.nvim_create_user_command('SessionDebug', M.debug_session, {})

return M
