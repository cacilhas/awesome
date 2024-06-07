local *

awful = require'awful'
wibox = require'wibox'
import link, showpopup from require'helpers'

callback = =>
    awful.spawn.easy_async_with_shell "ip addr show dev #{link.dev}", (stdout, _, _, exitcode) ->
        if exitcode == 0
            for line in stdout\gmatch'[^\n]+'
                data = [e for e in line\gsub('^%s+', '')\gmatch'[^%s]+']
                if data[1] == 'inet'
                    @markup = "<span color=\"green\">#{link.dev} [#{data[2]}]</span>"
                    return

        @markup = "<span color=\"red\">#{link.dev} down</span>" unless res.st


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'true', 10, callback

    bg: '#00000000'
    widget: wibox.container.background
    buttons: {
        awful.button {}, 1, ->
            awful.spawn.easy_async_with_shell "ip addr show dev #{link.dev}", =>
                showpopup(@).visible = true
        awful.button {}, 3, ->
            awful.spawn.with_shell "systemctl restart dhclient@#{link.dev}"
    }
}
