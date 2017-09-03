-- Lazy Xayah

if myHero.charName ~= "Xayah" then return end

--MENU

local version = 1.0

local icons = {	["Xayah"] = "https://vignette2.wikia.nocookie.net/leagueoflegends/images/5/55/Clean_Cuts.png",
}

local 	LazyMenu = MenuElement({id = "LazyXayah", name = "Lazy | "..myHero.charName, type = MENU ,leftIcon = icons[myHero.charName] })
		LazyMenu:MenuElement({id = "Combo", name = "Combo", type = MENU})
		LazyMenu:MenuElement({id = "Harass", name = "Harass", type = MENU})
		LazyMenu:MenuElement({id = "Killsteal", name = "Killsteal", type = MENU})
		LazyMenu:MenuElement({id = "Items", name = "Items", type = MENU})
		LazyMenu:MenuElement({id = "Misc", name = "Misc", type = MENU})
		LazyMenu:MenuElement({id = "Key", name = "Key Settings", type = MENU})
		LazyMenu.Key:MenuElement({id = "Combo", name = "Combo", key = string.byte(" ")})
		LazyMenu.Key:MenuElement({id = "Harass", name = "Harass | Mixed", key = string.byte("C")})
		LazyMenu.Key:MenuElement({id = "Clear", name = "LaneClear | JungleClear", key = string.byte("V")})
		LazyMenu.Key:MenuElement({id = "LastHit", name = "LastHit", key = string.byte("X")})
		
		
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function GetMode()
	if LazyMenu.Key.Combo:Value() then return "Combo" end
	if LazyMenu.Key.Harass:Value() then return "Harass" end
	if LazyMenu.Key.Clear:Value() then return "Clear" end
	if LazyMenu.Key.LastHit:Value() then return "LastHit" end
    return ""
end

local function GetDistance(p1,p2)
return  math.sqrt(math.pow((p2.x - p1.x),2) + math.pow((p2.y - p1.y),2) + math.pow((p2.z - p1.z),2))
end

local function GetDistance2D(p1,p2)
return  math.sqrt(math.pow((p2.x - p1.x),2) + math.pow((p2.y - p1.y),2))
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
  for i = 1, Game.HeroCount() do
    local unit = Game.Hero(i)
    if unit.isEnemy then
	  if _EnemyHeroes == nil then _EnemyHeroes = {} end
      table.insert(_EnemyHeroes, unit)
    end
  end
  return {}
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

local _OnVision = {}
function OnVision(unit)
	if _OnVision[unit.networkID] == nil then _OnVision[unit.networkID] = {state = unit.visible , tick = GetTickCount(), pos = unit.pos} end
	if _OnVision[unit.networkID].state == true and not unit.visible then _OnVision[unit.networkID].state = false _OnVision[unit.networkID].tick = GetTickCount() end
	if _OnVision[unit.networkID].state == false and unit.visible then _OnVision[unit.networkID].state = true _OnVision[unit.networkID].tick = GetTickCount() end
	return _OnVision[unit.networkID]
end
Callback.Add("Tick", function() OnVisionF() end)
local visionTick = GetTickCount()
function OnVisionF()
	if GetTickCount() - visionTick > 100 then
		for i,v in pairs(GetEnemyHeroes()) do
			OnVision(v)
		end
	end
end

local _OnWaypoint = {}
function OnWaypoint(unit)
	if _OnWaypoint[unit.networkID] == nil then _OnWaypoint[unit.networkID] = {pos = unit.posTo , speed = unit.ms, time = Game.Timer()} end
	if _OnWaypoint[unit.networkID].pos ~= unit.posTo then 
		-- print("OnWayPoint:"..unit.charName.." | "..math.floor(Game.Timer()))
		_OnWaypoint[unit.networkID] = {startPos = unit.pos, pos = unit.posTo , speed = unit.ms, time = Game.Timer()}
			DelayAction(function()
				local time = (Game.Timer() - _OnWaypoint[unit.networkID].time)
				local speed = GetDistance2D(_OnWaypoint[unit.networkID].startPos,unit.pos)/(Game.Timer() - _OnWaypoint[unit.networkID].time)
				if speed > 1250 and time > 0 and unit.posTo == _OnWaypoint[unit.networkID].pos and GetDistance(unit.pos,_OnWaypoint[unit.networkID].pos) > 200 then
					_OnWaypoint[unit.networkID].speed = GetDistance2D(_OnWaypoint[unit.networkID].startPos,unit.pos)/(Game.Timer() - _OnWaypoint[unit.networkID].time)
					-- print("OnDash: "..unit.charName)
				end
			end,0.05)
	end
	return _OnWaypoint[unit.networkID]
