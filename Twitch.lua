require('Inspired')

PrintChat("ADC MAIN | Twitch loaded.")
PrintChat("by Noddy")

mainMenu = Menu("ADC MAIN | Twitch", "Twitch")
mainMenu:SubMenu("Combo", "Combo")
mainMenu.Combo:Boolean("useW", "Use W in combo", true)
mainMenu.Combo:Boolean("useE", "E at max stacks", true)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
------------------------------------------------------
mainMenu:SubMenu("Killsteal", "Killsteal")
mainMenu.Killsteal:Boolean("ksE", "Use E - KS", true)
mainMenu.Killsteal:Boolean("ksEp", "Poison + E - KS", true)
------------------------------------------------------
mainMenu:SubMenu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)
------------------------------------------------------
mainMenu:SubMenu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("drawPoison", "Draw Posion-Damage", true)
mainMenu.Drawings:Boolean("drawE", "Draw E-Damage", true)
mainMenu.Drawings:Boolean("drawR", "Draw R-Range", true)
mainMenu.Drawings:Slider("Quality","Circle Quality", 100 , 1, 255, 1)
------------------------------------------------------
mainMenu:SubMenu("Misc", "Misc")
mainMenu.Misc:Boolean("iR", "Invisible Recall", true)
mainMenu.Misc:Key("recall", "Recall Key", string.byte("T"))

PassiveStacks = {}
PassiveApply = {}

OnUpdateBuff(function(Object,buff)

if buff.Name == 'twitchdeadlyvenom' then
if PassiveStacks[GetNetworkID(Object)] == nil then
	PassiveStacks[GetNetworkID(Object)] = 0
end
	if PassiveStacks[GetNetworkID(Object)] and PassiveStacks[GetNetworkID(Object)] < 6 then
		PassiveStacks[GetNetworkID(Object)] = PassiveStacks[GetNetworkID(Object)] + 1
	end
	PassiveApply[GetNetworkID(Object)] = buff.StartTime

	-----------------------
if GetLevel(myHero) >= 1 and GetLevel(myHero) <= 4 then
	pDMG = 12	
elseif 	GetLevel(myHero) >= 5 and GetLevel(myHero) <= 8 then
	pDMG = 18
elseif 	GetLevel(myHero) >= 9 and GetLevel(myHero) <= 12 then
	pDMG = 24
elseif 	GetLevel(myHero) >= 13 and GetLevel(myHero) <= 16 then
	pDMG = 30
elseif 	GetLevel(myHero) >= 17 and GetLevel(myHero) <= 18 then
	pDMG = 36
end	
	-----------------------
end
end)

OnRemoveBuff(function(Object,buff)

if buff.Name == 'twitchdeadlyvenom' then
	PassiveStacks[GetNetworkID(Object)] = 0
	PassiveApply[GetNetworkID(Object)] = 0
end

end)

OnTick(function(myHero)

local target = GetCurrentTarget()
local myHeroPos = GetOrigin(myHero)

-- Items
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)

-- Use Items
if mainMenu.Combo.Combo1:Value() then
	if CutBlade >= 1 and GoS:ValidTarget(target,550+50) and mainMenu.Items.useCut:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3144)) == READY then
			CastTargetSpell(target, GetItemSlot(myHero,3144))
		end	
	elseif bork >= 1 and GoS:ValidTarget(target,550+50) and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 and mainMenu.Items.useBork:Value() then 
		if CanUseSpell(myHero,GetItemSlot(myHero,3153)) == READY then
			CastTargetSpell(target,GetItemSlot(myHero,3153))
		end
	end

	if ghost >= 1 and GoS:ValidTarget(target,GetRange(myHero)+50) and mainMenu.Items.useGhost:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY then
			CastSpell(GetItemSlot(myHero,3142))
		end
	end
	
	if redpot >= 1 and GoS:ValidTarget(target,GetRange(myHero)+50) and mainMenu.Items.useRedPot:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,2140)) == READY then
			CastSpell(GetItemSlot(myHero,2140))
		end
	end
end

-- Combo
if mainMenu.Combo.Combo1:Value() and GoS:ValidTarget(target, 1500) then

	if mainMenu.Combo.useW:Value() and GoS:ValidTarget(target, 1500) and CanUseSpell(myHero,_W) == READY then
		local WPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),1400,250,940,220,false,true)
		if WPred.HitChance == 1 then
			CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
		end
	end
	
	if mainMenu.Combo.useE:Value() and GoS:ValidTarget(target,1200) and CanUseSpell(myHero,_E) == READY and PassiveStacks[GetNetworkID(target)] == 6 then
		CastSpell(_E)
	end

