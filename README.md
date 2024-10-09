# run_command.nvim

A Neovim plugin for executing and managing terminal commands. With `run_command.nvim`, you can run commands directly from Neovim, keep a history of commands, and easily re-execute previous commands using a simple interface.

## Features

- Run any command directly in a terminal buffer.
- Keep a history of previously executed commands and their results.
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

- `:RcRun <command>`: Runs the specified `<command>`.
- `:RcRunLast`: Re-runs the last executed command.
- `:RcRunFromHistory`: Opens a Telescope picker with the command history, allowing you to select and re-run a command. The previous command results are shown in the preview window.
- `:RcClearHistory`: Clear the command history and command results.

## Configuration

You can customize the default settings by passing a configuration table when calling `setup`:

```lua
require('run_command').setup({
  window = {
    direction = "horizontal", -- Options: "vertical", "vertical", "tab"
    name = "cmd_term"
  }
})
```

## API Functions

The following functions are available within the plugin:

- `run_command(cmd)`: Runs the specified command and adds it to history.
- `run_last_command()`: Executes the most recently run command from history.
- `run_command_from_history()`: Opens a Telescope picker to choose a command from history.
- `clear_command_history()`: Clears the command history and command results.

## Key Mappings

Consider adding key mappings in your Neovim configuration for quick access:

```lua
vim.api.nvim_set_keymap('n', '<leader>rr', ':RcRun ')
vim.api.nvim_set_keymap('n', '<leader>rl', ':RcRunLast<CR>')
vim.api.nvim_set_keymap('n', '<leader>rh', ':RcRunFromHistory<CR>')
vim.api.nvim_set_keymap('n', '<leader>rc', ':RcClearHistory<CR>')
```
