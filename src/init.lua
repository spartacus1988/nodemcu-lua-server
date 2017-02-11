local setup = require("setup")

tmr.alarm(0, 10000, 0, function()
setup.start()
end)


