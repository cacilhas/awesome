local *

-- Deal with LuaRocks
pcall require, "luarocks.loader"

-- Standard libs
assert require"gears"
assert require"wibox"
assert require"ruled"     -- declarative object management
awful = assert require"awful"

assert require"awful.hotkeys_popup.keys" -- enable hotkeys help widget for VIM and other apps
assert require"awful.autofocus"


--------------------------------------------------------------------------------
--- Error handling
naughty = assert require"naughty"   -- notification library
naughty.connect_signal "request::display_error", (startup) =>
    naughty.notification
        urgency: "critical"
        title:   "Oops, an error happened#{startup and " during startup!" or "!"}"
        message: @


--------------------------------------------------------------------------------
--- Theme
theme = assert require"beautiful"
themes_path = "#{awful.util.getdir"config"}/themes"
theme.init "#{themes_path}/cacilhas/theme.lua"


--------------------------------------------------------------------------------
-- Menu
assert require"menus"


--------------------------------------------------------------------------------
-- Tag layout
assert require"taglayouts"


--------------------------------------------------------------------------------
--- Wallpaper
assert require"wallpaper"


--------------------------------------------------------------------------------
--- Wibar
assert require"bars"


--------------------------------------------------------------------------------
--- Mouse bindings
assert require"mousebindings"


--------------------------------------------------------------------------------
--- Key bindings
assert require"keybindings"


--------------------------------------------------------------------------------
--- Rules
assert require"rules"


--------------------------------------------------------------------------------
--- Titlebars
assert require"titlebars"


--------------------------------------------------------------------------------
--- Notifications
assert require"notifications"


--------------------------------------------------------------------------------
-- Startup apps
if os.execute"pgrep picom" != 0
    awful.spawn "dex --autostart --environment awesome"
    awful.spawn "play /usr/share/sounds/Oxygen-Sys-Log-In-Short.ogg"
