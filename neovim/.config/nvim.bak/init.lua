local cmd = vim.cmd
local g = vim.g
local opt = vim.opt

g.mapleader = " "

-- default options
opt.completeopt = {'menu', 'menuone', 'noselect'}
opt.laststatus = 3
opt.mouse = 'a'
opt.splitright = true
opt.splitbelow = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
--opt.number = true "Not sure what it does since line number 27 is also there
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
-- opt.relativenumber = true
vim.cmd('set number')
vim.cmd('set relativenumber')
-- set diffopt+=vertical " starts diff mode in vertical split
opt.cmdheight = 1
-- set shortmess+=c " don't need to press enter so often
-- Do not show current vim mode since it is already shown by Lualine
opt.showmode = false
opt.signcolumn = 'yes'
opt.updatetime = 520
opt.showmatch = true
opt.showmode = true
opt.autoindent = true
opt.ruler = true
opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('config') .. '/undo-dir'
opt.clipboard = 'unnamedplus'
cmd('filetype plugin on')
opt.backup = false
g.netrw_banner = false
g.netrw_liststyle = 3
g.markdown_fenced_languages = { 'javascript', 'js=javascript', 'json=javascript' }

-- opt.path:append({ "**" })
vim.cmd([[set path=$PWD/**]])
vim.keymap.set('n', '<leader>v', ':e $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>w', ':w<CR>', { silent = true })
vim.keymap.set('n', '<leader>s', ':so $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>t', ':bnext<CR>')
vim.keymap.set('n', '<leader>T', ':bprev<CR>')
vim.keymap.set('n', '<leader>x', ':bd<CR>')

-- global mark I for last edit
vim.cmd [[autocmd InsertLeave * execute 'normal! mI']]

-- highlight on yank
vim.cmd([[au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}]])
-- better colors, but makes it sery slow!
-- opt.termguicolors = true
