local *

awful  = require'awful'
pactl  = require'plugins.audio.pactl'
import filesystem from require'gears'
import show_help from require'awful.hotkeys_popup'
import ddgo, moonprompt, nexttag, pgrep, prevtag, reload, rofi, showgames from require'helpers'
terminal = require'menubar.utils'.alt_terminal
import mainmenu from require'menus'

-- Mod1    = Meta/Alt_L
-- Mod2    = Num_Lock
-- Mod3    = Menu, ISO_Level5_Shift
-- Mod4    = Super_L, Super_R
-- Mod5    = ISO_Level3_Shift/AltGrp
-- Shift   = Shift_L, Shift_R
-- Control = Control_L, Control_R

ALT   = 'Mod1'
CTRL  = 'Control'
MENU  = 'Menu'
SHIFT = 'Shift'
SUPER = 'Mod4'


--------------------------------------------------------------------------------
--- Global keys

----------------
-- Audio keys --
----------------
awful.keyboard.append_global_keybindings {
    awful.key
        modifiers: {}
        key:       'XF86AudioMute'
        on_press: -> pactl.sink.togglemute!
        description: 'mute/umute audio'
        group:       'awesome'

    awful.key
        modifiers: {}
        key:       'XF86AudioLowerVolume'
        on_press: -> pactl.sink.volume '-10%'
        description: 'lower volume'
        group:       'awesome'

    awful.key
        modifiers: {}
        key:       'XF86MonBrightnessUp'
        onpress: -> awful.spawn 'brightcli +'
        description: 'raise brightness'
        group:       'awesome'

    awful.key
        modifiers: {}
        key:       'XF86MonBrightnessDown'
        onpress: -> awful.spawn 'brightcli -'
        description: 'decrease brightness'
        group:       'awesome'

    -- awful.key
    --     modifiers: {SUPER}
    --     key:       'F2'
    --     on_press: -> pactl.sink.volume '-10%'
    --     description: 'lower volume'
    --     group:       'awesome'

    awful.key
        modifiers: {}
        key:       'XF86AudioRaiseVolume'
        on_press: -> pactl.sink.volume '+10%'
        description: 'raise volume'
        group:       'awesome'

    -- awful.key
    --     modifiers: {SUPER}
    --     key:       'F3'
    --     on_press: -> pactl.sink.volume '+10%'
    --     description: 'raise volume'
    --     group:       'awesome'

    awful.key
        modifiers: {}
        key:      'XF86AudioMicMute'
        on_press: -> pactl.source.togglemute!
        description: 'mute/unmute mic'
        group:       'awesome'

    -- awful.key
    --     modifiers: {SUPER}
    --     key:       'F4'
    --     on_press: -> pactl.source.togglemute!
    --     description: 'mute/unmute mic'
    --     group:       'awesome'

}

---------------------
-- Multimedia keys --
---------------------

awful.keyboard.append_global_keybindings {
    awful.key
        modifiers: {}
        key:       'XF86AudioPlay'
        on_press: ->
            if pgrep 'spotify'
                awful.spawn 'playerctl --player=spotify play-pause'
            else
                awful.spawn.with_shell 'xdotool search --sync --class shortwave; playerctl --player=de.haeckerfelix.Shortwave play-pause'
                awful.spawn 'shortwave'
        description: 'play/pause audio'
        group:       'awesome'
}

awful.keyboard.append_global_keybindings {
    awful.key
        modifiers: {}
        key:       'XF86AudioStop'
        on_press: ->
            if pgrep 'spotify'
                awful.spawn 'playerctl --player=spotify stop'
            else
                awful.spawn.with_shell 'xdotool search --sync --class shortwave; playerctl --player=de.haeckerfelix.Shortwave stop; sleep 0.25; xdotool search --class shortwave windowquit'
                awful.spawn 'shortwave'
        description: 'stop audio'
        group:       'awesome'
}

awful.keyboard.append_global_keybindings {
    awful.key
        modifiers: {}
        key:       'XF86AudioPrev'
        on_press: -> awful.spawn 'playerctl --player=spotify previous'
        description: 'previous song on Spotify'
        group:       'awesome'
}

