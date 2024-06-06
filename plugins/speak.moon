local *

awful = require"awful"
wibox = require"wibox"
import filesystem from require"gears"

nospeak_cache = "#{filesystem.get_xdg_cache_home!}/.nospeak"
_G.nospeak = true == filesystem.file_readable nospeak_cache if _G.nospeak == nil

callback = =>
    if _G.nospeak
        @markup = '<span color="#aa6666"></span>'
    else
        @markup = '<span color="#4444ff">🗣</span>'


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'true', 1, callback

    bg: '#00000000'
    widget: wibox.container.background
    buttons: {
        awful.button {}, 1, ->
            _G.nospeak = not _G.nospeak
            if _G.nospeak
                awful.spawn.with_shell "touch #{nospeak_cache}"
            else
                awful.spawn.with_shell "rm -f #{nospeak_cache}"
    }
}
