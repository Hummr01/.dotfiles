-- ==========================================
-- MAIN HYPRLAND CONFIGURATION
-- ==========================================

-- 1. Source Environment Configurations[cite: 2]
require("~/.config/hypr/monitors.lua") --[cite: 2]
require("~/.config/hypr/style.lua") --[cite: 2]

-- 2. Preferred Applications[cite: 2]
terminal = "kitty" --[cite: 2]
fileManager = "dolphin" --[cite: 2]
menu = 'rofi -show drun -run-command "uwsm app -- {cmd}"' --[cite: 2]
browser = "brave -use-gl=egl" --[cite: 2]

-- 3. Autostart Processes (Systemd-integrated via UWSM)[cite: 2]
hl.on("hyprland.start", function () 
hl.exec_cmd("[workspace 1 silent] uwsm app -- " .. terminal) --[cite: 2]
hl.exec_cmd("[workspace 9 silent] uwsm app -- keepassxc") --[cite: 2]
hl.exec_cmd("uwsm app -- swaync") --[cite: 2]
end) 
-- Note: Multi-user steam share script should run as a systemd service at boot[cite: 2]

-- 4. Input Configuration[cite: 2]
    hl.config({
        input = {
            kb_layout = "de",
    }
})

-- 5. Device Profiles[cite: 2]
hl.device({
    name = "opentabletdriver-virtual-artist-tablet", --[cite: 2]
    output = "DP-1" --[cite: 2]
})

hl.device({
    name = "epic-mouse-v1", --[cite: 2]
    sensitivity = -0.5 --[cite: 2]
    })

-- 6. Bindings & Rules Mapping[cite: 2]
require("~/.config/hypr/keymaps.lua") --[cite: 2]
require("~/.config/hypr/windows.lua") --[cite: 2]