awful.keyboard.append_global_keybindings {
    awful.key
        modifiers: {}
        key:       'XF86AudioNext'
        on_press: -> awful.spawn 'playerctl --player=spotify next'
        description: 'next song on Spotify'
        group:       'awesome'
}

--------------------
-- Searching keys --
--------------------
awful.keyboard.append_global_keybindings {
    awful.key
        modifiers: {SUPER}
        key:       '/'
        on_press:  ddgo
        description: 'search on DuckDuckGo'
        group:       'awesome'

    awful.key
        modifiers: {SUPER}
        key:       'd'
        on_press: moonprompt
        description: 'run Moon command'
        group:       'awesome'
}

--------------------
-- Menus and bars --
--------------------
awful.keyboard.append_global_keybindings {
    awful.key
        modifiers: {}
        key:       MENU
        on_press: ->
            _G.menupressed = true
            for s in screen
                s.topbar.ontop = true
                s.topbar.opacity = 1
                -- s.bottombar\showup!
        on_release: ->
            _G.menupressed = false
            for s in screen
                s.topbar.ontop = false
                s.topbar.opacity = 0.625
                -- s.bottombar\hidedown!
        description: 'raise bars using '
        group:       'awesome'

    awful.key
        modifiers: {SUPER}
        key:       't'
        on_press: -> awful.spawn 'cambridge.sh'
        description: 'search for word in Cambridge dictionary'
        group:       'awesome'

    awful.key
        modifiers: {SUPER}
        key:       'Escape'
        on_press: -> mainmenu\show!
        description: 'show main menu'
        group:       'awesome'

    awful.key
        modifiers: {SUPER}
        key:       'u'
        on_press: -> awful.spawn 'rofimoji'
        description: 'show emoji'
        group:       'launcher'

    awful.key
        modifiers: {SUPER}
        key:       'o'
        on_press: -> awful.spawn 'ls-otp.sh'
        description: 'load OTP'
        group:       'client'

    awful.key
        modifiers: {SUPER}
        key:       'p'
        on_press: -> awful.spawn 'ls-pass.sh'
        description: 'load password'
        group:       'client'
}

-----------------
-- Screenshots --
-----------------
awful.keyboard.append_global_keybindings {
    awful.key
        modifiers: {}
        key:       'Print'
        on_press: -> awful.spawn.with_shell 'capture.sh'
        description: 'take a screenshot'
        group:       'screen'

    awful.key
        modifiers: {SUPER}
        key:       'Print'
        on_press: -> awful.spawn.with_shell 'capture.sh root'
        description: 'take a root screenshot'
        group:       'screen'
}

---------------
-- Launchers --
---------------
awful.keyboard.append_global_keybindings {
    awful.key
        modifiers: {ALT}
        key:       ' '
        on_press: ->
            awful.spawn "prime-run #{rofi} -show-icons -modes combi -combi-modes window,drun -show combi -theme docu -matching glob -display-combi NVIDIA"
        description: 'call application on NVIDIA card'
        group:       'launcher'

    awful.key
        modifiers: {SUPER, ALT}
        key:       ' '
        on_press: ->
            awful.spawn "#{rofi} -show-icons -modes drun -show drun -theme sidebar-v2 -display-drun 'Mesa Intel'"
        description: 'call application on Mesa Intel card'
        group:       'launcher'

    awful.key
        modifiers: {SUPER}
        key:       's'
        on_press: ->
            awful.spawn "#{rofi} -modes ssh -show ssh -theme fancy -display-ssh SSH -terminal kitty.sh -ssh-command 'kitten @ launch --type=tab kitten ssh {host}'"
        description: 'call application on Mesa Intel card'
        group:       'launcher'

    awful.key
        modifiers: {SUPER}
        key:       ' '
        on_press: ->
            awful.spawn "#{rofi} -modes run,calc -show run -theme fancy -display-calc Calculate -display-run 'Mesa Intel' -config ~/.config/rofi/term.rasi"
        description: 'run command on Mesa Intel card'
        group:       'launcher'

    awful.key
        modifiers: {SUPER, CTRL}
        key:       'Return'
        on_press: -> awful.spawn terminal
        description: 'start terminal'
        group:       'launcher'

    awful.key
        modifiers: {SUPER}
        key:       'g'
        on_press:    showgames
        description: 'call game on NVIDIA card'
        group:       'launcher'

    awful.key
        modifiers: {SUPER, ALT}
        key:       'c'
        on_press:  -> awful.spawn 'sh -c "yad --color --title \'Color Selector\' | xclip -selection clipboard -r"'
        description: 'Choose a colour'
        group:       'launcher'

    awful.key
        modifiers: {SUPER, CTRL, ALT}
        key:       'c'
        on_press:  -> awful.spawn 'sh -c "xcolor | xclip -selection clipboard -r"'
        description: 'Choose a colour'
        group:       'launcher'

    awful.key
        modifiers: {}
        key:       'XF86Explorer'
        on_press:  -> awful.spawn 'prime-run nemo /home/cacilhas/Desktop'
        description: 'open Nemo'
        group:       'launcher'

    awful.key
        modifiers: {}
        key:       'XF86HomePage'
        on_press:  -> awful.spawn 'prime-run www-browser'
        description: 'open Web browser'
        group:       'launcher'

    awful.key
        modifiers: {}
        key:       'XF86Mail'
        on_press:  -> awful.spawn 'prime-run betterbird -purgecaches -p default-release'
        description: 'open email'
        group:       'launcher'

    awful.key
        modifiers: {}
        key:       'XFCalculator'
        on_press:  -> awful.spawn 'xcalc'
        description: 'open calculator'
        group:       'launcher'

    awful.key
        modifiers: {SUPER}
        key:       'F12'
        on_press:  -> awful.spawn 'xcalc'
        description: 'open calculator'
        group:       'launcher'
}

