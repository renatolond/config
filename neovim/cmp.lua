-- setup autopairs
require('nvim-autopairs').setup()
cmp_autopairs = require("nvim-autopairs.completion.cmp")

-- Set up nvim-cmp.
local cmp = require'cmp'

-- Requires "nerd" fonts: https://www.nerdfonts.com/font-downloads
local kind_icons = {
  Class = "ﴯ",
  Color = "",
  Constant = "",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Keyword = "",
  Method = "",
  Module = "",
  Operator = "",
  Property = "ﰠ",
  Reference = "",
  Snippet = "",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "",
}

cmp.setup({
snippet = {
  expand = function(args)
	vim.fn["UltiSnips#Anon"](args.body)
  end,
},
formatting = {
  format = function(entry, vim_item)
    -- Kind icons
    vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) --Concatonate the icons with name of the item-kind
    vim_item.menu = ({
      nvim_lsp = "[LSP]",
      spell = "[Spellings]",
      zsh = "[Zsh]",
      buffer = "[Buffer]",
      ultisnips = "[Snip]",
      treesitter = "[Treesitter]",
      calc = "[Calculator]",
      nvim_lua = "[Lua]",
      path = "[Path]",
      nvim_lsp_signature_help = "[Signature]",
      cmdline = "[Vim Command]"
    })[entry.source.name]
    return vim_item
  end
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'ultisnips' },
}, {
  { name = 'buffer' },
  { name = 'path' }
})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
}, {
  { name = 'buffer' },
})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
-- mapping = cmp.mapping.preset.cmdline(),
-- sources = {
--   { name = 'buffer' }
-- }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
-- mapping = cmp.mapping.preset.cmdline(),
-- sources = cmp.config.sources({
--   { name = 'path' }
-- }, {
--   { name = 'cmdline' }
-- })
-- })

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { "solargraph", "grammarly", "rubocop", "crystalline" }
for _, lsp in ipairs(servers) do
require('lspconfig')[lsp].setup {
  capabilities = capabilities
}
end

cmp.event:on(
'confirm_done',
cmp_autopairs.on_confirm_done()
)
