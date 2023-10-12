-- my download: wget https://raw.githubusercontent.com/RedGuest2722/MRSC/development/MRSC_Program_Download.lua

-- 4 States (Green = 1, Caution = 3, Danger = 5, Flashing Caution = 2)
-- 4 Speeds (Green = 4, Caution = 2, Danger = 0, Turnoff = 1)    The "1" is active =<4 blocks before the points
-- 3 Block Status (Occupied = 0, Caution = 1, Clear = 2)
-- order of digital controller (Locking, Clear, Caution, Signal)

-- state = [state, down, main]

-- modem ports main = 5, down/up = 2, LineChoice = 3, lineExit = 2

-- redstone aspect = red(5) then redstone torch is on

-- Redstone is shortened to RS

Junctions:
-- hold signal ahead data to transmit to previous for allowing across junction on exit computer

-- aspect_changed, boxname, controllerName, aspect == os.pullevent() -- for digital rec
-- aspect = 1 when changed

-- regarding identifing the track to go from MM use modem.transmit(outport, inport, list -->) but us list {id_junc_comp, line (UF, US)}
-- corresponding dyes to trains{
    electric freight = top: Orange, Bottem: Brown = RS 15 strength          -- slow
    electric passeng = top: Blue, Bottem: Gray = RS 14 strength             -- fast

    steam freight = top: Black, Bottem: Gray = RS 13 strength               -- slow
    steam passeng = top: Green, Bottem: Gray = RS 12 strength               -- fast

    perp fast me = top: black, Bottem: magenta = RS 11 strength             -- fast
}

