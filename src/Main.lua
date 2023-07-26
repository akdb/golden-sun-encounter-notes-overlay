local Controller = require('Controller.lua')

Controller.init('notes.csv')

while true do
    Controller.frame()
    emu.frameadvance()
end
