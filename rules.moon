local *

awful = require"awful"
ruled = require"ruled"
naughty = require"naughty"


--------------------------------------------------------------------------------
--- Rules

ruled.client.connect_signal "request::rules", ->
    ----------------------------------------------------------------------------
    -- All clients’ rules

    ruled.client.append_rule
        id: "global"
        rule: {}
        properties:
            focus:     awful.client.focus.filter
            raise:     true
            screen:    awful.screen.preferred
            placement: awful.placement.no_overlap + awful.placement.no_offscreen

    -- Floating clients.
    ruled.client.append_rule
        id: "floating"
        rule_any:
            --instance: {"copyq", "pinentry"}
            class: {
                "^archlogo$"
                "^Clock$"
                "^Cairo-dock"
                "^Catclock$"
                "^dde-calendar$"
                "^Display$"
                "^Droidcam"
                "^FLTK$"
                "^Free42$"
                "^GDevelop"
                "^Guake"
                "^i3quitdialog"
                "^java-lang-"
                "^Nemo$"
                "^plasma%.emojier$"
                "^processing-core-"
                "^Toplevel$"
                "^XCalc$"
                "^XEyes$"
                "^xchomp$"
                "^XTerm$"
                "^Yad$"
            }
            type: {
                "dialog"
                "splash"
                "utility"
            }
            name: {
                "Event Tester"  -- xev.
            }
            role: {"pop-up"}
        except_any:
            name: { -- Clock has its own management
                "Kodumaro Clock"
                "kodumaro-clock"
            }
        properties:
            floating: true
            placement: awful.placement.centered

    ruled.client.append_rule
        id: "unframed"
        rule_any:
            class: {
                "^archlogo$"
                "^Clock$"
                "^Cairo-dock"
                "^Catclock$"
                "^dde-calendar$"
                "^Display$"
                "^Guake"
                "^i3quitdialog"
                "^XEyes$"
            }
            type: {"splash"}
            name: {
                "Kodumaro Clock"
                "kodumaro-clock"
            }
            role: {"pop-up"}
        properties:
            border_width:      0
            titlebars_enabled: false

    ruled.client.append_rule
        id: "titlebars"
        rule_any:
            type: {
                "normal"
                "dialog"
            }
        except_any:
            class: {
                "^archlogo$"
                "^Clock$"
                "^Cairo-dock"
                "^Catclock$"
                "^dde-calendar$"
                "^Display$"
                "^Guake"
                "^i3quitdialog"
                "^XEyes$"
            }
            name: {
                "Kodumaro Clock"
                "kodumaro-clock"
            }
            role: {"pop-up"}
            type: {"splash"}
        properties:
            titlebars_enabled: true

    ruled.client.append_rule
        id: "clock"
        rule_any:
            name: {
                "Kodumaro Clock"
                "kodumaro-clock"
            }
        properties:
            floating: true
            placement: awful.placement.top_right

    ruled.client.append_rule
        id: "xlock"
        rule:
            class: "^i3lock$"
        properties:
            fullscreen: true

    ----------------------------------------------------------------------------
    -- Per-application properties

    ruled.client.append_rule
        id: "astro"
        rule_any:
            class: {
                "^stellarium$"
                -- TODO: Celestia
                -- TODO: KStars
                -- TODO: Xephem
            }
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, " "
            switch_to_tags: true

    ruled.client.append_rule
        id: "audio"
        rule_any:
            class: {
                "^Audacity$"
                "^Hydrogen$"
                "^Spotify"
            }
        properties:
            maximized:      true
            tag:            awful.tag.find_by_name nil, " "
            switch_to_tags: true
    ruled.client.append_rule
        id: "emu"
        rule_any:
            class: {
                "^Qemu-system"
                "^Virt-manager"
            }
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, " "
            switch_to_tags: true


    ruled.client.append_rule
        id: "game"
        rule_any:
            class: {
                "^doѕbox"
                "^stella$"
                "^roblox"
                "^tic80$"
                "^org%.tuxemon%.Tuxemon"

    ruled.client.append_rule
        id: "cheese"
        rule:
            class: "^Cheese$"
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, " "
            switch_to_tags: true

            }
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, " "
            switch_to_tags: true

    ruled.client.append_rule
        id: "game-engine"
        rule_any:
            class: {
                "^com%.defold%.editor$"
                "^GDevelop"
                "^Godot"
                "^TrenchBroom$"
                "^turbowarp-desktop$"
                "^UnrealEditor"
            }
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, " "
            switch_to_tags: true

    ruled.client.append_rule
        id: "HP15C"
        rule:
            name: "H E W L E T T .*P A C K A R D 15C"
        properties:
            floating:  true
            placement: awful.placement.centered

    ruled.client.append_rule
        id: "ide"
        rule_any:
            class: {
                "^Code$"
                "^code-oss$"
                "^DrRacket$"
                "^FreeCAD$"
                "^Gambas3$"
                "^jetbrains-idea"
                "^Processing$"
                "^Whireshark$"
            }
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, " "
            switch_to_tags: true

    ruled.client.append_rule
        id: "im"
        rule_any:
            class: {
                "^discord$"
                "^Franz$"
                "^Hexchat$"
                "^Pop$"
                "^Slack$"
                "^TelegramDesktop$"
                "^Tuple$"
                "^Whalebird$"
                "^Whatsapp"
                "^whatsapp"
                "^Youp$"
                "^zoom$"
            }
        properties:
            tag:                  awful.tag.find_by_name nil, " "
            switch_to_tags:       true

    ruled.client.append_rule
        id: "image-manipulation"
        rule_any:
            class: {
                "^Gimp"
                "^kryta$"
                "^Inkscape$"
            }
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, " "
            switch_to_tags: true

    ruled.client.append_rule
        id: "office"
        rule_any:
            class: {
                "^Abiword$"
                "^Google Docs$"
                "^Gnumeric$"
                "^tm$"
            }
        properties:
            maximized:      true
            tag:            awful.tag.find_by_name nil, " "
            switch_to_tags: true

    ruled.client.append_rule
        id: "squeak"
        rule:
            class: "^Squeak$"
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, " " -- 
            switch_to_tags: true

    ruled.client.append_rule
        id: "steam"
        rule_any:
            class: {
                "^itch$"
                "^Steam"
                "^steam"
            }
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, " "
            switch_to_tags: true

    ruled.client.append_rule
        id: "terminal"
        rule_any:
            class: {
                "$cool-retro-term"
                "org%.wezfurlong%.wezterm"
                "kitty"
            }
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, " "
            switch_to_tags: true

    ruled.client.append_rule
        id: "video"
        rule_any:
            class: {
                "^Blender$"
                "^Cheese$"
                "^Droidcam$"
                "^kdenlive$"
                "^obs$"
            }
        properties:
            fullscreen:     true
            tag:            awful.tag.find_by_name nil, " "
            switch_to_tags: true

    ruled.client.append_rule
        id: "wwww-browser"
        rule_any:
            class: {
                "^librewolf$"
                "^Mailspring$"
                "^obsidian"
                "^Tor Browser$"
                "^Vivaldi"
            }
            role: {"^browser$"}
        properties:
            maximized:         true
            border_width:      0
            titlebars_enabled: false
            tag:               awful.tag.find_by_name nil, " "
            switch_to_tags:    true
