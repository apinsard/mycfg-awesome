local wibox = require("wibox")
local awful = require("awful")

local volume_plugin = {}

volume_plugin.wibox = wibox.widget.textbox()

volume_plugin.update = function(cmd)
    local loMixer = awful.util.pread("amixer s" .. cmd .. " | tail -n1")
    local loMute  = string.match(loMixer, "%[(off)%]")
    local loPcent = string.match(loMixer, "%[(%d+)%%%]")
    local loText  = " <span color='#6495ed'>Vol</span><span color='#454545'>|</span>"

    if loMute == "off" then
        loText = loText .. "<span color='#ff4545'>Ø</span>"
    else
        loText = loText .. loPcent .. "%"
    end

    volume_plugin.wibox:set_markup(loText .. " ")
end

volume_plugin.startup = function()
    volume_plugin.update('get Master')
end

volume_plugin.keys = awful.util.table.join(
    awful.key({'Mod4' }, "F6", function ()
        volume_plugin.update('set Master 5%+')
    end),
    awful.key({'Mod4' }, "F5", function ()
        volume_plugin.update('set Master 10%-')
    end),
    awful.key({'Mod4' }, "F3", function ()
        volume_plugin.update('set Master toggle')
    end)
)

return volume_plugin
