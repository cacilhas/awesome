local *

gears = require'gears'
awful = require'awful'
wibox = require'wibox'
theme = require'beautiful'


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
        fg_normal: theme.fg_normal
        fg_focus: theme.fg_normal
        fg_minimize: theme.fg_normal
    layout:
        spacing: 2
        layout: wibox.layout.flex.horizontal
