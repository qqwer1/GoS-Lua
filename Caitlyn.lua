require('Inspired')

mainMenu = Menu("ADC MAIN | Caitlyn", "Caitlyn")
mainMenu:SubMenu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useW", "Use W on close enemy", true)
mainMenu.Combo:Boolean("useR", "Use R in combo", true)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
---------------------------------------------------------------------------------
mainMenu:SubMenu("AutoW", "AutoW")
mainMenu.AutoW:Boolean("useWgap", "Use W on gapcloser", true)
mainMenu.AutoW:Boolean("useWc", "Use W on chanelling spells", true)
mainMenu.AutoW:Boolean("useWs", "Use W on immobile", true)
---------------------------------------------------------------------------------
mainMenu:SubMenu("Harass", "Harass")
mainMenu.Harass:Boolean("hQ", "Use Q", true)
mainMenu.Harass:Slider("Mana","Mana-Manager", 60, 1, 100, 1)
mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
---------------------------------------------------------------------------------
mainMenu:SubMenu("Killsteal", "Killsteal")
mainMenu.Killsteal:Boolean("ksQ", "Use Q - KS", true)
mainMenu.Killsteal:Boolean("ksE", "Use E - KS", true)
mainMenu.Killsteal:Boolean("ksR", "Use R - KS", true)
---------------------------------------------------------------------------------
mainMenu:SubMenu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)
---------------------------------------------------------------------------------
mainMenu:SubMenu("Misc", "Misc")
mainMenu.Misc:Boolean("drawR", "Draw R-Damage", true)
mainMenu.Misc:Boolean("gapE", "Auto E agains gapcloser", true)
mainMenu.Misc:Key("useEm", "Use E to mouse", string.byte("T"))

baseATKSpeed = GetBaseAttackSpeed(myHero)

CHANELLING_SPELLS = {
    ["CaitlynAceintheHole"]         = {Name = "Caitlyn",      Spellslot = _R},
    ["Drain"]                       = {Name = "FiddleSticks", Spellslot = _W},
    ["Crowstorm"]                   = {Name = "FiddleSticks", Spellslot = _R},
    ["GalioIdolOfDurand"]           = {Name = "Galio",        Spellslot = _R},
    ["FallenOne"]                   = {Name = "Karthus",      Spellslot = _R},
    ["KatarinaR"]                   = {Name = "Katarina",     Spellslot = _R},
    -- ["LucianR"]                     = {Name = "Lucian",       Spellslot = _R},
    ["AlZaharNetherGrasp"]          = {Name = "Malzahar",     Spellslot = _R},
    ["MissFortuneBulletTime"]       = {Name = "MissFortune",  Spellslot = _R},
    ["AbsoluteZero"]                = {Name = "Nunu",         Spellslot = _R},                        
    ["Pantheon_GrandSkyfall_Jump"]  = {Name = "Pantheon",     Spellslot = _R},
    ["ShenStandUnited"]             = {Name = "Shen",         Spellslot = _R},
    ["UrgotSwap2"]                  = {Name = "Urgot",        Spellslot = _R},
    -- ["VarusQ"]                      = {Name = "Varus",        Spellslot = _Q},
    ["InfiniteDuress"]              = {Name = "Warwick",      Spellslot = _R} 
}

GAPCLOSER_SPELLS = {
    ["AkaliShadowDance"]            = {Name = "Akali",      Spellslot = _R},
    ["Headbutt"]                    = {Name = "Alistar",    Spellslot = _W},
    ["DianaTeleport"]               = {Name = "Diana",      Spellslot = _R},
    ["FizzPiercingStrike"]          = {Name = "Fizz",       Spellslot = _Q},
    ["IreliaGatotsu"]               = {Name = "Irelia",     Spellslot = _Q},
    ["JaxLeapStrike"]               = {Name = "Jax",        Spellslot = _Q},
    ["JayceToTheSkies"]             = {Name = "Jayce",      Spellslot = _Q},
    ["blindmonkqtwo"]               = {Name = "LeeSin",     Spellslot = _Q},
    ["MaokaiUnstableGrowth"]        = {Name = "Maokai",     Spellslot = _W},
    ["AlphaStrike"]                 = {Name = "MasterYi",   Spellslot = _Q},
    ["MonkeyKingNimbus"]            = {Name = "MonkeyKing", Spellslot = _E},
    ["Pantheon_LeapBash"]           = {Name = "Pantheon",   Spellslot = _W},
    ["PoppyHeroicCharge"]           = {Name = "Poppy",      Spellslot = _E},
    ["QuinnE"]                      = {Name = "Quinn",      Spellslot = _E},
    ["RengarLeap"]                  = {Name = "Rengar",     Spellslot = _R},
    ["XenZhaoSweep"]                = {Name = "XinZhao",    Spellslot = _E}
}

