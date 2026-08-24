-- Assign standard apps to a specific workspace
-- Assign apps silently (opens in the background without pulling focus)

hl.window_rule({
	match = { class = "chromium" },
	workspace = "1",
})

hl.window_rule({
	match = { class = "class: com.mitchellh.ghostty" },
	workspace = "2",
})

hl.window_rule({
	match = { class = "chrome-discord.com__channels_@me-Default" },
	workspace = "3",
})

hl.window_rule({
	match = { class = "steam" },
	workspace = "4 silent",
})

hl.window_rule({
	match = { class = "chrome-gmail.google.com__-Default" },
	workspace = "5",
})
