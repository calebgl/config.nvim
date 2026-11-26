vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.scrolloff = 4

vim.opt.guicursor = ""
vim.opt.completeopt = { "fuzzy", "menu", "menuone", "noselect" }
vim.opt.mouse = "a"

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.signcolumn = "no"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.undo"
vim.opt.undofile = true

vim.g.netrw_banner = 0

vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>")

vim.keymap.set("x", ">", ">gv")
vim.keymap.set("x", "<", "<gv")

vim.keymap.set({ "n", "x" }, "<Leader>y", '"+y')

vim.keymap.set("n", "-", '<Cmd>Explore<CR> <Bar> <Cmd>sil! call search(expand("#:t"))<CR>')
vim.keymap.set("n", "<Leader>co", "<Cmd>edit $MYVIMRC<CR>")
vim.keymap.set("n", "<Leader>xf", "<Cmd>source %<CR>")

vim.keymap.set("x", "<Leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIy<Left><Left><Left>]])

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<C-6>", "<C-^>")

if vim.fn.has("win32") ~= 0 then
	vim.opt.shell = "pwsh -NoExit"
	vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -NoExit -Command "
		.. "[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();"
		.. "$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
		.. "$PSStyle.OutputRendering = 'PlainText';"
	vim.opt.shellpipe = "> %s 2>&1"
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
end

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank({ timeout = 125 })
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function(ev)
		vim.opt_local.number = true
		vim.opt_local.relativenumber = true

		local opts = { buffer = ev.buf, remap = false }
		vim.keymap.set("n", "i", "<Nop>", opts)
		vim.keymap.set("n", "s", "<Nop>", opts)
		vim.keymap.set("n", "r", "<Nop>", opts)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
		local opts = { buffer = 0 }

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

		vim.keymap.set("n", "<Leader>lr", "<Cmd>lsp restart roslyn<CR>", opts)
		vim.keymap.set("n", "<Leader>ln", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts)

		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
	end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
	{
		"tpope/vim-fugitive",
	},

	{
		"vague-theme/vague.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("vague").setup()
			-- vim.cmd.colorscheme("vague")
		end,
	},

	{
		dir = "~/personal/naysayer-colors.nvim",
		lazy = false,
		config = function()
			vim.cmd.colorscheme("naysayer")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
	},

	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
				},
			})
		end,
	},

	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	},

	{
		"stevearc/conform.nvim",
		event = "BufReadPost",
		command = "ConformInfo",
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					xml = { "xmllint" },
				},
				default_format_opts = {
					async = true,
					lsp_format = "fallback",
				},
			})

			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

			vim.keymap.set({ "n", "v" }, "<Leader>f", conform.format)
		end,
	},

	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			require("blink.cmp").setup({
				keymap = { preset = "default" },
				completion = {
					menu = {
						draw = {
							columns = {
								{ "label", "label_description", gap = 1 },
								{ "kind" },
							},
						},
					},
				},
				sources = {
					default = {
						"lazydev",
						"lsp",
						"path",
						"snippets",
						"buffer",
					},
					providers = {
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							score_offset = 100,
						},
					},
				},
				fuzzy = { implementation = "prefer_rust_with_warning" },
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"mason-org/mason.nvim",
			"saghen/blink.cmp",
			"j-hui/fidget.nvim",
		},
		config = function()
			--- @type table<string,vim.lsp.Config>
			local servers = {
				clangd = {},

				-- ols = {},

				-- pyrefly = {},

				lua_ls = {
					settings = {
						Lua = {
							telemetry = { enable = false },
							completion = { callSnippet = "replace" },
							diagnostics = {
								disable = { "missing-fields" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
							},
						},
					},
				},

				-- roslyn_ls = {
				-- 	settings = {
				-- 		["csharp|formatting"] = {
				-- 			dotnet_organize_imports_on_format = true,
				-- 		},
				-- 	},
				-- },
			}

			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			for server, config in pairs(servers) do
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end

			vim.diagnostic.config({
				severity_host = true,
				float = { header = "" },
			})
		end,
	},

	{
		"ibhagwan/fzf-lua",
		config = function()
			local fzf = require("fzf-lua")
			local blankborder = { " ", " ", " ", " ", " ", " ", " ", " " }

			fzf.setup({
				defaults = {
					git_icons = false,
					file_icons = false,
					color_icons = false,
				},
				winopts = {
					row = 1,
					col = 0,
					width = 1,
					height = 0.4,
					border = blankborder,
					preview = {
						hidden = true,
						layout = "horizontal",
						border = blankborder,
					},
				},
				fzf_colors = {
					true,
					["gutter"] = { "bg", "Normal" },
				},
				grep = {
					winopts = {
						preview = {
							hidden = false,
						},
					},
				},
			})

			vim.keymap.set("n", "<Leader>pf", fzf.files)
			vim.keymap.set("n", "<Leader>pg", fzf.live_grep)
			vim.keymap.set("n", "<Leader>pr", fzf.resume)

			vim.keymap.set("n", "<Leader>sp", ":FzfLua ")
			vim.keymap.set("n", "<Leader>sb", fzf.buffers)
			vim.keymap.set("n", "<Leader>sk", fzf.keymaps)

			local configpath = vim.fn.stdpath("config")

			vim.keymap.set("n", "<Leader>cf", function()
				fzf.files({ cwd = configpath })
			end)
			vim.keymap.set("n", "<Leader>cg", function()
				fzf.live_grep({ cwd = configpath })
			end)

			vim.api.nvim_set_hl(0, "FzfLuaTitle", { link = "Normal" })
			vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "Normal" })
			vim.api.nvim_set_hl(0, "FzfLuaFzfGutter", { bg = "None" })
		end,
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")

			harpoon.setup({})

			vim.keymap.set("n", "<Leader>ha", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<Leader>hc", function()
				harpoon:list():clear()
			end)
			vim.keymap.set("n", "<Leader>hs", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<Leader>1", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<Leader>2", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<Leader>3", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<Leader>4", function()
				harpoon:list():select(4)
			end)
		end,
	},

	{
		"nvim-mini/mini.align",
		version = "*",
		opts = {},
	},
})
