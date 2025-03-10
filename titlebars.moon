local *

awful = require'awful'
wibox = require'wibox'


--------------------------------------------------------------------------------
--- Titlebars
client.connect_signal 'request::titlebars', =>
    if @maximized or @fullscreen
        @titlebars_enabled = false
        awful.titlebar(@).enabled = false

    else
        @titlebars_enabled = true
        awful.titlebar(@).enabled = true

        -- buttons for the titlebar
        buttons = {
            awful.button {}, 1, -> @\activate context: 'titlebar', action: 'mouse_move'
            awful.button {}, 3, -> @\activate context: 'titlebar', action: 'mouse_resize'
        }

        awful.titlebar(@).widget = {
            {
                awful.titlebar.widget.closebutton @
                awful.titlebar.widget.minimizebutton @
                awful.titlebar.widget.maximizedbutton @
                layout: wibox.layout.fixed.horizontal
            }
            {
                {
                    halign: 'center'
                    widget: awful.titlebar.widget.titlewidget @
                }
                :buttons
                layout: wibox.layout.flex.horizontal
            }
            {
                awful.titlebar.widget.stickybutton @
                awful.titlebar.widget.iconwidget @
                :buttons
                layout: wibox.layout.fixed.horizontal
            }
            layout: wibox.layout.align.horizontal
        }
