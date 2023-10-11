-- Main lines into Fast & Slow Lines
-- slow lines come off main


os.loadAPI("Moduals/junctionInterface.lua")

-- Variables

local Monitor = "monitor_3" -- set the name of the monitor (Usually monitor_0)

local Modem_Junction = peripheral.wrap("top")
local Modem_Incoming = peripheral.wrap("left")
local Modem_Main = peripheral.wrap("back")

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

    if Route_Queues[1][1] ~= nil or Route_Queues[2] ~= nil then
        if Route_Queues[1][1] ~= nil then
            
            Route_Locked = {Route_Queues[1][1], Route_Lock_Check(Route_Queues[1][1])}

        elseif Route_Queues[2][1] ~= nil then

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

local function upStateRequest() --
    
end

local function signalSet()
    
end

local function modemMessageCheck()

end


while true do

    Queue_Check()

end