end

local function GetPred(unit,speed,delay,sourcePos)
	local speed = speed or math.huge
	local delay = delay or 0.25
	local sourcePos = sourcePos or myHero.pos
	local unitSpeed = unit.ms
	if OnWaypoint(unit).speed > unitSpeed then unitSpeed = OnWaypoint(unit).speed end
	if OnVision(unit).state == false then
		local unitPos = unit.pos + Vector(unit.pos,unit.posTo):Normalized() * ((GetTickCount() - OnVision(unit).tick)/1000 * unitSpeed)
		local predPos = unitPos + Vector(unit.pos,unit.posTo):Normalized() * (unitSpeed * (delay + (GetDistance(sourcePos,unitPos)/speed)))
		if GetDistance(unit.pos,predPos) > GetDistance(unit.pos,unit.posTo) then predPos = unit.posTo end
		return predPos
	else
		if unitSpeed > unit.ms then
			local predPos = unit.pos + Vector(OnWaypoint(unit).startPos,unit.posTo):Normalized() * (unitSpeed * (delay + (GetDistance(sourcePos,unit.pos)/speed)))
			if GetDistance(unit.pos,predPos) > GetDistance(unit.pos,unit.posTo) then predPos = unit.posTo end
			return predPos
		elseif IsImmobileTarget(unit) then
			return unit.pos
		else
			return unit:GetPrediction(speed,delay)
		end
	end
end

local function CanUseSpell(spell)
	return myHero:GetSpellData(spell).currentCd == 0 and myHero:GetSpellData(spell).level > 0 and myHero:GetSpellData(spell).mana <= myHero.mana
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

