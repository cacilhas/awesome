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
            awful.spawn.single_instance 'prime-run www-browser', rule: 'browser'
    }
}

image.timer or= gears.timer
    autostart: true
    timeout:   30
    callback:  -> image\emit_signal 'widget::redraw_needed'


--------------------------------------------------------------------------------
-> image
