local Terminal = require("toggleterm.terminal").Terminal
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local extract_commands = require("run_command.extract_commands")

local M = {}

-- Default configuration
M.config = {
  window = {
    direction = "horizontal",
    name = "cmd_term",
  },
}

M.commands = {}
M.last_command = nil
M.last_modified_time = -1

-- Initialize the terminal
local function setup_terminal()
  M.cmd_term = Terminal:new({
    cmd = "",
    hidden = true,
    direction = M.config.window.direction,
    display_name = M.config.window.name,
    close_on_exit = false,
  })
end

-- Internal function to run a command
local function _run_cmd(cmd)
  M.last_command = cmd
  M.cmd_term:shutdown()
  M.cmd_term.cmd = cmd
  M.cmd_term:open()
  M.cmd_term:set_mode("i")
end

-- Internal function to read the README.md
local function read_README()
  local lmt = vim.fn.getftime("README.md")

  if lmt == -1 then
    M.commands = {}
    M.last_command = nil
    M.last_modified_time = -1
    return
  elseif lmt ~= M.last_modified_time then
    local lines = vim.fn.readfile("README.md")
    M.commands = extract_commands.extract_commands(lines)
    M.last_modified_time = lmt
  end
end

-- API 1: Run a command
M.run_command = function(cmd)
  read_README()

  pickers
    .new({}, {
      prompt_title = "Commands",
      finder = finders.new_table({
        results = M.commands,
        entry_maker = function(entry)
          local display = entry.description ~= "" and entry.description or entry.command
          return {
            value = entry,
            display = display,
            ordinal = display,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      previewer = previewers.new_buffer_previewer({
        title = "Command",
        define_preview = function(self, entry, status)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, entry.value.block)
        end,
      }),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local entry = action_state.get_selected_entry()
          _run_cmd(entry.value.command)
        end)
        return true
      end,
    })
    :find()
end

-- API 2: Run the last command
M.run_last_command = function()
  if M.last_command then
    _run_cmd(M.last_command)
  else
    vim.notify("No last command", vim.log.levels.WARN)
  end
end

-- Setup function
function M.setup(user_config)
  M.config = vim.tbl_deep_extend("force", M.config, user_config or {})

  setup_terminal()

  -- Register user commands
  vim.api.nvim_create_user_command("RcRun", function()
    M.run_command()
  end, {})

  vim.api.nvim_create_user_command("RcRunLast", function()
    M.run_last_command()
  end, {})
end

return M
