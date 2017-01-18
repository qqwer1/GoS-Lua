local gankAlert = MenuElement({id = "gaMenu", name = "Movement Tracker", type = MENU ,leftIcon = "http://i.imgur.com/SK4bt6Q.png" })
	gankAlert:MenuElement({id = "gui", name = "Interface", type = MENU ,leftIcon = "http://i.imgur.com/rRpSWA6.png" })
		gankAlert.gui:MenuElement({id = "drawGUI", name = "Draw Interface", value = true})
		gankAlert.gui:MenuElement({id = "vertical", name = "Draw Vertical", value = true})
		gankAlert.gui:MenuElement({id = "x", name = "X", value = 50, min = 0, max = Game.Resolution().x, step = 1})
		gankAlert.gui:MenuElement({id = "y", name = "Y", value = 50, min = 0, max = Game.Resolution().y, step = 1})
		
	gankAlert:MenuElement({id = "circle", name = "Movement Circle", type = MENU, leftIcon = "http://i.imgur.com/CAHgS45.png" })	
		gankAlert.circle:MenuElement({id = "draw", name = "Draw Circle", value = true})
		gankAlert.circle:MenuElement({id = "drawWP", name = "Draw last waypoint", value = true})	
		gankAlert.circle:MenuElement({id = "screen", name = "On Screen", value = true, leftIcon = "http://puu.sh/rGpSj/e92234a9af.png" })
		gankAlert.circle:MenuElement({id = "minimap", name = "On Minimap", value = true, leftIcon = "http://puu.sh/rGpKK/e60ba3daa3.png" })
		
	gankAlert:MenuElement({id = "alert", name = "Gank Alert", type = MENU ,leftIcon = "http://i.imgur.com/fXU3MKH.png" })
		gankAlert.alert:MenuElement({id = "range", name = "Detection Range", value = 2500, min = 1500, max = 4000, step = 10})
		gankAlert.alert:MenuElement({id = "drawGank", name = "Gank Alert", value = true})
		gankAlert.alert:MenuElement({id = "drawGankFOW", name = "FOW Gank Alert", value = true})
		
	
	gankAlert:MenuElement({id = "drawRecall", name = "Predict Recall Position", value = true ,leftIcon = "http://i.imgur.com/iYHoZKb.png"})
		
		

local function EnemiesAround(pos,range)
	local x = 0
	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero and not hero.dead and hero.isEnemy and hero.pos:DistanceTo(pos) < range and hero.visible then
			x = x + 1
		end
	end
	return x
end

local function EnemiesInvisible(pos,range)
	local x = {}
	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero and hero.valid and hero.isEnemy and hero.pos:DistanceTo(pos) < range and not hero.visible then
			table.insert(x, hero)
		end
	end
	return x
end

-------------------------

local FOWGank = Sprite("MovementTracker\\FOWGank.png")

local GankGUI = Sprite("MovementTracker\\GankGUI.png")
local GankHP = Sprite("MovementTracker\\GankHP.png")
local GankMANA = Sprite("MovementTracker\\GankMANA.png")
local ultOFF = Sprite("MovementTracker\\ultOFF.png")
local ultON = Sprite("MovementTracker\\ultON.png")
local Shadow = Sprite("MovementTracker\\Shadow.png")
local nrGUI = Sprite("MovementTracker\\nrGUI.png")
local recallGUI = Sprite("MovementTracker\\recallGUI.png")

local gankTOP = Sprite("MovementTracker\\gankTOP.png")
local gankMID = Sprite("MovementTracker\\gankMID.png")
local gankBOT = Sprite("MovementTracker\\gankBOT.png")
local gankShadow = Sprite("MovementTracker\\gankShadow.png")

local recallMini = Sprite("MovementTracker\\recallMini.png",0.5)
local recallMiniC = Sprite("MovementTracker\\recallMini.png",0.5)
local miniRed = Sprite("MovementTracker\\miniRed.png",0.5)
local miniRedC = Sprite("MovementTracker\\miniRed.png",0.5)

