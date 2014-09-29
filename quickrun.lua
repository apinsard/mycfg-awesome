local awful = require('awful')

local quickrun_plugin = {}

quickrun_plugin.tags = {}
quickrun_plugin[1] = {
    clients = {"xterm tmux new-session -s 'stats' ; tmux new-window"}
}
quickrun_plugin[2] = {
    clients = {'firefox'}
}

quickrun_plugin.keys = awful.util.table.join(
    awful.key({ "Mod4" }, "i", function()
        for i=1, 2 do
            -- awful.util.spawn(quickrun_plugin.clients[i])
        end
    end)
)

return quickrun_plugin
