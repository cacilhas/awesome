local *

awful = require'awful'
wibox = require 'wibox'
menus = require'menus'

screen.connect_signal 'request::desktop_decoration', =>
    @icon = awful.wibar
        type:     'desktop'
        ontop:    false

        x: @geometry.x
        y: @geometry.y
        width:  @geometry.width
        height: @geometry.height
        screen: @
        struts: -> top: 0, bottom: 0, left: 0, right: 0
        bg: '#00000000'

        buttons: {
            awful.button {}, 2, -> menus.mainmenu\toggle!
            awful.button {}, 3, -> menus.desktopmenu\toggle!
            awful.button {}, 4, -> awful.tag.viewprev!
            awful.button {}, 5, -> awful.tag.viewnext!
        }

        widget: {
            layout: wibox.layout.manual

            -- Widget sampl
            wibox.widget
                image: '/home/cacilhas/.local/share/icons/hicolor/64x64/apps/blender.png'
                resize: true
                widget: wibox.widget.imagebox

                point:
                    x: 640
                    y: 640
                forced_width:  48
                forced_height: 48
        }
