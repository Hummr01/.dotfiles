-- lua/plugins/themes/catppuccin.lua
return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- or latte, frappe, macchiato
			-- other options
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
