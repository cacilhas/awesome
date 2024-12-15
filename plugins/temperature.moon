local *

awful = require'awful'
naughty = require'naughty'
theme = require'beautiful'
wibox = require'wibox'
import showpopup from require'helpers'
import terminal from require'menubar.utils'


local last_id

callback = (stdout) => pcall ->
    value = stdout\gmatch'Package id 0: *([^ \nC]+C).*'!
    num = tonumber value\sub 1, -4

    if num

        if num >= 82
            if last_id
                last_id = nil unless naughty.getById last_id

            urgency = if num >= 100 then 'critical' else 'normal'

            notif = naughty.notify
                :urgency
                title: 'Temperature too high'
                message: "CPU temperature is #{value}!"
                replaces_id: last_id
                ignore_suspend: true

            last_id = notif\get_id! if notif

        color = if num >= 100
            " color=\"##{theme.severe}\""

        elseif num >= 82
            " color=\"##{theme.warn}\""

        elseif num >= 60
            ' color="green"'

        else
            ''

        @markup = "<span size=\"x-small\"#{color}>#{value}</span>"


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'sensors', 10, callback

    bg: '#00000000'
    widget: wibox.container.background
    buttons: {
        awful.button {}, 1, ->
            awful.spawn.easy_async_with_shell 'sensors', =>
                showpopup(@).visible = true

        awful.button {}, 3, ->
            awful.spawn.raise_or_spawn "#{terminal} -e 'htop -s PERCENT_CPU'"
                fullscreen: true
                urgent:     true
    }
}
