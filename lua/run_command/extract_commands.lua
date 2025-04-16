local M = {}

-- Function to process a bash code block
local function process_bash_block(lines, exit_on_error)
  local commands = {}
  local current_command = ""
  local joined_by = exit_on_error and " && " or "; "

  for _, line in ipairs(lines) do
    -- Remove leading/trailing whitespace
    line = line:gsub("^%s*(.-)%s*$", "%1")
    -- Skip empty lines and comments
    if line ~= "" and not line:match("^#") then
      -- If line ends with \, append to current command (without the \)
      if line:match("\\%s*$") then
        current_command = current_command .. line:gsub("%s*\\%s*$", " ")
      else
        -- Otherwise, complete the command
        current_command = current_command .. line
        table.insert(commands, current_command)
        current_command = ""
      end
    end
  end

  -- Join commands with && or ;
  return table.concat(commands, joined_by)
end

-- Main processing function
function M.extract_commands(lines, exit_on_error)
  local prev_line = ""
  local in_bash_block = false
  local current_block = {}
  local commands = {}

  for _, line in ipairs(lines) do
    -- Remove trailing CR/LF
    line = line:gsub("[\r\n]*$", "")
    -- Check for code block start
    if line == "```sh" or line == "```bash" then
      in_bash_block = true
      current_block = {}
      -- Check for code block end
    elseif in_bash_block and line == "```" then
      in_bash_block = false
      local command = process_bash_block(current_block, exit_on_error)
      if command ~= "" then
        table.insert(commands, {
          description = prev_line:gsub("^%s*(.-)%s*$", "%1"),
          command = command,
          block = current_block,
        })
      end
      prev_line = ""
      -- Collect lines in bash block
    elseif in_bash_block then
      table.insert(current_block, line)
      -- Store previous line (for description)
    elseif line == "```" then
      prev_line = ""
    elseif line ~= "" then
      prev_line = line
    end
  end

  return commands
end

return M
