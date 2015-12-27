-- Noddy | ADC MAIN

require("Inspired")

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
local windUP = 300
local baseAS = GetBaseAttackSpeed(myHero)

OnProcessSpellComplete(function(unit,spell)
	if unit == myHero and spell.name:lower():find("attack") then
		ASDelay = 1/(baseAS*GetAttackSpeed(myHero))
		windUP = spell.windUpTime*1000
		aaTimeReady = ASDelay + GetGameTimer()
	end
end)

OnTick(function(myHero)
if aaTimeReady ~= nil then
aaTimer = aaTimeReady - GetGameTimer()
if aaTimer < 0 then
	aaTimer = 0
end
end
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "Ezreal"
function Ezreal:__init()
	PrintChat("ADC MAIN | Ezreal loaded.")
	self:Menu()
	OnTick(function(myHero) self:Tick() end)
 	OnDraw(function(myHero) self:Draw() end)
end

function Ezreal:Load()
	self:Menu()
	LoadIOW()
end

function Ezreal:Menu()
	mainMenu = Menu("ADC MAIN | Ezreal", "Ezreal")
	mainMenu:Menu("Combo", "Combo")
	mainMenu.Combo:Boolean("useQ", "Use Q", true)
	mainMenu.Combo:Boolean("useW", "Use W", true)
	mainMenu.Combo:Boolean("wAlly", "Use W on Ally", true)
	mainMenu.Combo:Boolean("useR", "Use R", true)
	mainMenu.Combo:Slider("rRange","Custom Ult range: ", 2500, 500, 5000, 10)
	mainMenu.Combo:Boolean("rS", "Use R if can hit: X", true)
	mainMenu.Combo:Slider("rSS","Enemy count: ", 3, 2, 5, 1)
	mainMenu.Combo:Slider("dontRRange", "Ult save range: ", 400, 0, 1000)
	mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
	mainMenu:Menu("Harass", "Harass")
	mainMenu.Harass:Boolean("useQ", "Use Q", true)
	mainMenu.Harass:Slider("qMana","Mana-Manager: Q", 45, 0, 100, 1)
	mainMenu.Harass:Boolean("useW", "Use W", false)
	mainMenu.Harass:Slider("wMana","Mana-Manager: W", 80, 0, 100, 1)
	mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
	mainMenu:Menu("Killsteal", "Killsteal")
	mainMenu.Killsteal:Boolean("useQ", "Use Q", true)
	mainMenu.Killsteal:Boolean("useW", "Use W", true)
	mainMenu.Killsteal:Boolean("useR", "Use R (on key press)", true)
	mainMenu.Killsteal:Boolean("drawKS", "Draw: Killable notification", true)
	mainMenu.Killsteal:Key("ksKey", "KS Ult Key", string.byte("T"))
	mainMenu:Menu("Items", "Items")
	mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
	mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
	mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
	mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)
	mainMenu.Items:Boolean("useMuramana", "Muramana", true)
	mainMenu:Menu("Misc", "Misc")
	mainMenu.Misc:Boolean("buyB", "Buy: Farsight Alteration", true)
	mainMenu.Misc:Boolean("drawDMG", "Draw: R-Damage", true)
	mainMenu.Misc:Key("farmQX", "LastHit: Q", string.byte("X"))
	mainMenu.Misc:Key("farmQV", "WaveClear: Q", string.byte("V"))
	mainMenu.Misc:Boolean("tearStack", "Tear Stacking", true)
	mainMenu.Misc:Slider("qMana","Mana-Manager: Q", 30, 0, 100, 1)
	mainMenu:Boolean("useSheen", "Sheen Weaving", true)
end

function Ezreal:Tick()
	self:Combo()
	self:Harass()
	self:Killsteal()
	self:qLastHit()
	self:buyB(basePos)
	self:Tear()
end

function Ezreal:Draw()
	self:drawDMG()
end

