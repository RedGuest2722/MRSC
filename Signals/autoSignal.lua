-- auto signal


-- varibles

digitalList = {"Locking", "Clear", "Caution", "Signal"}
channelList = {1, 2}

    -- wraping peripherals

digitalController = peripheral.wrap("bottom")

modem_main = peripheral.wrap("back")
modem_down = peripheral.wrap("left")
modem_up = peripheral.wrap("right")

-- set block to Occupied State
function Occupied()

    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 1)
    digitalController.setAspect(digitalList[4], 5)

    modem_down.transmit(channelList[2], channelList[2], "Caution")

    downRecieve = 0

    print("Train Wait")

    repeat
        
        os.sleep(0.1)

    until redstone.getAnalogInput("top") == 0

    digitalController.setAspect(digitalList[1], 5)

    print("In danger state")

    return downRecieve

end


-- set block to Caution State
function Warning()
       
    digitalController.setAspect(digitalList[1], 1)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 3)

    modem_down.transmit(channelList[2], channelList[2], "Clear")

    downRecieve = 0

    print("In caution state")

    return state

end

-- set block to Clear State
function Clear()
        
    digitalController.setAspect(digitalList[1], 1)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 1)

    print("In clear state")

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

    modem_down.open(channelList[2])
    event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent()
    modem_down.close(channelList[2])

    if event == "modem_message" then

        if senderChannel == channelList[1] then
            
            mainRecieve = 1

            message = "noChange"

        elseif senderChannel == channelList[2] then

            downRecieve = 1

            message = "noChange"
         
        elseif senderChannel == channelList[2] then

            upSend = 1

        end
    
    else
        
        message = "noChange"

    
    end

end

-- Start up

term.clear()
state = Occupied()

-- main loop of the signal
while true do
  
messageCheck()
updateBlock(message)
trainCheck()

end
