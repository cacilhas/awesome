local *

awful = require'awful'
wibox = require'wibox'
gears = require'gears'
import trim from require'helpers'
import filesystem from gears


command = "lsmod | sed -E 's/  */ /g' | awk '$1 ~ /^uvcvideo$/ { print $3; }'"

callback = ->
    awful.spawn.easy_async_with_shell command, (output) ->
        output = if output then trim output else ''
        with image
            if output != '1'
                .image = "#{filesystem.get_configuration_dir!}/assets/webcam-off.png"
                \set_opacity 0.5
            else
                .image = "#{filesystem.get_configuration_dir!}/assets/webcam-on.png"
                \set_opacity 1


--------------------------------------------------------------------------------
image = wibox.widget {
    image: "#{filesystem.get_configuration_dir!}/assets/webcam.png"
    resize: true
    widget: wibox.widget.imagebox

    buttons: {
        awful.button {}, 1, callback
    }
}

image.timer or= gears.timer
    autostart: true
    call_now:  true
    timeout:   1
    :callback


--------------------------------------------------------------------------------
-> image
