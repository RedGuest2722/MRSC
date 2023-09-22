-- auto Signal

-- variables
digitalList = {"Locking", "Clear", "Caution", "Signal"}

-- wraping peripherals
digitalController = peripheral.wrap("bottom") -- CC and RC Interface

modemMain = peripheral.wrap("back")
modemDown = peripheral.wrap("left")
modemUp = peripheral.wrap("right")

-- ports
modemMain.open(5) -- transmit between signal center and signal
modemDown.open(2) -- transmit to down signal
modemUp.open(2)   -- transmit to up signal


-- change screen colours
function screen(colour)

    term.setBackgroundColor(colour)
    term.clear()

end

-- next few function control the RC interface with the block state

function occupied() -- set block as occupied

    digitalController.setAspect(digitalList[1], 1) -- RS off: Locking Track: allow through
    digitalController.setAspect(digitalList[2], 1) -- RS off: 4 speed
    digitalController.setAspect(digitalList[3], 5) -- RS on: 2 speed
    digitalController.setAspect(digitalList[4], 5) -- Signal Red
    
    screen(colors.red) -- identification for player

end

function caution() -- set block as caution
   
    digitalController.setAspect(digitalList[1], 5) -- RS on: Locking Track: allow through
    digitalController.setAspect(digitalList[2], 1) -- RS off: 4 speed
    digitalController.setAspect(digitalList[3], 5) -- RS on: 2 speed
    digitalController.setAspect(digitalList[4], 3) -- Signal Orange/Yellow
    
    screen(colors.orange) -- identification for player

end

function clear() -- set block as clear

    digitalController.setAspect(digitalList[1], 5) -- RS on: Locking Track: allow through
    digitalController.setAspect(digitalList[2], 5) -- RS on: 4 speed
    digitalController.setAspect(digitalList[3], 1) -- RS off: 2 speed
    digitalController.setAspect(digitalList[4], 1) -- Signal Green
    
    screen(colors.green) -- identification for player

end

-- this tells the computer what block state to be in
function updateBlock(stateChange)

    if stateChange == "occupied" then

        occupied() 
        modemDown.transmit(2, 500, "caution") -- send the state the down signal needs to be
        state = {"occupied", 1, 1}

    elseif stateChange == "caution" then

        caution()
        modemDown.transmit(2, 500, "clear") -- send the state the down signal needs to be
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
        
        if side == "right" then -- from up signal message
            
            if message == "caution" then

                updateBlock("caution")
                
            elseif message == "clear" then

                updateBlock("clear")

            end
        
        elseif side == "left" and message == "Request" then -- from down signal when starting

            state_start = digitalController.getaspect(digitalList[4])
            
            if state_start == 1 or 3 then

                
                modemDown.transmit(2, 500, "clear")

            elseif state_start == 5 then
                
                modemDown.transmit(2, 500, "caution")

            end
        end
    end
end

-- startup

state = {"occupied", 1, 1}
updateBlock("occupied")

modemUp.transmit(2, 2, "Request") -- request block state from up signal

id = os.startTimer(5)
print("Waiting for signal state to be in from up signal. (5 secs max)")
event, side_id, senderChannel, replyChannel, message, senderDistance = os.pullEvent()

if event == "modem_message" then
    if side == "right" then -- from up signal message (startup)
            
        if message == "caution" then

            updateBlock("caution")
            
        elseif message == "clear" then

            updateBlock("clear")

        end
    end
end

-- main loop
while true do

    trainCheck()
    messageCheck()

end