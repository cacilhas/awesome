local *

awful = require'awful'
gears = require'gears'
wibox = require'wibox'
import filesystem from require'gears'


--------------------------------------------------------------------------------
image = wibox.widget {
    image: "#{filesystem.get_configuration_dir!}/assets/www-browser.png"
    resize: true
    widget: wibox.widget.imagebox
    buttons: {
        awful.button {}, 1, ->
            awful.spawn.raise_or_spawn 'prime-run www-browser', window_rule: 'browser'
    }
}

image.timer or= gears.timer
    autostart: true
    timeout:   30
    callback:  -> image\emit_signal 'widget::redraw_needed'


--------------------------------------------------------------------------------
-> image
