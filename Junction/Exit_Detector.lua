-- For Junction Controlers
    -- holds state of up signal to be requested
    -- detects train comming out of Junction

-- variables:

local modemUp = peripheral.wrap("left")
local modemJunc = peripheral.wrap("right")
      state = "caution"
local settings_table ={}
local do_settings = "n"

-- find out settings from the file, this aviods the auto update removvvving settings
if fs.exists("Junction/settings.txt") then
    local settings_file = fs.open("Junction/settings.txt", "r")
    local contents = settings_file.readAll()
    settings_file.close()
    local lines = contents.split("\n")
    for i, line in ipairs(lines) do
        settings_table[i] = line
    end
else
    print("Settings are needed to run.")
    print("Would you like to add them. (y/n)")

    do_settings = io.read().lower()

    if do_settings.lower() == "y" or do_settings.lower() == "yes" then
        
        

    end

end

local line = settings_table[1]

modemUp.open(2)
modemJunc.open(2)

local function TrainDet()
    
    local TrainStat = redstone.getAnalogueInput("top")

    if TrainStat > 0 then

        repeat

            TrainStat = redstone.getAnalogInput("top")
            os.sleep(0.05)

        until TrainStat == 0

    modemJunc.transmit(2, 500, {{"E", settings_table[1]}})
    
    end
end

local function modemMessageCheck()

    os.startTimer(0.05) -- stop os.pull() indefinitely
    local event, _, _, _, message = os.pullEvent()

    if event == "modem_message" then

        if message == "request" then -- only required on startup.

            modemJunc.transmit(2, 500, state)

        elseif message == "caution" or message == "clear" then

            modemJunc.transmit(2, 500, 0)

        end
    end
end

while true do

    modemMessageCheck()
    TrainDet()

end