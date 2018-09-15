-- Lazy Xerath

if myHero.charName ~= "Xerath" then return end

--MENU

local version = 1.11

local icons = {	["Xerath"] = "http://vignette2.wikia.nocookie.net/leagueoflegends/images/7/7a/XerathSquare.png",
}

local 	LazyMenu = MenuElement({id = "LazyXerath", name = "Lazy | "..myHero.charName, type = MENU ,leftIcon = icons[myHero.charName] })
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
		LazyMenu:MenuElement({id = "fastOrb", name = "Make Orbwalker fast again", value = true})
		
		
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

local function GetPred(unit,speed,delay)
	local speed = speed or math.huge
	local delay = delay or 0.25
	local unitSpeed = unit.ms
	if OnWaypoint(unit).speed > unitSpeed then unitSpeed = OnWaypoint(unit).speed end
	if OnVision(unit).state == false then
		local unitPos = unit.pos + Vector(unit.pos,unit.posTo):Normalized() * ((GetTickCount() - OnVision(unit).tick)/1000 * unitSpeed)
		local predPos = unitPos + Vector(unit.pos,unit.posTo):Normalized() * (unitSpeed * (delay + (GetDistance(myHero.pos,unitPos)/speed)))
		if GetDistance(unit.pos,predPos) > GetDistance(unit.pos,unit.posTo) then predPos = unit.posTo end
		return predPos
	else
		if unitSpeed > unit.ms then
			local predPos = unit.pos + Vector(OnWaypoint(unit).startPos,unit.posTo):Normalized() * (unitSpeed * (delay + (GetDistance(myHero.pos,unit.pos)/speed)))
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
  -- ["Amumu"] = {buff = "Tantrum", amount = function(target) return ({2, 4, 6, 8, 10})[target:GetSpellData(_E).level] end, damageType = 1},
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
  local p2 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gragas", "Irelia", "Jax", "Lee Sin", "Morgana", "Janna", "Nocturne", "Pantheon", "Rengar", "Rumble", "Swain", "Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai", "Bard", "Nami", "Sona", "Camille"}
  local p3 = {"Akali", "Diana", "Ekko", "FiddleSticks", "Fiora", "Gangplank", "Fizz", "Heimerdinger", "Jayce", "Kassadin", "Kayle", "Kha'Zix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo", "Zilean", "Zyra", "Ryze"}
  local p4 = {"Ahri", "Anivia", "Annie", "Ashe", "Azir", "Brand", "Caitlyn", "Cassiopeia", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "Karma", "Karthus", "Katarina", "Kennen", "KogMaw", "Kindred", "Leblanc", "Lucian", "Lux", "Malzahar", "MasterYi", "MissFortune", "Orianna", "Quinn", "Sivir", "Syndra", "Talon", "Teemo", "Tristana", "TwistedFate", "Twitch", "Varus", "Vayne", "Veigar", "Velkoz", "Viktor", "Xerath", "Zed", "Ziggs", "Jhin", "Soraka"}
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

-- local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
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
			-- print("OnAttackComp WindUP:"..myHero.attackData.endTime)
			aa.state = 3
			aa.tick2 = GetTickCount()
			aa.downTime = myHero.attackData.windDownTime*1000 - (myHero.attackData.windUpTime*1000)
			if LazyMenu.fastOrb ~= nil and LazyMenu.fastOrb:Value() then
				if GetMode() ~= "" and myHero.attackData.state == 2 then
					Control.Move()
				end
			end
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

local castAttack = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
local function CastAttack(pos,range,delay)
local delay = delay or myHero.attackData.windUpTime*1000/2

