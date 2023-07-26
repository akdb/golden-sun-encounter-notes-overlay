local GameData = require('GameData')

local Overlay = {}

local textColor = '#ffffff'
local minorColor = '#888888'
local numberColor = '#8fbfff'
local backgroundColor = '#000000'
local textSize = 9
local extraSize = 9
local numberSize = 8
local minorSize = 7
local textFont = 'Arial'
local numberFont = 'Arial'

function Overlay.clear()
    gui.clearGraphics()
end

function Overlay.drawNumbers(currentEnemyCount)
    local increment = 44 - ((currentEnemyCount > 3) and (currentEnemyCount-3)*7 or 0)
    local x = 127 - (24 * (currentEnemyCount - 1)) - increment/2
    local y = 48

    gui.use_surface("emucore")

    for i=1,currentEnemyCount do
        gui.drawText(x, y, i, numberColor, backgroundColor, 8, nil)
        x = x + increment
    end
end

function Overlay.drawNotes(noteData)
    local x = 60
    local y = 119

    gui.use_surface("emucore")

    for i = 1,4 do
        x = noteData[i].x or x
        y = noteData[i].y or y

        if noteData[i].target then
            gui.drawText(x + 11, y + textSize, tostring(noteData[i].target), numberColor, backgroundColor, numberSize, numberFont)
        end

        if noteData[i].text then
            if (noteData[i].text == 'def') or (noteData[i].text == 'd') then
                gui.drawText(x, y + textSize - minorSize, noteData[i].text, minorColor, backgroundColor, minorSize, textFont)
            else
                gui.drawText(x, y, noteData[i].text, textColor, backgroundColor, textSize, textFont)
            end
        end
        x = x + 44
    end

    if noteData.extra then
        gui.drawText(0, 119 - extraSize - 2, noteData.extra, textColor, backgroundColor, extraSize, textFont)
    end
end

return Overlay