local DamageReductionTable = {
  ["Braum"] = {buff = "BraumShieldRaise", amount = function(target) return 1 - ({0.3, 0.325, 0.35, 0.375, 0.4})[target:GetSpellData(_E).level] end},
  ["Urgot"] = {buff = "urgotswapdef", amount = function(target) return 1 - ({0.3, 0.4, 0.5})[target:GetSpellData(_R).level] end},
  ["Alistar"] = {buff = "Ferocious Howl", amount = function(target) return ({0.5, 0.4, 0.3})[target:GetSpellData(_R).level] end},
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

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function Priority(charName)
  local p1 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "Cho'Gath", "Dr. Mundo", "Garen", "Gnar", "Maokai", "Hecarim", "Jarvan IV", "Leona", "Lulu", "Malphite", "Nasus", "Nautilus", "Nunu", "Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Taric", "TahmKench", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Poppy"}
  local p2 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gragas", "Irelia", "Jax", "Lee Sin", "Morgana", "Janna", "Nocturne", "Pantheon", "Rengar", "Rumble", "Swain", "Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai", "Bard", "Nami", "Sona", "Camille", "Rakan"}
  local p3 = {"Akali", "Diana", "Ekko", "FiddleSticks", "Fiora", "Gangplank", "Fizz", "Heimerdinger", "Jayce", "Kassadin", "Kayle", "Kha'Zix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo", "Zilean", "Zyra", "Ryze"}
  local p4 = {"Ahri", "Anivia", "Annie", "Ashe", "Azir", "Brand", "Caitlyn", "Cassiopeia", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "Karma", "Karthus", "Katarina", "Kennen", "KogMaw", "Kindred", "Leblanc", "Lucian", "Lux", "Malzahar", "MasterYi", "MissFortune", "Orianna", "Quinn", "Sivir", "Syndra", "Talon", "Teemo", "Tristana", "TwistedFate", "Twitch", "Varus", "Vayne", "Veigar", "Velkoz", "Viktor", "Xerath", "Zed", "Ziggs", "Jhin", "Soraka", "Xayah"}
  if table.contains(p1, charName) then return 1 end
  if table.contains(p2, charName) then return 1.25 end
  if table.contains(p3, charName) then return 1.75 end
  return table.contains(p4, charName) and 2.25 or 1
end

local function GetTarget(range,t,pos)
local t = t or "AD"
local pos = pos or myHero.pos
local target = {}
	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isEnemy and not hero.dead then
			OnVision(hero)
		end
		if hero.isEnemy and hero.valid and not hero.dead and (OnVision(hero).state == true or (OnVision(hero).state == false and GetTickCount() - OnVision(hero).tick < 650)) and hero.isTargetable then
			local heroPos = hero.pos
			if OnVision(hero).state == false then heroPos = hero.pos + Vector(hero.pos,hero.posTo):Normalized() * ((GetTickCount() - OnVision(hero).tick)/1000 * hero.ms) end
			if GetDistance(pos,heroPos) <= range then
				if t == "AD" then
					target[(CalcPhysicalDamage(myHero,hero,100) / hero.health)*Priority(hero.charName)] = hero
				elseif t == "AP" then
					target[(CalcMagicalDamage(myHero,hero,100) / hero.health)*Priority(hero.charName)] = hero
				elseif t == "HYB" then
					target[((CalcMagicalDamage(myHero,hero,50) + CalcPhysicalDamage(myHero,hero,50))/ hero.health)*Priority(hero.charName)] = hero
				end
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
local range = range or math.huge
local delay = delay or 250
local ticker = GetTickCount()

	if castSpell.state == 0 and GetDistance(myHero.pos,pos) < range and ticker - castSpell.casting > delay + Game.Latency() and pos:ToScreen().onScreen then
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

local function CastSpellMM(spell,pos,range,delay)
local range = range or math.huge
local delay = delay or 250
local ticker = GetTickCount()
	if castSpell.state == 0 and GetDistance(myHero.pos,pos) < range and ticker - castSpell.casting > delay + Game.Latency() then
		castSpell.state = 1
		castSpell.mouse = mousePos
		castSpell.tick = ticker
	end
	if castSpell.state == 1 then
		if ticker - castSpell.tick < Game.Latency() then
			local castPosMM = pos:ToMM()
			Control.SetCursorPos(castPosMM.x,castPosMM.y)
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

local function ReleaseSpell(spell,pos,range,delay)
local delay = delay or 250
local ticker = GetTickCount()
	if castSpell.state == 0 and GetDistance(myHero.pos,pos) < range and ticker - castSpell.casting > delay + Game.Latency() then
		castSpell.state = 1
		castSpell.mouse = mousePos
		castSpell.tick = ticker
	end
	if castSpell.state == 1 then
		if ticker - castSpell.tick < Game.Latency() then
			if not pos:ToScreen().onScreen then
				pos = myHero.pos + Vector(myHero.pos,pos):Normalized() * math.random(530,760)
				Control.SetCursorPos(pos)
				Control.KeyUp(spell)
			else
				Control.SetCursorPos(pos)
				Control.KeyUp(spell)
			end
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
local aaTicker = Callback.Add("Tick", function() aaTick() end)
function aaTick()
	if aa.state == 1 and myHero.attackData.state == 2 then
		lastTick = GetTickCount()
		aa.state = 2
		aa.target = myHero.attackData.target
	end
	if aa.state == 2 then
		if myHero.attackData.state == 1 then
			aa.state = 1
		end
		if Game.Timer() + Game.Latency()/2000 - myHero.attackData.castFrame/200 > myHero.attackData.endTime - myHero.attackData.windDownTime and aa.state == 2 then
			aa.state = 3
			aa.tick2 = GetTickCount()
			aa.downTime = myHero.attackData.windDownTime*1000 - (myHero.attackData.windUpTime*1000)
		end
	end
	if aa.state == 3 then
		if GetTickCount() - aa.tick2 - Game.Latency() - myHero.attackData.castFrame > myHero.attackData.windDownTime*1000 - (myHero.attackData.windUpTime*1000)/2 then
			aa.state = 1
		end
		if myHero.attackData.state == 1 then
			aa.state = 1
		end
		if GetTickCount() - aa.tick2 > aa.downTime then
			aa.state = 1
		end
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "LazyXayah"

function LazyXayah:__init()
	print("Noddy's | LazyXayah loaded!")
	self.spellIcons = { Q = "https://vignette4.wikia.nocookie.net/leagueoflegends/images/1/1e/Double_Daggers.png",
						W = "https://vignette1.wikia.nocookie.net/leagueoflegends/images/b/be/Deadly_Plumage.png",
						E = "https://vignette4.wikia.nocookie.net/leagueoflegends/images/a/a8/Bladecaller.png",
						R = "https://vignette1.wikia.nocookie.net/leagueoflegends/images/2/25/Featherstorm.png"}
	self.AA = { delay = 0.25, speed = 2000, width = 0, range = 525 }
	self.Q = { delay = 0.25, speed = 1800, width = 100, range = 1100 }
	self.W = { delay = 0.05, speed = math.huge, width = 200, range = 525 }
	self.E = { delay = 0.25, speed = 3000, width = 90, range = 1050 }
	self.R = { delay = 0.5, speed = math.huge, width = 200, range = 1000, angle = 30 }
	self.Q_DMG = function(target) return CalcPhysicalDamage(myHero,target,40 + 40*myHero:GetSpellData(0).level + myHero.bonusDamage) end
	self.W_DMG = function(target) return CalcPhysicalDamage(myHero,target,myHero.totalDamage*0.2) end
	self.E_DMG = function(target,f) local dmg = 0 local count = 0 while f > count do dmg = dmg + CalcPhysicalDamage(myHero,target,(40+10*myHero:GetSpellData(2).level + myHero.bonusDamage*0.6)*1+0.05*myHero.critChance)*math.max(0.1,1-0.1*count) count = count + 1 end return dmg end
	self.R_DMG = function(target) return CalcPhysicalDamage(myHero,target,50 + 50*myHero:GetSpellData(3).level + myHero.totalDamage) end
	self.range = 525
	self.Feather = {}
	self.FeatherPos = {}
	self.FeatherCount = 0
	self.FeathersOn = {}
	self.FeathersOnDelay = {}
	self.FeatherHit = 0
	self.FeatherHitDelay = 0
	self.RootAble = 0
	self.RootAbleDelay = 0
	self:Menu()
	function OnTick() self:Tick() end
 	function OnDraw() self:Draw() end
end

function LazyXayah:Menu()
	LazyMenu.Combo:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.spellIcons.Q})
	LazyMenu.Combo:MenuElement({id = "useW", name = "Use W", value = true, leftIcon = self.spellIcons.W})
	LazyMenu.Combo:MenuElement({id = "useE", name = "Use E", value = true, leftIcon = self.spellIcons.E})
		LazyMenu.Combo:MenuElement({id = "E", name = "E - Settings", type = MENU, leftIcon = self.spellIcons.E})
		LazyMenu.Combo.E:MenuElement({id = "canRootX", name = " If can root X enemies", value = 3, min = 1, max = 5, step = 1})
		LazyMenu.Combo.E:MenuElement({id = "canHitX", name = " If can hit X feathers", value = 15, min = 5, max = 30, step = 1})
		LazyMenu.Combo.E:MenuElement({id = "leaveX", name = " If target leaving X feathers hits", value = 3, min = 3, max = 10, step = 1})
	LazyMenu.Combo:MenuElement({id = "useR", name = "Use R", value = true, leftIcon = self.spellIcons.R})
		LazyMenu.Combo:MenuElement({id = "R", name = "R - Settings", type = MENU, leftIcon = self.spellIcons.R})
		LazyMenu.Combo.R:MenuElement({id = "useKillR", name = "Use R to kill", value = true})
		LazyMenu.Combo.R:MenuElement({id = "useXR", name = "Use R on X enemies", value = true})
		LazyMenu.Combo.R:MenuElement({id = "canHitX", name = " If can hit X enemies", value = 3, min = 2, max = 5, step = 1})
		
	LazyMenu.Harass:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.spellIcons.Q})
	LazyMenu.Harass:MenuElement({id = "manaQ", name = " Q | Mana-Manager", value = 40, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})
	LazyMenu.Harass:MenuElement({id = "useW", name = "Use W", value = true, leftIcon = self.spellIcons.W})
	LazyMenu.Harass:MenuElement({id = "manaW", name = " W | Mana-Manager", value = 60, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})
	LazyMenu.Harass:MenuElement({id = "useE", name = "Use E", value = false, leftIcon = self.spellIcons.E})
	LazyMenu.Harass:MenuElement({id = "manaE", name = " E | Mana-Manager", value = 80, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})

	LazyMenu.Killsteal:MenuElement({id = "useQ", name = "Use Q to killsteal", value = true, leftIcon = self.spellIcons.Q})
	LazyMenu.Killsteal:MenuElement({id = "useE", name = "Use E to killsteal", value = true, leftIcon = self.spellIcons.E})

