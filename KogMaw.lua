--KogMaw
if GetObjectName(GetMyHero()) ~= "KogMaw" then return end
if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua!") return end
require("OpenPredict")

local orb = nil
DelayAction(function()
function findOrb()
	if DAC ~= nil and DAC:Mode() ~= nil then
		PrintChat("Found Orbwalker: DAC")
		orb = DAC
	elseif IOW ~= nil and IOW:Mode() ~= nil then
		PrintChat("Found Orbwalker: IOW")
		orb = IOW
	elseif PW ~= nil and PW:Mode() ~= nil then
		PrintChat("Found Orbwalker: PlatyWalk")
		orb = PW
	else
		PrintChat("Found Orbwalker: F7")
	end
end
findOrb()
end,.2)

local mainMenu = Menu("ADC MAIN | Kog'Maw", "KogMaw")
mainMenu:Menu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useW", "Use W in combo", true)
mainMenu.Combo:Boolean("useE", "Use E in combo", true)
mainMenu.Combo:Boolean("useR", "Use R in combo", true)
DelayAction(function()
if orb ~= nil then
mainMenu.Combo:Slider("aaSpeed","Dont Orbwalk at [X] Attack Speed", 3, 2.5, 5, .1)
mainMenu.Combo:Slider("aaKite","Kite back with [X] Attack Speed", 2.5, 2, 5, .1)
end
end,0.2)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
--------------------------------
-- mainMenu:Menu("Harass", "Harass")
-- mainMenu.Harass:Boolean("useQ", "Use Q", true)
-- mainMenu.Harass:Boolean("useW", "Use W", true)
-- mainMenu.Harass:Boolean("useE", "Use E", true)
-- mainMenu.Harass:Boolean("useR", "Use R", true)
-- mainMenu.Harass:Slider("RStacks","Max R stacks", 2, 1, 5, 1)
-- mainMenu.Harass:Slider("Mana","Mana-Manager", 60, 1, 100, 1)
-- mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
--------------------------
-- mainMenu:Menu("Killsteal", "Killsteal")
-- mainMenu.Killsteal:Boolean("ksQ", "Use Q", true)
-- mainMenu.Killsteal:Boolean("ksE", "Use E", false)
-- mainMenu.Killsteal:Boolean("ksR", "Use R", true)
--------------------------
mainMenu:Menu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useGun", "Hextech Gunblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)
--------------------------
-- mainMenu:Menu("Misc", "Misc")
-- mainMenu.Misc:Boolean("drawW", "Draw W Range", true)
-- mainMenu.Misc:Boolean("drawDMG", "Draw AA Damage", true)

function rRange()
	return 300*GetCastLevel(myHero,3)+900 
end

local kogAA = { delay = 0, speed = 1800, width = 20, range = 2000 }
local kogQ = { delay = .250, speed = 1650, width = 70, range = 1000 }
local kogQw = { delay = .125, speed = 1650, width = 70, range = 1000 }
local kogE = { delay = .250, speed = 1800, width = 120, range = 1350 }
local kogEw = { delay = .125, speed = 1800, width = 120, range = 1350 }
local kogR = { delay = .85+0.125, speed = math.huge, width = 100, range = rRange}
local kogRw = { delay = .715+0.125, speed = math.huge, width = 100, range = rRange}

local rMana = 50
local wBuff = false
local targetDMG = {}
local flyDMG = {
[1] = {dmg = 0, delay = 0},
[2] = {dmg = 0, delay = 0},
[3] = {dmg = 0, delay = 0},
}

local basePos = Vector(0,0,0)
local enemyTeam = nil
if GetTeam(myHero) == 100 then
	basePos = Vector(415,182,415)
	enemyTeam = 200
else
	basePos = Vector(14302,172,14387.8)
	enemyTeam = 100
end

local aaTimer = 0
local aaTimeReady = 0
local windUP = 300
local baseAS = GetBaseAttackSpeed(myHero)
local global_ticks = 0
local ASDelay = 1/(baseAS*GetAttackSpeed(myHero))
local afterATK = false

OnProcessSpellComplete(function(unit,spell)
	if unit == myHero and spell.name:lower():find("attack") then
		local target = spell.target
		if GetObjectType(target) == Obj_AI_Hero and ValidTarget(target,GetRange(myHero)+GetHitBox(target)-50) and GetDistance(myHero,target)+100 < GetDistance(GetMousePos(),target) and (baseAS*GetAttackSpeed(myHero)) >= mainMenu.Combo.aaSpeed:Value() then
			if orb ~= nil then
				if orb == DAC then
					DAC:AttacksEnabled(false)
				else
					orb.attacksEnabled = false
				end
				DelayAction(function()
					if orb == DAC then
						DAC:AttacksEnabled(true)
					else
						orb.attacksEnabled = true
					end
				end,1/mainMenu.Combo.aaKite:Value() -0.085 - spell.windUpTime)
			end
		end
	end
end)