local ticker = GetTickCount()
	if castAttack.state == 0 and GetDistance(myHero.pos,pos.pos) < range and ticker - castAttack.casting > delay + Game.Latency() and aa.state == 1 and not pos.dead and pos.isTargetable then
		castAttack.state = 1
		castAttack.mouse = mousePos
		castAttack.tick = ticker
		lastTick = GetTickCount()
	end
	if castAttack.state == 1 then
		if ticker - castAttack.tick < Game.Latency() and aa.state == 1 then
				Control.SetCursorPos(pos.pos)
				Control.mouse_event(MOUSEEVENTF_RIGHTDOWN)
				Control.mouse_event(MOUSEEVENTF_RIGHTUP)
				castAttack.casting = ticker + delay
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

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "LazyXerath"

function LazyXerath:__init()
	print("Noddy's | LazyXerath loaded!")
	self.spellIcons = { Q = "http://vignette3.wikia.nocookie.net/leagueoflegends/images/5/57/Arcanopulse.png",
						W = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/2/20/Eye_of_Destruction.png",
						E = "http://vignette2.wikia.nocookie.net/leagueoflegends/images/6/6f/Shocking_Orb.png",
						R = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/3/37/Rite_of_the_Arcane.png"}
	self.AA = { delay = 0.25, speed = 2000, width = 0, range = 550 }
	self.Q = { delay = 0.35, speed = math.huge, width = 145, range = 750 }
	self.W = { delay = 0.5, speed = math.huge, width = 200, range = 1050 }
	self.E = { delay = 0.25, speed = 2100, width = 80, range = 1050 }
	self.R = { delay = 0.5, speed = math.huge, width = 200, range = 3520 }
	self.range = 550
	self.chargeQ = false
	self.qTick = GetTickCount()
	self.chargeR = false
	self.chargeRTick = GetTickCount()
	self.R_target = nil
	self.R_target_tick = GetTickCount()
	self.firstRCast = true
	self.R_Stacks = 0
	self.lastRtick = GetTickCount()
	self.CanUseR = true
	self.lastTarget = nil
	self.lastTarget_tick = GetTickCount()
	self:Menu()
	function OnTick() self:Tick() end
 	function OnDraw() self:Draw() end
end

function LazyXerath:Menu()
	LazyMenu.Combo:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.spellIcons.Q})
	LazyMenu.Combo:MenuElement({id = "legitQ", name = "Legit Q slider", value = 0.075, min = 0, max = 0.15, step = 0.01})
	LazyMenu.Combo:MenuElement({id = "useW", name = "Use W", value = true, leftIcon = self.spellIcons.W})
	LazyMenu.Combo:MenuElement({id = "useE", name = "Use E", value = true, leftIcon = self.spellIcons.E})
	LazyMenu.Combo:MenuElement({id = "useR", name = "Use R", value = true, leftIcon = self.spellIcons.R})
	LazyMenu.Combo:MenuElement({id = "R", name = "Ultimate Settings", type = MENU, leftIcon = self.spellIcons.R})
	LazyMenu.Combo.R:MenuElement({id = "useRself", name = "Start R manually", value = false})
	LazyMenu.Combo.R:MenuElement({id = "BlackList", name = "Auto R blacklist", type = MENU})
	LazyMenu.Combo.R:MenuElement({id = "safeR", name = "Safety R stack", value = 1, min = 0, max = 2, step = 1})
	LazyMenu.Combo.R:MenuElement({id = "targetChangeDelay", name = "Delay between target switch", value = 100, min = 0, max = 2000, step = 10})
	LazyMenu.Combo.R:MenuElement({id = "castDelay", name = "Delay between casts", value = 150, min = 0, max = 500, step = 1})
	LazyMenu.Combo.R:MenuElement({id = "useBlue", name = "Use Farsight Alteration", value = true, leftIcon = "http://vignette2.wikia.nocookie.net/leagueoflegends/images/7/75/Farsight_Alteration_item.png"})
	LazyMenu.Combo.R:MenuElement({id = "useRkey", name = "On key press (close to mouse)", key = string.byte("T")})
	
	LazyMenu.Harass:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.spellIcons.Q})
	LazyMenu.Harass:MenuElement({id = "manaQ", name = " Q | Mana-Manager", value = 40, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})
	LazyMenu.Harass:MenuElement({id = "useW", name = "Use W", value = true, leftIcon = self.spellIcons.W})
	LazyMenu.Harass:MenuElement({id = "manaW", name = " W | Mana-Manager", value = 60, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})
	LazyMenu.Harass:MenuElement({id = "useE", name = "Use E", value = false, leftIcon = self.spellIcons.E})
	LazyMenu.Harass:MenuElement({id = "manaE", name = " E | Mana-Manager", value = 80, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})

	LazyMenu.Killsteal:MenuElement({id = "useQ", name = "Use Q to killsteal", value = true, leftIcon = self.spellIcons.Q})
	LazyMenu.Killsteal:MenuElement({id = "useW", name = "Use W to killsteal", value = true, leftIcon = self.spellIcons.W})
	
	LazyMenu.Misc:MenuElement({id = "gapE", name = "Use E on gapcloser (beta)", value = true, leftIcon = self.spellIcons.E})
	LazyMenu.Misc:MenuElement({id = "drawRrange", name = "Draw R range on minimap", value = true, leftIcon = self.spellIcons.R})
	
	LazyMenu:MenuElement({id = "TargetSwitchDelay", name = "Delay between target switch", value = 350, min = 0, max = 750, step = 1})
	self:TargetMenu()
	LazyMenu:MenuElement({id = "space", name = "Don't forget to turn off default [COMBO] orbwalker!", type = SPACE, onclick = function() LazyMenu.space:Hide() end})
