-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "catppuccin-mocha"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 11

config.hide_tab_bar_if_only_one_tab = true

--- Tmux Replace
config.term = "xterm-256color"
config.window_background_opacity = 0.99
config.window_padding = {
	left = 1,
	right = 1,
	top = 1,
	bottom = 1,
}

local session_manager = require("wezterm-session-manager/session-manager")
wezterm.on("save_session", function(window)
	session_manager.save_state(window)
end)
wezterm.on("load_session", function(window)
	session_manager.load_session(window)
end)
wezterm.on("restore_session", function(window)
	session_manager.restore_session(window)
end)

config.use_fancy_tab_bar = false
config.enable_scroll_bar = true
config.leader = {
	key = "a",
	mods = "CTRL",
	timeout_milliseconds = 1000,
}

config.keys = {
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "m",
		mods = "LEADER",
		action = act.TogglePaneZoomState,
	},
	{
		key = "Space",
		mods = "LEADER",
		action = act.RotatePanes("Clockwise"),
	},
	{
		key = "0",
		mods = "LEADER",
		action = act.PaneSelect({ mode = "SwapWithActive" }),
	},
	{
		key = "Enter",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},
	{
		key = "w",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},
	{
		key = "S",
		mods = "LEADER|SHIFT",
		action = wezterm.action({ EmitEvent = "save_session" }),
	},
	{
		key = "R",
		mods = "LEADER|SHIFT",
		action = wezterm.action({ EmitEvent = "restore_session" }),
	},
	{
		key = "L",
		mods = "LEADER|SHIFT",
		action = wezterm.action({ EmitEvent = "load_session" }),
	},
}

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

-- and finally, return the configuration to wezterm
return config
