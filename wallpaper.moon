local *

gears = require'gears'
awful = require'awful'
theme = require'beautiful'
wibox = require'wibox'

_G.screentimer or= {}


--------------------------------------------------------------------------------
--- Wallpaper

wallpapers = {theme.wallpaper}
do
    dir = "#{gears.filesystem.get_xdg_data_home!}/wallpapers"
    with io.popen "ls #{dir}/*.png #{dir}/*.jpg"
        files = [file for file in \lines!]
        \close!
        wallpapers = files if #files > 0

screen.connect_signal 'request::wallpaper', =>
    @wallpaper_index = if @wallpaper_index
        w = @wallpaper_index + 1
        w = 1 if w > #wallpapers
        w
    else
        math.random 1, #wallpapers

    awful.wallpaper {
        screen: @
        widget:
            image: wallpapers[@wallpaper_index]
            horizontal_fit_policy: 'fit'
            vertical_fit_policy:   'fit'
            widget: wibox.widget.imagebox
    }

    -- Force iDesk to reload whenever the wallpaper changes
    --awful.spawn.with_shell "#{gears.filesystem.get_configuration_dir!}/assets/reload-idesk"

for s in screen
    if _G.screentimer[s.index]
        _G.screentimer[s.index]\again!

    else
        _G.screentimer[s.index] = gears.timer
            autostart: true
            call_now:  true
            timeout:   15*60
            callback:  -> s\emit_signal 'request::wallpaper'

_G.screentimer[i]\stop! for i = screen\count! + 1, #_G.screentimer
_G.screentimer[i] = nil for i = screen\count! + 1, #_G.screentimer

awesome.connect_signal 'request::wallpaper', ->
    s\emit_signal'request::wallpaper' for s in screen
