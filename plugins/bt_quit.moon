local *

awful = require'awful'
wibox = require'wibox'
import reload from require'helpers'


--------------------------------------------------------------------------------
-> wibox.widget {
    wibox.widget
        markup: '<span color="red">⏻ </span>'
        font:   'Bellota 32'
        align:  'center'
        valign: 'center'
        widget: wibox.widget.textbox

    left:  12
    widget: wibox.container.margin
    buttons: {
        awful.button {}, 1, awesome.quit,
        awful.button {}, 3, reload,
    }
}
