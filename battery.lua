local wibox = require("wibox")
local naughty = require("naughty")
local awful = require("awful")

local battery_plugin = {}

battery_plugin.wibox = wibox.widget.textbox()
battery_plugin.is_low = false

battery_plugin.update = function()
    local loBatt  = awful.util.pread("acpi -i | head -n1")
    local loState = string.match(loBatt, "^Battery %d: ([^,]+),")
    local loLoad  = string.match(loBatt, "^Battery %d: [^,]+, (%d+)%%")
    local loTime  = string.match(loBatt, "^Battery %d: [^,]+, %d+%%, (%d%d:%d%d)")
    local loText  = "<span color='#6495ed'>Bat</span><span color='#454545'>|</span>"

    if loLoad then
        loText = loText .. loLoad .. "%"
    else
        loText = loText .. "??%"
    end

    if     loState == "Charging"    then loText = loText .. "<span color='#45ff45'>➚</span>"
    elseif loState == "Discharging" then loText = loText .. "<span color='#ff4545'>➘</span>"
    end

    battery_plugin.wibox:set_markup(loText .. " ")

    if tonumber(loLoad) < 10 and not battery_plugin.is_low then 
        battery_plugin.is_low = true
        naughty.notify({ preset = naughty.config.presets.critical,
                         title  = "Low battery",
                         text   = "The battery load is very low. Think about plugging in asap ;-)" })
    elseif tonumber(loLoad) >= 10 and battery_plugin.is_low then
        battery_plugin.is_low = false
   end
end

battery_plugin.timer = timer({ timeout = 60 })

battery_plugin.startup = function()
    battery_plugin.update()
    battery_plugin.timer:connect_signal("timeout", battery_plugin.update)
    battery_plugin.timer:start()
end

return battery_plugin