end	

	
if GoS:ValidTarget(GetCurrentTarget(), 2000) then
for i,enemy in pairs(GoS:GetEnemyHeroes()) do
if PassiveStacks[GetNetworkID(enemy)] ~= nil then
PrintChat("Enemy: "..GetObjectName(enemy).."  Stacks: "..PassiveStacks[GetNetworkID(enemy)])
	if CanUseSpell(myHero,_E) == READY then
	eDMG = GoS:CalcDamage(myHero,enemy,(15*GetCastLevel(myHero,_E)+5+(5*GetCastLevel(myHero,_E)+10+(0.2*GetBonusAP(myHero)+0.25*GetBonusDmg(myHero)))*PassiveStacks[GetNetworkID(enemy)]),0)
	else eDMG = 0 end
end
-- Posion-Damage
if PassiveApply[GetNetworkID(enemy)] ~= nil and pDMG ~= nil and PassiveStacks[GetNetworkID(enemy)] > 0 and PassiveApply[GetNetworkID(enemy)] > 0 then
	local p = GetGameTimer() - PassiveApply[GetNetworkID(enemy)]
	local pp = 6 - p
	truepoisonDMG = (((pDMG/6) * PassiveStacks[GetNetworkID(enemy)]) * pp -(GetHPRegen(enemy)* pp ))
end
end
end

-- DRAWINGS
if mainMenu.Drawings.drawPoison:Value() or mainMenu.Drawings.drawE:Value() and GoS:ValidTarget(target,2000) and eDMG ~= nil then
for i,enemy in pairs(GoS:GetEnemyHeroes()) do
	if CanUseSpell(myHero,_E) == READY and mainMenu.Drawings.drawE:Value() and mainMenu.Drawings.drawPoison:Value() then
	DrawDmgOverHpBar(target,GetCurrentHP(target),eDMG,0,0xff00ff00)
	DrawDmgOverHpBar(target,GetCurrentHP(target)-eDMG,truepoisonDMG,0,0xffff00ff)
	elseif CanUseSpell(myHero,_E) == ONCOOLDOWN and mainMenu.Drawings.drawE:Value() and mainMenu.Drawings.drawPoison:Value() then
	DrawDmgOverHpBar(target,GetCurrentHP(target),truepoisonDMG,0,0xffff00ff)
	end
	
	if mainMenu.Drawings.drawE:Value() and not mainMenu.Drawings.drawPoison:Value() then
	DrawDmgOverHpBar(target,GetCurrentHP(target),eDMG,0,0xff00ff00)
	end
	
	if mainMenu.Drawings.drawPoison:Value() and not mainMenu.Drawings.drawE:Value() then
	DrawDmgOverHpBar(target,GetCurrentHP(target),truepoisonDMG,0,0xffff00ff)
	end
end	
end

-- Draw R
if mainMenu.Drawings.drawR:Value() and CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(target,2000) then
	DrawCircle(GetOrigin(myHero),850,0,mainMenu.Drawings.Quality:Value(),ARGB(100,33,139,6))
end


-- Killsteal E
if mainMenu.Killsteal.ksE:Value() and eDMG ~= nil then
for i,enemy in pairs(GoS:GetEnemyHeroes()) do
		if CanUseSpell(myHero,_E) == READY and GoS:ValidTarget(enemy, 1200) and GetCurrentHP(enemy) + GetDmgShield(enemy) < eDMG and mainMenu.Killsteal.ksE:Value() then
			CastSpell(_E)
		end
		
		if CanUseSpell(myHero,_E) == READY and GoS:ValidTarget(enemy, 1200) and GetCurrentHP(enemy) + GetDmgShield(enemy) < eDMG + truepoisonDMG and mainMenu.Killsteal.ksE:Value() and mainMenu.Killsteal.ksEp:Value() then
			CastSpell(_E)
		end
end	
end

-- Recall
if mainMenu.Misc.iR:Value() then
	if CanUseSpell(myHero,_Q) == READY then
		if mainMenu.Misc.recall:Value() then
			CastSpell(_Q)
				GoS:DelayAction(function()
				CastSpell(RECALL)
				end, 10)
		end
	end
end

end)
