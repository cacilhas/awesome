local *

awful = require"awful"
naughty = require"naughty"
import showpopup from require"helpers"
import link from require"assets.resources"

erroricon = "/usr/share/icons/breeze/status/24@3x/state-error.svg"


--------------------------------------------------------------------------------
(cmd, cb) ->
    if cmd == "show"
        awful.spawn.easy_async_with_shell "ip link show dev #{link.dev}", (text) ->
            showpopup(text).visible = true

    awful.spawn.with_line_callback "timeout 2 nc -zv one.one.one.one 80"
        exit: (reason, code) ->
            if reason == "exit"
                if code == 0
                    cb "🌐"
                else
                    cb "⛔"
                    awful.spawn.swith_line_callback "nordvpn status"
                        stdout: (text) ->
                            awful.spawn "sudo nordvpn disconnect" if text == "Status: Connected"
            else
                cb "‼️"
                naughty.notify
                    title: "Netcat Error"
                    text: "Netcat killed with signal #{code}"
                    timeout: 5
                    error: erroricon
