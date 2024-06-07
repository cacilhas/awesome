local *

awful = require'awful'
wibox = require'wibox'
import prevtag, nexttag, withmargin from require'helpers'


--------------------------------------------------------------------------------
=>
    local taglist
    taglist =
        short: awful.widget.taglist {
            screen:  @
            filter:  awful.widget.taglist.filter.noempty
            buttons: {
                awful.button {},       1, => @\view_only!
                awful.button {'Mod4'}, 1, (=> client.focus\move_to_tag @ if client.focus)
                awful.button {},       3, awful.tag.viewtoggle
                awful.button {'Mod4'}, 3, (=> client.focus\toggle_tag @ if client.focus)
                awful.button {},       4, => prevtag @screen
                awful.button {},       5, => nexttag @screen
            }
        }

        long: awful.widget.taglist {
            screen:  @
            filter:  awful.widget.taglist.filter.all
            buttons: {
                awful.button {},       1, => @\view_only!
                awful.button {'Mod4'}, 1, (=> client.focus\move_to_tag @ if client.focus)
                awful.button {},       3, awful.tag.viewtoggle
                awful.button {'Mod4'}, 3, (=> client.focus\toggle_tag @ if client.focus)
                awful.button {},       4, => awful.tag.viewprev @screen
                awful.button {},       5, => awful.tag.viewnext @screen
            }
        }

        button: wibox.widget
            markup: ' <span color="#00c838"></span>'
            widget: wibox.widget.textbox
            buttons: {
                awful.button {}, 1, ->
                    with taglist
                        if .short.visible
                            .short.visible = false
                            .long.visible = true
                            .button.markup = '| <span color="#ffbd2f"></span>'
                        else
                            .short.visible = true
                            .long.visible = false
                            .button.markup = ' <span color="#00c838"></span>'
            }

    with taglist
        .short.visible = true
        .long.visible = false

    wibox.widget {
        taglist.short
        taglist.long
        withmargin taglist.button, margin: 4, right: 8, hijack: true

        layout: wibox.layout.align.horizontal
    }
