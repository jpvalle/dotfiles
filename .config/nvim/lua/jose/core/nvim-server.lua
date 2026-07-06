-- Start a Neovim RPC server so child processes (lazygit, git, etc.) can
-- open files in this exact session instead of spawning a new nvim.
local M = {}

function M.setup()
  if vim.fn.has("nvim") ~= 1 then
    return
  end

  local socket_dir = "/tmp/nvim-sockets"
  local socket_path = socket_dir .. "/nvim-" .. vim.fn.getpid()

  vim.fn.system({ "mkdir", "-p", socket_dir })

  if vim.v.servername == "" then
    local ok = pcall(vim.fn.serverstart, socket_path)
    if not ok then
      pcall(vim.fn.serverstart)
    end
  end

  local server = vim.v.servername
  if server ~= "" then
    vim.env.NVIM = server
    vim.env.NVIM_LISTEN_ADDRESS = server
  end

  if vim.fn.executable("nvr") == 1 then
    vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
  end

  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
      if vim.fn.filereadable(socket_path) == 1 then
        vim.fn.delete(socket_path)
      end
    end,
  })
end

--- Refresh server env vars before spawning a child process.
function M.export_env()
  local server = vim.v.servername
  if server ~= "" then
    vim.env.NVIM = server
    vim.env.NVIM_LISTEN_ADDRESS = server
  end
end

return M