end



function LazyXayah:Tick()
	if myHero.dead then return end
	
	if GetMode() == "Combo" then
		self:Combo()
	elseif GetMode() == "Harass" then
		self:Harass()
	end
	
	self:OnFeatherUpdate()
	self:EnemyLoop()
end

function LazyXayah:Draw()
if myHero.dead then return end
		-- local rPred = mousePos
		-- local mainPos = myHero.pos + Vector(myHero.pos,rPred):Normalized()*self.R.range
		-- local points = {[1] = mainPos,[2] = mainPos + Vector(myHero.pos,mainPos):Normalized():Perpendicular()*150, [3] =mainPos + Vector(myHero.pos,mainPos):Normalized():Perpendicular2()*150}
		-- for i,p in pairs(points) do
			-- Draw.Circle(p)
		-- end
end

function LazyXayah:Combo()
	local targetAA = GetTarget(self.range + myHero.boundingRadius/2 + 100,"AD")
	--W
	if LazyMenu.Combo.useW:Value() and targetAA then
		self:useW(targetAA)
	end
	--Q
	if LazyMenu.Combo.useQ:Value() then
		self:useQ(targetAA)
	end
	--E
	if LazyMenu.Combo.useE:Value() then
		self:useE(targetAA)
	end
	--R
	if LazyMenu.Combo.useR:Value() then
		self:useR()
	end
