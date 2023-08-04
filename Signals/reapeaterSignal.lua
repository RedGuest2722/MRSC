-- repeater signal

-- variables

digitalList = {"Locking", "Clear", "Caution", "Signal"}

-- wraping peripherals
digitalController = peripheral.wrap("bottom")

modemMain = peripheral.wrap("back")
modemBlock = peripheral.wrap("top")

-- ports
modemMain.open(5)
modemBlock.open(2)

-- change screen colours
function screen(colour)

    term.setBackgroundColor(colour)
    term.clear()

end

function caution()
   
    digitalController.setAspect(digitalList[1], 5)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 3)
    
    screen(colors.orange)

end

function clear()

    digitalController.setAspect(digitalList[1], 5)
    digitalController.setAspect(digitalList[2], 5)
    digitalController.setAspect(digitalList[3], 1)
    digitalController.setAspect(digitalList[4], 1) 
    
    screen(colors.green)  

end

-- this tells the computer what block state to be in
function updateBlock(stateChange)

    if stateChange == "caution" then
        caution()
        modemBlock.transmit(2, 500, "clear")
        state = {"caution", 1, nil}
    elseif stateChange == "clear" then
        clear()
        state = {"clear", 1, nil}
    end
end

function messageCheck()

    os.startTimer(0.1) -- this stops the os.pull() from running indefinitly
    event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent()

    if event == "modem_message" then
        
        if side == "top" then
            
            if message == "caution" then

                updateBlock("caution")
                
            elseif message == "clear" then

                updateBlock("clear")

            end
        end
    end
end

-- startup

state = {"caution", 1, nil}
updateBlock("caution")

while true do

    messageCheck()

end