GAPCLOSER2_SPELLS = {
    ["AatroxQ"]                     = {Name = "Aatrox",     Range = 1000, ProjectileSpeed = 1200, Spellslot = _Q},
    ["GragasE"]                     = {Name = "Gragas",     Range = 600,  ProjectileSpeed = 2000, Spellslot = _E},
    ["GravesMove"]                  = {Name = "Graves",     Range = 425,  ProjectileSpeed = 2000, Spellslot = _E},
    ["HecarimUlt"]                  = {Name = "Hecarim",    Range = 1000, ProjectileSpeed = 1200, Spellslot = _R},
    ["JarvanIVDragonStrike"]        = {Name = "JarvanIV",   Range = 770,  ProjectileSpeed = 2000, Spellslot = _Q},
    ["JarvanIVCataclysm"]           = {Name = "JarvanIV",   Range = 650,  ProjectileSpeed = 2000, Spellslot = _R},
    ["KhazixE"]                     = {Name = "Khazix",     Range = 900,  ProjectileSpeed = 2000, Spellslot = _E},
    ["khazixelong"]                 = {Name = "Khazix",     Range = 900,  ProjectileSpeed = 2000, Spellslot = _E},
    ["LeblancSlide"]                = {Name = "Leblanc",    Range = 600,  ProjectileSpeed = 2000, Spellslot = _W},
    ["LeblancSlideM"]               = {Name = "Leblanc",    Range = 600,  ProjectileSpeed = 2000, Spellslot = _R},
    ["LeonaZenithBlade"]            = {Name = "Leona",      Range = 900,  ProjectileSpeed = 2000, Spellslot = _E},
    ["UFSlash"]                     = {Name = "Malphite",   Range = 1000, ProjectileSpeed = 1800, Spellslot = _R},
    ["RenektonSliceAndDice"]        = {Name = "Renekton",   Range = 450,  ProjectileSpeed = 2000, Spellslot = _E},
    ["SejuaniArcticAssault"]        = {Name = "Sejuani",    Range = 650,  ProjectileSpeed = 2000, Spellslot = _Q},
    ["ShenShadowDash"]              = {Name = "Shen",       Range = 575,  ProjectileSpeed = 2000, Spellslot = _E},
    ["RocketJump"]                  = {Name = "Tristana",   Range = 900,  ProjectileSpeed = 2000, Spellslot = _W},
    ["slashCast"]                   = {Name = "Tryndamere", Range = 650,  ProjectileSpeed = 1450, Spellslot = _E}
}

OnProcessSpell(function(unit, spell)

if mainMenu.AutoW.useWgap:Value() then
local Spell1 = GAPCLOSER_SPELLS[spell.name]
	if Spell1 and spell.target == myHero and Spell1.Name == GetObjectName(unit) and GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == Obj_AI_Hero and CanUseSpell(myHero,_W) == READY then
		GoS:DelayAction(function()
			CastSkillShot(_W,GetOrigin(myHero))
		end, 250)
	end
local Spell2 = GAPCLOSER2_SPELLS[spell.name]
	if Spell2 and Spell2.Name == GetObjectName(unit) and GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == Obj_AI_Hero and CanUseSpell(myHero,_W) == READY then
		if GoS:GetDistance(spell.endPos, myHero) < 250 then
			CastSkillShot(_W,spell.endPos)
		end
	end
end

if mainMenu.AutoW.useWc:Value() then
local CSpell = CHANELLING_SPELLS[spell.name]
	if CSpell and CSpell.Name == GetObjectName(unit) and GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == Obj_AI_Hero and CanUseSpell(myHero,_W) == READY then
		CastSkillShot(_W,GetOrigin(unit))
	end
end

-- Need to add endPos check after E
if mainMenu.Misc.gapE:Value() then
local Spell1g = GAPCLOSER_SPELLS[spell.name]
	if Spell1g and spell.target == myHero and Spell1g.Name == GetObjectName(unit) and GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == Obj_AI_Hero and CanUseSpell(myHero,_E) == READY then
		CastSkillShot(_E,GetOrigin(unit))
	end
local Spell2g = GAPCLOSER2_SPELLS[spell.name]
	if Spell2g and Spell2g.Name == GetObjectName(unit) and GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == Obj_AI_Hero and CanUseSpell(myHero,_E) == READY then
		if GoS:GetDistance(spell.endPos, myHero) < 300 then
			CastSkillShot(_E,GetOrigin(unit))
		end
	end
end

end)