end

function LazyXayah:Harass()
	local mp = GetPercentMP(myHero)
	if LazyMenu.Harass.useW:Value() and mp > LazyMenu.Harass.manaW:Value() then
		local targetAA = GetTarget(self.range + 75,"AD")
		if targetAA then
			self:useW(targetAA)
		end
	end
	if LazyMenu.Harass.useE:Value() and mp > LazyMenu.Harass.manaE:Value() then
		self:useE()
	end
	if LazyMenu.Harass.useQ:Value() and mp > LazyMenu.Harass.manaQ:Value() then	
		self:useQ()
	end
end

function LazyXayah:useQ(targetAA)
	if Game.CanUseSpell(_Q) == 0 and castSpell.state == 0 and aa.state ~= 2 then
		self:useQkill()
		self:useQ_simple(targetAA)
	end
end

function LazyXayah:useW(targetAA)
	if Game.CanUseSpell(_W) == 0 and targetAA and aa.state == 2 then
		Control.CastSpell(HK_W)
	end
end

function LazyXayah:useE(targetAA)
	if Game.CanUseSpell(_E) == 0 and castSpell.state == 0 then
		if targetAA then
			if self.FeathersOn[targetAA.networkID] ~= nil then
				self:useE_runout(targetAA)
				local qDMG = 0
				local aaDMG = CalcPhysicalDamage(myHero,targetAA,myHero.totalDamage*(1+myHero.critChance)*(0.625*myHero.attackSpeed))*1.25
				if Game.CanUseSpell(_Q) == 0 then qDMG = self.Q_DMG(targetAA) end
				local eDMG = math.floor(self.E_DMG(targetAA,self.FeathersOn[targetAA.networkID]))
				if qDMG + aaDMG + eDMG > targetAA.health + targetAA.shieldAD then
					Control.CastSpell(HK_E)
					return
				end
			end
		else
			local targetRange = GetTarget(1300,"AD")
			if targetRange then
				if self.FeathersOn[targetRange.networkID] ~= nil then
					self:useE_runout(targetRange)
				end
			end
			for i,target in pairs(GetEnemyHeroes()) do
				if GetDistance(myHero.pos,target.pos) < 3500 then
					if self.FeathersOn[target.networkID] ~= nil and math.floor(self.E_DMG(target,self.FeathersOn[target.networkID])) >= target.health + target.shieldAD then
						Control.CastSpell(HK_E)
						return
					end
				end
			end
		end
		self:useE_team()
	end
