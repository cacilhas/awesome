local *

awful   = require'awful'
naughty = require'naughty'
ruled   = require'ruled.notification'
import filesystem from require'gears'
import aplay, say from require'helpers'

--------------------------------------------------------------------------------
--- Notifications

naughty.config.icon_dirs = {
    "#{filesystem.get_xdg_data_home!}icons/hicolor"
    '/usr/share/pixmaps'
    '/usr/share/icons/hicolor'
}

naughty.connect_signal 'request::display_error', ->
    aplay 'oxygen/stereo/dialog-error-critical.ogg'

ruled.connect_signal 'request::rules', ->
    ruled.append_rule
        rule: {}
        properties:
            screen: awful.screen.preferred
            implicit_timeout: 5

    ruled.append_rule
        rule: urgency: 'critical'
        properties:
            bg: '#ff0000'
            fg: '#ffffff'
            timeout: 0

naughty.connect_signal 'request::display', =>
    pcall ->
        message = if @title and #@title > 0 then @title else @message
        say message, @urgency == 'critical'
    naughty.layout.box notification: @