OnProcessSpellComplete(function(unit,spell)
	if unit == myHero and spell.name:lower():find("attack") then
		ASDelay = 1/(baseAS*GetAttackSpeed(myHero))
		windUP = spell.windUpTime*1000
		aaTimeReady = ASDelay + GetGameTimer() - windUP/1000
	end
end)

OnTick(function(myHero)
if aaTimeReady ~= nil then
aaTimer = aaTimeReady - GetGameTimer()
if aaTimer <= 0 then
	aaTimer = 0
end
end
end)

OnProcessSpellComplete(function(unit,spell)
	if unit == myHero and spell.name:lower():find("attack") then
		local target = spell.target
		if GetObjectType(target) == Obj_AI_Hero then
			targetDMG[GetNetworkID(target)] = flyDMG
			local dmg = CalcDamage(myHero,target,GetBaseDamage(myHero)+GetBonusDmg(myHero),0)
			if spell.name:lower():find("crit") then
				dmg = dmg*2
			end
			dmg = math.round(dmg)
			local wDMG = 0
			if wBuff == true then
				wDMG = CalcDamage(myHero,target,0,GetMaxHP(target)*(0.02+(math.round(GetBonusAP(myHero)/100)*0.075)))
				if wDMG < 15 then
					wDMG = CalcDamage(myHero,target,0,15)
				end
				wDMG = math.round(wDMG)
				dmg = dmg*0.55
			end
			local rageblade = 0
			if GotBuff(myHero,"rageblade") == 8 then
				rageblade = math.round(CalcDamage(myHero,target,0,20+GetBonusDmg(myHero)*0.15 + GetBonusAP(myHero)*0.075))
			end
			local bork = 0
			if GetItemSlot(myHero,3153) > 0 then
				bork = math.round(CalcDamage(myHero,target,(GetCurrentHP(target)-targetDMG[GetNetworkID(target)][1].dmg)*0.06,0))
			end
			dmg = dmg + wDMG + rageblade + bork
			local aaPred = GetPrediction(target,kogAA)
			local delay = GetDistance(myHero,aaPred.castPos)/1800
			local write = false
			for i = 1, 3, 1 do
				if targetDMG[GetNetworkID(target)][i].dmg == 0 and write == false then
					targetDMG[GetNetworkID(target)][i].dmg = dmg
					targetDMG[GetNetworkID(target)][i].delay = GetGameTimer() + delay
					write = true
					DelayAction(function()
						targetDMG[GetNetworkID(target)][i].dmg = 0
						targetDMG[GetNetworkID(target)][i].delay = 0
					end,delay)
				end
			end
		end
	end
end)

OnUpdateBuff(function(unit,buff)
	if unit == myHero and buff.Name == "KogMawBioArcaneBarrage" then
		wBuff = true
		DelayAction(function()
			wBuff = false
		end,6)
	end
	if unit == myHero and buff.Name == "kogmawlivingartillerycost" then
		rMana = 50 + 50*buff.Count
	end
end)

OnRemoveBuff(function(unit,buff)
	if unit == myHero and buff.Name == "kogmawlivingartillerycost" then
		rMana = 50
	end
end)

function incomingDMG(target,delay)
	local dmg = 0
	for i = 1, 3, 1 do
		if targetDMG[GetNetworkID(target)] ~= nil then
			if targetDMG[GetNetworkID(target)][i].delay - GetGameTimer() < delay then
				dmg = dmg + targetDMG[GetNetworkID(target)][i].dmg
			end
		end
	end
	return dmg
end

local mode = "Standart Orbwalk"

OnDraw(function(myHero)
	-- local Ticker = GetTickCount()
	-- if (global_ticks + 100) < Ticker then
		
	-- global_ticks = Ticker
	-- end
	local origin = GetOrigin(myHero)
	local myscreenpos = WorldToScreen(1,origin.x-125,origin.y,origin.z)
	DrawText(mode,10,myscreenpos.x+13,myscreenpos.y,0xff00ff00)
end)

