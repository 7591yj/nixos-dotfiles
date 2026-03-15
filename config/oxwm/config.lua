---@meta
---@module "oxwm"

local modkey = "Mod1"
local terminal = "st"

local colors = {
	fg = "#c5c8c6",
	red = "#cc6666",
	bg = "#1d1f21",
	cyan = "#8abeb7",
	green = "#b5bd68",
	lavender = "#b294bb",
	light_blue = "#81a2be",
	grey = "#969896",
	blue = "#81a2be",
	purple = "#b294bb",
	selection = "#373b41",
}

local tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
local bar_font = "PlemolJP35:style=Bold:size=11"

local function spawn(...)
	return oxwm.spawn({ ... })
end

local function spawn_shell(command)
	return oxwm.spawn({ "sh", "-c", command })
end

local function rofi_powermenu()
	return spawn_shell([[
		choice="$(printf 'lock\nsuspend\nlogout\nreboot\npoweroff' | rofi -dmenu -i -p power)" &&
			case "$choice" in
				lock) slock ;;
			suspend) slock & sleep 1; systemctl suspend ;;
			logout) pkill oxwm ;;
			reboot) systemctl reboot ;;
			poweroff) systemctl poweroff ;;
		esac
	]])
end

local function wallpaper_menu()
	return spawn_shell([[
		dir="${HOME}/Pictures/Wallpapers"
		[ -d "$dir" ] || exit 0
		choice="$(find "$dir" -maxdepth 1 -type f | sort | sed "s|$dir/||" | rofi -dmenu -i -p wallpaper)" &&
		[ -n "$choice" ] &&
		feh --bg-fill "$dir/$choice"
	]])
end

local blocks = {
	oxwm.bar.block.ram({
		format = "{used}G",
		interval = 5,
		color = colors.light_blue,
		underline = true,
	}),
	oxwm.bar.block.static({
		text = "|",
		interval = 999999999,
		color = colors.lavender,
		underline = false,
	}),
	oxwm.bar.block.battery({
		format = "{}%",
		charging = "AC{}%",
		discharging = "{}%",
		full = "{}%",
		interval = 30,
		color = colors.green,
		underline = true,
	}),
	oxwm.bar.block.static({
		text = "|",
		interval = 999999999,
		color = colors.lavender,
		underline = false,
	}),
	oxwm.bar.block.datetime({
		format = "{}",
		date_format = "%-I:%M %a %d ",
		interval = 1,
		color = colors.cyan,
		underline = true,
	}),
}

oxwm.set_terminal(terminal)
oxwm.set_modkey(modkey)
oxwm.set_tags(tags)
oxwm.tag.set_back_and_forth(true)

oxwm.set_layout_symbol("tiling", "[T]")
oxwm.set_layout_symbol("normie", "[F]")
oxwm.set_layout_symbol("tabbed", "[=]")
oxwm.set_layout_symbol("monocle", "[M]")
oxwm.set_layout_symbol("scrolling", "[S]")

oxwm.border.set_width(2)
oxwm.border.set_focused_color(colors.blue)
oxwm.border.set_unfocused_color(colors.bg)

oxwm.gaps.set_smart(true)
oxwm.gaps.set_inner(5, 5)
oxwm.gaps.set_outer(5, 5)

oxwm.rule.add({ instance = "nautilus", floating = true })
oxwm.rule.add({ instance = "gimp", floating = true })

oxwm.bar.set_font(bar_font)
oxwm.bar.set_blocks(blocks)
oxwm.bar.set_scheme_normal(colors.fg, colors.bg, colors.selection)
oxwm.bar.set_scheme_occupied(colors.cyan, colors.bg, colors.cyan)
oxwm.bar.set_scheme_selected(colors.cyan, colors.bg, colors.purple)
oxwm.bar.set_scheme_urgent(colors.red, colors.bg, colors.red)

oxwm.autostart("sh -lc 'pgrep -x picom >/dev/null || exec picom --config \"$HOME/.config/picom/picom.conf\"'")
oxwm.autostart('sh -lc \'[ -f "$HOME/.fehbg" ] && "$HOME/.fehbg"\'')
oxwm.autostart("sh -lc 'pgrep -x blueman-applet >/dev/null || exec blueman-applet'")
oxwm.autostart("sh -lc 'pgrep -x fcitx5 >/dev/null || exec fcitx5 -d'")
oxwm.autostart("sh -lc 'sleep 0.2; xdotool key Super_L+c'")

-- Launchers and overlays
oxwm.key.bind({ modkey }, "Return", oxwm.spawn_terminal())
oxwm.key.bind({ modkey }, "E", spawn("nautilus"))
oxwm.key.bind({ modkey }, "Z", spawn("zen-beta"))
oxwm.key.bind({ modkey }, "T", spawn("Telegram"))
oxwm.key.bind({ modkey }, "D", spawn("legcord"))
oxwm.key.bind({ modkey }, "Space", spawn_shell("rofi -show drun -show-icons"))
oxwm.key.bind({ modkey }, "V", spawn_shell("CM_LAUNCHER=rofi clipmenu"))
oxwm.key.bind({ "Control", "Shift" }, "Escape", spawn_shell("rofi -show window"))
oxwm.key.bind({ modkey }, "X", rofi_powermenu())
oxwm.key.bind({ modkey }, "comma", spawn("nm-connection-editor"))
oxwm.key.bind({ modkey }, "B", spawn("blueman-manager"))
oxwm.key.bind({ modkey }, "Y", wallpaper_menu())
oxwm.key.bind({ modkey }, "N", spawn("st", "-e", "sh", "-lc", "nmtui"))
oxwm.key.bind({ modkey, "Shift" }, "N", spawn("st", "-e", "sh", "-lc", '${EDITOR:-nvim} "$HOME/notes.txt"'))
oxwm.key.bind({ modkey, "Shift" }, "Slash", oxwm.show_keybinds())

