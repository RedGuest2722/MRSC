-- Automatic Signal
-- This signal cannot controled manually.

os.loadAPI("Signals/Moduals/signalInterface.lua")

-- variables
local digitalList = {"Locking", "Clear", "Caution", "Signal"}
local vers = "Signal Version: 0.1.0"

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
    signalInterface.SignalClear(colors.lightGray)
    signalInterface.SignalCaution(colors.lightGray)
    signalInterface.SignalDanger(colors.red)

end

-- Set block as caution
function caution()
    -- RS on: Locking Track: allow through
    digitalController.setAspect(digitalList[1], 5)
    -- RS off: 4 speed
    digitalController.setAspect(digitalList[2], 1)
    -- RS on: 2 speed
    digitalController.setAspect(digitalList[3], 5)
    -- Signal Orange/Yellow
    digitalController.setAspect(digitalList[4], 3)

    -- Clear signals, set caution, and clear danger
    signalInterface.SignalClear(colors.lightGray)
    signalInterface.SignalCaution(colors.orange)
    signalInterface.SignalDanger(colors.lightGray)
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

    -- Clear signal
    signalInterface.SignalClear(colors.green)
    -- Set caution signal to light gray
    signalInterface.SignalCaution(colors.lightGray)
    -- Set danger signal to light gray
    signalInterface.SignalDanger(colors.lightGray)
end

-- Function to update block state
local function updateBlock(stateChange)

    -- Check for occupied state
    if stateChange == "occupied" then
        occupied() 
        modemDown.transmit(2, 500, "caution") -- send state to down signal
        state = {"occupied", 1, 1}

    -- Check for caution state
    elseif stateChange == "caution" then
        caution()
        modemDown.transmit(2, 500, "clear") -- send state to down signal
        state = {"caution", 1, 1}

    -- Check for clear state
    elseif stateChange == "clear" then
        clear()
        state = {"clear", 0, 0}

    end
end

local function messageCheck()
    os.startTimer(0.1) -- stop os.pull() indefinitely
    local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent()

    if event == "modem_message" then
        if side == "right" then -- from up signal message
            if message == "caution" then
                updateBlock("caution")
            elseif message == "clear" then
                updateBlock("clear")
            end
        elseif side == "left" and message == "Request" then -- from down signal when starting
            signalInterface.writeText("sending status" .. state[1])
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
signalInterface.versionWrite(vers)

state = {"occupied", 1, 1}
updateBlock("occupied")

os.sleep(2)
signalInterface.writeText("Initiation Complete")

os.sleep(2)
local id = os.startTimer(5)
signalInterface.writeText("Waiting for inital signal state, from up signal. (5 secs max)")
modemUp.transmit(2, 2, "Request") -- request block state from up signal

repeat

	event, side_id, senderChannel, replyChannel, message, senderDistance = os.pullEvent()

until replyChannel == 500 or event == "timer"

if event == "modem_message" and side_id == "right" then -- from up signal message (startup)

	signalInterface.writeText("message received")
	os.sleep(0.5)
	signalInterface.writeText("Changing to " .. message)
	os.cancelTimer(id)
			
	if message == "caution" then

		updateBlock("caution")

				
	elseif message == "clear" then

		updateBlock("clear")

	end


elseif event == "timer" then

	signalInterface.writeText("no message received")
	os.sleep(0.5)
	signalInterface.writeText("staying as Occupied")

end

-- main loop
while true do

	trainCheck()
	messageCheck()

end