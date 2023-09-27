-- Signal Interface Program

local signalInterface

term.clear()

-- Init: Variables

local xMax, yMax = term.getSize()
local xMid = math.floor(6 * (xMax / 7))  -- Seperation for Text and Signal Display

-- Variables

local q = 0
local w = 0
local e = xMid + 1

yMax = yMax - 1

local textLine = 2

-- Signal drawing (Right Side)

local xSigMin = xMid + 1
local ySigMin = 2

local xSigMax = xMax - 1
local ySigMax = yMax

-- Signal Init: -- Signal size 7 x 4

local yStopDanger = yMax - 11
local yStopCaution = yMax - 6
local yStopClear = yMax - 1

-- Signals

function SignalClear(color)

    term.setBackgroundColor(color)
    local t = 13

    -- clear

    while t ~= yStopClear do

        local r = xSigMin + 1

        while r ~= xSigMax do
            
            term.setCursorPos(r, t)
            term.write(" ")
            
            r = r + 1 -- Next

        end
        
        t = t + 1 -- Next

    end
end

function SignalCaution(color)

    term.setBackgroundColor(color)
    local u = 8

    -- caution

    while u ~= yStopCaution do

        local y = xSigMin + 1

        while y ~= xSigMax do
            
            term.setCursorPos(y, u)
            term.write(" ")

            y = y + 1 -- Next

        end

        u = u + 1 -- Next

    end
end

function SignalDanger(color)

    term.setBackgroundColor(color)
    local o = 3

    -- Danger

    while o ~= yStopDanger do

        local i = xSigMin + 1

        while i ~= xSigMax do
            
            term.setCursorPos(i, o)
            term.write(" ")

            i = i + 1 -- Next

        end

        o = o + 1 -- Next

    end
end

-- only called from Initiation

function SignalInitiation()

    -- Signal Setting: Clear, Caution, Danger

    SignalClear(colors.lightGray)
    SignalCaution(colors.lightGray)
    SignalDanger(colors.lightGray)

end

-- call on Start

function Initiation()

    -- Borders: Top, Bottem, Left, Right, Middle ,

    term.setBackgroundColor(colors.gray)

    -- Top, Bottem

    while q ~= (xMax + 1) do
        
        term.setCursorPos(q, 1)
        term.write(" ") -- Top

        term.setCursorPos(q, yMax)
        term.write(" ") -- Bottem 1

        term.setCursorPos(q, (yMax + 1))
        term.write(" ") -- Bottem 2

        q = q + 1 -- Next

    end

    -- Left, Right, Middle

    while w ~= (yMax + 1) do
        
        term.setCursorPos(1, w)
        term.write(" ") -- Left

        term.setCursorPos(xMid, w)
        term.write(" ") -- Middle

        term.setCursorPos(xMax, w)
        term.write(" ") -- Right

        w = w + 1 -- Next

    end

    SignalInitiation()

end

function splitMessage(message)

    words = {}

    for word in string.gmatch(message, "[^%s]+") do

        table.insert(words, word)

    end

    local messageCon = {}

    local a = 1
    local messageReady = 0

    while messageReady ~= 1 do

        local lineFull = 0
        
        while lineFull == 0 do
            
            if messageCon[a] == nil then
                
                messageCon[a] = words[1]
                table.remove(words, 1)

            elseif words[1] == nil then

                messageReady = 1
                lineFull = 1

            elseif (string.len(messageCon[a]) + 1 + string.len(words[1])) < (xMid) then

                messageCon[a] = messageCon[a] .. " " .. words[1]
                table.remove(words, 1)

            else

                lineFull = 1

            end
        end

        a = a + 1
        
    end

    return messageCon

end

function clearText()

    term.setBackgroundColor(colors.black)

    local s = 2

    while s ~= yMax do
        
        local d = 2

        while d ~= xMid do

            term.setCursorPos(d, s)
            term.write(" ")

            d = d + 1

        end

        s = s + 1

    end

end

function writeText(messageRecieved, fontColor, backgroundColor)

    -- window min 2, 2
    -- window max 37, 17
    -- window size = 35, 15

    if fontColor == nil then 

        fontColor = colors.white 

    end

    if backgroundColor == nil then 
        
        backgroundColor = colors.black 
    
    end
    

    local messageLen = string.len(messageRecieved)
    local messageConRec = {}

    if messageLen > (xMid - 2) then
        
        messageConRec = splitMessage(messageRecieved)

    else

        table.insert(messageConRec, 1, messageRecieved)

    end

    if textLine > 13 then
        
        clearText()
        textLine = 2

    end

    term.setTextColor(fontColor)
    term.setBackgroundColor(backgroundColor)

    while messageConRec[1] ~= nil do

        term.setCursorPos(2, textLine)
        term.write(messageConRec[1])
        textLine = textLine + 1
        table.remove(messageConRec, 1)

    end
end