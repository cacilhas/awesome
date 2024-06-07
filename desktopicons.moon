local *

awful = require'awful'
wibox = require'wibox'


-- TODO: allow other clients to overlay the desktop
screen.connect_signal 'request::desktop_decoration', =>
    @icons = awful.wibar
        window: 'desktop'
        type:   'desktop'
        ontop:  false
        width: 1920, height: 1080
        input_passthrough: true
        x: 0, y: 0
        opacity:  1, bg: '#00000000'
        screen:   @

        widget: {
            layout: wibox.layout.manual
            wibox.widget
                markup: '<span color="green" size="xx-large">Test</span>'
                align: 'center'
                valign: 'center'
                point:
                    x: 640, y: 240
                widget: wibox.widget.textbox
        }
