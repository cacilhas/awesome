local *

gears = require"gears"
awful = require"awful"
wibox = require"wibox"
theme = require"beautiful"
assets = require"assets"
import nexttag, prevtag, reload, showpopup, terminal, trim from require"helpers"
import mainlauncher from require"menus"


--------------------------------------------------------------------------------
--- Wibar

-- Keyboard map indicator and switcher
--keyboardlayout = awful.widget.keyboardlayout!

screen.connect_signal "request::desktop_decoration", =>
    awful.tag {
        " "
        " "
        " "
        " "
        " "
        " "
        " "
        " "
        " "
        " "
        " "
        " "
        " "
        " " -- 
        " "
    }, @, awful.layout.suit.fair


    ----------------------------------------------------------------------------
    -- Top bar

    @topbar =
        helpers:
            updatemarkup: (command, bt) =>
                command = "button=#{bt} #{command}" if bt
                awful.spawn.easy_async_with_shell command, (res) ->
                    it = res\gmatch"[^\n]+"
                    text = it!
                    it! -- discard
                    color = it!
                    @markup = "<span color=\"#{color}\">#{text}</span>"

            updateuserhost: =>
                awful.spawn.easy_async_with_shell "hostname", (host) ->
                    if host
                        @markup = "<span color=\"blue\">#{os.getenv"USER"}@#{trim host}</span>"
                    else
                        awful.spawn.easy_async_with_shell "cat /etc/hostname", (host) ->
                            @markup = "<span color=\"blue\">#{os.getenv"USER"}@#{trim host}</span>"

            updatevpn: =>
                awful.spawn.easy_async_with_shell "nordvpn status | awk -F': ' '$1 ~ /Country/ { print $2; }'", (vpn) ->
                    if vpn or #vpn > 0
                        @markup = "<span color=\"green\">#{trim vpn}</span>"
                    else
                        @markup = '<span color="red">disconnected</span>'

    @topbar.widgets =
        taglist: awful.widget.taglist {
            screen:  @
            filter:  awful.widget.taglist.filter.noempty
            buttons: {
                awful.button {},       1, => @\view_only!
                awful.button {"Mod4"}, 1, (=> client.focus\move_to_tag @ if client.focus)
                awful.button {},       3, awful.tag.viewtoggle
                awful.button {"Mod4"}, 3, (=> client.focus\toggle_tag @ if client.focus)
                awful.button {},       4, => prevtag @screen
                awful.button {},       5, => nexttag @screen
            }
        }

        taglist_full: awful.widget.taglist {
            screen:  @
            filter:  awful.widget.taglist.filter.all
            buttons: {
                awful.button {},       1, => @\view_only!
                awful.button {"Mod4"}, 1, (=> client.focus\move_to_tag @ if client.focus)
                awful.button {},       3, awful.tag.viewtoggle
                awful.button {"Mod4"}, 3, (=> client.focus\toggle_tag @ if client.focus)
                awful.button {},       4, => awful.tag.viewprev @screen
                awful.button {},       5, => awful.tag.viewnext @screen
            }
        }

        et1: wibox.widget
            text: " "
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    @topbar.widgets.taglist.visible = false
                    @topbar.widgets.taglist_full.visible = true
                    @topbar.widgets.et1.visible = false
                    @topbar.widgets.et2.visible = true
            }

        et2: wibox.widget
            text: " "
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    @topbar.widgets.taglist.visible = true
                    @topbar.widgets.taglist_full.visible = false
                    @topbar.widgets.et1.visible = true
                    @topbar.widgets.et2.visible = false
            }

        archlogolauncher: wibox.widget
            markup:  '<span color="brown"> </span><span color="black"> </span><span color="blue"> </span>'
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    awful.spawn "#{awful.util.getdir"config"}/assets/archlogo"
            }

        userhost: wibox.widget
            markup:  '<span color="red">_@_</span>'
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    awful.spawn "prime-run nemo Desktop"
                        floating: true
                        focus:    true
                        sticky:   true
                        placement: awful.placement.centered
            }

        audio: wibox.widget
            markup:  ""
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.audio "mute", (markup) ->
                        @topbar.widgets.audio.markup = markup

                awful.button {}, 4, ->
                    assets.audio "dec", (markup) ->
                        @topbar.widgets.audio.markup = markup

                awful.button {}, 5, ->
                    assets.audio "inc", (markup) ->
                        @topbar.widgets.audio.markup = markup
            }

        mic: wibox.widget
            markup:  ""
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.mic "mute", (markup) ->
                        @topbar.widgets.mic.markup = markup
            }

        eth: wibox.widget
            markup:  ""
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.eth "show", (markup) ->
                        @topbar.widgets.eth.markup = markup

                awful.button {}, 3, ->
                    assets.eth "reset", (markup) ->
                        @topbar.widgets.eth.markup = markup
            }

        internet: wibox.widget
            text: "‼️"
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.webconn "show", (text) ->
                        @topbar.widgets.internet.text = text
            }

        vpn: wibox.widget
            markup: ""
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    awful.spawn.easy_async_with_shell "nordvpn status", (text) ->
                        showpopup(text).visible = true
                awful.button {}, 2, -> awful.spawn "sudo nordvpn disconnect"
                awful.button {}, 4, -> awful.spawn "sudo nordvpn connect us"
                awful.button {}, 5, -> awful.spawn "sudo nordvpn connect br"
            }

        layoutbox: awful.widget.layoutbox {
            screen:  @
            buttons: {
                awful.button {}, 1, -> awful.layout.inc  1
                awful.button {}, 3, -> awful.layout.inc -1
                awful.button {}, 4, -> awful.layout.inc -1
                awful.button {}, 5, -> awful.layout.inc  1
            }
        }

    @topbar.bar = awful.wibar
        position: "top"
        opacity:  0.8
        screen:   @
        widget:   {
            layout: wibox.layout.align.horizontal
            {
                layout: wibox.layout.fixed.horizontal
                @topbar.widgets.taglist
                @topbar.widgets.taglist_full
                @topbar.widgets.et1
                @topbar.widgets.et2
            }
            wibox.widget
                color: theme.bg_normal
                widget: wibox.widget.separator
            {
                layout: wibox.layout.fixed.horizontal
                @topbar.widgets.archlogolauncher
                wibox.widget.textbox"┊"
                @topbar.widgets.userhost
                wibox.widget.textbox"┊"
                @topbar.widgets.audio
                wibox.widget.textbox"┊"
                @topbar.widgets.mic
                wibox.widget.textbox"┊"
                @topbar.widgets.internet
                wibox.widget.textbox"┊"
                @topbar.widgets.eth
                wibox.widget.textbox"┊"
                @topbar.widgets.vpn
                wibox.widget.textbox"┊"
                wibox.widget.systray!
                @topbar.widgets.layoutbox
            }
        }

    @topbar.widgets.taglist_full.visible = false
    @topbar.widgets.et2.visible = false

    ---------------------
    -- Top bar updates --

    gears.timer
        autostart: true
        call_now:  true
        timeout:   1
        callback:  ->
            assets.audio nil, (markup) ->
                @topbar.widgets.audio.markup = markup

    gears.timer
        autostart: true
        call_now:  true
        timeout:   1
        callback:  ->
            assets.mic nil, (markup) ->
                @topbar.widgets.mic.markup = markup

    gears.timer
        autostart: true
        call_now:  true
        timeout:   5
        callback:  ->
            assets.eth nil, (markup) ->
                @topbar.widgets.eth.markup = markup

    gears.timer
        autostart: true
        call_now:  true
        timeout:   10
        callback:  ->
            assets.webconn nil, (text) ->
                @topbar.widgets.internet.text = text

    gears.timer
        autostart: true
        call_now:  true
        timeout:   5
        callback:  -> @topbar.helpers.updatevpn @topbar.widgets.vpn

    gears.timer
        autostart: true
        call_now:  true
        timeout:   15*60
        callback: -> @topbar.helpers.updateuserhost @topbar.widgets.userhost

    ----------------------------------------------------------------------------
    -- Bottom bar

    @bottombar =
        helpers:
            updatebright: =>
                xrandr = "xrandr --verbose --current | grep '^HDMI-1 ' -A5 | awk -F': ' '$1 ~ /Brightness/ { print $2; }'"
                awful.spawn.easy_async_with_shell xrandr, (bri) ->
                    @text = if bri then "🔆#{math.floor (100 * tonumber bri) + .5}%" else "🔆‼️%"

    @bottombar.widgets =
        bright: wibox.widget
            text: "🔆‼️%"
            widget: wibox.widget.textbox

        taskbar: awful.widget.tasklist {
            screen:  @,
            filter:  awful.widget.tasklist.filter.currenttags,
            buttons: {
                awful.button {}, 1, => @\activate context: "tasklist", action: "toggle_minimization"
                awful.button {}, 3, -> awful.menu.client_list theme: {width: 250}
                awful.button {}, 4, -> awful.client.focus.byidx -1
                awful.button {}, 5, -> awful.client.focus.byidx  1
            }
        }

        loadavg: wibox.widget
            markup: '<span foreground="yellow"> </span>'
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.loadavg "show", (markup) ->
                        @bottombar.widgets.loadavg.markup = markup
            }

        localclock: wibox.widget
            format:  '<span color="#ffaa88">%a %F %H:%MBRT</span>'
            refresh: 60
            widget:  wibox.widget.textclock

        calendar: awful.widget.calendar_popup.month!

        pstclock: wibox.widget
            format:   '<span size="small">%H:%MPST</span>'
            timezone: 'US/Pacific'
            refresh:  60
            widget:   wibox.widget.textclock

        cstclock: wibox.widget
            format:   '<span size="small">%H:%MCST</span>'
            timezone: 'US/Central'
            refresh:  60
            widget:   wibox.widget.textclock

        utcclock: wibox.widget
            format:   '<span color="#00aa55">%H:%MZ</span>'
            timezone: 'UTC'
            refresh:  60
            widget:   wibox.widget.textclock
            buttons:  {awful.button {}, 1, -> awful.spawn "kodumaro-clock"}

        quitbt: wibox.widget
            markup: '<span size="large" color="red">⏻ </span>'
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, -> awesome.quit!,
                awful.button {}, 3, reload,
            }

    with @bottombar.widgets
        .calendar\attach .localclock, "br", on_hover: false
        .localclock.buttons = {awful.button {}, 1, -> .calendar\toggle!}

    @bottombar.bar = awful.wibar
        position: "bottom"
        opacity:  0.8
        screen:   @
        widget:   {
            layout: wibox.layout.align.horizontal
            {
                layout: wibox.layout.fixed.horizontal
                mainlauncher
                wibox.widget.textbox" "
            }
            @bottombar.widgets.taskbar
            {
                layout: wibox.layout.fixed.horizontal
                wibox.widget
                    text:   " "
                    color:  theme.bg_normal
                    bg:     theme.bg_normal
                    widget: wibox.widget.textbox" "
                @bottombar.widgets.bright
                wibox.widget.textbox"┊"
                @bottombar.widgets.loadavg
                wibox.widget.textbox"┊"
                @bottombar.widgets.localclock
                wibox.widget.textbox"┊"
                @bottombar.widgets.pstclock
                wibox.widget.textbox"┊"
                @bottombar.widgets.cstclock
                wibox.widget.textbox"┊"
                @bottombar.widgets.utcclock
                wibox.widget.textbox"┊"
                @bottombar.widgets.quitbt
            }
        }

    -----------------------
    -- Bottom bar update --

    gears.timer
        autostart: true
        call_now:  true
        timeout: 5
        callback: -> @bottombar.helpers.updatebright @bottombar.widgets.bright

    gears.timer
        autostart: true
        call_now:  true
        timeout:   5
        callback:  ->
            assets.loadavg nil, (markup) ->
                @bottombar.widgets.loadavg.markup = markup