-- Session and system controls
oxwm.key.bind({ modkey, "Mod4" }, "L", spawn("slock"))
oxwm.key.bind({ modkey, "Shift" }, "E", oxwm.quit())
oxwm.key.bind({ modkey, "Shift" }, "R", oxwm.restart())
oxwm.key.bind({ modkey, "Shift" }, "P", spawn_shell("xset dpms force off"))

-- Audio and brightness
oxwm.key.bind({}, "XF86AudioRaiseVolume", spawn("pamixer", "-i", "3"))
oxwm.key.bind({}, "XF86AudioLowerVolume", spawn("pamixer", "-d", "3"))
oxwm.key.bind({}, "XF86AudioMute", spawn("pamixer", "-t"))
oxwm.key.bind({}, "XF86AudioMicMute", spawn("pamixer", "--default-source", "-t"))
oxwm.key.bind({}, "XF86AudioPause", spawn("playerctl", "play-pause"))
oxwm.key.bind({}, "XF86AudioPlay", spawn("playerctl", "play-pause"))
oxwm.key.bind({}, "XF86AudioPrev", spawn("playerctl", "previous"))
oxwm.key.bind({}, "XF86AudioNext", spawn("playerctl", "next"))
oxwm.key.bind({}, "XF86MonBrightnessUp", spawn("brightnessctl", "set", "+5%"))
oxwm.key.bind({}, "XF86MonBrightnessDown", spawn("brightnessctl", "set", "5%-"))

-- Window management
oxwm.key.bind({ modkey }, "Q", oxwm.client.kill())
oxwm.key.bind({ modkey }, "F", oxwm.layout.set("monocle"))
oxwm.key.bind({ modkey, "Shift" }, "F", oxwm.client.toggle_fullscreen())
oxwm.key.bind({ modkey }, "M", oxwm.layout.set("monocle"))
oxwm.key.bind({ modkey, "Shift" }, "T", oxwm.client.toggle_floating())
oxwm.key.bind({ modkey }, "W", oxwm.layout.set("tabbed"))
oxwm.key.bind({ modkey }, "Tab", oxwm.layout.cycle())
oxwm.key.bind({ modkey }, "C", oxwm.layout.set("scrolling"))
oxwm.key.bind({ modkey, "Shift" }, "C", oxwm.layout.set("tiling"))
oxwm.key.bind({ modkey }, "A", oxwm.toggle_gaps())
oxwm.key.bind({ modkey }, "Minus", oxwm.set_master_factor(-5))
oxwm.key.bind({ modkey }, "equal", oxwm.set_master_factor(5))
oxwm.key.bind({ modkey, "Shift" }, "Minus", oxwm.inc_num_master(-1))
oxwm.key.bind({ modkey, "Shift" }, "equal", oxwm.inc_num_master(1))

-- Focus movement
oxwm.key.bind({ modkey }, "Down", oxwm.client.focus_stack(1))
oxwm.key.bind({ modkey }, "J", oxwm.client.focus_stack(1))
oxwm.key.bind({ modkey }, "Up", oxwm.client.focus_stack(-1))
oxwm.key.bind({ modkey }, "K", oxwm.client.focus_stack(-1))
oxwm.key.bind({ modkey }, "Left", oxwm.monitor.focus(-1))
oxwm.key.bind({ modkey }, "H", oxwm.monitor.focus(-1))
oxwm.key.bind({ modkey }, "Right", oxwm.monitor.focus(1))
oxwm.key.bind({ modkey }, "L", oxwm.monitor.focus(1))

-- Window movement
oxwm.key.bind({ modkey, "Shift" }, "Down", oxwm.client.move_stack(1))
oxwm.key.bind({ modkey, "Shift" }, "J", oxwm.client.move_stack(1))
oxwm.key.bind({ modkey, "Shift" }, "Up", oxwm.client.move_stack(-1))
oxwm.key.bind({ modkey, "Shift" }, "K", oxwm.client.move_stack(-1))
oxwm.key.bind({ modkey, "Shift" }, "Left", oxwm.monitor.tag(-1))
oxwm.key.bind({ modkey, "Shift" }, "H", oxwm.monitor.tag(-1))
oxwm.key.bind({ modkey, "Shift" }, "Right", oxwm.monitor.tag(1))
oxwm.key.bind({ modkey, "Shift" }, "L", oxwm.monitor.tag(1))

-- Workspace navigation
oxwm.key.bind({ modkey }, "I", oxwm.tag.view_next())
oxwm.key.bind({ modkey }, "U", oxwm.tag.view_previous())

for index = 1, #tags do
	oxwm.key.bind({ modkey }, tostring(index), oxwm.tag.view(index - 1))
	oxwm.key.bind({ modkey, "Shift" }, tostring(index), oxwm.tag.move_to(index - 1))
	oxwm.key.bind({ modkey, "Control" }, tostring(index), oxwm.tag.toggleview(index - 1))
	oxwm.key.bind({ modkey, "Control", "Shift" }, tostring(index), oxwm.tag.toggletag(index - 1))
end

-- Screenshots
oxwm.key.bind({}, "Print", spawn_shell("maim -s | xclip -selection clipboard -t image/png"))
oxwm.key.bind({ "Control" }, "Print", spawn_shell("maim | xclip -selection clipboard -t image/png"))
oxwm.key.bind(
	{ "Mod4" },
	"Print",
	spawn_shell("maim -i $(xdotool getactivewindow) | xclip -selection clipboard -t image/png")
)
