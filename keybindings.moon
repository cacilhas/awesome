local *

awful = require"awful"
import show_help from require"awful.hotkeys_popup"
import nexttag, prevtag, reload, wezterm from require"helpers"
import mainmenu from require"menus"

-- Mod1 = Meta/Alt
-- Mod2 =
-- Mod3 = ISO_Level5_Shift/Menu
-- Mod4 = Super
-- Mod5 = ISO_Level3_Shift/AltGrp


--------------------------------------------------------------------------------
--- Global keys

awful.keyboard.append_global_keybindings {
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
        description: "reload awesome"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "F1"
        on_press: show_help
        description: "show help"
        group:       "awesome"

    awful.key
        modifiers: {}
        key:       "XF86AudioLowerVolume"
        on_press: ->
            with bar = awful.screen.focused!.topbar
                if .bar
                    widget = .widgets.audio
                    widget.markup = .helpers.updateaudio 4
        description: "lower volume"
        group:       "awesome"

    awful.key
        modify: {"Mod4"}
        key:    "F2"
        on_press: ->
            with bar = awful.screen.focused!.topbar
                if .bar
                    widget = .widgets.audio
                    widget.markup = .helpers.updateaudio 4
        description: "lower volume"
        group:       "awesome"

    awful.key
        modifiers: {}
        key:       "XF86AudioRaiseVolume"
        on_press: ->
            with bar = awful.screen.focused!.topbar
                if .bar
                    widget = .widgets.audio
                    widget.markup = .helpers.updateaudio 5
        description: "raise volume"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "F3"
        on_press: ->
            with bar = awful.screen.focused!.topbar
                if .bar
                    widget = .widgets.audio
                    widget.markup = .helpers.updateaudio 5
        description: "raise volume"
        group:       "awesome"

    awful.key
        modifiers: {}
        key:       "XF86AudioMute"
        on_press: ->
            with bar = awful.screen.focused!.topbar
                if .bar
                    widget = .widgets.audio
                    widget.markup = .helpers.updateaudio 1
        description: "mute/umute audio"
        group:       "awesome"

    awful.key
        modifiers: {}
        key:       "XF86AudioMuteMic"
        on_press: ->
            with bar = awful.screen.focused!.topbar
                if .bar
                    widget = .widgets.mic
                    widget.markup = .helpers.updatemic 1
        description: "mute/unmute mic"
        group:       "awesome"

    awful.key
        modifiers: {"Mod4"}
        key:       "F4"
        on_press: ->
            with bar = awful.screen.focused!.topbar
                if .bar
                    widget = .widgets.mic
                    widget.markup = .helpers.updatemic 1
        description: "mute/unmute mic"
        group:       "awesome"

    -- awful.key {"Mod4"}, "F7", -> os.execute"brighcli -", description: "decrease brightness", group: "awesome"
    -- awful.key {"Mod4"}, "F8", -> os.execute"brighcli +", description: "increase brightness", group: "awesome"

    awful.key
        modifiers:  {"Mod4"}
        key:        "F7"
        on_press: ->
            command = [[xrandr --verbose --current | grep '^HDMI-1 ' -A5 | awk -F': ' '$1 ~ /Brightness/ { print $2; }']]
            awful.spawn.easy_async_with_shell command, (bri) ->
                bri = tonumber bri
                bri -= 0.1
                bri = 0.1 if bri < 0.1
                awful.spawn "xrandr --output HDMI-1 --brightness #{bri}"

    awful.key
        modifiers:  {"Mod4"}
        key:        "F8"
        on_press: ->
            command = [[xrandr --verbose --current | grep '^HDMI-1 ' -A5 | awk -F': ' '$1 ~ /Brightness/ { print $2; }']]
            awful.spawn.easy_async_with_shell command, (bri) ->
                bri = tonumber bri
                bri += 0.1
                bri = 1 if bri > 1
                awful.spawn "xrandr --output HDMI-1 --brightness #{bri}"

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
        modifiers: {"Mod1"}
        key:       "Tab"
        on_press: ->
            awful.spawn "rofi -show-icons -modes windowcd -show windowcd -display-windowcd App -theme sidebar-v2"
        description: "navigate between windows"
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
        on_press: prevtag -- awful.tag.viewprev
        description: "view previous tag"
        group:       "tag"

    awful.key
        modifiers: {"Mod3"}
        key:       "Left"
        on_press: awful.tag.viewprev
        description: "view previous tag"
        group:       "tag"

    awful.key
        modifiers: {"Mod4", "Control"}
        key:       "Right"
        on_press: nexttag -- awful.tag.viewnext
        description: "view next tag"
        group:       "tag"

    awful.key
        modifiers: {"Mod3"}
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
