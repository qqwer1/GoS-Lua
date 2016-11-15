-- qwerTF.lua VIP only ofc pls pfff all those plebs Kappa
-- dont even say thanks senpaii for making me wet ohhiiii kawaii origato
-- sick combos you know W Q BOOM! VIP
-- no R ofc bcs its would be retarded LUL
-- ay and again like at qwerShyv.lua no jungle fuking clear and no waveclear bcs I can use Q by pressing my Q key LOL
-- something else? hmm it draws a card above your HEAD Kappa
-- sick fow gold card stun support for the Q 
-- sick auto follow with Q if you hit a bronze player with ur gold card PogChamp
-- PogChamp a new update for qwerTF with some sik drawings
-- 1SHOT HELPER: Will show you which enemy you can 1shot perfect for fuking ult tps
-- didnt test if it will work for 1. start but fuk it, it works for me

if GetObjectName(GetMyHero()) ~= "TwistedFate" then return end

if not DirExists(SPRITE_PATH.."Champions\\") then
	CreateDir(SPRITE_PATH.."Champions\\") 
end

local champSprite = {}

OnLoad(function()
	for i,v in pairs(GetEnemyHeroes()) do
		if FileExist(SPRITE_PATH.."Champions//"..GetObjectName(v)..".png") then
			champSprite[GetObjectName(v)] = CreateSpriteFromFile("Champions//"..GetObjectName(v)..".png",0.57)
		else
			DownloadFileAsync("https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/Sprites/Champions/"..GetObjectName(v)..".png",SPRITE_PATH.."Champions//"..GetObjectName(v)..".png", function() DelayAction(function() champSprite[GetObjectName(v)] = CreateSpriteFromFile("Champions//"..GetObjectName(v)..".png",0.55) end,0.05)	 return end)
		end
	end
end)

if not pcall( require, "OpenPredict" ) then PrintChat("You are missing OpenPredict.lua!") return end

local pewpewQ = {delay = 0.25, speed = 1000, width = 40, range = 1500}
local kamehamehaAA = {delay = 0.25, speed = 1600, width = 5, range = 525}

local pickTHISfukingCARDnow = "Its a vip only feature XD"

local mainMenu = Menu("tf", "qwerTwistedFate")
mainMenu:Key("yellow", "Pick the yellow card", string.byte("W") )
mainMenu:Key("blue", "Pick the blue card", string.byte("E"))
mainMenu:Key("red", "Pick the red card", string.byte("T") )
mainMenu:Key("Combo1", "Start QWER (without R)", string.byte(" "))
mainMenu:Boolean("drawOneShot","Draw 1Shot Helper", true)
mainMenu:Boolean("fixAA","Fix Orbwalkers", true)

local sickCardTimeTrackerToNotGetRektByPingFails = 0
local currentCardAboveYourFuking4Head = "nil"
local currentlyPickingAfukingCardjustW8abit = false
local canAA = true
local eStack = false
local ludens = 0
local lich

OnCreateObj(function(Object)
	if GetObjectBaseName(Object) == "PickaCard_yellow_tar.troy" then
		if CanUseSpell(myHero,0) == READY and GetDistance(Object) <= pewpewQ.range + pewpewQ.width then
			for i,enemy in pairs(GetEnemyHeroes()) do
				if GetDistance(enemy,Object) < 60 and not IsDead(enemy) then
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
	if mainMenu.fixAA:Value() and orderProc.flag == 3 and canAA == false and mainMenu.Combo1:Value() then
		BlockOrder()
	end
	if orderProc.flag == 3 and mainMenu.Combo1:Value() and currentlyPickingAfukingCardjustW8abit == true then
		if GetObjectType(orderProc.target) == Obj_AI_Hero then
			local aaPred = GetPrediction(orderProc.target,kamehamehaAA)
			if GetDistance(aaPred.castPos) > kamehamehaAA.range + GetHitBox(orderProc.target) and GetMoveSpeed(myHero) - 40 < GetMoveSpeed(orderProc.target) then
				BlockOrder()
			end
		end
	end
end)

local isAA = false

OnProcessSpell(function(unit,spell)
	if unit == myHero then
		if spell.name == "Gate" then
			pickTHISfukingCARDnow = "gold"
			if GotBuff(myHero,"pickacard_tracker") == 0 then
				CastSpell(1)
			end
		end
		if spell.name:lower():find("attack") then		
			IsAA = true
			DelayAction(function()
				IsAA = false
			end,spell.windUpTime)
		end
	end
end)

OnProcessSpellComplete(function(unit,spell)
	if unit == myHero then
		if spell.name:lower():find("attack") then
			IsAA = false
			canAA = false
			DelayAction(function()
				canAA = true
			end,1/(GetBaseAttackSpeed(myHero)*GetAttackSpeed(myHero)) - spell.windUpTime - 0.1337)
		end
	end
end)

OnUpdateBuff(function(unit,buff)
	if unit == myHero then
		if buff.Name == "cardmasterstackparticle" then
			eStack = true
		end
		if buff.Name == "itemmagicshankcharge" then
			ludens = buff.Count
		end
	end
end)

OnRemoveBuff(function(unit,buff)
	if unit == myHero then
		if buff.Name == "cardmasterstackparticle" then
			eStack = false
		end
		if buff.Name == "itemmagicshankcharge" then
			ludens = 0
		end
	end
end)


