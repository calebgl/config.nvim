vim.keymap.set("n", "<Leader>pd", vim.cmd.Ex)

vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>')

vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist)

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("x", "<Leader>p", '"_dP')

vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y')
vim.keymap.set("n", "<Leader>Y", '"+Y')

vim.keymap.set({ "n", "v" }, "<Leader>d", '"_d')
