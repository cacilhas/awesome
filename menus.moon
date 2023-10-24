local *

menubar = require"menubar"
awful   = require"awful"
theme   = require"beautiful"
wibox   = require"wibox"
import apply_dpi from require"beautiful.xresources"
import reload, reloadscripts, terminal, wezterm from require"helpers"


--------------------------------------------------------------------------------
-- Menu
mainmenu = awful.menu
    items: {
        {
            "System"
            {
                {"Halt", "sudo halt -p"}
                {"Reboot", "sudo reboot"}
            }
            theme.system_logo
        }
        {
            "Awesome"
            {
                {"Manual", "www-browser https://awesomewm.org/doc/api/"}
                {"Terminal", wezterm}
                {widget: wibox.widget.separator}
                {"Reload Awesome", reload}
                {"Exit", -> awesome.quit!}
            }
            theme.awesome_icon
        }
        {
            "X11"
            {
                -- {"Xev", "#{terminal} -e xev"}
                {"XKill", "xkill"}
            }
            theme.xorg_icon
        }
        {widget: wibox.widget.separator}
        {"Reload Scripts", reloadscripts, theme.recycle}
    }
    hide_on_unfocus: 5

mainlauncher = awful.widget.launcher
    image: theme.awesome_icon
    menu:  mainmenu

menubar.utils.terminal = terminal -- Set the terminal for applications that require it

desktopmenu = awful.menu
    theme:
        width: apply_dpi 300
    items: {
        {"Desktop", (->), theme.awesome_icon, widget: wibox.widget.textbox}
        {"Change current wallpaper", -> awful.screen.focused!\emit_signal "request::wallpaper"}
        {"Change all wallpapers",    -> awesome.emit_signal "request::wallpaper"}
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
awesome.connect_signal "request::wallpaper", ->
    s\emit_signal"request::wallpaper" for s in screen

{:mainmenu, :desktopmenu, :mainlauncher}
