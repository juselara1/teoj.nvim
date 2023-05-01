# teoj.nvim

teoj.nvim is a simple plugin written in Lua that allows you to define flexible and custom text objects in Neovim. With `teoj`, you can define what is **i**nside and **a**round two patterns.

## Installation

You can install this plugin using [packer](https://github.com/wbthomason/packer.nvim):

```lua
use "juselara1/teoj.nvim"
```

## Usage

To define custom text objects using teoj, you need to use Lua. Here's an example:

```lua
local teoj = require("teoj")
local options = {noremap = true, silent=true}
binds = {
    {mode = {'v', 'o'}, bind="ix", command=function () teoj.object("<<", ">>", false, false) end},
    {mode = {'v', 'o'}, bind="ax", command=function () teoj.object("<<", ">>", true, true) end},
}

for _, bind in ipairs(binds) do
    vim.keymap.set(bind.mode, bind.bind, bind.command, options)
end
```

In this example, we create a new text object `x` that defines the pattern `<<text>>` and can be used in visual and operator-pending mode. Therefore, you can use the following commands:

- `vix`: select inside.
- `vax`: select around.
- `dix`: delete inside.
- `dax`: delete around.
- `yix`: yank inside.
- `yax`: yank around.
- `cix`: change inside.
- `cax`: change around.

Here's an example of `vix` and `vax` in action:

![example1](docs/example1.gif)

You can also define text objects that do not necessarily include left or right patterns. For instance:

```lua
local teoj = require("teoj")
local options = {noremap = true, silent=true}
binds = {
    {mode = {'v', 'o'}, bind="ic", command=function () teoj.object("^# %%%%", "# %%%%", false, false) end},
    {mode = {'v', 'o'}, bind="ac", command=function () teoj.object("^# %%%%", "# %%%%", true, false) end},
}

for _, bind in ipairs(binds) do
    vim.keymap.set(bind.mode, bind.bind, bind.command, options)
end
```

Here, we create a new text object `c` that selects texts between `# %%` and `# %%` (patterns are defined according to [Lua's specification](https://www.lua.org/pil/20.2.html)). However, inside excludes both patterns (the 3rd and 4th parameters are `false`) and around includes only the left pattern (the 3rd argument is `true` and the 4th is `false`). Here's an example:

![example2](docs/example2.gif)

## Examples

There are some examples of text objects:

```lua
binds = {
    {mode = {'v', 'o'}, bind="ice", command=function () teoj.object("^# %%%%.*$", "^# %%%%.*$", false, false) end}, -- jupytext cell
    {mode = {'v', 'o'}, bind="ace", command=function () teoj.object("^# %%%%.*$", "^# %%%%.*$", true, false) end}, -- jupytext cell
    {mode = {'v', 'o'}, bind="imh1", command=function () teoj.object("^# .+$", "^# .+$", false, false) end}, -- markdown h1
    {mode = {'v', 'o'}, bind="amh1", command=function () teoj.object("^# .+$", "^# .+$", true, false) end}, -- markdown h1
    {mode = {'v', 'o'}, bind="imh2", command=function () teoj.object("^## .+$", "^##? .+$", false, false) end}, -- markdown h2
    {mode = {'v', 'o'}, bind="amh2", command=function () teoj.object("^## .+$", "^##? .+$", true, false) end}, -- markdown h2
    {mode = {'v', 'o'}, bind="imh3", command=function () teoj.object("^### .+$", "^##?#? .+$", false, false) end}, -- markdown h3
    {mode = {'v', 'o'}, bind="amh3", command=function () teoj.object("^### .+$", "^##?#? .+$", true, false) end}, -- markdown h3
    {mode = {'v', 'o'}, bind="i,", command=function () teoj.object("%,", "%,", false, false) end}, -- comma
    {mode = {'v', 'o'}, bind="a,", command=function () teoj.object("%,", "%,", true, true) end}, -- comma
    {mode = {'v', 'o'}, bind="i.", command=function () teoj.object("%.", "%.", false, false) end}, -- dot
    {mode = {'v', 'o'}, bind="a.", command=function () teoj.object("%.", "%.", true, true) end}, -- dot
    {mode = {'v', 'o'}, bind="i;", command=function () teoj.object("%;", "%;", false, false) end}, -- dot
    {mode = {'v', 'o'}, bind="a;", command=function () teoj.object("%;", "%;", true, true) end}, -- dot
}
```
