local ec = dofile("lua/run_command/extract_commands.lua")
local file = nil
local content = ""
local lines = {}
local commands = {}

file = io.open("test/README.md", "r")

if not file then
  io.stderr:write("Error: Could not open file " .. filename .. "\n")
  os.exit(1)
end

content = file:read("*a")

file:close()

for line in content:gmatch("[^\n]*") do
  table.insert(lines, line)
end

commands = ec.extract_commands(lines, true)

for _, c in ipairs(commands) do
  print(string.format("- description: %q", c.description))
  print(string.format("  command: %q", c.command))
  print("  block:")
  for _, line in ipairs(c.block) do
    print(string.format("  - %q", line))
  end
end
