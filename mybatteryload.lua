local wibox = require("wibox")
local naughty = require("naughty")
local awful = require("awful")

mybatteryload = {}

mybatteryload.wibox = wibox.widget.textbox()
mybatteryload.is_low = false

mybatteryload.update = function()
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

    mybatteryload.wibox:set_markup(loText .. " ")

    if tonumber(loLoad) < 10 and not mybatteryload.is_low then 
        mybatteryload.is_low = true
        naughty.notify({ preset = naughty.config.presets.critical,
                         title  = "Low battery",
                         text   = "The battery load is very low. Think about plugging in asap ;-)" })
    elseif tonumber(loLoad) >= 10 and mybatteryload.is_low then
        mybatteryload.is_low = false
   end
end

mybatteryload.timer = timer({ timeout = 60 })

mybatteryload.startup = function()
    mybatteryload.update()
    mybatteryload.timer:connect_signal("timeout", mybatteryload.update)
    mybatteryload.timer:start()
end

return mybatteryload
