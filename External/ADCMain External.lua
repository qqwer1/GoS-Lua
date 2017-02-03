local supportedChamps = {
["Ashe"] = 0,["Caitlyn"] = 0,["Corki"] = 1,["Draven"] = 0,["Ezreal"] = 0,["Graves"] = 0,["Jinx"] = 0,["Kalista"] = 0,["Kennen"] = 0,["Kindred"] = 0,["KogMaw"] = 0,["Lucian"] = 0,["MissFortune"] = 0,["Quinn"] = 0,["Sivir"] = 1,["Tristana"] = 0,["Twitch"] = 0,["Urgot"] = 0,["Varus"] = 0,["Vayne"] = 1,["Jhin"] = 0,
}
if supportedChamps[myHero.charName] ~= 1 then return end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local version = 0.1

local icons = {	["Corki"] = "http://vignette2.wikia.nocookie.net/leagueoflegends/images/3/3d/CorkiSquare.png",
				-- ["Caitlyn"] = "http://vignette4.wikia.nocookie.net/leagueoflegends/images/e/e1/SivirSquare.png",
				["Sivir"] = "http://vignette4.wikia.nocookie.net/leagueoflegends/images/e/e1/SivirSquare.png",
				["Lucian"] = "http://vignette4.wikia.nocookie.net/leagueoflegends/images/1/1e/LucianSquare.png",
				["Varus"] = "http://vignette4.wikia.nocookie.net/leagueoflegends/images/1/1e/LucianSquare.png",
				["Vayne"] = "http://vignette2.wikia.nocookie.net/leagueoflegends/images/9/95/VayneSquare.png",
}

local 	ADCMenu = MenuElement({id = "ADCMainExt", name = "ADC in 2017 LUL | "..myHero.charName, type = MENU ,leftIcon = icons[myHero.charName] })
		ADCMenu:MenuElement({id = "Combo", name = "Combo", type = MENU})
		ADCMenu:MenuElement({id = "Harass", name = "Harras", type = MENU})
		ADCMenu:MenuElement({id = "Killsteal", name = "Killsteal", type = MENU})
		ADCMenu:MenuElement({id = "Items", name = "Items", type = MENU})
		ADCMenu:MenuElement({id = "Misc", name = "Misc", type = MENU})
		ADCMenu:MenuElement({id = "Key", name = "Key Settings", type = MENU})
		ADCMenu.Key:MenuElement({id = "Combo", name = "Combo", key = string.byte(" ")})
		ADCMenu.Key:MenuElement({id = "Harass", name = "Harass | Mixed", key = string.byte("C")})
		ADCMenu.Key:MenuElement({id = "Clear", name = "LaneClear | JungleClear", key = string.byte("V")})
		ADCMenu.Key:MenuElement({id = "LastHit", name = "LastHit", key = string.byte("X")})
		if myHero.charName ~= "Sivir" then
			ADCMenu:MenuElement({id = "fastOrb", name = "Make Orbwalker fast again", value = true})
		end
		
local DragonPos = Vector(9821,-71.25,4384.1)
local BaronPos = Vector(4971.5,-71.25,10415.6)

local _SPELLS

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function GetMode()
	if ADCMenu.Key.Combo:Value() then return "Combo" end
	if ADCMenu.Key.Harass:Value() then return "Harass" end
	if ADCMenu.Key.Clear:Value() then return "Clear" end
	if ADCMenu.Key.LastHit:Value() then return "LastHit" end
    return ""
end

local function GetDistance(p1,p2)
return  math.sqrt(math.pow((p2.x - p1.x),2) + math.pow((p2.y - p1.y),2) + math.pow((p2.z - p1.z),2))
end

local function GetPred(unit,speed,delay)
	return unit.pos + Vector(unit.pos,unit.posTo):Normalized() * (unit.ms * (delay + (GetDistance(myHero.pos,unit.pos)/speed)))
end

local _AllyHeroes
function GetAllyHeroes()
  if _AllyHeroes then return _AllyHeroes end
  _AllyHeroes = {}
  for i = 1, Game.HeroCount() do
    local unit = Game.Hero(i)
    if unit.isAlly then
      table.insert(_AllyHeroes, unit)
    end
  end
  return _AllyHeroes
end

local _EnemyHeroes
function GetEnemyHeroes()
  if _EnemyHeroes then return _EnemyHeroes end
  _EnemyHeroes = {}
  for i = 1, Game.HeroCount() do
    local unit = Game.Hero(i)
    if unit.isEnemy then
      table.insert(_EnemyHeroes, unit)
    end
  end
  return _EnemyHeroes
end

function GetPercentHP(unit)
  if type(unit) ~= "userdata" then error("{GetPercentHP}: bad argument #1 (userdata expected, got "..type(unit)..")") end
  return 100*unit.health/unit.maxHealth
end

function GetPercentMP(unit)
  if type(unit) ~= "userdata" then error("{GetPercentMP}: bad argument #1 (userdata expected, got "..type(unit)..")") end
  return 100*unit.mana/unit.maxMana
end

local function GetBuffs(unit)
  local t = {}
  for i = 0, unit.buffCount do
    local buff = unit:GetBuff(i)
    if buff.count > 0 then
      table.insert(t, buff)
    end
  end
  return t
end

function HasBuff(unit, buffname)
  if type(unit) ~= "userdata" then error("{HasBuff}: bad argument #1 (userdata expected, got "..type(unit)..")") end
  if type(buffname) ~= "string" then error("{HasBuff}: bad argument #2 (string expected, got "..type(buffname)..")") end
  for i, buff in pairs(GetBuffs(unit)) do
    if buff.name == buffname then 
      return true
    end
  end
  return false
end

function GetItemSlot(unit, id)
  for i = ITEM_1, ITEM_7 do
    if unit:GetItemData(i).itemID == id then
      return i
    end
  end
  return 0 -- 
end

function GetBuffData(unit, buffname)
  for i = 0, unit.buffCount do
    local buff = unit:GetBuff(i)
    if buff.name == buffname and buff.count > 0 then 
      return buff
    end
  end
  return {type = 0, name = "", startTime = 0, expireTime = 0, duration = 0, stacks = 0, count = 0}--
end

function IsImmune(unit)
  if type(unit) ~= "userdata" then error("{IsImmune}: bad argument #1 (userdata expected, got "..type(unit)..")") end
  for i, buff in pairs(GetBuffs(unit)) do
    if (buff.name == "KindredRNoDeathBuff" or buff.name == "UndyingRage") and GetPercentHP(unit) <= 10 then
      return true
    end
    if buff.name == "VladimirSanguinePool" or buff.name == "JudicatorIntervention" then 
      return true
    end
  end
  return false
end 

function IsImmobileTarget(unit)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and (buff.type == 5 or buff.type == 11 or buff.type == 29 or buff.type == 24 or buff.name == "recall") and buff.count > 0 then
			return true
		end
	end
	return false	
end

function IsValidTarget(unit, range, checkTeam, from)
  local range = range == nil and math.huge or range
  if type(range) ~= "number" then error("{IsValidTarget}: bad argument #2 (number expected, got "..type(range)..")") end
  if type(checkTeam) ~= "nil" and type(checkTeam) ~= "boolean" then error("{IsValidTarget}: bad argument #3 (boolean or nil expected, got "..type(checkTeam)..")") end
  if type(from) ~= "nil" and type(from) ~= "userdata" then error("{IsValidTarget}: bad argument #4 (vector or nil expected, got "..type(from)..")") end
  if unit == nil or not unit.valid or not unit.visible or unit.dead or not unit.isTargetable or IsImmune(unit) or (checkTeam and unit.isAlly) then 
    return false 
  end 
  return unit.pos:DistanceTo(from.pos and from.pos or myHero.pos) < range 
end

function CountAlliesInRange(point, range)
  if type(point) ~= "userdata" then error("{CountAlliesInRange}: bad argument #1 (vector expected, got "..type(point)..")") end
  local range = range == nil and math.huge or range 
  if type(range) ~= "number" then error("{CountAlliesInRange}: bad argument #2 (number expected, got "..type(range)..")") end
  local n = 0
  for i = 1, Game.HeroCount() do
    local unit = Game.Hero(i)
    if unit.isAlly and not unit.isMe and IsValidTarget(unit, range, false, point) then
      n = n + 1
    end
  end
  return n
end

local function CountEnemiesInRange(point, range)
  if type(point) ~= "userdata" then error("{CountEnemiesInRange}: bad argument #1 (vector expected, got "..type(point)..")") end
  local range = range == nil and math.huge or range 
  if type(range) ~= "number" then error("{CountEnemiesInRange}: bad argument #2 (number expected, got "..type(range)..")") end
  local n = 0
  for i = 1, Game.HeroCount() do
    local unit = Game.Hero(i)
    if IsValidTarget(unit, range, true, point) then
      n = n + 1
    end
  end
  return n
end

local function CanUseSpell(spell)
	return myHero:GetSpellData(spell).currentCd == 0 and myHero:GetSpellData(spell).level > 0 and myHero:GetSpellData(spell).mana <= myHero.mana
end

local DamageReductionTable = {
  ["Braum"] = {buff = "BraumShieldRaise", amount = function(target) return 1 - ({0.3, 0.325, 0.35, 0.375, 0.4})[target:GetSpellData(_E).level] end},
  ["Urgot"] = {buff = "urgotswapdef", amount = function(target) return 1 - ({0.3, 0.4, 0.5})[target:GetSpellData(_R).level] end},
  ["Alistar"] = {buff = "Ferocious Howl", amount = function(target) return ({0.5, 0.4, 0.3})[target:GetSpellData(_R).level] end},
  ["Amumu"] = {buff = "Tantrum", amount = function(target) return ({2, 4, 6, 8, 10})[target:GetSpellData(_E).level] end, damageType = 1},
  ["Galio"] = {buff = "GalioIdolOfDurand", amount = function(target) return 0.5 end},
  ["Garen"] = {buff = "GarenW", amount = function(target) return 0.7 end},
  ["Gragas"] = {buff = "GragasWSelf", amount = function(target) return ({0.1, 0.12, 0.14, 0.16, 0.18})[target:GetSpellData(_W).level] end},
  ["Annie"] = {buff = "MoltenShield", amount = function(target) return 1 - ({0.16,0.22,0.28,0.34,0.4})[target:GetSpellData(_E).level] end},
  ["Malzahar"] = {buff = "malzaharpassiveshield", amount = function(target) return 0.1 end}
}

function GotBuff(unit, buffname)
  for i = 0, unit.buffCount do
    local buff = unit:GetBuff(i)
    if buff.name == buffname and buff.count > 0 then 
      return buff.count
    end
  end
  return 0
end

function GetBuffData(unit, buffname)
  for i = 0, unit.buffCount do
    local buff = unit:GetBuff(i)
    if buff.name == buffname and buff.count > 0 then 
      return buff
    end
  end
  return {type = 0, name = "", startTime = 0, expireTime = 0, duration = 0, stacks = 0, count = 0}
end

function CalcPhysicalDamage(source, target, amount)
  local ArmorPenPercent = source.armorPenPercent
  local ArmorPenFlat = (0.4 + target.levelData.lvl / 30) * source.armorPen
  local BonusArmorPen = source.bonusArmorPenPercent

  if source.type == Obj_AI_Minion then
    ArmorPenPercent = 1
    ArmorPenFlat = 0
    BonusArmorPen = 1
  elseif source.type == Obj_AI_Turret then
    ArmorPenFlat = 0
    BonusArmorPen = 1
    if source.charName:find("3") or source.charName:find("4") then
      ArmorPenPercent = 0.25
    else
      ArmorPenPercent = 0.7
    end
  end

  if source.type == Obj_AI_Turret then
    if target.type == Obj_AI_Minion then
      amount = amount * 1.25
      if string.ends(target.charName, "MinionSiege") then
        amount = amount * 0.7
      end
      return amount
    end
  end

  local armor = target.armor
  local bonusArmor = target.bonusArmor
  local value = 100 / (100 + (armor * ArmorPenPercent) - (bonusArmor * (1 - BonusArmorPen)) - ArmorPenFlat)

  if armor < 0 then
    value = 2 - 100 / (100 - armor)
  elseif (armor * ArmorPenPercent) - (bonusArmor * (1 - BonusArmorPen)) - ArmorPenFlat < 0 then
    value = 1
  end
  return math.max(0, math.floor(DamageReductionMod(source, target, PassivePercentMod(source, target, value) * amount, 1)))
end

function CalcMagicalDamage(source, target, amount)
  local mr = target.magicResist
  local value = 100 / (100 + (mr * source.magicPenPercent) - source.magicPen)

  if mr < 0 then
    value = 2 - 100 / (100 - mr)
  elseif (mr * source.magicPenPercent) - source.magicPen < 0 then
    value = 1
  end
  return math.max(0, math.floor(DamageReductionMod(source, target, PassivePercentMod(source, target, value) * amount, 2)))
end

function DamageReductionMod(source,target,amount,DamageType)
  if source.type == Obj_AI_Hero then
    if GotBuff(source, "Exhaust") > 0 then
      amount = amount * 0.6
    end
  end

  if target.type == Obj_AI_Hero then

    for i = 0, target.buffCount do
      if target:GetBuff(i).count > 0 then
        local buff = target:GetBuff(i)
        if buff.name == "MasteryWardenOfTheDawn" then
          amount = amount * (1 - (0.06 * buff.count))
        end
    
        if DamageReductionTable[target.charName] then
          if buff.name == DamageReductionTable[target.charName].buff and (not DamageReductionTable[target.charName].damagetype or DamageReductionTable[target.charName].damagetype == DamageType) then
            amount = amount * DamageReductionTable[target.charName].amount(target)
          end
        end

        if target.charName == "Maokai" and source.type ~= Obj_AI_Turret then
          if buff.name == "MaokaiDrainDefense" then
            amount = amount * 0.8
          end
        end

        if target.charName == "MasterYi" then
          if buff.name == "Meditate" then
            amount = amount - amount * ({0.5, 0.55, 0.6, 0.65, 0.7})[target:GetSpellData(_W).level] / (source.type == Obj_AI_Turret and 2 or 1)
          end
        end
      end
    end

    if GetItemSlot(target, 1054) > 0 then
      amount = amount - 8
    end

    if target.charName == "Kassadin" and DamageType == 2 then
      amount = amount * 0.85
    end
  end

  return amount
end

function PassivePercentMod(source, target, amount, damageType)
  local SiegeMinionList = {"Red_Minion_MechCannon", "Blue_Minion_MechCannon"}
  local NormalMinionList = {"Red_Minion_Wizard", "Blue_Minion_Wizard", "Red_Minion_Basic", "Blue_Minion_Basic"}

  if source.type == Obj_AI_Turret then
    if table.contains(SiegeMinionList, target.charName) then
      amount = amount * 0.7
    elseif table.contains(NormalMinionList, target.charName) then
      amount = amount * 1.14285714285714
    end
  end
  if source.type == Obj_AI_Hero then 
    if target.type == Obj_AI_Hero then
      if (GetItemSlot(source, 3036) > 0 or GetItemSlot(source, 3034) > 0) and source.maxHealth < target.maxHealth and damageType == 1 then
        amount = amount * (1 + math.min(target.maxHealth - source.maxHealth, 500) / 50 * (GetItemSlot(source, 3036) > 0 and 0.015 or 0.01))
      end
    end
  end
  return amount
end

