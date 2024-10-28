awful = require'awful'


callback = (stdout) =>
    value = stdout\gmatch'temp1: *([^ \n]+)'!
    @markup = "<span size=\"x-small\">#{value}</span>" if value


--------------------------------------------------------------------------------
-> awful.widget.watch 'sensors', 15, callback