end

local create_menu_tick
function LazyXerath:TargetMenu()
	create_menu_tick = Callback.Add("Tick",function() 
		for i,v in pairs(GetEnemyHeroes()) do
			self:MenuRTarget(v,create_menu_tick)
		end
	end)
end

function LazyXerath:MenuRTarget(v,t)
	if LazyMenu.Combo.R.BlackList[v.charName] ~= nil then
		-- Callback.Del("Tick",create_menu_tick)
	else
		LazyMenu.Combo.R.BlackList:MenuElement({id = v.charName, name = "Blacklist: "..v.charName, value = false})
	end
end

function LazyXerath:Tick()
	if Game.IsChatOpen() then return end
	self:castingQ()
	self:castingR()
	if myHero.dead then return end
	self:useRonKey()
	if GetMode() == "Combo" then
		if aa.state ~= 2 then
			self:Combo()
		end
		self:ComboOrb()
	elseif GetMode() == "Harass" then
		if aa.state ~= 2 then
			self:Harass()
		end
	end
	self:EnemyLoop()
end

function LazyXerath:Draw()
if myHero.dead then return end
	if LazyMenu.Combo.R.useRkey:Value() then
		Draw.Circle(mousePos,500)
	end
	if LazyMenu.Misc.drawRrange:Value() and self.chargeR == false then
		if Game.CanUseSpell(_R) == 0 then
			Draw.CircleMinimap(myHero.pos,2000 + 1220*myHero:GetSpellData(_R).level,1.5,Draw.Color(200,50,180,230))
		end
	end
end

function LazyXerath:ComboOrb()
	if self.chargeR == false and castSpell.state == 0 then
		local target = GetTarget(610)
		local tick = GetTickCount()
		if target then
			if aa.state == 1 and self.chargeQ == false and GetDistance(myHero.pos,target.pos) < 575 and ((Game.CanUseSpell(_Q) ~= 0 and Game.CanUseSpell(_W) ~= 0 and Game.CanUseSpell(_E) ~= 0) or GotBuff(myHero,"xerathascended2onhit") > 0 ) then
				CastAttack(target,575)
			elseif aa.state ~= 2 and tick - lastMove > 120 then
				Control.Move()
				lastMove = tick
			end
		else
			if aa.state ~= 2 and tick - lastMove > 120 then
				Control.Move()
				lastMove = tick
			end
		end
	end
end

