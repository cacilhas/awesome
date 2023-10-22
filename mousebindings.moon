local *

awful = require"awful"
import mainmenu, desktopmenu from require"menus"


--------------------------------------------------------------------------------
--- Mouse bindings
awful.mouse.append_global_mousebindings {
    awful.button {}, 2, -> mainmenu\toggle!
    awful.button {}, 3, -> desktopmenu\toggle!
    awful.button {}, 4, awful.tag.viewprev
    awful.button {}, 5, awful.tag.viewnext
}

client.connect_signal "request::default_mousebindings", ->
    awful.mouse.append_client_mousebindings {
        awful.button {},       1, => @activate context: "mouse_click"
        awful.button {"Mod4"}, 1, => @activate context: "mouse_click", action: "mouse_move"
        awful.button {"Mod4"}, 3, => @activate context: "mouse_click", action: "mouse_resize"
    }


--------------------------------------------------------------------------------
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal "mouse::enter", =>
    @\activate context: "mouse_enter", raise: false
