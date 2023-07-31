local NotesFile = require 'NotesFile'
local GameData = require 'GameData'
local Overlay = require 'Overlay'
local Downloader = require 'Downloader'

local allNotes = {}
local currentEncounter = nil
local currentBattleSize = 0
local currentNotes = nil
local reversePolarity = false
local lastQueuedCommandCount = nil
local setPositionsWait = -1
local newBattle = false

local Controller = {}

function getEncounterKey(t)
    for k,v in pairs(t) do
        t[k] = v:gsub('%A', '')
    end
    return table.concat(t, ',')
end

function getReverse(t)
    local result = {}
    for i=#t,1, -1 do
        result[#result+1] = t[i]
    end
    return result
end


function Controller.init(notesFile, downloadUrl)
    local test = io.open(notesFile, 'r')
    local doLoad = false
    if test == nil then
        if downloadUrl == nil then
            print("No notes loaded, " .. notesFile .. " does not exist")
        else
            print(notesFile .. " not found, downloading from " .. downloadUrl)
            doLoad = Downloader.get(downloadUrl, notesFile)
            if not doLoad then
                print("WARNING: Download failed, please place a " .. notesFile .. " in the same folder as gs-encounter-notes-overlay.lua")
            end
        end
    else
        io.close(test)
        doLoad = true
    end

    if doLoad then
        allNotes = NotesFile.load(notesFile)
    end

    Overlay.clear()
    print("")
    print("Golden Sun Encounter Notes script prepped and ready")
end

function Controller.frame()
    if allNotes == nil then
        print("Controller not initialized")
        return
    end

    local currentEnemyCount = GameData.battleSlotList:enemyCount()

    if currentEnemyCount == 0 and currentEncounter ~= nil then --Encounter finished
        print("No longer in encounter\n")
        setPositionsWait = 2
        currentEncounter = nil
        currentNotes = nil
        lastQueuedCommandCount = nil
        Overlay.clear()

    elseif currentEnemyCount > 0 then
        if currentEncounter == nil then --Encounter begins
            newBattle = true

            local partySize = GameData.partyFlags:partySize()
            currentBattleSize = partySize + currentEnemyCount
            currentEncounter = GameData.enemyNames:asArray()
            local key = getEncounterKey(currentEncounter)
            print("In encounter ", key)
            local rawNotes = nil
            if allNotes[key] ~= nil then
                reversePolarity = false
                rawNotes = allNotes[key]
            else
                local reverseKey = getEncounterKey(getReverse(currentEncounter))
                if allNotes[reverseKey] ~= nil then
                    reversePolarity = true
                    rawNotes = allNotes[reverseKey]
                end
            end

            if rawNotes ~= nil then
                --arrange notes and numbers according to party/enemy positions
                local partyOrder = GameData.partyOrder:asArray()
                currentNotes = {extra = rawNotes.extra}

                --first sprite is unrelated
                for i = 1,4 do
                    currentNotes[i] = {}
                    if i <= partySize then
                        local sourceIndex = partyOrder[i]+1
                        currentNotes[i].text = rawNotes[sourceIndex].text
                        print(currentNotes[i].text or 'def')
                        currentNotes[i].y = 118

                        local target = rawNotes[sourceIndex].target
                        if rawNotes[sourceIndex].target ~= nil then
                            currentNotes[i].target = reversePolarity and (currentEnemyCount - target + 1) or target
                        end
                    end
                end
            end
        elseif currentNotes ~= nil then --Mid-encounter
            local queuedCommandCount = GameData.battleCommand:queuedCommandCount()

            if queuedCommandCount then --not nil indicates menu has appeared
                if setPositionsWait == 0 then
                    for i = 1,4 do
                        local partyAnchor = GameData.spriteData:positionsArray(1,1)[1].x + 10
                        currentNotes[i].x = partyAnchor + (i-1)*44
                    end
                    setPositionsWait = setPositionsWait - 1
                end

                if queuedCommandCount ~= lastQueuedCommandCount then
                    --drawing anything on a frame resets previous drawings
                    if queuedCommandCount == 0 or newBattle then
                        Overlay.drawNumbers(currentEnemyCount)
                        Overlay.drawNotes(currentNotes)
                    elseif queuedCommandCount == currentBattleSize then
                        Overlay.drawNotes(currentNotes)
                    end
                end
            end

            lastQueuedCommandCount = queuedCommandCount
            newBattle = false
        end
    end
end

Controller.allNotes = allNotes
return Controller
