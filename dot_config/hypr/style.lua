-- ==========================================
-- LOOK AND FEEL
-- ==========================================
-- Lockscreen binds
hl.bind("CONTROL + SHIFT + L", hl.dsp.exec_raw("hyprlock"))

-- General Aesthetics
hl.config({
    general = {
    gaps_in = 5,
    gaps_out = 20,
    border_size = 2,
    resize_on_border = false,
    allow_tearing = true,
    layout = "dwindle"

}
})

-- Decoration
    hl.config({
        decoration = {
    rounding = 10,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = {
        enabled = true,
        range = 4,
        render_power = 3,
        color = "rgba(1a1a1aee)"
    },
    blur = {
        enabled = true,
        size = 3,
        passes = 1,
        vibrancy = 0.1696
    }}
})

-- Animations
hl.config({
    animations = {
    enabled = true,
    bezier = {
        {"myBezier", 0.05, 0.9, 0.1, 1.05}
    },
    animation = {
        {"windows", 1, 7, "myBezier"},
        {"windowsOut", 1, 7, "default", "popin 80%"},
        {"border", 1, 10, "default"},
        {"borderangle", 1, 8, "default"},
        {"fade", 1, 7, "default"},
        {"workspaces", 1, 6, "default"}
    }}
})


