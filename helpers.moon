local *

awful   = require'awful'
gears   = require'gears'
naughty = require'naughty'
theme   = require'beautiful'
wibox   = require'wibox'
import filesystem from gears


--------------------------------------------------------------------------------
rofi = "rofi -replace -steal-focus"


--------------------------------------------------------------------------------
aplay = => awful.spawn.with_shell "play /usr/share/sounds/#{@}"


--------------------------------------------------------------------------------
process = =>
    res = ""
    for word in @\gmatch"%S+"
        res ..= " " .. word unless word\match"%w+%.%w+" or word\match"/"
    trim res


--------------------------------------------------------------------------------
trim = =>
    return '' if not trim
    res = @\gsub '^%s+', ''
    res = res\gsub '%s+$', ''
    res


--------------------------------------------------------------------------------
-- XXX: ¡¡BLOCKING FUNCTION!! prefer using awful.spawn.easy_async_with_shell instead
shell = =>
    with io.popen @
        res = \read'*a'
        \close!
        return trim res


--------------------------------------------------------------------------------
-- XXX: reload MUST be a blocking function
reload = ->
    stderr = os.tmpname!

    if os.execute"cd #{filesystem.get_configuration_dir!} && make &> #{stderr}" != 0
        err = with io.open stderr, 'r'
            content = \read'*a'
            \close!
            return content
        os.remove stderr
        return naughty.notification
            urgency: 'critical'
            title:   'Awesome reload failed'
            message: err

    if os.execute"awesome -k &> #{stderr}" == 0
        os.remove stderr
        return awesome.restart!

    err = with io.open stderr, 'r'
        content = \read'*a'
        \close!
        return content
    os.remove stderr
    naughty.notification
        urgency: 'critical'
        title:   'Awesome reload failed'
        message: err


--------------------------------------------------------------------------------
setup = ''
setup ..= "if not #{req} then #{req} = require[[#{req}]] end " for req in *{
    'awful'
    'gears'
    'wibox'
    'ruled'
    'naughty'
    'inspect'
}
setup ..= 'if not s then s = awful.screen.focused() end '

moonprompt = -> awful.prompt.run
    prompt: ' <span color="#4444ff">AWM&gt;</span> '
    textbox: awful.screen.focused!.prompt.widget
    history_path: "#{filesystem.get_cache_dir!}/history"
    hook: {
        awful.key
            modifier: {'Mod4'}
            key:      'c'
            on_press: => "#{@}#{selection!}", false
    }
    exe_callback: =>
        awful.spawn.easy_async_with_shell "echo '#{@}' | moonc --", (output) ->
            res = awful.util.eval"#{setup}#{output}" or ''
            naughty.notify
                title: "Moonscript response"
                ontop:  true
                text:   tostring res
                timeout: 10
            awful.spawn.easy_async_with_shell "printf %s '#{res}' | xclip -i -selection clipboard"


--------------------------------------------------------------------------------
ddgo = -> awful.prompt.run
    prompt: ' <span color="#884400">DuckDuckGo&gt;</span> '
    textbox: awful.screen.focused!.prompt.widget
    history_path: "#{filesystem.get_cache_dir!}/ddgo"
    exe_callback: =>
        awful.spawn "prime-run www-browser https://www.duckduckgo.com/?q=#{@\gsub "%s+", "+"}"


--------------------------------------------------------------------------------
redditsearch = -> awful.prompt.run
    prompt: ' <span color="#884400">Reddit&gt;</span> '
    textbox: awful.screen.focused!.prompt.widget
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
            geo.lat = line\gsub '^lat%s*=%s*', '' if line\match'^lat%s*='
            geo.lon = line\gsub '^lon%s*=%s*', '' if line\match'^lon%s*='
            geo.temp = line\gsub '^temp.*=%s*', '' if line\match'^temp.*='
        geo.lat = tonumber geo.lat
        geo.lon = tonumber geo.lon
        \close!


