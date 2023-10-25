local *

awful = require"awful"
import trim from require"helpers"


--------------------------------------------------------------------------------
(cmd, cb) ->
    if cmd
        awful.spawn "prime-run #{cmd} Desktop"
            floating: true
            focus:    true
            sticky:   true
            placement: awful.placement.centered

    awful.spawn.easy_async_with_shell "hostname", (host) ->
        if host
            cb "<span color=\"#0044ff\">#{os.getenv"USER"}@#{trim host}</span>"
        else
            awful.spawn.easy_async_with_shell "cat /etc/hostname", (host) ->
                cb if host
                    "<span color=\"#0044ff\">#{os.getenv"USER"}@#{trim host}</span>"
                else
                    '<span color="red">_@_</span>'
