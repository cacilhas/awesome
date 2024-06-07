local *

awful = require'awful'
wibox = require'wibox'
gears = require'gears'
import trim from require'helpers'
import sink from require'plugins.audio.pactl'

callback = (stdout) =>
    return unless stdout and #stdout > 0
    info = {}

    fp = stdout\gmatch'[^\n]+'
    info.mute = 1 == tonumber fp!

    it = fp!\gmatch'%d+'
    left = it! or 0
    right = it! or left
    left = tonumber left
    right = tonumber right
    info.vol = math.floor ((left + right) / 2) + .5

    if info.mute
        @markup = '<span color="red"> %3d%%</span>'\format(info.vol)

    elseif info.vol == 0
        @markup = '<span color="#444400">   0%</span>'

    elseif info.vol == 100
        @markup = '<span color="#44ffff"> %3d%%</span>'\format(info.vol)

    elseif info.vol > 100
        @markup = '<span color="#ffff22"> %3d%%</span>'\format(info.vol)

    elseif info.vol >= 80
        color = math.floor info.vol * 256 / 100
        @markup = '<span color="#4444%02x"> %3d%%</span>'\format(color, info.vol)

    else
        color = math.floor info.vol * 256 / 100
        @markup = '<span color="#4444%02x"> %3d%%</span>'\format(color, info.vol)


--------------------------------------------------------------------------------
->
    watch, timer = awful.widget.watch 'sh -c "pulsemixer --get-mute; pulsemixer --get-volume"', 3, callback

    wibox.widget {
        watch

        bg: '#00000000'
        widget: wibox.container.background
        buttons: {
            awful.button {}, 1, sink.togglemute
            awful.button {}, 2, -> awful.spawn 'pavucontrol'
            awful.button {}, 4, ->
                sink.volume '-10%'
                timer\emit_signal 'timeout'
            awful.button {}, 5, ->
                sink.volume '+10%'
                timer\emit_signal 'timeout'
        }
    }