function Ezreal:Combo()
	if mainMenu.Combo.Combo1:Value() then
		local target = GetCurrentTarget()
		self:useItems(target)
		self:useR(target)
		self:aoeR(target)
		if mainMenu.Combo.useW:Value() and GetCurrentMana(myHero) - GetCastMana(myHero,1,GetCastLevel(myHero,1)) >= 100 then
			self:dmgW(target)
			if mainMenu.Combo.wAlly:Value() then
				self:wAlly(target)
			end
		end
		if mainMenu.useSheen:Value() then
			if self:GotSheen() == true then
				if self:Sheen() == true and self:qPred(target) == 1 and mainMenu.Combo.useQ:Value() then
					self:useQ(target)
				elseif self:Sheen() == true and (self:SheenBuff() == false or self:SheenBuff() == nil) and IsInDistance(target,550 + GetHitBox(target)/2) and mainMenu.Combo.useW:Value() and GetCurrentMana(myHero) - GetCastMana(myHero,1,GetCastLevel(myHero,1)) >= 100 then
					self:useW(target)
				elseif not IsInDistance(target,550 + GetHitBox(target)/2) and mainMenu.Combo.useW:Value() and GetCurrentMana(myHero) - GetCastMana(myHero,1,GetCastLevel(myHero,1)) >= 100 then
					self:useW(target)
				end
			else
				if mainMenu.Combo.useQ:Value() then
					self:useQ(target)
				end
				if mainMenu.Combo.useW:Value() and GetCurrentMana(myHero) - GetCastMana(myHero,1,GetCastLevel(myHero,1)) >= 100 then
					self:useW(target)
				end
			end
		elseif not mainMenu.useSheen:Value() then
			if mainMenu.Combo.useQ:Value() then
				self:useQ(target)
			end
			if mainMenu.Combo.useW:Value() and GetCurrentMana(myHero) - GetCastMana(myHero,1,GetCastLevel(myHero,1)) >= 100 then
				self:useW(target)
			end
		end
	end
	if GotBuff(myHero,"Muramana") == 1 and not ValidTarget(GetCurrentTarget(), 1800) and mainMenu.Items.useMuramana:Value() then
		CastSpell(GetItemSlot(myHero,3042))
	end
end

function Ezreal:Harass()
	if mainMenu.Harass.Harass1:Value() then
		local target = GetCurrentTarget()
		if mainMenu.Harass.useQ:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.qMana:Value() then
			self:useQ(target)
		end
		if mainMenu.Harass.useW:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.wMana:Value() then
			self:useW(target)
		end
	end
end

function Ezreal:Killsteal()
for i,enemy in pairs(GetEnemyHeroes()) do
	if mainMenu.Killsteal.useQ:Value() and ValidTarget(enemy, 1250) then
		if CanUseSpell(myHero,0) == READY and GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero,enemy,20*GetCastLevel(myHero,0)+15+(GetBaseDamage(myHero)+GetBonusDmg(myHero))*1.1+GetBonusAP(myHero)*0.4, 0) then
			local qPred = GetPredictionForPlayer(GetOrigin(myHero),enemy,GetMoveSpeed(enemy),2000,250,1250,70,true,false)
			if qPred.HitChance == 1 then
				CastSkillShot(0,qPred.PredPos)
			end
		end
	end
	if mainMenu.Killsteal.useW:Value() and ValidTarget(enemy, 1000) then
		if CanUseSpell(myHero,1) == READY and GetCurrentHP(enemy) + GetDmgShield(enemy) + GetMagicShield(enemy) < CalcDamage(myHero,enemy,0,45*GetCastLevel(myHero,1)+25+GetBonusAP(myHero)*0.8) then
			local wPred = GetPredictionForPlayer(GetOrigin(myHero),enemy,GetMoveSpeed(enemy),1600,250,1000,80,false,false)
			if wPred.HitChance == 1 then
				CastSkillShot(1,wPred.PredPos)
			end
		end
	end
	if mainMenu.Killsteal.useR:Value() and ValidTarget(enemy, mainMenu.Combo.rRange:Value()) then
		if CanUseSpell(myHero,3) == READY and mainMenu.Killsteal.ksKey:Value() then
			local rPred = GetPredictionForPlayer(GetOrigin(myHero),enemy,GetMoveSpeed(enemy),2000,1000,5000,160,false,false)
			local reduction = (1-(0.1*CountObjectsOnLineSegment(GetOrigin(myHero), rPred.PredPos, 200, minionManager.objects, enemyTeam)))
				if reduction < 0.7 then
					reduction = 0.7
				end
			local rDMG = CalcDamage(myHero, enemy, 0, 150*GetCastLevel(myHero,3)+200+GetBonusDmg(myHero)+GetBonusAP(myHero)*0.9)*reduction
			if GetCurrentHP(enemy) + GetDmgShield(enemy) + GetMagicShield(enemy) < rDMG then
				CastSkillShot(3,rPred.PredPos)
			end
		end
	end
