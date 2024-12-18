local *

awful = require'awful'
wibox = require'wibox'
import trim from require'helpers'
import filesystem from require'gears'


command = "lsmod | sed -E 's/  */ /g' | awk '$1 ~ /^uvcvideo$/ { print $3; }'"

callback = ->
    awful.spawn.easy_async_with_shell command, (output) ->
        output = if output then trim output else ''
        output = tonumber(output) or 0
        with image
            if output % 2 == 1
                .image = "#{filesystem.get_configuration_dir!}/assets/webcam-on.png"
                \set_opacity 1
            else
                .image = "#{filesystem.get_configuration_dir!}/assets/webcam-off.png"
                \set_opacity 0.5


--------------------------------------------------------------------------------
image = wibox.widget {
    image: "#{filesystem.get_configuration_dir!}/assets/webcam.png"
    resize: true
    widget: wibox.widget.imagebox

    buttons: {
        awful.button {}, 1, callback
    }
}


--------------------------------------------------------------------------------
-> wibox.widget {
    image
    awful.widget.watch command, 1, callback

    bg: '#00000000'
    widget: wibox.container.background
}
