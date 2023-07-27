local MemoryStructure = require('MemoryStructure')

local GameData = {
    partyFlags      = MemoryStructure(0x02000040,   1, nil, memory.read_u8),
    battleSlotList  = MemoryStructure(0x020300b2,   2, nil, memory.read_u8),
    partyOrder      = MemoryStructure(0x02000438,   1, nil, memory.read_u8),
    battleCommand   = MemoryStructure(0x02030338,  16, nil, memory.read_u8),
    spriteData      = MemoryStructure(0x07000000,   8, nil, memory.read_u16_le),
    enemyNames      = MemoryStructure(0x02030878, 332,  15, memory.read_bytes_as_array)
}

function GameData.partyFlags:partySize()
    local count = 0
    local data = self:read(0)
    for i=0,7 do
        if bit.check(data, i) then
            count = count + 1
        end
    end
    return count
end

function GameData.battleSlotList:enemyCount()
    local size = 0

    local v = self:read(size)
    while v > 0 and v < 0xff and size < 7 do
        size = size + 1
        v = self:read(size)
    end
    return size
end

function GameData.partyOrder:asArray()
    local result = {}
    for i = 0,3 do
        table.insert(result, self:read(i))
    end
    return result
end

function GameData.battleCommand:queuedCommandCount()
    local count = 0
    for i=0,19 do
        if self:read(i) ~= 0xff then
            count = count + 1
        end
    end
    if count == 20 then
        --workaround: before first turn, data appears to be all 0s
        return nil
    end
    return count
end

function GameData.spriteData:positionsArray(index, length)
    local result = {}
    for i=index,index+length-1 do
        local attr0 = self:read(i, 0)
        local attr1 = self:read(i, 2)
        local y = bit.band(attr0, 0x0ff)
        local x = bit.band(attr1, 0x1ff)
        table.insert(result, {x=x, y=y})
    end
    return result
end


function GameData.enemyNames:asArray(encounterSize)
    encounterSize = encounterSize or GameData.battleSlotList:enemyCount()

    local names = {}
    for i = 0,encounterSize-1 do
        local data = self:read(i)
        local str = {}
        for _, v in ipairs(data) do
            if v > 0 then
                table.insert(str, string.char(v))
            end
        end
        table.insert(names, table.concat(str))
    end

    return names
end

return GameData
