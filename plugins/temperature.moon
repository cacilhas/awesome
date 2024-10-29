awful = require'awful'
wibox = require'wibox'
import showpopup from require'helpers'


callback = (stdout) =>
    value = stdout\gmatch'temp1: *([^ \n]+)'!
    @markup = "<span size=\"x-small\">#{value}</span>" if value


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
