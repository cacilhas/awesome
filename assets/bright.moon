local *

awful = require"awful"
import geo, trim from require"helpers"


--------------------------------------------------------------------------------
(cmd, cb) ->
    awful.spawn.easy_async_with_shell "xgamma 2>&1", (text) ->
        return cb "🔆‼️%" unless text
        it = text\gmatch"[%d%.]+"
        bri = 0
        bri += tonumber it! for _ = 1, 3
        bri /= 3

        switch cmd
            when "dec"
                bri -= 0.1
                bri = .3 if bri < .3
                awful.spawn "xgamma -gamma #{bri}"

            when "inc"
                bri += 0.1
                bri = 1 if bri > 1
                awful.spawn "xgamma -gamma #{bri}"

        awful.spawn.with_line_callback "xrandr --verbose --current"
            stdout: (line) ->
                line = trim line
                if line\match"^Brightness:"
                    realbri = tonumber line\gmatch"[%d%.]+"!
                    cb "🔆#{math.floor .5 + (bri * realbri * 100)}%"
