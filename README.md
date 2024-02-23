# Radix.nvim

Radix, from [Latin](https://en.wikipedia.org/wiki/Latin) [*rādīx*](https://en.wiktionary.org/wiki/radix) ("a root"), is a project root directory finder for [Neovim](https://github.com/neovim/neovim). It automatically attempts to find the root directory of a project when starting Neovim.

## Requirements

- Neovim >= 0.8.0

## Installation

Using [Lazy](https://github.com/folke/lazy.nvim):

```lua
{
    "michel-garcia/radix.nvim",
    opts = {}
}
```

## Options

Below is a list of the available options along with their defaults:

```lua
{
    -- if false cwd will be left unchanged if no directory is found
    -- otherwise it uses the head of the starting path
    fallback = true,

    -- callback for when a directory was successfully found
    -- path contains the directory
    on_success = function (path) end,

    -- glob patterns to query
    patterns = {
        ".git",
        "Makefile",
        "package.json"
    },

    -- if false a notification will be shown when changing the cwd
    silent = true
}
```

Check [glob](https://en.wikipedia.org/wiki/Glob_%28programming%29) to learn more about glob patterns and its wildcards.

## API

You can get the root directory by:

```lua
-- path can point to any directory or file
require("radix").get_root_dir(path)
```

