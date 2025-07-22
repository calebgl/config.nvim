return {
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = "make install_jsregexp",
			opts = {},
		},
		"folke/lazydev.nvim",
	},
	config = function()
		require("blink-cmp").setup({
			keymap = { preset = "default" },
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = {
					auto_show = false,
					auto_show_delay_ms = 500,
				},
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true },
		})
	end,
}
