-- ==========================================
-- MAIN HYPRLAND CONFIGURATION
-- ==========================================

-- 1. Source Environment Configurations
require("~/.config/hypr/monitors.lua")
require("~/.config/hypr/style.lua")

-- 2. Preferred Applications
terminal = "kitty"
fileManager = "dolphin"
menu = 'rofi -show drun -run-command "uwsm app -- {cmd}"' --
browser = "brave -use-gl=egl"

-- 3. Autostart Processes (Systemd-integrated via UWSM)
hl.on("hyprland.start", function()
	hl.exec_cmd("[workspace 1 silent] uwsm app -- " .. terminal) --
	hl.exec_cmd("uwsm app -- swaync")
end)
-- Note: Multi-user steam share script should run as a systemd service at boot

-- 4. Input Configuration
hl.config({
	input = {
		kb_layout = "de",
	},
})

-- 5. Device Profiles
hl.device({
	name = "opentabletdriver-virtual-artist-tablet",
	output = "DP-1",
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

-- 6. Bindings & Rules Mapping
require("~/.config/hypr/keymaps.lua")
require("~/.config/hypr/windows.lua")