OnUpdateBuff(function(unit, buff)
if mainMenu.AutoW.useWs:Value() then
	if GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == Obj_AI_Hero then
		if buff.Type == 11  and GoS:IsInDistance(unit, 800+GetHitBox(unit)+250) then
			snaredtarget = unit
			snared = true
		end
		if buff.Type == 5  and GoS:IsInDistance(unit, 800+GetHitBox(unit)+250) then
			stunedtarget = unit
			stuned = true
		end
		if buff.Type == 29  and GoS:IsInDistance(unit, 800+GetHitBox(unit)) then
			uptarget = unit
			up = true
		end
		if buff.Type == 28  and GoS:IsInDistance(unit, 800+GetHitBox(unit)+250) then
			fleetarget = unit
			flee = true
		end
		if buff.Type == 8  and GoS:IsInDistance(unit, 800+GetHitBox(unit)+250) then
			taunttarget = unit
			taunt = true
		end
		if buff.Type == 22  and GoS:IsInDistance(unit, 800+GetHitBox(unit)+250) then
			charmtarget = unit
			charm = true
		end
	end
end
end)

OnRemoveBuff(function(unit, buff)
if mainMenu.AutoW.useWs:Value() then
	if GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == Obj_AI_Hero then
		if buff.Type == 11  and GoS:IsInDistance(unit, 800+GetHitBox(unit)+1000) then
			snared = false
		end
		if buff.Type == 5  and GoS:IsInDistance(unit, 800+GetHitBox(unit)+1000) then
			stuned = false
		end
		if buff.Type == 29  and GoS:IsInDistance(unit, 800+GetHitBox(unit)+1000) then
			up = false
		end
		if buff.Type == 28  and GoS:IsInDistance(unit, 800+GetHitBox(unit)+1000) then
			flee = false
		end
		if buff.Type == 8  and GoS:IsInDistance(unit, 800+GetHitBox(unit)+1000) then
			taunt = false
		end
		if buff.Type == 22  and GoS:IsInDistance(unit, 800+GetHitBox(unit)+1000) then
			charm = false
		end
	end
end
end)

OnTick(function(myHero)

local target = GetCurrentTarget()
local myHeroPos = GetOrigin(myHero)

local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)

if mainMenu.AutoW.useWs:Value() then
	if snared ~= nil and snared == true and GoS:IsInDistance(snaredtarget, 800) then
		CastSkillShot(_W, GetOrigin(snaredtarget))
	end
	if stuned ~= nil and stuned == true and GoS:IsInDistance(stunedtarget, 800) then
		CastSkillShot(_W, GetOrigin(stunedtarget))
	end
	if up ~= nil and up == true and GoS:IsInDistance(uptarget, 800) then
		CastSkillShot(_W, GetOrigin(uptarget))
	end
	if flee ~= nil and flee == true and GoS:IsInDistance(fleetarget, 800) then
		GoS:DelayAction(function()
		local fleeWPred = GetPredictionForPlayer(myHeroPos,fleetarget,GetMoveSpeed(fleetarget),math.huge, 1500, 800, 70, false, true)
			if fleeWPred.HitChance == 1 then
				CastSkillShot(_W, fleeWPred.PredPos.x, fleeWPred.PredPos.y, fleeWPred.PredPos.z)
			end
		end,100)
	end
	if taunt ~= nil and taunt == true and GoS:IsInDistance(taunttarget, 800) then
		GoS:DelayAction(function()
		local tauntWPred = GetPredictionForPlayer(myHeroPos,taunttarget,GetMoveSpeed(taunttarget),math.huge, 1500, 800, 70, false, true)
			if tauntWPred.HitChance == 1 then
				CastSkillShot(_W, tauntWPred.PredPos.x, tauntWPred.PredPos.y, tauntWPred.PredPos.z)
			end
		end,100)
	end
	if charm ~= nil and charm == true and GoS:IsInDistance(charmtarget, 800) then
		GoS:DelayAction(function()
		local charmWPred = GetPredictionForPlayer(myHeroPos,charmtarget,GetMoveSpeed(charmtarget),math.huge, 1500, 800, 70, false, true)
			if charmWPred.HitChance == 1 then
				CastSkillShot(_W, charmWPred.PredPos.x, charmWPred.PredPos.y, charmWPred.PredPos.z)
			end
		end,100)
	end
