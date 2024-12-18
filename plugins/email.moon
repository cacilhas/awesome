local *

awful = require'awful'
wibox = require'wibox'
theme = require'beautiful'
import showpopup, trim from require'helpers'

callback = =>
    inbox = os.getenv'MAIL' or "/var/spool/mail/#{os.getenv'USER'}"
    mails = 0
    for line in io.lines inbox
        mails += 1 if line\startswith'Received:'

    @markup = if mails == 0
        "✉"
    else
        "<span color=\"#{theme.warn}\">✉ #{mails}</span>"


--------------------------------------------------------------------------------
-> wibox.widget {
    awful.widget.watch 'true', 2, callback

    bg: '#00000000'
    widget: wibox.container.background
    buttons: {
        awful.button {}, 1, ->
            showpopup('Run mutt to list emails').visible = true
    }
}
