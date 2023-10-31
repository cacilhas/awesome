local *

awful   = require"awful"
naughty = require"naughty"
ruled   = require"ruled"
say     = require"assets.say"
import filesystem from require"gears"

--------------------------------------------------------------------------------
--- Notifications

naughty.config.icon_dirs = {
    "#{filesystem.get_xdg_data_home!}icons/hicolor"
    "/usr/share/pixmaps"
    "/usr/share/icons/hicolor"
}

ruled.notification.connect_signal "request::rules", ->
    ruled.notification.append_rule
        rule: {}
        properties:
            screen: awful.screen.preferred
            implicit_timeout: 5

    ruled.notification.append_rule
        rule: urgency: "critical"
        properties:
            bg: "#ff0000"
            fg: "#ffffff"
            timeout: 0

naughty.connect_signal "request::display", =>
    pcall -> say @message, @urgency == "critical"
    naughty.layout.box notification: @
