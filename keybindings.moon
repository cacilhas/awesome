local *

awful  = require"awful"
assets = require"assets"
import show_help from require"awful.hotkeys_popup"
import ddgo, moonprompt, nexttag, prevtag, reload, wezterm from require"helpers"
import mainmenu from require"menus"

-- Mod1 = Meta/Alt
-- Mod2 =
-- Mod3 = Menu - former ISO_Level5_Shift/Menu
-- Mod4 = Super
-- Mod5 = ISO_Level3_Shift/AltGrp


--------------------------------------------------------------------------------
--- Global keys


awful.keyboard.append_global_keybindings {
    awful.key
        modifiers: {}
        key:       "Menu"
        on_press: ->
            for s in screen
                s.topbar.bar.ontop = true
                s.bottombar.bar.ontop = true
        on_release: ->
            for s in screen
                s.topbar.bar.ontop = false
                s.bottombar.bar.ontop = false
        description: "raise bars using "
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "1"
        on_press: -> awful.screen.focused!.tags[1]\view_only!
        description: "got to tag #{awful.screen.focused!.tags[1].name}"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "2"
        on_press: -> awful.screen.focused!.tags[2]\view_only!
        description: "got to tag #{awful.screen.focused!.tags[2].name}"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "3"
        on_press: -> awful.screen.focused!.tags[3]\view_only!
        description: "got to tag #{awful.screen.focused!.tags[3].name}"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "4"
        on_press: -> awful.screen.focused!.tags[2]\view_only!
        description: "got to tag #{awful.screen.focused!.tags[4].name}"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "5"
        on_press: -> awful.screen.focused!.tags[5]\view_only!
        description: "got to tag #{awful.screen.focused!.tags[5].name}"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "/"
        on_press:  ddgo
        description: "search on DuckDuckGo"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "d"
        on_press: moonprompt
        description: "run Moon command"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "Escape"
        on_press: -> mainmenu\show!
        description: "show main menu"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4", "Shift"}
        key:       "r"
        on_press: reload
        description: "reload settings"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "F1"
        on_press: show_help
        description: "show help"
        group:       "awesome"

    awful.key
        modifiers: {}
        key:       "XF86AudioMute"
        on_press: ->
            with awful.screen.focused!.topbar.widgets.audio
                assets.audio "mute", (markup) ->
                    .markup = markup
        description: "mute/umute audio"
        group:       "awesome"

    awful.key
        modifiers: {}
        key:       "XF86AudioLowerVolume"
        on_press: ->
            with awful.screen.focused!.topbar.widgets.audio
                assets.audio "dec", (markup) ->
                    .markup = markup
        description: "lower volume"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "F2"
        on_press: ->
            with awful.screen.focused!.topbar.widgets.audio
                assets.audio "dec", (markup) ->
                    .markup = markup
        description: "lower volume"
        group:       "awesome"

    awful.key
        modifiers: {}
        key:       "XF86AudioRaiseVolume"
        on_press: ->
            with awful.screen.focused!.topbar.widgets.audio
                assets.audio "inc", (markup) ->
                    .markup = markup
        description: "raise volume"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "F3"
        on_press: ->
            with awful.screen.focused!.topbar.widgets.audio
                assets.audio "inc", (markup) ->
                    .markup = markup
        description: "raise volume"
        group:       "awesome"

    awful.key
        modifiers: {}
        key:       "XF86AudioMicMute"
        on_press: ->
            with awful.screen.focused!.topbar.widgets.mic
                assets.mic "mute", (markup) ->
                    .markup = markup
        description: "mute/unmute mic"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "F4"
        on_press: ->
            with awful.screen.focused!.topbar.widgets.mic
                assets.mic "mute", (markup) ->
                    .markup = markup
        description: "mute/unmute mic"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        Key:       "F5"
        on_press: ->
            with awful.screen.focused!
                .topbar.bar.ontop = true
                .bottombar.bar.ontop = true
        on_release: ->
            with awful.screen.focused!
                .topbar.bar.ontop = false
                .bottombar.bar.ontop = false

    -- awful.key {"Mod4"}, "F7", -> os.execute"brighcli -", description: "decrease brightness", group: "awesome"
    -- awful.key {"Mod4"}, "F8", -> os.execute"brighcli +", description: "increase brightness", group: "awesome"

    awful.key
        modifiers:  {"Mod4"}
        key:        "F7"
        on_press: ->
            with awful.screen.focused!.bottombar.widgets.bright
                assets.bright "dec", (text) ->
                    .text = text

    awful.key
        modifiers:  {"Mod4"}
        key:        "F8"
        on_press: ->
            with awful.screen.focused!.bottombar.widgets.bright
                assets.bright "inc", (text) ->
                    .text = text

    awful.key
        modifiers: {}
        key:       "Print"
        on_press: -> awful.spawn "capture.sh"
        description: "take a screenshot"
        group:       "screen"

    awful.key
        modifiers: {"Mod4"}
        key:       "Print"
        on_press: -> awful.spawn "capture.sh root"
        description: "take a root screenshot"
        group:       "screen"

    awful.key
        modifiers: {"Mod4"}
        key:       "u"
        on_press: -> awful.spawn "ibus emoji"
        description: "show emoji"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4", "Control"}
        key:       "Return"
        on_press: -> awful.spawn wezterm
        description: "start terminal"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "t"
        on_press: -> awful.spawn "cambridge.sh"
        description: "search for word in Cambridge dictionary"
        group:       "awesome"

    awful.key
        modifiers: {"Mod1"}
        key:       " "
        on_press: ->
            awful.spawn "prime-run rofi -show-icons -modes drun -show drun -theme iggy -display-drun 'NVIDIA' -dpi 64"
        description: "call application on NVIDIA card"
        group:       "launcher"

    awful.key
        modifiers: {"Mod4", "Mod1"}
        key:       " "
        on_press: ->
            awful.spawn "rofi -show-icons -modes drun -show drun -theme sidebar-v2 -display-drun 'Mesa Intel' -dpi 64"
        description: "call application on Mesa Intel card"
        group:       "launcher"

    awful.key
        modifiers: {"Mod4"}
        key:       " "
        on_press: ->
            awful.spawn "rofi -modes run -show run -theme Indego -display-run 'Mesa Intel'"
        description: "run command on Mesa Intel card"
        group:       "launcher"

    awful.key
        modifiers: {"Mod4"}
        key:       "Tab"
        on_press: ->
            awful.spawn "rofi -show-icons -modes windowcd -show windowcd -display-windowcd App -theme sidebar-v2"
        description: "open between-clients navigation window"
        group:       "client"

    awful.key
        modifiers: {"Mod1"}
        key:       "Tab"
        on_press: -> awful.client.focus.byidx 1
        description: "focus next window"
        group:       "client"

    awful.key
        modifiers: {"Shift", "Mod1"}
        key:       "Tab"
        on_press: -> awful.client.focus.byidx -1
        description: "focus previous window"
        group:       "client"

    awful.key
        modifiers: {"Mod4"}
        key:       "o"
        on_press: -> awful.spawn "ls-otp.sh"
        description: "load OTP"
        group:       "client"

    awful.key
        modifiers: {"Mod4"}
        key:       "p"
        on_press: -> awful.spawn "ls-pass.sh"
        description: "load password"
        group:       "client"

    awful.key
        modifiers: {"Mod4", "Shift"}
        key:       " "
        on_press: ->
            with awful.layout
                .set .suit.floating
        description: "set floating"
        group: "layout"

    awful.key
        modifiers:  {"Mod4"}
        key:        "Up"
        on_press: -> awful.client.focus.bydirection "up"
        description: "select the client above"
        group:       "client"

    awful.key
        modifiers:  {"Mod4"}
        key:        "Right"
        on_press: -> awful.client.focus.bydirection "right"
        description: "select the client to the right"
        group:       "client"

    awful.key
        modifiers:  {"Mod4"}
        key:        "Down"
        on_press: -> awful.client.focus.bydirection "down"
        description: "select the client bellow"
        group:       "client"

    awful.key
        modifiers:  {"Mod4"}
        key:        "Left"
        on_press: -> awful.client.focus.bydirection "left"
        description: "select the client to the left"
        group:       "client"

    awful.key
        modifiers: {"Mod4", "Mod1"}
        key:       "u"
        on_press: awful.client.urgent.jumpto
        description: "jump to urgent client"
        group:       "client"

    awful.key
        modifiers: {"Mod4",  "Shift"}
        key:       "Up"
        on_press: -> awful.client.swap.bydirection "up"
        description: "swap to the top"
        group:       "client"

    awful.key
        modifiers: {"Mod4",  "Shift"}
        key:       "Right"
        on_press: -> awful.client.swap.bydirection "right"
        description: "swap to the right"
        group:       "client"

    awful.key
        modifiers: {"Mod4",  "Shift"}
        key:       "Down"
        on_press: -> awful.client.swap.bydirection "down"
        description: "swap to the bottom"
        group:       "client"

    awful.key
        modifiers: {"Mod4",  "Shift"}
        key:       "Left"
        on_press: -> awful.client.swap.bydirection "left"
        description: "swap to the left"
        group:       "client"

    awful.key
        modifiers: {"Mod4", "Mod1"}
        key:       "l"
        on_press: -> awful.spawn "xlock.fish"
        description: "lock screen"
        group:       "screen"

    awful.key
        modifiers: {"Mod4", "Control"}
        key:       "Left"
        on_press: prevtag
        description: "view previous non-empty tag"
        group:       "tag"

    awful.key
        modifiers: {"Mod4", "Mod1", "Control"}
        key:       "Left"
        on_press: awful.tag.viewprev
        description: "view previous tag"
        group:       "tag"

    awful.key
        modifiers: {"Mod4", "Control"}
        key:       "Right"
        on_press: nexttag
        description: "view next non-empty tag"
        group:       "tag"

    awful.key
        modifiers: {"Mod4", "Mod1", "Control"}
        key:       "Right"
        on_press: awful.tag.viewnext
        description: "view next tag"
        group:       "tag"

    -- awful.key {"Mod4", "Control"}, "Escape", awful.tag.history.restore, description: "go back", group: "tag"

    awful.key
        modifiers: {"Mod4"}
        key:       "F10"
        on_press: ->
            if not client.focus
                with c = awful.client.restore!
                    \activate raise: true, context: "key.unminimize" if c
        description: "restore minimized"
        group:       "client"
}