local bigRed = Sprite("MovementTracker\\miniRed.png")

local champSprite = {}
local champSpriteSmall = {}
local champSpriteMini = {}
local champSpriteMiniC = {}

local midX = Game.Resolution().x/2
local midY = Game.Resolution().y/2

-------------------------

local minionEXP = {
 ["SRU_OrderMinionSuper"]	= 97,
 ["SRU_OrderMinionSiege"] 	= 92,
 ["SRU_OrderMinionMelee"] 	= 58.88,
 ["SRU_OrderMinionRanged"] 	= 29.44,
 ["SRU_ChaosMinionSuper"]	= 97,
 ["SRU_ChaosMinionSiege"] 	= 92,
 ["SRU_ChaosMinionMelee"] 	= 58.88,
 ["SRU_ChaosMinionRanged"] 	= 29.44,
}

local expT = {
 ["SRU_OrderMinionSiege"] 	= {[92] = 1, [60] = 2, [40] = 3, [30] = 4, [24] = 5} ,
 ["SRU_OrderMinionMelee"] 	= {[58] = 1, [38] = 2, [25] = 3, [19] = 4, [15] = 5} ,
 ["SRU_OrderMinionRanged"] 	= {[29] = 1, [19] = 2, [13] = 3, [9] = 4, [8] = 5} ,
}

local expMulti = {
 [1] = 1, [2] = 0.652, [3] = 0.4346, [4] = 0.326, [5] = 0.2608, [6] = 0.1337
}
 
local enemies = {}

local on_rip_tick = 0
local before_rip_tick = 50000
local ripMinions = {}
local t = {}

local oldExp = {}
local newExp = {}
local eT = {}

local invChamp = {}
local iCanSeeYou = {}
local isRecalling = {}
local OnGainVision = {}

local aBasePos
local eBasePos

-- print(myHero.pos)

local mapPos = {
["BOT"] = {Vector(7832,49.4456,1252), Vector(10396,50.1820,1464), Vector(12650,51.5588,2466), Vector(13598,52.5385,4840), Vector(13580,52.3063,7024) },
["MID"] = {Vector(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0) },
["TOP"] = {Vector(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0) },
["BASE"] = {Vector(0,0,0), Vector(0,0,0) }
}

local add = 0

function OnLoad()

if myHero.team == 100 then
	aBasePos = Vector(415,182,415)
	eBasePos = Vector(14302,172,14387.8)
else
	aBasePos = Vector(14302,172,14387.8)
	eBasePos = Vector(415,182,415)
end

DelayAction(function()
	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero and hero.isEnemy and eT[hero.networkID] == nil then	
			add = add + 1
			champSprite[hero.charName] = Sprite("Champions\\"..hero.charName..".png", 1.2)
			champSpriteSmall[hero.charName] = Sprite("Champions\\"..hero.charName..".png", 1)
			champSpriteMini[hero.charName] = Sprite("Champions\\"..hero.charName..".png", .5)
			champSpriteMiniC[hero.charName] = Sprite("Champions\\"..hero.charName..".png", .5)
			invChamp[hero.networkID] = {champ = hero, lastTick = GetTickCount(), lastWP = Vector(0,0,0), lastPos = hero.pos or eBasePos, where = "will be added.", status = hero.visible, n = add }
			iCanSeeYou[hero.networkID] = {tick = 0, champ = hero, number = add, draw = false}
			isRecalling[hero.networkID] = {status = false, tick = 0, proc = nil, spendTime = 0}
			OnGainVision[hero.networkID] = {status = not hero.visible, tick = 0}
			oldExp[hero.networkID] = 0
			newExp[hero.networkID] = 0
			table.insert(enemies, hero)
			eT[hero.networkID] = {champ = hero, fow = 0, saw = 0,}
		end
	end
end,30)

