local *

awful = require'awful'
wibox = require'wibox'
import trim, wait from require'helpers'

readbri = =>
    it = @gmatch'[%d%.]+'
    bri = 0
    bri += tonumber it! for _ = 1, 3
    bri / 3

setbright = =>
    awful.spawn.easy_async_with_shell 'xgamma 2>&1', (text) ->
        return unless text and #text > 0
        bri = readbri text

        switch @
            when 'dec'
                bri -= 0.1
                bri = .3 if bri < .3
                awful.spawn "xgamma -gamma #{bri}"

            when 'inc'
                bri += 0.1
                bri = 1 if bri > 1
                awful.spawn "xgamma -gamma #{bri}"

callback = (stdout) =>
    unless stdout and #stdout > 0
        @.text = '🔆‼️%'
        return
    bri = readbri stdout

    awful.spawn.with_line_callback 'xrandr --verbose --current'
        stdout: (line) ->
            line = trim line
            if line\match'^Brightness:'
                realbri = tonumber line\gmatch'[%d%.]+'!
                @.text = "🔆#{math.floor .5 + (bri * realbri * 100)}%"
        stderr: -> @.text = '🔆‼️%'


--------------------------------------------------------------------------------
->
    watch, timer = awful.widget.watch 'sh -c "xgamma 2>&1"', 5, callback

    wibox.widget {
        watch

        bg: '#00000000'
        widget: wibox.container.background
        buttons: {
            awful.button {}, 4, ->
                setbright 'dec'
                wait .25, -> timer\emit_signal 'timeout'
            awful.button {}, 5, ->
                setbright 'inc'
                wait .25, -> timer\emit_signal 'timeout'
        }
    }
