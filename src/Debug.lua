require = function(file)
    return dofile(file .. '.lua')
end

local Controller = dofile('Controller.lua')

Controller.init()

while true do
    Controller.frame()
    emu.frameadvance()
end
