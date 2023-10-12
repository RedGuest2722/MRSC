-- Main lines into Fast & Slow Lines
-- slow lines come off main


os.loadAPI("Moduals/junctionInterface.lua")

-- Variables

local Monitor = "monitor_3" -- set the name of the monitor (Usually monitor_0)

local IDs = {os.getComputerID, 35} -- set ID of UM (in slot 2) Train type detector

local Modem_Junction = peripheral.wrap("right")
local Modem_Main = peripheral.wrap("back")
local DigConBox = peripheral.wrap("top") -- for points

Modem_Main.open(3)

-- tell computer which routes are locked, via 3D arrays
local Route_Locks = {}

local upStates = {nil, nil, nil}

-- tell computer where trains want to go if have to be queued
local Route_Queues = {Fast_Queue = {}, Slow_Queue = {}}

local Routes_Lock_List = {
    UF_UM_locks = {"US_UM"},
    US_UM_locks = {"UF_UM", "DM_DF"},
    DM_DF_locks = {"US_UM", "DM_DF"},
    DM_DS_locks = {"DM_DF"}
}

local function Route_Lock_Check(Check_Route)

    local Locked = true

    for q in ipairs(Routes_Lock_List) do
        for w in ipairs(Routes_Lock_List[q])do
            
            if Check_Route == Routes_Lock_List[q][w] then
               
                Locked = true

                break

            else

                Locked = false

            end
        end
    end

    return Locked
end

local function Route_Set(Route)

    if Route == "DF_DM" then

        table.insert(Route_Locks, Routes_Lock_List[1])
        Modem_Junction.transmit(2, 500, {"DF", upStates[1]})
        -- no points changed
        table.remove(Route_Queues[1], 1)
        
    elseif Route == "DS_DM" then

        table.insert(Route_Locks, Routes_Lock_List[2])
        Modem_Junction.transmit(2, 500, {"DS", upStates[2]})
        DigConBox.setAspect("P2", 5)
        table.remove(Route_Queues[2], 1)

    elseif Route == "UM_UF" then

        table.insert(Route_Locks, Routes_Lock_List[3])
        Modem_Junction.transmit(2, 500, {"UM", upStates[3]})
        -- no points changed
        table.remove(Route_Queues[1], 1)

    elseif Route == "UM_US" then

        table.insert(Route_Locks, Routes_Lock_List[4])
        Modem_Junction.transmit(2, 500, {"UM", upStates[3]})
        DigConBox.setAspect("P1", 5)
        table.remove(Route_Queues[2], 1)

    end 
end

local function Queue_Check() -- check queue for waiting trians

    local Route_Locked = {nil, false}

    if Route_Queues[1][1] ~= nil or Route_Queues[2] ~= nil then -- Checking Queues
        if Route_Queues[1][1] ~= nil then -- Fast Queue
            
            Route_Locked = {Route_Queues[1][1], Route_Lock_Check(Route_Queues[1][1])}

        elseif Route_Queues[2][1] ~= nil then -- Slow Queue

            Route_Locked = {Route_Queues[2][1], Route_Lock_Check(Route_Queues[2][1])}

        end

        if Route_Locked[2] == false then
        
            Route_Set(Route_Locked[1])
    
        end
    end 
end

local function Route_unLock(route) 

    route.gsub("E", "")

    if route == "DM" then

        for q in ipairs(Route_Locks) do

            if Route_Locks[q] == "DF_DM_locks" or "DS_DM_locks" then

                table.remove(Route_Locks, q)

            end    
        end

    elseif route == "US" then

        for q in ipairs(Route_Locks) do
            
            if Route_Locks[q] == "UM_US_locks" then

                table.remove(Route_Locks, q)

            end 

        end

    elseif route == "UF" then

        for q in ipairs(Route_Locks) do
            
            if Route_Locks[q] == "UM_UF_locks" then

                table.remove(Route_Locks, q)

            end
        end
    end
end

local function modemMessageCheck()

    os.startTimer(0.05) -- stop os.pull() indefinitely
    local event, _, name, _, message = os.pullEvent()

    if event == "modem_mesasge" then

        if message[1] == "EUM" or "EDF" or "EDS" then

            Route_unLock(message)

        elseif message[2] == "caution" or "clear" then

            if message[1] == "UF" then
                
                upStates[1] = message[1]

            elseif message[1] == "US" then

                upStates[2] = message[1]

            elseif message[1] == "DM" then

                upStates[3] = message[1]

            end

            -- signal change function?

        elseif message[1] == IDs[2] then
        end

    elseif event == "aspect_changed" then

        if name == "DF" then

            table.insert(Route_Queues[1], "DF_DM")

        elseif name == "DS" then

            table.insert(Route_Queues[2], "DS_DM")
            
        end
    end
end

local function InitLineID(compID)

    Modem_Main.transmit(3, 500, IDs[2])
    Modem_Junction.transmit(2, 500, "request")
    -- add thing saying sent Init for LineID and Exit Detec
    
end


-- Startup

InitLineID(IDs[1])

while true do

    Queue_Check()
    modemMessageCheck()

end