local function OnProcessSpellComplete(unit,spell)
	if unit:GetSpellData(spell).currentCd == 0 and unit:GetSpellData(spell).cd == 0 then return end
	if unit:GetSpellData(spell).currentCd >= unit:GetSpellData(spell).cd - 0.05 and unit:GetSpellData(spell).level > 0 then
		return true
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function Priority(charName)
  local p1 = {"Alistar", "Amumu", "Bard", "Blitzcrank", "Braum", "Cho'Gath", "Dr. Mundo", "Garen", "Gnar", "Hecarim", "Janna", "Jarvan IV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu", "Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona", "Taric", "TahmKench", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra"}
  local p2 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax", "Lee Sin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain", "Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"}
  local p3 = {"Akali", "Diana", "Ekko", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin", "Kayle", "Kha'Zix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo", "Zilean"}
  local p4 = {"Ahri", "Anivia", "Annie", "Ashe", "Azir", "Brand", "Caitlyn", "Cassiopeia", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "Karma", "Karthus", "Katarina", "Kennen", "KogMaw", "Kindred", "Leblanc", "Lucian", "Lux", "Malzahar", "MasterYi", "MissFortune", "Orianna", "Quinn", "Sivir", "Syndra", "Talon", "Teemo", "Tristana", "TwistedFate", "Twitch", "Varus", "Vayne", "Veigar", "Velkoz", "Viktor", "Xerath", "Zed", "Ziggs", "Jhin", "Soraka"}
  if table.contains(p1, charName) then return 1 end
  if table.contains(p2, charName) then return 2 end
  if table.contains(p3, charName) then return 3 end
  return table.contains(p4, charName) and 4 or 1
end

local function GetTarget(range,t)
local t = t or "AD"
local target = {}
	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isEnemy and GetDistance(myHero.pos,hero.pos) <= range and hero.valid and not hero.dead and hero.visible and hero.isTargetable then
			if t == "AD" then
				target[(CalcPhysicalDamage(myHero,hero,100) / hero.health)*Priority(hero.charName)] = hero
			elseif t == "AP" then
				target[(CalcMagicalDamage(myHero,hero,100) / hero.health)*Priority(hero.charName)] = hero
			elseif t == "HYB" then
				target[((CalcMagicalDamage(myHero,hero,50) + CalcPhysicalDamage(myHero,hero,50))/ hero.health)*Priority(hero.charName)] = hero
			end
		end
	end
	local bT = 0
	for d,v in pairs(target) do
		if d > bT then
			bT = d
		end
	end
	if bT ~= 0 then return target[bT] end
end
 
local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
local function CastSpell(spell,pos,range,delay)
local delay = delay or 250
local ticker = GetTickCount()
	if castSpell.state == 0 and GetDistance(myHero.pos,pos) < range and ticker - castSpell.casting > delay + Game.Latency()then
		castSpell.state = 1
		castSpell.mouse = mousePos
		castSpell.tick = ticker
	end
	if castSpell.state == 1 then
		if ticker - castSpell.tick < Game.Latency() then
			Control.SetCursorPos(pos)
			Control.KeyDown(spell)
			Control.KeyUp(spell)
			castSpell.casting = ticker + delay
			DelayAction(function()
				if castSpell.state == 1 then
					Control.SetCursorPos(castSpell.mouse)
					castSpell.state = 0
				end
			end,Game.Latency()/1000)
		end
		if ticker - castSpell.casting > Game.Latency() then
			Control.SetCursorPos(castSpell.mouse)
			castSpell.state = 0
		end
	end
end

local aa = {state = 1, tick = GetTickCount(), tick2 = GetTickCount(), downTime = GetTickCount(), target = myHero}
local lastTick = 0
local lastMove = 0
Callback.Add("Tick", function() aaTick() end)
function aaTick()
	if aa.state == 1 and myHero.attackData.state == 2 then
		lastTick = GetTickCount()
		aa.state = 2
		-- print("OnProcessAttack")
		aa.target = myHero.attackData.target
	end
	if aa.state == 2 then
		if myHero.attackData.state == 1 then
			aa.state = 1
			-- print("OnProcessAttackCancel")
		end
		if Game.Timer() + Game.Latency()/2000 + myHero.attackData.castFrame/150 > myHero.attackData.endTime - myHero.attackData.windDownTime and aa.state == 2 then
			aa.state = 3
			aa.tick2 = GetTickCount()
			aa.downTime = myHero.attackData.windDownTime*1000 - (myHero.attackData.windUpTime*1000)
			-- print("OnProcessAttackComplete: "..Game.Timer())
			if ADCMenu.fastOrb ~= nil and ADCMenu.fastOrb:Value() then
				if GetMode() ~= "" and myHero.attackData.state == 2 then
					Control.Move()
				end
			end
		end
	end
	if aa.state == 3 then
		if GetTickCount() - aa.tick2 - Game.Latency() - myHero.attackData.castFrame > myHero.attackData.windDownTime*1000 - (myHero.attackData.windUpTime*1000)/2 then
			aa.state = 1
			-- print("Can AA")
		end
		if myHero.attackData.state == 1 then
			aa.state = 1
			-- print("State 1")
		end
		-- print(aa.downTime)
		if GetTickCount() - aa.tick2 > aa.downTime then
			aa.state = 1
			-- print("downtime reset")
		end
	end
end

local castAttack = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
local function CastAttack(pos,range,delay)
local delay = delay or myHero.attackData.windUpTime*1000/2
-- local delay = Game.Latency()/1000
-- print(delay)
-- local delay = delay or 35 + Game.Latency()

local ticker = GetTickCount()
	if castAttack.state == 0 and GetDistance(myHero.pos,pos.pos) < range and ticker - castAttack.casting > delay + Game.Latency() and aa.state == 1 and not pos.dead and pos.isTargetable then
		castAttack.state = 1
		castAttack.mouse = mousePos
		castAttack.tick = ticker
		lastTick = GetTickCount()
		-- print("OnAttack")
	end
	if castAttack.state == 1 then
		if ticker - castAttack.tick < Game.Latency() and aa.state == 1 then
				-- aa.state = 2
				Control.SetCursorPos(pos.pos)
				Control.mouse_event(MOUSEEVENTF_RIGHTDOWN)
				Control.mouse_event(MOUSEEVENTF_RIGHTUP)
				castAttack.casting = ticker + delay
				-- print(ticker - castAttack.casting)
			DelayAction(function()
				if castAttack.state == 1 then
					Control.SetCursorPos(castAttack.mouse)
					castAttack.state = 0
				end
			end,Game.Latency()/1000)
		end
		if ticker - castAttack.casting > Game.Latency() and castAttack.state == 1 then
			Control.SetCursorPos(castAttack.mouse)
			castAttack.state = 0
			-- print("SetmouseBack")
		end
	end
end

local castMove = {state = 0, tick = GetTickCount(), mouse = mousePos}
local function CastMove(pos)
local movePos = pos or mousePos
Control.KeyDown(HK_TCO)
Control.mouse_event(MOUSEEVENTF_RIGHTDOWN)
Control.mouse_event(MOUSEEVENTF_RIGHTUP)
Control.KeyUp(HK_TCO)
end

--CORKI--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "Corki"

function Corki:__init()
	print("ADC Main | Corki loaded!")
	self.spellIcons = { Q = "http://vignette3.wikia.nocookie.net/leagueoflegends/images/f/f8/Phosphorus_Bomb.png",
						W = "http://vignette3.wikia.nocookie.net/leagueoflegends/images/d/d5/Valkyrie.png",
						E = "http://vignette3.wikia.nocookie.net/leagueoflegends/images/3/36/Gatling_Gun.png",
						R = "http://vignette2.wikia.nocookie.net/leagueoflegends/images/d/d3/Missile_Barrage.png"}
	self.Q = { delay = 0.25, speed = 1125, width = 250, range = 825 }
	self.W = { delay = 0.25, speed = 650, width = 100, range = 600 }
	self.E = { delay = 0.05, speed = math.huge, width = 80, range = 550 }
	self.R = { delay = 0.25, speed = 2000, width = 40, range = 1300 }
	self.range = 550
	self:Menu()
	function OnTick() self:Tick() end
 	function OnDraw() self:Draw() end
end

function Corki:Menu()
	-- COMBO
	ADCMenu.Combo:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.spellIcons.Q})
	ADCMenu.Combo:MenuElement({id = "useW", name = "Use W", value = true, leftIcon = self.spellIcons.W})
	ADCMenu.Combo:MenuElement({id = "useE", name = "Use E", value = true, leftIcon = self.spellIcons.E})
	ADCMenu.Combo:MenuElement({id = "useR", name = "Use R", value = true, leftIcon = self.spellIcons.R})
	ADCMenu.Combo:MenuElement({id = "Orb", name = "Use ADC in 2017 Orbwalker", value = true})
	-- ADCMenu.Combo:MenuElement({id = "OrbKey", name = "Orbwalker Key", key = string.byte(" ")})
	-- ADCMenu.Combo:MenuElement({id = "moveDelay", name = "Delay between movement clicks", value = 160, min = 0, max = 250, step = 1})
	
	-- HARASS
	ADCMenu.Harass:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.spellIcons.Q})
	ADCMenu.Harass:MenuElement({id = "manaQ", name = " Q | Mana-Manager", value = 70, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})
	ADCMenu.Harass:MenuElement({id = "useE", name = "Use E", value = false, leftIcon = self.spellIcons.E})
	ADCMenu.Harass:MenuElement({id = "manaE", name = " E | Mana-Manager", value = 80, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})
	ADCMenu.Harass:MenuElement({id = "useR", name = "Use R", value = true, leftIcon = self.spellIcons.R})
	ADCMenu.Harass:MenuElement({id = "useRX", name = "Safe X amount of R stacks", value = 4, min = 0, max = 7, step = 1, leftIcon = self.spellIcons.R})
	ADCMenu.Harass:MenuElement({id = "manaR", name = " R | Mana-Manager", value = 40, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})

	-- KILLSTEAL
	ADCMenu.Killsteal:MenuElement({id = "useQ", name = "Use Q to killsteal", value = true, leftIcon = self.spellIcons.Q})
	ADCMenu.Killsteal:MenuElement({id = "useR", name = "Use R to killsteal", value = true, leftIcon = self.spellIcons.R})
	
end

function Corki:Tick()
	if GetMode() == "Combo" then
		local target = GetTarget(1300,"AP")
		if target then
			if GetDistance(myHero.pos,target.pos) > self.range + 100 then
				local cTarget = GetTarget(self.range + 100,"AP")
				if cTarget then
					target = cTarget
				end
			end
		end
		if target then
			self:Combo(target)
			Item:useItem(target)
		end
		--hehexd
		if ADCMenu.Combo.Orb:Value() then
			if target and GetDistance(myHero.pos,target.pos) < self.range + 50 then
				if aa.state == 1 and aa.state ~= 2 and castSpell.state ~= 1 then
					Control.Attack(target)
				elseif aa.state == 3 and aa.state ~= 2 and castSpell.state ~= 1 and GetTickCount() - lastMove > 150 then
					Control.Move()
					lastMove = GetTickCount()
				end
			else
				if aa.state ~= 2 and castSpell.state ~= 1 and GetTickCount() - lastMove > 150 then
					Control.Move()
					lastMove = GetTickCount()
				end
			end
		end
	elseif GetMode() == "Harass" then
		local target = GetTarget(1300,"AP")
		if target then
			if GetDistance(myHero.pos,target.pos) > self.range + 100 then
				local cTarget = GetTarget(self.range + 100,"AP")
				if cTarget then
					target = cTarget
				end
			end
		end
		if target then
			self:Harass(target)
		end
	end
	self:Killsteal()
end

function Corki:Draw()

end

function Corki:Combo(target)
	if ADCMenu.Combo.useQ:Value() then
		self:useQ(target)
	end
	if ADCMenu.Combo.useE:Value() then
		self:useE(target)
	end
	if ADCMenu.Combo.useR:Value() then
		self:useR(target)
	end
	if ADCMenu.Combo.useW:Value() then
		self:useW(target)
	end
end

function Corki:Harass(target)
	local mp = GetPercentMP(myHero)
	if ADCMenu.Harass.useQ:Value() and mp > ADCMenu.Harass.manaQ:Value() then
		self:useQ(target)
	end
	if ADCMenu.Harass.useE:Value() and mp > ADCMenu.Harass.manaE:Value() then
		self:useE(target)
	end
	if ADCMenu.Harass.useR:Value() and mp > ADCMenu.Harass.manaR:Value() and myHero:GetSpellData(_R).ammo > ADCMenu.Harass.useRX:Value() then
		self:useR(target)
	end
end

function Corki:Killsteal()
	for i = 1, Game.HeroCount() do
		local target = Game.Hero(i)
		if target.isEnemy and target.valid and not target.dead and target.visible and target.isTargetable then
			Item:ksItem(target)
			local hp = target.health + target.shieldAP + target.shieldAD + target.hpRegen
			if ADCMenu.Killsteal.useQ:Value() and CanUseSpell(_Q) and GetDistance(myHero.pos,target.pos)+100 <= self.Q.range then
				local qDMG = CalcMagicalDamage(myHero,target,25 + 45*myHero:GetSpellData(_Q).level + (0.5*myHero.bonusDamage) + (0.5*myHero.ap))
				local qPred = target:GetPrediction(self.Q.speed,self.Q.delay)
				if hp < qDMG and GetDistance(qPred,myHero.pos) <= self.Q.range then
					CastSpell(HK_Q,qPred,self.Q.range)
				end
			end
			if ADCMenu.Killsteal.useR:Value() and CanUseSpell(_R) and myHero:GetSpellData(_R).ammo > 0 and GetDistance(myHero.pos,target.pos)+100 <= self.R.range then
				local rDMG = 0
				if GotBuff(myHero,"mbcheck2") > 0 then
					rDMG = CalcMagicalDamage(myHero,target,105 + 45*myHero:GetSpellData(_R).level + ((-0.3 + 0.6*myHero:GetSpellData(_R).level)*myHero.totalDamage) + (0.45*myHero.ap))
				else
					rDMG = CalcMagicalDamage(myHero,target,70 + 30*myHero:GetSpellData(_R).level + ((-0.2 + 0.4*myHero:GetSpellData(_R).level)*myHero.totalDamage) + (0.3*myHero.ap))
				end
				local rPred = target:GetPrediction(self.R.speed,self.R.delay)
				if hp < rDMG and GetDistance(rPred,myHero.pos) <= self.R.range and target:GetCollision(self.R.width,self.R.speed,self.R.delay) == 0 then
					CastSpell(HK_R,rPred,5000)
				end
			end
		end
	end
end

function Corki:useQ(target)
	if CanUseSpell(_Q) then
		local qPred = target:GetPrediction(self.Q.speed,self.Q.delay)
		if GetDistance(myHero.pos,qPred) < self.Q.range then
			if GetDistance(myHero.pos,target.pos) > self.range+25 then
				CastSpell(HK_Q,qPred,self.Q.range)
			elseif aa.state == 3 then
				CastSpell(HK_Q,qPred,self.Q.range)
			end
		end
	end
end

function Corki:useW(target)
--CarpetBomb,CarpetBombMega
	if CanUseSpell(_W) and myHero:GetSpellData(_W).name == "CarpetBomb" then
		if aa.state ~= 2 then
			local wPred = target:GetPrediction(math.huge,0.5)
			if GetDistance(target.pos,myHero.pos) > self.range + 100 and GetDistance(wPred,myHero.pos) < self.range + self.W.range then
				--agressive
				if GetDistance(mousePos,target.pos) + 250 < GetDistance(myHero.pos,mousePos) then
					local dps = (CalcPhysicalDamage(myHero,target,myHero.totalDamage*0.5) + CalcMagicalDamage(myHero,target,myHero.totalDamage*0.5)) * (0.625*myHero.attackSpeed)
						  dps = dps + ((dps*2) * (1+myHero.critChance))
					if dps < (CalcPhysicalDamage(myHero,target,myHero.totalDamage*0.5) + CalcMagicalDamage(myHero,target,myHero.totalDamage*0.5)) then
						dps = (CalcPhysicalDamage(myHero,target,myHero.totalDamage*0.5) + CalcMagicalDamage(myHero,target,myHero.totalDamage*0.5))
					end
					local qDMG = 0
					local rDMG = 0
					local mana = 100
					if CanUseSpell(myHero,_Q) then
						mana = mana + 50+10*myHero:GetSpellData(_Q).level
						qDMG = CalcMagicalDamage(myHero,target,25 + 45*myHero:GetSpellData(_Q).level + (0.5*myHero.bonusDamage) + (0.5*myHero.ap))
					end
					local rPred = 0
					if myHero:GetSpellData(_R).ammo > 0 then
						mana = mana + 20
						if target:GetCollision(self.R.width,self.R.speed,self.R.delay) == 0 then
							rPred = target:GetPrediction(self.R.speed,self.R.delay)
							if GetDistance(myHero.pos,rPred) > self.R.range then
								rPred = 0
							end
						end
						if GotBuff(myHero,"mbcheck2") > 0 then
							rDMG = CalcMagicalDamage(myHero,target,105 + 45*myHero:GetSpellData(_R).level + ((-0.3 + 0.6*myHero:GetSpellData(_R).level)*myHero.totalDamage) + (0.45*myHero.ap))
						else
							rDMG = CalcMagicalDamage(myHero,target,70 + 30*myHero:GetSpellData(_R).level + ((-0.2 + 0.4*myHero:GetSpellData(_R).level)*myHero.totalDamage) + (0.3*myHero.ap))
						end
					end
					local pewpewR = 0
					if rPred ~= 0 then
						local m = myHero:GetSpellData(_R).ammo
						if m < 2 then m = 1 else m = 2 end
						pewpewR = rDMG*m
					end
					local totalDPS = dps + qDMG + rDMG
					if target.health + target.shieldAP + target.shieldAD <= totalDPS and target.health + target.shieldAP + target.shieldAD > pewpewR then
						local underT = false
						for t = 1,Game.TurretCount() do
							local tower = Game.Turret(t)
							if GetDistance(wPred,tower.pos) < 800 and tower.isEnemy then
								underT = true
								break
							end
						end
						local enemiesAround = CountEnemiesInRange(myHero.pos,3000)
						if underT == false and enemiesAround <= CountAlliesInRange(myHero.pos,1500) + 1 and enemiesAround < 4 then
							CastSpell(HK_W,wPred,5000)
						end
					end
				end
			--defensive
			elseif GetDistance(target.pos,myHero.pos) < self.range - 300 then
				local away = 0
				-- soontm
			end
		end
	end
end

function Corki:useE(target)
	if CanUseSpell(_E) then
		if aa.state == 2 and GetDistance(myHero.pos,target.pos) < self.range - 25 then
			CastSpell(HK_E,target.pos,5000,10)
		end
	end
end

function Corki:useR(target)
	if CanUseSpell(_R) and myHero:GetSpellData(_R).ammo > 0 then
		local rPred = target:GetPrediction(self.R.speed,self.R.delay)
		if GetDistance(myHero.pos,rPred) < self.R.range and target:GetCollision(self.R.width,self.R.speed,self.R.delay) == 0 then
			if GetDistance(myHero.pos,target.pos) > self.range+50 then
				CastSpell(HK_R,rPred,5000)
			elseif aa.state == 3 then
				CastSpell(HK_R,rPred,5000)
			end
		end
	end
end

--SIVIR--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function DrawLine3D(x,y,z,a,b,c,width,col)
  local p1 = Vector(x,y,z):To2D()
  local p2 = Vector(a,b,c):To2D()
  Draw.Line(p1.x, p1.y, p2.x, p2.y, width, col)
end

local function DrawRectangleOutline(x, y, z, x1, y1, z1, width, col)
  local startPos = Vector(x,y,z)
  local endPos = Vector(x1,y1,z1)
  local c1 = startPos+Vector(Vector(endPos)-startPos):Perpendicular():Normalized()*width
  local c2 = startPos+Vector(Vector(endPos)-startPos):Perpendicular2():Normalized()*width
  local c3 = endPos+Vector(Vector(startPos)-endPos):Perpendicular():Normalized()*width
  local c4 = endPos+Vector(Vector(startPos)-endPos):Perpendicular2():Normalized()*width
  DrawLine3D(c1.x,c1.y,c1.z,c2.x,c2.y,c2.z,2,col)
  DrawLine3D(c2.x,c2.y,c2.z,c3.x,c3.y,c3.z,2,col)
  DrawLine3D(c3.x,c3.y,c3.z,c4.x,c4.y,c4.z,2,col)
  DrawLine3D(c1.x,c1.y,c1.z,c4.x,c4.y,c4.z,2,col)
