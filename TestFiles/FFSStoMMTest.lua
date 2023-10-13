

local Monitor = "monitor_3"
local IDs = {os.getComputerID(), 35}

local Modem_Junction = peripheral.wrap("right")
local Modem_Main = peripheral.wrap("back")
local DigConBox = peripheral.wrap("top")

Modem_Main.open(3)
Modem_Junction.open(2)

local Route_Locks = {}
local upStates = {}
local Route_Queues = {Fast = {}, Slow = {}}

local Routes_Lock_List = {
    UF_UM = {"US_UM"},
    US_UM = {"UF_UM", "DM_DF"},
    DM_DF = {"US_UM", "DM_DF"},
    DM_DS = {"DM_DF"}
}

local function Route_Lock_Check(Check_Route)
    for _, routeList in pairs(Routes_Lock_List) do
        if routeList[Check_Route] then
            return true
        end
    end
    return false
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


local function Queue_Check()
    local Route_Locked = {nil, false}
    if Route_Queues.Fast ~= nil then
        Route_Locked = {Route_Queues.Fast[1], Route_Lock_Check(Route_Queues.Fast[1])}
    elseif Route_Queues.Slow ~= nil then
        Route_Locked = {Route_Queues.Slow[1], Route_Lock_Check(Route_Queues.Slow[1])}
    end
    if not Route_Locked[2] then
        Route_Set(Route_Locked[1])
    end
end

local function Route_unLock(route)
    route = route:gsub("E", "")
    for i, lock in ipairs(Route_Locks) do
        if lock == route then
            table.remove(Route_Locks, i)
            break
        end
    end
end

local function modemMessageCheck()
    os.startTimer(0.05)
    local event, _, name, _, message = os.pullEvent()
    if event == "modem_message" then
        if message[1] == "EUM" or message[1] == "EDF" or message[1] == "EDS" then
            Route_unLock(message)
        elseif message[2] == "caution" or message[2] == "clear" then
            upStates[message[1]] = message[2]
        elseif message[1] == IDs[2] then
            -- Handle this case
        end
    elseif event == "aspect_changed" then
        if name == "DF" then
            table.insert(Route_Queues.Fast, "DF_DM")
        elseif name == "DS" then
            table.insert(Route_Queues.Slow, "DS_DM")
        end
    end
end

local function InitLineID(compID)
    Modem_Main.transmit(3, 500, IDs[2])
    Modem_Junction.transmit(2, 500, "request")
    -- Add any necessary initialization steps here
end

InitLineID(IDs[1])

while true do
    Queue_Check()
    modemMessageCheck()
end
