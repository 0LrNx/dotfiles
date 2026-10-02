-- Neovim minimal, sans plugin (fonctionne partout dès nvim 0.9).
-- Pour ajouter des plugins plus tard : https://lazy.nvim

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local o = vim.opt
o.number = true
o.relativenumber = true
o.mouse = "a"
o.ignorecase = true
o.smartcase = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true
o.termguicolors = true
o.signcolumn = "yes"
o.cursorline = true
o.scrolloff = 8
o.splitright = true
o.splitbelow = true
o.undofile = true
o.updatetime = 250
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- Presse-papiers système (sous WSL, nécessite win32yank ; sinon retirer cette ligne)
o.clipboard = "unnamedplus"

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>w", "<cmd>write<CR>")
map("n", "<leader>e", "<cmd>Explore<CR>")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})
