local *

awful = require'awful'
wibox = require'wibox'
import trim from require'helpers'

callback = (stdout) =>
    @text = trim stdout


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'sh -c "ls ~/Downloads/ | wc -l"', 2, callback

    bg: '#00000000'
    widget: wibox.container.background
    buttons: {
        awful.button {}, 1, -> awful.spawn 'sh -c "nemo ~/Downloads/"'
    }
}
