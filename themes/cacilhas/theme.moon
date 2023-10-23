local *

awful         = assert require"awful"
theme_assets  = assert require"beautiful.theme_assets"
rnotification = assert require"ruled.notification"
import apply_dpi from assert require"beautiful.xresources"

-- themes_path = require"gears.filesystem".get_themes_dir!
themes_path = "#{awful.util.getdir"config"}/themes"

-- Set different colors for urgent notifications.
rnotification.connect_signal "request::rules", ->
    rnotification.append_rule
        rule: {urgency: "critical"}
        properties:
            bg: "#900000"
            fg: "#ffffff"

taglist_square_size = apply_dpi 4
bg_focus    = "#2aa198"
bg_normal   = "#002b36"
bg_urgent   = "#900000"
bg_minimize = "#5f676a"
bg_systray  = bg_normal

fg_focus    = "#1b0e00"
fg_normal   = "#888888"
fg_urgent   = "#ffff00"
fg_minimize = "#ffffff"

{
    -- BASICS
    font: "Bellota 14"
    :bg_focus, :bg_normal, :bg_urgent, :bg_minimize, :bg_systray
    :fg_focus, :fg_normal, :fg_urgent, :fg_minimize

    useless_gap:  apply_dpi 0
    border_width: apply_dpi 2
    border_color_normal: "#15514c"
    border_color_active: "#95d0cc"
    border_color_marked: "#2f343a"

    -- IMAGES
    layout_fairh: "#{themes_path}/cacilhas/layouts/fairh.png"
    layout_fairv: "#{themes_path}/cacilhas/layouts/fairv.png"
    layout_floating: "#{themes_path}/cacilhas/layouts/floating.png"
    layout_magnifier: "#{themes_path}/cacilhas/layouts/magnifier.png"
    layout_max: "#{themes_path}/cacilhas/layouts/max.png"
    layout_fullscreen: "#{themes_path}/cacilhas/layouts/fullscreen.png"
    layout_tilebottom: "#{themes_path}/cacilhas/layouts/tilebottom.png"
    layout_tileleft: "#{themes_path}/cacilhas/layouts/tileleft.png"
    layout_tile: "#{themes_path}/cacilhas/layouts/tile.png"
    layout_tiletop: "#{themes_path}/cacilhas/layouts/tiletop.png"
    layout_spiral: "#{themes_path}/cacilhas/layouts/spiral.png"
    layout_dwindle: "#{themes_path}/cacilhas/layouts/dwindle.png"
    layout_cornernw: "#{themes_path}/cacilhas/layouts/cornernw.png"
    layout_cornerne: "#{themes_path}/cacilhas/layouts/cornerne.png"
    layout_cornersw: "#{themes_path}/cacilhas/layouts/cornersw.png"
    layout_cornerse: "#{themes_path}/cacilhas/layouts/cornerse.png"

    awesome_icon: "#{themes_path}/cacilhas/awesome-icon.png"
    exit_icon: "#{themes_path}/cacilhas/exit.png"

        -- from default for now...
    menu_submenu_icon: "#{themes_path}/cacilhas/submenu.png"

        -- Generate taglist squares:
    taglist_squares_sel:   theme_assets.taglist_squares_sel   taglist_square_size, fg_normal
    taglist_squares_unsel: theme_assets.taglist_squares_unsel taglist_square_size, fg_normal

        -- MISC
    wallpaper: "#{themes_path}/cacilhas/sky-background.png"
    recycle: "#{themes_path}/cacilhas/recycle.png"
    system_logo: "#{themes_path}/cacilhas/system-logo.png"
    taglist_squares: "true"
    titlebar_close_button: "true"
    menu_height: apply_dpi 24
    menu_width:  apply_dpi 200

        -- Define the image to load
    titlebar_close_button_normal: "#{themes_path}/cacilhas/titlebar/close_normal.png"
    titlebar_close_button_focus:  "#{themes_path}/cacilhas/titlebar/close_focus.png"

    titlebar_minimize_button_normal: "#{themes_path}/cacilhas/titlebar/minimize_normal.png"
    titlebar_minimize_button_focus:   "#{themes_path}/cacilhas/titlebar/minimize_focus.png"

    titlebar_ontop_button_normal_inactive: "#{themes_path}/cacilhas/titlebar/ontop_normal_inactive.png"
    titlebar_ontop_button_focus_inactive:  "#{themes_path}/cacilhas/titlebar/ontop_focus_inactive.png"
    titlebar_ontop_button_normal_active:   "#{themes_path}/cacilhas/titlebar/ontop_normal_active.png"
    titlebar_ontop_button_focus_active:    "#{themes_path}/cacilhas/titlebar/ontop_focus_active.png"

    titlebar_sticky_button_normal_inactive: "#{themes_path}/cacilhas/titlebar/sticky_normal_inactive.png"
    titlebar_sticky_button_focus_inactive:  "#{themes_path}/cacilhas/titlebar/sticky_focus_inactive.png"
    titlebar_sticky_button_normal_active:   "#{themes_path}/cacilhas/titlebar/sticky_normal_active.png"
    titlebar_sticky_button_focus_active:    "#{themes_path}/cacilhas/titlebar/sticky_focus_active.png"

    titlebar_floating_button_normal_inactive: "#{themes_path}/cacilhas/titlebar/floating_normal_inactive.png"
    titlebar_floating_button_focus_inactive:  "#{themes_path}/cacilhas/titlebar/floating_focus_inactive.png"
    titlebar_floating_button_normal_active:   "#{themes_path}/cacilhas/titlebar/floating_normal_active.png"
    titlebar_floating_button_focus_active:    "#{themes_path}/cacilhas/titlebar/floating_focus_active.png"

    titlebar_maximized_button_normal_inactive: "#{themes_path}/cacilhas/titlebar/maximized_normal_active.png"
    titlebar_maximized_button_focus_inactive:  "#{themes_path}/cacilhas/titlebar/maximized_focus_active.png"
    titlebar_maximized_button_normal_active:   "#{themes_path}/cacilhas/titlebar/maximized_normal_active.png"
    titlebar_maximized_button_focus_active:    "#{themes_path}/cacilhas/titlebar/maximized_focus_active.png"
}
