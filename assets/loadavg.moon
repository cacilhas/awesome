local *

awful = require"awful"
import terminal from require"helpers"


--------------------------------------------------------------------------------
(cmd, cb) ->
    if cmd == "show"
        awful.spawn "#{terminal} -e btop"
            fullscreen: true
            urgent:     true

    awful.spawn.easy_async_with_shell "cat /proc/loadavg", =>
        it = @\gmatch"[%d%.]+"
        avg1  = tonumber it!
        avg5  = tonumber it!
        avg15 = tonumber it!

        res = '<span face="Fira Code" size="x-small">'
        res ..= if math.max(avg1, math.max(avg5, avg15)) >= 5
            '<span foreground="red"> </span>'
        else
            '<span foreground="gray"> </span>'

        res ..= if avg1 < 3
            "<span foreground=\"cyan\">¹%.2f</span> "\format avg1
        elseif avg1 < 5
            "<span foreground=\"yellow\">¹%.2f</span> "\format avg1
        else
            "<span foreground=\"red\">¹%.2f</span> "\format avg1

        res ..= if avg5 < 3
            "<span foreground=\"cyan\">⁵%.2f</span> "\format avg5
        elseif avg5 < 5
            "<span foreground=\"yellow\">⁵%.2f</span> "\format avg5
        else
            "<span foreground=\"red\">⁵%.2f</span> "\format avg5

        res ..= if avg15 < 3
            "<span foreground=\"cyan\">¹⁵%.2f</span>"\format avg15
        elseif avg15 < 5
            "<span foreground=\"yellow\">¹⁵%.2f</span>"\format avg15
        else
            "<span foreground=\"red\">¹⁵%.2f</span>"\format avg15

        res ..= "</span>"

        cb res
