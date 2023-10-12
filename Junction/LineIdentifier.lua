-- This progarm identifies the line need for the corresponding train

local modem = peripheral.wrap("left")
local JuncID = os.getComputerID()

modem.open(3)

local function lineIdentifier(JuncID)

    local state = redstone.getAnalogInput("right")

    if state == 15 or 13 then
        
        modem.transmit(3, 500, {JuncID, "US"})

    elseif state == 14 or 12 or 11 then

        modem.transmit(3, 500, {JuncID, "UF"})

    end
end

-- startup

print("Waiting for message from Junction control.")
print("Id of this computer is " .. tostring(os.getComputerID()) .. "." )

repeat

    local _, _, _, _, message = os.pullEvent()
    
    JuncID = message

    os.sleep(0.05)

until JuncID ~= nil

print("Junction control ID recieved")

while true do
    
    lineIdentifier(JuncID)
    os.sleep(0.05)

end