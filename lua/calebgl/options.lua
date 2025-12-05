vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = false

vim.o.smartcase = true
vim.o.ignorecase = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"

vim.o.breakindent = true
vim.o.signcolumn = "yes"

vim.o.updatetime = 250

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.inccommand = "split"

vim.o.cursorline = true

vim.o.scrolloff = 8

vim.o.confirm = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.swapfile = false

vim.o.backup = false
vim.o.undofile = true

vim.o.more = false

vim.o.termguicolors = true

vim.o.winborder = "single"

-- Don't continue comments when pressing o/O
vim.opt.formatoptions:remove("o")

