-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.laststatus = 3
opt.showmode = false
opt.cmdheight = 0
opt.pumblend = 10
opt.winblend = 10
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true
opt.splitbelow = true
opt.splitright = true
opt.fillchars = {
  eob = " ",
}
opt.shortmess:append("c")