--------------------------------------------------------------------------------
--- Mouse bindings

client.connect_signal "request::default_mousebindings", ->
    awful.mouse.append_client_mousebindings {
        awful.button
            modifiers: {}
            button:    1
            on_press: =>
                @activate context: "mouse_click"

        awful.button
            modifiers: {"Mod4"}
            button:    1
            on_press: => @activate context: "mouse_click", action: "mouse_move"

        awful.button
            modifiers: {"Mod4"}
            button: 3
            on_press: => @activate context: "mouse_click", action: "mouse_resize"
    }


--------------------------------------------------------------------------------
--- Per-client keys

client.connect_signal "request::default_keybindings", ->
    awful.keyboard.append_client_keybindings {
        awful.key
            modifiers: {"Mod4"}
            key:       "f"
            on_press: =>
                @fullscreen = not @fullscreen
                @\raise!
            description: "toggle fullscreen"
            group:       "client"

        awful.key
            modifiers: {"Mod4"}
            key:       "q"
            on_press: => @\kill!
            description: "close window"
            group:       "client"

        awful.key
            modifiers: {"Mod4", "Mod1"}
            key:       "q"
            on_press: => awesome.kill @pid, 9
            description: "kill application"
            group:       "client"

        -- awful.key
        --     modifiers: {"Mod4", "Shift"}
        --     key:       " "
        --     on_press: awful.client.floating.toggle
        --     description: "toggle floating"
        --     group:       "client"

        -- awful.key
        --     modifiers: {"Mod4", "Control"}
        --     key:      "Return"
        --     on_press: =>
        --         @\swap awful.client.getmaster!
        --     description: "move to master"
        --     group:       "client"

        awful.key
            modifiers: {"Mod4"}
            key:       "F11"
            on_press: =>
                @maximized = not @maximized
                @\raise!
                @\emit_signal "request::titlebars"
            description: "(un)maximize"
            group:       "client"
    }
