local awful = require('awful')

myquickrun = {}

myquickrun.tags = {}
myquickrun[1] = {
    clients = {"xterm tmux new-session -s 'stats' ; tmux new-window"}
}
myquickrun[2] = {
    clients = {'firefox'}
}

myquickrun.keys = awful.util.table.join(
    awful.key({ "Mod4" }, "i", function()
        for i=1, 2 do
            -- awful.util.spawn(myquickrun.clients[i])
        end
    end)
)

return myquickrun
