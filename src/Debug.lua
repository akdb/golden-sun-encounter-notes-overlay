require = function(file)
    return dofile(file .. '.lua')
end

local Controller = require('Controller.lua')

Controller.init('notes.csv')

while true do
    Controller.frame()
    emu.frameadvance()
end
