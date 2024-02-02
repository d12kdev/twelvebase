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