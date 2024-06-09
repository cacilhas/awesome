local *

menubar = require'menubar'
awful   = require'awful'
theme   = require'beautiful'
wibox   = require'wibox'
import apply_dpi from require'beautiful.xresources'
import filesystem from require'gears'
import ddgo, moonprompt, reload, reloadscripts, redditsearch, terminal, kitty, xprop from require 'helpers'


--------------------------------------------------------------------------------
-- Menu
mainmenu = awful.menu
    items: {
        {
            'System'
            {
                {'Reboot', 'sudo reboot', '/usr/share/icons/breeze-dark/actions/32/edit-redo.svg'}
                {'Halt', 'sudo halt -p', '/usr/share/icons/breeze/actions/24/gtk-quit.svg'}
            }
            theme.system_logo
        }
        {
            'Awesome'
            {
                {'Manual', 'www-browser https://awesomewm.org/doc/api/', theme.awesome_icon}
                {'Reddit', redditsearch, theme.reddit_icon}
                { 'Command', moonprompt, '/usr/share/icons/breeze/apps/64/utilities-terminal.svg'}
                --{'Settings', 'kitty -- nvim -cNvimTreeFocus', '/usr/share/icons/breeze/apps/48/systemsettings.svg'}
                {widget: wibox.widget.separator}
                {'Reload Awesome', reload, '/usr/share/icons/breeze-dark/actions/32/edit-redo.svg'}
                {'Exit', -> awesome.quit!, '/usr/share/icons/breeze/actions/24/gtk-quit.svg'}
            }
            theme.awesome_icon
        }
        {
            'X11'
            {
                {"Xev", "#{terminal} -e xev"}
                {'Xprop', xprop}
                {'Terminal', kitty}
                {'dconf Editor', 'dconf-editor'}
                {widget: wibox.widget.separator}
                {'Font Selector', 'sel-font.sh'}
                {"Reload Desktop Icons", () -> awful.spawn.with_shell"#{filesystem.get_configuration_dir!}/assets/reload-idesk"}
                {"Reload Compositor", "fish #{filesystem.get_xdg_config_home!}/autostart-scripts/compositor.fish"}
                {widget: wibox.widget.separator}
                {'XKill', 'xkill'}
            }
            theme.xorg_icon
        }
        {widget: wibox.widget.separator}
        {'DuckDuckGo', ddgo, theme.ddgo_icon}
        {'Reload Scripts', reloadscripts, theme.recycle}
    }
    hide_on_unfocus: 5

mainlauncher = awful.widget.launcher
    image: theme.system_logo
    menu:  mainmenu

menubar.utils.terminal = terminal -- Set the terminal for applications that require it

desktopmenu = awful.menu
    theme:
        width: apply_dpi 300
    items: {
        {'Desktop', (->), theme.awesome_icon, widget: wibox.widget.textbox}
        {'Change current wallpaper', -> awful.screen.focused!\emit_signal 'request::wallpaper'}
        {'Change all wallpapers',    -> awesome.emit_signal 'request::wallpaper'}
        {
            'Layout'
            with awful.layout
                return {
                    {'Floating',   -> .set .suit.floating}
                    {'Tile',       -> .set .suit.fair}
                    {'Maximise',   -> .set .suit.max}
                    {'Fullscreen', -> .set .suit.max.fullscreen}
                }
        }
        {'Reload', reload}
    }

mainmenu\connect_signal    'mouse::leave', => @\hide!
desktopmenu\connect_signal 'mouse::leave', => @\hide!

{:mainmenu, :desktopmenu, :mainlauncher}
