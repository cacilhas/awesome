local *

awful = require"awful"


--------------------------------------------------------------------------------
(cmd, cb) ->
    switch cmd
        when "dec"
            command = [[xrandr --verbose --current | grep '^HDMI-1 ' -A5 | awk -F': ' '$1 ~ /Brightness/ { print $2; }']]
            awful.spawn.easy_async_with_shell command, (bri) ->
                bri = tonumber bri
                bri -= 0.1
                bri = 0.1 if bri < 0.1
                awful.spawn "xrandr --output HDMI-1 --brightness #{bri}"

        when "inc"
            command = [[xrandr --verbose --current | grep '^HDMI-1 ' -A5 | awk -F': ' '$1 ~ /Brightness/ { print $2; }']]
            awful.spawn.easy_async_with_shell command, (bri) ->
                bri = tonumber bri
                bri += 0.1
                bri = 1 if bri > 1
                awful.spawn "xrandr --output HDMI-1 --brightness #{bri}"


    xrandr = "xrandr --verbose --current | grep '^HDMI-1 ' -A5 | awk -F': ' '$1 ~ /Brightness/ { print $2; }'"
    awful.spawn.easy_async_with_shell xrandr, (bri) ->
        cb if bri then "🔆#{math.floor (100 * tonumber bri) + .5}%" else "🔆‼️%"