end


class "Sivir"

function Sivir:__init()
	print("ADC Main | Sivir loaded!")
	self.spellIcons = { Q = "http://vignette2.wikia.nocookie.net/leagueoflegends/images/b/bb/Boomerang_Blade.png",
						W = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/8/87/Ricochet.png",
						E = "http://vignette2.wikia.nocookie.net/leagueoflegends/images/4/4a/Spell_Shield.png",
						R = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/f/fa/On_The_Hunt.png"}
	self.Q = { delay = 0.25, speed = 1350, width = 80, range = 1200 }
	self.range = 500
	self.incSpells = {}
	self.res = Game.Resolution()
	self:Menu()
	function OnTick() self:Tick() end
 	function OnDraw() self:Draw() end
end

function Sivir:Menu()
	ADCMenu.Combo:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.spellIcons.Q})
	ADCMenu.Combo:MenuElement({id = "useW", name = "Use W", value = true, leftIcon = self.spellIcons.W})
	ADCMenu.Combo:MenuElement({id = "useR", name = "Use R", value = true, leftIcon = self.spellIcons.R})
	ADCMenu.Combo:MenuElement({id = "useRonXE", name = " If X enemies around", value = 3, min = 1, max = 5, step = 1 , leftIcon = self.spellIcons.R})
	ADCMenu.Combo:MenuElement({id = "useRonXA", name = " If X allies around", value = 2, min = 0, max = 4, step = 1 , leftIcon = self.spellIcons.R})
	
	-- ADCMenu.Combo:MenuElement({id = "Orb", name = "Use ADC in 2017 Orbwalker", value = true})

	ADCMenu.Harass:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.spellIcons.Q})
	ADCMenu.Harass:MenuElement({id = "manaQ", name = " Q | Mana-Manager", value = 60, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})
	ADCMenu.Harass:MenuElement({id = "useW", name = "Use W", value = true, leftIcon = self.spellIcons.W})
	ADCMenu.Harass:MenuElement({id = "manaW", name = " W | Mana-Manager", value = 40, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})

	ADCMenu.Killsteal:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.spellIcons.Q})
	
	ADCMenu.Misc:MenuElement({id = "autoESpells", name = "Supported auto E spells", type = MENU})
	ADCMenu.Misc:MenuElement({id = "ESpells", name = "Please do report those spells back", type = MENU})
	ADCMenu.Misc:MenuElement({id = "autoE", name = "Use auto E agains skillshots", value = true, leftIcon = self.spellIcons.E})
	ADCMenu.Misc:MenuElement({id = "saveDelay", name = "E | Safety delay", value = 250, min = 150, max = 500, step = 10})
	ADCMenu.Misc:MenuElement({id = "autoQ", name = "Use auto Q on Immobile", value = true, leftIcon = self.spellIcons.Q})
	ADCMenu.Misc:MenuElement({id = "manaQ", name = " Q on Immobile | Mana-Manager", value = 70, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})
	
end

function Sivir:Tick()
if OnProcessSpellComplete(myHero,_W) then
	aa.state = 1
end
	if GetMode() == "Combo" then
		local target = GetTarget(1250,"AD")
		if target then
			if GetDistance(myHero.pos,target.pos) > self.range + 100 then
				local cTarget = GetTarget(self.range + 100,"AD")
				if cTarget then
					target = cTarget
				end
			end
		end
		if target then
			self:Combo(target)
			Item:useItem(target)
		end
		--hehexd
		-- if ADCMenu.Combo.Orb:Value() then
			-- if target and GetDistance(myHero.pos,target.pos) < self.range + 75 then
				-- if aa.state == 1 and aa.state ~= 2 and castSpell.state ~= 1 then
					-- CastAttack(target,self.range + 75)
					-- lastTick = GetTickCount()
				-- elseif aa.state == 3 and aa.state ~= 2 and castSpell.state ~= 1 and GetTickCount() - lastMove > 120 then
					-- Control.Move()
					-- lastMove = GetTickCount()
				-- end
			-- else
				-- if aa.state ~= 2 and castSpell.state ~= 1 and GetTickCount() - lastMove > 120 then
					-- Control.Move()
					-- lastMove = GetTickCount()
				-- end
			-- end
		-- end
	elseif GetMode() == "Harass" then
		local target = GetTarget(1250,"AD")
		if target then
			if GetDistance(myHero.pos,target.pos) > self.range + 100 then
				local cTarget = GetTarget(self.range + 100,"AD")
				if cTarget then
					target = cTarget
				end
			end
		end
		if target then
			self:Harass(target)
		end
	end
	
	if ADCMenu.Misc.autoQ:Value() then
		local mp = 100*myHero.mana/myHero.maxMana
		if mp >= ADCMenu.Misc.manaQ:Value() and Game.CanUseSpell(_Q) == 0 then
			local target = GetTarget(1250,"AD")
			if target then
				self:useQCC(target)
			end
		end
	end
	
	self:Killsteal()
end

function Sivir:Draw()
	if ADCMenu.Misc.autoE:Value() and CanUseSpell(_E) then
		self:GetSkillshots()
		for i,v in pairs(self.incSpells) do
			if v ~= nil then
				-- self:TargetSkillBlock(i,v,_E)
				self:LineSkillshotBlock(i,v,myHero,_E)
				-- self:CircularSkillshotBlock(i,v,myHero,_E)
			end
		end
	end
end

function Sivir:Combo(target)
	if ADCMenu.Combo.useW:Value() then
		self:useW(target)
	end
	if ADCMenu.Combo.useQ:Value() then
		self:useQ(target)
	end
	if ADCMenu.Combo.useR:Value() then
		self:useR(target)
	end
end

function Sivir:Harass(target)
	local mp = 100*myHero.mana/myHero.maxMana
	if ADCMenu.Harass.manaW:Value() <= mp and ADCMenu.Harass.useW:Value() then
		self:useW(target)
	end
	if ADCMenu.Harass.manaQ:Value() <= mp and ADCMenu.Harass.useQ:Value() then
		self:useQ(target)
	end
end

function Sivir:Killsteal()
	for i = 1, Game.HeroCount() do
		local target = Game.Hero(i)
		if target.isEnemy and target.valid and not target.dead and target.visible and target.isTargetable then
			Item:ksItem(target)
			if ADCMenu.Killsteal.useQ:Value() and Game.CanUseSpell(_Q) == 0 and GetDistance(myHero.pos,target.pos) < self.Q.range then
				local hp = target.health + target.shieldAD + target.hpRegen*2
				local qPred = target:GetPrediction(self.Q.speed,self.Q.delay)
				if GetDistance(myHero.pos,qPred) < self.Q.range then
					local col = target:GetCollision(self.Q.width,self.Q.speed,self.Q.delay)
					if col >= 4 then col = 4 end
					local qDMG = CalcPhysicalDamage(myHero,target,5 + 20*myHero:GetSpellData(_Q).level + myHero.totalDamage*(0.6 + 0.1*myHero:GetSpellData(_Q).level) + 0.5*myHero.ap ) * (1 - (0.15*col))
					if hp < qDMG and CountAlliesInRange(target.pos,500) == 0 then	
						CastSpell(HK_Q,qPred,self.Q.range)
					end
				end
			end
		end
	end
end

function Sivir:useQ(target)
	if Game.CanUseSpell(_Q) == 0 then
		local qPred = target:GetPrediction(self.Q.speed,self.Q.delay)
		self:useQonAA(target,qPred)
		self:useQ2(target,qPred)
		self:useQkill(target,qPred)
		self:useQCC(target,qPred)
	end
end

function Sivir:useQonAA(target,qPred)
	if aa.state == 3 and aa.downTime - (GetTickCount() - aa.tick2) > 250 and GetDistance(target.pos,myHero.pos) <= self.range + myHero.boundingRadius + target.boundingRadius and Game.CanUseSpell(_W) ~= 0 then
		CastSpell(HK_Q,qPred,self.Q.range)
	end
end

function Sivir:useQ2(target,qPred)
	local sivirDelay = (self.Q.range + (self.Q.range - qPred:DistanceTo(myHero.pos)))/self.Q.speed + 0.25
	local qPred2 = target:GetPrediction(math.huge,sivirDelay)
	local checkPoint = myHero.pos + Vector(myHero.pos,qPred2):Normalized() * qPred:DistanceTo(myHero.pos)
	if GetDistance(checkPoint,qPred) < self.Q.width + target.boundingRadius and GetDistance(target.pos,qPred2) > 1 and GetDistance(myHero.pos,qPred2) <= self.Q.range then
		CastSpell(HK_Q,qPred,self.Q.range)
	end
end

function Sivir:useQkill(target,qPred)
	if GetDistance(myHero.pos,qPred) <= self.Q.range then
		local col = target:GetCollision(self.Q.width,self.Q.speed,self.Q.delay)
		if col >= 4 then col = 4 end
		local qDMG = CalcPhysicalDamage(myHero,target,5 + 20*myHero:GetSpellData(_Q).level + myHero.totalDamage*(0.6 + 0.1*myHero:GetSpellData(_Q).level) + 0.5*myHero.ap ) * (1 - (0.15*col))
		if target.health + target.shieldAD + target.hpRegen < qDMG then
			CastSpell(HK_Q,qPred,self.Q.range)
		end
	end
end

function Sivir:useQCC(target)
	if GetDistance(myHero.pos,target.pos) < self.Q.range and aa.state ~= 2 and ((aa.state == 3 and aa.downTime - (GetTickCount() - aa.tick2) > 250 and GetDistance(target.pos,myHero.pos) <= self.range + myHero.boundingRadius + target.boundingRadius) or GetDistance(target.pos,myHero.pos) > self.range + myHero.boundingRadius + target.boundingRadius ) then
		if IsImmobileTarget(target) then
			CastSpell(HK_Q,target.pos,self.Q.range)
		end
	end
end

function Sivir:useW(target)
	if Game.CanUseSpell(_W) == 0 and GetDistance(target.pos,myHero.pos) < self.range + 250 then
		if GetTickCount() - aa.tick2 < 250 and aa.state == 3 then
			CastSpell(HK_W,mousePos,5000,10)
		end
	end
end

function Sivir:useR(target)
	if Game.CanUseSpell(_R) == 0 and GetDistance(myHero.pos,target.pos) < 1000 then
		if ADCMenu.Combo.useRonXE:Value() <= CountEnemiesInRange(myHero.pos, 1200) and ADCMenu.Combo.useRonXA:Value() <= CountAlliesInRange(myHero.pos, 1000) then
			CastSpell(HK_R,mousePos,5000,10)
		end
	end
end

function Sivir:GetSkillshots()
	for i = 1, Game.MissileCount() do
		local missile = Game.Missile(i)
		-- if missile and (missile.missileData.owner > 0) and (missile.missileData.speed > 0) and missile.isEnemy and (missile.team < 300) and missile.missileData.target == myHero.networkID then
			-- Draw.Circle(missile.pos,missile.missileData.width,Draw.Color(100,0xFF,0xFF,0xFF))
		-- end
		if missile and (missile.missileData.owner > 0) and (missile.missileData.speed > 0) and (missile.missileData.width > 0) and (missile.missileData.range > 0) and missile.isEnemy and (missile.team < 300) then
			-- Draw.Circle(missile.pos,missile.missileData.width,Draw.Color(100,0xFF,0xFF,0xFF))
			-- DrawRectangleOutline(missile.missileData.startPos.x,missile.missileData.startPos.y,missile.missileData.startPos.z,missile.missileData.endPos.x,missile.missileData.endPos.y,missile.missileData.endPos.z,missile.missileData.width,drawColor);
								
			local OwnerObj
			for i,v in pairs(GetEnemyHeroes()) do
				if missile.missileData.owner == v.handle then
					OwnerObj = v
				end
			end
			if ADCMenu.Misc.autoESpells[missile.missileData.name] == nil and OwnerObj ~= nil then
				if ADCMenu.Misc.ESpells[missile.missileData.name] == nil then
					-- print("Missing: "..OwnerObj.charName.." | "..missile.missileData.name)
					ADCMenu.Misc.ESpells:MenuElement({id = missile.missileData.name, name = OwnerObj.charName.." | "..missile.missileData.name, value = false})
				end
			end
			if OwnerObj ~= nil and _SPELLS[OwnerObj.charName] ~= nil then
				for _,_SS in pairs(_SPELLS[OwnerObj.charName]) do
					if _SS.missileName ~= nil or _SS.spellName ~= nil then
						if _SS.missileName == missile.missileData.name or _SS.spellName == missile.missileData.name then
							if (self.res.x*2 >= missile.pos2D.x) and (self.res.x*-1 <= missile.pos2D.x) and (self.res.y*2 >= missile.pos2D.y) and (self.res.y*-1 <= missile.pos2D.y) then --draw skillshots close to our screen, probably we need to exclude global ultimates
								if self.incSpells[missile.missileData.name] == nil then
									if _SS.spellType == "Line" then
										if ADCMenu.Misc.autoESpells[missile.missileData.name] == nil then
											local x = {[0]="Q",[1]="W",[2]="E",[3]="R"}
											ADCMenu.Misc.autoESpells:MenuElement({id = missile.missileData.name, name = x[_SS.Slot].." | "..OwnerObj.charName.." | ".._SS.name, value = true})
											print("Added: "..missile.missileData.name)
										end
										self.incSpells[missile.missileData.name] = {sPos = missile.pos, ePos = missile.missileData.endPos, pos = missile.pos, radius = missile.missileData.width, speed = _SS.projectileSpeed, sType = _SS.spellType, createTime = GetTickCount()}
									-- elseif CC[missile.missileData.name].spellType == "circular" then
										-- self.incSpells[missile.missileData.name] = {sPos = missile.pos, ePos = missile.missileData.ePos, delay = missile.missileData.delay, radius = missile.missileData.width, speed = CC[missile.missileData.name].projectileSpeed, sType = CC[missile.missileData.name].spellType, createTime = GetTickCount()}
									end
								end
							end
						end
					end
				end
			end
		end
	end
end


function Sivir:TargetSkillBlock(i,v,cast)
	if v.sType == "target" then
		local spellPos =  v.sPos + Vector(v.sPos,v.ePos.pos):Normalized() * (v.speed/1000*(GetTickCount()-v.createTime))
		local timeToDodge = 100 + ADCMenu.Misc.saveDelay:Value() + Game.Latency()
		local dodgeHere = spellPos + Vector(v.sPos,v.ePos.pos):Normalized() * (v.speed*(timeToDodge + v.delay)/1000)
		if GetDistance(v.ePos.pos,spellPos) <= GetDistance(dodgeHere,spellPos) and GetDistance(v.ePos.pos, v.sPos) - v.radius - v.ePos.boundingRadius <= GetDistance(v.sPos,v.ePos.pos) then
			if CanUseSpell(cast) then
				Control.CastSpell(HK_E)
			end
		end
		if GetDistance(spellPos,v.sPos) > GetDistance(v.ePos.pos,v.sPos) then
			incSpells[i] = nil
		end
	end
end

function Sivir:LineSkillshotBlock(i,v,who,cast)
	if v.sType == "Line" and ADCMenu.Misc.autoESpells[i]:Value() then
		local spellOnMe = v.sPos + Vector(v.sPos,v.ePos):Normalized() * GetDistance(who.pos,v.sPos)
		local spellPos = v.sPos + Vector(v.sPos,v.ePos):Normalized() * (v.speed/1000*(GetTickCount()-v.createTime))
		local timeToDodge = 150 + ADCMenu.Misc.saveDelay:Value() + Game.Latency()
		local dodgeHere = spellPos + Vector(v.sPos,v.ePos):Normalized() * (v.speed*(timeToDodge)/1000)
			if GetDistance(spellOnMe,spellPos) <= GetDistance(dodgeHere,spellPos) and GetDistance(spellOnMe,v.sPos) - v.radius - who.boundingRadius <= GetDistance(v.sPos,v.ePos) then
				if GetDistance(who.pos,spellOnMe) < v.radius + who.boundingRadius then
					if CanUseSpell(cast) then
						Control.CastSpell(HK_E)
					end
				end
			end
		if (GetDistance(spellPos,v.sPos) >= GetDistance(v.sPos,v.ePos)) then
			self.incSpells[i] = nil
		end
	end
end

function Sivir:CircularSkillshotBlock(i,v,who,cast)
	if v.sType == "circular" then
		Draw.Circle(v.ePos,v.radius,Draw.Color(255,255,50,50))
		local timeToDodge = ((v.radius + who.boundingRadius - GetDistance(who.pos,v.ePos))/who.ms)*1000 - ADCMenu.Misc.saveDelay:Value()
		local timeToHit = (GetDistance(v.ePos,v.sPos)/v.speed)*1000 + v.createTime - GetTickCount() + v.delay
		print(timeToHit)
		if GetDistance(v.ePos,who.pos) < v.radius + who.boundingRadius then
			if timeToHit < timeToDodge and timeToHit > 0.05 then
				if CanUseSpell(cast) then
					Control.CastSpell(HK_E)
				end
			end
		end
		if timeToHit <= 0 then
			self.incSpells[i] = nil
		end
	end
end

--VAYNE--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "Vayne"

