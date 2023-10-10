local repo_main = "https://raw.githubusercontent.com/RedGuest2722/MRSC/main/"

local files = {"Signals/Moduals/signalInterface.lua", "Junction/FFSS to MM.lua", "Junction/SFFS to MM.lua", "Signals/autoSignal_noMain.lua", "Signals/repeaterSignal_noMain.lua", "Signals/multiSignal_noMain.lua"}
local dir_find = {"Signals/", "Junction/"}


-- Function to delete directories
function del_dirs()
    -- Iterate through each file in the files array
    for w in ipairs(files) do
        
        -- Check if the file exists
        if fs.exists(files[w]) then
            
            -- Delete the file
            fs.delete(files[w])

        end
    end
end

-- Function to download and execute a file
function download(file_download)

    -- Delete existing directories
    del_dirs()

    -- Download the file
    local handle = http.get(repo_main .. file_download)
    local content = handle.readAll()
    handle.close()

    -- Iterate through directories to find
    for q = 1, 2 do
        
        -- Find directory in file path
        local startPos, endPos = string.find(file_download, dir_find[q])

        -- If directory found
        if startPos then
            
            -- If directory exists
            if fs.exists(dir_find[q]) then

                -- Save the file
                local fileHandle = fs.open(file_download, "w")
                fileHandle.write(content)
                fileHandle.close()

            else

                -- If last directory, create it
                if dir_find[q] == dir_find[2] then

                    fs.makeDir(dir_find[2])

                else

                    -- Create first directory
                    fs.makeDir(dir_find[1] .. "Moduals/")

                end

                -- Save the file
                local fileHandle = fs.open(file_download, "w")
                fileHandle.write(content)
                fileHandle.close()

            end
        end
    end

    -- If Signal directory exists
    if fs.exists(dir_find[1]) then

        -- Download the Signal Interface
        handle = http.get(repo_main .. files[1])
        content = handle.readAll()
        handle.close()

        -- Save the Signal Interface
        local fileHandle = fs.open(files[1], "w")
        fileHandle.write(content)
        fileHandle.close()
    
    end

    -- Execute the downloaded file
    shell.execute(file_download)
end

for e in ipairs(files) do

    num = e + 1

    if num == #files then

        print("no file to start found.")

        break

    elseif fs.exists(files[num]) then

        download(files[num])

        break
  
    end  
end