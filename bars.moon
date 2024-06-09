local *

gears = require'gears'
awful = require'awful'
wibox = require'wibox'
theme = require'beautiful'
plugins = require'plugins'

import withmargin, wrap from require'helpers'
import mainlauncher from require'menus'


--------------------------------------------------------------------------------
--- Wibar

-- Keyboard map indicator and switcher
--keyboardlayout = awful.widget.keyboardlayout!

screen.connect_signal 'request::desktop_decoration', =>
    awful.tag {
        ' '
        ' '
        ' '
        ' '
        ' '
        ' ' -- 
        ' '
        ' '
        ' '
    }, @, awful.layout.suit.fair

    awful.tag.find_by_name(s, ' ').layout = awful.layout.suit.max
    awful.tag.find_by_name(s, ' ').layout = awful.layout.suit.max.fullscreen
    awful.tag.find_by_name(s, ' ').layout = awful.layout.suit.max
    awful.tag.find_by_name(s, ' ').layout = awful.layout.suit.max.fullscreen


    ----------------------------------------------------------------------------
    -- Top bar

    sep = {
        text:   ' '
        font:   'monospace 12'
        widget: wibox.widget.textbox
    }

    @prompt = awful.widget.prompt!
    @topbar = awful.wibar
        position: 'top'
        opacity:  0.8
        screen:   @
        widget:   {
            layout: wibox.layout.align.horizontal
            {
                layout: wibox.layout.fixed.horizontal
                plugins.taglist @
                @prompt
            }
            wibox.widget
                color: theme.bg_normal
                widget: wibox.widget.separator
            {
                layout: wibox.layout.fixed.horizontal
                plugins.archlogo!
                wrap plugins.hostname!
                wrap plugins.speak!
                wrap plugins.audio!
                wrap plugins.mic!
                wrap plugins.connectivity!
                wrap plugins.ethernet!
                sep
                wibox.widget.systray!
                awful.widget.layoutbox {
                    screen:  @
                    buttons: {
                        awful.button {}, 1, -> awful.layout.inc  1
                        awful.button {}, 3, -> awful.layout.inc -1
                        awful.button {}, 4, -> awful.layout.inc -1
                        awful.button {}, 5, -> awful.layout.inc  1
                    }
                }
            }
        }


    ----------------------------------------------------------------------------
    -- Bottom bar

    bb_height = 64
    bb_y = 1080 - bb_height

    @bottombar = awful.wibar
        position: 'bottom'
        opacity:  1
        width:    1920 * 0.75
        height:   bb_height
        x:        768
        y:        bb_y
        ontop:    true
        shape: gears.shape.rounded_rect
        screen:   @
        widget:   {
            layout: wibox.layout.align.horizontal
            {
                layout: wibox.layout.fixed.horizontal
                withmargin mainlauncher, left: 8, right: 8
            }
            withmargin plugins.taskbar(@), left: 4, top: 8, bottom: 8
            {
                layout: wibox.layout.fixed.horizontal
                wrap plugins.bright!, margin: 8
                wrap plugins.loadavg!, margin: 8
                wrap plugins.utc!, margin: 8
                wrap plugins.clock!, margin: 8
                plugins.bt_quit!
            }
        }


    -----------------------
    -- Bottom bar update --

    @bottombar\connect_signal 'mouse::enter', () ->
        @bottombar.y = bb_y

    @bottombar\connect_signal 'mouse::leave', () ->
        @bottombar.y = 1078

    @bottombar\connect_signal 'property::visible', () ->
        if @bottombar.visible
            @bottombar.y = bb_y