for i = 1, Game.HeroCount() do
	local hero = Game.Hero(i)
	if hero and hero.isEnemy then
		add = add + 1
		champSprite[hero.charName] = Sprite("Champions\\"..hero.charName..".png", 1.2)
		champSpriteSmall[hero.charName] = Sprite("Champions\\"..hero.charName..".png", 1)
		champSpriteMini[hero.charName] = Sprite("Champions\\"..hero.charName..".png", .5)
		champSpriteMiniC[hero.charName] = Sprite("Champions\\"..hero.charName..".png", .5)
		invChamp[hero.networkID] = {champ = hero, lastTick = GetTickCount(), lastWP = Vector(0,0,0), lastPos = hero.pos or eBasePos, where = "will be added.", status = hero.visible, n = add }
		iCanSeeYou[hero.networkID] = {tick = 0, champ = hero, number = add, draw = false}
		isRecalling[hero.networkID] = {status = false, tick = 0, proc = nil, spendTime = 0}
		OnGainVision[hero.networkID] = {status = not hero.visible, tick = 0}
		oldExp[hero.networkID] = 0
		newExp[hero.networkID] = 0
		table.insert(enemies, hero)
		eT[hero.networkID] = {champ = hero, fow = 0, saw = 0,}
	end
end


function OnTick()

	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		--OnGainVision
		if invChamp[hero.networkID] ~= nil and invChamp[hero.networkID].status == false and hero.visible and not hero.dead then
			if myHero.pos:DistanceTo(hero.pos) <= gankAlert.alert.range:Value() + 100 and GetTickCount()-invChamp[hero.networkID].lastTick > 5000 then
				OnGainVision[hero.networkID].status = true
				OnGainVision[hero.networkID].tick = GetTickCount()
			end
			newExp[hero.networkID] = hero.levelData.exp
			oldExp[hero.networkID] = hero.levelData.exp
		end
		if hero and not hero.dead and hero.isEnemy and hero.visible then
			invChamp[hero.networkID].status = hero.visible
			isRecalling[hero.networkID].spendTime = 0
			newExp[hero.networkID] = hero.levelData.exp
			local hehTicker = GetTickCount()
			if (before_rip_tick + 10000) < hehTicker then
				oldExp[hero.networkID] = hero.levelData.exp
			before_rip_tick = hehTicker
			end
		end
		--OnLoseVision
		if invChamp[hero.networkID] ~= nil and invChamp[hero.networkID].status == true and not hero.visible and not hero.dead then
			invChamp[hero.networkID].lastTick = GetTickCount()
			invChamp[hero.networkID].lastWP = hero.posTo
			invChamp[hero.networkID].lastPos = hero.pos
			invChamp[hero.networkID].status = false
		end
	end
				
	for i = 1, Game.MinionCount() do
		local minion = Game.Minion(i)
		
		if minion.pos:DistanceTo(myHero.pos) < 2500 and minion.isAlly and not minion.dead then
			t[minion.networkID] = minion
		end
		
		local heheTicker = GetTickCount()
		if (on_rip_tick + 1000) < heheTicker then
			for i,v in pairs(t) do
				if v.dead then
					table.insert(ripMinions, v)
				end
			end
			on_rip_tick = heheTicker
			t = {}
		end
		
	end
	
-- MULTI EXP TRACK
	for i,hero in pairs(enemies) do
		if hero and not hero.dead and hero.pos:DistanceTo(myHero.pos) < 2500 and hero.isEnemy and hero.visible then
			local gainEXP = 0
			local gotEXP = newExp[hero.networkID] - oldExp[hero.networkID]
			for n,v in pairs(ripMinions) do
				if hero.pos:DistanceTo(v.pos) <= 1600 then
					if minionEXP[v.charName] ~= nil then
						gainEXP = gainEXP + minionEXP[v.charName]
					end
				end
			end
			if gainEXP > 0 then	
				for a,m in pairs(expMulti) do
					if math.floor(gotEXP) == math.floor(gainEXP*m) then
						eT[hero.networkID].fow = a - EnemiesAround(hero.pos,1600)
						eT[hero.networkID].saw = EnemiesAround(hero.pos,1600)
					end
				end
				oldExp[hero.networkID] = hero.levelData.exp
				DelayAction(function()
					ripMinions = {}
				end,0)
			end
		end
	end
	
