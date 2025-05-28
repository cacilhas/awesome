local *

awful = require'awful'
wibox = require'wibox'
naughty = require'naughty'

callback = =>
    naughty.toggle!
    if naughty.is_suspended!
        widget.text = '🔕'
    else
        widget.text = '🔔'
        naughty.notify
            title: 'Notification'
            message: 'Notifications enabled'
            timeout: 2


--------------------------------------------------------------------------------
widget = wibox.widget
    text: '🔔'
    bg: '#00000000'
    widget: wibox.widget.textbox
    buttons: {
        awful.button {}, 1, callback
    }


--------------------------------------------------------------------------------
-> widget
