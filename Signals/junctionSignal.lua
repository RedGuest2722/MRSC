-- junction signal

-- variables
digitalList = {"Locking", "Clear", "Caution", "Signal"}
upstate = "caution"

-- wraping peripherals
digitalController = peripheral.wrap("bottom")

modemMain = peripheral.wrap("back")
modemDown = peripheral.wrap("left")
modemUp = peripheral.wrap("right")

-- ports
modemMain.open(5)
modemDown.open(2)
modemUp.open(2)


-- change screen colours
function screen(colour)

    term.setBackgroundColor(colour)
    term.clear()

end

function occupied()

    digitalController.setAspect(digitalList[1], 1)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 5)
    
    screen(colors.red)

end

function caution()
   
    digitalController.setAspect(digitalList[1], 5)
    digitalController.setAspect(digitalList[2], 1)
    digitalController.setAspect(digitalList[3], 5)
    digitalController.setAspect(digitalList[4], 3)
    
    screen(colors.orange)

end

function clear()

    digitalController.setAspect(digitalList[1], 5)
    digitalController.setAspect(digitalList[2], 5)
    digitalController.setAspect(digitalList[3], 1)
    digitalController.setAspect(digitalList[4], 1) 
    
    screen(colors.green)  

end