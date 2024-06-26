local *

awful = require'awful'
import aplay from require'helpers'

pop = 'freedesktop/stereo/audio-volume-change.oga'
setsourcem = 'pactl set-source-mute @DEFAULT_SOURCE@'
setsinkm   = 'pactl set-sink-mute @DEFAULT_SINK@'
setvolume  = 'pactl set-sink-volume @DEFAULT_SINK@'

{
    source:
        togglemute: ->
            awful.spawn.with_shell "#{setsourcem} toggle"

    sink:
        togglemute: ->
            awful.spawn.easy_async_with_shell "#{setsinkm} toggle", ->
                aplay pop
                _G.audiotimer\emit_signal 'timeout' if _G.audiotimer

        volume: (vol) ->
            awful.spawn.easy_async_with_shell "#{setvolume} #{vol}", ->
                aplay pop
                _G.audiotimer\emit_signal 'timeout' if _G.audiotimer
}
