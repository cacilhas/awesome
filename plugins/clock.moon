local *

awful = require'awful'
wibox = require'wibox'


--------------------------------------------------------------------------------
->
    clock = wibox.widget
        format:  '<span color="#ffaa88">%a %F %H:%MBRT</span>'
        refresh: 10
        widget:  wibox.widget.textclock
    calendar = awful.widget.calendar_popup.month!

    calendar\attach clock, 'br', on_hover: false
    clock.buttons = {awful.button {}, 1, calendar\toggle}
    clock.calendar = calendar

    clock
