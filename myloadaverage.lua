local wibox = require("wibox")
local awful = require("awful")

myloadaverage = {}

myloadaverage.wibox = wibox.widget.textbox()

myloadaverage.update = function()
    local loLoad   = tostring(tonumber(awful.util.pread("cat /proc/loadavg | cut -d' ' -f1")))
    local loNbProc = awful.util.pread("cat /proc/cpuinfo | grep processor | wc -l")
    local loText   = "<span color='#6495ed'>Load</span><span color='#454545'>|</span>"

    if tonumber(loLoad) > tonumber(loNbProc) then
        loText = loText .. "<span color='#ff4545'>" .. loLoad .. "</span>"
    else
        loText = loText .. loLoad
    end

    myloadaverage.wibox:set_markup(loText .. " ")
end

myloadaverage.startup = function()
    myloadaverage.update()
    myloadaverage.timer:connect_signal("timeout", myloadaverage.update)
    myloadaverage.timer:start()
end

myloadaverage.timer = timer({ timeout = 60 })

return myloadaverage
