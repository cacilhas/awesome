local *

awful = require"awful"
import showpopup, trim from require"helpers"


--------------------------------------------------------------------------------
(cmd, cb) ->
    switch cmd
        when "status"
            buf = ""
            awful.spawn.with_line_callback "nordvpn status"
                stdout: => buf ..= "#{@\gsub "^.*\13", ""}\n" if @\match"%w"
                exit:   -> showpopup(buf).visible = true

        when "disconnect"
            awful.spawn "sudo nordvpn disconnect"

        when "br"
            awful.spawn "sudo nordvpn connect br"

        when "us"
            awful.spawn "sudo nordvpn connect us"

    awful.spawn.easy_async_with_shell "nordvpn status | awk -F': ' '$1 ~ /Country/ { print $2; }'", (vpn) ->
        if vpn or #vpn > 0
            cb "<span color=\"green\">#{trim vpn}</span>"
        else
            cb '<span color="red">disconnected</span>'
