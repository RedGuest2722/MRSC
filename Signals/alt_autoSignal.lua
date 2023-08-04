-- auto Signal alternative (may become main)

-- variables

digitalList = {"Locking", "Clear", "Caution", "Signal"}
xSize, ySize = term.getSize()

-- wraping peripherals
digitalController = peripheral.wrap("bottom")

modemMain = peripheral.wrap("back")
modemDown = peripheral.wrap("left")
modemUp = peripheral.wrap("right")

-- ports

modemMain.open(5)
modemDown.open(2)
modemUp.open(2)


-- change screen colours
function screen(colour)

    term.setBackgroundColor(colour)
    for q in ySize do
        
        for w in xSize do

            term.write(" ")

        end    
    end
end

function occupied()

    digitalController.setAspect(digitalList[1], 5)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 1)
    digitalController.setAspect(digitalList[4], 5)
    
    
    screen(colors.red)

end

function caution()
   
    digitalController.setAspect(digitalList[1], 1)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 3)
    
    screen(colors.orange)

end

function clear()

    digitalController.setAspect(digitalList[1], 1)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 1) 
    
    screen(colors.green)  

end

-- this tells the computer what block state to be in
function updateBlock(stateChange)

    if stateChange == "occupied" then
        occupied() 
        modemDown.transmit(2, 500, "caution")
        state = {"occupied", 1, 1}
    elseif stateChange == "caution" then
        caution()
        modemDown.transmit(2, 500, "clear")
        state = {"caution", 1, 1}
    elseif stateChange == "clear" then
        clear()
        state = {"clear", 0, 0}
    end
end

-- see if train has occupied the block
function trainCheck()
    
    if redstone.getAnalogInput("top") > 0 then

        repeat
        
            os.sleep(0.1)
    
        until redstone.getAnalogInput("top") == 0
        
        updateBlock("occupied")

    end
end

function messageCheck()

    os.startTimer(0.1) -- this stops the os.pull() from running indefinitly
    event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent()

    if event == "modem_message" then
        
        if side == "right" then
            
            if message == "caution" then

                updateBlock("caution")
                
            elseif message == "clear" then

                updateBlock("clear")

            end
        end
    end
end

-- startup

state = {"occupied", 1, 1}
term.clear()
updateBlock("occupied")

while true do

    trainCheck()
    messageCheck()

end