function LazyXerath:castingQ()
	if self.chargeQ == true then
		self.Q.range = 750 + 500*(GetTickCount()-self.qTick)/1000
		if self.Q.range > 1500 then self.Q.range = 1500 end
	end
	local qBuff = GetBuffData(myHero,"XerathArcanopulseChargeUp")
	if self.chargeQ == false and qBuff.count > 0 then
		self.qTick = GetTickCount()
		self.chargeQ = true
	end
	if self.chargeQ == true and qBuff.count == 0 then
		self.chargeQ = false
		self.Q.range = 750
		if Control.IsKeyDown(HK_Q) == true then
			Control.KeyUp(HK_Q)
		end
	end
	if Control.IsKeyDown(HK_Q) == true and self.chargeQ == false then
		DelayAction(function()
			if Control.IsKeyDown(HK_Q) == true and self.chargeQ == false then
				Control.KeyUp(HK_Q)
			end
		end,0.3)
	end
	if Control.IsKeyDown(HK_Q) == true and Game.CanUseSpell(_Q) ~= 0 then
		DelayAction(function()
			if Control.IsKeyDown(HK_Q) == true then
				self.Q.range = 750
				Control.KeyUp(HK_Q)
			end
		end,0.01)
	end
end

function LazyXerath:castingR()
	local rBuff = GetBuffData(myHero,"XerathLocusOfPower2")
	if self.chargeR == false and rBuff.count > 0 then
		self.chargeR = true
		self.chargeRTick = GetTickCount()
		self.firstRCast = true
	end
	if self.chargeR == true and rBuff.count == 0 then
		self.chargeR = false
		self.R_target = nil
	end
	if self.chargeR == true then
		if self.CanUseR == true and Game.CanUseSpell(_R) ~= 0 and GetTickCount() - self.chargeRTick > 600 then
			self.CanUseR = false
			self.R_Stacks = self.R_Stacks - 1
			self.firstRCast = false
			self.lastRtick = GetTickCount()
		end
		if self.CanUseR == false and Game.CanUseSpell(_R) == 0 then
			self.CanUseR = true
		end
	end
	if self.chargeR == false then
		if Game.CanUseSpell(_R) == 0 then
			self.R_Stacks = 2+myHero:GetSpellData(_R).level
		end
	end
end

function LazyXerath:Combo()
	if self.chargeR == false then
		if LazyMenu.Combo.useW:Value() then
			self:useW()
		end
		if LazyMenu.Combo.useE:Value() then
			self:useE()
		end
		if LazyMenu.Combo.useQ:Value() then
			self:useQ()
		end
	end
	self:useR()
end

function LazyXerath:Harass()
	if self.chargeR == false then
		local mp = GetPercentMP(myHero)
		if LazyMenu.Harass.useW:Value() and mp > LazyMenu.Harass.manaW:Value() then
			self:useW()
		end
		if LazyMenu.Harass.useE:Value() and mp > LazyMenu.Harass.manaE:Value() then
			self:useE()
		end
		if LazyMenu.Harass.useQ:Value() and (mp > LazyMenu.Harass.manaQ:Value() or self.chargeQ == true) then	
			self:useQ()
		end
	end
end

function LazyXerath:useQ()
	if Game.CanUseSpell(_Q) == 0 and castSpell.state == 0 then
		local target = GetTarget(1500,"AP")
		if target then
			local qPred = GetPred(target,math.huge,0.35 + Game.Latency()/1000)
			local qPred2 = GetPred(target,math.huge,1)
			if qPred and qPred2 then
				if GetDistance(myHero.pos,qPred2) < 1500 then
					self:startQ(target)
				end
				if self.chargeQ == true then
					self:useQclose(target,qPred)
					self:useQCC(target)
					self:useQonTarget(target,qPred)
				end
			end
		end
	end
end

