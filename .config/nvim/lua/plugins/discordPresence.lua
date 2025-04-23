return {
	"andweeb/presence.nvim",
	config = function()
		require("presence").setup({
			enable_line_number = true,
		})
	end,
}
