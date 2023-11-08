local *

awful = require"awful"
import filesystem from require"gears"
import trim from require"helpers"


--------------------------------------------------------------------------------
process = =>
    res = ""
    for word in @\gmatch"%S+"
        res ..= " " .. word unless word\match"%w+%.%w+" or word\match"/"
    trim res


--------------------------------------------------------------------------------
(urgent) =>
    return if _G.nospeak

    if @\match "^%[%["
        voice = if urgent then "Demonic -k1" else "belinda -k20"
        awful.spawn "espeak -ven+#{voice} -s140 \"#{@}\""
    else
        awful.spawn.easy_async_with_shell "#{filesystem.get_configuration_dir!}/assets/langit \"#{process @}\"", (res) ->
            res = "English" unless res and #res > 0
            it = res\gmatch"[^\n]+"
            res = it!
            voice = if urgent
                "Demonic -k1"
            elseif res == "Portuguese"
                "anika -k20"
            else
                "belinda -k20"
            lang = switch res
                when "Portuguese"
                    "pt-BR"
                when "French"
                    "fr"
                else
                    "en"
            message = @\gsub '"', ""
            awful.spawn "espeak -v#{lang}+#{voice} -s140 \"#{message}\""
