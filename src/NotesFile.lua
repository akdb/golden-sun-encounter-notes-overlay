local csv = require 'csv'

local NotesFile = {}

function NotesFile.load()
	local data = {}
	local file = csv.open("notes.csv", {header=true})
    for fields in file:lines() do
        if fields.fileDescription and #fields.fileDescription > 0 then
            print(fields.fileDescription)
        end
        data[fields.encounterKey] = decodeNote(fields)
    end

	return data
end

function decodeNote(fields)
    local row = {extra = fields.extra}

    for i = 1,4 do
        local noteData = wordSplit(fields[tostring(i)])
        row[i] = {}
        --note [1] text [2] target
        row[i].text = noteData[1]
        row[i].target = tonumber(noteData[2])
    end

    return row
end

function wordSplit(str, char)
    local result = {}
    for chunk in str:gmatch('%S+') do 
        table.insert(result, chunk) 
    end
    return result
end

return NotesFile
