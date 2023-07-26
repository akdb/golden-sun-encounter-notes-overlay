local class = require('class')

local MemoryStructure = class(function (o, offset, iterator, size, reader)
    o.offset = offset
    o.iterator = iterator
    o.size = size
    o.reader = reader
end)

function MemoryStructure:read(index, skip)
    skip = skip or 0
    if self.size then
        return self.reader(self.offset + skip + index*self.iterator, self.size)
    end
    return self.reader(self.offset + skip + index*self.iterator)
end

return MemoryStructure
