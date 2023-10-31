local *

awful = require"awful"
import filesystem from require"gears"


--------------------------------------------------------------------------------
=>
    if @\match "^%[%["
        awful.spawn "espeak -ven+belinda -k20 \"#{@}\""
    else
        awful.spawn.easy_async_with_shell "#{filesystem.get_configuration_dir!}/assets/langit \"#{@}\" | head -1", (res) ->
            if res == "English"
                awful.spawn "espeak -ven+belinda -k20 \"#{@}\""
            else
                awful.spawn "espeak -vpt-BR+anika -k20 \"#{@}\""