----------------
-- Navigation --
----------------
do
    s = awful.screen.focused!
    dealsupernumber = =>
        tag = s.tags[@]
        if tag
            return awful.key
                modifiers: {SUPER}
                key:       tostring(@ % 10)
                --on_press: -> tag\view_only!
                on_press: -> tag\emit_signal 'request::select'
                description: "got to tag #{tag.name}"
                group:       'awesome'
    awful.keyboard.append_global_keybindings [dealsupernumber tag for tag = 1, 9]

awful.keyboard.append_global_keybindings {
    awful.key
        modifiers: {SUPER}
        key:       'Tab'
        on_press: ->
            awful.spawn "#{rofi} -show-icons -modes windowcd -show windowcd -display-windowcd App -theme sidebar-v2"
        description: 'open between-clients navigation window'
        group:       'client'

    awful.key
        modifiers: {ALT}
        key:       'Tab'
        on_press: -> awful.client.focus.byidx 1
        description: 'focus next window'
        group:       'client'

    awful.key
        modifiers: {SUPER}
        key:       'Right'
        on_press: -> awful.client.focus.byidx 1
        description: 'focus next window'
        group:       'client'

    awful.key
        modifiers: {SHIFT, ALT}
        key:       'Tab'
        on_press: -> awful.client.focus.byidx -1
        description: 'focus previous window'
        group:       'client'

    awful.key
        modifiers: {SUPER}
        key:       'Left'
        on_press: -> awful.client.focus.byidx -1
        description: 'focus previous window'
        group:       'client'

    awful.key
        modifiers:  {SUPER}
        key:        'Up'
        on_press: -> awful.client.focus.bydirection 'up'
        description: 'select the client above'
        group:       'client'

    awful.key
        modifiers:  {SUPER}
        key:        'Right'
        on_press: -> awful.client.focus.bydirection 'right'
        description: 'select the client to the right'
        group:       'client'

    awful.key
        modifiers:  {SUPER}
        key:        'Down'
        on_press: -> awful.client.focus.bydirection 'down'
        description: 'select the client bellow'
        group:       'client'

    awful.key
        modifiers:  {SUPER}
        key:        'Left'
        on_press: -> awful.client.focus.bydirection 'left'
        description: 'select the client to the left'
        group:       'client'

    awful.key
        modifiers: {SUPER, ALT}
        key:       'u'
        on_press: awful.client.urgent.jumpto
        description: 'jump to urgent client'
        group:       'client'

    awful.key
        modifiers: {SUPER, SHIFT}
        key:       'Up'
        on_press: -> awful.client.swap.bydirection 'up'
        description: 'swap to the top'
        group:       'client'

    awful.key
        modifiers: {SUPER, SHIFT}
        key:       'Right'
        on_press: -> awful.client.swap.bydirection 'right'
        description: 'swap to the right'
        group:       'client'

    awful.key
        modifiers: {SUPER, SHIFT}
        key:       'Down'
        on_press: -> awful.client.swap.bydirection 'down'
        description: 'swap to the bottom'
        group:       'client'

    awful.key
        modifiers: {SUPER, SHIFT}
        key:       'Left'
        on_press: -> awful.client.swap.bydirection 'left'
        description: 'swap to the left'
        group:       'client'

    awful.key
        modifiers: {SUPER, CTRL}
        key:       'Left'
        on_press: prevtag
        description: 'view previous non-empty tag'
        group:       'tag'

    awful.key
        modifiers: {SUPER, ALT, CTRL}
        key:       'Left'
        on_press: awful.tag.viewprev
        description: 'view previous tag'
        group:       'tag'

    awful.key
        modifiers: {SUPER, CTRL}
        key:       'Right'
        on_press: nexttag
        description: 'view next non-empty tag'
        group:       'tag'

    awful.key
        modifiers: {SUPER, ALT, CTRL}
        key:       'Right'
        on_press: awful.tag.viewnext
        description: 'view next tag'
        group:       'tag'
}

