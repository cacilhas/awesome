awful = require"awful"


--------------------------------------------------------------------------------
(cmd, cb) ->
    if cmd == "switch"
        _G.nospeak = not _G.nospeak
        if _G.nospeak
            awful.spawn.with_shell "touch #{_G.nospeak_cache}"
        else
            awful.spawn.with_shell "rm -f #{_G.nospeak_cache}"

    if _G.nospeak
        cb '<span color="#ff4444">🗢 </span>'
    else
        cb '<span color="#4444ff">🗣</span>'