end

if mainMenu.Misc.useEm:Value() then
	local ePos = VectorWay(myHeroPos,GetMousePos())
	local ePosEnd = myHeroPos - ePos
	-- DrawCircle(ePosEnd,50,3,155,ARGB(255,255,255,255))
		CastSkillShot(_E, ePosEnd)
end

-- Combo
if mainMenu.Combo.Combo1:Value() then

-- Items
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
--
if mainMenu.Combo.useW:Value() and GoS:ValidTarget(target, 500) and CanUseSpell(myHero,_W) == READY then
	local WPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),math.huge, 1500, 800, 70, false, true)
	if WPred.HitChance == 1 and GoS:GetDistance(myHeroPos, WPred.PredPos) < 250+GetHitBox(target) then
		CastSkillShot(_W, WPred.PredPos.x, WPred.PredPos.y, WPred.PredPos.z)
	end
end

if mainMenu.Combo.useQ:Value() and GoS:ValidTarget(target, 1300) and CanUseSpell(myHero,_Q) == READY then
	local AA = (GoS:CalcDamage(myHero,target,GetBaseDamage(myHero)+GetBonusDmg(myHero),0) * (baseATKSpeed*GetAttackSpeed(myHero)))
	local AACrit = (2*AA) * GetCritChance(myHero)
	local qDMG = GoS:CalcDamage(myHero,target,40*GetCastLevel(myHero,_Q)-20+1.3*(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0)
	local qDMG2 = GoS:CalcDamage(myHero,target,20*GetCastLevel(myHero,_Q)-10+0.65*(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0)
		if GoS:ValidTarget(target,650) then
			local QPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),2200, 625, 1300, 90, true, false)
			local QPred2 = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),2200, 625, 1300, 90, false, false)
				if QPred.HitChance == 1 and qDMG > AA+AACrit then
					CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
				end
				if QPred.HitChance == 0 and QPred2.HitChance == 1 and qDMG2 > AA+AACrit then 
					CastSkillShot(_Q, QPred2.PredPos.x, QPred2.PredPos.y, QPred2.PredPos.z)
				end
		elseif GoS:ValidTarget(target, 1300) and not GoS:IsInDistance(target, 650+GetHitBox(target)) then
			local QPred2 = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),2200, 625, 1300, 90, false, false)
				if QPred2.HitChance == 1 then
					CastSkillShot(_Q, QPred2.PredPos.x, QPred2.PredPos.y, QPred2.PredPos.z)
				end
		end
end

if mainMenu.Combo.useR:Value() and CanUseSpell(myHero,_R) == READY then
	for i,enemy in pairs(GoS:GetEnemyHeroes()) do
		if GoS:ValidTarget(enemy, 500*GetCastLevel(myHero,_R)+1500) and GoS:EnemiesAround(myHeroPos, 1100) == 0 and not GoS:IsInDistance(enemy, 1100) and GetCurrentHP(enemy) + GetDmgShield(enemy) + GetHPRegen(enemy)*2 < GoS:CalcDamage(myHero, enemy, 225*GetCastLevel(myHero,_R)+25+2*GetBonusDmg(myHero),0) then
			CastTargetSpell(enemy,_R)
		end
	end
end

end -- Combo

-- Harass
if mainMenu.Harass.Harass1:Value() and CanUseSpell(myHero,_Q) == READY and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.Mana:Value() and GoS:ValidTarget(target, 1300) then
	local QPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),2200, 625, 1300, 90, true, false)
	if QPred.HitChance == 1 then
		CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
	end
end








end)

function VectorWay(A,B)
WayX = B.x - A.x
WayY = B.y - A.y
WayZ = B.z - A.z
return Vector(WayX, WayY, WayZ)
end
