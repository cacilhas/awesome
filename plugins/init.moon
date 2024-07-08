local *

import filesystem from require'gears'

plugins = "#{filesystem.get_configuration_dir!}/plugins"

module = {}
status, list = pcall io.popen, "ls #{plugins}/*.lua"

if status
    for filename in list\lines!
        key = filename\sub 1, #filename - 4
        key = key\gsub '^.*/', ''
        name = "plugins.#{key}"
        key = key\gsub '%-', '_'
        unless key == 'init'
            pcall -> module[key] = assert require name
    list\close!


--------------------------------------------------------------------------------
module
