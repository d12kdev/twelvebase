
_G.graphx = {}
_G.graphx.animations = {}

_G.graphx.buffer = {}
_G.graphx.buffer.layers = {
    ["layer1"] = {},
    ["layer2"] = {},
    ["layer3"] = {},
    ["layer4"] = {},
    ["layer5"] = {}
}

_G.graphx.buffer.system_layer = {}


function graphx.packXY(x, y)
    return {x,y}
end

function graphx.drawPx(xy, color, layer)
    local x = xy[1]
    local y = xy[2]
    local clr = nil

    if layer == nil then
        layer = graphx.buffer.layers["layer1"]
    end

    if type(color) == "string" then
        clr = colors.fromBlit(color)
    elseif type(color) == "number" then
        clr = color
    else
        clr = colors.white
    end

    table.insert(layer, {x, y, "px", clr})
end

function graphx.clearScreen()
    term.clear()
    term.setCursorPos(1,1)
end

function graphx.clsc()
    graphx.clearScreen()
end

function graphx.clearAll()
    graphx.cleanBuffer()
    graphx.clearScreen()
end

function graphx.drawText(startXY, text, color, layer)
    local x,y = startXY[1], startXY[2]
    local clr = nil

    if layer == nil then
        layer = graphx.buffer.layers["layer1"]
    end

    if type(color) == "string" then
        clr = colors.fromBlit(color)
    elseif type(color) == "number" then
        clr = color
    else
        clr = colors.white
    end

    table.insert(layer, {x,y,"text", {text, clr}})
end

function graphx.drawLine(startXY, endXY, color, layer)
    local x1, y1 = startXY[1], startXY[2]
    local x2, y2 = endXY[1], endXY[2]

    if layer == nil then
        layer = graphx.buffer.layers["layer1"]
    end

    if color == nil then
        color = colors.white
    end

    local dx = math.abs(x2 - x1)
    local dy = math.abs(y2 - y1)
    local sx, sy

    if x1 < x2 then
        sx = 1
    else
        sx = -1
    end

    if y1 < y2 then
        sy = 1
    else
        sy = -1
    end

    local err = dx - dy

    while true do
        graphx.drawPx(graphx.packXY(x1, y1), color, layer)

        if x1 == x2 and y1 == y2 then
            break
        end

        local e2 = 2 * err

        if e2 > -dy then
            err = err - dy
            x1 = x1 + sx
        end

        if e2 < dx then
            err = err + dx
            y1 = y1 + sy
        end
    end
end

function graphx.fillScreen(color, layer)
    local screenWidth, screenHeight = term.getSize()
    graphx.drawFilledSquare({1, 1}, math.max(screenWidth, screenHeight), color, layer)
end


function graphx.drawSquare(startXY, size, color, layer)
    local x, y = startXY[1], startXY[2]
    local endX, endY = x + size - 1, y + size - 1
    local g = graphx

    -- Draw top side
    g.drawLine({x, y}, {endX, y}, color, layer)
    -- Draw right side
    g.drawLine({endX, y}, {endX, endY}, color, layer)
    -- Draw bottom side
    g.drawLine({x, endY}, {endX, endY}, color, layer)
    -- Draw left side
    g.drawLine({x, y}, {x, endY}, color, layer)
end

function graphx.drawFilledSquare(startXY, size, color, layer)
    local x, y = startXY[1], startXY[2]
    local endX, endY = x + size - 1, y + size - 1

    for i = y, endY do
        graphx.drawLine({x, i}, {endX, i}, color, layer)
    end
end

function graphx.drawRectangle(startXY, endXY, color, layer)
    local x1, y1 = startXY[1], startXY[2]
    local x2, y2 = endXY[1], endXY[2]

    if layer == nil then
        layer = graphx.buffer.layers["layer1"]
    end

    -- Draw the four sides of the rectangle
    graphx.drawLine({x1, y1}, {x2, y1}, color, layer) -- Top
    graphx.drawLine({x1, y2}, {x2, y2}, color, layer) -- Bottom
    graphx.drawLine({x1, y1}, {x1, y2}, color, layer) -- Left
    graphx.drawLine({x2, y1}, {x2, y2}, color, layer) -- Right
end

function graphx.drawFilledRectangle(startXY, endXY, color, layer)
    local x1, y1 = startXY[1], startXY[2]
    local x2, y2 = endXY[1], endXY[2]

    if layer == nil then
        layer = graphx.buffer.layers["layer1"]
    end

    -- for every line loop
    for y = y1, y2 do
        graphx.drawLine({x1, y}, {x2, y}, color, layer) -- Draw a horizontal line
    end
