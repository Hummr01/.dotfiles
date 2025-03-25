return {
	{
		"barrett-ruth/live-server.nvim",
		build = "npm add -g live-server",
		cmd = { "LiveServerStart", "LiveServerStop" },
		config = true,
		keys = {
			{ "<F2>", "<cmd>LiveServerStart <CR>", desc = "Start Live Server" },
			{ "<F3>", "<cmd>LiveServerStop <CR>", desc = "Kill Live Server" },
		},
	},
}
