
wanted_languages = { "ruby", "vim", "yaml", "python", "lua", "json", "javascript", "git_config", "gitcommit", "dockerfile", "markdown", "markdown_inline" , "gotmpl", "comment", "terraform", "embedded_template", "elixir" }

-- Install wanted languages
require('nvim-treesitter').install(wanted_languages)

-- start treesitter for given files
vim.api.nvim_create_autocmd("FileType", {
	pattern = wanted_languages,
	callback = function()
		vim.treesitter.start()
	end
})

vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
-- require('nvim-treesitter.configs').setup {
--   -- one of "all", "maintained" (parsers with maintainers),
--   -- or a list of languages
--   ensure_installed = { "ruby", "vim", "yaml", "python", "lua", "json", "javascript", "git_config", "gitcommit", "dockerfile", "markdown", "markdown_inline" , "gotmpl", "comment", "terraform", "embedded_template", "elixir" },
--   highlight = {
--     enable = true,
-- 
--     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--     -- Using this option may slow down your editor, and you may see some duplicate highlights.
--     -- Instead of true it can also be a list of languages
--     additional_vim_regex_highlighting = false,
--   },
--   playground = {
--     enable = true,
--     disable = {},
--     updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
--     persist_queries = false, -- Whether the query persists across vim sessions
--     keybindings = {
--       toggle_query_editor = 'o',
--       toggle_hl_groups = 'i',
--       toggle_injected_languages = 't',
--       toggle_anonymous_nodes = 'a',
--       toggle_language_display = 'I',
--       focus_language = 'f',
--       unfocus_language = 'F',
--       update = 'R',
--       goto_node = '<cr>',
--       show_help = '?',
--     },
--   },
--   matchup = {
--     enable = true,              -- mandatory, false will disable the whole extension
--     -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
--     -- [options]
--   },
-- }