----------
-- Misc --
----------
awful.keyboard.append_global_keybindings {
    awful.key
        modifiers: {SUPER, SHIFT}
        key:       'r'
        on_press: reload
        description: 'reload settings'
        group:       'awesome'

    awful.key
        modifiers: {SUPER}
        key:       'F1'
        on_press: show_help
        description: 'show help'
        group:       'awesome'

    awful.key
        modifiers: {SUPER, SHIFT}
        key:       ' '
        on_press: ->
            with awful.layout
                .set .suit.floating
        description: 'set floating'
        group: 'layout'

    awful.key
        modifiers: {SUPER, ALT}
        key:       'l'
        on_press: -> awful.spawn 'xlock.fish'
        description: 'lock screen'
        group:       'screen'

    awful.key
        modifiers: {SUPER}
        key:       'F9'
        on_press: ->
            if not client.focus
                with c = awful.client.restore!
                    \activate raise: true, context: 'key.unminimize' if c
        description: 'restore minimized'
        group:       'client'
}


--------------------------------------------------------------------------------
--- Per-client keys
client.connect_signal 'request::default_keybindings', ->
    do
        s = awful.screen.focused!
        dealsupernumber = =>
            tag = s.tags[@]
            if tag
                return awful.key
                    modifiers: {SHIFT, SUPER}
                    key:       tostring(@ % 10)
                    on_press: =>
                        @\move_to_tag tag
                        awful.screen.focused!.tags[tag]\view_only!
                    description: "move to tag #{tag.name}"
                    group:       'awesome'
        awful.keyboard.append_global_keybindings [dealsupernumber tag for tag = 1, 9]

    awful.keyboard.append_client_keybindings {
        awful.key
            modifiers: {SUPER}
            key:       'F11'
            on_press: =>
                @fullscreen = not @fullscreen
                @\raise!
            description: 'toggle fullscreen'
            group:       'client'

        awful.key
            modifiers: {SUPER}
            key:       'q'
            on_press: => @\kill!
            description: 'kill window'
            group:       'client'

        awful.key
            modifiers: {ALT}
            key:       'F4'
            on_press: => @\kill!
            description: 'kill window'
            group:       'client'

        awful.key
            modifiers: {SUPER, ALT}
            key:       'q'
            on_press: => awesome.kill @pid, 9
            description: 'kill application'
            group:       'client'

        -- awful.key
        --     modifiers: {SUPER, SHIFT}
        --     key:       ' '
        --     on_press: awful.client.floating.toggle
        --     description: 'toggle floating'
        --     group:       'client'

        -- awful.key
        --     modifiers: {SUPER, CTRL}
        --     key:      'Return'
        --     on_press: =>
        --         @\swap awful.client.getmaster!
        --     description: 'move to master'
        --     group:       'client'

        awful.key
            modifiers: {SUPER}
            key:       'F10'
            on_press: =>
                @maximized = not @maximized
                @\raise!
                @\emit_signal 'request::titlebars'
            description: '(un)maximize'
            group:       'client'
    }
