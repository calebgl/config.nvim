vim.keymap.set("n", "<Leader>pd", vim.cmd.Ex)

vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>")

vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist)

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("x", "<Leader>p", '"_dP')

vim.keymap.set({ "n", "v" }, "<Leader>y", [["+y]])
vim.keymap.set("n", "<Leader>Y", '"+Y')

vim.keymap.set({ "n", "v" }, "<Leader>d", '"_d')

vim.keymap.set("n", "<Leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<Leader>r", [[:s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

vim.keymap.set("n", "<Leader>x", function()
	vim.cmd("lua " .. vim.fn.getline("."))
end)

vim.keymap.set("v", "<Leader>x", "<Cmd>.lua<CR>")
vim.keymap.set("n", "<Leader><Leader>x", "<Cmd>source %<CR>")

vim.keymap.set("n", ",st", function()
	vim.cmd.new()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 10)
	vim.wo.winfixheight = true
	vim.cmd.term()
end)

vim.keymap.set("n", ",tt", function()
	vim.cmd.tabnew()
	vim.cmd.term()
end)
