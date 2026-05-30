-- Applications
hl.bind("SUPER + Space", hl.dsp.exec_cmd("hyprlauncher"), { description = "Launch application launcher" })
hl.bind("SUPER + Return", hl.dsp.exec_cmd("ghostty"), { description = "Launch terminal emulator" })
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("firefox"), { description = "Launch browser" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("ghostty --title=yazi -e yazi"), { description = "Launch filebrowser" })



-- Windows
hl.bind("SUPER + W", hl.dsp.window.close(), { description = "Close active window" })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true }, { description = "Drag window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true }, { description = "Resize window" })

for key, direction in pairs({ H = "l", J = "d", K = "u", L = "r" }) do
	hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = direction }), { description = "Move focus <" .. direction .. ">" })
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }), { description = "Move window <" .. direction .. ">" })
end



-- Workspaces
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("scratch"), { description = "Toggle scratchpad" })
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratch" }), { description = "Move active window to scratchpad" })

for i = 1, 9 do
	hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }), { description = "Focus workspace " .. i })
	hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follows = true }), { description = "Move active window to workspace " .. i })
end

-- Multimedia
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
