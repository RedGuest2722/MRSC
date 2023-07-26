-- auto signal


-- varibles

local digitalList = {"Locking", "Clear", "Caution", "Signal"}
local channelList = {1, 2, 3}

    -- wraping peripherals

local digitalController = peripheral.wrap("bottom")

local modem_main = peripheral.wrap("bottom")
local modem_down = peripheral.wrap("left")
local modem_up = peripheral.wrap("right")

-- open channels

modem_main.open(channelList[1])
modem_down.open(channelList[2])
modem_up.open(channelList[3])

-- set block to Occupied State
function Occupied()

    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 1)
    digitalController.setAspect(digitalList[4], 5)
    
    modem_down.transmit(channelList[2], channelList[2], "Caution")

    local downRecieve = 0

    repeat
        
        os.sleep(0.1)

    until redstone.getAnalogInput("top") == 0

    digitalController.setAspect(digitalList[1], 5)

    return downRecieve

end


-- set block to Caution State
function Warning()
       
    digitalController.setAspect(digitalList[1], 1)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 3)

    modem_down.transmit(channelList[2], channelList[2], "Clear")
    
    local downRecieve = 0

    return state

end

-- set block to Clear State
function Clear()
        
    digitalController.setAspect(digitalList[1], 1)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 1)

end

function trainCheck()

    trainpass = redstone.getAnalogInput("top")

    if trainpass > 0 then
    
        Occupied()

    end
end

function updateBlock(stateChange)

   if stateChange == "Caution" then
    
        Warning()

    elseif stateChange == "Clear" then

        Clear()

   end 
end

function messageCheck()

    os.startTimer(0.1)

    local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent()
 

    if event == "modem_message" then

        if senderChannel == channelList[1] then
            
            mainRecieve = 1

        elseif senderChannel == channelList[2] then

            downRecieve = 1

        elseif senderChannel == channelList[3] then

            return message

        end
    
    else
        
        message = "noChange"

        return message
    
    end
end

-- Start up

state = Occupied()

-- main loop of the signal
while true do
  
message = messageCheck()
updateBlock(message)
trainCheck()

end