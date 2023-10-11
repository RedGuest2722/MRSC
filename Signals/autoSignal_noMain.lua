-- Automatic Signal
-- This signal cannot controled manually.

os.loadAPI("Signals/Moduals/signalInterface.lua")

-- variables
local digitalList = {"Locking", "Clear", "Caution", "Signal"}
local vers = "0.1.0"
local timer_num = math.random(1, 5)

-- wraping peripherals
local digitalController = peripheral.wrap("bottom") -- CC and RC Interface

local modemMain = peripheral.wrap("back")
local modemDown = peripheral.wrap("left")
local modemUp = peripheral.wrap("right")

-- ports
modemMain.open(5) -- transmit between signal center and signal
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
    os.startTimer(0.1) -- stop os.pull() indefinitely
    local event, side, _, _, message = os.pullEvent()

    if event == "modem_message" then
        if side == "right" then -- from up signal message
            if message == "caution" or message == "clear" then
                updateBlock(message)
            end
        elseif side == "left" and message == "Request" then -- from down signal when starting
            signalInterface.Write_Text("sending status" .. state[1])
            os.sleep(1)
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
            os.sleep(0.1)
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

local id = os.startTimer(timer_num)
signalInterface.Write_Text("Waiting for inital signal state, from up signal. (5 secs max)")
modemUp.transmit(2, 2, "Request") -- request block state from up signal

repeat

	event, side_id, senderChannel, replyChannel, message, senderDistance = os.pullEvent()

until replyChannel == 500 or event == "timer"

if event == "modem_message" and side_id == "right" then -- from up signal message (startup)

	signalInterface.Write_Text("message received")
	signalInterface.Write_Text("Changing to " .. message)
	os.cancelTimer(id)
			
	if message == "caution" then

		updateBlock("caution")

				
	elseif message == "clear" then

		updateBlock("clear")

	end


elseif event == "timer" then

	signalInterface.Write_Text("no message received")
	signalInterface.Write_Text("staying as Occupied")

end

-- main loop
while true do

	trainCheck()
	messageCheck()

end