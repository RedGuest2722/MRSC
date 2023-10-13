-- Junction where slow lines merge with fast lines to become mainlines

local settings_table = {}

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

local function event_check()

    local event, _, name, _, message = os.pullEvent()

    if event == "modem_message" then
        
        if message[1] == "request" then
            
            --

        elseif string.match(message[1], "E") == "E" then

            --

        elseif tostring(message[1]) == settings_table[1] then

            --

        end

    elseif event == "aspect_changed" then

        --
        
    end
    
end