local *

awful = require'awful'
wibox = require'wibox'
naughty = require'naughty'
import link, showpopup from require'helpers'

callback = (stdout, _, reason, exitcode) =>
    if reason == 'exit'
        @text = if exitcode == 0 then '🌐' else '⛔'
    else
        @text = '‼️'
        naughty.notify
            title: 'Netcat Error'
            text: "Netcat killed with signal #{exitcode}\n#{reason}"
            timeout: 5
            error: erroricon


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'sh -c "timeout 2 nc -zv one.one.one.one 80"', 10, callback

    bg: '#00000000'
    widget: wibox.container.background
    buttons: {
        awful.button {}, 1, ->
            link.show => showpopup(@).visible = true
    }
}
