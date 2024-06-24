local *

awful = require'awful'
wibox = require'wibox'
import filesystem from require'gears'
import showgames from require'helpers'


--------------------------------------------------------------------------------
-> wibox.widget {
    image: "#{filesystem.get_configuration_dir!}/assets/eidolon.png"
    resize: true
    widget: wibox.widget.imagebox
    buttons: {
        awful.button {}, 1, showgames
            --awful.spawn.with_shell "prime-run eidolon menu"
    }
}
