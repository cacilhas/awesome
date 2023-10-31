local *

awful   = require"awful"
naughty = require"naughty"
ruled   = require"ruled"
import filesystem from require"gears"

--------------------------------------------------------------------------------
--- Notifications

naughty.config.icon_dirs = {
    "#{filesystem.get_xdg_data_home!}icons/hicolor"
    "/usr/share/pixmaps"
    "/usr/share/icons/hicolor"
}

ruled.notification.connect_signal "request::rules", ->
    -- All notifications will match this rule.
    ruled.notification.append_rule
        rule: {}
        properties:
            screen: awful.screen.preferred
            implicit_timeout: 5

naughty.connect_signal "request::display", =>
    naughty.layout.box notification: @
