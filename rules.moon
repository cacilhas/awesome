local *

awful = require'awful'
ruled = require'ruled'


--------------------------------------------------------------------------------
--- Rules

ruled.client.connect_signal 'request::rules', ->
    ----------------------------------------------------------------------------
    -- General rules

    ruled.client.append_rule
        id: 'global'
        rule: {}
        properties:
            focus:     awful.client.focus.filter
            raise:     true
            screen:    awful.screen.preferred
            placement: awful.placement.no_overlap + awful.placement.no_offscreen

    with screen.primary
        nil  -- workaround Moonscript issue
        :width, :height = .geometry
        placement = (args) =>
            args.margins =
                left: 0
                right: 0
                top: .topbar\geometry!.height
                bottom: .bottombar\geometry!.height
            awful.placement.top_left @, args

        ruled.client.append_rule
            id: 'desktop'
            rule:
                type: 'desktop'
            properties:
                sticky: true
                below: true
                tags: {}
                :placement
                border_width: 0
                focus:             false
                titlebars_enabled: false

    -- Floating clients.
    ruled.client.append_rule
        id: 'floating'
        rule_any:
            --instance: {'copyq', 'pinentry'}
            class: {
                'contabilone-agent-installer'
                '^archlogo$'
                '^ark$'
                '^Audacious$'
                '^Clock$'
                '^Cairo%-dock'
                '^Catclock$'
                '^dde%-calendar$'
                '^Display$'
                '^Droidcam'
                '^FLTK$'
                '^Free42$'
                '^Guake'
                '^i3quitdialog'
                '^java%-lang%-'
                '^memory$'
                '^meteo-qt$'
                '^Nemo$'
                '^Pavucontrol$'
                '^Pcmanfm$'
                '^plasma%.emojier$'
                '^processing%-core%-'
                '^Toplevel$'
                '^Wish$'
                '^XCalc$'
                '^XEyes$'
                '^xchomp$'
                '^XTerm$'
                '^Yad$'
            }
            type: {
                'dialog'
                'splash'
                'utility'
            }
            name: {
                'Event Tester'  -- xev
            }
            role: {
                'pop-up'
            }
        except_any:
            name: { -- Clock has its own management
                'Kodumaro Clock'
                'kodumaro-clock'
            }
        properties:
            floating: true

    -- Sticky clients.
    ruled.client.append_rule
        id: 'floating'
        rule_any:
            --instance: {'copyq', 'pinentry'}
            class: {
                '^archlogo$'
                '^Clock$'
                '^Cairo%-dock'
                '^dde%-calendar$'
                '^Display$'
                '^Guake'
                '^i3quitdialog'
                '^Nemo$'
                '^Pcmanfm$'
                '^plasma%.emojier$'
                '^XCalc$'
                '^XEyes$'
            }
            name: {
                'Event Tester'  -- xev
            }
        except_any:
            name: { -- Clock has its own management
                'Kodumaro Clock'
                'kodumaro-clock'
            }
        properties:
            sticky:    true
            tags:      {}
            placement: awful.placement.centered

    ruled.client.append_rule
        id: 'unframed'
        rule_any:
            class: {
                '^archlogo$'
                '^Audacious$'
                '^Clock$'
                '^Cairo%-dock'
                '^Catclock$'
                '^dde%-calendar$'
                '^Display$'
                '^Guake'
                '^i3quitdialog'
                '^XEyes$'
            }
            type: {'splash'}
            name: {
                'Kodumaro Clock'
                'kodumaro-clock'
            }
            role: {'pop-up'}
        properties:
            border_width:      0
            titlebars_enabled: false

    ruled.client.append_rule
        id: 'titlebars'
        rule_any:
            type: {
                'normal'
                'dialog'
            }
        except_any:
            class: {
                '^archlogo$'
                '^Audacious$'
                '^Clock$'
                '^Cairo%-dock'
                '^Catclock$'
                '^dde%-calendar$'
                '^Display$'
                '^Guake'
                '^i3quitdialog'
                '^XEyes$'
            }
            name: {
                'Kodumaro Clock'
                'kodumaro-clock'
            }
            role: {'pop-up'}
            type: {'splash'}
        properties:
            titlebars_enabled: true

    ruled.client.append_rule
        id: 'clock'
        rule_any:
            name: {
                'Kodumaro Clock'
                'kodumaro-clock'
            }
        properties:
            floating: true
            sticky:   true
            tags: {}
            placement: awful.placement.top_right

    ruled.client.append_rule
        id: 'xlock'
        rule:
            class: '^i3lock$'
        properties:
            fullscreen: true


    ----------------------------------------------------------------------------
    -- Per-application properties

    ruled.client.append_rule
        id: 'astro'
        rule_any:
            class: {
                '^kstars$'
                '^stellarium$'
                '^XEphem$'
            }
        properties:
            floating:       false
            fullscreen:     true
            switch_to_tags: true
            new_tag:
                name:     ' '
                layout:   awful.layout.suit.floating
                volatile: true

    ruled.client.append_rule
        id: 'celestia'
        rule:
            class: '^Celestia$'
            name: '^Celestia$'
        properties:
            floating:       false
            fullscreen:     true
            switch_to_tags: true
            new_tag:
                name:     ' '
                layout:   awful.layout.suit.floating
                volatile: true

    ruled.client.append_rule
        id: 'celestia-popup'
        rule:
            class: '^Celestia$'
        except:
            name: '^Celestia$'
        properties:
            floating:       true
            fullscreen:     false
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'audacious'
        rule:
            class: 'Audacious'
        properties:
            request_no_titlebar: true
            floating:            false
            tag:                 awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags:      true
            skip_taskbar:        true

    ruled.client.append_rule
        id: 'audio'
        rule_any:
            class: {
                '^Audacity$'
                '^Hydrogen$'
                '^com%.github%.polymeilex%.neothesia$'
                '^Spotify'
            }
        properties:
            fullscreen:     true
            floating:       false
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'emu'
        rule_any:
            class: {
                '^Qemu%-system'
                '^Virt%-manager'
                '^VirtualBox'
            }
        properties:
            fullscreen:     true
            floating:       false
            switch_to_tags: true
            new_tag:
                name:     ' '
                layout:   awful.layout.suit.fair
                volatile: true

    ruled.client.append_rule
        id: 'cheese'
        rule:
            class: '^Cheese$'
        properties:
            fullscreen:     true
            floating:       false
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'games'
        rule_any:
            class: {
                '^airshipper$'
                '^Dfarc'
                '^doѕbox'
                '^freedink$'
                '^kpat$'
                '^kshisen$'
                '^LODERUNN.bin.x86_64$'
                '^magnet%-ball$'
                '^Nonogram$'
                '^stella$'
                '^roblox'
                '^tic80$'
                '^org%.tuxemon%.Tuxemon'
            }
        properties:
            fullscreen:     true
            floating:       false
            switch_to_tags: true
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '

    ruled.client.append_rule
        id: 'floating-window-games'
        rule_any:
            class: {
                '^rustzx'
            }
        properties:
            fullscreen:     false
            floating:       true
            switch_to_tags: true
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '

    ruled.client.append_rule
        id: 'nanpure'
        rule:
            class: '^nanpure$'
        properties:
            floating: true

    ruled.client.append_rule
        id: 'game-engine'
        rule_any:
            class: {
                '^Castle-editor'
                '^com%.defold%.editor'
                '^GDevelop'
                '^TrenchBroom$'
                '^turbowarp%-desktop$'
                '^UnrealEditor'
            }
        properties:
            fullscreen:     true
            floating:       false
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'godot'
        rule_any:
            class: '^Godot'
            instance: {
                '^Godot_Editor'
                '^Godot_Engine$'
            }
        properties:
            fullscreen:     false
            maximized:      false
            floating:       true
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'godot-editor-2'
        rule:
            class: '^Godot'
            instance: '^Godot_Engine'
        properties:
            fullscreen:     false
            maximized:      true
            floating:       true
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'HP15C'
        rule:
            name: 'H E W L E T T .*P A C K A R D 15C'
        properties:
            floating:  true
            placement: awful.placement.centered

    ruled.client.append_rule
        id: 'ide'
        rule_any:
            class: {
                '^Code$'
                '^code%-oss$'
                '^DrRacket$'
                '^ecode%.bin$'
                '^FreeCAD$'
                '^Gambas3$'
                '^jetbrains%-'
                '^lmms$'
                '^Processing$'
                '^Whireshark$'
                '^dev%.zed%.Zed$'
            }
        properties:
            fullscreen:     true
            floating:       false
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'non-fs-ide'
        rule_any:
            class: {
                '^Glade$'
                '^Lazarus$'
            }
            name: {
                '^Visual Tcl$'
                '^vTcl$'
            }
        properties:
            fullscreen:     false
            floating:       false
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            layout:         awful.layout.suit.floating
            switch_to_tags: true

    ruled.client.append_rule
        id: 'im'
        rule_any:
            class: {
                '^discord$'
                '^Franz$'
                '^Hexchat$'
                '^Pop$'
                '^rambox$'
                '^Slack$'
                '^TelegramDesktop$'
                '^Tuple$'
                '^Whalebird$'
                '^Whatsapp'
                '^whatsapp'
                '^Youp$'
                '^zoom$'
            }
        properties:
            floating:       false
            fullscreen:     true
            maximized:      false
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'image-manipulation'
        rule_any:
            class: {
                '^kryta$'
                '^Inkscape$'
                '^Spriter$'
            }
            role: {
                'gimp-image-window-1'
            }
        properties:
            floating:       false
            fullscreen:     true
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'gimp-windows'
        rule:
            class: '^Gimp'
        except:
            role: 'gimp-image-window-1'
        properties:
            floating:       true
            fullscreen:     false
            maximized:      false
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'graphite'
        rule:
            name: '^Graphite$'
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'office'
        rule_any:
            class: {
                '^Abiword$'
                '^Google Docs$'
                '^Gnumeric$'
                '^ONLYOFFICE'
                '^tm$'
            }
        properties:
            floating:       false
            maximized:      true
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'squeak'
        rule:
            class: '^Squeak$'
        properties:
            fullscreen:     true
            floating:       false
            switch_to_tags: true
            new_tag:
                name:     ' ' -- 
                layout:   awful.layout.suit.max.fullscreen
                volatile: true

    ruled.client.append_rule
        id: 'steam'
        rule_any:
            class: {
                '^itch$'
                '^Steam'
                '^steam'
            }
        properties:
            fullscreen:     true
            floating:       false
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'terminal'
        rule_any:
            class: {
                '^cool%-retro%-term'
                'kitty'
                'org%.wezfurlong%.wezterm'
                '^XTerm'
            }
        properties:
            fullscreen:     true
            floating:       false
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true
            placement: awful.placement.centered

    ruled.client.append_rule
        id: 'video'
        rule_any:
            class: {
                '^Blender$'
                '^Cheese$'
                '^Droidcam$'
                '^kdenlive$'
                '^obs$'
                '^Stremio$'
            }
        properties:
            fullscreen:     true
            floating:       false
            tag:            awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags: true
            placement: awful.placement.centered

    ruled.client.append_rule
        id: 'wayland'
        rule:
            class: '^Weston Compositor$'
        properties:
            floating:       false
            fullscreen:     true
            switch_to_tags: true
            new_tag:
                name:     ' '
                layout:   awful.layout.suit.floating
                volatile: true

    ruled.client.append_rule
        id: 'wwww-browser'
        rule_any:
            class: {
                '^eu%.betterbird%.Betterbird$'
                '^Element$'
                '^firefox$'
                '^Google-chrome$'
                '^HTTPie$'
                '^Jitsi Meet$'
                '^librewolf$'
                '^Mailspring$'
                '^Microsoft-edge$'
                '^obsidian'
                '^QtTube$'
                '^thunderbird$'
                '^Slimjet$'
                '^servo$'
                '^Tor Browser$'
                '^Vivaldi'
            }
            role: {'^browser$'}
        properties:
            maximized:         true
            floating:          false
            border_width:      0
            titlebars_enabled: false
            tag:               awful.tag.find_by_name awful.screen.focused!, ' '
            switch_to_tags:    true

    ruled.client.append_rule
        id: 'radio'
        rule:
            class: '^shortwave$'
        properties:
            sticky: true
            tags: {}
            border_width: 0
            floating:          false
            focus:             false
            ontop:             true
            titlebars_enabled: false

    ruled.client.append_rule
        id: 'LLM'
        rule:
            class: '^llama%-desktop'
        properties:
            fullscreen:     true
            floating:       false
            switch_to_tags: true
            new_tag:
                name:     '🦙'
                layout:   awful.layout.suit.max.fullscreen
                volatile: true


--------------------------------------------------------------------------------
--- Maximisation and fullscreen rules

client.connect_signal 'property::maximized', =>
    if @maximized
        with @screen
            topbargeom = .topbar\geometry!
            @\geometry
                x:      .geometry.x
                y:      topbargeom.height
                width:  .geometry.width
                height: .geometry.height - topbargeom.height

client.connect_signal 'property::fullscreen', =>
    @screen.bottombar.visible = not @fullscreen if @focus

client.connect_signal 'focus', =>
    with @screen
        if @fullscreen
            .bottombar.visible = false
        else
            .bottombar.visible = true
            .bottombar.y = .geometry.height - 1
        if @maximized
            x = .geometry.x
            y = .geometry.y + .topbar.height
            width = .geometry.width
            height = .geometry.height - y
            @\geometry :x, :y, :width, :height

client.connect_signal 'unfocus', =>
    with @screen
        .bottombar.visible = true
