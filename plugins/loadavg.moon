local *

awful = require'awful'
wibox = require'wibox'
import terminal from require'menubar.utils'


callback = (stdout) =>
    unless stdout and #stdout > 0
        @.markup = '<span foreground="yellow"> </span>'
        return

    it = stdout\gmatch'[%d%.]+'
    avg1  = tonumber it!
    avg5  = tonumber it!
    avg15 = tonumber it!
    max = math.max 5, avg1, avg5, avg15

    res = '<span face="Fira Code" size="xx-small"><span foreground="gray"> </span>'
    res ..= if avg1 < 3
        '<span foreground="cyan">%.2f</span> '\format avg1
    elseif avg1 < 5
        '<span foreground="yellow">%.2f</span> '\format avg1
    else
        '<span foreground="red">%.2f</span> '\format avg1

    res ..= '</span>'

    @markup = res

    avg1widget.value = avg1
    avg1widget.max_value = max
    if avg1 < 3
        avg1widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {100*avg1/max, 0}
            stops: {{0, 'green'}, {0.3, '#00bbbb'}, {0.6, 'blue'}}
    elseif avg1 < 5
        avg1widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {100*avg1/max, 0}
            stops: {{0, 'blue'}, {0.5, 'yellow'}}
    else
        avg1widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {100*avg1/max, 0}
            stops: {{0, 'orange'}, {0.5, 'red'}}

    avg5widget.value = avg5
    avg5widget.max_value = max
    if avg5 < 3
        avg5widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {100*avg5/max, 0}
            stops: {{0, 'green'}, {0.3, '#00bbbb'}, {0.6, 'blue'}}
    elseif avg5 < 5
        avg5widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {100*avg5/max, 0}
            stops: {{0, 'blue'}, {0.5, 'yellow'}}
    else
        avg5widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {100*avg5/max, 0}
            stops: {{0, 'orange'}, {0.5, 'red'}}

    avg15widget.value = avg15
    avg15widget.max_value = max
    if avg15 < 3
        avg15widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {100*avg15/max, 0}
            stops: {{0, 'green'}, {0.3, '#00bbbb'}, {0.6, 'blue'}}
    elseif avg15 < 5
        avg15widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {100*avg15/max, 0}
            stops: {{0, 'blue'}, {0.5, 'yellow'}}
    else
        avg15widget.color =
            type: 'linear'
            from: {0, 0}
            to:   {100*avg15/max, 0}
            stops: {{0, 'orange'}, {0.5, 'red'}}


avg1widget = wibox.widget
    value: 0
    max_value: 1
    color: 'blue'
    background_color: '#00000000'
    forced_width: 100
    border_width: 2
    border_color: 'gray'
    widget: wibox.widget.progressbar

avg5widget = wibox.widget
    value: 0
    max_value: 1
    color: 'blue'
    background_color: '#00000000'
    forced_width: 100
    border_width: 2
    border_color: 'gray'
    widget: wibox.widget.progressbar

avg15widget = wibox.widget
    value: 0
    max_value: 1
    color: 'blue'
    background_color: '#00000000'
    forced_width: 100
    border_width: 2
    border_color: 'gray'
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
            awful.spawn "#{terminal} -e btop"
                fullscreen: true
                urgent:     true
    }
}
