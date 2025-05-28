local *

import notify from assert require'notifications'
import filesystem from require'gears'

startup = "#{filesystem.get_configuration_dir!}/startup"

showerror = => (message) ->
    notify
        urgency: 'critical'
        title:   "error loading startup script “#{@}”"
        :message

status, list = pcall io.popen, "ls #{startup}/*.lua"

if status
    for filename in list\lines!
        key = filename\sub 1, #filename - 4
        key = key\gsub '^.*/', ''
        name = "startup.#{key}"
        key = key\gsub '%-', '_'
        unless key == 'init'
            startup = -> assert require name
            xpcall startup, showerror name
    list\close!

else
    showerror list