--------------------------------------------------------------------------------
showpopup = =>
    lines = [{:text, widget: wibox.widget.textbox} for text in @\gmatch'[^\n]+']
    lines.layout = wibox.layout.fixed.vertical
    popup = awful.popup
        widget: {
            lines
            widget: wibox.container.margin
        }
        placement: awful.placement.under_mouse + awful.placement.no_offscreen
        shape:     gears.shape.rounded_rec
        ontop:     true
    popup\connect_signal 'mouse::leave', => @visible = false
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
say = (urgent) =>
    return if _G.nospeak

    if @\match "^%[%["
        voice = if urgent then "Demonic -k1" else "belinda -k20"
        awful.spawn "espeak -ven+#{voice} -s140 \"#{@}\""
    else
        awful.spawn.easy_async_with_shell "#{filesystem.get_configuration_dir!}/assets/langit \"#{process @}\"", (res) ->
            res = "English" unless res and #res > 0
            it = res\gmatch"[^\n]+"
            res = it!
            voice = if urgent
                "Demonic -k1"
            elseif res == "Portuguese"
                "anika -k20"
            else
                "belinda -k20"
            lang = switch res
                when "Portuguese"
                    "pt-BR"
                when "French"
                    "fr"
                else
                    "en"
            message = @\gsub '"', ""
            awful.spawn "espeak -v#{lang}+#{voice} -s140 \"#{message}\""


--------------------------------------------------------------------------------
link =
    dev: 'lo'

    init: ->
        return unless link.dev == 'lo'
        awful.spawn.easy_async_with_shell 'ip addr', (res) ->
            for line in res\gmatch'[^\n]+'
                data = [e for e in line\gsub('^%s+', '')\gmatch'[^%s]+']
                if data[1] == 'inet' and data[6] == 'global'
                    link.dev = data[7]
                    return

    show: (cb) ->
        awful.spawn.easy_async_with_shell "ip link show dev #{link.dev}", cb

link.init!


--------------------------------------------------------------------------------
-- FIXME: use awful assets to wait
wait = (t, cb) -> awful.spawn.easy_async_with_shell "wait #{t}", cb


--------------------------------------------------------------------------------
withmargin = (kwargs = {}) =>
    top = kwargs.top or kwargs.margin
    bottom = kwargs.bottom or kwargs.margin
    left = kwargs.left or kwargs.margin
    right = kwargs.right or kwargs.margin

    wrapper = wibox.widget {
        @
        :top, :bottom, :left, :right
        widget: wibox.container.margin
    }

    if kwargs.hijack
        for button in *@buttons
            {:press, :release} = button
            button.press   = -> press   @ if press
            button.release = -> release @ if release
        wrapper.buttons = @buttons
        @buttons = {}

    wrapper


--------------------------------------------------------------------------------
rounded = (bg) => wibox.widget {
    @
    shape:      gears.shape.rounded_rect
    shape_clip: true
    bg:         bg
    widget: wibox.container.background
}


wrap = (kwargs = {}) =>
    top    = kwargs.top or kwargs.margin or 4
    bottom = kwargs.bottom or kwargs.margin or 4
    right  = kwargs.right or 0
    left   = kwargs.left or 4
    bg = kwargs.bg or theme.bg_button
    wrapper = withmargin rounded(withmargin(@, left: 8, right: 8), bg),
        :top, :bottom, :left, :right
    -- Hijack button behaviour from inner widget
    for button in *@buttons
        {:press, :release} = button
        button.press   = -> press   @ if press
        button.release = -> release @ if release
    wrapper.buttons = @buttons
    @buttons = {}
    --
    wrapper


--------------------------------------------------------------------------------
xprop = ->
    awful.spawn.easy_async_with_shell 'xprop', showpopup


--------------------------------------------------------------------------------
showgames = ->
    awful.tag.find_by_name(nil, ' ')\view_only!
    awful.spawn "prime-run #{rofi} -sort -show-icons -modes drun -drun-categories Game,Games -show drun -theme docu -matching glob -display-drun Games"


--------------------------------------------------------------------------------
{
    :aplay
    :trim, :moonprompt
    :showgames, :rofi
    :showpopup, :reload, :reloadscripts
    :nexttag, :prevtag
    :link, :say, :wait
    :ddgo, :redditsearch, :geo, :xprop
    :withmargin, :wrap
    terminal: 'st'
    kitty: 'call-terminal.sh'
}
