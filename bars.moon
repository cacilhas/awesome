local *

gears = require'gears'
awful = require'awful'
wibox = require'wibox'
theme = require'beautiful'
plugins = require'plugins'
glib = require('lgi').GLib
import call from gears.protected_call

import withmargin, wrap from require'helpers'
import mainlauncher from require'menus'


--------------------------------------------------------------------------------
--- Wibar

-- Keyboard map indicator and switcher
--keyboardlayout = awful.widget.keyboardlayout!

screen.connect_signal 'request::desktop_decoration', =>
    awful.tag {
        ' '
        ' '
        ' '
        ' '
        ' '
        ' '
        -- ' '
        ' ' -- 
        -- ' '
        -- ' '
        ' '
    }, @, awful.layout.suit.floating

    -- with awful
    --     .tag.find_by_name(s, ' ').layout = .layout.suit.max
    --     .tag.find_by_name(s, ' ').layout = .layout.suit.max.fullscreen


    ----------------------------------------------------------------------------
    -- Top bar

    sep = {
        text:   ' '
        font:   'monospace 12'
        widget: wibox.widget.textbox
    }

    @prompt = awful.widget.prompt!
    @topbar = awful.wibar
        position: 'top'
        opacity:  0.8
        screen:   @
        widget:   {
            layout: wibox.layout.align.horizontal
            {
                layout: wibox.layout.fixed.horizontal
                call plugins.taglist, @
                @prompt
            }
            plugins.client_title @
            {
                layout: wibox.layout.fixed.horizontal
                call plugins.archlogo
                wrap call plugins.hostname
                wrap call plugins.downloads
                wrap call plugins.speak
                call plugins.camera
                wrap call plugins.temperature
                wrap call plugins.audio
                wrap call plugins.mic
                withmargin call(plugins.connectivity), left: 8, right: 4
                wrap call plugins.ethernet
                call plugins.notif
                sep
                call plugins.games
                call plugins.browser
                call plugins.obsidian
                call plugins.radio
                wibox.widget.systray
                awful.widget.layoutbox {
                    screen:  @
                    buttons: {
                        awful.button {}, 1, -> awful.layout.inc  1
                        awful.button {}, 3, -> awful.layout.inc -1
                        awful.button {}, 4, -> awful.layout.inc -1
                        awful.button {}, 5, -> awful.layout.inc  1
                    }
                }
            }
        }


    ----------------------------------------------------------------------------
    -- Bottom bar

    bb_height = 64
    bb_y = @geometry.height - bb_height - 16
    tween =
        tic: 1
        speed: 2

    @bottombar = awful.wibar
        position: 'bottom'
        opacity:  1
        bg:       theme.bg_normal\sub(1, 7) .. 'a0'
        width:    @geometry.width * 0.75
        height:   bb_height
        x:        @geometry.width * 0.375
        y:        @geometry.height - 2
        ontop:    true
        shape:    gears.shape.rounded_rect
        screen:   @
        struts:   ->
            top: 0, bottom: 0
            left: 0, right: 0
        widget:   {
            layout: wibox.layout.align.horizontal
            {
                layout: wibox.layout.fixed.horizontal
                withmargin mainlauncher, left: 8, right: 8
            }
            withmargin plugins.taskbar(@), left: 4, top: 8, bottom: 8
            {
                layout: wibox.layout.fixed.horizontal
                withmargin call(plugins.bright), margin: 8
                withmargin call(plugins.termometer), margin: 8
                wrap call(plugins.email), margin: 8
                wrap call(plugins.loadavg), margin: 8
                wrap call(plugins.utc), margin: 8
                wrap call(plugins.clock), margin: 8
                call plugins.bt_quit
            }
        }


    -----------------------
    -- Bottom bar update --
    @bottombar.showup = =>
        return if @y == bb_y
        @visible = true
        @ontop = true

        glib.timeout_add glib.PRIORITY_DEFAULT, tween.tic, ->
            @y -= tween.speed if @y > bb_y
            if @y < bb_y
                @y = bb_y
            @y != bb_y

    @bottombar.hidedown = (bar) ->
        return @bottombar\showup! if @topbar.ontop  -- MENU button pressed
        clients = [c for c in *@clients when #c\tags! > 0 and not (c.hidden or c.minimized)]
        return @bottombar\showup! if #clients == 0

        return if (mouse.coords!.y or @geometry.height) > bb_y
        desired = @geometry.height - 1
        return if bar.y == desired

        glib.timeout_add glib.PRIORITY_DEFAULT, tween.tic, ->
            bar.y += tween.speed if bar.y < desired
            if bar.y >= desired
                bar.y = desired
                bar.visible = false if client.focus and client.focus.fullscreen
            bar.y != desired

    @bottombar.showntimer = gears.timer
        timeout: 0.25
        autostart: true
        call_now: true
        callback: ->
            return @bottombar\hidedown! if client.focus and client.focus.fullscreen
            :y = mouse.coords! or (@geometry.height / 2)
            return @bottombar\showup! if y > @geometry.height - 2
            return @bottombar\hidedown! if y < bb_y
