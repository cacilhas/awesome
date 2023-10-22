local *

awful = require"awful"


--------------------------------------------------------------------------------
-- Tag layout

-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal "request::default_layouts", ->
    with awful.layout
        .append_default_layouts with .suit
            return {
                .floating
                -- .tile
                -- .tile.left
                -- .tile.bottom
                -- .tile.top
                .fair
                -- .fair.horizontal
                -- .spiral
                -- .spiral.dwindle
                .max
                .max.fullscreen
                -- .magnifier
                -- .corner.nw
            }