function Vayne:__init()
	if not pcall( require, "MapPositionGOS" ) then PrintChat("You are missing MapPositionGOS.lua!") return end
	print("ADC Main | Vayne loaded!")
	self.spellIcons = { Q = "http://vignette4.wikia.nocookie.net/leagueoflegends/images/8/8d/Tumble.png",
						W = "http://vignette3.wikia.nocookie.net/leagueoflegends/images/1/12/Silver_Bolts.png",
						E = "http://vignette2.wikia.nocookie.net/leagueoflegends/images/6/66/Condemn.png",
						R = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/b/b4/Final_Hour.png"}
	self.AA = { delay = 0.25, speed = 2000, width = 0, range = 550 }
	self.Q = { delay = 0.5, speed = 1000, width = 0, range = 300 }
	self.W = { delay = 0, speed = 0, width = 0, range = 0, dmg = function(target) return 1 end }
	self.E = { delay = 0.15, speed = 2000, width = 10, range = 750 }
	self.R = { delay = 0.25, speed = 2000, width = 40, range = 1300 }
	self.range = 550
	self.canUseQ = Game.CanUseSpell(_Q)
	self:Menu()
	function OnTick() self:Tick() end
 	-- function OnDraw() self:Draw() end
end

function Vayne:Menu()
	-- COMBO
	ADCMenu.Combo:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.spellIcons.Q})
	ADCMenu.Combo:MenuElement({id = "useE", name = "Use E", value = true, leftIcon = self.spellIcons.E})
	ADCMenu.Combo:MenuElement({id = "Epush", name = "Custom E push distance", value = 350, min = 100, max = 450, step = 10, leftIcon = self.spellIcons.E})
	ADCMenu.Combo:MenuElement({id = "useR", name = "Use R", value = true, leftIcon = self.spellIcons.R})
	ADCMenu.Combo:MenuElement({id = "useRx", name = "Use R at X enemies", value = 3, min = 1, max = 5, step = 1, leftIcon = self.spellIcons.R})
	ADCMenu.Combo:MenuElement({id = "Orb", name = "Use ADC in 2017 Orbwalker", value = true})
	
	-- HARASS
	ADCMenu.Harass:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.spellIcons.Q})
	ADCMenu.Harass:MenuElement({id = "manaQ", name = " Q | Mana-Manager", value = 60, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})

	-- KILLSTEAL
	ADCMenu.Killsteal:MenuElement({id = "useE", name = "Use E to killsteal", value = true, leftIcon = self.spellIcons.E})
end

function Vayne:Tick()
	if GetMode() == "Combo" then
		local target = GetTarget(850,"AD")
		if target then
			if GetDistance(myHero.pos,target.pos) > self.range + 100 then
				local cTarget = GetTarget(self.range + 100,"AD")
				if cTarget then
					target = cTarget
				end
			end
		end
		if target then
			self:Combo(target)
			Item:useItem(target)
		end
		--hehexd
		if ADCMenu.Combo.Orb:Value() then
			if target and GetDistance(myHero.pos,target.pos) < self.range + 75 then
				if aa.state == 1 and aa.state ~= 2 and castSpell.state ~= 1 then
					-- Control.Attack(target)
					CastAttack(target,self.range + 75)
					lastTick = GetTickCount()
				elseif aa.state == 3 and aa.state ~= 2 and castSpell.state ~= 1 and GetTickCount() - lastMove > 120 then
					Control.Move()
					lastMove = GetTickCount()
				end
			else
				if aa.state ~= 2 and castSpell.state ~= 1 and GetTickCount() - lastMove > 120 then
					Control.Move()
					lastMove = GetTickCount()
				end
			end
		end
	elseif GetMode() == "Harass" then
		local target = GetTarget(850,"AD")
		if target then
			if GetDistance(myHero.pos,target.pos) > self.range + 100 then
				local cTarget = GetTarget(self.range + 100,"AD")
				if cTarget then
					target = cTarget
				end
			end
		end
		if target then
			self:Harass(target)
		end
	end
	self:Killsteal()
	self:ResetOrb()
end

function Vayne:Draw()

end

function Vayne:ResetOrb()
	if self.canUseQ ~= 0 and  Game.CanUseSpell(_Q) == 0 then
		self.canUseQ = Game.CanUseSpell(_Q)
	end
	if self.canUseQ == 0 and Game.CanUseSpell(_Q) ~= 0 then
		aa.state = 1
		castAttack.state = 0
		castAttack.casting = GetTickCount() - 1000
		self.canUseQ = Game.CanUseSpell(_Q)
	end
end

function Vayne:Combo(target)
	if ADCMenu.Combo.useQ:Value() then
		self:useQ(target)
	end
	if ADCMenu.Combo.useE:Value() then
		self:useE(target)
	end
	if ADCMenu.Combo.useR:Value() then
		self:useR(target)
	end
end

function Vayne:Harass(target)
	local mp = GetPercentMP(myHero)
	if ADCMenu.Harass.useQ:Value() and mp > ADCMenu.Harass.manaQ:Value() then
		self:useQ(target)
	end
end

function Vayne:Killsteal()
	for i = 1, Game.HeroCount() do
		local target = Game.Hero(i)
		if target.isEnemy and target.valid and not target.dead and target.visible and target.isTargetable then
			Item:ksItem(target)
			if ADCMenu.Killsteal.useE:Value() and Game.CanUseSpell(_E) == 0 and GetDistance(myHero.pos,target.pos) < self.E.range and (GetDistance(myHero.pos,target.pos) > self.range or (aa.state == 3 and GetTickCount() - aa.tick2 < 100)) then
				local hp = target.health + target.shieldAD + target.hpRegen*2
				local extraStackeronikekoroni = 0
				if GetTickCount() - aa.tick2 < GetDistance(myHero.pos,target.pos)/self.AA.speed*1000 - 100 and aa.target == target.handle then
					extraStackeronikekoroni = 1
				end
				local wDMG = 0
				if GotBuff(target,"VayneSilveredDebuff") + extraStackeronikekoroni == 2 then
					wDMG = math.floor(target.maxHealth*(0.045 + 0.015*myHero:GetSpellData(_W).level) + 20 + 20*myHero:GetSpellData(_W).level)
				end
				if hp < wDMG and CountAlliesInRange(target.pos,500) == 0 then
					CastSpell(HK_E,target.pos,self.E.range)
				end
			end
		end
	end
end

function Vayne:useQ(target)
	if Game.CanUseSpell(_Q) == 0 then
		self:useQkill(target)
		self:useQchase(target)
		self:useQaway(target)
		self:useQSilver(target)
		self:useQult(target)
	end
end

function Vayne:useE(target)
	if CanUseSpell(_E) and GetDistance(myHero.pos,target.pos) <= self.E.range then
		self:useEstun(target)
		self:useEtower(target)
		self:useEmelee(target)
	end
end

function Vayne:useR(target)
	if CanUseSpell(_R) then
		self:useRfight(target)
	end
end

function Vayne:useQchase(target)
	if aa.state == 3 then
		local qPred = target:GetPrediction(math.huge,0.75)
		if GetDistance(target.pos,myHero.pos) <= self.range + 50 and GetDistance(qPred,myHero.pos) > self.range + 50 then
			if GetDistance(mousePos,target.pos) + 250 < GetDistance(myHero.pos,mousePos) then
				local dashRange = GetDistance(myHero.pos,mousePos)
				if dashRange > self.Q.range then dashRange = self.Q.range end
				local afterQ = myHero.pos + Vector(myHero.pos,mousePos):Normalized() * dashRange
				local underT = false
				for t = 1,Game.TurretCount() do
					local tower = Game.Turret(t)
					if GetDistance(qPred,tower.pos) < 800 and GetDistance(afterQ,tower.pos) < 750 and tower.isEnemy then
						underT = true
						break
					end
				end
				if underT == false then
					CastSpell(HK_Q,mousePos,5000,100)
				end
			end		
		end
	end
end

function Vayne:useQaway(target)
	if aa.state == 3 then
		local qPred = target:GetPrediction(math.huge,0.5)
		if GetDistance(target.pos,myHero.pos) <= self.range + 50 and GetDistance(qPred,myHero.pos) <= 200 then
			local dashRange = 425
			local qPosVec = Vector(myHero.pos,mousePos):Normalized()
			local afterQ = myHero.pos + qPosVec * dashRange
			if GetDistance(afterQ,target.pos) < GetDistance(myHero.pos,target.pos) then
				afterQ = myHero.pos - qPosVec * dashRange
			end
			local underT = false
			for t = 1,Game.TurretCount() do
				local tower = Game.Turret(t)
				if GetDistance(qPred,tower.pos) < 800 and GetDistance(afterQ,tower.pos) < 750 and tower.isEnemy then
					underT = true
					break
				end
			end
			if underT == false and CountEnemiesInRange(myHero.pos, 650) >= CountEnemiesInRange(afterQ, 650) then
				CastSpell(HK_Q,afterQ,5000,100)
			end	
		end
	end
end

function Vayne:useQSilver(target)
	if aa.state == 3 and aa.downTime - (GetTickCount() - aa.tick2) > 250 then
		local extraStackeronikekoroni = 0
		if GetTickCount() - aa.tick2 < GetDistance(myHero.pos,target.pos)/self.AA.speed*1000 - 100 and aa.target == target.handle then
			extraStackeronikekoroni = 1
		end
		local dashRange = GetDistance(myHero.pos,mousePos)
		if dashRange > self.Q.range then dashRange = self.Q.range end
		local qPos = myHero.pos + Vector(myHero.pos,mousePos):Normalized() * dashRange
		local qPosVec = Vector(myHero.pos,mousePos):Normalized()
		local afterQ = myHero.pos + qPosVec * (GetDistance(myHero.pos,target.pos) - 350)
		if GetDistance(afterQ,target.pos) < 550 then
			if GotBuff(target,"VayneSilveredDebuff") + extraStackeronikekoroni == 2 then
				CastSpell(HK_Q,mousePos,5000,100)
			end
		end
	end
end

function Vayne:useQkill(target)
	if aa.state ~= 2 then
		local qPred = target:GetPrediction(math.huge,0.5)
		if GetDistance(target.pos,myHero.pos) <= self.range + 75 + 300 and GetDistance(qPred,myHero.pos) > self.range + 50 then
			if GetDistance(mousePos,target.pos) + 250 < GetDistance(myHero.pos,mousePos) then
				local hp = target.health + target.shieldAD + target.hpRegen*2
				local qDMG = CalcPhysicalDamage(myHero,target,myHero.totalDamage + (myHero.totalDamage*(0.25+0.05*myHero:GetSpellData(_Q).level)))
				local extraStackeronikekoroni = 0
				local extraAA = 0
				if GetTickCount() - aa.tick2 < GetDistance(myHero.pos,target.pos)/self.AA.speed*1000 - 100 and aa.target == target.handle then
					extraStackeronikekoroni = 1
					extraAA = CalcPhysicalDamage(myHero,target,myHero.totalDamage)
				end
				local wDMG = 0
				if GotBuff(target,"VayneSilveredDebuff") + extraStackeronikekoroni == 2 then
					wDMG = math.floor(target.maxHealth*(0.045 + 0.015*myHero:GetSpellData(_W).level) + 20 + 20*myHero:GetSpellData(_W).level)
				end
				if hp <= qDMG + extraAA + wDMG then
					CastSpell(HK_Q,target.pos,5000,100)
				end
			end
		end
	end
end

function Vayne:useQult(target)
	if GetDistance(myHero.pos,target.pos) < 850 then
		if GotBuff(myHero,"VayneInquisition") > 0 then
			local dashRange = GetDistance(myHero.pos,mousePos)
			if dashRange > self.Q.range then dashRange = self.Q.range end
			local qPos = myHero.pos + Vector(myHero.pos,mousePos):Normalized() * dashRange
			if GetDistance(qPos,target.pos) < 600 then
				CastSpell(HK_Q,mousePos,5000,100)
			end
		end
	end
end

function Vayne:useEstun(target)
	-- if aa.state ~= 2 and GetDistance(myHero.pos,target.pos) < self.E.range and ((GetDistance(myHero.pos,target.pos) < self.range + 50 and aa.state == 3) or GetDistance(myHero.pos,target.pos) > self.range + 50 ) then
	-- if (aa.state == 3 and GetDistance(myHero.pos,target.pos) < self.range + 50) or (GetDistance(myHero.pos,target.pos) > self.range + 50) then
		local ePred = target:GetPrediction(self.E.speed,self.E.delay)
		for i = 100,ADCMenu.Combo.Epush:Value(),50 do
			local pushPos = myHero.pos + Vector(myHero.pos,ePred):Normalized() * (GetDistance(myHero.pos,target.pos) + i)
			local checkPos = myHero.pos + Vector(myHero.pos,ePred):Normalized() * (GetDistance(myHero.pos,target.pos) + i + 50)
			if MapPosition:inWall(pushPos) == true and MapPosition:inWall(checkPos) == true and GetDistance(pushPos,myHero.pos) < self.range + ADCMenu.Combo.Epush:Value() then
				CastSpell(HK_E,target.pos,self.E.range)
				break
			end
		end
	-- end
end

function Vayne:useEmelee(target)
	if aa.state ~= 2 and Game.CanUseSpell(_Q) ~= 0 then
		if target.range < 300 then
			if GetDistance(myHero.pos,target.pos) < 250 then
				local ePred = target:GetPrediction(self.E.speed,self.E.delay)
				if GetDistance(ePred,myHero.pos) < GetDistance(target.pos,myHero.pos) then
					CastSpell(HK_E,target.pos,self.E.range)
				end
			end
		end
	end
end

function Vayne:useEtower(target)
	for t = 1,Game.TurretCount() do
		local tower = Game.Turret(t)
		if GetDistance(target.pos,tower.pos) < 800 and GetDistance(myHero.pos,tower.pos) < 1200 and tower.isAlly and tower.targetID == target.networkID then
			local ePred = target:GetPrediction(self.E.speed,self.E.delay)
			local pushPos = myHero.pos + Vector(myHero.pos,ePred):Normalized() * 350
			if GetDistance(tower.pos,pushPos) < GetDistance(tower.pos,target.pos) then 
				CastSpell(HK_E,target.pos,self.E.range)
			end
			break
		end
	end
end

function Vayne:useRfight(target)
	if CountEnemiesInRange(myHero.pos,800) >= ADCMenu.Combo.useRx:Value() then
		CastSpell(HK_R,mousePos,5000,100)
	end
end


class "Varus"

function Varus:__init()
	print("ADC Main | Varus loaded!")
	self.spellIcons = { Q = "http://vignette4.wikia.nocookie.net/leagueoflegends/images/8/8d/Tumble.png",
						W = "http://vignette3.wikia.nocookie.net/leagueoflegends/images/1/12/Silver_Bolts.png",
						E = "http://vignette2.wikia.nocookie.net/leagueoflegends/images/6/66/Condemn.png",
						R = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/b/b4/Final_Hour.png"}
	self.AA = { delay = 0.25, speed = 2000, width = 0, range = 550 }
	self.Q = { delay = 0.5, speed = 1000, width = 0, range = 300 }
	self.W = { delay = 0, speed = 0, width = 0, range = 0, dmg = function(target) return 1 end }
	self.E = { delay = 0.15, speed = 2000, width = 10, range = 750 }
	self.R = { delay = 0.25, speed = 2000, width = 40, range = 1300 }
	self.range = 575
	self:Menu()
	function OnTick() self:Tick() end
end

function Varus:Menu()
	ADCMenu.Combo:MenuElement({id = "Orb", name = "Use ADC in 2017 Orbwalker", value = true})
end

function Varus:Tick()
	-- Draw.Text(aa.state,30,500,500)
		if GetMode() == "Combo" then
		local target = GetTarget(850,"AD")
		if target then
			if GetDistance(myHero.pos,target.pos) > self.range + 100 then
				local cTarget = GetTarget(self.range + 100,"AD")
				if cTarget then
					target = cTarget
				end
			end
		end
		if target then
			-- self:Combo(target)
			Item:useItem(target)
		end
		--hehexd
		if ADCMenu.Combo.Orb:Value() then
			if target and GetDistance(myHero.pos,target.pos) < self.range + 75 then
				if aa.state == 1 and aa.state ~= 2 and castSpell.state ~= 1 then
					CastAttack(target,self.range + 75)
					lastTick = GetTickCount()
				elseif aa.state == 3 and aa.state ~= 2 and castSpell.state ~= 1 and GetTickCount() - lastMove > 120 then
					-- Control.Move()
					CastMove()
					lastMove = GetTickCount()
				end
			else
				if aa.state ~= 2 and castSpell.state ~= 1 and GetTickCount() - lastMove > 120 then
					-- Control.Move()
					CastMove()
					lastMove = GetTickCount()
				end
			end
		end
	elseif GetMode() == "Clear" then
		local target
		if Game.MinionCount() > 0 then
			for i = 0,Game.MinionCount() do
				local minion = Game.Minion(i)
				if minion and GetDistance(minion.pos,myHero.pos) < self.range + 50 and minion.isEnemy and minion.valid and not minion.dead then
					target = minion
					break
				end
			end
		end
			if target and GetDistance(myHero.pos,target.pos) < self.range + 75 then
				if aa.state == 1 and aa.state ~= 2 and castSpell.state == 0 and castAttack.state == 0 and GetTickCount() - lastTick > 150 then
					CastAttack(target,self.range + 75)
					lastTick = GetTickCount()
				elseif aa.state == 3 and castSpell.state ~= 1 and GetTickCount() - lastMove > 120 then
					CastMove()
					lastMove = GetTickCount()
				end
			else
				if aa.state ~= 2 and castSpell.state ~= 1 and GetTickCount() - lastMove > 120 then
					CastMove()
					lastMove = GetTickCount()
				end
			end
	end
end

--ITEMS--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "Item"
function Item:__init()
	self.Icon = { 	Cut = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/4/44/Bilgewater_Cutlass_item.png",
					Bork = "http://vignette2.wikia.nocookie.net/leagueoflegends/images/2/2f/Blade_of_the_Ruined_King_item.png",
					Ghost = "http://vignette4.wikia.nocookie.net/leagueoflegends/images/4/41/Youmuu%27s_Ghostblade_item.png",
					Gun = "http://vignette4.wikia.nocookie.net/leagueoflegends/images/6/64/Hextech_Gunblade_item.png",	
					RedPot = "http://vignette3.wikia.nocookie.net/leagueoflegends/images/6/62/Elixir_of_Wrath_item.png",	
					BluePot = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/2/27/Elixir_of_Sorcery_item.png",	
				}	
	self:Menu()
end

function Item:Menu()
	ADCMenu.Items:MenuElement({id = "useCut", name = "Bilgewater Cutlass", value = true, leftIcon = self.Icon.Cut})
	ADCMenu.Items:MenuElement({id = "useBork", name = "Blade of the Ruined King", value = true, leftIcon = self.Icon.Bork})
	ADCMenu.Items:MenuElement({id = "useGhost", name = "Youmuu's Ghostblade", value = true, leftIcon = self.Icon.Ghost})
	ADCMenu.Items:MenuElement({id = "useGun", name = "Hextech Gunblade", value = true, leftIcon = self.Icon.Gun})
	ADCMenu.Items:MenuElement({id = "useRedPot", name = "Elixir of Wrath", value = true, leftIcon = self.Icon.RedPot})
	ADCMenu.Items:MenuElement({id = "useBluePot", name = "Elixir of Sorcery", value = true, leftIcon = self.Icon.BluePot})
	
	ADCMenu.Killsteal:MenuElement({id = "ksCut", name = "Bilgewater Cutlass", value = true, leftIcon = self.Icon.Cut})
	ADCMenu.Killsteal:MenuElement({id = "ksBork", name = "Blade of the Ruined King", value = true, leftIcon = self.Icon.Bork})
	ADCMenu.Killsteal:MenuElement({id = "ksGun", name = "Hextech Gunblade", value = true, leftIcon = self.Icon.Gun})
end

local ItemTick = GetTickCount()
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)
local bluepot = GetItemSlot(myHero,2139)
local gun = GetItemSlot(myHero,3146)
local Item_HK = {}

