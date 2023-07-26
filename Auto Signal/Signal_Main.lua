-- auto signal

-- variables to be set on install

local digitalControllerName = ""        -- please set the name of digital controller
local mainComputerID = 0                -- please set the computerID of main computer
      upBlockID = 0                     -- please set the computerID of up block computer
      downBlockID = 0                   -- please set the computerID of down block computer

-- varibles

local digitalList = {"Locking", "Clear", "Caution", "Signal"}
local computersID = {mainComputerID, upBlockID, downBlockID}
local blockStatus = 0

    -- wraping peripherals

local digitalController = peripheral.wrap(digitalControllerName)
local modem = peripheral.wrap("bottem")

-- open rednet to send / recieve messages

rednet.open(modem)

-- set block to Occupied State
function Occupied()

    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 1)
    digitalController.setAspect(digitalList[4], 5)

    rednet.send(downBlockID, 1)
    
    state = 0

    repeat
        
        os.sleep(0.1)

    until redstone.getAnalogInput("top") == 0

    digitalController.setAspect(digitalList[1], 5)

    return state

end


-- set block to Caution State
function Warning()
       
    digitalController.setAspect(digitalList[1], 1)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 3)

    rednet.send(downBlockID, 2)
    
    state = 1

    return state

end

-- set block to Clear State
function Clear()
        
    digitalController.setAspect(digitalList[1], 1)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 1)

    -- rednet.send(downBlock, 2) -- no need to update downblock as already green / red
    
    state = 2

    return state

end

-- Start up

state = Occupied()

-- main loop of the signal
while true do
    
    trainpass = redstone.getAnalogInput("top")

    computerID, message = rednet.recieve()

    if trainpass > 0 then
        
        Occupied()

    elseif computersID == upBlockID then

        if message == 1 then
            
            Warning()

        elseif message == 2 then
            
            Clear()

        end
    end
end