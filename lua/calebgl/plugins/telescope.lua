return {
	"nvim-telescope/telescope.nvim",
	event = { "VimEnter" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	config = function()
		require("telescope").setup({
			extensions = { fzf = {} },
			pickers = {
				buffers = {
					mappings = {
						i = {}, -- ["<C-s>"] = "delete_buffer"
						n = { d = "delete_buffer" },
					},
				},
			},
			defaults = require("telescope.themes").get_ivy({
				border = false,
			}),
		})

		pcall(require("telescope").load_extension, "fzf")

		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<Leader>ss", builtin.lsp_document_symbols)
		vim.keymap.set("n", "<Leader>sf", builtin.find_files)
		vim.keymap.set("n", "<Leader>sg", builtin.live_grep)
		vim.keymap.set("n", "<Leader>sb", builtin.buffers)
		vim.keymap.set("n", "<Leader>sr", builtin.resume)
		vim.keymap.set("n", "<Leader>sq", builtin.quickfix)
		vim.keymap.set("n", "<Leader>st", "<Cmd>TodoTelescope<CR>")

		vim.keymap.set("n", "<Leader>s/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_ivy({ previewe = false }))
		end)

		vim.keymap.set("n", "<Leader>sw", function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word })
		end)

		vim.keymap.set("n", "<Leader>sw", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end)
	end,
}
