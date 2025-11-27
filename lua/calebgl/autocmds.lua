local function augroup(name)
	return vim.api.nvim_create_augroup("calebgl_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("HighlightYank"),
	callback = function()
		vim.highlight.on_yank({
			"IncSerach",
			timeout = 100,
		})
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup("TermOpen"),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.scrolloff = 0

		vim.bo.filetype = "terminal"
	end,
})
