local *

awful = require'awful'
wibox = require'wibox'
import filesystem from require'gears'


--------------------------------------------------------------------------------
-> wibox.widget {
    image: "#{filesystem.get_configuration_dir!}/assets/shortwave.png"
    resize: true
    widget: wibox.widget.imagebox
    buttons: {
        awful.button {}, 1, ->
            awful.spawn 'shortwave'
    }
}
