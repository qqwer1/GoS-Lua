-- KappaMon
-- 1 = Creep
-- 2 = SmallMob
-- 3 = BigMob
-- 4 = Kill/Assist
-- 5 = Drake_Element
-- 6 = Rift/Baron/Ender
-- 7 = Win
local expGain = { [1] = 1, [2] = 1, [3] = 3, [4] = 5, [5] = 10, [6] = 25, [7] = 100}

--expNeeded
local level = GetLevel(myKappa)
local NeededExp = 100*level+(100*(0.5*level))
