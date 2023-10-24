local *

awful = require"awful"
import showpopup from require"helpers"
import link from require"assets.resources"


--------------------------------------------------------------------------------
(cmd, cb) ->
    link.init! if link.dev == "lo"

    switch cmd
        when "show"
            awful.spawn.easy_async_with_shell "ip addr show dev #{link.dev}", =>
                showpopup(@).visible = true

        when "reset"
            awful.spawn "systemctl restart dhclient@#{link.dev}"

    res = st: false
    awful.spawn.with_line_callback "ip addr show dev #{link.dev}"
        stdout: (line) ->
            unless res.st  -- stick with the first valid result
                data = [e for e in line\gsub("^%s+", "")\gmatch"[^%s]+"]
                if data[1] == "inet"
                    cb "<span color=\"green\">#{link.dev} [#{data[2]}]</span>"
                    res.st = true
        exit: ->
            cb "<span color=\"red\">#{link.dev} down</span>" unless res.st
