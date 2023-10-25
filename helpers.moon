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

    if os.execute"cd #{awful.util.getdir"config"} && make &> #{stderr}" != 0
        err = with io.open stderr, "r"
            content = \read"*a"
            \close!
            return content
        os.remove stderr
        return naughty.notification
            urgency: "critical"
            title:   "Awesome reload failed"
            message: err

    if os.execute"awesome -k &> #{stderr}" == 0
        os.remove stderr
        return awesome.restart!

    err = with io.open stderr, "r"
        content = \read"*a"
        \close!
        return content
    os.remove stderr
    naughty.notification
        urgency: "critical"
        title:   "Awesome reload failed"
        message: err

--------------------------------------------------------------------------------
setup = ""
setup ..= "if not #{req} then #{req} = require[[#{req}]] end " for req in *{
    "awful"
    "gears"
    "wibox"
    "ruled"
    "naughty"
    "inspect"
}
setup ..= "if not s then s = awful.screen.focused() end "

moonprompt = -> awful.prompt.run
    prompt: " <span color=\"#4444ff\">AWM&gt;</span> "
    textbox: awful.screen.focused!.topbar.widgets.prompt.widget
    history_path: "#{awful.util.get_cache_dir!}/history"
    exe_callback: =>
        awful.spawn.easy_async_with_shell "echo '#{@}' | moonc --", =>
            naughty.notify
                title: "Moonscript response"
                ontop:  true
                text: tostring awful.util.eval "#{setup}#{@}"
                timeout: 10

--------------------------------------------------------------------------------
reloadscripts = ->
    awful.spawn "dex #{gears.filesystem.get_xdg_config_home!}/autostart/Scripts.desktop"

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
    for i = 1, idx
        tag = tags[i]
        if #tag\clients! > 0
            tag\view_only!
            return
    -- No other non-empty tag, quitting silently

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
    for i = #tags, idx, -1
        tag = tags[i]
        if #tag\clients! > 0
            tag\view_only!
            return
    -- No other non-empty tag, quitting silently

--------------------------------------------------------------------------------
xprop = ->
    -- FIXME: not working
    awful.spawn.with_shell "DISPLAY=:0 xprop | xmessage -f-"
        -- naughty.notify
        --     title: "xprop"
        --     icon: theme.xorg_logo
        --     icon_size: apply_dpi 64
        --     text: @
        --     timeout: 0

--------------------------------------------------------------------------------
terminal = "sakura"


--------------------------------------------------------------------------------
{
    :terminal, :trim, :moonprompt
    :showpopup, :reload, :reloadscripts
    :nexttag, :prevtag
    wezterm: "call-terminal.sh"
}
