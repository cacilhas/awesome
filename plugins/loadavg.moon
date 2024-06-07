local *

awful = require'awful'
wibox = require'wibox'
import terminal from require'helpers'


callback = (stdout) =>
    unless stdout and #stdout > 0
        @.markup = '<span foreground="yellow"> </span>'
        return

    it = stdout\gmatch'[%d%.]+'
    avg1  = tonumber it!
    avg5  = tonumber it!
    avg15 = tonumber it!

    res = '<span face="Fira Code" size="xx-small">'
    res ..= if math.max(avg1, math.max(avg5, avg15)) >= 5
        '<span foreground="red"> </span>'
    else
        '<span foreground="gray"> </span>'

    res ..= if avg1 < 3
        '<span foreground="cyan">¹%.2f</span> '\format avg1
    elseif avg1 < 5
        '<span foreground="yellow">¹%.2f</span> '\format avg1
    else
        '<span foreground="red">¹%.2f</span> '\format avg1

    res ..= if avg5 < 3
        '<span foreground="cyan">⁵%.2f</span> '\format avg5
    elseif avg5 < 5
        '<span foreground="yellow">⁵%.2f</span> '\format avg5
    else
        '<span foreground="red">⁵%.2f</span> '\format avg5

    res ..= if avg15 < 3
        '<span foreground="cyan">¹⁵%.2f</span>'\format avg15
    elseif avg15 < 5
        '<span foreground="yellow">¹⁵%.2f</span>'\format avg15
    else
        '<span foreground="red">¹⁵%.2f</span>'\format avg15

    res ..= '</span>'

    @.markup = res


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'cat /proc/loadavg', 5, callback

    bg: '#00000000'
    widget: wibox.container.background
    buttons: {
        awful.button {}, 1, ->
            awful.spawn "#{terminal} -e btop"
                fullscreen: true
                urgent:     true
    }
}
