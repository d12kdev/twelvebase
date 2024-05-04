_G.tutils = {}

function tutils.input(question)
    if question == nil then
        err("No arguments given")
    end

    print(question)
    local answer = read()
    return answer
end

function tutils.inputYN(question)
    if question == nil then
        err("No arguments given")
    end

    print(question)

    local preAnswer = read()
    local answer = false
    if preAnswer == "y" or preAnswer == "Y" then
        answer = true
    end

    return answer
end

function tutils.inputNum(question)
    if question == nil then
        err("No arguments given")
    end

    local loopOver = false
    local finalAnswer = nil

    repeat
        print(question)
        local answer = read()
        local isGood = tonumber(answer, 10)
        if isGood == nil then
            print("Must be a number.")
        else
            loopOver = true
            finalAnswer = tonumber(answer, 10)
        end
    until loopOver == true

    return finalAnswer
end

function tutils.table(input_table)
    if type(input_table) ~= "table" then
        err("The input isn't a table")
    end
    if #input_table == 0 then
        err("The table is empty")
    end

    local columnWidths = {}
    local headers = {}

    for key in pairs(input_table[1]) do
        table.insert(headers, key)
        columnWidths[key] = #tostring(key)
    end

    for _, record in ipairs(input_table) do
        for key, value in pairs(record) do
            local length = #tostring(value)
            if length > columnWidths[key] then
                columnWidths[key] = length
            end
        end
    end

    local function padText(text, width)
        return text .. string.rep(" ", width - #text)
    end

    local headerRow = ""
    for _, header in ipairs(headers) do
        headerRow = headerRow .. padText(header, columnWidths[header]) .. " | "
    end
    headerRow = headerRow:sub(1, -3)

    local dataRows = {}
    for _, record in ipairs(input_table) do
        local dataRow = ""
        for _, header in ipairs(headers) do
            local value = record[header] or ""
            dataRow = dataRow .. padText(tostring(value), columnWidths[header]) .. " | "
        end
        dataRow = dataRow:sub(1, -3)
        table.insert(dataRows, dataRow)
    end

    local formattedTable = headerRow .. "\n" .. table.concat(dataRows, "\n")
    return formattedTable
end

function tutils.toBool(str)
    if str == null or str == "" then
        return nil
    end
    if type(str) ~= "string" then
        err("The input isn't a string")
    end

    tbl = {
        ["false"] = false,
        ["true"] = true
    }

    return tbl[str]
end

function tutils.is_number(str)
    local num = tonumber(str)
    return num ~= nil
end

function tutils.flipBool(bool)
    return not bool
end