end
end

function Ezreal:useItems(target)
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)
local Muramana = GetItemSlot(myHero,3042)
	if CutBlade >= 1 and ValidTarget(target,550) and mainMenu.Items.useCut:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3144)) == READY then
			CastTargetSpell(target, GetItemSlot(myHero,3144))
		end	
	elseif bork >= 1 and ValidTarget(target,550) and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 and mainMenu.Items.useBork:Value() then 
		if CanUseSpell(myHero,GetItemSlot(myHero,3153)) == READY then
			CastTargetSpell(target,GetItemSlot(myHero,3153))
		end
	end
	if ghost >= 1 and ValidTarget(target,550) and mainMenu.Items.useGhost:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY then
			CastSpell(GetItemSlot(myHero,3142))
		end
	end
	if redpot >= 1 and ValidTarget(target,550) and mainMenu.Items.useRedPot:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,2140)) == READY then
			CastSpell(GetItemSlot(myHero,2140))
		end
	end
	if ValidTarget(target,GetCastRange(myHero,_Q)) and Muramana >= 1 and GotBuff(myHero,"Muramana") == 0 and mainMenu.Items.useMuramana:Value() then
		CastSpell(GetItemSlot(myHero,3042))
	elseif GotBuff(myHero,"Muramana") == 1 and not ValidTarget(target, 1500) and mainMenu.Items.useMuramana:Value() then
		CastSpell(GetItemSlot(myHero,3042))
	end
end

function Ezreal:qPred(target)
	local qPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),2000,250,1200,80,true,false)
	return qPred.HitChance
end

function Ezreal:useQ(target)
	if CanUseSpell(myHero,0) == READY and ValidTarget(GetCurrentTarget(), 1500) then
		local qPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),2000,250,1200,80,true,false)
		if qPred.HitChance == 1 then
			CastSkillShot(0,qPred.PredPos)
		end
	end
end

function Ezreal:useW(target)
	if CanUseSpell(myHero,1) == READY and ValidTarget(target, 1500) then
		local wPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1600,250,1000,80,false,false)
		if wPred.HitChance == 1 then
			CastSkillShot(1,wPred.PredPos)
		end
	end
end

function Ezreal:dmgW(target)
	if CanUseSpell(myHero,1) == READY and ValidTarget(target, 1500) then
		if CalcDamage(myHero,target,(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0)*(1+GetCritChance(myHero)) < CalcDamage(myHero,target,0,45*GetCastLevel(myHero,1)+25+GetBonusAP(myHero)*0.8) then
			local wPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1600,250,1000,80,false,false)
			if wPred.HitChance == 1 then
				CastSkillShot(1,wPred.PredPos)
			end
		end	
	end
end

function Ezreal:wAlly(target)
	if CanUseSpell(myHero,1) == READY then
		for _, ally in pairs(GetAllyHeroes()) do
			if ValidTarget(ally,900) then
				if IsInDistance(ally, 900) and GetDistance(ally,target) < GetRange(ally) and CalcDamage(ally,target,(GetBaseDamage(ally)+GetBonusDmg(ally))*(GetBaseAttackSpeed(ally)*GetAttackSpeed(ally)),0) + (CalcDamage(ally,target,(GetBaseDamage(ally)+GetBonusDmg(ally)),0)*2)*GetCritChance(ally) > CalcDamage(myHero,target,0,45*GetCastLevel(myHero,1)+25+GetBonusAP(myHero)*0.8) then
					local wPred = GetPredictionForPlayer(GetOrigin(myHero),ally,GetMoveSpeed(ally),1600,250,1000,80,false,false)
					if wPred.HitChance == 1 then
						CastSkillShot(1,wPred.PredPos)
					end
				end
			end
		end
	end
end

