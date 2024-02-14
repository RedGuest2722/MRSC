local settings_table = {}

print(fs.getDir())

if fs.exists("settings.txt") then
    local settings_file = fs.open("settings.txt", "r")
    local contents = settings_file.readAll()
    settings_file.close()
    local lines = contents.split("\n")
    for i, line in ipairs(lines) do
        settings_table[i] = line
    end
else
    error("No setup file found")
end

print(settings_table)