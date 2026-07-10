-- Suppress expensive buffer hooks while auto-session reloads windows.
local M = {}

function M.active()
  return vim.g.jose_restoring_session == true
end

function M.enter()
  vim.g.jose_restoring_session = true
end

function M.leave()
  vim.g.jose_restoring_session = false
end

function M.restore_if_needed()
  if vim.fn.argc() > 0 then
    return
  end

  local ok, as = pcall(require, "auto-session")
  if not ok then
    return
  end

  pcall(as.restore_session, nil, {
    is_autorestore = true,
    is_startup_autorestore = true,
    show_message = false,
  })

  if M.active() then
    M.leave()
  end
end

return M
