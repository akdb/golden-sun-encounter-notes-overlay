require = function(file)
    return dofile(file .. '.lua')
end

local Controller = dofile('Controller.lua')

Controller.init('gs-encounter-notes.csv')

while true do
    Controller.frame()
    emu.frameadvance()
end
