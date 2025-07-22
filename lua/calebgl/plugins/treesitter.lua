return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local disabled_languages = { "ruby", "python", "html" }

			require("nvim-treesitter.configs").setup({
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = disabled_languages, -- avoid weird indent issues
				},
				indent = { enable = true, disable = disabled_languages },
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			vim.cmd.highlight("TreesitterContext gui=none")
			vim.cmd.highlight("TreesitterContextSeparator gui=none")
			vim.cmd.highlight("TreesitterContextBottom gui=none")

			require("treesitter-context").setup({
				max_lines = 4,
				separator = "-",
			})
		end,
	},
}
