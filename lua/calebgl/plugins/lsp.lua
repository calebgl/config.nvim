return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"nvim-telescope/telescope.nvim",

		{ "j-hui/fidget.nvim", opts = {} },
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},

		"saghen/blink.cmp",
	},
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local servers = {
			gopls = {},
			clangd = {},
			lua_ls = {
				settings = {
					Lua = {
						telemetry = { enable = false },
						completion = { callSnippet = "replace" },
						diagnostics = {
							disable = { "missing-fields" },
						},
					},
				},
			},

			kotlin_language_server = {},
			pylsp = {},
		}

		local servers_to_install = vim.tbl_keys(servers)
		local ensure_installed = {
			"stylua",
		}

		vim.list_extend(ensure_installed, servers_to_install)

		require("mason").setup()
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		for server_name, config in pairs(servers) do
			config = vim.tbl_extend("force", {}, { capabilities = capabilities }, config)
			require("lspconfig")[server_name].setup(config)
		end

		vim.diagnostic.config({
			severity_host = true,
			float = { source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			virtual_text = {
				source = "if_many",
				spacing = 2,
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function()
				local builtin = require("telescope.builtin")
				local opts = { buffer = 0 }

				vim.keymap.set("n", "gd", builtin.lsp_definitions, opts)
				vim.keymap.set("n", "gr", builtin.lsp_references, opts)
				vim.keymap.set("n", "gI", builtin.lsp_implementations, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				vim.keymap.set("n", "<Leader>cr", vim.lsp.buf.rename, opts)
				vim.keymap.set({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, opts)

				vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, opts)
			end,
		})
	end,
}