local global_ticks = 0
local item_ticks = 0

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
		if CanUseSpell(myHero,1) == READY then
			if GotBuff(myHero,"pickacard_tracker") == 0 and ValidTarget(target, 850) then
			local Ticker = GetTickCount()
				if (global_ticks + 350) < Ticker then
					CastSpell(1)
				global_ticks = Ticker
				end
			end
		end
		if CanUseSpell(myHero,0) == READY and ValidTarget(target,pewpewQ.range + 100) then
			local qPred = GetPrediction(target,pewpewQ)
			-- if (qPred and qPred.hitChance >= 0.99 and GetDistance(GetOrigin(target), qPred.castPos) < 50 ) or (GetDistance(target) < 500 and qPred.hitChance >= 0.8) then
			-- if (qPred and GetDistance(GetOrigin(target), qPred.castPos) < 50 ) or (GetDistance(target) < 550 and CanUseSpell(myHero,1) == ONCOOLDOWN and not currentCardAboveYourFuking4Head == "yellow" and isAA == false) then
			if (qPred and GetDistance(GetOrigin(target), qPred.castPos) < 40 ) or (GetDistance(target) < 570 and CanUseSpell(myHero,1) == ONCOOLDOWN and currentlyPickingAfukingCardjustW8abit == false and isAA == false and currentCardAboveYourFuking4Head == "nil") then
				CastSkillShot(0,qPred.castPos)
			end
		end
	end
	local ItemTicker = GetTickCount()
	if (item_ticks + 5000) < ItemTicker then
		lich = GetItemSlot(myHero,3100)
		item_ticks = ItemTicker
	end
end)

OnLoad(function()

local drawThem = {}
local howLongIsMyDong = {}
for i,enemy in pairs(GetEnemyHeroes()) do
	howLongIsMyDong[GetNetworkID(enemy)] = math.huge
	if IsVisible(enemy) then
		drawThem[GetNetworkID(enemy)] = true
	else
		drawThem[GetNetworkID(enemy)] = false
	end
end

OnProcessRecall(function(unit,recall)
	if recall.isFinish == true and drawThem[GetNetworkID(unit)] == true and recall.isStart == false then
		-- print("Finished recall: "..unit.charName)
		drawThem[GetNetworkID(unit)] = false
	end
end)

OnLoseVision(function(unit)
	if drawThem[GetNetworkID(unit)] == true then
		howLongIsMyDong[GetNetworkID(unit)] = GetGameTimer()
	end
end)

	OnDraw(function()
		if mainMenu.drawOneShot:Value() then
			for i,enemy in pairs(GetEnemyHeroes()) do
				if not IsDead(enemy) then
					if IsVisible(enemy) then
						drawThem[GetNetworkID(enemy)] = true
					elseif not IsVisible(enemy) then
						local thatsHUGE = GetGameTimer() - howLongIsMyDong[GetNetworkID(enemy)]
						if thatsHUGE >= 20 then
							drawThem[GetNetworkID(enemy)] = false
						end
					end
					local qdmg = 0
					local wdmg = CalcDamage(myHero,enemy,(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0)
					local edmg = 0
					local lDmg = 0
					local lichDmg = 0
					local manaNeed = 0
					local myhppos = GetHPBarPos(myHero)
					if CanUseSpell(myHero,0) == READY then
						qdmg = CalcDamage(myHero,enemy,0,15+(45*GetCastLevel(myHero,0))+(GetBonusAP(myHero)*0.65))
						manaNeed = manaNeed + GetCastMana(myHero,0,GetCastLevel(myHero,0))
					end
					if CanUseSpell(myHero,1) == READY or currentCardAboveYourFuking4Head ~= "nil" or currentlyPickingAfukingCardjustW8abit == true then
						wdmg = CalcDamage(myHero,enemy,0,7.5 + (7.5*GetCastLevel(myHero,1)) + (GetBaseDamage(myHero)+GetBonusDmg(myHero)) + GetBonusAP(myHero)*0.5)
						manaNeed = manaNeed + GetCastMana(myHero,1,GetCastLevel(myHero,1))
					end
					if eStack == true then
						edmg = CalcDamage(myHero,enemy,0,30+(25*GetCastLevel(myHero,2))+(GetBonusAP(myHero)*0.5))
					end
					if ludens >= 90 then
						lDmg = CalcDamage(myHero,enemy,0,100+0.1*GetBonusAP(myHero))
					end
					if lich ~= nil and lich > 0 and CanUseSpell(myHero,lich) == 8 then
						lichDmg = CalcDamage(myHero,enemy,0, (0.75*GetBaseDamage(myHero))+0.5*GetBonusAP(myHero) )
					end
					if GetDistance(enemy) > 1200 and CanUseSpell(myHero,3) == READY then
						manaNeed = manaNeed + GetCastMana(myHero,3,GetCastLevel(myHero,3))
					end
					local dps = qdmg + wdmg + edmg + lDmg + lichDmg
					if dps >= GetCurrentHP(enemy) and GetCurrentMana(myHero) >= manaNeed and drawThem[GetNetworkID(enemy)] == true and GetDistance(enemy) < 7000 then
						DrawSprite(champSprite[GetObjectName(enemy)],myhppos.x-26 + 26*(i-1),myhppos.y+23,0,0,0,0,ARGB(255,255,255,255))
					end
				end
			end
		end
	end)
end)
