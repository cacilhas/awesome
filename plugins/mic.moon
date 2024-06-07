local *

awful = require'awful'
wibox = require'wibox'
import wait from require'helpers'
import source from require'plugins.audio.pactl'

callback = (stdout) =>
    if stdout\match'Mute: no'
        @markup = '<span color="blue"></span>'
    else
        @markup = '<span color="red"> </span>'


--------------------------------------------------------------------------------
->
    watch, timer = awful.widget.watch 'pactl get-source-mute @DEFAULT_SOURCE@', 5, callback

    wibox.widget {
        watch

        bg: '#00000000'
        widget: wibox.container.background
        buttons: {
            awful.button {}, 1, ->
                source.togglemute!
                wait .25, -> timer\emit_signal 'timeout'
        }
    }