function Item:useItem(target)

local ticker = GetTickCount()
if 	ItemTick + 5000 < ticker then
	Item_HK[ITEM_1] = HK_ITEM_1
	Item_HK[ITEM_2] = HK_ITEM_2
	Item_HK[ITEM_3] = HK_ITEM_3
	Item_HK[ITEM_4] = HK_ITEM_4
	Item_HK[ITEM_5] = HK_ITEM_5
	Item_HK[ITEM_6] = HK_ITEM_6 
	Item_HK[ITEM_7] = HK_ITEM_7 
	CutBlade = GetItemSlot(myHero,3144)
	bork = GetItemSlot(myHero,3153)
	ghost = GetItemSlot(myHero,3142)
	redpot = GetItemSlot(myHero,140)
	bluepot = GetItemSlot(myHero,2139)
	gun = GetItemSlot(myHero,3146)
	ItemTick = ticker
end
	if CutBlade >= 1 and GetDistance(myHero.pos,target.pos) <= 550 + 25 and ADCMenu.Items.useCut:Value() then
		if CanUseSpell(CutBlade) then
			CastSpell(Item_HK[CutBlade],target.pos,575,50)
		end	
	elseif bork >= 1 and GetDistance(myHero.pos,target.pos) <= 550 + 25 and GetPercentHP(myHero) <= 65 and ADCMenu.Items.useBork:Value() then 
		if CanUseSpell(bork) then
			CastSpell(Item_HK[bork],target.pos,575,50)
		end
	end
	if ghost >= 1 and GetDistance(myHero.pos,target.pos) <= 550 + 25 and ADCMenu.Items.useGhost:Value() then
		if CanUseSpell(ghost) then
			Control.CastSpell(Item_HK[ghost])
		end
	end
	if gun >= 1 and GetDistance(myHero.pos,target.pos) <= 690 + 25 and ADCMenu.Items.useGun:Value() then
		if CanUseSpell(gun) then
			CastSpell(Item_HK[gun],target.pos,715,50)
		end
	end
	if redpot >= 1 and GetDistance(myHero.pos,target.pos) <= 550 + 100 and ADCMenu.Items.useRedPot:Value() then
		if CanUseSpell(redpot) then
			Control.CastSpell(Item_HK[redpot])
		end
	end
	if bluepot >= 1 and GetDistance(myHero.pos,target.pos) <= 550 + 100 and ADCMenu.Items.useBluePot:Value() then
		if CanUseSpell(redpot) then
			Control.CastSpell(Item_HK[bluepot])
		end
	end
end

function Item:ksItem(target)
	local ticker = GetTickCount()
if 	ItemTick + 5000 < ticker then
	Item_HK[ITEM_1] = HK_ITEM_1
	Item_HK[ITEM_2] = HK_ITEM_2
	Item_HK[ITEM_3] = HK_ITEM_3
	Item_HK[ITEM_4] = HK_ITEM_4
	Item_HK[ITEM_5] = HK_ITEM_5
	Item_HK[ITEM_6] = HK_ITEM_6 
	Item_HK[ITEM_7] = HK_ITEM_7 
	CutBlade = GetItemSlot(myHero,3144)
	bork = GetItemSlot(myHero,3153)
	ghost = GetItemSlot(myHero,3142)
	redpot = GetItemSlot(myHero,140)
	bluepot = GetItemSlot(myHero,2139)
	gun = GetItemSlot(myHero,3146)
	ItemTick = ticker
end
	if CutBlade >= 1 and GetDistance(myHero.pos,target.pos) <= 550 + 25 and ADCMenu.Killsteal.ksCut:Value() then
		if CanUseSpell(CutBlade) and CalcMagicalDamage(myHero,target,100) > target.health + target.shieldAD + target.shieldAP then
			CastSpell(Item_HK[CutBlade],target.pos,575,50)
		end	
	elseif bork >= 1 and GetDistance(myHero.pos,target.pos) <= 550 + 25 and CalcPhysicalDamage(myHero,target,target.maxHealth*0.1) > target.health + target.shieldAD and ADCMenu.Killsteal.ksBork:Value() then 
		if CanUseSpell(bork) then
			CastSpell(Item_HK[bork],target.pos,575,50)
		end
	end
	if gun >= 1 and GetDistance(myHero.pos,target.pos) <= 690 + 25 and CalcMagicalDamage(myHero,target,(({[1]=175,[2]=179,[3]=183,[4]=187,[5]=191,[6]=195,[7]=199,[8]=203,[9]=207,[10]=211,[11]=215,[12]=220,[13]=225,[14]=230,[15]=235,[16]=240,[17]=245,[18]=250})[myHero.levelData.lvl]) + myHero.ap*0.3) > target.health + target.shieldAD + target.shieldAP and ADCMenu.Killsteal.ksGun:Value() then
		if CanUseSpell(gun) then
			CastSpell(Item_HK[gun],target.pos,715,50)
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function OnLoad()
	if _G[myHero.charName] then _G[myHero.charName]() Item() end
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local CHANELLING_SPELLS = {
    ["CaitlynAceintheHole"]         = {Name = "Caitlyn",      Spellslot = _R},
    ["Drain"]                       = {Name = "FiddleSticks", Spellslot = _W},
    ["Crowstorm"]                   = {Name = "FiddleSticks", Spellslot = _R},
    ["GalioIdolOfDurand"]           = {Name = "Galio",        Spellslot = _R},
    ["FallenOne"]                   = {Name = "Karthus",      Spellslot = _R},
    ["KatarinaR"]                   = {Name = "Katarina",     Spellslot = _R},
	["Meditate"]         			= {Name = "MasterYi",     Spellslot = _W},
    ["AlZaharNetherGrasp"]          = {Name = "Malzahar",     Spellslot = _R},
    ["MissFortuneBulletTime"]       = {Name = "MissFortune",  Spellslot = _R},
    ["AbsoluteZero"]                = {Name = "Nunu",         Spellslot = _R},                        
    ["Pantheon_GrandSkyfall_Jump"]  = {Name = "Pantheon",     Spellslot = _R},
    ["ShenStandUnited"]             = {Name = "Shen",         Spellslot = _R},
    ["UrgotSwap2"]                  = {Name = "Urgot",        Spellslot = _R},
    ["InfiniteDuress"]              = {Name = "Warwick",      Spellslot = _R} 
}

local GAPCLOSER_SPELLS = {
    ["AkaliShadowDance"]            = {Name = "Akali",      Spellslot = _R},
    ["Headbutt"]                    = {Name = "Alistar",    Spellslot = _W},
    ["DianaTeleport"]               = {Name = "Diana",      Spellslot = _R},
    ["FizzPiercingStrike"]          = {Name = "Fizz",       Spellslot = _Q},
    ["IreliaGatotsu"]               = {Name = "Irelia",     Spellslot = _Q},
    ["JaxLeapStrike"]               = {Name = "Jax",        Spellslot = _Q},
    ["JayceToTheSkies"]             = {Name = "Jayce",      Spellslot = _Q},
    ["blindmonkqtwo"]               = {Name = "LeeSin",     Spellslot = _Q},
    ["MaokaiUnstableGrowth"]        = {Name = "Maokai",     Spellslot = _W},
    -- ["AlphaStrike"]                 = {Name = "MasterYi",   Spellslot = _Q},
    ["MonkeyKingNimbus"]            = {Name = "MonkeyKing", Spellslot = _E},
    ["Pantheon_LeapBash"]           = {Name = "Pantheon",   Spellslot = _W},
    ["PoppyHeroicCharge"]           = {Name = "Poppy",      Spellslot = _E},
    ["QuinnE"]                      = {Name = "Quinn",      Spellslot = _E},
    ["RengarLeap"]                  = {Name = "Rengar",     Spellslot = _R},
    ["XenZhaoSweep"]                = {Name = "XinZhao",    Spellslot = _E}
}

