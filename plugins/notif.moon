local *

awful = require'awful'
wibox = require'wibox'
naughty = require'naughty'

callback = =>
    naughty.toggle!
    widget.text = if naughty.is_suspended! then '🔕' else '🔔'
    unless naughty.is_suspended!
        naughty.notify
            title: 'Info'
            message: 'Notifications enabled'
            timeout: 2


--------------------------------------------------------------------------------
widget = wibox.widget {
    text: '🔔'

    bg: '#00000000'
    widget: wibox.widget.textbox
    buttons: {
        awful.button {}, 1, callback
    }
}


--------------------------------------------------------------------------------
-> widget
