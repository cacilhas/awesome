local *

awful = require'awful'
wibox = require'wibox'
naughty = require'naughty'
import link, showpopup from require'helpers'

callback = (stdout, _, reason, exitcode) =>
    if reason == 'exit'
        @text = if exitcode == 0 then '🌐' else '⛔'
    else
        @text = '‼️'
        naughty.notify
            title: 'Netcat Error'
            text: "Netcat killed with signal #{exitcode}\n#{reason}"
            timeout: 5
            -- icon: erroricon


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'http head --fail https://one.one.one.one/', 10, callback

    bg: '#00000000'
    widget: wibox.container.background
    buttons: {
        awful.button {}, 1, ->
            awful.spawn.easy_async_with_shell 'ip route', => showpopup"Route:\n#{@}".visible = true
    }
}
