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

function cfgParser.__convertArray(arrayObj)
    if type(arrayObj) ~= "table" then
        err("Passed argument isn't a table. cfgParser (__ method)")
    end
    local result = "{ "
    local isFirst = true
    for _, obj in ipairs(arrayObj) do
        if isFirst then
            result = result .. obj
            isFirst = false
        else
            result = result .. ", " .. obj
        end
    end

    return result
end

function cfgParser.convert(configObj)
    if type(configObj) ~= "table" then
        err("Passed argument isn't a table. cfgParser")
    end

    local result = ""
    for objName, obj in pairs(configObj) do
        if type(obj) == "table" then
            result = result .. objName .. " = " .. cfgParser.__convertArray(obj) .. "}\n"
        else
            result = result .. objName .. " = " .. obj .. "\n"
        end
    end
    return result
end