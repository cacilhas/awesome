awful = assert require'awful'
import geo from require'helpers'
awful.spawn "f.lux -l #{geo.lat} -g #{geo.lon} -k #{geo.temp}"
