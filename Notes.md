-- 4 States (Green = 1, Caution = 3, Danger = 5, Flashing Caution = 2)
-- 4 Speeds (Green = 4, Caution = 2, Danger = 0, Turnoff = 1)    The "1" is active =<4 blocks before the points
-- 3 Block Status (Occupied = 0, Caution = 1, Clear = 2)
-- order of digital controller (Locking, Clear, Caution, Signal)


-- channel list = (main = 1, down = 2, up = 3)


clear state:
- signal block state clear
- up block nothing
- down block nothing

Caution state:
- signal block state Caution
- up block recieve
- downblock send clear

Danger state:
- signal block state Danger
- up block nothing
- down block send caution

-- events
    -- local event, side, oldState, newState = os.pullEvent("redstone")

    -- local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")


-- test