end

function OnDraw()
-- CIRCLE
if gankAlert.circle.draw:Value() and (gankAlert.circle.screen:Value() or gankAlert.circle.minimap:Value()) then
	for i,v in pairs(invChamp) do
		if v.status == false and not v.champ.dead then
			local recallTime = 0
			if isRecalling[v.champ.networkID].status == true then
				recallTime = GetTickCount()-isRecalling[v.champ.networkID].tick
			end
			local timer = (GetTickCount() - v.lastTick - isRecalling[v.champ.networkID].spendTime - recallTime)/1000
			local vec = v.lastPos + (Vector(v.lastPos,myHero.pos)/v.lastPos:DistanceTo(myHero.pos))*v.champ.ms*timer
			if v.champ.ms*timer < 10000 and v.champ.ms*timer > 0 and vec:DistanceTo(v.lastPos) < myHero.pos:DistanceTo(v.lastPos) + 2000 then
				if gankAlert.circle.screen:Value() then
					local d2 = v.lastPos:ToScreen()
					if d2.onScreen then
						bigRed:Draw(d2.x - 25, d2.y - 25)
						champSpriteSmall[v.champ.charName]:Draw(d2.x - 25, d2.y - 25)
					end
					if gankAlert.circle.drawWP:Value() then
						if v.lastPos ~= eBasePos and v.champ.pos:DistanceTo(eBasePos) > 250 then
							local d2_to = v.champ.posTo:ToScreen()
							if d2_to.onScreen or d2.onScreen then
								Draw.Line(d2,d2_to,2 ,Draw.Color(255,255,28,28))
							end
							if v.lastPos ~= eBasePos and d2_to.onScreen then
								champSpriteMiniC[v.champ.charName]:Draw(d2_to.x - 12.5, d2_to.y - 12.5)
								miniRedC:Draw(d2_to.x - 12.5, d2_to.y - 12.5)
							end
						end
					end
					Draw.Circle(v.lastPos,v.champ.ms*timer,Draw.Color(180,225,0,30))
					Draw.Rect(vec:To2D().x - 6,vec:To2D().y-3,8*string.len(v.champ.charName),20,Draw.Color(200,25,25,25))
					Draw.Text(v.champ.charName, 14,vec:To2D())
				end
			end
			if v.champ.ms*timer < 10000 and v.champ.ms*timer > 0 then
				if gankAlert.circle.minimap:Value() then
					champSpriteMini[v.champ.charName]:SetColor(Draw.Color(240,158,158,158))
					if v.lastPos ~= eBasePos then
						champSpriteMini[v.champ.charName]:Draw(v.champ.posMM.x - 12.5,v.champ.posMM.y - 12)
						miniRed:Draw(v.champ.posMM.x - 12,v.champ.posMM.y - 12)
						if isRecalling[v.champ.networkID].status == true then
							-- Draw.CircleMinimap(v.lastPos,900, 2,Draw.Color(255,225,0,10))
							local r = 25/isRecalling[v.champ.networkID].proc.totalTime * (isRecalling[v.champ.networkID].proc.totalTime - (GetTickCount()-isRecalling[v.champ.networkID].tick))
							local recallCut = {x = 0, y = 25, w = 25, h = r }
							recallMini:Draw(recallCut,v.champ.posMM.x - 12,v.champ.posMM.y - 12 + 25)
						end
					end
					if v.champ.ms*timer > 720 then
						Draw.CircleMinimap(v.lastPos,v.champ.ms*timer, 1,Draw.Color(180,225,0,30))
					end
				end
			end
		end
	end
