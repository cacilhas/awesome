local *

awful = require'awful'
wibox = require'wibox'
import filesystem from require'gears'


--------------------------------------------------------------------------------
-> wibox.widget
    markup:  '<span color="brown"> </span><span color="black"> </span><span color="#0044ff"> </span>'
    widget:  wibox.widget.textbox
    buttons: {
        awful.button {}, 1, ->
            awful.spawn "#{filesystem.get_configuration_dir!}/assets/archlogo"
    }
