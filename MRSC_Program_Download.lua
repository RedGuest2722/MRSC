-- MRSC Program Download

--Variables

local repo_main = "https://raw.githubusercontent.com/RedGuest2722/MRSC/development/"

local files = {
    "Signals/Moduals/signalInterface.lua",
    "Junction/FFSStoMM.lua",
    "Junction/SFFStoMM.lua",
    "Signals/autoSignal_noMain.lua",
    "Signals/repeaterSignal_noMain.lua",
    "Signals/manualSignal_noMain.lua",
    "Junction/LineIdentifier.lua",
    "Junction/Exit_Detector.lua"
}

local version = "0.0.2"
local requires_settings = false
local computerID = nil
local line = nil
local file_write = nil

local function write_settings(path, type, file)
    if type == "Junction" then
        if file == files[2] or file == files[3] then
            print("please type the computer ID of the Mainline Line identifier")
            computerID = read()
        end
    elseif type == "Signal" then
        print("please type the type of line the computer is for")
        print("either UM, DM, UF, DF, US, UF.")
        print("that is not code U/D stands for up/down and M/F/S stands for main/fast/slow")
        line = read()
    end

    if computerID ~= nil then
        file_write = fs.open("Junction/settings.txt")
        file_write.write(computerID)
        file_write.close()
    end
end

local function file_settings(file)

    print("Files downloaded")
    print("")

    if selection == "1" then
        if file == files[6] then
            requires_settings = true
        end
    elseif selection == "2" then
        if file == files[2] or file == files[3] or file == files[8] then
            requires_settings = true
        end
    end
    
    if requires_settings then
        if string.gmatch(file, "Junction") then
            fs.makeDir("Junction/settings.txt")
            write_settings("Junction/settings.txt", "Junction", file)
        elseif string.gmatch(file, "Signals") then
            fs.makeDir("Signals/settings.txt")
            write_settings("Signals/settings.txt", "Signal", file)
        end
    end        
end

-- Download and save file
local function download(file)
    -- Get file from repo
    local handle = http.get(repo_main .. file)
    local content = handle.readAll()
    handle.close()

    -- Save file locally in the correct directory
    local fileHandle = fs.open(file, "w")
    fileHandle.write(content)
    fileHandle.close()

    file_settings()
end

-- where it begins
print("MRSC Downloader Version: " .. version)
print("some files may be NIOP.")
print("All files will automatically update on startup.")
print("")

if http.checkURL(repo_main) == false then
    
    error("Can't reach the repository. \nExited MRSC Program Download.")

end

print("1: For Signals")
print("2: For Junctions")
print("3: For Stations (NIOP)")

selection = tostring(read())
print("")

if selection == "1" then

    print("Signal Selection: ")
    print("1: Automatic Signal")
    print("2: Repeater Signal")
    print("3: Manual Signal")

    typeProgram = tostring(read())
    
elseif selection == "2" then

    print("Junction Selection: ")
    print("1: FFSS to MM")
    print("2: SFFS to MM")
    print("3: Line Identifier")
    print("4: Junction Exit Detector")

    typeProgram = tostring(read())

elseif selection == "3" then
    
    print("Station Selection: ")
    error("NIOP")

else

    error("Not a choice.")

end

print("")
download("startup.lua")

if selection == "1" then

    fs.makeDir("Signals/Moduals/")

    download(files[1])
    
    if typeProgram == "1" then

        download(files[4])

    elseif typeProgram == "2" then

        download(files[5])

    elseif typeProgram == "3" then

        download(files[6])

    else

        error("Not a choice")
        
    end

elseif selection == "2" then

    fs.makeDir("Junction")

    if typeProgram == "1" then
        
        download(files[2])

    elseif typeProgram == "2" then

        download(files[3])

    elseif typeProgram == "3" then

        download(files[7])

    elseif typeProgram == "4" then

        download(files[8])

    else

        error("Not a choice")

    end
end

print("would you like to start the program (yes/no)")

local start = string.lower(read())

if start == "yes" or start == "y" then
    
    shell.execute("startup.lua")

end
