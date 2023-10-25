local *

awful = require"awful"
import geo from require"helpers"


--------------------------------------------------------------------------------
(cmd, cb) ->
    xrandr = "xrandr --verbose --current | grep '^HDMI-1 ' -A5 | awk -F': ' '$1 ~ /Brightness/ { print $2; }'"
    awful.spawn.easy_async_with_shell xrandr, (bri) ->
        return cb "🔆‼️%" unless bri

        switch cmd
            when "dec"
                bri = math.floor 10 * tonumber bri
                bri -= 1
                bri = 3 if bri < 3
                awful.spawn "xrandr --output HDMI-1 --brightness #{bri/10}"
                bri *= 10

            when "inc"
                bri = math.floor 10 * tonumber bri
                bri += 1
                bri = 10 if bri > 10
                awful.spawn "xrandr --output HDMI-1 --brightness #{bri/10}"
                bri *= 10

            when '*'
                bri = math.floor 100 * tonumber(bri) + .5

        cb "🔆#{bri}%"
