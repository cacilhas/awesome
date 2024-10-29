local *

gears = require'gears'
awful = require'awful'
wibox = require'wibox'


--------------------------------------------------------------------------------
=> awful.widget.tasklist
    screen: @
    filter: awful.widget.tasklist.filter.focused
    style:
        shape: gears.shape.rounded_rect
        align: 'center'
        bg_normal: '#00000000'
        bg_focus: '#00000000'
        bg_minimize: '#00000000'
        fg_normal: 'gray'
        fg_focus: 'gray'
        fg_minimize: 'gray'
    layout:
        spacing: 2
        layout: wibox.layout.flex.horizontal
