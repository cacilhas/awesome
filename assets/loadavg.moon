local *

awful = require"awful"
import terminal from require"helpers"


--------------------------------------------------------------------------------
(cmd, cb) ->
    awful.spawn "#{terminal} -e btop" if cmd == "show"

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
            "<span foreground=\"blue\">¹#{avg1}</span> "
        elseif avg1 < 5
            "<span foreground=\"yellow\">¹#{avg1}</span> "
        else
            "<span foreground=\"red\">¹#{avg1}</span> "

        res ..= if avg5 < 3
            "<span foreground=\"blue\">⁵#{avg5}</span> "
        elseif avg5 < 5
            "<span foreground=\"yellow\">⁵#{avg5}</span> "
        else
            "<span foreground=\"red\">⁵#{avg5}</span> "

        res ..= if avg15 < 3
            "<span foreground=\"blue\">¹⁵#{avg15}</span>"
        elseif avg15 < 5
            "<span foreground=\"yellow\">¹⁵#{avg15}</span>"
        else
            "<span foreground=\"red\">¹⁵#{avg15}</span>"

        res ..= "</span>"

        cb res
