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
naughty = assert require'naughty'   -- notification library
naughty.connect_signal 'request::display_error', (startup) =>
    aplay 'oxygen/stereo/dialog-error-critical.ogg'
    naughty.notification
        urgency: 'critical'
        title:   "Oops, an error happened#{startup and ' during startup' or ''}!"
        message: @


--------------------------------------------------------------------------------
--- Theme
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
if os.execute'pgrep -f "picom --daemon"' != 0
    awful.spawn 'dex --autostart --environment awesome'
    -- FIXME: workaround over wrong picom startup
    awful.spawn "fish #{filesystem.get_xdg_config_home!}/autostart-scripts/compositor.fish"
    -- Pulse Audio startup volume
    os.execute 'pactl set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo    100%' -- sound boxes
    os.execute 'pactl set-sink-volume alsa_output.platform-snd_aloop.0.analog-stereo 60%' -- headphones
    os.execute 'pactl set-sink-volume combined                                       40%' -- master

if os.execute'pgrep f.lux' != 0
    import geo from require'helpers'
    awful.spawn "f.lux -l #{geo.lat} -g #{geo.lon} -k #{geo.temp}"


--------------------------------------------------------------------------------
-- Log-in notification
aplay 'Oxygen-Sys-Log-In-Short.ogg'
