awful = require"awful"
import filesystem from require"gears"


--------------------------------------------------------------------------------
nospeak_cache = "#{filesystem.get_xdg_cache_home!}/.nospeak"
_G.nospeak = true == filesystem.file_readable nospeak_cache if _G.nospeak == nil


--------------------------------------------------------------------------------
(cmd, cb) ->
    if cmd == "switch"
        _G.nospeak = not _G.nospeak
        if _G.nospeak
            awful.spawn.with_shell "touch #{nospeak_cache}"
        else
            awful.spawn.with_shell "rm -f #{nospeak_cache}"

    if _G.nospeak
        cb '<span color="#aa6666"></span>'
    else
        cb '<span color="#4444ff">🗣</span>'
