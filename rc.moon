local *

-- Deal with LuaRocks
pcall require, 'luarocks.loader'
_, posix = xpcall (-> require'posix'), (-> os)

-- Standard libs
assert require'wibox'
assert require'ruled'     -- declarative object management
awful = assert require'awful'
gears = assert require 'gears'
import filesystem from gears
import aplay from assert require'helpers'

assert require'awful.hotkeys_popup.keys' -- enable hotkeys help widget for VIM and other apps
assert require'awful.autofocus'


--------------------------------------------------------------------------------
-- Inject gear string utils into string metatable
do
    smt = getmetatable''.__index
    smt[key] = value for key, value in pairs gears.string


--------------------------------------------------------------------------------
--- Error handling
do
    naughty = assert require'naughty'   -- notification library
    naughty.connect_signal 'request::display_error', (startup) =>
        aplay 'oxygen/stereo/dialog-error-critical.ogg'
        naughty.notification
            urgency: 'critical'
            title:   "Oops, an error happened#{startup and ' during startup' or ''}!"
            message: @


--------------------------------------------------------------------------------
--- Theme
do
    theme = assert require'beautiful'
    themes_path = "#{filesystem.get_configuration_dir!}/themes"
    posix.setenv 'AWESOME_THEMES_PATH', themes_path if posix.setenv
    theme.init "#{themes_path}/cacilhas/theme.lua"


--------------------------------------------------------------------------------
-- Menu
assert require'menus'


--------------------------------------------------------------------------------
-- Tag layout
assert require'taglayouts'


--------------------------------------------------------------------------------
--- Wallpaper
assert require'wallpaper'


--------------------------------------------------------------------------------
--- Wibar
assert require'bars'


--------------------------------------------------------------------------------
--- Mouse bindings
assert require'mousebindings'


--------------------------------------------------------------------------------
--- Key bindings
assert require'bindings'


--------------------------------------------------------------------------------
--- Rules
assert require'rules'


--------------------------------------------------------------------------------
--- Titlebars
assert require'titlebars'


--------------------------------------------------------------------------------
--- Notifications
assert require'notifications'


--------------------------------------------------------------------------------
-- Startup apps
unless os.execute'pgrep -f "picom --daemon"'
    assert require'startup'


--------------------------------------------------------------------------------
-- Log-in notification
unless _G.startupdone
    aplay 'Oxygen-Sys-Log-In-Short.ogg'
    _G.startupdone = true