end

function LazyXayah:useR()
	if Game.CanUseSpell(_R) == 0 and castSpell.state == 0 then
		local target = GetTarget(1200,"AD")
		if target then
			self:useR_kill(target)
			self:useR_multi(target)
		end
	end
end

function LazyXayah:useQ_simple(targetAA)
	if ((Game.CanUseSpell(_R) == 0 and myHero.mana >= 150) or (Game.CanUseSpell(_R) ~= 0 and myHero.mana >= 100)) then
		if targetAA then
			if aa.state == 3 and (Game.Timer() - OnWaypoint(targetAA).time < 0.15 or Game.Timer() - OnWaypoint(targetAA).time > 1.0) then
				local qPred = GetPred(targetAA,self.Q.speed,self.Q.delay + Game.Latency()/1000)
				if GetDistance(myHero.pos,qPred) < self.Q.range then
					local dmg = self.Q_DMG(targetAA)
					local aaDMG = CalcPhysicalDamage(myHero,targetAA,myHero.totalDamage*(1+myHero.critChance))
					if targetAA:GetCollision(self.Q.width,self.Q.speed,self.Q.delay) > 0 then dmg = dmg/2 end
					if myHero.hudAmmo < 3 or aaDMG < dmg then
						CastSpell(HK_Q,qPred,1000,250)
					end
				end
			end
		else
			local target = GetTarget(self.Q.range - 150,"AD")
			if target and (Game.Timer() - OnWaypoint(target).time < 0.15 or Game.Timer() - OnWaypoint(target).time > 1.0) then
				local qPred = GetPred(target,self.Q.speed,self.Q.delay + Game.Latency()/1000)
				if GetDistance(myHero.pos,qPred) < self.Q.range - 250 then
					CastSpell(HK_Q,qPred,1000,250)
				end
			end
		end
	end
end

function LazyXayah:useQkill()
	local target = GetTarget(self.Q.range,"AD")
	if target then
		local qPred = GetPred(target,self.Q.speed,self.Q.delay + Game.Latency()/1000)
		local qDMG = self.Q_DMG(target)
		local eDMG = 0
		if Game.CanUseSpell(_E) == 0 and self.FeathersOn[target.networkID] ~= nil then eDMG = self.E_DMG(target,self.FeathersOn[target.networkID] + 2) end
		if target.health + target.shieldAD < qDMG then
			if GetDistance(myHero.pos,qPred) < self.Q.range then
				CastSpell(HK_Q,qPred)
				return
			end
		end
		if eDMG > 0 and target.health + target.shieldAD < qDMG + eDMG then
			if GetDistance(myHero.pos,qPred) < self.Q.range - 175 then
				CastSpell(HK_Q,qPred)
				return
			end
		end
	end
end

function LazyXayah:useE_team()
	if self.RootAble >= LazyMenu.Combo.E.canRootX:Value() or self.FeatherHit >= LazyMenu.Combo.E.canHitX:Value() then
		Control.CastSpell(HK_E)
		return
	end
end

