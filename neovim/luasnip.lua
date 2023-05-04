local runtime_paths = vim.api.nvim_get_runtime_file("snippets", true)
runtime_paths[2] = vim.fn.expand('$HOME/config/vimsnippets')
require("luasnip.loaders.from_snipmate").lazy_load({ paths = runtime_paths })
