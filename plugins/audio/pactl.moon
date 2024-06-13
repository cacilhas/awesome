local *

awful = require'awful'

playpop = 'play /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga'
setsourcem = 'pactl set-source-mute @DEFAULT_SOURCE@'
setsinkm   = 'pactl set-sink-mute @DEFAULT_SINK@'
setvolume  = 'pactl set-sink-volume @DEFAULT_SINK@'

{
    source:
        togglemute: ->
            awful.spawn.with_shell "#{setsourcem} toggle"

    sink:
        togglemute: ->
            awful.spawn.with_shell "#{setsinkm} toggle; #{playpop}"
            s = awful.screen.focused!
            s.audiotimer\emit_signal 'timeout' if s.audiotimer

        volume: (vol) ->
            awful.spawn.with_shell "#{setvolume} #{vol}; #{playpop}"
            s = awful.screen.focused!
            s.audiotimer\emit_signal 'timeout' if s.audiotimer
}
