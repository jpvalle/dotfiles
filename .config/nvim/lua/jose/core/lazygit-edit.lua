-- Open a file from lazygit in the main Neovim window and dismiss the lazygit float.
local M = {}

local function state_file()
  return (os.getenv("XDG_STATE_HOME") or (vim.env.HOME .. "/.local/state")) .. "/lazygit/edit.target"
end

local function close_lazygit_float()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "lazygit" then
        vim.api.nvim_win_close(win, true)
        if vim.api.nvim_buf_is_valid(buf) then
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
        return true
      end
    end
  end
  return false
end

local function main_edit_win()
  local tab = vim.api.nvim_get_current_tabpage()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      return win
    end
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      return win
    end
  end
  return vim.api.nvim_get_current_win()
end

function M.open(filename, line)
  filename = vim.fn.expand(filename)
  if filename == "" then
    return
  end

  close_lazygit_float()
  vim.api.nvim_set_current_win(main_edit_win())

  line = tonumber(line)
  if line then
    vim.cmd("edit +" .. line .. " " .. vim.fn.fnameescape(filename))
  else
    vim.cmd("edit " .. vim.fn.fnameescape(filename))
  end
end

--- Called from lazygit config via nvim --remote-send (path written to state file first).
function M.dispatch()
  local path = state_file()
  if vim.fn.filereadable(path) ~= 1 then
    return
  end

  local lines = vim.fn.readfile(path)
  pcall(vim.fn.delete, path)

  if #lines == 0 then
    return
  end

  M.open(lines[1], lines[2])
end

function M.setup()
  vim.api.nvim_create_user_command("LazyGitEdit", function(opts)
    M.open(opts.fargs[1], opts.fargs[2])
  end, {
    nargs = "+",
    complete = "file",
    desc = "Open a file from lazygit in the current window",
  })
end

return M
