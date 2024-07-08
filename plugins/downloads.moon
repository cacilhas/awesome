local *

awful = require'awful'
wibox = require'wibox'
theme = require'beautiful'
import trim from require'helpers'

callback = (stdout) =>
    count = tonumber(trim stdout) or 0
    color = if count == 0 then theme.fg_normal else theme.fg_urgent
    @markup = "<span color=\"#{color}\">⇓ #{count}</span>"


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'sh -c "ls ~/Downloads/ | wc -l"', 2, callback

    bg: '#00000000'
    widget: wibox.container.background
    buttons: {
        awful.button {}, 1, ->
            awful.spawn 'prime-run nemo Downloads/'
                floating: true
                focus:    true
                sticky:   true
                placement: awful.placement.centered
    }
}
