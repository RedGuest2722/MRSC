-- auto signal

digitalControllerName = ""        -- please set the name of digital controller
digitalList = {"Locking", "Clear", "Caution", "Signal"}
autoSignalSend = 8
autoSignalrecieve = 7


digitalController = peripheral.wrap(digitalControllerName)

modem_recieve = peripheral.wrap("left")
modem_recieve.open(8)

modem_send = peripheral.wrap("right")
modem_send.open(8)

modem_main = peripheral.wrap("bottem")
rednet.open(modem_main)

function Occupied()

    digitalController.setAspect(digitalList[1], 5)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 1)
    digitalController.setAspect(digitalList[4], 5)

end

function Warning()
       
    digitalController.setAspect(digitalList[1], 1)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 3)

end

function Clear()
        
    digitalController.setAspect(digitalList[1], 1)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 1)

end

function updateMain(status)

    rednet.send(status)
    
end

while true do
    
    trainPass = redstone.getInput("top")

    if trainPass > 0 then
        
        Occupied()
        blockStatus = 0
        mainToChange = 1

        return blockStatus, mainToChange

    end



end