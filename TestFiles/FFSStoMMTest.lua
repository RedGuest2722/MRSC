-- Junction where slow lines merge with fast lines to become mainlines

-- Varibales
local settings_table = {}

-- read settings file and output into a table that can be used
if fs.exists("Junction/settings.txt") then
    local settings_file = fs.open("Junction/settings.txt", "r")
    local contents = settings_file.readAll()
    settings_file.close()
    local lines = contents.split("\n")
    for i, line in ipairs(lines) do
        settings_table[i] = line
    end
else
    error("No setup file found")
end

-- Basically the control of the program as it deals with all the "control messages"
local function event_check()

    local event, _, name, _, message = os.pullEvent()

    if event == "modem_message" then
        
        if message[1] == "request" then -- 
            
            --

        elseif message[1][1] == "E" then

            --

        elseif tostring(message[1]) == settings_table[1] then

            --

        end

    elseif event == "aspect_changed" then

        --
        
    end
    
end