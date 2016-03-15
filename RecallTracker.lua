-- RecallTracker

local rtMenu = Menu("Recall Tracker", "Recall Tracker")
rtMenu:Boolean("trackRecall", "Track Recalls", true)

local rt = {}
local screen = GetResolution()

OnProcessRecall(function(Object,recallProc)

	if recallProc.isStart == true then
		local info = { rTime = 0, rTimeNeed = nil , who = nil, color = ARGB(130,255,255,255), currentTime = 0 }
		rt[GetNetworkID(Object)] = info
		rt[GetNetworkID(Object)].rTime = recallProc.totalTime
		rt[GetNetworkID(Object)].rTimeNeed = recallProc.totalTime/1000 + GetGameTimer()
		rt[GetNetworkID(Object)].who = Object
		rt[GetNetworkID(Object)].color = ARGB(130,255,255,255)
	elseif recallProc.isFinish == true then
		rt[GetNetworkID(Object)].rTime = 0
		rt[GetNetworkID(Object)].who = nil
	else
		rt[GetNetworkID(Object)].who = Object
		rt[GetNetworkID(Object)].color = ARGB(155,255,5,25)
		DelayAction(function()
			rt[GetNetworkID(Object)].who = nil
		end,0.75)
	end
end)

OnDraw(function(myHero)
if rtMenu.trackRecall:Value() then
	for i,enemy in pairs(GetEnemyHeroes()) do
		if rt[GetNetworkID(enemy)] ~= nil then
			if rt[GetNetworkID(enemy)].who ~= nil and rt[GetNetworkID(enemy)].rTime ~= nil and rt[GetNetworkID(enemy)].color ~= nil then
				drawRecallTracker(ARGB(250,28,28,28))
				trackRecall(rt[GetNetworkID(enemy)])
			end
		end
	end
end
end)

function trackRecall(tab)
	local t = (1000/tab.rTime)*(tab.rTimeNeed - GetGameTimer())
	if tab.color["g"] ~= 5 then
		tab.currentTime = t
	end
	DrawText(GetObjectName(tab.who).."("..math.round(100*GetCurrentHP(tab.who)/GetMaxHP(tab.who)).."%)", 12, screen.x/2-198+(397*tab.currentTime) - (2.25*string.len(GetObjectName(tab.who))) - 10, screen.y/1.337-25, tab.color)
	FillRect(screen.x/2-198+(397*tab.currentTime), screen.y/1.337+3, -1, 15, tab.color)
	FillRect(screen.x/2-198, screen.y/1.337+3, (397*tab.currentTime), 11, tab.color)
end

function drawRecallTracker(color)
FillRect(screen.x/2-200, screen.y/1.337, 400, 2, color)
FillRect(screen.x/2-200, screen.y/1.337+15, 400, 2, color)
FillRect(screen.x/2-200, screen.y/1.337, 1, 15, color)
FillRect(screen.x/2+200, screen.y/1.337, 1, 17, color)
FillRect(screen.x/2-200, screen.y/1.337, 400, 15, ARGB(100,28,28,28))
end
