local Terminal = require('toggleterm.terminal').Terminal
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local M = {}

-- Default configuration
M.config = {
  initial_command = "echo 'You have not executed any command'",
  window = {
    direction = "horizontal",
    name = "cmd_term",
  }
}

-- Initialize the terminal
local function setup_terminal()
  M.cmd_term = Terminal:new {
    cmd = M.config.initial_command,
    hidden = true,
    direction = M.config.window.direction,
    display_name = M.config.window.name,
    close_on_exit = false,
  }
end

-- Command history
M.command_history = {}

-- Internal function to run a command
local function _run_cmd(cmd)
  if M.cmd_term:is_open() then
    M.cmd_term:shutdown()
  end
  M.cmd_term.cmd = cmd
  M.cmd_term:open()
end

-- API 1: Run a command
M.run_command = function(cmd)
  table.insert(M.command_history, cmd)
  _run_cmd(cmd)
end

-- API 2: Run the last command
M.run_last_command = function ()
  if #M.command_history > 0 then
    _run_cmd(M.command_history[#M.command_history])
  else
    print("No command history available")
  end
end

-- API 3: Run a command from history using Telescope
M.run_command_from_history = function()
  pickers.new({}, {
    prompt_title = "Command History",
    finder = finders.new_table {
      results = M.command_history,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        _run_cmd(selection[1])
      end)
      return true
    end,
  }):find()
end

-- Setup function
function M.setup(user_config)
  M.config = vim.tbl_deep_extend("force", M.config, user_config or {})
  setup_terminal()

  -- Register user commands
  vim.api.nvim_create_user_command("RunCommand", function(opts)
    M.run_command(opts.args)
  end, { nargs = '+' })

  vim.api.nvim_create_user_command("RunLastCommand", function()
    M.run_last_command()
  end, {})

  vim.api.nvim_create_user_command("RunCommandFromHistory", function()
    M.run_command_from_history()
  end, {})
end

return M

