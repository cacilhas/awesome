local *

awful = require'awful'
wibox = require'wibox'
import trim from require'helpers'

callback = (stdout) =>

    host = trim stdout
    color = '#0044ff'
    if not host or #host == 0
        host = '  '
        color = 'red'
    user = trim os.getenv'USER'
    if not user or #user == 0
        user = '  '
        color = 'red'

    @markup = "<span color=\"#{color}\">#{user}@#{host}</span>"


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'cat /etc/hostname', 30, callback

    bg: '#00000000'
    widget: wibox.container.background
    buttons: {
        awful.button {}, 1, ->
            awful.spawn 'prime-run nemo Desktop'
                floating: true
                focus:    true
                sticky:   true
                placement: awful.placement.centered
    }
}