end

-- RecallPos (add max disntace depends on :goTo)
if gankAlert.drawRecall:Value() then
	for i,v in pairs(invChamp) do
		if v.status == false and not v.champ.dead then
			if isRecalling[v.champ.networkID].status == true then
				local recall = isRecalling[v.champ.networkID]
				local spend_to_recall = recall.tick - v.lastTick - 500
				if spend_to_recall < 2000 then
					local recallPos = v.lastPos + (Vector(v.lastPos,v.champ.posTo)/v.lastPos:DistanceTo(v.champ.posTo))*(v.champ.ms*spend_to_recall/1000)
					if recallPos:DistanceTo(v.lastPos) < spend_to_recall*v.champ.ms then
						local d2 = recallPos:ToScreen()
						local b4_d2 = v.lastPos:ToScreen()
						if d2.onScreen or b4_d2.onScreen then
							Draw.Line(d2,b4_d2,4 ,Draw.Color(255,0,128,255))
							champSpriteMini[v.champ.charName]:SetColor(Draw.Color(255,255,255,255))
							champSpriteMini[v.champ.charName]:Draw(d2.x - 12.5,d2.y - 12.5)
							local r = 25/isRecalling[v.champ.networkID].proc.totalTime * (isRecalling[v.champ.networkID].proc.totalTime - (GetTickCount()-isRecalling[v.champ.networkID].tick))
							local recallCut = {x = 0, y = 25, w = 25, h = r }
							recallMiniC:Draw(recallCut,d2.x - 12.5,d2.y - 12.5 + 25)
						end
					end
				end
			end
		end
	end
end

