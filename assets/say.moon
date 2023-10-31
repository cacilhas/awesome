local *

awful = require"awful"
import filesystem from require"gears"


--------------------------------------------------------------------------------
(urgency) =>
    if @\match "^%[%["
        voice = if urgency == "critical" then "Demonic" else "belinda"
        awful.spawn "espeak -ven+#{voice} -k20 \"#{@}\""
    else
        awful.spawn.easy_async_with_shell "#{filesystem.get_configuration_dir!}/assets/langit \"#{@}\"", (res) ->
            it = res\gmatch"[^\n]+"
            res = it!
            voice = if urgency == "critical"
                "Demonic"
            elseif res == "English"
                "belinda"
            else
                "anika"
            lang = if res == "English" then "en" else "pt-BR"
            message = @\gsub '"', ""
            awful.spawn "espeak -v#{lang}+#{voice} -k20 \"#{message}\""
