local *

awful = require'awful'
naughty = require'naughty'
theme = require'beautiful'
wibox = require'wibox'
import showpopup from require'helpers'


local last_id

callback = (stdout) =>
    value = stdout\gmatch'Package id 0: *([^ \nC]+C).*'!
    num = tonumber value\sub 1, -4

    if num and num >= 82
        if last_id
            last_id = nil unless naughty.getById last_id

        notif = naughty.notify
            urgency: 'critical'
            title: 'Temperature too high'
            message: "CPU temperature is #{value}!"
            timeout: 8
            replaces_id: last_id

        last_id = notif\get_id! if notif

    color = if not num
        ''

    elseif num >= 82
        r, g, b = theme.severe\match '#(..)(..)(..)'
        if g == '00'
            g = 128 - ((num - 82) * 64 / 9)
            g = math.min 255, math.max(0, g)
            g = '%02x'\format g
            " color=\"##{r}#{g}#{b}\""
        else
            " color=\"##{theme.severe}\""

    elseif num >= 60
        " color=\"#{theme.warn}\""

    else
        ''

    @markup = "<span size=\"x-small\"#{color}>#{value}</span>" if value


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'sensors', 10, callback

    bg: '#00000000'
    widget: wibox.container.background
    buttons: {
        awful.button {}, 1, ->
            awful.spawn.easy_async_with_shell 'sensors', =>
                showpopup(@).visible = true
    }
}