-- GUI
if gankAlert.gui.drawGUI:Value() then
	if gankAlert.gui.vertical:Value() then
		for i,v in pairs(invChamp) do
			local d = v.champ.dead
			champSprite[v.champ.charName]:Draw(gankAlert.gui.x:Value() + 12,gankAlert.gui.y:Value() + 75*(v.n-1) + 6)
			if v.status == false and not d then
				local timer = math.floor((GetTickCount() - v.lastTick)/1000)
				Shadow:Draw(gankAlert.gui.x:Value() + 15,gankAlert.gui.y:Value() + 75*(v.n-1) + 15)
				if timer < 350 then
					Draw.Text( timer , 27, gankAlert.gui.x:Value() + 42 - 6.34*string.len(timer),gankAlert.gui.y:Value() + 21 + 75*(v.n-1), Draw.Color(200,200,0,30))
				else
					Draw.Text( "AFK" , 25, gankAlert.gui.x:Value() + 43 - 6.34*3,gankAlert.gui.y:Value() + 21 + 75*(v.n-1), Draw.Color(200,225,0,30))
				end
				local eTimer = math.floor(v.lastPos:DistanceTo(myHero.pos)/v.champ.ms) - timer
				if eTimer > 0 then
					Draw.Rect(gankAlert.gui.x:Value() + 30,gankAlert.gui.y:Value() + 67 + 75*(v.n-1), 22, 14, Draw.Color(180,1,1,1))
					Draw.Text( eTimer , 12, gankAlert.gui.x:Value() + 39 - 3*(string.len(eTimer)-1),gankAlert.gui.y:Value() + 67 + 75*(v.n-1), Draw.Color(200,225,0,30))
				end
			elseif d then
				Shadow:Draw(gankAlert.gui.x:Value() + 15,gankAlert.gui.y:Value() + 75*(v.n-1) + 15)
			end
			
			GankGUI:Draw(gankAlert.gui.x:Value(),gankAlert.gui.y:Value() + 75*(v.n-1))
			if d then
				Draw.Text( "DEAD" , 10, gankAlert.gui.x:Value() + 29 ,gankAlert.gui.y:Value() + 55 + 75*(v.n-1), Draw.Color(200,255,255,255))
			elseif (v.lastPos == eBasePos or v.lastPos:DistanceTo(eBasePos) < 250) and v.status == false then
				Draw.Text( "BASE" , 10, gankAlert.gui.x:Value() + 30 ,gankAlert.gui.y:Value() + 55 + 75*(v.n-1), Draw.Color(200,255,255,255))
			elseif v.status == false then
				Draw.Text( "MISS" , 10, gankAlert.gui.x:Value() + 30 ,gankAlert.gui.y:Value() + 55 + 75*(v.n-1), Draw.Color(200,255,255,255))
			end
			
			if not d then
				
				if v.champ:GetSpellData(3).currentCd == 0 and v.champ:GetSpellData(3).level > 0 then
					ultON:Draw(gankAlert.gui.x:Value() + 35,gankAlert.gui.y:Value() + 75*(v.n-1) + 8)
				else
					ultOFF:Draw(gankAlert.gui.x:Value() + 35,gankAlert.gui.y:Value() + 75*(v.n-1) + 8)
				end
				
				local CutHP = {x = 0, y = 47, w = 17, h = 47 - 47*(v.champ.health/v.champ.maxHealth)}
				GankHP:Draw(CutHP, gankAlert.gui.x:Value()+ 10,gankAlert.gui.y:Value() + 11 + 47 + 75*(v.n-1))
				
				local manaMulti = v.champ.mana/v.champ.maxMana
				if v.champ.maxMana == 0 then
					manaMulti = 0
				end
				local CutMANA = {x = 0, y = 47, w = 17, h = 47 - 47*(manaMulti)}
				GankMANA:Draw(CutMANA, gankAlert.gui.x:Value()+ 55,gankAlert.gui.y:Value() + 11 + 47 + 75*(v.n-1))
				
				nrGUI:Draw(gankAlert.gui.x:Value()+ 16,gankAlert.gui.y:Value() - 32 + 47 + 75*(v.n-1))
				if isRecalling[v.champ.networkID].status == true then
					local r = 38/isRecalling[v.champ.networkID].proc.totalTime * (isRecalling[v.champ.networkID].proc.totalTime - (GetTickCount()-isRecalling[v.champ.networkID].tick))
					local recallCut = {x = 0, y = 38, w = 50, h = r }		
					recallGUI:Draw(recallCut, gankAlert.gui.x:Value()+ 16,gankAlert.gui.y:Value() - 32 + 38 + 47 + 75*(v.n-1))
				end
			end

		end
	else
		for i,v in pairs(invChamp) do
			local d = v.champ.dead
			champSprite[v.champ.charName]:Draw(gankAlert.gui.x:Value() + 12  + 75*(v.n-1),gankAlert.gui.y:Value() + 6)
			
			if v.status == false and not d then
				local timer = math.floor((GetTickCount() - v.lastTick)/1000)
				Shadow:Draw(gankAlert.gui.x:Value() + 15 + 75*(v.n-1) ,gankAlert.gui.y:Value() + 15)
				if timer < 350 then
					Draw.Text( timer , 27, gankAlert.gui.x:Value() + 42 - 6.34*string.len(timer) + 75*(v.n-1) ,gankAlert.gui.y:Value() + 21, Draw.Color(200,200,0,30))
				else
					Draw.Text( "AFK" , 25, gankAlert.gui.x:Value() + 43 - 6.34*3 + 75*(v.n-1) ,gankAlert.gui.y:Value() + 21, Draw.Color(200,225,0,30))
				end
				local eTimer = math.floor(v.lastPos:DistanceTo(myHero.pos)/v.champ.ms) - timer
				if eTimer > 0 then
					Draw.Rect(gankAlert.gui.x:Value() + 30 + 75*(v.n-1) ,gankAlert.gui.y:Value() + 67, 22, 14, Draw.Color(180,1,1,1))
					Draw.Text( eTimer , 12, gankAlert.gui.x:Value() + 39 - 3*(string.len(eTimer)-1) + 75*(v.n-1) ,gankAlert.gui.y:Value() + 67, Draw.Color(200,225,0,30))
				end
			elseif d then
				Shadow:Draw(gankAlert.gui.x:Value() + 15 + 75*(v.n-1) ,gankAlert.gui.y:Value() + 15)
			end
			
			GankGUI:Draw(gankAlert.gui.x:Value() + 75*(v.n-1),gankAlert.gui.y:Value())
			
			if d then
				Draw.Text( "DEAD" , 10, gankAlert.gui.x:Value() + 29 + 75*(v.n-1),gankAlert.gui.y:Value() + 55, Draw.Color(200,255,255,255))
			elseif (v.lastPos == eBasePos or v.lastPos:DistanceTo(eBasePos) < 250) and v.status == false then
				Draw.Text( "BASE" , 10, gankAlert.gui.x:Value() + 30 + 75*(v.n-1),gankAlert.gui.y:Value() + 55, Draw.Color(200,255,255,255))
			elseif v.status == false then
				Draw.Text( "MISS" , 10, gankAlert.gui.x:Value() + 30 + 75*(v.n-1),gankAlert.gui.y:Value() + 55, Draw.Color(200,255,255,255))
			end
			
			if not d then
			
				if v.champ:GetSpellData(3).currentCd == 0 and v.champ:GetSpellData(3).level > 0 then
					ultON:Draw(gankAlert.gui.x:Value() + 35 + 75*(v.n-1),gankAlert.gui.y:Value() + 8)
				else
					ultOFF:Draw(gankAlert.gui.x:Value() + 35 + 75*(v.n-1),gankAlert.gui.y:Value() + 8)
				end
				
				local CutHP = {x = 0, y = 47, w = 17, h = 47 - 47*(v.champ.health/v.champ.maxHealth)}
				GankHP:Draw(CutHP, gankAlert.gui.x:Value()+ 10 + 75*(v.n-1),gankAlert.gui.y:Value() + 11 + 47)
				local manaMulti = v.champ.mana/v.champ.maxMana
				if v.champ.maxMana == 0 then
					manaMulti = 0
				end
				local CutMANA = {x = 0, y = 47, w = 17, h = 47 - 47*(manaMulti)}
				GankMANA:Draw(CutMANA, gankAlert.gui.x:Value()+ 55 + 75*(v.n-1),gankAlert.gui.y:Value() + 11 + 47)
				
				nrGUI:Draw(gankAlert.gui.x:Value()+ 16 + 75*(v.n-1),gankAlert.gui.y:Value() - 32 + 47)
				if isRecalling[v.champ.networkID].status == true then
					local r = 38/isRecalling[v.champ.networkID].proc.totalTime * (isRecalling[v.champ.networkID].proc.totalTime - (GetTickCount()-isRecalling[v.champ.networkID].tick))
					local recallCut = {x = 0, y = 38, w = 50, h = r }		
					recallGUI:Draw(recallCut, gankAlert.gui.x:Value()+ 16 + 75*(v.n-1),gankAlert.gui.y:Value() - 32 + 38 + 47)
				end
			end
			
		end
	end
