-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable providers we don't need
vim.g.loaded_python3_provider = 0  -- Disable Python3 provider
vim.g.loaded_ruby_provider = 0     -- Disable Ruby provider

-- Load plugins
require('config.lazy')

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Enable LSP features
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes" 