local *

gears   = require"gears"
awful   = require"awful"
naughty = require"naughty"
wibox   = require"wibox"
import filesystem from gears


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

    if os.execute"cd #{filesystem.get_configuration_dir!} && make &> #{stderr}" != 0
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
    history_path: "#{filesystem.get_cache_dir!}/history"
    hook: {
        awful.key
            modifier: {"Mod4"}
            key:      "c"
            on_press: => "#{@}#{selection!}", false
    }
    exe_callback: =>
        awful.spawn.easy_async_with_shell "echo '#{@}' | moonc --", =>
            res = tostring awful.util.eval "#{setup}#{@}"
            naughty.notify
                title: "Moonscript response"
                ontop:  true
                text:   res
                timeout: 10
            awful.spawn.with_shell "printf %s '#{res}' | xclip -i -selection clipboard"

--------------------------------------------------------------------------------
ddgo = -> awful.prompt.run
    prompt: " <span color=\"#884400\">DuckDuckGo&gt;</span> "
    textbox: awful.screen.focused!.topbar.widgets.prompt.widget
    history_path: "#{filesystem.get_cache_dir!}/ddgo"
    exe_callback: =>
        awful.spawn "prime-run www-browser https://www.duckduckgo.com/?q=#{@\gsub "%s+", "+"}"

--------------------------------------------------------------------------------
redditsearch = -> awful.prompt.run
    prompt: " <span color=\"#884400\">Reddit&gt;</span> "
    textbox: awful.screen.focused!.topbar.widgets.prompt.widget
    history_path: "#{filesystem.get_cache_dir!}/reddit"
    exe_callback: =>
        awful.spawn "prime-run www-browser https://www.reddit.com/r/awesomewm/search/?q=#{@\gsub "%s+", "+"}"

--------------------------------------------------------------------------------
reloadscripts = ->
    awful.spawn "dex #{filesystem.get_xdg_config_home!}/autostart/Scripts.desktop"

--------------------------------------------------------------------------------
geo =
    lat: 0
    lon: 0
    temp: 3400
with f = io.open "#{filesystem.get_xdg_config_home!}/redshift.conf"
    if f
        for line in \lines!
            geo.lat = line\gsub "^lat%s*=%s*", "" if line\match"^lat%s*="
            geo.lon = line\gsub "^lon%s*=%s*", "" if line\match"^lon%s*="
            geo.temp = line\gsub "^temp.*=%s*", "" if line\match"^temp.*="
        geo.lat = tonumber geo.lat
        geo.lon = tonumber geo.lon
        \close!



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
    awful.spawn.easy_async_with_shell "xprop", showpopup

--------------------------------------------------------------------------------
--terminal = "sakura"
terminal = "st"


--------------------------------------------------------------------------------
{
    :terminal, :trim, :moonprompt
    :showpopup, :reload, :reloadscripts
    :nexttag, :prevtag
    :ddgo, :redditsearch, :geo, :xprop
    wezterm: "call-terminal.sh"
}