function LazyXayah:useE_runout(target)
	if target then
		local fOn = self.FeathersOn[target.networkID]
		local fOnD = self.FeathersOnDelay[target.networkID]
		if fOn ~= nil and fOnD ~= nil then
			if fOn >= LazyMenu.Combo.E.leaveX:Value() and fOnD < fOn then
				Control.CastSpell(HK_E)
				return
			end
		end
	end
end

-- E before R dmg if doesnt need the extra dmg
-- R before E if needed the extra dmg for E
-- R if target out of range and Q/E on cooldown

function LazyXayah:useR_kill(target)
	if LazyMenu.Combo.R.useKillR:Value() then
		local targetHP = target.health + target.shieldAD + target.hpRegen*2
		local rPred = GetPred(target,self.R.speed,self.R.delay + 0.25 + Game.Latency()/1000)
		if GetDistance(myHero.pos,target.pos) > GetDistance(rPred,target.pos) then
			local rDMG = self.R_DMG(target)
			local feathers = 0
			local extraFeathers = 0
			local fOn = self.FeathersOn[target.networkID]
			local aggro = ((GetDistance(myHero.pos,target.pos) - 250 > GetDistance(Game.mousePos(),target.pos)) or (GetDistance(myHero.pos,target.pos) < 350)) and true or false
			if GetDistance(myHero.pos,rPred) + myHero.ms/1.5 > self.R.range then return end
			if Game.CanUseSpell(_E) == 0 and fOn ~= nil then feathers = fOn end
			if GetDistance(myHero.pos,rPred) <= 350 then extraFeathers = 3 elseif GetDistance(myHero.pos,rPred) > 350 and GetDistance(myHero.pos,rPred) < 600 then extraFeathers = 2 else extraFeathers = 1 end
				if IsImmobileTarget(target) == true then
					extraFeathers = extraFeathers + 2
				end
			if Game.CanUseSpell(_E) == 0 then
				local eDMG = self.E_DMG(target,feathers)
				if targetHP <= eDMG + rDMG then
				print("1")
					CastSpell(HK_R,rPred)
				elseif targetHP > eDMG + rDMG and aggro == true then
					print("2")
					local eDMG2 = self.E_DMG(target,feathers + extraFeathers)
					if targetHP < eDMG2 + rDMG then
						print("2!")
						CastSpell(HK_R,rPred)
					end
				end
				if feathers < 3 and targetHP > eDMG and GetDistance(myHero.pos,target.pos) > 850 and targetHP < rDMG and aggro == true then
					print("3")
					CastSpell(HK_R,rPred)
				end
			else
				if GetDistance(myHero.pos,target.pos) > 850 and targetHP < rDMG and aggro == true then
					print("4")
					CastSpell(HK_R,rPred)
				end
			end
		end
	end
end

function LazyXayah:useR_multi(target)
if LazyMenu.Combo.R.useXR:Value() then
	local rPred = GetPred(target,self.R.speed,self.R.delay + Game.Latency()/1000)
	if GetDistance(rPred,myHero.pos) < self.R.range then
		local mainPos = myHero.pos + Vector(myHero.pos,rPred):Normalized()*self.R.range
		local points = {[1] = mainPos,[2] = mainPos + Vector(myHero.pos,mainPos):Normalized():Perpendicular()*150, [3] = mainPos + Vector(myHero.pos,mainPos):Normalized():Perpendicular2()*150}
		local hits = {[1] = 1, [2] = 1, [3] = 1}
		local distance = {[1] = 0, [2] = 0, [3] = 0}
		local maxHits,point = 1, 1
		local castPos = rPred
		for i,p in pairs(points) do
			for n,e in pairs(GetEnemyHeroes()) do
				if not e.dead and GetDistance(myHero.pos,e.pos) < self.R.range + 250 and e ~= target then
					local e_Pos = GetPred(e,self.R.speed,self.R.delay + Game.Latency()/1000)
					if GetDistance(myHero.pos,e_Pos) < self.R.range then
						local checkPos = myHero.pos + Vector(myHero.pos,p):Normalized()*GetDistance(myHero.pos,e.pos)
						local distance_e_Pos_checkPos = GetDistance(e_Pos,checkPos)
						if distance_e_Pos_checkPos <= 0.4166666666666666666667*GetDistance(myHero.pos,checkPos) + 20 then
							hits[i] = hits[i] + 1
							distance[i] = distance[i] + distance_e_Pos_checkPos
						end
					end
				end
			end
			if maxHits < hits[i] then
				maxHits, point = hits[i], i
			end
			if hits[i] == hits[point] then
				if distance[i] < distance[point] then
					point = i
				end
			end
		end
		
		if hits[point] >= LazyMenu.Combo.R.canHitX:Value() then
			CastSpell(HK_R,points[point])
			return
		end
	end
