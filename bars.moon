local *

gears = require"gears"
awful = require"awful"
wibox = require"wibox"
theme = require"beautiful"
import i3blocksassets, reload, shell, showpopup, terminal, trim from require"helpers"
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
            updateaudio: =>
                command = "#{i3blocksassets}/audio.sh"
                command = "button=#{@} #{command}" if @
                with io.popen command
                    text = \read"*l"
                    \read"*l" -- discard
                    color = \read"*l"
                    \close!
                    return "<span color=\"#{color}\">#{text}</span>"

            updatemic: =>
                command = "#{i3blocksassets}/mic.sh"
                command = "button=#{@} #{command}" if @
                with io.popen command
                    text = \read"*l"
                    \read"*l" -- discard
                    color = \read"*l"
                    \close!
                    return "<span color=\"#{color}\">#{text}</span>"

            updateeth: =>
                command = "#{i3blocksassets}/eth.sh"
                command = "button=#{@} #{command}" if @
                with io.popen command
                    text = \read"*l"
                    \read"*l" -- discard
                    color = \read"*l"
                    \close!
                    return "<span color=\"#{color}\">#{text}</span>"

            updatevpn: =>
                vpn = shell "nordvpn status | awk -F': ' '$1 ~ /Country/ { print $2; }'"
                if #vpn > 0
                    "<span color=\"green\">#{trim vpn}</span>"
                else
                    '<span color="red">disconnected</span>'

    @topbar.widgets =
        taglist: awful.widget.taglist {
            screen:  @
            filter:  awful.widget.taglist.filter.noempty
            buttons: {
                awful.button {},       1, => @\view_only!
                awful.button {"Mod4"}, 1, (=> client.focus\move_to_tag @ if client.focus)
                awful.button {},       3, awful.tag.viewtoggle
                awful.button {"Mod4"}, 3, (=> client.focus\toggle_tag @ if client.focus)
                awful.button {},       4, => awful.tag.viewprev @screen
                awful.button {},       5, => awful.tag.viewnext @screen
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

        expandtags: wibox.widget
            text: " "
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    if @topbar.widgets.taglist.visible
                        @topbar.widgets.taglist.visible = false
                        @topbar.widgets.taglist_full.visible = true
                        @topbar.widgets.expandtags.text == " "
                    else
                        @topbar.widgets.taglist.visible = true
                        @topbar.widgets.taglist_full.visible = false
                        @topbar.widgets.expandtags.text == " "
                    @topbar.widgets.expandtags\emit_signal "widget::redraw_needed"
            }

        archlogolauncher: wibox.widget
            markup:  '<span color="brown"> </span><span color="black"> </span><span color="blue"> </span>'
            widget:  wibox.widget.textbox
            buttons: {awful.button {}, 1, -> awful.spawn "#{i3blocksassets}/archlogo"}

        userhost: wibox.widget
            markup:  "<span color=\"blue\">#{os.getenv"USER"}@#{shell"hostname"}</span>"
            widget:  wibox.widget.textbox
            buttons: {awful.button {}, 1, -> awful.spawn "prime-run nemo Desktop"}

        audio: wibox.widget
            markup:  ""
            widget:  wibox.widget.textbox
            buttons: [awful.button({}, b, -> @topbar.widgets.audio.markup = @topbar.helpers.updateaudio b) for b in *{1, 2, 3, 4, 5}]

        mic: wibox.widget
            markup:  ""
            widget:  wibox.widget.textbox
            buttons: [awful.button({}, b, -> @topbar.widgets.mic.markup = @topbar.helpers.updatemic b) for b in *{1, 2, 3, 4, 5}]

        eth: wibox.widget
            markup:  ""
            widget:  wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    text = shell "ip link show dev eno1"
                        noempty: true
                        removegarbage: true
                    showpopup(text).visible = true
            }

        internet: wibox.widget
            markup: ""
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    text = shell "ip addr show dev eno1"
                        noempty: true
                        removegarbage: true
                    showpopup(text).visible = true
            }

        vpn: wibox.widget
            markup: ""
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    text = shell "nordvpn status",
                        noempty: true
                        removegarbage: true
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
                @topbar.widgets.expandtags
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

    ---------------------
    -- Top bar updates --

    gears.timer
        autostart: true
        call_now:  true
        timeout:   1
        callback:  -> @topbar.widgets.audio.markup = @topbar.helpers.updateaudio!

    gears.timer
        autostart: true
        call_now:  true
        timeout:   1
        callback:  -> @topbar.widgets.mic.markup = @topbar.helpers.updatemic!

    gears.timer
        autostart: true
        call_now:  true
        timeout:   5
        callback:  -> @topbar.widgets.eth.markup = @topbar.helpers.updateeth!

    gears.timer
        autostart: true
        call_now:  true
        timeout:   10
        callback:  -> @topbar.widgets.internet.markup = shell "#{i3blocksassets}/internet.sh"

    gears.timer
        autostart: true
        call_now:  true
        timeout:   5
        callback:  -> @topbar.widgets.vpn.markup = @topbar.helpers.updatevpn!

    ----------------------------------------------------------------------------
    -- Bottom bar

    @bottombar =
        helpers:
            updateloadavg: =>
                with io.popen "#{i3blocksassets}/loadavg.awk"
                    res = \read"*l"
                    \close!
                    return res

    @bottombar.widgets =
        reloadbt: wibox.widget
            markup: '<span size="large" color="#aaff00">♼</span>'
            widget: wibox.widget.textbox
            buttons: {awful.button {}, 1, -> awful.spawn "dex #{gears.filesystem.get_xdg_config_home!}/autostart/Scripts.desktop"}

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
            markup: @bottombar.helpers.updateloadavg!
            widget: wibox.widget.textbox
            buttons: {awful.button {}, 1, -> awful.spawn "#{terminal} -e btop"}

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
                @bottombar.widgets.reloadbt
                wibox.widget.textbox" "
            }
            @bottombar.widgets.taskbar
            {
                layout: wibox.layout.fixed.horizontal
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
        timeout:   5
        callback:  -> @bottombar.widgets.loadavg.markup = @bottombar.helpers.updateloadavg!
