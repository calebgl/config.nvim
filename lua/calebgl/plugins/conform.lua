return {
	"stevearc/conform.nvim",
	event = { "VimEnter" },
	cmd = { "ConformInfo" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "golines", "gofumpt", "goimports" },
			},
		})

		vim.keymap.set({ "n", "v" }, "<Leader>f", function()
			require("conform").format({ async = true, lsp_format = "fallback" }, function(err)
				if not err then
					local mode = vim.api.nvim_get_mode().mode
					if vim.startswith(string.lower(mode), "v") then
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
					end
				end
			end)
		end)
	end,
}
