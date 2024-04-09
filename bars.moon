local *

gears = require"gears"
awful = require"awful"
wibox = require"wibox"
theme = require"beautiful"
assets = require"assets"
import filesystem from gears
import nexttag, prevtag, reload, showpopup from require"helpers"
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
        " " -- 
        " "
        " "
        " "
        " "
        " "
        " "
        " " -- 
        " "
    }, @, awful.layout.suit.fair

    awful.tag.find_by_name(s, " ").layout = awful.layout.suit.max
    awful.tag.find_by_name(s, " ").layout = awful.layout.suit.max.fullscreen
    awful.tag.find_by_name(s, " ").layout = awful.layout.suit.max
    awful.tag.find_by_name(s, " ").layout = awful.layout.suit.max.fullscreen
    awful.tag.find_by_name(s, " ").layout = awful.layout.suit.max.fullscreen


    ----------------------------------------------------------------------------
    -- Top bar

    @topbar = {}

    @topbar.widgets =
        prompt: awful.widget.prompt!

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
            markup: ' <span color="#00c838"></span>'
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    @topbar.widgets.taglist.visible = false
                    @topbar.widgets.taglist_full.visible = true
                    @topbar.widgets.et1.visible = false
                    @topbar.widgets.et2.visible = true
            }

        et2: wibox.widget
            markup: '| <span color="#ffbd2f"></span>'
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    @topbar.widgets.taglist.visible = true
                    @topbar.widgets.taglist_full.visible = false
                    @topbar.widgets.et1.visible = true
                    @topbar.widgets.et2.visible = false
            }

        archlogolauncher: wibox.widget
            markup:  '<span color="brown"> </span><span color="black"> </span><span color="#0044ff"> </span>'
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    awful.spawn "#{filesystem.get_configuration_dir!}/assets/archlogo"
            }

        hostname: wibox.widget
            markup:  '<span color="red">_@_</span>'
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.hostname "nemo", (markup) ->
                        @topbar.widgets.hostname.markup = markup
            }

        speak: wibox.widget
            markup: ""
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.speak "switch", (markup) ->
                        @topbar.widgets.speak.markup = markup
            }

        audio: wibox.widget
            markup:  ""
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.audio "mute", (markup) ->
                        @topbar.widgets.audio.markup = markup

                awful.button {}, 2, ->
                    awful.spawn "pavucontrol"

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

        webconn: wibox.widget
            text: "‼️"
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.webconn "show", (text) ->
                        @topbar.widgets.webconn.text = text
            }

        vpn: wibox.widget
            markup: '<span color="yellow">Connecting…</span>'
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.vpn "status", (markup) -> @topbar.widgets.vpn.markup = markup
                awful.button {}, 2, ->
                    assets.vpn "disconnect", (markup) -> @topbar.widgets.vpn.markup = markup
                awful.button {}, 4, ->
                    assets.vpn "us", (markup) -> @topbar.widgets.vpn.markup = markup
                awful.button {}, 5, ->
                    assets.vpn "br", (markup) -> @topbar.widgets.vpn.markup = markup
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
                @topbar.widgets.prompt
            }
            wibox.widget
                color: theme.bg_normal
                widget: wibox.widget.separator
            {
                layout: wibox.layout.fixed.horizontal
                @topbar.widgets.archlogolauncher
                wibox.widget.textbox"┊"
                @topbar.widgets.hostname
                wibox.widget.textbox"┊"
                @topbar.widgets.speak
                wibox.widget.textbox"┊"
                @topbar.widgets.audio
                wibox.widget.textbox"┊"
                @topbar.widgets.mic
                wibox.widget.textbox"┊"
                @topbar.widgets.webconn
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

    @topbar.timers or= {}
    timer\stop! for _, timer in pairs @topbar.timers

    @topbar.timers.speak = gears.timer
        autostart: true
        call_now:  true
        timeout:   30
        callback: ->
            assets.speak nil, (markup) ->
                @topbar.widgets.speak.markup = markup

    @topbar.timers.audio = gears.timer
        autostart: true
        call_now:  true
        timeout:   1
        callback:  ->
            assets.audio nil, (markup) ->
                @topbar.widgets.audio.markup = markup

    @topbar.timers.mic = gears.timer
        autostart: true
        call_now:  true
        timeout:   1
        callback:  ->
            assets.mic nil, (markup) ->
                @topbar.widgets.mic.markup = markup

    @topbar.timers.eth = gears.timer
        autostart: true
        call_now:  true
        timeout:   5
        callback:  ->
            assets.eth nil, (markup) ->
                @topbar.widgets.eth.markup = markup

    @topbar.timers.webconn = gears.timer
        autostart: true
        call_now:  true
        timeout:   10
        callback:  ->
            assets.webconn nil, (text) ->
                @topbar.widgets.webconn.text = text

    @topbar.timers.vpn = gears.timer
        autostart: true
        call_now:  true
        timeout:   5
        callback: ->
            assets.vpn nil, (markup) ->
                @topbar.widgets.vpn.markup = markup

    @topbar.timers.hostname = gears.timer
        autostart: true
        call_now:  true
        timeout:   15*60
        callback: ->
            assets.hostname nil, (markup) ->
                @topbar.widgets.hostname.markup = markup

    ----------------------------------------------------------------------------
    -- Bottom bar

    @bottombar = {}

    @bottombar.widgets =
        bright: wibox.widget
            text: "🔆‼️%"
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 4, =>
                    assets.bright "dec", (text) ->
                        @text = text

                awful.button {}, 5, =>
                    assets.bright "inc", (text) ->
                        @text = text
            }

        taskbar: awful.widget.tasklist
            screen:  @,
            filter:  awful.widget.tasklist.filter.currenttags,
            buttons: {
                awful.button {}, 1, => @\activate context: "tasklist", action: "toggle_minimization"
                awful.button {}, 3, -> awful.menu.client_list theme: {width: 250}
                awful.button {}, 4, -> awful.client.focus.byidx -1
                awful.button {}, 5, -> awful.client.focus.byidx  1
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
            buttons:  {awful.button {}, 1, -> showpopup"US/Pacific".visible = true}

        cstclock: wibox.widget
            format:   '<span size="small">%H:%MCST</span>'
            timezone: 'US/Central'
            refresh:  60
            widget:   wibox.widget.textclock
            buttons:  {awful.button {}, 1, -> showpopup"US/Central".visible = true}

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
                @bottombar.widgets.pstclock
                wibox.widget.textbox"┊"
                @bottombar.widgets.cstclock
                wibox.widget.textbox"┊"
                @bottombar.widgets.utcclock
                wibox.widget.textbox"┊"
                @bottombar.widgets.localclock
                wibox.widget.textbox"┊"
                @bottombar.widgets.quitbt
            }
        }

    -----------------------
    -- Bottom bar update --

    @bottombar.timers or= {}
    timer\stop! for _, timer in pairs @bottombar.timers

    @bottombar.timers.bright = gears.timer
        autostart: true
        call_now:  true
        timeout: 5
        callback: ->
            assets.bright nil, (text) ->
                @bottombar.widgets.bright.text = text

    @bottombar.timers.loadavg = gears.timer
        autostart: true
        call_now:  true
        timeout:   5
        callback:  ->
            assets.loadavg nil, (markup) ->
                @bottombar.widgets.loadavg.markup = markup
