local *

menubar = require"menubar"
awful   = require"awful"
theme   = require"beautiful"
wibox   = require"wibox"
import reload, terminal, wezterm from require"helpers"


--------------------------------------------------------------------------------
-- Menu
mainmenu = awful.menu
    items: {
        {
            "Awesome"
            {
                {"Manual", "#mterminal} -e 'man awesome'"}
                {"Terminal", wezterm}
            }
            theme.awesome_icon
        }
        {widget: wibox.widget.separator}
        {"Halt", -> os.execute"sudo halt -p"}
        {"Reboot", -> os.execute"sudo reboot"}
        {widget: wibox.widget.separator}
        {"Reload", reload}
        {"Exit", -> awesome.quit!}
    }
    hide_on_unfocus: 5

mainlauncher = awful.widget.launcher
    image: theme.awesome_icon
    menu:  mainmenu

menubar.utils.terminal = terminal -- Set the terminal for applications that require it

desktopmenu = awful.menu
    items: {
        {"Desktop", (->), theme.awesome_icon, widget: wibox.widget.textbox}
        {"Change wallpaper", -> awful.screen.focused!\emit_signal "request::wallpaper"}
        {
            "Layout"
            with awful.layout
                return {
                    {"Floating",   -> .set .suit.floating}
                    {"Tile",       -> .set .suit.fair}
                    {"Maximise",   -> .set .suit.max}
                    {"Fullscreen", -> .set .suit.max.fullscreen}
                }
        }
        {"Reload", reload}
    }

mainmenu\connect_signal    "mouse::leave", => @\hide!
desktopmenu\connect_signal "mouse::leave", => @\hide!

{:mainmenu, :desktopmenu, :mainlauncher}