end

-- GANK ALERT
if gankAlert.alert.drawGank:Value() and not myHero.dead then 
	local drawIT = false
	local nDraws = -1
	for i,v in pairs(invChamp) do
	
		if GetTickCount() - OnGainVision[v.champ.networkID].tick > 4000 and OnGainVision[v.champ.networkID].status == true then
			OnGainVision[v.champ.networkID].status = false
		end
		-- if OnGainVision[v.champ.networkID].status == true and GetTickCount() - OnGainVision[v.champ.networkID].tick <= 4000 and GetTickCount()-v.lastTick > 5000 and not v.champ.dead then
		if OnGainVision[v.champ.networkID].status == true and not v.champ.dead then
			if v.champ.pos:DistanceTo(myHero.pos) < gankAlert.alert.range:Value() then
				iCanSeeYou[v.champ.networkID].draw = true
				if GetTickCount() - OnGainVision[v.champ.networkID].tick > 3500 then
					OnGainVision[v.champ.networkID].status = false
					iCanSeeYou[v.champ.networkID].draw = false
				end
				drawIT = true
				nDraws = nDraws + 1
				iCanSeeYou[v.champ.networkID].number = nDraws
			end
		end
	end
	
	if drawIT == true then
		gankMID:Draw(midX - 152, midY/3)
		for i,v in pairs(iCanSeeYou) do
			if v.draw == true then
				gankShadow:Draw(midX - 25 - (50*nDraws/2) + 50*v.number ,midY/3 +1)
				champSpriteSmall[v.champ.charName]:Draw(midX - 25 - (50*nDraws/2) + 50*v.number ,midY/3 +1) -- need some work!!
			end
		end
		gankTOP:Draw(midX - 152, midY/3 - 14)
		gankBOT:Draw(midX - 152, midY/3 + 45)
	end
