# run_command.nvim

A Neovim plugin for executing and managing terminal commands. With `run_command.nvim`, you can run commands directly from Neovim, keep a history of commands, and easily re-execute previous commands using a simple interface.

## Features

- Run any command directly in a terminal buffer.
- Keep a history of previously executed commands.
- Use Telescope to select and run commands from your command history.
- Configurable terminal settings.

## Installation

To install `run_command.nvim`, you can use [lazy.nvim](https://github.com/folke/lazy.nvim). Add the following line to your Neovim configuration:

```lua
require("lazy").setup({
  {
    "ideless/run_command.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {},
  },
})
```

## Usage

After installation, you can execute commands using the following user-defined commands:

- `:RunCommand <command>`: Runs the specified `<command>`.
- `:RunLastCommand`: Re-runs the last executed command.
- `:RunCommandFromHistory`: Opens a Telescope picker with the command history, allowing you to select and re-run a command.

## Configuration

You can customize the default settings by passing a configuration table when calling `setup`:

```lua
require('run_command').setup({
  initial_command = "echo 'Welcome to run_command.nvim'",
  window = {
    direction = "vertical", -- Options: "horizontal", "vertical", "tab"
    name = "CustomTerminalName"
  }
})
```

## API Functions

The following functions are available within the plugin:

- `run_command(cmd)`: Runs the specified command and adds it to history.
- `run_last_command()`: Executes the most recently run command from history.
- `run_command_from_history()`: Opens a Telescope picker to choose a command from history.

## Key Mappings

Consider adding key mappings in your Neovim configuration for quick access:

```lua
vim.api.nvim_set_keymap('n', '<leader>rc', ':RunCommand ', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>rl', ':RunLastCommand<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>rh', ':RunCommandFromHistory<CR>', { noremap = true })
```
