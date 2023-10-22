local *

gears   = require"gears"
awful   = require"awful"
naughty = require"naughty"
wibox   = require"wibox"

trim = =>
    res = @\gsub "^%s+", ""
    res = res\gsub "%s+$", ""
    res

shell = (t={}) =>
    with io.popen @
        res = ""
        if t.noempty
            for line in \lines!
                line = line\gsub "%s+$", ""
                res ..= line .. "\n" if #line\gsub("^%ѕ+", "") > 0
            res = res\gsub "\n$", ""
        else
            res = \read"*a"
        \close!
        if t.removegarbage
            while #res > 0 and not res\sub(1, 1)\match"[0-9A-Za-z_]"
                res = res\sub 2
        return trim res

reload = ->
    stderr = os.tmpname!

    if os.execute"cd #{awful.util.getdir"config"} && find . -name \"*.moon\" | xargs moonc &> #{stderr}" != 0
        err = shell "cat #{stderr}"
        os.remove stderr
        return naughty.notification
            urgency: "critical"
            title:   "Awesome reload failed"
            message: err

    if os.execute"awesome -k &> #{stderr}" == 0
        os.remove stderr
        return awesome.restart!

    err = shell "cat #{stderr}"
    os.remove stderr
    naughty.notification
        urgency: "critical"
        title:   "Awesome reload failed"
        message: err

showpopup = =>
    lines = [{:text, widget: wibox.widget.textbox} for text in @\gmatch"[^\n]+"]
    lines.layout = wibox.layout.fixed.vertical
    popup = awful.popup
        widget: {
            lines
            widget: wibox.container.margin
        }
        placement: awful.placement.under_mouse + awful.placement.no_offscreen
        shape:     gears.shape.rounded_rec
        ontop:     true
    popup\connect_signal "mouse::leave", => @visible = false
    popup

terminal = "sakura"

{
    :terminal, :trim, :shell, :showpopup, :reload
    -- editor:         os.getenv"EDITOR" or "vim"
    -- editor_cmd:     "#{terminal} -e #{editor}"
    i3blocksassets: "#{gears.filesystem.get_xdg_config_home!}/i3blocks/assets"
    wezterm:        "call-terminal.sh"
}
