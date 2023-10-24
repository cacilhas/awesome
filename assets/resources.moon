local *

awful = require"awful"


--------------------------------------------------------------------------------
link =
    dev: "lo"

link.init = ->
    awful.spawn.easy_async_with_shell "ip addr", (res) ->
        for line in res\gmatch"[^\n]+"
            data = [e for e in line\gsub("^%s+", "")\gmatch"[^%s]+"]
            if data[1] == "inet" and data[6] == "global"
                link.dev = data[7]
                return


--------------------------------------------------------------------------------
{
    :link
}
