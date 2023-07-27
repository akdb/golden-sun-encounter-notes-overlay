Downloader = {}

function Downloader.get(url, destination)
    local cmd = string.format('curl --fail --verbose --location "%s" --fail --output "%s"', url, destination)
    print(cmd)
    local code = os.execute(cmd)
    if code ~= 0 then
        print("Could not download " .. destination .. " from " .. url)
        return false
    end
    return true
end

return Downloader