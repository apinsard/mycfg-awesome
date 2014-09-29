local wibox = require("wibox")
local awful = require("awful")

mysoundvolume = {}

mysoundvolume.wibox = wibox.widget.textbox()

mysoundvolume.update = function(cmd)
    local loMixer = awful.util.pread("amixer s" .. cmd .. " | tail -n1")
    local loMute  = string.match(loMixer, "%[(off)%]")
    local loPcent = string.match(loMixer, "%[(%d+)%%%]")
    local loText  = " <span color='#6495ed'>Vol</span><span color='#454545'>|</span>"

    if loMute == "off" then
        loText = loText .. "<span color='#ff4545'>Ø</span>"
    else
        loText = loText .. loPcent .. "%"
    end

    mysoundvolume.wibox:set_markup(loText .. " ")
end

mysoundvolume.startup = function()
    mysoundvolume.update('get Master')
end

mysoundvolume.keys = awful.util.table.join(
    awful.key({'Mod4' }, "F6", function ()
        mysoundvolume.update('set Master 5%+')
    end),
    awful.key({'Mod4' }, "F5", function ()
        mysoundvolume.update('set Master 10%-')
    end),
    awful.key({'Mod4' }, "F3", function ()
        mysoundvolume.update('set Master toggle')
    end)
)

return mysoundvolume
