local *

awful = require"awful"


--------------------------------------------------------------------------------
playpop = "play /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"
setvol = "pactl set-sink-volume"


--------------------------------------------------------------------------------
(cmd, cb) ->
    switch cmd
        when "mute"
            awful.spawn.with_shell "pactl set-sink-mute @DEFAULT_SINK@ toggle; #{playpop}"

        when "full"
            awful.spawn.with_shell "#{setvol} @DEFAULT_SINK@ 100%; #{playpop}"

        when "dec"
            awful.spawn.with_shell "#{setvol} @DEFAULT_SINK@ -10%; #{playpop}"

        when "inc"
            awful.spawn.with_shell "#{setvol} @DEFAULT_SINK@ +10%; #{playpop}"

    awful.spawn.easy_async_with_shell "pulsemixer --get-volume", =>
        it = @\gmatch"%d+"
        left = it!
        right = it! or left
        left = tonumber left
        right = tonumber right
        vol = (left + right) / 2
        vol = math.floor vol + .5

        if vol == 0
            cb '<span color="#444400">   0%</span>'

        elseif vol >= 100
            cb '<span color="#4444ff"> %3d</span>'\format(vol)

        else
            color = math.floor vol * 256 / 100
            cb '<span color="#4444%02x"> %3d</span>'\format(color, vol)