end

-- FOW
if gankAlert.alert.drawGankFOW:Value() then
	for i,v in pairs(eT) do
		if v.fow > 0 and v.champ.pos2D.onScreen and v.champ.pos:DistanceTo(myHero.pos) < 2500 and v.fow >= EnemiesAround(myHero.pos,2500) and v.champ.visible then
			Draw.Rect( v.champ.pos2D.x + 30,v.champ.pos2D.y+4, 22, 14, Draw.Color(180,1,1,1))
			Draw.Text("+"..v.fow, 10 , v.champ.pos2D.x + 36,v.champ.pos2D.y+6, Draw.Color(250,225,0,30))
			FOWGank:Draw(v.champ.pos2D.x - 36,v.champ.pos2D.y)
			for n,e in pairs(EnemiesInvisible(v.champ.pos, 1600)) do
				Draw.Text(e.charName, 10 , v.champ.pos2D.x - 30,v.champ.pos2D.y + 20*n, Draw.Color(250,225,0,30))
			end
		end
		if v.fow < EnemiesAround(myHero.pos,2000) and v.champ.visible and v.fow > 0 then
			-- print("reset FOW")
			v.fow = 0
		end
	end
end

end

function OnProcessRecall(unit,recall)
if isRecalling[unit.networkID] == nil then return end
	if recall.isFinish == false and recall.isStart == true and unit.type == "AIHeroClient" and isRecalling[unit.networkID] ~= nil then
		isRecalling[unit.networkID].status = true
		isRecalling[unit.networkID].tick = GetTickCount()
		isRecalling[unit.networkID].proc = recall
	elseif recall.isFinish == true and recall.isStart == false and unit.type == "AIHeroClient" and isRecalling[unit.networkID] ~= nil then
		isRecalling[unit.networkID].status = false
		isRecalling[unit.networkID].proc = recall
		isRecalling[unit.networkID].spendTime = 0
	elseif recall.isFinish == false and recall.isStart == false and unit.type == "AIHeroClient" and isRecalling[unit.networkID] ~= nil and isRecalling[unit.networkID].status == true then
		isRecalling[unit.networkID].status = false
		isRecalling[unit.networkID].proc = recall
		if not unit.visible then
			isRecalling[unit.networkID].spendTime = isRecalling[unit.networkID].spendTime + recall.passedTime
		end
	else
		if isRecalling[unit.networkID] ~= nil and isRecalling[unit.networkID].status == false then
			isRecalling[unit.networkID].status = true
			isRecalling[unit.networkID].tick = GetTickCount()
			isRecalling[unit.networkID].proc = recall
		end
	end
	if recall.isFinish == true and recall.isStart == false and unit.type == "AIHeroClient" and invChamp[unit.networkID] ~= nil then
		invChamp[unit.networkID].lastPos = eBasePos
		invChamp[unit.networkID].lastTick = GetTickCount()
	end
end

end
