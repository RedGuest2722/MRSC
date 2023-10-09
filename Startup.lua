local repo_main = "https://raw.githubusercontent.com/RedGuest2722/MRSC/main/"

local files = {"Signals/Moduals/signalInterface.lua", "Junction/FFSS to MM.lua", "Junction/SFFS to MM.lua", "Signals/autoSignal_noMain.lua", "Signals/repeaterSignal_noMain.lua", "Signals/multiSignal_noMain.lua"}
local dir_find = {"Signals/", "Junction/"}


local function del_dirs()
    for w in ipairs(files) do
        
        if fs.exists(files[w]) then
            
            fs.delete(files[w])

        end
    end
end

local function download(file_download)

    del_dirs()

    -- Download the file
    local handle = http.get(repo_main .. file_download)
    local content = handle.readAll()
    handle.close()

    for q = 1, 2 do
        
        local startPos, endPos = string.find(file_download, dir_find[q])

        if startPos then
            
            if fs.exists(dir_find[q]) then

                -- Save the file
                local fileHandle = fs.open(file_download, "w")
                fileHandle.write(content)
                fileHandle.close()

            else

                if dir_find[q] == dir_find[2] then

                    fs.makeDir(dir_find[2])

                else

                    fs.makeDir(dir_find[1] .. "Moduals/")

                end

                -- Save the file
                local fileHandle = fs.open(file_download, "w")
                fileHandle.write(content)
                fileHandle.close()

            end
        end
    end

    print(fs.exists(dir_find[1]))

    os.sleep(5)

    if fs.exists(dir_find[1]) then

        -- Download the file
        handle = http.get(repo_main .. files[1])
        content = handle.readAll()
        handle.close()

        -- Save the file
        local fileHandle = fs.open(files[1], "w")
        fileHandle.write(content)
        fileHandle.close()
    
    end

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