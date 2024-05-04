_G.CUSTOMENTRY = false

function customentry()


    local function render1(desc, btn1, btn2, btn1Selected)
        local width, height = term.getSize()
        local centerWidth, centerHeight = (width / 2), (height / 2)
        graphx.clearAll()
        graphx.fillScreen(colors.lightGray, graphx.buffer.layers.layer5)
        local ceverText = _G._CEVER or "VERSION" -- Default if not set
        local ceverTextLength = #ceverText
        local ceverStartX = math.floor(centerWidth - (ceverTextLength / 2))
    
        graphx.drawText(
            graphx.packXY(ceverStartX, 2),
            ceverText,
            colors.black,
            graphx.buffer.layers.layer3
        )
    
        -- Centered desc text
        local descTextLength = #desc
        local descStartX = math.floor(centerWidth - (descTextLength / 2))
    
        graphx.drawText(
            graphx.packXY(descStartX, math.floor(centerHeight) - 2),
            desc,
            colors.black,
            graphx.buffer.layers.layer3
        )

        -- buttons
        local b1Color, b2Color
        local b1TextColor, b2TextColor
        if btn1Selected then
            b1Color = colors.black
            b2Color = colors.gray
            b1TextColor = colors.white
            b2TextColor = colors.black
        else
            b1Color = colors.gray
            b2Color = colors.black
            b1TextColor = colors.black
            b2TextColor = colors.white
        end

        local buttonWidth = 10
        local buttonHeight = 3
        local button1X = math.floor(centerWidth) - buttonWidth - 1
        local button1Y = height - buttonHeight - 1

        graphx.drawFilledRectangle(
            graphx.packXY(button1X, button1Y),
            graphx.packXY(button1X + buttonWidth, button1Y + buttonHeight),
            b1Color,
            graphx.buffer.layers.layer4
        )

        -- Draw text for Button1
        graphx.drawText(
            graphx.packXY(button1X + 2, button1Y + 1),
            btn1,
            b1TextColor,
            graphx.buffer.layers.layer3
        )

        -- Draw Button2 filled rectangle at center-right of the bottom row
        local button2X = math.floor(centerWidth) + 1

        graphx.drawFilledRectangle(
            graphx.packXY(button2X, button1Y),
            graphx.packXY(button2X + buttonWidth, button1Y + buttonHeight),
            b2Color,
            graphx.buffer.layers.layer4
        )

        -- Draw text for Button2
        graphx.drawText(
            graphx.packXY(button2X + 2, button1Y + 1),
            btn2,
            b2TextColor,
            graphx.buffer.layers.layer3
        )
        
        graphx.renderFrame()
    end

    local function render2(desc, input, caps)
        local width, height = term.getSize()
        local centerWidth, centerHeight = (width / 2), (height / 2)
        graphx.clearAll()
        graphx.fillScreen(colors.lightGray, graphx.buffer.layers.layer5)
        local ceverText = _G._CEVER or "VERSION" -- Default if not set
        local ceverTextLength = #ceverText
        local ceverStartX = math.floor(centerWidth - (ceverTextLength / 2))
    
        graphx.drawText(
            graphx.packXY(ceverStartX, 2),
            ceverText,
            colors.black,
            graphx.buffer.layers.layer3
        )
    
        -- Centered desc text
        local descTextLength = #desc
        local descStartX = math.floor(centerWidth - (descTextLength / 2))
    
        graphx.drawText(
            graphx.packXY(descStartX, math.floor(centerHeight) - 2),
            desc,
            colors.black,
            graphx.buffer.layers.layer3
        )

        local warningText = "CapsLock doesn't work, only Shift"
        local warningStartX = math.floor(centerWidth - (#warningText / 2))
        graphx.drawText(
            graphx.packXY(warningStartX, math.floor(centerHeight)),
            warningText,
            colors.orange,
            graphx.buffer.layers.layer3
        )

        

        local inputTextLength = #input
        local inputStartX = math.floor(centerWidth - (inputTextLength / 2))

        graphx.drawLine(
            graphx.packXY(1, math.floor(centerHeight) + 2),
            graphx.packXY(width, math.floor(centerHeight) + 2),
            colors.white,
            graphx.buffer.layers.layer4
        )

        graphx.drawText(
            graphx.packXY(inputStartX, math.floor(centerHeight) + 2),
            input,
            colors.black,
            graphx.buffer.layers.layer3
        )

        local capsColor = colors.red
        if caps then
            capsColor = colors.green
        end

        local buttonHeight = 3
        local buttonWidth = 10
        local button1X = math.floor(centerWidth) - (buttonWidth / 2)
        local button1Y = height - buttonHeight - 1

        graphx.drawFilledRectangle(
            graphx.packXY(button1X, button1Y),
            graphx.packXY(button1X + buttonWidth, button1Y + buttonHeight),
            capsColor,
            graphx.buffer.layers.layer4
        )

        -- Draw text for Button1
        graphx.drawText(
            graphx.packXY(button1X + (buttonWidth / 4), button1Y + 1),
            "SHIFT",
            colors.black,
            graphx.buffer.layers.layer3
        )
        
        graphx.renderFrame()
    end

    function thirdLoop()
        local filePath = ""
        local confirm = false
        local caps = false

        graphx.clearAll()
        os.sleep(1)

        render2("Write the path to the file", filePath)
        
        repeat
            local event, key = os.pullEvent()
            
            local numberList = {
                ["one"] = 1,
                ["two"] = 2,
                ["three"] = 3,
                ["four"] = 4,
                ["five"] = 5,
                ["six"] = 6,
                ["seven"] = 7,
                ["eight"] = 8,
                ["nine"] = 9
            }



            if event == "key" then
                local write = true
                local letter = keys.getName(key)
                if key == keys.leftShift or key == keys.rightShift then
                    caps = true
                end

                if key == keys.backspace then
                    if #filePath > 0 then
                        filePath = string.sub(filePath, 1, -2) 
                    end
                end

                if key == keys.enter then
                    confirm = true
                end

                if #keys.getName(key) > 1 then
                    write = false
                end
                
                if key == keys.space then
                    write = true
                end

                if key == keys.slash then
                    write = true
                    letter = "/"
                elseif key == keys.period then
                    write = true
                    letter = "."
                end

                for word, number in pairs(numberList) do
                    if keys.getName(key) == word then
                        write = true
                        letter = number
                        break
                    end
                end
                
                if caps and write then
                    filePath = filePath..string.upper(letter)
                elseif write then
                    filePath = filePath..letter
                end
            end

            if event == "key_up" then
                if key == keys.leftShift or key == keys.rightShift then
                    caps = false
                end
            end

            render2("Write the path to the file", filePath, caps)
        until confirm == true

        pcall(dofile, filePath)
        _G.CUSTOMENTRY = true

    end

    function secondLoop()
        local buttonPressed = true
        render1("How do you want to continue?", "Shutdown", "Load", buttonPressed)
        local exit = false

        repeat
            local event, key = os.pullEvent()

            if event == "key" then
                if key == keys.right then
                    buttonPressed = false
                elseif key == keys.left then
                    buttonPressed = true
                elseif key == keys.enter then
                    exit = true
                end
            end

            render1("How do you want to continue?", "Shutdown", "Load",buttonPressed)
        until exit == true
        
        if buttonPressed then
            shutdown()
        else
            thirdLoop()
            return
        end
    end

    local function mainLoop()
        local buttonPressed = true
        render1("Boot into TwelveBase?", "Yes", "No", buttonPressed)
        local exit = false

        repeat
            local event, key = os.pullEvent()

            if event == "key" then
                if key == keys.right then
                    buttonPressed = false
                elseif key == keys.left then
                    buttonPressed = true
                elseif key == keys.enter then
                    exit = true
                end
            end
            render1("Boot into TwelveBase?", "Yes", "No", buttonPressed)
        until exit == true

        if buttonPressed == true then
            return
        else
            secondLoop()
            return
        end
    end

    mainLoop()

end
