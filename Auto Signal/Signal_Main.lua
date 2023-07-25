-- auto signal

-- variables to be set on install

local digitalControllerName = ""        -- please set the name of digital controller
local mainComputerID = 0                -- please set the computerID of main computer
local upBlockID = 0                     -- please set the computerID of up block computer
local downBlockID = 0                   -- please set the computerID of down block computer

-- varibles

local digitalList = {"Locking", "Clear", "Caution", "Signal"}
local computersID = {mainComputerID, upBlockID, downBlockID}
local blockStatus = 0

    -- Messages from Main Computer and Blocks

local mainMessage = "Recieved " .. tostring(os.getComputerID() .. "from " .. tostring(mainComputerID))
local upMessage = 0
local downMessage = "Recieved " .. tostring(os.getComputerID() .. "from down block")

    -- wraping peripherals

local digitalController = peripheral.wrap(digitalControllerName)
local modem = peripheral.wrap("bottem")

-- open rednet to send / recieve messages

rednet.open(modem)

-- set block to Occupied State
function Occupied()

    digitalController.setAspect(digitalList[1], 5)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 1)
    digitalController.setAspect(digitalList[4], 5)

end


-- set block to Caution State
function Warning()
       
    digitalController.setAspect(digitalList[1], 1)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 3)

end

-- set block to Clear State
function Clear()
        
    digitalController.setAspect(digitalList[1], 1)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 1)

end

-- up dates Main Computer and other block computers
function sendMessage(Device, Status, Recieved, computers)
    
    for i in ipairs(Recieved) do
        
        if Recieved[i] == 0 then
            
            if i == 2 then
                
                message = "recieved " .. tostring(Device)

                return message

            else

                message = Status

                return message

            end

            rednet.send(computers[i], message)

        end

        Recieved[i] = 0

    end
end

function recievedMessage()

    local computerID, Message = rednet.receive()



end    


-- main loop of the signal
while true do
    
    trainPass = redstone.getInput("top")                        -- Redstone from Detector

    if trainPass > 0 and reset == 0 then                        -- check if train has entered controlled block
        
        blockStatus = 0
        local reset = 1

        return blockStatus, reset

    elseif trainPass == 0 then                                  -- reset detector
        
        reset = 0

    elseif blockStatus == 2 then                                -- allows the clear function to run
        
        Clear()
        local mainToChange = 1

        return mainToChange

    elseif blockStatus == 1 then                                -- allows the caution function to run

        Warning()
        local mainToChange = 1

        return mainToChange
    
    elseif blockStatus == 0 then                                -- allows the occupied function to run

        Occupied()
        local mainToChange = 1

        return mainToChange

    end
end