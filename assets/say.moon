local *

awful = require"awful"
import filesystem from require"gears"

_G.nospeak_cache = "#{filesystem.get_xdg_cache_home!}/.nospeak"
if _G.nospeak == nil
    _G.nospeak = true == filesystem.file_readable _G.nospeak_cache


--------------------------------------------------------------------------------
(urgent) =>
    return if _G.nospeak

    if @\match "^%[%["
        voice = if urgent then "Demonic -k1" else "belinda -k20"
        awful.spawn "espeak -ven+#{voice} -s140 \"#{@}\""
    else
        awful.spawn.easy_async_with_shell "#{filesystem.get_configuration_dir!}/assets/langit \"#{@}\"", (res) ->
            it = res\gmatch"[^\n]+"
            res = it!
            voice = if urgent
                "Demonic -k1"
            elseif res == "English"
                "belinda -k20"
            else
                "anika -k20"
            lang = if res == "English" then "en" else "pt-BR"
            message = @\gsub '"', ""
            awful.spawn "espeak -v#{lang}+#{voice} -s140 \"#{message}\""
