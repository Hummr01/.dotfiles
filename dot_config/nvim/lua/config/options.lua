-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Visuals & scrolling
opt.scrolloff = 10
opt.breakindent = true
opt.inccommand = "split"

-- 4-space indentation (migrated from lua/user/options.lua)
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

-- Whitespace visuals
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Automatically reload files modified externally (e.g. by OpenCode / Sidekick)
opt.autoread = true
