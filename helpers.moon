local *

gears   = require"gears"
awful   = require"awful"
naughty = require"naughty"

trim = =>
    res = @\gsub "^%s+", ""
    res = res\gsub "%s+$", ""
    res

shell = =>
    with io.popen @
        res = \read"*a"
        \close!
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

terminal = "sakura"

{
    :terminal, :trim, :shell, :reload
    -- editor:         os.getenv"EDITOR" or "vim"
    -- editor_cmd:     "#{terminal} -e #{editor}"
    i3blocksassets: "#{gears.filesystem.get_xdg_config_home!}/i3blocks/assets"
    wezterm:        "call-terminal.sh"
}
