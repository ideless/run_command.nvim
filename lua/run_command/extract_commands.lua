local M = {}

-- Function to process a bash code block
local function process_bash_block(block)
  local commands = {}
  local current_command = ""

  for _, line in ipairs(block) do
    -- Remove leading/trailing whitespace
    line = line:gsub("^%s*(.-)%s*$", "%1")

    -- Skip empty lines and comments
    if line ~= "" and not line:match("^#") then
      -- If line ends with \, append to current command (without the \)
      if line:match("%s*\\%s*$") then
        current_command = current_command .. line:gsub("%s*\\%s*$", " ")
      else
        -- Otherwise, complete the command
        current_command = current_command .. line
        table.insert(commands, current_command)
        current_command = ""
      end
    end
  end

  -- Join commands with &&
  return table.concat(commands, " && ")
end

-- Main processing function
function M.extract_commands(filename)
  local file = io.open(filename, "r")
  if not file then
    io.stderr:write("Error: Could not open file " .. filename .. "\n")
    os.exit(1)
  end

  local content = file:read("*a")
  file:close()

  local prev_line = ""
  local in_bash_block = false
  local current_block = {}
  local commands = {}

  for line in content:gmatch("[^\r\n]+") do
    -- Check for code block start
    if line == "```sh" or line == "```bash" then
      in_bash_block = true
      current_block = {}
      -- Check for code block end
    elseif in_bash_block and line:match("^```") then
      in_bash_block = false
      local command = process_bash_block(current_block)
      if command ~= "" then
        -- Print description if available
        local description = prev_line:gsub("^%s*(.-)%s*$", "%1")
        table.insert(commands, {
          description = description,
          command = command,
          block = current_block,
        })
      end
      -- Collect lines in bash block
    elseif in_bash_block then
      table.insert(current_block, line)
      -- Store previous line (for description)
    elseif line:match("^```") then
      prev_line = ""
    else
      prev_line = line
    end
  end

  return commands
end

return M