function LazyXerath:useW()
	if Game.CanUseSpell(_W) == 0 and self.chargeQ == false and castSpell.state == 0 then
		local target = GetTarget(self.W.range,"AP")
		if self.lastTarget == nil then self.lastTarget = target end
		if target and (target == self.lastTarget or (GetDistance(target.pos,self.lastTarget.pos) > 400 and GetTickCount() - self.lastTarget_tick > LazyMenu.TargetSwitchDelay:Value())) then
			local wPred = GetPred(target,math.huge,0.5)
			if wPred then
				self:useWdash(target)
				self:useWCC(target)
				self:useWkill(target,wPred)
				self:useWhighHit(target,wPred)
			end
		end
	end
end

function LazyXerath:useE()
	if Game.CanUseSpell(_E) == 0 and self.chargeQ == false and castSpell.state == 0 then
		self:useECC()
		local target = GetTarget(self.E.range,"AP")
		if self.lastTarget == nil then self.lastTarget = target end
		if target and (target == self.lastTarget or (GetDistance(target.pos,self.lastTarget.pos) > 400 and GetTickCount() - self.lastTarget_tick > LazyMenu.TargetSwitchDelay:Value())) then
			local ePred = GetPred(target,self.E.speed,self.E.delay)
			if ePred and target:GetCollision(self.E.width,self.E.speed,self.E.delay) == 0 then
				self:useEdash(target)
				self:useEbrainAFK(target,ePred)
			end
		end
	end
end

function LazyXerath:useR()
	if Game.CanUseSpell(_R) == 0 and self.chargeQ == false and castSpell.state == 0 then
		local target = self:GetRTarget(1100,2200 + 1220*myHero:GetSpellData(_R).level)
		if target then
			self:useRkill(target)
			if ((self.firstRCast == true or self.chargeR ~= true) or (GetTickCount() - self.lastRtick > 500 + LazyMenu.Combo.R.targetChangeDelay:Value() and GetDistance(target.pos,self.R_target.pos) > 750) or (GetDistance(target.pos,self.R_target.pos) <= 850)) and target ~= self.R_target then
				self.R_target = target
			end
			-- if target == self.R_target or (target ~= self.R_target and GetDistance(target.pos,self.R_target.pos) > 600 and GetTickCount() - self.lastRtick > 800 + LazyMenu.Combo.R.targetChangeDelay:Value()) then
			if target == self.R_target then
				if self.chargeR == true and GetTickCount() - self.lastRtick >= 800 + LazyMenu.Combo.R.castDelay:Value() then
					if target and not IsImmune(target) and (Game.Timer() - OnWaypoint(target).time > 0.05 and (Game.Timer() - OnWaypoint(target).time < 0.20 or Game.Timer() - OnWaypoint(target).time > 1.25) or IsImmobileTarget(target) == true or (self.firstRCast == true and OnVision(target).state == false) ) then
						local rPred = GetPred(target,math.huge,0.45)
						if rPred:ToScreen().onScreen then
							CastSpell(HK_R,rPred,2200 + 1320*myHero:GetSpellData(_R).level,100)
							self.R_target = target
						else
							CastSpellMM(HK_R,rPred,2200 + 1320*myHero:GetSpellData(_R).level,100)
							self.R_target = target
						end
					end
				end
			end
		end
	end
end

function LazyXerath:EnemyLoop()
	if aa.state ~= 2 and castSpell.state == 0 then
		for i,target in pairs(GetEnemyHeroes()) do
			if not target.dead and target.isTargetable and target.valid and (OnVision(target).state == true or (OnVision(target).state == false and GetTickCount() - OnVision(target).tick < 500)) then
				if LazyMenu.Killsteal.useQ:Value() then
					if Game.CanUseSpell(_Q) == 0 and GetDistance(myHero.pos,target.pos) < 1500 then
						local hp = target.health + target.shieldAP + target.shieldAD
						local dmg = CalcMagicalDamage(myHero,target,40 + 40*myHero:GetSpellData(_Q).level + (0.75*myHero.ap))
						if hp < dmg then
							if self.chargeQ == false then
								local qPred2 = GetPred(target,math.huge,1.25)
								if GetDistance(qPred2,myHero.pos) < 1500 then
									Control.KeyDown(HK_Q)
								end
							else
								local qPred = GetPred(target,math.huge,0.35 + Game.Latency()/1000)
								self:useQonTarget(target,qPred)
							end
						end
					end
				end
				if LazyMenu.Killsteal.useW:Value() then
					if Game.CanUseSpell(_W) == 0 and GetDistance(myHero.pos,target.pos) < self.W.range then
						local wPred = GetPred(target,math.huge,0.55)
						self:useWkill(target,wPred)
					end
				end
				if LazyMenu.Misc.gapE:Value() and Game.CanUseSpell(_E) == 0 then
					if GetDistance(target.posTo,myHero.pos) < 500 then
						self:useEdash(target)
					end
				end
			end
		end
	end
