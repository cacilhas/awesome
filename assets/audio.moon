local *

awful = require"awful"
gears = require"gears"


--------------------------------------------------------------------------------
playpop = "play /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"
setvol = "pactl set-sink-volume"


realprocess = (cb) ->
    awful.spawn.easy_async_with_shell "pulsemixer --get-mute", =>
        mute = 1 == tonumber @
        awful.spawn.easy_async_with_shell "pulsemixer --get-volume", =>
            it = @\gmatch"%d+"
            left = it! or 0
            right = it! or left
            left = tonumber left
            right = tonumber right
            vol = (left + right) / 2
            vol = math.floor vol + .5

            if  mute
                cb '<span color="red"> %3d%%</span>'\format(vol)

            elseif vol == 0
                cb '<span color="#444400">   0%</span>'

            elseif vol == 100
                cb '<span color="#44ffff"> %3d%%</span>'\format(vol)

            elseif vol > 100
                cb '<span color="#ffff22"> %3d%%</span>'\format(vol)

            elseif vol >= 80
                color = math.floor vol * 256 / 100
                cb '<span color="#4444%02x"> %3d%%</span>'\format(color, vol)

            else
                color = math.floor vol * 256 / 100
                cb '<span color="#4444%02x"> %3d%%</span>'\format(color, vol)


--------------------------------------------------------------------------------
(cmd, cb) ->
    changed = false
    switch cmd
        when "mute"
            awful.spawn.with_shell "pactl set-sink-mute @DEFAULT_SINK@ toggle; #{playpop}"
            changed = true

        when "full"
            awful.spawn.with_shell "#{setvol} @DEFAULT_SINK@ 100%; #{playpop}"
            changed = true

        when "dec"
            awful.spawn.with_shell "#{setvol} @DEFAULT_SINK@ -10%; #{playpop}"
            changed = true

        when "inc"
            awful.spawn.with_shell "#{setvol} @DEFAULT_SINK@ +10%; #{playpop}"
            changed = true

    if changed
        -- Wait for pactl changes to take effect
        gears.timer
            timer: 0.25
            single_shot: true
            callback: -> realprocess cb
    else
        realprocess cb
