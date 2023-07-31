local class = require('class')

local MemoryStructure = class(function (o, offset, iterator, size, reader)
    o.offset = offset
    o.iterator = iterator
    o.size = size
    o.reader = reader
end)

function MemoryStructure:read(index, skip)
    index = index or 0
    skip = skip or 0
    if self.size then
        return self.reader(self.offset + skip + index*self.iterator, self.size)
    end
    return self.reader(self.offset + skip + index*self.iterator)
end

function MemoryStructure:readString(index)
    local data = self:read(index)
    local str = {}
    for _, v in ipairs(data) do
        if v > 0 then
            table.insert(str, string.char(v))
        end
    end
    return table.concat(str)
end

return MemoryStructure
