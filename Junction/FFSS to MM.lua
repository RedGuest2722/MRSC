-- Main lines into Fast & Slow Lines
-- slow lines come off main


os.loadAPI("Moduals/junctionInterface.lua")

-- Variables

local Monitor = "monitor_3" -- set the name of the monitor (Usually monitor_0)
local DigBox = "digital_receiver_box_1" -- set the name of the Digital Receiver (Usually digital_reciever_0)
local IDs = {os.getComputerID, 35} -- set ID of UM (in slot 2) Train type detector

local Modem_Junction = peripheral.wrap("top")
local Modem_Incoming = peripheral.wrap("left")
local Modem_Main = peripheral.wrap("back")

Modem_Main.open(3)

-- tell computer which routes are locked, via 3D arrays
local Route_Locks = {}

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

    if Route == "UF_UM" then

        table.insert(Route_Locks, Routes_Lock_List[1])
        
    elseif Route == "US_UM" then

        table.insert(Route_Locks, Routes_Lock_List[2])

    elseif Route == "DM_DF" then

        table.insert(Route_Locks, Routes_Lock_List[3])

    elseif Route == "DM_DS" then

        table.insert(Route_Locks, Routes_Lock_List[4])

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
    end

    if Route_Locked[2] == false then
        
        Route_Set(Route_Locked[1])

    end
end

local function queueAdd() --

end

local function exit()
    
end

local function upStateRequest() 
    
end

local function signalSet()
    
end

local function Route_unLock(route)

    route.gsub("E", "")

    if route == "UM" then

        for q in ipairs(Route_Locks) do

            if Route_Locks[q] == "UF_UM_locks" or "US_UM_locks" then

                table.remove(Route_Locks, q)

            end    
        end

    elseif route == "DS" then

        for q in ipairs(Route_Locks) do
            
            if Route_Locks[q] == "DM_DS_locks" then

                table.remove(Route_Locks, q)

            end 

        end

    elseif route == "DF" then

        for q in ipairs(Route_Locks) do
            
            if Route_Locks[q] == "DM_DF_locks" then

                table.remove(Route_Locks, q)

            end 

        end

    end
end

local function modemMessageCheck()

    -- ELL message from exit dect

    os.startTimer(0.05)
    os.startTimer(0.1) -- stop os.pull() indefinitely
    local event, _, name, aspect, message = os.pullEvent()

    if event == "modem_mesasge" then

        if message == "EUM" or "EDF" or "EDS" then

            Route_unLock()

        end
    end
end

local function InitLineID(compID)

    Modem_Main.transmit(3, 500, tostring(compID))
    -- add thing saying sent Init to LIneID on interface
    
end


-- Startup

InitLineID(IDs[1])

while true do

    Queue_Check()

end