local GAPCLOSER2_SPELLS = {
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

_SPELLS = {
["Aatrox"] = {
	{
	charName = "Aatrox",
	danger = 3,
	name = "AatroxQ",
	projectileSpeed = 450,
	radius = 285,
	range = 650,
	delay = 250,
	Slot = 0,
	spellName = "AatroxQ",
	spellType = "Circular",
	},
	{
	charName = "Aatrox",
	danger = 1,
	name = "Blade of Torment",
	projectileSpeed = 1200,
	radius = 100,
	range = 1075,
	delay = 250,
	Slot = 2,
	spellName = "AatroxE",
	spellType = "Line",
	},
},
--end Aatrox
["Ahri"] = {
	{
	charName = "Ahri",
	danger = 2,
	missileName = "AhriOrbMissile",
	name = "Orb of Deception",
	projectileSpeed = 1750,
	radius = 100,
	range = 925,
	delay = 250,
	Slot = 0,
	spellName = "AhriOrbofDeception",
	spellType = "Line",
	},
	{
	charName = "Ahri",
	danger = 3,
	missileName = "AhriSeduceMissile",
	name = "Charm",
	projectileSpeed = 1550,
	radius = 60,
	range = 1000,
	delay = 250,
	Slot = 2,
	spellName = "AhriSeduce",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "Ahri",
	danger = 3,
	name = "Orb of Deception Back",
	projectileSpeed = 915,
	radius = 100,
	range = 925,
	delay = 250,
	Slot = 0,
	spellName = "AhriOrbofDeception2",
	spellType = "Line",
	},
},
--end Ahri
["Alistar"] = {
	{
	charName = "Alistar",
	defaultOff = true,
	danger = 3,
	name = "Pulverize",
	radius = 365,
	range = 365,
	Slot = 0,
	spellName = "Pulverize",
	spellType = "Circular",
	},
},
--end Alistar
["Amumu"] = {
	{
	charName = "Amumu",
	danger = 4,
	name = "CurseoftheSadMummy",
	radius = 560,
	range = 560,
	delay = 250,
	Slot = 3,
	spellName = "CurseoftheSadMummy",
	spellType = "Circular",
	},
	{
	charName = "Amumu",
	danger = 3,
	missileName = "SadMummyBandageToss",
	name = "Bandage Toss",
	projectileSpeed = 2000,
	radius = 80,
	range = 1100,
	delay = 250,
	Slot = 0,
	spellName = "BandageToss",
	spellType = "Line",
	collision = true,
	},
},
--end Amumu
["Anivia"] = {
	{
	charName = "Anivia",
	danger = 3,
	missileName = "FlashFrostSpell",
	name = "Flash Frost",
	projectileSpeed = 850,
	radius = 110,
	range = 1250,
	delay = 250,
	Slot = 0,
	spellName = "FlashFrostSpell",
	spellType = "Line",
	},
},
--end Anivia
["Annie"] = {
	{
	angle = 25,
	charName = "Annie",
	danger = 2,
	name = "Incinerate",
	radius = 80,
	range = 625,
	delay = 250,
	Slot = 2,
	spellName = "Incinerate",
	spellType = "Cone",
	},
	{
	charName = "Annie",
	danger = 4,
	name = "InfernalGuardian",
	radius = 290,
	range = 600,
	delay = 250,
	Slot = 3,
	spellName = "InfernalGuardian",
	spellType = "Circular",
	},
},
--end Annie
["Ashe"] = {
	{
	charName = "Ashe",
	danger = 3,
	name = "Enchanted Arrow",
	projectileSpeed = 1600,
	radius = 130,
	range = 25000,
	delay = 250,
	Slot = 3,
	spellName = "EnchantedCrystalArrow",
	spellType = "Line",
	},
	{
	angle = 5,
	charName = "Ashe",
	danger = 2,
	missileName = "VolleyAttack",
	name = "Volley",
	projectileSpeed = 1500,
	radius = 20,
	range = 1200,
	delay = 250,
	Slot = 1,
	spellName = "Volley",
	spellType = "Line",
	isSpecial = true,
	collision = true,
	},
},
--end Ashe
["Azir"] = {
	{
	charName = "Azir",
	danger = 2,
	name = "AzirQ",
	projectileSpeed = 1000,
	radius = 80,
	range = 800,
	delay = 250,
	Slot = 0,
	spellName = "AzirQ",
	spellType = "Line",

	isSpecial = true,
	},
},
--end Azir
["Bard"] = {
	{
	charName = "Bard",
	danger = 2,
	name = "BardQ",
	missileName = "BardQMissile",
	projectileSpeed = 1600,
	radius = 60,
	range = 950,
	delay = 250,
	Slot = 0,
	spellName = "BardQ",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "Bard",
	danger = 2,
	name = "BardR",
	missileName = "BardR",
	projectileSpeed = 2100,
	radius = 350,
	range = 3400,
	delay = 250,
	Slot = 3,
	spellName = "BardR",
	spellType = "Circular",
	},
},
--end Bard
["Blitzcrank"] = {
	{
	charName = "Blitzcrank",
	danger = 3,
	extraDelay = 75,
	missileName = "RocketGrabMissile",
	name = "Rocket Grab",
	projectileSpeed = 1800,
	radius = 70,
	range = 1050,
	delay = 250,
	Slot = 0,
	spellName = "RocketGrab",
	spellType = "Line",
	collision = true,
	},
},
--end Blitzcrank
["Brand"] = {
	{
	charName = "Brand",
	danger = 3,
	missileName = "BrandBlazeMissile",
	name = "BrandBlaze",
	projectileSpeed = 2000,
	radius = 60,
	range = 1100,
	delay = 250,
	Slot = 0,
	spellName = "BrandBlaze",
	spellType = "Line",
	collision = true,              
	},
	{
	charName = "Brand",
	danger = 2,
	name = "Pillar of Flame",
	radius = 250,
	range = 1100,
	delay = 850,
	Slot = 1,
	spellName = "BrandFissure",
	spellType = "Circular",
	},
},
--end Brand
["Braum"] = {
	{
	charName = "Braum",
	danger = 4,
	name = "GlacialFissure",
	projectileSpeed = 1125,
	radius = 100,
	range = 1250,
	delay = 500,
	Slot = 3,
	spellName = "BraumRWrapper",
	spellType = "Line",
	},
	{
	charName = "Braum",
	danger = 3,
	missileName = "BraumQMissile",
	name = "BraumQ",
	projectileSpeed = 1200,
	delay = 250,   
	radius = 100,
	range = 1000,             
	Slot = 0,
	spellName = "BraumQ",
	spellType = "Line",
	collision = true,
	},
},
--end Braum
["Caitlyn"] = {
	{
	charName = "Caitlyn",
	danger = 2,
	name = "Piltover Peacemaker",
	projectileSpeed = 2200,
	radius = 90,
	range = 1300,
	delay = 625,
	Slot = 0,
	spellName = "CaitlynPiltoverPeacemaker",
	spellType = "Line",
	},
	{
	charName = "Caitlyn",
	danger = 2,
	missileName = "CaitlynEntrapmentMissile",
	name = "Caitlyn Entrapment",
	projectileSpeed = 2000,
	radius = 80,
	range = 950,
	delay = 125,
	Slot = 2,
	spellName = "CaitlynEntrapment",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "Caitlyn",
	danger = 4,
	missileName = "CaitlynAceintheHoleMissile",
	name = "Ace in the Hole",
	projectileSpeed = 2000,
	radius = 75,
	range = 3500,
	delay = 1000,
	Slot = 3,
	spellName = "CaitlynAceintheHole",
	spellType = "Line",
	collision = false,
	},
},
--end Caitlyn
["Cassiopeia"] = {
	{
	angle = 40,
	charName = "Cassiopeia",
	danger = 4,
	name = "CassiopeiaPetrifyingGaze",
	radius = 20,
	range = 825,
	delay = 500,
	Slot = 3,
	spellName = "CassiopeiaPetrifyingGaze",
	spellType = "Cone",
	},
	{
	charName = "Cassiopeia",
	danger = 1,
	name = "CassiopeiaNoxiousBlast",
	radius = 200,
	range = 600,
	delay = 825,
	Slot = 0,
	spellName = "CassiopeiaNoxiousBlast",
	spellType = "Circular",
	},
	{
	charName = "Cassiopeia",
	danger = 1,
	name = "CassiopeiaMiasma",
	radius = 220,
	range = 850,
	delay = 250,
	projectileSpeed = 2500,
	Slot = 1,
	spellName = "CassiopeiaMiasma",
	spellType = "Circular",
	},
},
--end Cassiopeia
["Chogath"] = {
	{
	angle = 30,
	charName = "Chogath",
	danger = 2,
	name = "FeralScream",
	radius = 20,
	range = 650,
	delay = 250,
	Slot = 1,
	spellName = "FeralScream",
	spellType = "Cone",
	},
	{
	charName = "Chogath",
	danger = 3,
	name = "Rupture",
	radius = 250,
	range = 950,
	delay = 1200,
	Slot = 0,
	spellName = "Rupture",
	spellType = "Circular",
	extraDrawHeight = 45,
	},
},
--end Chogath
["Corki"] = {
	{
	charName = "Corki",
	danger = 1,
	missileName = "MissileBarrageMissile2",
	name = "Missile Barrage big",
	projectileSpeed = 2000,
	radius = 40,
	range = 1500,
	delay = 175,
	Slot = 3,
	spellName = "MissileBarrage2",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "Corki",
	danger = 2,
	missileName = "PhosphorusBombMissile",
	name = "Phosphorus Bomb",
	projectileSpeed = 1125,
	radius = 270,
	range = 825,
	delay = 500,
	Slot = 0,
	spellName = "PhosphorusBomb",
	spellType = "Circular",
	extraDrawHeight = 110,
	},
	{
	charName = "Corki",
	danger = 1,
	missileName = "MissileBarrageMissile",
	name = "Missile Barrage",
	projectileSpeed = 2000,
	radius = 40,
	range = 1300,
	delay = 175,
	Slot = 3,
	spellName = "MissileBarrage",
	spellType = "Line",
	collision = true,
	},
},
--end Corki
["Darius"] = {
	{
	angle = 25,
	charName = "Darius",
	danger = 3,
	name = "DariusAxeGrabCone",
	radius = 20,
	range = 570,
	delay = 320,
	Slot = 2,
	spellName = "DariusAxeGrabCone",
	spellType = "Cone",
	},
},
--end Darius
["Diana"] = {
	{
	charName = "Diana",
	danger = 3,
	name = "DianaArc",
	projectileSpeed = 1400,
	radius = 50,
	range = 850,
	fixedRange = true,
	delay = 250,
	Slot = 0,
	spellName = "DianaArc",
	spellType = "Line",
	hasEndExplosion = true,
	secondaryRadius = 195,
	extraEndTime = 250,
	},
},
--end Diana
["DrMundo"] = {
	{
	charName = "DrMundo",
	danger = 1,
	missileName = "InfectedCleaverMissile",
	name = "Infected Cleaver",
	projectileSpeed = 2000,
	radius = 60,
	range = 1050,
	delay = 250,
	Slot = 0,
	spellName = "InfectedCleaverMissileCast",
	spellType = "Line",
	collision = true,
	},
},
--end DrMundo
["Draven"] = {
	{
	charName = "Draven",
	danger = 3,
	missileName = "DravenR",
	name = "DravenR",
	projectileSpeed = 2000,
	radius = 160,
	range = 25000,
	delay = 500,
	Slot = 3,
	spellName = "DravenRCast",
	spellType = "Line",
	},
	{
	charName = "Draven",
	danger = 2,
	missileName = "DravenDoubleShotMissile",
	name = "Stand Aside",
	projectileSpeed = 1400,
	radius = 130,
	range = 1100,
	delay = 250,
	Slot = 2,
	spellName = "DravenDoubleShot",
	spellType = "Line",
	},
},
--end Draven
["Ekko"] = {
	{
	charName = "Ekko",
	danger = 3,
	name = "EkkoQ",
	missileName = "EkkoQMis",
	projectileSpeed = 1650,
	radius = 60,
	range = 950,
	delay = 250,
	Slot = 0,
	spellName = "EkkoQ",
	spellType = "Line",
	},
	{
	charName = "Ekko",
	danger = 3,
	name = "EkkoW",
	radius = 375,
	range = 1600,
	delay = 3750,
	Slot = 1,
	spellName = "EkkoW",
	spellType = "Circular",
	},
	{
	charName = "Ekko",
	danger = 3,
	name = "EkkoR",
	radius = 375,
	range = 1600,
	delay = 250,
	Slot = 3,
	spellName = "EkkoR",
	spellType = "Circular",
	isSpecial = true,
	},
},
--end Ekko
["Elise"] = {
	{
	charName = "Elise",
	danger = 3,
	name = "Cocoon",
	projectileSpeed = 1600,
	radius = 70,
	range = 1100,
	delay = 250,
	Slot = 2,
	spellName = "EliseHumanE",
	spellType = "Line",
	collision = true,
	},
},
--end Elise
["Evelynn"] = {
	{
	charName = "Evelynn",
	danger = 3,
	name = "EvelynnR",
	radius = 350,
	range = 650,
	delay = 250,
	Slot = 3,
	spellName = "EvelynnR",
	spellType = "Circular",
	},
},
--end Evelynn
["Ezreal"] = {
	{
	charName = "Ezreal",
	danger = 2,
	missileName = "EzrealMysticShotMissile",
	name = "Mystic Shot",
	projectileSpeed = 2000,
	radius = 60,
	range = 1200,
	delay = 250,
	Slot = 0,
	spellName = "EzrealMysticShot",
	extraSpellNames = "ezrealmysticshotwrapper",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "Ezreal",
	danger = 2,
	name = "Trueshot Barrage",
	projectileSpeed = 2000,
	radius = 160,
	range = 20000,
	delay = 1000,
	Slot = 3,
	spellName = "EzrealTrueshotBarrage",
	missileName = "EzrealTrueshotBarrageMissile",
	spellType = "Line",
	},
	{
	charName = "Ezreal",
	danger = 1,
	missileName = "EzrealEssenceFluxMissile",
	name = "Essence Flux",
	projectileSpeed = 1600,
	radius = 80,
	range = 1050,
	delay = 250,
	Slot = 1,
	spellName = "EzrealEssenceFlux",
	spellType = "Line",
	},
},
--end Ezreal
["Fiora"] = {
	{
	charName = "Fiora",
	danger = 1,
	missileName = "FioraWMissile",
	name = "FioraW",
	projectileSpeed = 3200,
	radius = 70,
	range = 750,
	delay = 500,
	Slot = 1,
	spellName = "FioraW",
	spellType = "Line",
	},
},
--end Fiora
["Fizz"] = {
	{
	charName = "Fizz",
	danger = 2,
	name = "FizzPiercingStrike",
	projectileSpeed = 1400,
	radius = 150,
	range = 550,
	delay = 0,
	Slot = 0,
	spellName = "FizzPiercingStrike",
	spellType = "Line",
	isSpecial = true,
	},
	{
	charName = "Fizz",
	danger = 3,
	missileName = "FizzMarinerDoomMissile",
	name = "Fizz ULT",
	projectileSpeed = 1350,
	radius = 120,
	range = 1275,
	delay = 250,
	Slot = 3,
	spellName = "FizzMarinerDoom",
	spellType = "Line",
	hasEndExplosion = true,
	secondaryRadius = 250,
	useEndPosition = true,
	extraEndTime = 1000,
	},
},
--end Fizz
["Galio"] = {
	{
	charName = "Galio",
	danger = 2,
	missileName = "GalioRighteousGustMissile",
	name = "GalioRighteousGust",
	projectileSpeed = 1300,
	radius = 160,
	range = 1280,
	Slot = 2,
	spellName = "GalioRighteousGust",
	spellType = "Line",
	},
	{
	charName = "Galio",
	danger = 2,
	name = "GalioResoluteSmite",
	missileName = "GalioResoluteSmite",
	projectileSpeed = 1200,
	radius = 235,
	range = 1040,
	delay = 250,
	Slot = 0,
	spellName = "GalioResoluteSmite",
	spellType = "Circular",
	},
	{
	charName = "Galio",
	danger = 4,
	name = "GalioIdolOfDurand",
	radius = 600,
	range = 600,
	Slot = 3,
	spellName = "GalioIdolOfDurand",
	spellType = "Circular",
	},
},
--end Galio
["Gnar"] = {
	{
	charName = "Gnar",
	danger = 2,
	name = "Boulder Toss",
	missileName = "GnarBigQMissile",
	projectileSpeed = 2000,
	radius = 90,
	range = 1150,
	delay = 500,
	Slot = 0,
	spellName = "GnarBigQ",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "Gnar",
	danger = 3,
	name = "GnarUlt",
	radius = 500,
	range = 500,
	delay = 250,
	Slot = 3,
	spellName = "GnarR",
	spellType = "Circular",
	},
	{
	charName = "Gnar",
	danger = 3,
	name = "Wallop",
	projectileSpeed = math.huge,
	radius = 100,
	range = 600,
	delay = 600,
	Slot = 1,
	spellName = "GnarBigW",
	spellType = "Line",
	},
	{
	charName = "Gnar",
	danger = 2,
	name = "Boomerang Throw",
	missileName = "GnarQMissile",
	extraMissileNames = "GnarQMissileReturn",
	projectileSpeed = 2400,
	radius = 60,
	range = 1185,
	delay = 250,
	Slot = 0,
	spellName = "GnarQ",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "Gnar",
	danger = 2,
	name = "GnarE",
	spellName = "GnarE",
	range = 475,
	delay = 0,
	radius = 150,
	fixedRange = true,
	projectileSpeed = 900,
	Slot = 2,
	spellType = "Circular",
	},
	{
	charName = "Gnar",
	danger = 2,
	name = "GnarBigE",
	spellName = "gnarbige",
	range = 475,
	delay = 0,
	radius = 100,
	fixedRange = true,
	projectileSpeed = 800,
	Slot = 2,
	spellType = "Circular",
	},
},
--end Gnar
["Gragas"] = {
	{
	charName = "Gragas",
	danger = 2,
	name = "Barrel Roll",
	projectileSpeed = 1000,
	radius = 250,
	range = 975,
	delay = 500,
	Slot = 0,
	spellName = "GragasQ",
	spellType = "Circular",
	},
	{
	charName = "Gragas",
	danger = 3,
	name = "Barrel Roll",
	projectileSpeed = 1200,
	radius = 200,
	range = 950,
	delay = 0,
	Slot = 2,
	spellName = "GragasE",
	spellType = "Line",
	},
	{
	charName = "Gragas",
	danger = 4,
	name = "GragasExplosiveCask",
	projectileSpeed = 1750,
	radius = 350,
	range = 1050,
	delay = 250,
	Slot = 3,
	spellName = "GragasR",
	spellType = "Circular",
	},
},
--end Gragas
["Graves"] = {
	{
	charName = "Graves",
	danger = 2,
	missileName = "GravesQLineMis",
	extraMissileNames = "GravesQReturn",
	name = "Buckshot",
	projectileSpeed = 3000,
	radius = 60,
	range = 825,
	delay = 250,
	Slot = 0,
	spellName = "GravesQLineSpell",
	spellType = "Line",
	},
	{
	charName = "Graves",
	danger = 3,
	missileName = "GravesChargeShotShot",
	name = "Collateral Damage",
	projectileSpeed = 2100,
	radius = 100,
	range = 1000,
	delay = 250,
	Slot = 3,
	spellName = "GravesChargeShot",
	spellType = "Line",
	},
},
--end Graves
["Hecarim"] = {
	{
	charName = "Hecarim",
	danger = 4,
	name = "HecarimR",
	missileName = "hecarimultmissile",
	projectileSpeed = 1100,
	radius = 300,
	range = 1500,
	delay = 10,
	Slot = 3,
	spellName = "HecarimUlt",
	spellType = "Line",
	},
},
--end Hecarim
["Heimerdinger"] = {
	{
	charName = "Heimerdinger",
	danger = 2,
	missileName = "HeimerdingerESpell",
	name = "HeimerdingerE",
	projectileSpeed = 1750,
	radius = 135,
	range = 925,
	delay = 325,
	Slot = 2,
	spellName = "HeimerdingerE",
	spellType = "Circular",
	},
	{
	charName = "Heimerdinger",
	danger = 2,
	name = "HeimerdingerW",
	missileName = "HeimerdingerWAttack2",
	projectileSpeed = 2500,
	radius = 35,
	range = 1350,
	fixedRange = true,
	delay = 250,
	Slot = 1,
	spellName = "HeimerdingerW",
	spellType = "Line",
	defaultOff = true,
	},
	{
	charName = "Heimerdinger",
	danger = 2,
	name = "Turret Energy Blast",
	projectileSpeed = 1650,
	radius = 50,
	range = 1000,
	delay = 435,
	Slot = 0,
	spellName = "HeimerdingerTurretEnergyBlast",
	spellType = "Line",
	isSpecial = true,
	},
	{
	charName = "Heimerdinger",
	danger = 3,
	name = "Turret Energy Blast",
	projectileSpeed = 1650,
	radius = 75,
	range = 1000,
	delay = 350,
	Slot = 0,
	spellName = "HeimerdingerTurretBigEnergyBlast",
	spellType = "Line",
	},
},
--end Heimerdinger
["Illaoi"] = {
	{
	charName = "Illaoi",
	danger = 3,
	name = "IllaoiQ",
	radius = 100,
	range = 850,
	delay = 750,
	Slot = 0,
	spellName = "IllaoiQ",
	spellType = "Line",
	},
	{
	charName = "Illaoi",
	danger = 3,
	missileName = "Illaoiemis",
	name = "IllaoiE",
	projectileSpeed = 1900,
	radius = 50,
	range = 950,
	delay = 250,
	Slot = 2,
	spellName = "IllaoiE",
	spellType = "Line",
	},
	{
	charName = "Illaoi",
	danger = 3,
	name = "IllaoiR",
	range = 0,
	radius = 450,
	delay = 500,
	Slot = 3,
	spellName = "IllaoiR",
	spellType = "Circular",
	},
},
--end Illaoi
["Irelia"] = {
	{
	charName = "Irelia",
	danger = 2,
	missileName = "ireliatranscendentbladesspell",
	name = "IreliaTranscendentBlades",
	projectileSpeed = 1600,
	radius = 120,
	range = 1200,
	Slot = 3,
	delay = 0,
	spellName = "IreliaTranscendentBlades",
	spellType = "Line",

	defaultOff = true,
	},
},
--end Irelia
["Janna"] ={
	{
	charName = "Janna",
	danger = 2,
	missileName = "HowlingGaleSpell",
	name = "HowlingGaleSpell",
	projectileSpeed = 900,
	radius = 120,
	range = 1700,
	Slot = 0,
	spellName = "HowlingGale",
	spellType = "Line",

	},
},
--end Janna
["JarvanIV"] = {
	{
	charName = "JarvanIV",
	danger = 2,
	name = "JarvanIVDragonStrike",
	projectileSpeed = 2000,
	radius = 80,
	range = 845,
	delay = 250,
	Slot = 0,
	spellName = "JarvanIVDragonStrike",
	spellType = "Line",
	},
	{
	charName = "JarvanIV",
	danger = 2,
	name = "JarvanIVDragonStrike",
	projectileSpeed = 1800,
	radius = 120,
	range = 845,
	delay = 250,
	Slot = 0,
	spellName = "JarvanIVDragonStrike2",
	spellType = "Line",
	useEndPosition = true,
	},
	{
	charName = "JarvanIV",
	danger = 3,
	name = "JarvanIVCataclysm",
	projectileSpeed = 1900,
	radius = 350,
	range = 825,
	delay = 0,
	Slot = 3,
	spellName = "JarvanIVCataclysm",
	spellType = "Circular",
	},
},
--end JarvanIV
["Jayce"] = {
	{
	charName = "Jayce",
	danger = 3,
	missileName = "JayceShockBlastMis",
	name = "JayceShockBlastCharged",
	projectileSpeed = 2350,
	radius = 70,
	range = 1570,
	delay = 250,
	Slot = 0,
	spellName = "JayceShockBlast",
	spellType = "Line",
	collision = true,
	hasEndExplosion = true,
	secondaryRadius = 250,
	},
	{
	charName = "Jayce",
	danger = 2,
	missileName = "JayceShockBlastMis",
	name = "JayceShockBlast",
	projectileSpeed = 1450,
	radius = 70,
	range = 1050,
	delay = 250,
	Slot = 0,
	spellName = "jayceshockblast",
	spellType = "Line",
	collision = true,
	hasEndExplosion = true,
	secondaryRadius = 175,
	},
},
--end Jayce
["Jinx"] = {
	{
	charName = "Jinx",
	danger = 3,
	name = "JinxR",
	projectileSpeed = 2000,
	radius = 140,
	range = 25000,
	delay = 600,
	Slot = 3,
	spellName = "JinxR",
	spellType = "Line",
	},
	{
	charName = "Jinx",
	danger = 3,
	missileName = "JinxWMissile",
	name = "Zap",
	projectileSpeed = 3300,
	radius = 60,
	range = 1500,
	delay = 600,
	Slot = 1,
	spellName = "JinxWMissile",
	spellType = "Line",
	collision = true,
	},
},
--end Jinx
["Jhin"] = {
	{
	charName = "Jhin",
	danger = 3,
	missileName = "JhinWMissile",
	name = "JhinW",
	projectileSpeed = 5000,
	radius = 40,
	range = 2250,
	delay = 750,
	Slot = 1,
	spellName = "JhinW",
	spellType = "Line",
	fixedRange = true,
	},
	{
	charName = "Jhin",
	danger = 2,
	missileName = "JhinRShotMis",
	name = "JhinR",
	projectileSpeed = 5000,
	radius = 80,
	range = 3500,
	delay = 250,
	Slot = 3,
	spellName = "JhinRShot",
	extraSpellNames = "JhinRShotFinal",
	spellType = "Line",
	fixedRange = true,
	extraMissileNames = "JhinRShotMis4",
	},
},
--end
["Kalista"] = {
	{
	charName = "Kalista",
	danger = 2,
	missileName = "kalistamysticshotmistrue",
	name = "KalistaQ",
	projectileSpeed = 2000,
	radius = 70,
	range = 1200,
	delay = 350,
	Slot = 0,
	spellName = "KalistaMysticShot",
	spellType = "Line",
	collision = true,
	},
},
--end Kalista
["Karma"] = {
	{
	charName = "Karma",
	danger = 2,
	missileName = "KarmaQMissile",
	name = "KarmaQ",
	projectileSpeed = 1700,
	radius = 90,
	range = 1050,
	delay = 250,
	Slot = 0,
	spellName = "KarmaQ",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "Karma",
	danger = 2,
	missileName = "KarmaQMissileMantra",
	name = "KarmaQMantra",
	projectileSpeed = 1700,
	radius = 90,
	range = 1050,
	delay = 250,
	Slot = 0,
	spellName = "KarmaQMissileMantra",
	spellType = "Line",

	collision = true,
	},
},
--end Karma
["Karthus"] = {
	{
	charName = "Karthus",
	danger = 1,
	name = "Lay Waste",
	radius = 190,
	range = 875,
	delay = 900,
	Slot = 0,
	spellName = "KarthusLayWaste",
	spellType = "Circular",
	extraSpellNames = {"karthuslaywastea2", "karthuslaywastea3", "karthuslaywastedeada1", "karthuslaywastedeada2", "karthuslaywastedeada3"},	--tostring
	},
},
--end Karthus
["Kassadin"] = {
	{
	charName = "Kassadin",
	danger = 1,
	name = "RiftWalk",
	radius = 270,
	range = 700,
	delay = 250,
	Slot = 3,
	spellName = "RiftWalk",
	spellType = "Circular",
	},
	{
	angle = 40,
	charName = "Kassadin",
	danger = 2,
	name = "ForcePulse",
	radius = 20,
	range = 700,
	delay = 250,
	Slot = 2,
	spellName = "ForcePulse",
	spellType = "Cone",
	},
},
--end Kassadin
["Kennen"] = {
	{
	charName = "Kennen",
	danger = 2,
	missileName = "KennenShurikenHurlMissile1",
	name = "Thundering Shuriken",
	projectileSpeed = 1700,
	radius = 50,
	range = 1175,
	delay = 180,
	Slot = 0,
	spellName = "KennenShurikenHurlMissile1",
	spellType = "Line",
	collision = true,
	},
},
--end Kennen
["Khazix"] = { 
	{
	charName = "Khazix",
	danger = 1,
	missileName = "KhazixWMissile",
	name = "KhazixW",
	projectileSpeed = 1700,
	radius = 70,
	range = 1100,
	delay = 250,
	Slot = 1,
	spellName = "KhazixW",
	spellType = "Line",
	collision = true,
	},
	{
	angle = 22,
	charName = "Khazix",
	danger = 1,
	isThreeWay = true,
	name = "KhazixWLong",
	projectileSpeed = 1700,
	radius = 70,
	range = 1025,
	delay = 250,
	Slot = 1,
	spellName = "KhazixWLong",
	spellType = "Line",
	collision = true,
	},
},
--end Khazix
["KogMaw"] = {
	{
	charName = "KogMaw",
	danger = 2,
	name = "Caustic Spittle",
	missileName = "KogMawQ",
	projectileSpeed = 1650,
	radius = 70,
	range = 1125,
	delay = 250,
	Slot = 0,
	spellName = "KogMawQ",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "KogMaw",
	danger = 1,
	name = "KogMawVoidOoze",
	missileName = "KogMawVoidOozeMissile",
	projectileSpeed = 1400,
	radius = 120,
	range = 1360,
	delay = 250,
	Slot = 2,
	spellName = "KogMawVoidOoze",
	spellType = "Line",
	},
	{
	charName = "KogMaw",
	danger = 2,
	name = "Living Artillery",
	radius = 235,
	range = 2200,
	delay = 1100,
	Slot = 3,
	spellName = "KogMawLivingArtillery",
	spellType = "Circular",
	},
},
--end KogMaw
["Leblanc"] = {
	{
	charName = "Leblanc",
	danger = 2,
	name = "Ethereal Chains R",
	missileName = "LeblancSoulShackleM",
	projectileSpeed = 1750,
	radius = 55,
	range = 960,
	delay = 250,
	Slot = 3,
	spellName = "LeblancSoulShackleM",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "Leblanc",
	danger = 2,
	name = "Ethereal Chains",
	missileName = "LeblancSoulShackle",
	projectileSpeed = 1750,
	radius = 55,
	range = 960,
	delay = 250,
	Slot = 2,
	spellName = "LeblancSoulShackle",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "Leblanc",
	danger = 1,
	name = "LeblancSlideM",
	projectileSpeed = 1450,
	radius = 250,
	range = 725,
	delay = 250,
	Slot = 3,
	spellName = "LeblancSlideM",
	spellType = "Circular",
	},
	{
	charName = "Leblanc",
	danger = 1,
	name = "LeblancSlide",
	projectileSpeed = 1450,
	radius = 250,
	range = 725,
	delay = 250,
	Slot = 1,
	spellName = "LeblancSlide",
	spellType = "Circular",
	},
},
--end Leblanc
["LeeSin"] = {
	{
	charName = "LeeSin",
	danger = 3,
	name = "Sonic Wave",
	projectileSpeed = 1800,
	radius = 60,
	range = 1100,
	delay = 250,
	Slot = 0,
	spellName = "BlindMonkQOne",
	spellType = "Line",
	collision = true,
	},
	--end LeeSin
},
["Leona"] = {
	{
	charName = "Leona",
	danger = 4,
	name = "Leona Solar Flare",
	radius = 300,
	range = 1200,
	delay = 1000,
	Slot = 3,
	spellName = "LeonaSolarFlare",
	spellType = "Circular",
	},
	{
	charName = "Leona",
	danger = 3,
	extraDistance = 65,
	missileName = "LeonaZenithBladeMissile",
	name = "Zenith Blade",
	projectileSpeed = 2000,
	radius = 70,
	range = 975,
	delay = 200,
	Slot = 2,
	spellName = "LeonaZenithBlade",
	spellType = "Line",
	},
},
--end Leona
["Lissandra"] = {
	{
	charName = "Lissandra",
	danger = 3,
	name = "LissandraW",
	projectileSpeed = math.huge,
	radius = 450,
	range = 725,
	delay = 250,
	Slot = 1,
	spellName = "LissandraW",
	spellType = "Circular",
	},
	{
	charName = "Lissandra",
	danger = 2,
	name = "Ice Shard",
	projectileSpeed = 2250,
	radius = 75,
	range = 825,
	delay = 250,
	Slot = 0,
	spellName = "LissandraQ",
	spellType = "Line",
	},
},
--end Lissandra
["Lucian"] = {
	{
	charName = "Lucian",
	danger = 1,
	defaultOff = true,
	name = "LucianW",
	projectileSpeed = 1600,
	radius = 80,
	range = 1000,
	delay = 300,
	Slot = 1,
	spellName = "LucianW",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "Lucian",
	danger = 2,
	defaultOff = true,
	isSpecial = true,
	name = "LucianQ",
	projectileSpeed = math.huge,
	radius = 65,
	range = 1140,
	delay = 350,
	Slot = 0,
	spellName = "LucianQ",
	spellType = "Line",
	},
},
--end Lucian
["Lulu"] = {
	{
	charName = "Lulu",
	danger = 2,
	missileName = "LuluQMissile",
	extraMissileNames = "LuluQMissileTwo",
	name = "LuluQ",
	projectileSpeed = 1450,
	radius = 80,
	range = 925,
	delay = 250,
	Slot = 0,
	spellName = "LuluQ",
	extraSpellNames = "LuluQMissile",
	spellType = "Line",
	isSpecial = true,
	},
},
--end Lulu
["Lux"] = {
	{
	charName = "Lux",
	danger = 2,
	name = "LuxLightStrikeKugel",
	projectileSpeed = 1400,
	radius = 340,
	range = 1100,
	extraEndTime = 1000,
	delay = 250,
	Slot = 2,
	spellName = "LuxLightStrikeKugel",
	spellType = "Circular",
	},
	{
	charName = "Lux",
	danger = 3,
	name = "Lux Malice Cannon",
	projectileSpeed = math.huge,
	radius = 110,
	range = 3500,
	delay = 1000,
	Slot = 3,
	spellName = "LuxMaliceCannon",
	spellType = "Line",
	},
	{
	charName = "Lux",
	danger = 3,
	missileName = "LuxLightBindingMis",
	name = "Light Binding",
	projectileSpeed = 1200,                
	radius = 70,
	range = 1300,
	delay = 250,
	Slot = 0,
	spellName = "LuxLightBinding",
	spellType = "Line",
	collision = true,
	},
},
--end Lux
["Malphite"] = {
	{
	charName = "Malphite",
	danger = 4,
	name = "UFSlash",
	projectileSpeed = 2000,
	radius = 300,
	range = 1000,
	delay = 0,
	Slot = 3,
	spellName = "UFSlash",
	spellType = "Circular",
	},
},
--end Malphite
["Malzahar"] = {
	{
	charName = "Malzahar",
	danger = 2,
	extraEndTime = 750,
	defaultOff = true,
	isSpecial = true,
	isWall = true,
	missileName = "AlZaharCalloftheVoidMissile",
	name = "AlZaharCalloftheVoid",
	projectileSpeed = 1600,
	radius = 85,
	range = 900,
	sideRadius = 400,
	delay = 1000,
	Slot = 0,
	spellName = "AlZaharCalloftheVoid",
	spellType = "Line",
	},
},
--end Malzahar
["MonkeyKing"] = {
	{
	charName = "MonkeyKing",
	danger = 3,
	name = "MonkeyKingSpinToWin",
	radius = 225,
	range = 300,
	delay = 250,
	Slot = 3,
	spellName = "MonkeyKingSpinToWin",
	spellType = "Circular",
	defaultOff = true,
	},
},
--end MonkeyKing
["Morgana"] = {
	{
	charName = "Morgana",
	danger = 3,
	name = "Dark Binding",
	missileName = "DarkBindingMissile",
	projectileSpeed = 1200,
	radius = 80,
	range = 1300,
	delay = 250,
	Slot = 0,
	spellName = "DarkBindingMissile",
	spellType = "Line",
	collision = true,
	},
},
--end Morgana
["Nami"] = {
	{
	charName = "Nami",
	danger = 3,
	name = "NamiQ",
	radius = 200,
	range = 875,
	delay = 1000,
	Slot = 0,
	spellName = "NamiQ",
	spellType = "Circular",
	},
	{
	charName = "Nami",
	danger = 4,
	missileName = "NamiRMissile",
	name = "NamiR",
	projectileSpeed = 850,
	radius = 250,
	range = 2750,
	delay = 500,
	Slot = 3,
	spellName = "NamiR",
	spellType = "Line",
	},
},
--end Nami
["Nautilus"] = {
	{
	charName = "Nautilus",
	danger = 3,
	missileName = "NautilusAnchorDragMissile",
	name = "Dredge Line",
	projectileSpeed = 2000,
	radius = 90,
	range = 1250,
	delay = 250,
	Slot = 0,
	spellName = "NautilusAnchorDrag",
	spellType = "Line",
	collision = true,
	},
},
--end Nautilus
["Nidalee"] = {
	{
	charName = "Nidalee",
	danger = 2,
	name = "Javelin Toss",
	projectileSpeed = 1300,
	radius = 60,
	range = 1500,
	delay = 250,
	Slot = 0,
	spellName = "JavelinToss",
	spellType = "Line",
	collision = true,
	},
},
--end Nidalee
["Nocturne"] = {
	{
	charName = "Nocturne",
	danger = 1,
	name = "NocturneDuskbringer",
	projectileSpeed = 1400,
	radius = 60,
	range = 1125,
	delay = 250,
	Slot = 0,
	spellName = "NocturneDuskbringer",
	spellType = "Line",
	},
},
--end Nocturne
["Olaf"] = {
	{
	charName = "Olaf",
	danger = 1,
	name = "Undertow",
	projectileSpeed = 1600,
	radius = 90,
	range = 1000,
	delay = 250,
	Slot = 0,
	spellName = "OlafAxeThrowCast",
	spellType = "Line",
	},
},
--end Olaf
["Orianna"] = {
	{
	charName = "Orianna",
	danger = 2,
	hasEndExplosion = true,
	name = "OrianaIzunaCommand",
	projectileSpeed = 1200,
	radius = 80,
	secondaryRadius = 170,
	range = 2000,
	delay = 0,
	Slot = 0,
	spellName = "OrianaIzunaCommand",
	spellType = "Line",
	isSpecial = true,
	useEndPosition = true,
	},
	{
	charName = "Orianna",
	danger = 4,
	name = "OrianaDetonateCommand",
	radius = 410,
	range = 410,
	delay = 500,
	Slot = 3,
	spellName = "OrianaDetonateCommand",
	spellType = "Circular",
	},
	{
	charName = "Orianna",
	danger = 2,
	name = "OrianaDissonanceCommand",
	radius = 250,
	range = 1825,
	Slot = 1,
	spellName = "OrianaDissonanceCommand",
	spellType = "Circular",
	},
},
--end Orianna
["Pantheon"] = {
	{
	angle = 35,
	charName = "Pantheon",
	danger = 2,
	name = "Heartseeker",
	radius = 100,
	range = 650,
	delay = 1000,
	Slot = 2,
	spellName = "PantheonE",
	spellType = "Cone",
	},
},
--end Pantheon
["Poppy"] = {
	{
	charName = "Poppy",
	danger = 2,
	name = "Hammer Shock",
	radius = 100,
	range = 450,
	delay = 500,
	Slot = 0,
	spellName = "PoppyQ",
	spellType = "Line",
	},
	{
	charName = "Poppy",
	danger = 3,
	name = "Keeper's Verdict",
	radius = 110,
	range = 450,
	delay = 300,
	Slot = 3,
	spellName = "PoppyRSpellInstant",
	spellType = "Line",
	},
	{
	charName = "Poppy",
	danger = 3,
	name = "Keeper's Verdict",
	radius = 100,
	range = 1150,
	projectileSpeed = 1750,
	delay = 300,
	Slot = 3,
	spellName = "PoppyRSpell",
	missileName = "PoppyRMissile",
	spellType = "Line",
	},
},
--end
["Quinn"] = {
	{
	charName = "Quinn",
	danger = 2,
	missileName = "QuinnQMissile",
	name = "QuinnQ",
	projectileSpeed = 1550,
	radius = 80,
	range = 1050,
	delay = 250,
	Slot = 0,
	spellName = "QuinnQ",
	spellType = "Line",
	collision = true,
	},
},
--end Quinn
["RekSai"] = {
	{
	charName = "RekSai",
	danger = 2,
	missileName = "RekSaiQBurrowedMis",
	name = "RekSaiQ",
	projectileSpeed = 1950,
	radius = 65,
	range = 1500,
	delay = 125,
	Slot = 0,
	spellName = "ReksaiQBurrowed",
	spellType = "Line",
	collision = true,
	},
},
--end RekSai
["Rengar"] = {
	{
	charName = "Rengar",
	danger = 2,
	missileName = "RengarEFinal",
	name = "Bola Strike",
	projectileSpeed = 1500,
	radius = 70,
	range = 1000,
	delay = 250,
	Slot = 2,
	spellName = "RengarE",
	spellType = "Line",
	extraMissileNames = "RengarEFinalMAX",
	collision = true,
	},
},
--end Rengar
["Riven"] = {
	{
	angle = 15,
	charName = "Riven",
	danger = 2,
	isThreeWay = true,
	name = "WindSlash",
	projectileSpeed = 1600,
	radius = 100,
	range = 1100,
	delay = 250,
	Slot = 3,
	spellName = "RivenIzunaBlade",
	spellType = "Line",
	isSpecial = true,
	},
	{
	charName = "Riven",
	danger = 2,
	defaultOff = true,
	name = "RivenW",
	projectileSpeed = 1500,
	radius = 280,
	range = 650,
	delay = 267,
	Slot = 1,
	spellName = "RivenMartyr",
	spellType = "Circular",
	},
},
--end Riven
["Rumble"] = {
	{
	charName = "Rumble",
	danger = 1,
	missileName = "RumbleGrenadeMissile",
	name = "RumbleGrenade",
	projectileSpeed = 2000,
	radius = 90,
	range = 950,
	delay = 250,
	Slot = 2,
	spellName = "RumbleGrenade",
	spellType = "Line",
	collision = true,
	},
},
--end Rumble
["Ryze"] = {
	{
	charName = "Ryze",
	danger = 2,
	missileName = "RyzeQ",
	name = "RyzeQ",
	projectileSpeed = 1700,
	radius = 60,
	range = 900,
	delay = 250,
	Slot = 0,
	spellName = "RyzeQ",
	spellType = "Line",
	collision = true,
	},
},
--end Ryze
["Sejuani"] = {
	{
	charName = "Sejuani",
	danger = 3,
	name = "Arctic Assault",
	projectileSpeed = 1600,
	radius = 70,
	range = 900,
	delay = 0,
	Slot = 0,
	spellName = "SejuaniArcticAssault",
	spellType = "Line",
	},
	{
	charName = "Sejuani",
	danger = 4,
	missileName = "SejuaniGlacialPrison",
	name = "SejuaniR",
	projectileSpeed = 1600,
	radius = 110,
	range = 1200,
	delay = 250,
	Slot = 3,
	spellName = "SejuaniGlacialPrisonCast",
	spellType = "Line",
	},
},
--end Sejuani
["Shen"] = {
	{
	charName = "Shen",
	danger = 3,
	missileName = "ShenE",
	name = "ShadowDash",
	projectileSpeed = 1600,
	radius = 60,
	range = 675,
	delay = 0,
	Slot = 2,
	spellName = "ShenE",
	spellType = "Line",
	},
},
--end Shen
["Shyvana"] = {
	{
	charName = "Shyvana",
	danger = 1,
	name = "ShyvanaFireball",
	projectileSpeed = 1700,
	radius = 60,
	range = 950,
	Slot = 2,
	spellName = "ShyvanaFireball",
	spellType = "Line",
	},
	{
	charName = "Shyvana",
	danger = 3,
	name = "ShyvanaTransformCast",
	projectileSpeed = 1100,
	radius = 160,
	range = 1000,
	delay = 10,
	Slot = 3,
	spellName = "ShyvanaTransformCast",
	spellType = "Line",
	},
},
--end Shyvana
["Sion"] = {
	{
	charName = "Sion",
	danger = 2,
	missileName = "SionEMissile",
	name = "SionE",
	projectileSpeed = 1800,
	radius = 80,
	range = 800,
	delay = 250,
	Slot = 2,
	spellName = "SionE",
	spellType = "Line",
	isSpecial = true,
	},
},
--end Sion
["Sivir"] = {
	{
	charName = "Sivir",
	danger = 2,
	missileName = "SivirQMissile",
	name = "Boomerang Blade",
	projectileSpeed = 1350,
	radius = 100,
	range = 1275,
	delay = 250,
	Slot = 0,
	spellName = "SivirQ",
	extraMissileNames = "SivirQMissileReturn",
	spellType = "Line",
	},
},
--end Sivir
["Skarner"] = {
	{
	charName = "Skarner",
	danger = 2,
	missileName = "SkarnerFractureMissile",
	name = "SkarnerFracture",
	projectileSpeed = 1400,
	radius = 60,
	range = 1000,
	delay = 250,
	Slot = 2,
	spellName = "SkarnerFracture",
	spellType = "Line",
	},
},
--end Skarner
["Sona"] = {
	{
	charName = "Sona",
	danger = 4,
	name = "Crescendo",
	projectileSpeed = 2400,
	radius = 150,
	range = 1000,
	delay = 250,
	Slot = 3,
	spellName = "SonaR",
	spellType = "Line",
	},
},
--end Sona
["Soraka"] = {
	{
	charName = "Soraka",
	danger = 2,
	name = "SorakaQ",
	projectileSpeed = 1100,
	radius = 260,
	range = 970,
	delay = 250,
	Slot = 0,
	spellName = "SorakaQ",
	spellType = "Circular",
	},
	{
	charName = "Soraka",
	danger = 2,
	name = "SorakaE",
	radius = 275,
	range = 925,
	delay = 1750,
	Slot = 2,
	spellName = "SorakaE",
	spellType = "Circular",
	},
},
--end Soraka
["Swain"] = {
	{
	charName = "Swain",
	danger = 3,
	name = "Nevermove",
	radius = 250,
	range = 900,
	delay = 1100,
	Slot = 1,
	spellName = "SwainShadowGrasp",
	spellType = "Circular",
	},
},
--end Swain
["Syndra"] = {
	{
	angle = 30,
	charName = "Syndra",
	danger = 3,
	name = "SyndraE",
	missileName = "SyndraE",

	projectileSpeed = 1500,
	radius = 140,
	range = 800,
	delay = 250,
	Slot = 2,
	spellName = "SyndraE",
	spellType = "Line",
	},
	{
	charName = "Syndra",
	danger = 2,
	name = "SyndraW",
	projectileSpeed = 1450,
	radius = 220,
	range = 925,
	delay = 0,
	Slot = 1,
	spellName = "SyndraWCast",
	spellType = "Circular",
	},
	{
	charName = "Syndra",
	danger = 2,
	name = "SyndraQ",
	radius = 210,
	range = 800,
	delay = 600,
	Slot = 0,
	spellName = "SyndraQ",
	missileName = "SyndraQSpell",
	spellType = "Circular",
	},
},
--end Syndra
["TahmKench"] = {
	{
	charName = "TahmKench",
	danger = 2,
	missileName = "TahmkenchQMissile",
	name = "TahmKenchQ",
	projectileSpeed = 2000,
	delay = 250,
	radius = 70,
	range = 951,
	Slot = 0,
	spellName = "TahmKenchQ",
	spellType = "Line",
	collision = true,
	},
},
--end TahmKench
["Talon"] = {
	{
	angle = 20,
	charName = "Talon",
	danger = 2,
	isThreeWay = true,
	name = "TalonRake",
	projectileSpeed = 2300,
	radius = 75,
	range = 780,
	Slot = 1,
	spellName = "TalonRake",
	spellType = "Line",
	splits = 3,
	isSpecial = true,
	},
},
--end Talon
["Thresh"] = {
	{
	charName = "Thresh",
	danger = 3,
	missileName = "ThreshQMissile",
	name = "ThreshQ",
	projectileSpeed = 1900,
	radius = 70,
	range = 1100,
	delay = 500,
	Slot = 0,
	spellName = "ThreshQ",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "Thresh",
	danger = 3,
	missileName = "ThreshEMissile1",
	name = "ThreshE",
	projectileSpeed = 2000,
	radius = 110,
	range = 1075,
	delay = 0,
	defaultOff = true,
	Slot = 2,
	spellName = "ThreshE",
	spellType = "Line",

	},
},
--end Thresh
["TwistedFate"] = {
	{
	angle = 28,
	charName = "TwistedFate",
	danger = 2,
	isThreeWay = true,
	missileName = "SealFateMissile",
	name = "Loaded Dice",
	projectileSpeed = 1000,
	radius = 40,
	range = 1450,
	delay = 250,
	Slot = 0,
	spellName = "WildCards",
	spellType = "Line",
	isSpecial = true,
	},
},
--end TwistedFate
["Twitch"] = {
	{
	charName = "Twitch",
	danger = 2,
	name = "Loaded Dice",
	projectileSpeed = 4000,
	radius = 60,
	range = 1100,
	delay = 250,
	Slot = 3,
	spellName = "TwitchSprayandPrayAttack",
	spellType = "Line",
	},
},
--end Twitch
["Urgot"] = {
	{
	charName = "Urgot",
	danger = 1,
	name = "Acid Hunter",
	projectileSpeed = 1600,
	radius = 60,
	range = 1000,
	delay = 175,
	Slot = 0,
	spellName = "UrgotHeatseekingLineMissile",
	spellType = "Line",
	collision = true,
	},
	{
	charName = "Urgot",
	danger = 2,
	name = "Plasma Grenade",
	projectileSpeed = 1750,
	radius = 250,
	range = 900,
	delay = 250,
	Slot = 2,
	spellName = "UrgotPlasmaGrenade",
	spellType = "Circular",
	},
},
--end Urgot
["Varus"] = {
	{
	charName = "Varus",
	danger = 1,
	name = "Varus E",
	missileName = "VarusEMissile",
	projectileSpeed = 1500,
	radius = 235,
	range = 925,
	delay = 250,
	Slot = 2,
	spellName = "VarusE",
	extraSpellNames = "VarusEMissile",
	spellType = "Circular",
	},
	{
	charName = "Varus",
	danger = 2,
	missileName = "VarusQMissile",
	name = "VarusQMissile",
	projectileSpeed = 1900,
	radius = 70,
	range = 1600,
	delay = 0,
	Slot = 0,
	spellName = "VarusQ",
	spellType = "Line",

	},
	{
	charName = "Varus",
	danger = 3,
	name = "VarusR",
	missileName = "VarusRMissile",
	projectileSpeed = 1950,
	radius = 100,
	range = 1200,
	delay = 250,
	Slot = 3,
	spellName = "VarusR",
	spellType = "Line",
	},
},
--end Varus
["Veigar"] = {
	{
	charName = "Veigar",
	danger = 2,
	name = "VeigarBalefulStrike",
	radius = 70,
	range = 950,
	delay = 250,
	projectileSpeed = 1750,
	Slot = 0,
	spellName = "VeigarBalefulStrike",
	missileName = "VeigarBalefulStrikeMis",
	spellType = "Line",
	},
	{
	charName = "Veigar",
	danger = 2,
	name = "VeigarDarkMatter",
	radius = 225,
	range = 900,
	delay = 1350,
	Slot = 1,
	spellName = "VeigarDarkMatter",
	spellType = "Circular",
	},
	{
	charName = "Veigar",
	danger = 3,
	name = "VeigarEventHorizon",
	radius = 425,
	range = 700,
	delay = 500,
	extraEndTime = 3500,
	Slot = 2,
	spellName = "VeigarEventHorizon",
	spellType = "Circular",
	defaultOff = true,
	},
},
--end Veigar
["Velkoz"] = {
	{
	charName = "Velkoz",
	danger = 2,
	name = "VelkozE",
	projectileSpeed = 1500,
	radius = 225,
	range = 950,
	Slot = 2,
	spellName = "VelkozE",
	spellType = "Circular",
	},
	{
	charName = "Velkoz",
	danger = 1,
	name = "VelkozW",
	projectileSpeed = 1700,
	radius = 88,
	range = 1100,
	Slot = 1,
	spellName = "VelkozW",
	spellType = "Line",
	},
	{
	charName = "Velkoz",
	danger = 2,
	name = "VelkozQMissileSplit",
	projectileSpeed = 2100,
	radius = 45,
	range = 1100,
	Slot = 0,
	spellName = "VelkozQMissileSplit",
	spellType = "Line",

	collision = true,
	},
	{
	charName = "Velkoz",
	danger = 2,
	name = "VelkozQ",
	projectileSpeed = 1300,
	radius = 50,
	range = 1250,
	Slot = 0,
	missileName = "VelkozQMissile",
	spellName = "VelkozQ",
	spellType = "Line",
	collision = true,
	},
},
--end Velkoz
["Vi"] = {
	{
	charName = "Vi",
	danger = 3,
	name = "ViQMissile",
	projectileSpeed = 1500,
	radius = 90,
	range = 725,
	Slot = 0,
	spellName = "ViQMissile",
	spellType = "Line",

	defaultOff = true,
	},
},
--end Vi
["Viktor"] = {
	{
	charName = "Viktor",
	danger = 2,
	missileName = "ViktorDeathRayMissile",
	name = "ViktorDeathRay",
	projectileSpeed = 780,
	radius = 80,
	range = 800,
	Slot = 2,
	spellName = "ViktorDeathRay",
	extraMissileNames = "ViktorEAugMissile",
	spellType = "Line",
	},
	{
	charName = "Viktor",
	danger = 2,
	name = "ViktorDeathRay3",
	projectileSpeed = math.huge,
	delay = 500,
	radius = 80,
	range = 800,
	Slot = 2,
	spellName = "ViktorDeathRay3",
	spellType = "Line",                
	},
	{
	charName = "Viktor",
	danger = 2,
	missileName = "ViktorDeathRayMissile2",
	name = "ViktorDeathRay2",
	projectileSpeed = 1500,
	radius = 80,
	range = 800,
	Slot = 2,
	spellName = "ViktorDeathRay2",
	spellType = "Line",
	},
	{
	charName = "Viktor",
	danger = 2,
	name = "GravitonField",
	radius = 300,
	range = 625,
	delay = 1500,
	Slot = 1,
	spellName = "ViktorGravitonField",
	spellType = "Circular",
	defaultOff = true,
	},
},
--end Viktor
["Vladimir"] = {
	{
	charName = "Vladimir",
	danger = 3,
	name = "VladimirHemoplague",
	radius = 375,
	range = 700,
	delay = 389,
	Slot = 3,
	spellName = "VladimirHemoplague",
	spellType = "Circular",
	},
},
--end Vladimir
["Xerath"] = {
	{
	charName = "Xerath",
	danger = 2,
	name = "XerathArcaneBarrage2",
	radius = 280,
	range = 1100,
	delay = 750,
	Slot = 1,
	spellName = "XerathArcaneBarrage2",
	spellType = "Circular",
	extraDrawHeight = 45,
	},
	{
	charName = "Xerath",
	danger = 3,
	name = "XerathArcanopulse2",
	projectileSpeed = math.huge,
	radius = 70,
	range = 1525,
	delay = 500,
	Slot = 0,
	spellName = "XerathArcanopulse2",
	useEndPosition = true,
	spellType = "Line",
	},
	{
	charName = "Xerath",
	danger = 2,
	name = "XerathLocusOfPower2",
	missileName = "XerathLocusPulse",
	radius = 200,
	range = 5600,
	delay = 600,
	Slot = 3,
	spellName = "XerathRMissileWrapper",
	extraSpellNames = "XerathLocusPulse",
	spellType = "Circular"
	},
	{
	charName = "Xerath",
	danger = 3,
	missileName = "XerathMageSpearMissile",
	name = "XerathMageSpear",
	projectileSpeed = 1600,
	delay = 200,
	radius = 60,
	range = 1125,
	Slot = 2,
	spellName = "XerathMageSpear",
	spellType = "Line",
	collision = true,
	},
},
--end Xerath
["Yasuo"] = {
	{
	charName = "Yasuo",
	danger = 3,
	missileName = "YasuoQ3",
	name = "Steel Tempest 3",
	projectileSpeed = 1200,
	radius = 90,
	range = 1100,
	delay = 250,
	Slot = 0,
	spellName = "YasuoQ3W",
	extraMissileNames = "YasuoQ3Mis",
	spellType = "Line",
	},
	{
	charName = "Yasuo",
	danger = 2,
	name = "Steel Tempest 2",
	projectileSpeed = math.huge,
	radius = 35,
	range = 525,
	fixedRange = true,
	delay = 350,
	Slot = 0,
	spellName = "YasuoQ2",
	spellType = "Line",
	},
	{
	charName = "Yasuo",
	danger = 2,
	name = "Steel Tempest 1",
	projectileSpeed = math.huge,
	radius = 35,
	range = 525,
	fixedRange = true,
	delay = 350,
	Slot = 0,
	spellName = "YasuoQ2",
	spellType = "Line",
	},
},
--end Yasuo
["Zac"] = {
	{
	charName = "Zac",
	danger = 2,
	name = "ZacQ",
	projectileSpeed = math.huge,
	fixedRange = true,
	radius = 120,
	range = 550,
	delay = 500,
	Slot = 0,
	spellName = "ZacQ",
	extraSpellNames = "YasuoQ2", "YasuoQ2W",
	spellType = "Line",
	},
},
--end Zac
["Zed"] = {
	{
	charName = "Zed",
	danger = 2,
	missileName = "ZedQMissile",
	name = "ZedQ",                
	projectileSpeed = 1700,
	radius = 50,
	range = 925,
	delay = 250,
	Slot = 0,
	spellName = "ZedQ",
	spellType = "Line",
	},
	{
	charName = "Zed",
	danger = 1,
	name = "ZedE",
	radius = 290,
	range = 290,
	Slot = 2,
	spellName = "ZedE",
	spellType = "Circular",
	isSpecial = true,
	defaultOff = true,
	},
},
--end Zed
["Ziggs"] = {
	{
	charName = "Ziggs",
	danger = 1,
	name = "ZiggsE",
	projectileSpeed = 3000,
	radius = 235,
	range = 2000,
	delay = 250,
	Slot = 2,
	spellName = "ZiggsE",
	spellType = "Circular",
	},
	{
	charName = "Ziggs",
	danger = 1,
	name = "ZiggsW",
	projectileSpeed = 3000,
	radius = 275,
	range = 2000,
	delay = 250,
	Slot = 1,
	spellName = "ZiggsW",
	spellType = "Circular",
	},
	{
	charName = "Ziggs",
	danger = 2,
	name = "ZiggsQ",
	projectileSpeed = 1700,
	radius = 150,
	range = 850,                
	delay = 250,
	Slot = 0,
	spellName = "ZiggsQ",
	spellType = "Circular",
	isSpecial = true,
	noProcess = true,
	},
	{
	charName = "Ziggs",
	danger = 4,
	name = "ZiggsR",
	projectileSpeed = 1500,
	radius = 550,
	range = 5300,
	delay = 1500,
	Slot = 3,
	spellName = "ZiggsR",
	spellType = "Circular",
	},
},
--end Ziggs
["Zilean"] = {
	{
	charName = "Zilean",
	danger = 2,
	name = "ZileanQ",
	projectileSpeed = 2000,
	radius = 250,
	range = 900,
	delay = 300,
	Slot = 0,
	spellName = "ZileanQ",
	spellType = "Circular",
	},
},
--end Zilean
["Zyra"] = {
	{
	charName = "Zyra",
	danger = 3,
	name = "Grasping Roots",
	projectileSpeed = 1400,
	radius = 70,
	range = 1150,
	delay = 250,
	Slot = 2,
	spellName = "ZyraGraspingRoots",
	missileName = "ZyraE",
	spellType = "Line",
	},
	{
	charName = "Zyra",
	danger = 2,
	missileName = "ZyraPassiveDeathManager",
	name = "Zyra Passive",
	projectileSpeed = 1900,
	radius = 70,
	range = 1474,
	delay = 500,
	Slot = 0,
	spellName = "ZyraPassiveDeathManager",
	spellType = "Line",
	},
	{
	charName = "Zyra",
	danger = 2,
	name = "Deadly Bloom",
	radius = 260,
	range = 825,
	delay = 800,
	Slot = 0,
	spellName = "ZyraQFissure",
	spellType = "Circular",
	},
	{
	charName = "Zyra",
	danger = 4,
	name = "ZyraR",
	radius = 525,
	range = 700,
	delay = 500,
	Slot = 3,
	spellName = "ZyraBrambleZone",
	spellType = "Circular",
	},
},
--end Zyra
}