end



function graphx.cleanBuffer()
    _G.graphx.buffer.layers = {
        ["layer1"] = {},
        ["layer2"] = {},
        ["layer3"] = {},
        ["layer4"] = {},
        ["layer5"] = {}
    }
end


function graphx.renderFrame(cleanBuffer)
    graphx.clearScreen()

    local layerNames = {"layer5","layer4", "layer3", "layer2", "layer1"}

    for _, layerName in ipairs(layerNames) do
        local layer = graphx.buffer.layers[layerName]
        for _, renderObject in ipairs(layer) do
            local x = renderObject[1]
            local y = renderObject[2]
            local objType = renderObject[3]
            local color = renderObject[4]

            if objType == "px" then
                term.setCursorPos(x,y)
                local oldColor = term.getBackgroundColor()
                term.setBackgroundColor(color)
                term.write(" ")
                term.setBackgroundColor(oldColor)
            elseif objType == "text" then
                local props = color
                local text = props[1]
                local color = props[2]
                local oldPosX, oldPosY = term.getCursorPos()
                local oldTextColor = term.getTextColor()
                local oldBkgColor = term.getBackgroundColor()
                term.setCursorPos(x,y)
                local upLayers = {}
                local downLayers = {}
                local blayers = graphx.buffer.layers
                if layer == blayers["layer1"] then
                    upLayers = {}
                elseif layer == blayers["layer2"] then
                    upLayers = {blayers["layer1"]}
                elseif layer == blayers["layer3"] then
                    upLayers = {blayers["layer1"], blayers["layer2"]}
                elseif layer == blayers["layer4"] then
                    upLayers = {blayers["layer1"], blayers["layer2"], blayers["layer3"]}
                elseif layer == blayers["layer5"] then
                    upLayers = {blayers["layer1"], blayers["layer2"], blayers["layer3"], blayers["layer4"]}
                end
                
                if layer == blayers["layer5"] then
                    downLayers = {}
                elseif layer == blayers["layer4"] then
                    downLayers = {blayers["layer5"]}
                elseif layer == blayers["layer3"] then
                    downLayers = {blayers["layer4"], blayers["layer5"]}
                elseif layer == blayers["layer2"] then
                    downLayers = {blayers["layer3"], blayers["layer4"], blayers["layer5"]}
                elseif layer == blayers["layer1"] then
                    downLayers = {blayers["layer2"], blayers["layer3"], blayers["layer4"], blayers["layer5"]}
                end
                for i = 1, #text do
                    local letter = text:sub(i,i)
                    local cPosX, cPosY = term.getCursorPos()
                    local downLayerPxFound = false
                    local downLayerPxObj = nil
                    for _, downLayer in ipairs(downLayers) do
                        for _, downObj in ipairs(downLayer) do
                            if downObj[1] == cPosX and downObj[2] == cPosY then
                                downLayerPxFound = true
                                downLayerPxObj = downObj
                                break
                            end
                        end
                        if downLayerPxFound then
                            break
                        end
                    end
                    local cBkgColor = term.getBackgroundColor()
                    if downLayerPxFound and downLayerPxObj ~= nil then
                        cBkgColor = downLayerPxObj[4]
                    end
                    term.setBackgroundColor(cBkgColor)
                    term.setTextColor(color)
                    term.write(letter)
                end
                term.setCursorPos(oldPosX, oldPosY)
                term.setTextColor(oldTextColor)
                term.setBackgroundColor(oldBkgColor)
            end
        end
    end
    term.setCursorPos(1,1)
    if cleanBuffer == nil or cleanBuffer == true then
        graphx.cleanBuffer()
    end
end

function graphx.animations.rollingText(text, color, duration, line)
    local function getTermSize()
        local width, height = term.getSize()
        return width, height
    end
    local width, height = getTermSize()

    local yPos = line
    if line == "center" then
        yPos = height / 2
    end
    local textLength = #text
    local totalSteps = width + textLength
    local stepDuration = duration / totalSteps

    for i = 1, totalSteps do
        graphx.clearScreen()

        local startX = i - textLength

        if startX >= 1 then
            graphx.drawText(graphx.packXY(startX, yPos), text, color)
        end

        graphx.renderFrame()

        os.sleep(stepDuration)
    end
end