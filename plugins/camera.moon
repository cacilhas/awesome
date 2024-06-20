local *

awful = require'awful'
wibox = require'wibox'
import trim from require'helpers'

callback = (stdout) =>
    stdout = if stdout then trim stdout else ''
    @markup = if #stdout == 0
        '<span foreground="red"></span>'
    elseif stdout == '0'
        '<span>📷</span>'
    else
        '<span>📸</span>'


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch "sh -c \"lsmod | sed -E 's/  */ /' | awk '\\$1 ~ /^uvcvideo\\$/ { print \\$3; }'\"", 0.5, callback

    bg: '#00000000'
    widget: wibox.container.background
}