DelayAction(function()
OnTick(function(myHero)
	Combo()
	if orb ~= nil then
	if orb:Mode() == "Harass" then
		local target = GetCurrentTarget()
		-- orb.forceTarget = target
		if ValidTarget(target,GetRange(myHero)+GetHitBox(target) - 50) and (baseAS*GetAttackSpeed(myHero)) >= mainMenu.Combo.aaSpeed:Value() then
			if orb == DAC then
				DAC:MovementEnabled(false)
			else
				orb.movementEnabled = false
			end
		else
			if orb == DAC then
				DAC:MovementEnabled(true)
			else
				orb.movementEnabled = true
			end
		end
	end
	if orb:Mode() == "LaneClear" then
		if CountObjectsNearPos(GetOrigin(myHero), 0, GetRange(myHero), minionManager.objects, enemyTeam) >= 1 and (baseAS*GetAttackSpeed(myHero)) >= mainMenu.Combo.aaSpeed:Value() then
			mode = "High Attack Speed Capped"
			if orb == DAC then
				DAC:MovementEnabled(false)
			else
				orb.movementEnabled = false
			end
		else
			mode = "Standart Orbwalk"
			if orb == DAC then
				DAC:MovementEnabled(true)
			else
				orb.movementEnabled = true
			end
		end
	end
	end
end)
end,.2)

function Combo()
	if mainMenu.Combo.Combo1:Value() then
		local target = GetCurrentTarget()
		-- orb.forceTarget = target
		useItems(target)
		if orb ~= nil then
		if ValidTarget(target,GetRange(myHero)+GetHitBox(target)-50) and GetDistance(myHero,target)+125 < GetDistance(GetMousePos(),target) and (baseAS*GetAttackSpeed(myHero)) >= mainMenu.Combo.aaSpeed:Value() then
			mode = "Kiting"
			if orb == DAC then
				DAC:MovementEnabled(true)
			else
				orb.movementEnabled = true
			end
		elseif ValidTarget(target,GetRange(myHero)+GetHitBox(target)-50) and (baseAS*GetAttackSpeed(myHero)) >= mainMenu.Combo.aaSpeed:Value() then
			mode = "High Attack Speed Capped"
			if orb == DAC then
				DAC:MovementEnabled(false)
				DAC:AttackEnabled(true)
			else
				orb.movementEnabled = false
				orb.attackEnabled = true
			end
		else
			mode = "Standart Orbwalk"
			if orb == DAC then
				DAC:MovementEnabled(true)
				DAC:AttackEnabled(true)
			else
				orb.movementEnabled = true
				orb.attackEnabled = true
			end
		end
		end
		if mainMenu.Combo.useE:Value() then
			useE(target)
		end
		if mainMenu.Combo.useQ:Value() then
			useQ(target)
		end
		if mainMenu.Combo.useW:Value() then
			useW(target)
		end
		if mainMenu.Combo.useR:Value() then
			useR(target)
		end
	end
end

function useE(target)
	if ValidTarget(target,1400) and CanUseSpell(myHero,2) == READY and saveManaW(GetCastMana(myHero,2,GetCastLevel(myHero,2))) == true then
		local ePred = GetLinearAOEPrediction(target,kogE)
		if wBuff == true then
			ePred = GetLinearAOEPrediction(target,kogEw)
		end
		if ePred and ePred.hitChance >= 0.25 then
			CastSkillShot(2,ePred.castPos)
		end
	end
end

function useQ(target)
	if ValidTarget(target,1375) and CanUseSpell(myHero,0) == READY and saveManaW(GetCastMana(myHero,0,GetCastLevel(myHero,0))) == true and ((GetArmor(target) >= 100 or GetMagicResist(target) >= 100) or aaTimer > 0.25 )and GetCurrentHP(target) + GetDmgShield(target) + GetMagicShield(target) > incomingDMG(target,1) then
		local qPred = GetPrediction(target,kogQ)
		if wBuff == true then
			qPred = GetPrediction(target,kogQw)
		end
		if qPred and qPred.hitChance >= 0.4 and not qPred:mCollision(1) then
			CastSkillShot(0,qPred.castPos)
		end
	end
end

function useW(target)
	if ValidTarget(target,500 + GetHitBox(target)/2 + (30*GetCastLevel(myHero,1)+60)) and aaTimer < windUP/1000 and CanUseSpell(myHero,1) == READY and GetCurrentHP(target) + GetDmgShield(target) + GetMagicShield(target) > incomingDMG(target,1) then
		CastSpell(1)
	end
end

