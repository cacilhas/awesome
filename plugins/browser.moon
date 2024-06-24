local *

awful = require'awful'
wibox = require'wibox'
import filesystem from require'gears'


--------------------------------------------------------------------------------
-> wibox.widget {
    image: "#{filesystem.get_configuration_dir!}/assets/www-browser.png"
    resize: true
    widget: wibox.widget.imagebox
    buttons: {
        awful.button {}, 1, ->
            awful.spawn.with_shell 'prime-run www-browser'
    }
}
