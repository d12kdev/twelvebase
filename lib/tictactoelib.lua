_G.tictactoe = {}
_G.tictactoe.inter = {}

function tictactoe.inter.check(board)
    local function is_winning_line(a, b, c)
        return a == b and b == c and a ~= ' '
    end
    
    for i = 1, 3 do
        if is_winning_line(board[i][1], board[i][2], board[i][3]) then
            return board[i][1] == 'x' and "player1" or "player2"
        end
    end
    
    for i = 1, 3 do
        if is_winning_line(board[1][i], board[2][i], board[3][i]) then
            return board[1][i] == 'x' and "player1" or "player2"
        end
    end
    
    if is_winning_line(board[1][1], board[2][2], board[3][3]) then
        return board[1][1] == 'x' and "player1" or "player2"
    end
    
    if is_winning_line(board[1][3], board[2][2], board[3][1]) then
        return board[1][3] == 'x' and "player1" or "player2"
    end
    
    for i = 1, 3 do
        for j = 1, 3 do
            if board[i][j] == ' ' then
                return "continue"
            end
        end
    end
    
    return "draw"
end

function tictactoe.inter.make_move(board, moveX, moveY, playerSymbol)
    if board[moveY][moveX] ~= ' ' then
        return false  -- Invalid move, cell is not empty
    end

    board[moveY][moveX] = playerSymbol  -- This modifies the original board
    return true  -- Return true to indicate the move was successful
end



function tictactoe.inter.draw(board, focusOn)
    local g = _G.graphx
    local gridColor = colors.white
    local textColor = nil
    local player1Color = colors.red
    local player2Color = colors.blue
    local cellSize = 4  -- Adjusted cell size for better spacing

    -- Draw the grid
    local startX, startY = 1, 1

    if focusOn == "player1" then
       player2Color = colors.gray
    elseif focusOn == "player2" then
        player1Color = colors.gray             
    end

    -- Draw horizontal grid lines
    for i = 0, 3 do
        g.drawLine(
            {startX, startY + i * cellSize},
            {startX + 3 * cellSize, startY + i * cellSize},
            gridColor,
            g.buffer.layers["layer4"]
        )
    end

    -- Draw vertical grid lines
    for i = 0, 3 do
        g.drawLine(
            {startX + i * cellSize, startY},
            {startX + i * cellSize, startY + 3 * cellSize},
            gridColor,
            g.buffer.layers["layer4"]
        )
    end

    -- Draw the contents of the Tic-Tac-Toe board
    for row = 1, 3 do
        for col = 1, 3 do
            local content = board[row][col]
            if content ~= ' ' then
                local posX = (startX + (col - 1) * cellSize + 1) + 1
                local posY = (startY + (row - 1) * cellSize + 1) + 1
                local contentColor = textColor
                if content == 'x' then
                    contentColor = player1Color
                elseif content == 'o' then
                    contentColor = player2Color
                end
                g.drawText({posX, posY}, content, contentColor, g.buffer.layers["layer4"])
            end
        end
    end
end

function tictactoe.inter.board()
    return {
        {' ', ' ', ' '},
        {' ', ' ', ' '},
        {' ', ' ', ' '}
    }
end

function tictactoe.multiplayer()
    local board = {
        {' ', ' ', ' '},
        {' ', ' ', ' '},
        {' ', ' ', ' '}
    }

    local function boardToString(board)
        local str = ""
    
        for i = 1, #board do
            for j = 1, #board[i] do
                str = str .. board[i][j]  -- Add each element to the string
                if j < #board[i] then
                    str = str .. " | "  -- Add separator between columns (optional)
                end
            end
    
            if i < #board then
                str = str .. "\n"  -- Add a new line after each row (except the last row)
            end
        end
    
        return str
    end
    

    local width, height = term.getSize()
    local promptY = height - 1

    local finsihed = false
    local fPos1, fPos2 = 1, height
    local turn = false

    local function statusMessage(msg)
        graphx.drawText(
            graphx.packXY(fPos1, fPos2 - 1),
            msg,
            colors.white,
            graphx.buffer.layers.layer2
        )
    end

    local function finishPos()
        term.setCursorPos(fPos1, fPos2)
    end

    local function getSymbol(boolPlayer)
        if boolPlayer then
            return 'x'
        else
            return 'o'
        end
    end

    local function next(player)
        graphx.clearAll()
        local focus = nil
        local status = tictactoe.inter.check(board)
        local result = false
        if status == "player1" then
            statusMessage("Player 1 won!")
            finishPos()
            focus = "player1"
            result = true
        elseif status == "player2" then
            statusMessage("player2")
            finishPos()
            focus = "player2"
            result = true
        elseif status == "draw" then
            statusMessage("It's a draw!")
            finishPos()
            result = true
        end
        tictactoe.inter.draw(board, focus)
        local promptMessage = player.."'s move: "
        if result == false then
            graphx.drawText(
                graphx.packXY(1, promptY),
                promptMessage,
                colors.white,
                graphx.buffer.layers["layer3"]
            )
        end
        graphx.renderFrame()
        if result == false then
            term.setCursorPos(#promptMessage, promptY)
            local input = read()
            turn = tutils.flipBool(turn)
            if input == "q" then
                term.clear()
                return true
            end
            local x, y = input:match("(%d+),%s*(%d+)")
            x = tonumber(x)
            y = tonumber(y)

            local function panic()
                turn = tutils.flipBool(turn)
                print("\nInvalid input!")
                os.sleep(1)
                return false
            end
            
            if x == nil or y == nil then
                return panic()
            end
            local movee = tictactoe.inter.make_move(board, x, y, getSymbol(turn))
            if movee == false then
                return panic()
            end
        end
        return result
    end

    local function getPlayer(bool)
        if bool then
            return "Player 1"
        else 
            return "Player 2"
        end
    end


    repeat
        finsihed = next(getPlayer(turn))
    until finsihed == true
end