function useR(target)
	if ValidTarget(target,300*GetCastLevel(myHero,3)+1000) and CanUseSpell(myHero,3) == READY then
		for i,enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy,300*GetCastLevel(myHero,3)+1000) then
			kogR.range = (({[1]=1200,[2]=1500,[3]=1800})[GetCastLevel(myHero,3)])
			kogRw.range = (({[1]=1200,[2]=1500,[3]=1800})[GetCastLevel(myHero,3)])
			local rDMG = CalcDamage(myHero,enemy,0,(40*GetCastLevel(myHero,3)+30+GetBonusDmg(myHero)*0.65 + GetBonusAP(myHero)*0.25))
			local pHP = 100*(GetCurrentHP(enemy)-incomingDMG(target,0.715))/GetMaxHP(enemy)
			local enemyHP = GetCurrentHP(enemy) + GetDmgShield(enemy) + GetMagicShield(enemy) + GetHPRegen(enemy)*2
			local multi = 1
			if pHP <= 50 and pHP > 25 then
				rDMG = CalcDamage(myHero,enemy,0,(40*GetCastLevel(myHero,3)+30+GetBonusDmg(myHero)*0.65 + GetBonusAP(myHero)*0.25)*2)
				multi = 2
			elseif pHP <= 25 then
				rDMG = CalcDamage(myHero,enemy,0,(40*GetCastLevel(myHero,3)+30+GetBonusDmg(myHero)*0.65 + GetBonusAP(myHero)*0.25)*3)
				multi = 3
			end
			rDMG = math.round(rDMG)
			local castTime = 0.25
			if wBuff == true then
				castTime = 0.125
			end
			if enemyHP - incomingDMG(enemy,0.715) < rDMG then
				local rPred = GetCircularAOEPrediction(target,kogR)
				if wBuff == true then
					rPred = GetCircularAOEPrediction(target,kogRw)
				end
				if rPred and rPred.hitChance >= 0.2 then
					CastSkillShot(3,rPred.castPos)
				end
			end
			if GetDistance(myHero,target) < GetRange(myHero) and aaTimer > castTime+GetLatency()/1000 and multi >= 2 and (rDMG/GetMaxHP(target))*100 > 15 and rMana <= 100 and GetCurrentMana(myHero)-rMana >= rMana+50 then
				local rPred = GetCircularAOEPrediction(target,kogR)
				if wBuff == true then
					rPred = GetCircularAOEPrediction(target,kogRw)
				end
				if rPred and rPred.hitChance >= 0.2 then
					CastSkillShot(3,rPred.castPos)
				end
			elseif (rDMG/GetMaxHP(target))*100 > 13.37 and multi >= 2 and rMana <= 100 and GetCurrentMana(myHero)-rMana >= rMana+50 then
				local rPred = GetCircularAOEPrediction(enemy,kogR)
				if wBuff == true then
					rPred = GetCircularAOEPrediction(enemy,kogRw)
				end
				if rPred and rPred.hitChance >= 0.2 then
					CastSkillShot(3,rPred.castPos)
				end
			elseif multi == 3 and rMana <= 100 then
				local rPred = GetCircularAOEPrediction(enemy,kogR)
				if wBuff == true then
					rPred = GetCircularAOEPrediction(enemy,kogRw)
				end
				if rPred and rPred.hitChance >= 0.2 then
					CastSkillShot(3,rPred.castPos)
				end
			end
		end
		end
	end
end

function saveManaW(castMana)
	local ON = false
	if GetCurrentMana(myHero)-castMana >= 40 and CanUseSpell(myHero,1) == READY then
		ON = true
	end
	if CanUseSpell(myHero,1) ~= READY then
		ON = true
	end
	return ON
end

function useItems(target)
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)
local gun = GetItemSlot(myHero,3146)
	if CutBlade >= 1 and ValidTarget(target,550) and mainMenu.Items.useCut:Value() then
		if CanUseSpell(myHero,CutBlade) == READY then
			CastTargetSpell(target, CutBlade)
		end	
	elseif bork >= 1 and ValidTarget(target,550) and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 and mainMenu.Items.useBork:Value() then 
		if CanUseSpell(myHero,bork) == READY then
			CastTargetSpell(target,bork)
		end
	end
	if ghost >= 1 and ValidTarget(target,GetRange(myHero)) and mainMenu.Items.useGhost:Value() then
		if CanUseSpell(myHero,ghost) == READY then
			CastSpell(ghost)
		end
	end
	if redpot >= 1 and ValidTarget(target,700) and mainMenu.Items.useRedPot:Value() then
		if CanUseSpell(myHero,redpot) == READY then
			CastSpell(redpot)
		end
	end
	if gun >= 1 and ValidTarget(target,690) and mainMenu.Items.useGun:Value() then
		if CanUseSpell(myHero,gun) == READY then
			CastTargetSpell(target,gun)
		end
	end
end
