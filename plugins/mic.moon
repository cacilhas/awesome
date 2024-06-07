local *

awful = require"awful"
wibox = require"wibox"
import source from require'plugins.audio.pactl'

callback = (stdout) =>
    if stdout\match"Mute: no"
        @markup = '<span color="blue"></span>'
    else
        @markup = '<span color="red"> </span>'


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'pactl get-source-mute @DEFAULT_SOURCE@', 5, callback

    bg: '#00000000'
    widget: wibox.container.background
    buttons: {
        awful.button {}, 1, -> source.togglemute!
    }
}
