-- Manual Signal
-- This signal can controled manually or automatically.

os.loadAPI("Signals/Moduals/signalInterface.lua")

-- variables
local digitalList = {"Locking", "Clear", "Caution", "Signal"}
local vers = "0.1.0"
local settings_table ={}

-- find out settings from the file, this aviods the auto update removvvving settings
if fs.exists("Signals/settings.txt") then
    local settings_file = fs.open("Signals/settings.txt", "r")
    local contents = settings_file.readAll()
    settings_file.close()
    local lines = contents.split("\n")
    for i, line in ipairs(lines) do
        settings_table[i] = line
    end
else
    error("No setup file found")
end

local line = settings_table[1]

-- wraping peripherals
local digitalController = peripheral.wrap("bottom") -- CC and RC Interface

local modemMain = peripheral.wrap("back")
local modemDown = peripheral.wrap("left")
local modemUp = peripheral.wrap("right")

-- ports
modemMain.open(5) -- transmit between signal center and signals
modemDown.open(2) -- transmit to down signal
modemUp.open(2)   -- transmit to up signal

-- next few function control the RC interface with the block state

-- Set block as occupied
local function occupied()

    -- RS off: Locking Track: allow through
    digitalController.setAspect(digitalList[1], 1)

    -- RS off: 4 speed
    digitalController.setAspect(digitalList[2], 1)

    -- RS on: 2 speed
    digitalController.setAspect(digitalList[3], 5)

    -- Signal Red
    digitalController.setAspect(digitalList[4], 5)

    -- Clear, Caution, and Danger signals
    signalInterface.Signal_Clear(colors.lightGray)
    signalInterface.Signal_Caution(colors.lightGray)
    signalInterface.Signal_Danger(colors.red)

end

-- Set block as caution
local function caution()
    -- RS on: Locking Track: allow through
    digitalController.setAspect(digitalList[1], 5)
    -- RS off: 4 speed
    digitalController.setAspect(digitalList[2], 1)
    -- RS on: 2 speed
    digitalController.setAspect(digitalList[3], 5)
    -- Signal Orange/Yellow
    digitalController.setAspect(digitalList[4], 3)

    -- Clear, Caution, and Danger signals
    signalInterface.Signal_Clear(colors.lightGray)
    signalInterface.Signal_Caution(colors.orange)
    signalInterface.Signal_Danger(colors.lightGray)
end

-- Function to clear block
local function clear()
    -- Set RS on: Locking Track
    digitalController.setAspect(digitalList[1], 5)
    -- Set RS on: 4 speed
    digitalController.setAspect(digitalList[2], 5)
    -- Set RS off: 2 speed
    digitalController.setAspect(digitalList[3], 1)
    -- Set signal to green
    digitalController.setAspect(digitalList[4], 1)

    -- Clear, Caution, and Danger signals
    signalInterface.Signal_Clear(colors.lime)
    signalInterface.Signal_Caution(colors.lightGray)
    signalInterface.Signal_Danger(colors.lightGray)
end

local function updateBlock(stateChange)
    -- Map stateChange to appropriate function and message for down signal
    local stateMap = {
        occupied = {func = occupied, message = "caution"},
        caution = {func = caution, message = "clear"},
        clear = {func = clear}
    }

    -- Execute appropriate function based on the stateChange
    stateMap[stateChange].func()

        if stateChange ~= "clear" then
        -- Send state to down signal
        modemDown.transmit(2, 500, stateMap[stateChange].message)
        state = {stateChange, 1, 1}
    else
        state = {stateChange, 0, 0}
    end
end

local function messageCheck()
    os.startTimer(0.05) -- stop os.pull() indefinitely
    local event, side, _, _, message = os.pullEvent()

    if event == "modem_message" then
        if side == "right" and message[1] == line then -- from up signal message
            if message[2] == "caution" or "clear" then
                updateBlock(message[2])
            end
        elseif side == "left" and message == "Request" then -- from down signal when starting
            signalInterface.Write_Text("sending status" .. state[1])
            
            if state[1] == "caution" or state[1] == "clear" then
                modemDown.transmit(2, 500, "clear")
            elseif state[1] == "occupied" then
                modemDown.transmit(2, 500, "caution")
            end
        end
    end
end

-- Check if train is passing the signal
local function trainCheck()

    -- If redstone signal is on (train is passing the signal)
    if redstone.getAnalogInput("top") > 0 then

        -- Wait until train passed the signal
        repeat
            os.sleep(0.05)
        until redstone.getAnalogInput("top") == 0

        -- Update block to show it's occupied
        updateBlock("occupied")

    end
end

-- startup
signalInterface.Initiation()
signalInterface.Version_Write("Signal Version: " .. vers)

state = {"occupied", 1, 1}
updateBlock("occupied")
signalInterface.Write_Text("Initiation Complete")

-- main loop
while true do

	trainCheck()
	messageCheck()

end