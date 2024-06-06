local *

gears = require"gears"
awful = require"awful"
wibox = require"wibox"
theme = require"beautiful"
assets = require"assets"
plugins = require"plugins"

import withmargin, wrap from require"helpers"
import mainlauncher from require"menus"


--------------------------------------------------------------------------------
--- Wibar

-- Keyboard map indicator and switcher
--keyboardlayout = awful.widget.keyboardlayout!

stop_timer = => @\stop! if @ and @.started


screen.connect_signal 'request::desktop_decoration', =>
    awful.tag {
        ' '
        ' '
        ' '
        ' '
        ' '
        ' '
        ' ' -- 
        ' '
        ' '
        ' '
        ' '
        ' '
        ' '
        ' ' -- 
        ' '
        '🦙'
    }, @, awful.layout.suit.fair

    awful.tag.find_by_name(s, ' ').layout = awful.layout.suit.max
    awful.tag.find_by_name(s, ' ').layout = awful.layout.suit.max.fullscreen
    awful.tag.find_by_name(s, ' ').layout = awful.layout.suit.max
    awful.tag.find_by_name(s, ' ').layout = awful.layout.suit.max.fullscreen
    awful.tag.find_by_name(s, ' ').layout = awful.layout.suit.max.fullscreen
    awful.tag.find_by_name(s, '🦙').layout = awful.layout.suit.max.fullscreen


    ----------------------------------------------------------------------------
    -- Top bar

    @topbar = {}

    @topbar.widgets =
        hostname: wibox.widget
            markup:  '<span color="red">_@_</span>'
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.hostname 'nemo', (markup) ->
                        @topbar.widgets.hostname.markup = markup
            }

        speak: wibox.widget
            markup: ''
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.speak 'switch', (markup) ->
                        @topbar.widgets.speak.markup = markup
            }

        audio: wibox.widget
            markup:  ''
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.audio 'mute', (markup) ->
                        @topbar.widgets.audio.markup = markup

                awful.button {}, 2, ->
                    awful.spawn 'pavucontrol'

                awful.button {}, 4, ->
                    assets.audio 'dec', (markup) ->
                        @topbar.widgets.audio.markup = markup

                awful.button {}, 5, ->
                    assets.audio 'inc', (markup) ->
                        @topbar.widgets.audio.markup = markup
            }

        mic: wibox.widget
            markup:  ''
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.mic 'mute', (markup) ->
                        @topbar.widgets.mic.markup = markup
            }

        eth: wibox.widget
            markup:  ''
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.eth 'show', (markup) ->
                        @topbar.widgets.eth.markup = markup

                awful.button {}, 3, ->
                    assets.eth 'reset', (markup) ->
                        @topbar.widgets.eth.markup = markup
            }

        webconn: wibox.widget
            text: '‼️'
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.webconn 'show', (text) ->
                        @topbar.widgets.webconn.text = text
            }

        vpn: wibox.widget
            markup: '<span color="yellow">Connecting…</span>'
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    assets.vpn 'status', (markup) -> @topbar.widgets.vpn.markup = markup
                awful.button {}, 2, ->
                    assets.vpn 'disconnect', (markup) -> @topbar.widgets.vpn.markup = markup
                awful.button {}, 4, ->
                    assets.vpn 'us', (markup) -> @topbar.widgets.vpn.markup = markup
                awful.button {}, 5, ->
                    assets.vpn 'br', (markup) -> @topbar.widgets.vpn.markup = markup
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

    sep = {
        text:   ' '
        font:   'monospace 12'
        widget: wibox.widget.textbox
    }

    @prompt = awful.widget.prompt!
    @topbar.bar = awful.wibar
        position: 'top'
        opacity:  0.8
        screen:   @
        widget:   {
            layout: wibox.layout.align.horizontal
            {
                layout: wibox.layout.fixed.horizontal
                plugins.taglist @
                @prompt
            }
            wibox.widget
                color: theme.bg_normal
                widget: wibox.widget.separator
            {
                layout: wibox.layout.fixed.horizontal
                plugins.archlogo!
                wrap @topbar.widgets.hostname
                wrap @topbar.widgets.speak
                wrap @topbar.widgets.audio
                wrap @topbar.widgets.mic
                wrap @topbar.widgets.webconn
                wrap @topbar.widgets.eth
                --wrap @topbar.widgets.vpn
                sep
                wibox.widget.systray!
                @topbar.widgets.layoutbox
            }
        }

    ---------------------
    -- Top bar updates --

    @topbar.timers or= {}
    timer\stop! for _, timer in pairs @topbar.timers

    stop_timer @topbar.timers.speak
    @topbar.timers.speak = gears.timer
        autostart: true
        call_now:  true
        timeout:   30
        callback: ->
            assets.speak nil, (markup) ->
                @topbar.widgets.speak.markup = markup

    stop_timer @topbar.timers.audio
    @topbar.timers.audio = gears.timer
        autostart: true
        call_now:  true
        timeout:   1
        callback:  ->
            assets.audio nil, (markup) ->
                @topbar.widgets.audio.markup = markup

    stop_timer @topbar.timers.mic
    @topbar.timers.mic = gears.timer
        autostart: true
        call_now:  true
        timeout:   1
        callback:  ->
            assets.mic nil, (markup) ->
                @topbar.widgets.mic.markup = markup

    stop_timer @topbar.timers
    @topbar.timers.eth = gears.timer
        autostart: true
        call_now:  true
        timeout:   5
        callback:  ->
            assets.eth nil, (markup) ->
                @topbar.widgets.eth.markup = markup

    stop_timer @topbar.timers.webconn
    @topbar.timers.webconn = gears.timer
        autostart: true
        call_now:  true
        timeout:   10
        callback:  ->
            assets.webconn nil, (text) ->
                @topbar.widgets.webconn.text = text

    stop_timer @topbar.timers.vpn
    @topbar.timers.vpn = gears.timer
        autostart: true
        call_now:  true
        timeout:   5
        callback: ->
            assets.vpn nil, (markup) ->
                @topbar.widgets.vpn.markup = markup

    stop_timer @topbar.timers.hostname
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
        bright: plugins.bright!
        loadavg: plugins.loadavg!
        taskbar: plugins.taskbar @
        localclock: plugins.clock!
        utcclock: plugins.utc!
        quitbt: plugins.bt_quit!

    bb_height = 64
    bb_y = 1080 - bb_height

    @bottombar.bar = awful.wibar
        position: 'bottom'
        opacity:  1
        width:    1920 * 0.75
        height:   bb_height
        x:        768
        y:        bb_y
        ontop:    true
        shape: gears.shape.rounded_rect
        screen:   @
        widget:   {
            layout: wibox.layout.align.horizontal
            {
                layout: wibox.layout.fixed.horizontal
                withmargin mainlauncher, left: 8, right: 8
            }
            withmargin @bottombar.widgets.taskbar, left: 4, top: 8, bottom: 8
            {
                layout: wibox.layout.fixed.horizontal
                wrap @bottombar.widgets.bright, margin: 8
                wrap @bottombar.widgets.loadavg, margin: 8
                wrap @bottombar.widgets.utcclock, margin: 8
                wrap @bottombar.widgets.localclock, margin: 8
                @bottombar.widgets.quitbt
            }
        }

    -----------------------
    -- Bottom bar update --

    @bottombar.bar\connect_signal 'mouse::enter', () ->
        @bottombar.bar.y = bb_y
        @bottombar.bar.opacity = 100

    @bottombar.bar\connect_signal 'mouse::leave', () ->
        @bottombar.bar.y = 1078
        @bottombar.bar.opacity = 1

    @bottombar.bar\connect_signal 'property::visible', () ->
        if @bottombar.bar.visible
            @bottombar.bar.y = bb_y
            @bottombar.bar.opacity = 100
