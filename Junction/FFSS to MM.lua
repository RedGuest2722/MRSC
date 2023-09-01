routeLock = {0,0,0,0}

routeQueue = {}

modemExit = peripheral.wrap("")
modemEnter = peripheral.wrap("")
modemMain = peripheral.wrap("")

function queueCheck() -- check queue for waiting trians
    
end

function queueAdd(from, to) --

end

function routeSet()
    
end

function exit()
    
end

function routeLockCheck()

end

function upStateRequest() --
    
end

function signalSet()
    
end

function modemMessageCheck()

    os.startTimer(0.1) -- this stops the os.pull() from running indefinitly
    event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent()

    if message[1] == "train F" or "train S" or "train M" then
        
        if message[1] == "train F" then
            
            queueAdd("FL", "ML")

        elseif message[1] == "train S" then
            
            queueAdd("SL", "ML")

        elseif message[1] == "train M" then
            
            queueAdd("ML", message[2])

        end

    elseif message == "exit" then

        junctionLock = 0

    end

     
    
end
