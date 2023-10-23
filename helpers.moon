local *

gears   = require"gears"
awful   = require"awful"
naughty = require"naughty"
wibox   = require"wibox"


--------------------------------------------------------------------------------
trim = =>
    res = @\gsub "^%s+", ""
    res = res\gsub "%s+$", ""
    res

--------------------------------------------------------------------------------
-- XXX: ¡¡BLOCKING FUNCTION!! prefer using awful.spawn.easy_async_with_shell instead
shell = =>
    with io.popen @
        res = \read"*a"
        \close!
        return trim res

--------------------------------------------------------------------------------
-- XXX: reload MUST be a blocking function
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

--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
nexttag = (screen=awful.screen.focused!) =>
    tags = screen.tags
    src  = awful.tag.selected!
    idx  = 0
    for i, v in ipairs(tags)
        if v == src
            idx = i
            break
    for i = idx+1, #tags
        tag = tags[i]
        if #tag\clients! > 0
            tag\view_only!
            return

    -- -- Rotating
    -- idx += 1
    -- idx = 1 if idx > #tags
    -- tag = tags[idx]
    -- while tag.name != src.name
    --     if #tag\clients! > 0
    --         tag\view_only!
    --         return
    --     idx += 1
    --     idx = 1 if idx > #tags
    --     tag = tags[idx]

--------------------------------------------------------------------------------
prevtag = (screen=awful.screen.focused!) =>
    tags = screen.tags
    src  = awful.tag.selected!
    idx  = 0
    for i, v in ipairs(tags)
        if v == src
            idx = i
            break
    for i = idx-1, 1, -1
        tag = tags[i]
        if #tag\clients! > 0
            tag\view_only!
            return

    -- -- Rotating
    -- idx -= 1
    -- idx = #tags if idx == 0
    -- tag = tags[idx]
    -- while tag.name != src.name
    --     if #tag\clients! > 0
    --         tag\view_only!
    --         return
    --     idx -= 1
    --     idx = #tags if idx == 0
    --     tag = tags[idx]

--------------------------------------------------------------------------------
terminal = "sakura"


--------------------------------------------------------------------------------
{
    :terminal, :trim, :showpopup, :reload
    :nexttag, :prevtag
    i3blocksassets: "#{gears.filesystem.get_xdg_config_home!}/i3blocks/assets"
    wezterm: "call-terminal.sh"
}
