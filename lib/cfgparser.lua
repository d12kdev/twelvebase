_G.cfgParser = {}

function cfgParser.parse(filename)
    local config = {}
    local file = io.open(filename, "r")

    if file then
        for line in file:lines() do
            local key, value = line:match("(%w+)%s*=%s*(.*)")
            if key and value then
                -- Check if the value is an array
                local arrayValues = value:match("{(.-)}")
                if arrayValues then
                    -- Split the array values and store them in a Lua table
                    local arrayTable = {}
                    for v in arrayValues:gmatch("[^,%s]+") do
                        table.insert(arrayTable, tonumber(v) or v)
                    end
                    config[key] = arrayTable
                else
                    config[key] = tonumber(value) or value
                end
            end
        end
        file:close()
    else
        print("Error: Unable to open the .cfg file")
    end

    return config
end

function cfgParser.parseString(inputString)
    local config = {}

    for line in inputString:gmatch("[^\r\n]+") do
        local key, value = line:match("(%w+)%s*=%s*(.*)")
        if key and value then
            -- Check if the value is an array
            local arrayValues = value:match("{(.-)}")
            if arrayValues then
                -- Split the array values and store them in a Lua table
                local arrayTable = {}
                for v in arrayValues:gmatch("[^,%s]+") do
                    table.insert(arrayTable, tonumber(v) or v)
                end
                config[key] = arrayTable
            else
                config[key] = tonumber(value) or value
            end
        end
    end

    return config
end
