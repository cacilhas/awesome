local *

awful = require'awful'
gears = require'gears'
wibox = require'wibox'
import filesystem from require'gears'


--------------------------------------------------------------------------------
-> wibox.widget {
    image: "#{filesystem.get_configuration_dir!}/assets/www-browser.png"
    resize: true
    widget: wibox.widget.imagebox
    buttons: {
        awful.button {}, 1, ->
            awful.spawn.raise_or_spawn 'prime-run www-browser', window_rule: 'browser'
    }
}
