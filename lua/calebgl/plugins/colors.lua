return {
	{
		"rose-pine/neovim",
		config = function()
			require("rose-pine").setup({
				styles = {
					bold = true,
					italic = false,
					transparency = true,
				},
				highlight_groups = {
					Visual = { bg = "rose", blend = 30 },
					LspSignatureActiveParameter = { bg = "rose", blend = 30 },
				},
			})

			vim.cmd.colorscheme("rose-pine")
		end,
	},
}
