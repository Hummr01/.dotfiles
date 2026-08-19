-- ==========================================
-- WINDOWS AND WORKSPACES RULES
-- ==========================================

-- Global Window Rules
hl.window_rule({ match = { class = "kitty" }, opacity = "0.9" })
hl.window_rule({ match = { class = "org.keepassxc.KeePassXC" }, workspace = "9 silent" })
hl.window_rule({ match = { class = "steam", title = "Steam" }, workspace = "8 silent" })
hl.window_rule({ match = { class = "discord" }, workspace = "2 silent" })
hl.window_rule({ match = { class = "brave-browser" }, workspace = "3 silent" })

-- Specialized Application Layout Hooks
hl.window_rule({
	name = "move-Steam",
	match = {
		class = "steam",
		title = "Steam Big Picture Mode",
	},
	monitor = "0",
})

hl.workspace_rule({ workspace = "1", monitor = "DP-2", default = true })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
