local *

awful = require'awful'
ruled = require'ruled'


--------------------------------------------------------------------------------
--- Rules

ruled.client.connect_signal 'request::rules', ->
    ----------------------------------------------------------------------------
    -- All clients’ rules

    ruled.client.append_rule
        id: 'global'
        rule: {}
        properties:
            focus:     awful.client.focus.filter
            raise:     true
            screen:    awful.screen.preferred
            placement: awful.placement.no_overlap + awful.placement.no_offscreen

    ruled.client.append_rule
        id: 'desktop'
        rule:
            type: 'desktop'
        properties:
            sticky: true
            placement: awful.placement.top_right
            border_width:      0
            titlebars_enabled: false

    -- Floating clients.
    ruled.client.append_rule
        id: 'floating'
        rule_any:
            --instance: {'copyq', 'pinentry'}
            class: {
                '^archlogo$'
                '^Audacious$'
                '^Clock$'
                '^Cairo%-dock'
                '^Catclock$'
                '^dde%-calendar$'
                '^Display$'
                '^Droidcam'
                '^FLTK$'
                '^Free42$'
                '^GDevelop'
                '^Guake'
                '^i3quitdialog'
                '^java%-lang%-'
                '^memory$'
                '^Nemo$'
                '^Pavucontrol$'
                '^Pcmanfm$'
                '^plasma%.emojier$'
                '^processing%-core%-'
                '^Toplevel$'
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
            role: {'pop-up'}
        except_any:
            name: { -- Clock has its own management
                'Kodumaro Clock'
                'kodumaro-clock'
            }
        properties:
            floating: true
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
                '^Celestia$'
                '^kstars$'
                '^stellarium$'
                '^XEphem$'
            }
        properties:
            fullscreen:     true
            switch_to_tags: true
            new_tag:
                name:     ' '
                layout:   awful.layout.suit.max.fullscreen
                volatile: true

    ruled.client.append_rule
        id: 'audacious'
        rule:
            class: 'Audacious'
        properties:
            request_no_titlebar: true
            tag:                 awful.tag.find_by_name nil, ' '
            switch_to_tags:      true
            skip_taskbar:        true

    ruled.client.append_rule
        id: 'audio'
        rule_any:
            class: {
                '^Audacity$'
                '^Hydrogen$'
                '^Spotify'
            }
        properties:
            maximized:      true
            tag:            awful.tag.find_by_name nil, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'emu'
        rule_any:
            class: {
                '^Qemu%-system'
                '^Virt%-manager'
            }
        properties:
            fullscreen:     true
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
            tag:            awful.tag.find_by_name nil, ' '
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
                '^magnet%-ball$'
                '^Nonogram$'
                '^stella$'
                '^roblox'
                '^tic80$'
                '^org%.tuxemon%.Tuxemon'
            }
        properties:
            fullscreen:     true
            switch_to_tags: true
            tag:            awful.tag.find_by_name nil, ' '

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
                '^com%.defold%.editor'
                '^GDevelop'
                '^Godot'
                '^TrenchBroom$'
                '^turbowarp%-desktop$'
                '^UnrealEditor'
            }
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, ' '
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
                '^goneovim'
                '^jetbrains%-'
                '^Processing$'
                '^Whireshark$'
            }
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'lazarus'
        rule:
            class: '^Lazarus$'
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, ' '
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
            tag:            awful.tag.find_by_name nil, ' '
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
            tag:            awful.tag.find_by_name nil, ' '
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
            tag:            awful.tag.find_by_name nil, ' '
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
            maximized:      true
            tag:            awful.tag.find_by_name nil, ' '
            switch_to_tags: true

    ruled.client.append_rule
        id: 'squeak'
        rule:
            class: '^Squeak$'
        properties:
            fullscreen:     true
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
            tag:            awful.tag.find_by_name nil, ' '
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
            tag:            awful.tag.find_by_name nil, ' '
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
            }
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, ' '
            switch_to_tags: true
            placement: awful.placement.centered

    ruled.client.append_rule
        id: 'wwww-browser'
        rule_any:
            class: {
                '^betterbird$'
                '^librewolf$'
                '^Mailspring$'
                '^obsidian'
                '^QtTube$'
                '^thunderbird$'
                '^Slimjet$'
                '^Tor Browser$'
                '^Vivaldi'
            }
            role: {'^browser$'}
        properties:
            maximized:         true
            border_width:      0
            titlebars_enabled: false
            tag:               awful.tag.find_by_name nil, ' '
            switch_to_tags:    true

    ruled.client.append_rule
        id: 'LLM'
        rule:
            class: '^llama%-desktop'
        properties:
            fullscreen:     true
            switch_to_tags: true
            new_tag:
                name:     '🦙'
                layout:   awful.layout.suit.max.fullscreen
                volatile: true


--------------------------------------------------------------------------------
--- Maximisation and fullscreen rules

client.connect_signal 'property::maximized', =>
    if @maximized
        s = @screen
        topbargeom = s.topbar\geometry!
        @\geometry
            x:      s.geometry.x
            y:      topbargeom.height
            width:  s.geometry.width
            height: s.geometry.height - topbargeom.height

client.connect_signal 'property::fullscreen', =>
    @screen.bottombar.visible = not @fullscreen if @focus

client.connect_signal 'focus', =>
    s = @screen
    if @fullscreen
        s.bottombar.visible = false
    else
        s.bottombar.visible = true
        s.bottombar.y = s.geometry.height - 2
    if @maximized
        x = s.geometry.x
        y = s.geometry.y + s.topbar.height
        width = s.geometry.width
        height = s.geometry.height - y
        @\geometry :x, :y, :width, :height

client.connect_signal 'unfocus', =>
    s = @screen
    s.bottombar.visible = true
    s.bottombar.y = s.geometry.height - 2
