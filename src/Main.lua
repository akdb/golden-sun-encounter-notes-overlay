local Controller = require 'Controller'

print ''
Controller.init()

while true do
    Controller.frame()
    emu.frameadvance()
end
