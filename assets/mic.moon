local *

awful = require"awful"


--------------------------------------------------------------------------------
(cmd, cb) ->
    awful.spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle" if cmd == "mute"

    awful.spawn.easy_async_with_shell "pactl get-source-mute @DEFAULT_SOURCE@", =>
        if @\match"Mute: no"
            cb '<span color="blue"></span>'
        else
            cb '<span color="red"></span>'
