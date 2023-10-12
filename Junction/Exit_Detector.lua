-- For Junction Controlers
    -- holds state of up signal to be requested
    -- detects train comming out of Junction

-- variables:

local modemUp = peripheral.wrap("left")
local modemJunc = peripheral.wrap("right")
local state = "caution"

local TypeDect = ( -- uncomment type of line the dector is detecting
    -- "DF"
    -- "DS"
    -- "UM"
)

local function TrainDect()
    
    local TrainStat = redstone.getAnalogueInput("top")

    if TrainStat > 0 then

        repeat

            TrainStat = redstone.getAnalogInput("top")
            os.sleep(0.05)

        until TrainStat == 0

    modemJunc.transmit(2, 500, "E" .. TypeDect)
    
    end
end

local function modemMessageCheck()

    os.startTimer(0.1) -- stop os.pull() indefinitely
    local event, _, _, _, message = os.pullEvent()

    if event == "modem_message" then

        if message == "request" then

            modemJunc.transmit(2, 500, state)

        elseif message == "caution" or message == "clear" then

            state = message

        end
    end
end

while true do

    modemMessageCheck()
    TrainDect()

end