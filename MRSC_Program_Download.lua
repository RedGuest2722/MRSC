-- MRSC Program Download

--Variables

local repo_main = "https://raw.githubusercontent.com/RedGuest2722/MRSC/development/"
local files = {"Signals/Moduals/signalInterface.lua", "Junction/FFSS to MM.lua", "Junction/SFFS to MM.lua", "Signals/autoSignal_noMain.lua", "Signals/repeaterSignal_noMain.lua", "Signals/manualSignal_noMain.lua"}
local version = "0.0.2"

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
end

print("MRSC Downloader Version: " .. version)
os.sleep(1)

print("some files may be NIOP.")
os.sleep(1)

print("All files will automatically update on startup.")
os.sleep(1)

if http.checkURL(repo_main) == false then
    
    error("Can't reach the repository. \nExited MRSC Program Download.")

end

print("1: For Signals")
print("2: For Junctions")
print("3: For Stations (NIOP)")

selection = tostring(read())

if selection == "1" then

    print("Signal Selection: ")
    os.sleep(0.5)

    print("1: Automatic Signal")
    print("2: Repeater Signal")
    print("3: Manual Signal")

    typeProgram = tostring(read())
    
elseif selection == "2" then

    print("Junction Selection: ")
    os.sleep(0.5)

    print("1: FFSS to MM")
    print("2: SFFS to MM")

    typeProgram = tostring(read())

elseif selection == "3" then
    
    print("Station Selection: ")
    os.sleep(0.5)

    error("NIOP")

else

    error("Not a choice.")

end

download("Startup.lua")

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

    else

        error("Not a choice")

    end
end

print("Files downloaded")

os.sleep(0.5)

print("would you like to start the program (yes/no)")

local start = string.lower(read())

if start == "yes" then
    
    shell.execute("Startup.lua")

end