end

function LazyXerath:startQ(target)
	local start = true
	if LazyMenu.Combo.useE:Value() and Game.CanUseSpell(_E) == 0 and GetDistance(target.pos,myHero.pos) < 650 and target:GetCollision(self.E.width,self.E.speed,self.E.delay) == 0 then start = false end
	if Game.CanUseSpell(_Q) == 0 and self.chargeQ == false and start == true then
		Control.KeyDown(HK_Q)
	end
end

function LazyXerath:useQCC(target)
	if GetDistance(myHero.pos,target.pos) < self.Q.range - 20 then
		if IsImmobileTarget(target) == true then
			ReleaseSpell(HK_Q,target.pos,self.Q.range,100)
			self.lastTarget = target
			self.lastTarget_tick = GetTickCount() + 200
		end
	end
end

function LazyXerath:useQonTarget(target,qPred)
	if Game.Timer() - OnWaypoint(target).time > 0.05 + LazyMenu.Combo.legitQ:Value() and (((Game.Timer() - OnWaypoint(target).time < 0.15 + LazyMenu.Combo.legitQ:Value() or Game.Timer() - OnWaypoint(target).time > 1.0) and OnVision(target).state == true) or (OnVision(target).state == false)) and GetDistance(myHero.pos,qPred) < self.Q.range - target.boundingRadius then
		ReleaseSpell(HK_Q,qPred,self.Q.range,100)
		self.lastTarget = target
		self.lastTarget_tick = GetTickCount() + 200
	end
end

function LazyXerath:useQclose(target,qPred)
	if GetDistance(myHero.pos,qPred) < 750 and Game.Timer() - OnWaypoint(target).time > 0.05 then
		ReleaseSpell(HK_Q,qPred,self.Q.range,75)
		self.lastTarget = target
		self.lastTarget_tick = GetTickCount() + 200
	end
end

function LazyXerath:useWCC(target)
	if GetDistance(myHero.pos,target.pos) < self.W.range - 50 then
		if IsImmobileTarget(target) == true then
			CastSpell(HK_W,target.pos,self.W.range)
			self.lastTarget = target
			self.lastTarget_tick = GetTickCount() + 200
		end
	end
end

function LazyXerath:useWhighHit(target,wPred)
	local afterE = false
	if LazyMenu.Combo.useE:Value() and Game.CanUseSpell(_E) == 0 and myHero:GetSpellData(_W).mana + myHero:GetSpellData(_E).mana <= myHero.mana and GetDistance(myHero.pos,target.pos) <= 750 then
		if target:GetCollision(self.E.width,self.E.speed,self.E.delay) == 0 then
			afterE = true
		end
	end
	if Game.Timer() - OnWaypoint(target).time > 0.05 and (Game.Timer() - OnWaypoint(target).time < 0.20 or Game.Timer() - OnWaypoint(target).time > 1.25) and GetDistance(myHero.pos,wPred) < self.W.range - 50 and afterE == false then
		CastSpell(HK_W,wPred,self.W.range)
		self.lastTarget = target
		self.lastTarget_tick = GetTickCount() + 200
	end
end

