local *

awful = require'awful'
wibox = require'wibox'


--------------------------------------------------------------------------------
-> wibox.widget
    format:   '<span color="#00aa55">%H:%MZ</span>'
    timezone: 'UTC'
    refresh:  10
    widget:   wibox.widget.textclock
    buttons:  {
        awful.button {}, 1, ->
            awful.spawn.raise_or_spawn 'kodumaro-clock', class: 'kodumaro-clock'
    }
