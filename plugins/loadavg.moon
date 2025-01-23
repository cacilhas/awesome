local *

awful = require'awful'
wibox = require'wibox'
theme = require'beautiful'
import terminal from require'menubar.utils'


callback = (stdout) =>
    unless stdout and #stdout > 0
        @markup = "<span foreground=\"#{theme.fg_urgent}\" background=\"#{theme.bg_urgent}\">  couldn’t get load average</span>"
        return

    it = stdout\gmatch'[%d%.]+'
    avg1  = tonumber it!
    avg5  = tonumber it!
    avg15 = tonumber it!
    max = math.max 5, avg1, avg5, avg15

    res = "<span face=\"Fira Code\" size=\"xx-small\"><span foreground=\"#{theme.fg_normal}\"> </span>"
    res ..= if avg1 < 3
        '<span foreground="%s">%.2f</span> '\format theme.bg_focus, avg1
    elseif avg1 < 5
        '<span foreground="%s">%.2f</span> '\format theme.fg_urgent, avg1
    else
        '<span foreground="%s">%.2f</span> '\format theme.bg_urgent, avg1

    res ..= '</span>'

    @markup = res

    avg1widget.value = avg1
    avg1widget.max_value = max
    normal_stops = {{0, 'green'}, {0.3, '#00bbbb'}, {0.6, 'blue'}}
    attention_stops = {{0, 'blue'}, {0.5, 'yellow'}}
    alert_stops = {{0, 'orange'}, {0.5, 'red'}}
    avg1_percent = 100*avg1/max
    avg5_percent = 100*avg5/max
    avg15_percent = 100*avg15/max

    if avg1 < 3
        avg1widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {avg1_percent, 0}
            stops: normal_stops
    elseif avg1 < 5
        avg1widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {avg1_percent, 0}
            stops: attention_stops
    else
        avg1widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {avg1_percent, 0}
            stops: alert_stops

    avg5widget.value = avg5
    avg5widget.max_value = max
    if avg5 < 3
        avg5widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {avg5_percent, 0}
            stops: normal_stops
    elseif avg5 < 5
        avg5widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {avg5_percent, 0}
            stops: attention_stops
    else
        avg5widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {avg5_percent, 0}
            stops: alert_stops

    avg15widget.value = avg15
    avg15widget.max_value = max
    if avg15 < 3
        avg15widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {avg15_percent, 0}
            stops: normal_stops
    elseif avg15 < 5
        avg15widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {avg15_percent, 0}
            stops: attention_stops
    else
        avg15widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {avg15_percent, 0}
            stops: alert_stops


avg1widget = wibox.widget
    value: 0
    max_value: 1
    color: 'blue'
    background_color: '#00000000'
    forced_width: 100
    border_width: 1
    border_color: theme.bg_normal
    widget: wibox.widget.progressbar

avg5widget = wibox.widget
    value: 0
    max_value: 1
    color: 'blue'
    background_color: '#00000000'
    forced_width: 100
    border_width: 1
    border_color: theme.bg_normal
    widget: wibox.widget.progressbar

avg15widget = wibox.widget
    value: 0
    max_value: 1
    color: 'blue'
    background_color: '#00000000'
    forced_width: 100
    border_width: 1
    border_color: theme.bg_normal
    widget: wibox.widget.progressbar


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'cat /proc/loadavg', 5, callback

    {
        avg1widget
        avg5widget
        avg15widget
        layout: wibox.layout.flex.vertical
    }

    bg: '#00000000'
    layout: wibox.layout.align.horizontal
    widget: wibox.container.background

    buttons: {
        awful.button {}, 1, ->
            awful.spawn.raise_or_spawn "#{terminal} -e btop"
                fullscreen: true
                urgent:     true
    }
}
