local *

awful = require'awful'
naughty = require'naughty'
wibox = require'wibox'
theme = require'beautiful'

callback = (stdout) =>
    @align = 'center'
    unless stdout and #stdout > 0
        @markup = "<span size=\"small\"><span color=\"red\">🌡</span>℃</span>"
        @container.value = 10
        return

    for line in stdout\gmatch'[^\n]+'
        matcher = line\gmatch'[^ ]+'
        if matcher! == 'temp1:'
            value = matcher!
            @markup = "<span size=\"small\"><span color=\"red\">🌡</span>#{value}</span>"
            @container.value = tonumber value\gmatch'[%d%.]+'!
            return


--------------------------------------------------------------------------------
->
    watch, timer = awful.widget.watch 'sensors', 60, callback

    watch.container = wibox.widget {
        watch

        bg: theme.bg_button
        widget: wibox.container.radialprogressbar
        color: 'white'
        border_color: 'black'
        forced_width: 84
        border_width: 2
        padding: 5
        placement: awful.placement.centered
        min_value: 10
        max_value: 60
        buttons: {
            awful.button {}, 1, -> timer\emit_signal 'timeout'
        }
    }

    watch.container
