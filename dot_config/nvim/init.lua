-- ~/.config/nvim/init.lua

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Load your other modules
require("user.options")
require("user.keymaps")
-- NOTE: require("user.plugins") is GONE from here!

-- Let lazy.nvim handle the plugins directory
require("lazy").setup({
	spec = {
		{ import = "user.plugins" },
	},
	ui = { 
		border = "rounded" 
	},
})
