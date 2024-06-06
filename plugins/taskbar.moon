local *

gears = require"gears"
awful = require"awful"
wibox = require"wibox"
theme = require"beautiful"


--------------------------------------------------------------------------------
=> awful.widget.tasklist
    screen:  @
    filter:  awful.widget.tasklist.filter.currenttags
    style:
        shape: gears.shape.rounded_rect
        align: 'center'
    layout:
        spacing: 2
        layout: wibox.layout.flex.horizontal
    buttons: {
        awful.button {}, 1, => @\activate context: 'tasklist', action: 'toggle_minimization'
        awful.button {}, 3, -> awful.menu.client_list theme: {width: 250}
        awful.button {}, 4, -> awful.client.focus.byidx -1
        awful.button {}, 5, -> awful.client.focus.byidx  1
    }
