-- 4 States (Green = 1, Caution = 3, Danger = 5, Flashing Caution = 2)
-- 4 Speeds (Green = 4, Caution = 2, Danger = 0, Turnoff = 1)    The "1" is active =<4 blocks before the points
-- 3 Block Status (Occupied = 0, Caution = 1, Clear = 2)
-- order of digital controller (Locking, Clear, Caution, Signal)

-- state = [state, down, main]

-- modem ports main = 5, down/up = 2

-- redstone aspect = red(5) then redstone torch is on