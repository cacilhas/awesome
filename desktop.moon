local *

awful = require'awful'
wibox = require'wibox'
gears = require'gears'
theme = assert require'beautiful'
import filesystem from require'gears'
import wrap from require'helpers'

icons = "#{filesystem.get_xdg_config_home!}/desktop"


updateicons = ->
    widgets = layout: wibox.layout.manual
    status, list = pcall io.popen, "ls #{icons}/*.ini"
    return widgets unless status
    -- TODO: add icons from list
    list\close!
    widgets[#widgets+1] = wibox.widget {

        wibox.widget
            image: '/home/cacilhas/.local/share/icons/hicolor/64x64/apps/blender.png'
            resize: true
            forced_width: 48
            forced_height: 48
            widget: wibox.widget.imagebox

        wrap(
            wibox.widget
                markup: "<span color=\"#{theme.fg_icon}\">Blender</span>"
                bg: "gray"
                widget: wibox.widget.textbox
            bg: theme.bg_icon
        )

        align: 'center'
        layout: wibox.layout.align.vertical
        point:
            x: 640, y: 240
        buttons: {
            awful.button {}, 1, -> awful.spawn 'blender'
        }
    }

    widgets


screen.connect_signal 'request::desktop_decoration', =>
    @icons = awful.wibar
        window: 'desktop'
        type:   'desktop'
        ontop:  false
        width: 84, height: 84
        x: 640, y: 640
        opacity:  1, bg: '#00000000'
        screen:   @
        struts: ->
            top: 0, bottom: 0
            left: 0, right: 0

    unless @iconstimer
        @iconstimer = gears.timer
            timeout: 10
            call_now: true
            autostart: true
            callback: -> @icons.widget = updateicons!