function Ezreal:useR(target)
	if CanUseSpell(myHero,3) == READY and ValidTarget(target,mainMenu.Combo.rRange:Value()) and mainMenu.Combo.useR:Value() and not IsInDistance(target,mainMenu.Combo.dontRRange:Value()) then
		local rPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),2000,1000,5000,160,false,false)
		local reduction = (1-(0.1*CountObjectsOnLineSegment(GetOrigin(myHero), rPred.PredPos, 200, minionManager.objects, ENEMY)))
		if reduction < 0.7 then
			reduction = 0.7
		end
		local rDMG = CalcDamage(myHero, target, 0, 150*GetCastLevel(myHero,3)+200+GetBonusDmg(myHero)+GetBonusAP(myHero)*0.9)*reduction
		for i,enemy in pairs(GetEnemyHeroes()) do
			if IsInDistance(target,550) and CalcDamage(myHero,target,(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0) + (CalcDamage(myHero,target,(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0)*2)*GetCritChance(myHero) + CalcDamage(myHero,target,(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0) + CalcDamage(myHero,target,20*GetCastLevel(myHero,0)+15+(GetBaseDamage(myHero)+GetBonusDmg(myHero))*1.1+GetBonusAP(myHero)*0.4, 0)*2 < GetCurrentHP(target) + GetMagicShield(myHero) + GetDmgShield(target) + GetHPRegen(target)*3 then
				if rPred.HitChance == 1 and GetCurrentHP(target) + GetMagicShield(myHero) + GetDmgShield(target) + GetHPRegen(target)*3 < rDMG and not IsInDistance(enemy,mainMenu.Combo.dontRRange:Value()) then
					CastSkillShot(3,rPred.PredPos)
				end
			elseif not IsInDistance(target,550) and IsInDistance(target,1000) and CalcDamage(myHero,target,20*GetCastLevel(myHero,0)+15+(GetBaseDamage(myHero)+GetBonusDmg(myHero))*1.1+GetBonusAP(myHero)*0.4, 0)*2 < GetCurrentHP(target) + GetMagicShield(myHero) + GetDmgShield(target) + GetHPRegen(target)*3 then
				if rPred.HitChance == 1 and GetCurrentHP(target) + GetMagicShield(myHero) + GetDmgShield(target) + GetHPRegen(target)*3 < rDMG and not IsInDistance(enemy,mainMenu.Combo.dontRRange:Value()) then
					CastSkillShot(3,rPred.PredPos)
				end
			elseif not IsInDistance(target,1000) and IsInDistance(target,1200) and CalcDamage(myHero,target,20*GetCastLevel(myHero,0)+15+(GetBaseDamage(myHero)+GetBonusDmg(myHero))*1.1+GetBonusAP(myHero)*0.4, 0) < GetCurrentHP(target) + GetMagicShield(myHero) + GetDmgShield(target) + GetHPRegen(target)*3 then
				if rPred.HitChance == 1 and GetCurrentHP(target) + GetMagicShield(myHero) + GetDmgShield(target) + GetHPRegen(target)*3 < rDMG and not IsInDistance(enemy,mainMenu.Combo.dontRRange:Value()) then
					CastSkillShot(3,rPred.PredPos)
				end
			elseif not IsInDistance(target,1200) then
				if rPred.HitChance == 1 and GetCurrentHP(target) + GetMagicShield(myHero) + GetDmgShield(target) + GetHPRegen(target)*3 < rDMG and not IsInDistance(enemy,mainMenu.Combo.dontRRange:Value()) then
					CastSkillShot(3,rPred.PredPos)
				end
			end
		end
	end
end

function Ezreal:aoeR(target) 
	if CanUseSpell(myHero,3) == READY and ValidTarget(target,mainMenu.Combo.rRange:Value()) and mainMenu.Combo.rS:Value() and not IsInDistance(target,mainMenu.Combo.dontRRange:Value()) then
		for i,enemy in pairs(GetEnemyHeroes()) do
			local rPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),2000,1100,5000,160,false,false)
			local rPredTrue = GetOrigin(myHero) + (VectorWay(GetOrigin(myHero),rPred.PredPos)/GetDistance(myHero,rPred.PredPos))*mainMenu.Combo.rRange:Value()
			if rPred.HitChance == 1 and not IsInDistance(enemy,mainMenu.Combo.dontRRange:Value()) and CountObjectsOnLineSegment(GetOrigin(myHero), rPredTrue, 200, GetEnemyHeroes()) >= mainMenu.Combo.rSS:Value() then
				CastSkillShot(3,rPred.PredPos)
			end
		end
	end
end

function Ezreal:SheenBuff()
	OnUpdateBuff(function(unit,buff)
		if buff.Name == "sheen" or buff.Name == "itemfrozenfist" then
			if unit == myHero then
				ON = true
			end
		end
	end)
	OnRemoveBuff(function(unit,buff)
		if buff.Name == "sheen" or buff.Name == "itemfrozenfist" then
			if unit == myHero then
				ON = false
			end
		end
	end)
	OnProcessSpell(function(unit,spell)
		if unit == myHero then
			if spell.name == "EzrealMysticShot" or spell.name == "EzrealEssenceFlux" or spell.name == "EzrealArcaneShift" or spell.name == "EzrealTrueshotBarrage" then
				ON = true
			end
		end
	end)
return ON
end

function Ezreal:Sheen()
local Sheen = GetItemSlot(myHero,3057)
local TonsOfDamage = GetItemSlot(myHero,3078)
local Iceborn = GetItemSlot(myHero,3025)
	local ON = false
	if (CanUseSpell(myHero,Sheen) == READY or CanUseSpell(myHero,TonsOfDamage) == READY or CanUseSpell(myHero,Iceborn) == READY) then
		ON = true
	end
	return ON
end

function Ezreal:GotSheen()
local Sheen = GetItemSlot(myHero,3057)
local TonsOfDamage = GetItemSlot(myHero,3078)
local Iceborn = GetItemSlot(myHero,3025)
	local ON = false
	if (Sheen >= 1 or TonsOfDamage >= 1 or Iceborn >= 1) then
		ON = true
	end
	return ON
end

function Ezreal:buyB(basePos)
if mainMenu.Misc.buyB:Value() and GetLevel(myHero) > 8 and GetDistance(myHero,basePos) < 550 then
	if GetItemID(myHero,ITEM_7) ~= 3363 then
		DelayAction(function()
			BuyItem(3363)
		end, math.random(392,663))
	end
end
end

function Ezreal:qLastHit()
if (mainMenu.Misc.farmQX:Value() or mainMenu.Misc.farmQV:Value()) and CanUseSpell(myHero,0) == READY and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Misc.qMana:Value() then
	for i,minion in pairs(minionManager.objects) do
		if ValidTarget(minion, 1200) then
			if IsInDistance(minion,600) then
				if GetCurrentHP(minion) - GetDamagePrediction(minion,aaTimer*1000 - GetLatency() + windUP/1.5 + (GetDistance(myHero,minion)/2000)*1000) < 1 and GetCurrentHP(minion) - GetDamagePrediction(minion,250 + GetLatency() + (GetDistance(myHero,minion)/2000)*1000) > 1 and GetCurrentHP(minion) + 10 < CalcDamage(myHero,minion,20*GetCastLevel(myHero,0)+15+(GetBaseDamage(myHero)+GetBonusDmg(myHero))*1.1+GetBonusAP(myHero)*0.4, 0) then
					if CountObjectsOnLineSegment(GetOrigin(myHero), GetOrigin(minion), 100, minionManager.objects, enemyTeam) == 0 and CountObjectsOnLineSegment(GetOrigin(myHero), GetOrigin(minion), 120, GetEnemyHeroes()) == 0 then
						CastSkillShot(0,GetOrigin(minion))
					end
				end
			elseif not IsInDistance(minion,600) then
				if GetCurrentHP(minion) - GetDamagePrediction(minion,250 + GetLatency() + (GetDistance(myHero,minion)/2000)*1000) > 0 and GetCurrentHP(minion) - GetDamagePrediction(minion,250 + GetLatency() + (GetDistance(myHero,minion)/2000)*1000) < CalcDamage(myHero,minion,20*GetCastLevel(myHero,0)+15+(GetBaseDamage(myHero)+GetBonusDmg(myHero))*1.1+GetBonusAP(myHero)*0.4, 0) then
					if CountObjectsOnLineSegment(GetOrigin(myHero), GetOrigin(minion), 100, minionManager.objects, enemyTeam) == 0 and CountObjectsOnLineSegment(GetOrigin(myHero), GetOrigin(minion), 120, GetEnemyHeroes()) == 0 then
						CastSkillShot(0,GetOrigin(minion))
					end
				end
			end
			if CanUseSpell(myHero,3) == ONCOOLDOWN or (mainMenu.Misc.tearStack:Value() and (GetItemSlot(myHero,3004) > 0 or GetItemSlot(myHero,3070) > 0) and (CanUseSpell(myHero,GetItemSlot(myHero,3004)) == READY or CanUseSpell(myHero,GetItemSlot(myHero,3070)) == READY) ) then
				if GetCurrentHP(minion) - GetDamagePrediction(minion,250 + GetLatency() + (GetDistance(myHero,minion)/2000)*1000) > 0 and GetCurrentHP(minion) - GetDamagePrediction(minion,250 + GetLatency() + (GetDistance(myHero,minion)/2000)*1000) < CalcDamage(myHero,minion,20*GetCastLevel(myHero,0)+15+(GetBaseDamage(myHero)+GetBonusDmg(myHero))*1.1+GetBonusAP(myHero)*0.4, 0) then
					if CountObjectsOnLineSegment(GetOrigin(myHero), GetOrigin(minion), 100, minionManager.objects, enemyTeam) == 0 and CountObjectsOnLineSegment(GetOrigin(myHero), GetOrigin(minion), 120, GetEnemyHeroes()) == 0 then
						CastSkillShot(0,GetOrigin(minion))
					end
				end
			end
			
		end
	end
end
end

function Ezreal:drawDMG()
	if (mainMenu.Misc.drawDMG:Value() or mainMenu.Killsteal.drawKS:Value()) and CanUseSpell(myHero,3) == READY then
		for i,enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy,mainMenu.Combo.rRange:Value()) then
				local rPred = GetPredictionForPlayer(GetOrigin(myHero),enemy,GetMoveSpeed(enemy),2000,1000,5000,160,false,false)
				local reduction = (1-(0.1*CountObjectsOnLineSegment(GetOrigin(myHero), rPred.PredPos, 200, minionManager.objects, enemyTeam)))
				if reduction < 0.7 then
					reduction = 0.7
				end
				local rDMG = CalcDamage(myHero, enemy, 0, 150*GetCastLevel(myHero,3)+200+GetBonusDmg(myHero)+GetBonusAP(myHero)*0.9)*reduction
				if mainMenu.Misc.drawDMG:Value() then
					DrawDmgOverHpBar(enemy,GetCurrentHP(enemy),rDMG,0,0xff00ff00)
				end
				if mainMenu.Killsteal.drawKS:Value() then
					if GetCurrentHP(enemy) + GetDmgShield(enemy) + GetMagicShield(enemy) < rDMG then
						local origin = GetOrigin(myHero)
						local myscreenpos = WorldToScreen(1,origin.x,origin.y,origin.z)
						DrawText("Killable with R: "..GetObjectName(enemy),14,myscreenpos.x,myscreenpos.y+(-14+(14*i)),0xff00ff00)
					end
				end
			end
		end
	end
end

function Ezreal:Tear()
	if mainMenu.Misc.tearStack:Value() then
		if CanUseSpell(myHero,0) == READY and GotBuff(myHero,"recall") == 0 and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Misc.qMana:Value() then
		local Manamune = GetItemSlot(myHero,3004)
		local Tear = GetItemSlot(myHero,3070)
			if CountObjectsNearPos(GetOrigin(myHero), 0, 1000, minionManager.objects, 300) == 0 then
				if (Manamune > 0 or Tear > 0) and (CanUseSpell(myHero,Manamune) == READY or CanUseSpell(myHero,Tear) == READY) then
					if CountObjectsNearPos(GetOrigin(myHero), 0, 1500, minionManager.objects, enemyTeam) == 0 and CountObjectsNearPos(GetOrigin(myHero), 0, 2500, GetEnemyHeroes()) == 0  then
						CastSkillShot(0,GetMousePos())
					end
				end
			end
		end
	end
end







----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if _G[GetObjectName(myHero)] then
	_G[GetObjectName(myHero)]()
end

function VectorWay(A,B)
WayX = B.x - A.x
WayY = B.y - A.y
WayZ = B.z - A.z
return Vector(WayX, WayY, WayZ)
end
