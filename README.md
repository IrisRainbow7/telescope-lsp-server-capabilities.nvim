# telescope-lsp-server-capabilities.nvim
Telescope.nvim extensions for LSP server capabilities

## Screenshots

| lua_ls & none_ls | volar & eslint |
| -- | -- |
|<img width="1440" alt="スクリーンショット 2023-11-27 23 32 22" src="https://github.com/IrisRainbow7/telescope-lsp-server-capabilities.nvim/assets/34544233/567f7b48-f789-4400-a5a5-eb6892262e69">|<img width="1440" alt="スクリーンショット 2023-11-27 23 40 12" src="https://github.com/IrisRainbow7/telescope-lsp-server-capabilities.nvim/assets/34544233/fed90c87-5c81-4f22-b273-8849bd9b25bd">|

## Install

example for `lazy.nvim`
```
require("lazy").setup({
  { "nvim-telescope/telescope.nvim",
    dependencies = { "IrisRainbow7/telescope-lsp-server-capabilities.nvim" },
    config = function()
      require('telescope').setup{
        -- ... your options
      }
      require("telescope").load_extension("lsp_server_capabilities")
    end
  },
})
```
