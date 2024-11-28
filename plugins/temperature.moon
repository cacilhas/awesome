awful = require'awful'
wibox = require'wibox'
import showpopup from require'helpers'


callback = (stdout) =>
    value = stdout\gmatch'Package id 0: *([^ \nC]+C).*'!
    num = tonumber value\sub 1, -4
    color = if num and num >= 60 then ' color="#ff0000"' else ''
    @markup = "<span size=\"x-small\"#{color}>#{value}</span>" if value


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'sensors', 15, callback

    bg: '#00000000'
    widget: wibox.container.background
    buttons: {
        awful.button {}, 1, ->
            awful.spawn.easy_async_with_shell 'sensors', =>
                showpopup(@).visible = true
    }
}