function LazyXerath:useWdash(target)
	if OnWaypoint(target).speed > target.ms then
		local wPred = GetPred(target,math.huge,0.5)
		if GetDistance(myHero.pos,wPred) < self.W.range then
			CastSpell(HK_W,wPred,self.W.range)
			self.lastTarget = target
			self.lastTarget_tick = GetTickCount() + 200
		end
	end
end

function LazyXerath:useWkill(target,wPred)
	if Game.Timer() - OnWaypoint(target).time > 0.05 and GetDistance(myHero.pos,wPred) < self.W.range then
		if target.health + target.shieldAP + target.shieldAD < CalcMagicalDamage(myHero,target,30 + 30*myHero:GetSpellData(_W).level + (0.6*myHero.ap)) then
			CastSpell(HK_W,wPred,self.W.range)
		end
	end
end

function LazyXerath:useECC()
	local target = GetTarget(self.E.range,"AP")
	if target then
		if GetDistance(myHero.pos,target.pos) < self.E.range - 20 then
			if IsImmobileTarget(target) == true and target:GetCollision(self.E.width,self.E.speed,0.25) == 0 then
				CastSpell(HK_E,target.pos,5000)
				self.lastTarget = target
				self.lastTarget_tick = GetTickCount() + 200
			end
		end
	end
end

function LazyXerath:useEbrainAFK(target,ePred)
	if Game.Timer() - OnWaypoint(target).time > 0.05 and (Game.Timer() - OnWaypoint(target).time < 0.125 or Game.Timer() - OnWaypoint(target).time > 1.25) and GetDistance(myHero.pos,ePred) < self.E.range then
		if GetDistance(myHero.pos,ePred) <= 800 then
			CastSpell(HK_E,ePred,5000)
			self.lastTarget = target
			self.lastTarget_tick = GetTickCount() + 200
		else
			if target.ms < 340 then
				CastSpell(HK_E,ePred,5000)
				self.lastTarget = target
				self.lastTarget_tick = GetTickCount() + 200
			end
		end
	end
end

function LazyXerath:useEdash(target)
	if OnWaypoint(target).speed > target.ms then
		local ePred = GetPred(target,math.huge,0.5)
		if GetDistance(myHero.pos,ePred) < self.E.range and target:GetCollision(self.E.width,self.E.speed,1) == 0 then
			CastSpell(HK_E,ePred,5000)
			self.lastTarget = target
			self.lastTarget_tick = GetTickCount() + 200
		end
	end
end

function LazyXerath:startR(target)
	local eAallowed = 0
	if GetDistance(myHero.pos,target.pos) < 1200 + 250*myHero:GetSpellData(_R).level and target.visible then
		eAallowed = 1
	end
	if self.chargeR == false and CountEnemiesInRange(myHero.pos,2500) <= eAallowed and GetDistance(myHero.pos,target.pos) > 1300 and not (GetDistance(myHero.pos,target.pos) < 1500 and Game.CanUseSpell(_Q) == 0) and (OnVision(target).state == true or (OnVision(target).state == false and GetTickCount() - OnVision(target).tick < 50)) then
		if LazyMenu.Combo.R.useBlue:Value() then
			local blue = GetItemSlot(myHero,3363)
			if blue > 0 and CanUseSpell(blue) and OnVision(target).state == false and GetDistance(myHero.pos,target.pos) < 3800 then
				local bluePred = GetPred(target,math.huge,0.25)
				CastSpellMM(HK_ITEM_7,bluePred,4000,50)
			else
				CastSpell(HK_R,myHero.pos + Vector(myHero.pos,target.pos):Normalized() * math.random(500,800),2200 + 1320*myHero:GetSpellData(_R).level,50)
			end
		else
			CastSpell(HK_R,myHero.pos + Vector(myHero.pos,target.pos):Normalized() * math.random(500,800),2200 + 1320*myHero:GetSpellData(_R).level,50)
		end
		self.R_target = target
		self.firstRCast = true
	end
end

