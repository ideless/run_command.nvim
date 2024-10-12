-- The data is encoded in JSON and stored in a global variable.
-- You should make sure that `vim.opt.sessionoptions` contains `"globals"` for this to work.
-- See `:h Session` for more information.

local M = {}

M.key = ""

M.load = function()
  local success, result = pcall(vim.fn.json_decode, vim.g[M.key])

  if success then
    return result
  end
end

M.save = function(data)
  local success, result = pcall(function()
    vim.g[M.key] = vim.fn.json_encode(data)
  end)

  if not success then
    vim.notify("Failed to save session: " .. result, vim.log.levels.ERROR)
  end
end

M.setup = function(key)
  M.key = key
end

return M
