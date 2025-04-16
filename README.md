# run_command.nvim

A Neovim plugin that provides an interactive interface to run shell commands in your README.md file.

## Features

- Extract shell commands from README.md files with descriptions
- Interactive command selection using Telescope
- Preview command blocks before execution
- Run commands in a toggleable terminal
- Remember and re-run last executed command

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
require("lazy").setup({
  {
    "ideless/run_command.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      window = {
        direction = "horizontal", -- or "vertical" | "float"
        name = "cmd_term",        -- terminal display name
      },
      shell = {
        exit_on_error = true,     -- join commands by && or ;
      },
    },
  },
})
```

## Usage

- `:RcRun` - Open the command picker to select and run a command
- `:RcRunLast` - Re-run the last executed command

## Command extraction rule

The script will extract code blocks marked as `sh` or `bash` from the project's root `README.md` file.
For each code block found, the preceding line (if it exists) will be used as its description.

## Development

Test `extract_commands.lua`:

```sh
lua test/test_extract_commands.lua | diff - test/README.md.yaml
```