function LazyXerath:useRkill(target)
	if self.chargeR == false and LazyMenu.Combo.R.BlackList[target.charName] ~= nil and not LazyMenu.Combo.R.useRself:Value() and LazyMenu.Combo.R.BlackList[target.charName]:Value() == false then
		local rDMG = CalcMagicalDamage(myHero,target,170+30*myHero:GetSpellData(_R).level + (myHero.ap*0.43))*(2+myHero:GetSpellData(_R).level - LazyMenu.Combo.R.safeR:Value())
		if target.health + target.shieldAP + target.shieldAD < rDMG and CountAlliesInRange(target.pos,700) == 0 then
			local delay =  math.floor((target.health + target.shieldAP + target.shieldAD)/(rDMG/(2+myHero:GetSpellData(_R).level))) * 0.8
			if GetDistance(myHero.pos,target.pos) + target.ms*delay <= 2200 + 1320*myHero:GetSpellData(_R).level and not IsImmune(target) then
				self:startR(target)
			end
		end
	end
end

function LazyXerath:useRonKey()
	if LazyMenu.Combo.R.useRkey:Value() then
		if self.chargeR == true and Game.CanUseSpell(_R) == 0 then
			local target = GetTarget(500,"AP",mousePos)
			if not target then target = GetTarget(2200 + 1320*myHero:GetSpellData(_R).level,"AP") end
			if target and not IsImmune(target) then
				local rPred = GetPred(target,math.huge,0.45)
				if rPred:ToScreen().onScreen then
					CastSpell(HK_R,rPred,2200 + 1320*myHero:GetSpellData(_R).level,100)
					self.R_target = target
					self.R_target_tick = GetTickCount()
				else
					CastSpellMM(HK_R,rPred,2200 + 1320*myHero:GetSpellData(_R).level,100)
					self.R_target = target
					self.R_target_tick = GetTickCount()
				end
			end
		end
	end
end

local _targetSelect
local _targetSelectTick = GetTickCount()
function LazyXerath:GetRTarget(closeRange,maxRange)
local tick = GetTickCount()
if tick - _targetSelectTick > 200 then
	_targetSelectTick = tick
	local killable = {}
		for i,hero in pairs(GetEnemyHeroes()) do
			if hero.isEnemy and hero.valid and not hero.dead and hero.isTargetable and (OnVision(hero).state == true or (OnVision(hero).state == false and GetTickCount() - OnVision(hero).tick < 50)) and hero.isTargetable and GetDistance(myHero.pos,hero.pos) < maxRange then
				local stacks = self.R_Stacks
				local rDMG = CalcMagicalDamage(myHero,hero,170+30*myHero:GetSpellData(_R).level + (myHero.ap*0.43))*stacks
				if hero.health + hero.shieldAP + hero.shieldAD < rDMG then
					killable[hero.networkID] = hero
				end
			end
		end
		local target
		local p = 0
		local oneshot = false
		for i,kill in pairs(killable) do
			if (CalcMagicalDamage(myHero,kill,170+30*myHero:GetSpellData(_R).level + (myHero.ap*0.43)) > kill.health + kill.shieldAP + kill.shieldAD) then
				if p < Priority(kill.charName) then
					p = Priority(kill.charName)
					target = kill
					oneshot = true
				end
			else
				if p < Priority(kill.charName) and oneshot == false then
					p = Priority(kill.charName)
					target = kill
				end
			end
		end
		if target then
			_targetSelect = target
			return _targetSelect
		end
	if CountEnemiesInRange(myHero.pos,closeRange) >= 2 then
		local t = GetTarget(closeRange,"AP")
		_targetSelect = t
		return _targetSelect
	else
		local t = GetTarget(maxRange,"AP")
		_targetSelect = t
		return _targetSelect
	end
end

if _targetSelect and not _targetSelect.dead then
	return _targetSelect
else
	_targetSelect = GetTarget(maxRange,"AP")
	return _targetSelect
end

end

function OnLoad() LazyXerath() end
