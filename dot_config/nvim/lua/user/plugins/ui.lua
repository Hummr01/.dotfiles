return {
	{ -- Theme
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup({ styles = { comments = { italic = false } } })
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	{ -- Utilities
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
		end,
	},
	{ "folke/which-key.nvim", event = "VimEnter", opts = { delay = 0 } },
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{ "NMAC427/guess-indent.nvim", opts = {} },
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" }, -- Fixed broken character mapping
				changedelete = { text = "~" },
			},
		},
	},
}
