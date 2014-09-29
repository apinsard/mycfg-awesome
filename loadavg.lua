local wibox = require("wibox")
local awful = require("awful")

local loadavg_plugin = {}

loadavg_plugin.wibox = wibox.widget.textbox()

loadavg_plugin.update = function()
    local loLoad   = tostring(tonumber(awful.util.pread("cat /proc/loadavg | cut -d' ' -f1")))
    local loNbProc = awful.util.pread("cat /proc/cpuinfo | grep processor | wc -l")
    local loText   = "<span color='#6495ed'>Load</span><span color='#454545'>|</span>"

    if tonumber(loLoad) > tonumber(loNbProc) then
        loText = loText .. "<span color='#ff4545'>" .. loLoad .. "</span>"
    else
        loText = loText .. loLoad
    end

    loadavg_plugin.wibox:set_markup(loText .. " ")
end

loadavg_plugin.startup = function()
    loadavg_plugin.update()
    loadavg_plugin.timer:connect_signal("timeout", loadavg_plugin.update)
    loadavg_plugin.timer:start()
end

loadavg_plugin.timer = timer({ timeout = 60 })

return loadavg_plugin
