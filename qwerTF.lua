-- qwerTF.lua VIP only ofc pls pfff all those plebs Kappa
-- dont even say thanks senpaii for making me wet ohhiiii kawaii origato
-- sick combos you know W Q BOOM! VIP
-- no R ofc bcs its would be retarded LUL
-- ay and again like at qwerShyv.lua no jungle fuking clear and no waveclear bcs I can use Q by pressing my Q key LOL
-- something else? hmm it draws a card above your HEAD Kappa
-- sick fow gold card stun support for the Q 
-- sick auto follow with Q if you hit a bronze player with ur gold card PogChamp

if GetObjectName(GetMyHero()) ~= "TwistedFate" then return end

if not pcall( require, "OpenPredict" ) then PrintChat("You are missing OpenPredict.lua!") return end

local pewpewQ = {delay = 0.25, speed = 1000, width = 40, range = 1500}
local kamehamehaAA = {delay = 0.25, speed = 1600, width = 5, range = 525}

local pickTHISfukingCARDnow = "Its a vip only feature XD"

local mainMenu = Menu("tf", "qwerTwistedFate")
mainMenu:Key("yellow", "Pick the yellow card", string.byte("W") )
mainMenu:Key("blue", "Pick the blue card", string.byte("E"))
mainMenu:Key("red", "Pick the red card", string.byte("T") )
mainMenu:Key("Combo1", "Start QWER (without R)", string.byte(" "))

local sickCardTimeTrackerToNotGetRektByPingFails = 0
local currentCardAboveYourFuking4Head = "nil"
local currentlyPickingAfukingCardjustW8abit = false

OnCreateObj(function(Object)
	if GetObjectBaseName(Object) == "PickaCard_yellow_tar.troy" then
		if CanUseSpell(myHero,0) == READY and GetDistance(Object) <= pewpewQ.range + pewpewQ.width then
			for i,enemy in pairs(GetEnemyHeroes()) do
				if GetDistance(enemy,Object) < 70 and not IsDead(enemy) then
					CastSkillShot(0,GetOrigin(Object))
				end
			end
		end
	end
	if GetDistance(Object) < 5 then
		if GetObjectBaseName(Object) == "Card_Yellow.troy" then
			currentCardAboveYourFuking4Head = "yellow"
			currentlyPickingAfukingCardjustW8abit = false
		elseif GetObjectBaseName(Object) == "Card_Blue.troy" then
			currentCardAboveYourFuking4Head = "blue"
			currentlyPickingAfukingCardjustW8abit = false
		elseif GetObjectBaseName(Object) == "Card_Red.troy" then
			currentCardAboveYourFuking4Head = "red"
			currentlyPickingAfukingCardjustW8abit = false
		end
	end
	if GetDistance(Object) < 5 then
		if GetObjectBaseName(Object):lower():find("twistedfate_base_w_") then
			currentlyPickingAfukingCardjustW8abit = true
		end
		if GetObjectBaseName(Object):lower():find("twistedfate_base_w_"..pickTHISfukingCARDnow) then
			CastSpell(1)
			pickTHISfukingCARDnow = "Back to vip Kappa"
		end
		if GetObjectBaseName(Object):lower():find("twistedfate_base_w_gold") and mainMenu.Combo1:Value() then
			CastSpell(1)
		end
	end
end)

OnDeleteObj(function(Object)
	if GetDistance(Object) < 5 and GetObjectBaseName(Object):find("Card_") then
		DelayAction(function()
			currentCardAboveYourFuking4Head = "nil"
		end, 0.2)
	end
end)

OnIssueOrder(function(orderProc)
	if orderProc.flag == 3 and mainMenu.Combo1:Value() and currentlyPickingAfukingCardjustW8abit == true then
		if GetObjectType(orderProc.target) == Obj_AI_Hero then
			local aaPred = GetPrediction(orderProc.target,kamehamehaAA)
			if GetDistance(aaPred.castPos) > kamehamehaAA.range + GetHitBox(orderProc.target) and GetMoveSpeed(myHero) - 40 < GetMoveSpeed(orderProc.target) then
				BlockOrder()
				-- print("BOOM BLOCKED AA! WHILE PICKING A FUKING CARD")
			end
		end
	end
end)

local isAA = false

OnProcessSpell(function(unit,spell)
	if unit == myHero then
		if spell.name:lower():find("attack") then		
			IsAA = true
			DelayAction(function()
				IsAA = false
			end,spell.windUpTime)
		end
	end
end)


local global_ticks = 0

OnTick(function()
if mainMenu.yellow:Value() then
	pickTHISfukingCARDnow = "gold"
elseif mainMenu.blue:Value() then
	pickTHISfukingCARDnow = "blue"
	local Ticker = GetTickCount()
	if (global_ticks + 500) < Ticker and currentlyPickingAfukingCardjustW8abit == false then
		CastSpell(1)
		global_ticks = Ticker
	end
elseif mainMenu.red:Value() then
	pickTHISfukingCARDnow = "red"
	local Ticker = GetTickCount()
	if (global_ticks + 500) < Ticker and currentlyPickingAfukingCardjustW8abit == false then
		CastSpell(1)
		global_ticks = Ticker
	end
end
	if mainMenu.Combo1:Value() and not IsDead(myHero) then
		local target = GetCurrentTarget()
		if CanUseSpell(myHero,0) == READY and ValidTarget(target,pewpewQ.range + 100) then
			local qPred = GetPrediction(target,pewpewQ)
			-- if (qPred and qPred.hitChance >= 0.99 and GetDistance(GetOrigin(target), qPred.castPos) < 50 ) or (GetDistance(target) < 500 and qPred.hitChance >= 0.8) then
			if (qPred and GetDistance(GetOrigin(target), qPred.castPos) < 50 ) or (GetDistance(target) < 550 and CanUseSpell(myHero,1) == ONCOOLDOWN and not currentCardAboveYourFuking4Head == "yellow" and isAA == false) then
				CastSkillShot(0,qPred.castPos)
			end
		end
		if CanUseSpell(myHero,1) == READY then
			if GotBuff(myHero,"pickacard_tracker") == 0 and ValidTarget(target, 850) then
			local Ticker = GetTickCount()
				if (global_ticks + 350) < Ticker then
					CastSpell(1)
				global_ticks = Ticker
				end
			end
		end
	end
end)
