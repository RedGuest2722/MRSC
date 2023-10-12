-- For Junction Controlers
    -- holds state of up signal to be requested
    -- detects train comming out of Junction

-- variables:

local modemUp = peripheral.wrap("left")
local modemJunc = peripheral.wrap("right")
local state = "caution"

local TypeDect = ( -- uncomment type of line the dector is detecting
    -- "UF"
    -- "US"
    -- "DM"
)

modemUp.open(2)
modemJunc.open(2)

local function TrainDet()
    
    local TrainStat = redstone.getAnalogueInput("top")

    if TrainStat > 0 then

        repeat

            TrainStat = redstone.getAnalogInput("top")
            os.sleep(0.05)

        until TrainStat == 0

    modemJunc.transmit(2, 500, {"E" .. TypeDect})
    
    end
end

local function modemMessageCheck()

    os.startTimer(0.05) -- stop os.pull() indefinitely
    local event, _, _, _, message = os.pullEvent()

    if event == "modem_message" then

        if message == "request" then -- only required on start up.

            modemJunc.transmit(2, 500, state)

        elseif message == "caution" or message == "clear" then

            modemJunc.transmit(2, 500, message)

        end
    end
end

while true do

    modemMessageCheck()
    TrainDet()

end