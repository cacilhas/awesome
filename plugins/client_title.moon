local *

awful = require'awful'
wibox = require'wibox'
gears = require'gears'


callback = ->
    if client and client.focus
        clienticon[1] = awful.widget.clienticon client.focus
        clienttitle.text = client.focus.name
    else
        clienticon[1] = nil
        clienttitle.text = ''


--------------------------------------------------------------------------------
clienticon = {
    widget: wibox.container.margin
}

clienttitle = {
    text:   ''
    widget: wibox.widget.textbox
}


->
    _G.titletimer\stop! if _G.titletimer
    _G.titletimer = gears.timer
        autostart: true
        call_now:  true
        timeout:   0.5
        :callback

    wibox.widget {
        clienticon
        clienttitle
        layout: wibox.layout.align.horizontal
    }
