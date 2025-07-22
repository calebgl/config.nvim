local function augroup(name)
	return vim.api.nvim_create_augroup("calebgl_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("HighlightYank"),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			"IncSerach",
			timeout = 100,
		})
	end,
})