end
end

------------------------------------------------------------------------------

local counting = 0
function LazyXayah:EnemyLoop()
	local tick = GetTickCount()
	if aa.state ~= 2 and castSpell.state == 0 then
		if counting + 100 < tick then
			self.FeathersOn = {}
			self.FeathersOnDelay = {}
			self.RootAble = 0
			self.RootAbleDelay = 0
			self.FeatherHit = 0
			self.FeatherHitDelay = 0
			for i,target in pairs(GetEnemyHeroes()) do
				if not target.dead and target.isTargetable and target.valid and (OnVision(target).state == true or (OnVision(target).state == false and GetTickCount() - OnVision(target).tick < 500)) then
					self.FeathersOn[target.networkID] = 0
					self.FeathersOnDelay[target.networkID] = 0
					self:CountFeatherOn(target)
					if LazyMenu.Killsteal.useQ:Value() then
						
					end
					if LazyMenu.Killsteal.useE:Value() then

					end
				end
			end
			counting = tick
		end
	end
end

local countingFeather = 0
function LazyXayah:OnFeatherUpdate()
	local tick = GetTickCount()
	self.FeatherCount = myHero:GetSpellData(2).ammo
	if self.FeatherCount ~= #self.Feather then
		if countingFeather + 50 < tick then
			self.Feather = {}
			self.FeatherPos = {}
			table.insert(self.FeatherPos,myHero.pos.x..myHero.pos.y..myHero.pos.z)
				for i = 0,Game.ObjectCount() do
					local o = Game.Object(i)
						if o.owner == myHero and o.name == "Feather" and not o.dead and self.Feather[o.pos.x..o.pos.y..o.pos.z] == nil then
							table.insert(self.Feather,o)
							self.Feather[o.pos.x..o.pos.y..o.pos.z] = o
						end
				end
			self.FeatherCount = #self.Feather
			countingFeather = tick
		end
	end
end

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

function LazyXayah:CountFeatherOn(target)
	if GetDistance(myHero.pos,target.pos) < 5000 then
		for i,f in pairs(self.Feather) do
			local targetPos = GetPred(target,self.E.speed,0.1, f.pos)
			local targetPosDelay = GetPred(target,self.E.speed,0.5, f.pos)
			local checkPos = myHero.pos + Vector(myHero.pos,f.pos):Normalized()*GetDistance(myHero.pos,target.pos)
			--Normal
			if GetDistance(targetPos,checkPos) < target.boundingRadius + self.E.width then
				self.FeathersOn[target.networkID] = self.FeathersOn[target.networkID] + .5
				self.FeatherHit = self.FeatherHit + 0.5
				-- DrawRectangleOutline(myHero.pos.x, myHero.pos.y, myHero.pos.z, f.pos.x, f.pos.y, f.pos.z, target.boundingRadius/2 + self.E.width, Draw.Color(200,200,50,200))
			end
			--Delay
			if GetDistance(targetPosDelay,checkPos) < target.boundingRadius + self.E.width then
				self.FeathersOnDelay[target.networkID] = self.FeathersOnDelay[target.networkID] + .5
				self.FeatherHitDelay = self.FeatherHitDelay + 0.5
			end
		end
		if self.FeathersOnDelay[target.networkID] >= 3 then
			self.RootAbleDelay = self.RootAbleDelay + 1
		end
		if self.FeathersOn[target.networkID] >= 3 then
			self.RootAble = self.RootAble + 1
		end
	end
end

function OnLoad() LazyXayah() end
