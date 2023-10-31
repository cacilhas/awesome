local *

gears = require"gears"
awful = require"awful"
theme = require"beautiful"
wibox = require"wibox"


--------------------------------------------------------------------------------
--- Wallpaper

wallpapers = {theme.wallpaper}
do
    dir = "#{gears.filesystem.get_xdg_data_home!}/wallpapers"
    with io.popen "ls #{dir}/*.png #{dir}/*.jpg"
        files = [file for file in \lines!]
        \close!
        wallpapers = files if #files > 0

screen.connect_signal "request::wallpaper", =>
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
            horizontal_fit_policy: "fit"
            vertical_fit_policy:   "fit"
            widget: wibox.widget.imagebox
    }

gears.timer
    autostart: true
    call_now:  true
    timeout:   15*60
    callback:  -> awful.screen.focused!\emit_signal "request::wallpaper"
