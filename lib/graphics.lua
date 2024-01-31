_G.graphx = {}

_G.graphx.buffer = {}
_G.graphx.buffer.layers = {
    ["layer1"] = {},
    ["layer2"] = {},
    ["layer3"] = {},
    ["layer4"] = {},
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


function graphx.clearAll()

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



function graphx.renderFrame()
    graphx.clearScreen()
    for _, layer in pairs(graphx.buffer.layers) do
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
                for i = 1, #text do
                    local letter = text:sub(i,i)
                    term.setBackgroundColor(term.getBackgroundColor())
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
end