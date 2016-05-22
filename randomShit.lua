-- KappaMon
-- 1 = Creep
-- 2 = SmallMob
-- 3 = BigMob
-- 4 = Kill/Assist
-- 5 = Drake_Element
-- 6 = Rift/Baron/Ender
-- 7 = Win
local expGain = { [1] = 1, [2] = 1, [3] = 3, [4] = 5, [5] = 10, [6] = 25, [7] = 10*math.round(GameTime)}
local evolution = { [0] = {stage = 0, img = KappaMon0.png}, [20] = {stage = 1, img = KappaMon1.png}, [50] = {stage = 2, img = KappaMon2.png}, [100] = {stage = 3, img = KappaMon3.png}}
--expNeeded
local level = GetLevel(myKappa)
local NeededExp = 100*level+(100*(0.5*level))
