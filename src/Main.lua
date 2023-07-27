local Controller = require('Controller.lua')

print("")
Controller.init('gs-encounter-notes.csv', 'https://raw.githubusercontent.com/wiki/akdb/golden-sun-encounter-notes-overlay/contrib/akdylie/gs-encounter-notes.csv')

while true do
    Controller.frame()
    emu.frameadvance()
end
