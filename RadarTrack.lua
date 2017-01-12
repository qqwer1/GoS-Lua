-- RadarTrack

if not DirExists(SPRITE_PATH.."RadarHack\\") then
	CreateDir(SPRITE_PATH.."RadarHack\\") 
end

local enemyCircle
local allyCircle
local miss
local placeHolder
local hpbar
local hp
local shadow

if FileExist(SPRITE_PATH.."RadarHack//eC.png") then
	enemyCircle = CreateSpriteFromFile("RadarHack//eC.png",1)
else
	DownloadFileAsync("https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/Sprites/RadarHack/eC.png",SPRITE_PATH.."RadarHack//eC.png", function() 	DelayAction(function() enemyCircle = CreateSpriteFromFile("RadarHack//eC.png",1) end,0.1) return end)
end
if FileExist(SPRITE_PATH.."RadarHack//aC.png") then
	allyCircle = CreateSpriteFromFile("RadarHack//aC.png",1)
else
	DownloadFileAsync("https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/Sprites/RadarHack/aC.png",SPRITE_PATH.."RadarHack//aC.png", function() 	DelayAction(function() allyCircle = CreateSpriteFromFile("RadarHack//aC.png",1) end,0.1) return end)
end
if FileExist(SPRITE_PATH.."RadarHack//miss.png") then
	miss = CreateSpriteFromFile("RadarHack//miss.png",1)
else
	DownloadFileAsync("https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/Sprites/RadarHack/miss.png",SPRITE_PATH.."RadarHack//miss.png", function() DelayAction(function() miss = CreateSpriteFromFile("RadarHack//miss.png",1) end,0.1) return end)
end
if FileExist(SPRITE_PATH.."RadarHack//placeHolder.png") then
	placeHolder = CreateSpriteFromFile("RadarHack//placeHolder.png",1)
else
	DownloadFileAsync("https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/Sprites/RadarHack/placeHolder.png",SPRITE_PATH.."RadarHack//placeHolder.png", function() DelayAction(function() placeHolder = CreateSpriteFromFile("RadarHack//placeHolder.png",1) end, 0.1) return end)
end
if FileExist(SPRITE_PATH.."RadarHack//hpbar.png") then
	hpbar = CreateSpriteFromFile("RadarHack//hpbar.png",1)
else
	DownloadFileAsync("https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/Sprites/RadarHack/hpbar.png",SPRITE_PATH.."RadarHack//hpbar.png", function() DelayAction(function() hpbar = CreateSpriteFromFile("RadarHack//hpbar.png",1) end, 0.1) return end)
end
if FileExist(SPRITE_PATH.."RadarHack//hp.png") then
	hp = CreateSpriteFromFile("RadarHack//hp.png",1)
else
	DownloadFileAsync("https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/Sprites/RadarHack/hp.png",SPRITE_PATH.."RadarHack//hp.png", function() DelayAction(function() hp = CreateSpriteFromFile("RadarHack//hp.png",1) end, 0.1) return end)
end
if FileExist(SPRITE_PATH.."RadarHack//shadow.png") then
	shadow = CreateSpriteFromFile("RadarHack//shadow.png",1)
else
	DownloadFileAsync("https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/Sprites/RadarHack/shadow.png",SPRITE_PATH.."RadarHack//shadow.png", function() DelayAction(function() shadow = CreateSpriteFromFile("RadarHack//shadow.png",1) end, 0.1) return end)
end

local allies = {}
local enemies = {}
local drawIT = {}

local downloadActive = 0

DelayAction(function()

for a, ally in pairs(GetAllyHeroes()) do
	if FileExist(SPRITE_PATH.."RadarHack//"..GetObjectName(ally)..".png") then
		allies[GetNetworkID(ally)] = CreateSpriteFromFile("RadarHack//"..GetObjectName(ally)..".png",1)	
	else
		downloadActive = downloadActive + 1
		DownloadFileAsync("https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/Sprites/Champions/"..GetObjectName(ally)..".png",SPRITE_PATH.."RadarHack//"..GetObjectName(ally)..".png", function() DelayAction(function() allies[GetNetworkID(ally)] = CreateSpriteFromFile("RadarHack//"..GetObjectName(ally)..".png",1) end,0.1)	 return end)
	end
end
for i,enemy in pairs(GetEnemyHeroes()) do
	if FileExist(SPRITE_PATH.."RadarHack//"..GetObjectName(enemy)..".png") then
		enemies[GetNetworkID(enemy)] = CreateSpriteFromFile("RadarHack//"..GetObjectName(enemy)..".png",1)
	else
		downloadActive = downloadActive + 1
		DownloadFileAsync("https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/Sprites/Champions/"..GetObjectName(enemy)..".png",SPRITE_PATH.."RadarHack//"..GetObjectName(enemy)..".png", function() DelayAction(function() enemies[GetNetworkID(enemy)] = CreateSpriteFromFile("RadarHack//"..GetObjectName(enemy)..".png",1) end,0.1) return end)
	end
end

DelayAction(function()

local rtMenu = Menu("Radar Hack", "Radar Track")
rtMenu:Boolean("trackAlly", "Show: Allies", true)
rtMenu:Boolean("trackEnemy", "Show: Enemies", true)
rtMenu:Boolean("showDistance", "Show: Distance", true)
rtMenu:Slider("trackRange","Check range", 4000, 2000, 8000, 100)

local screen = GetResolution()
local mX = screen.x/2
local mY = screen.y/2

OnDraw(function(myHero)
if rtMenu.trackAlly:Value() then
	for a, ally in pairs(GetAllyHeroes()) do
		if not IsDead(ally) and GetDistance(ally) < rtMenu.trackRange:Value() then
			drawSprite(ally,GetOrigin(ally),1)
		end
	end	
end
if rtMenu.trackEnemy:Value() then
	for i,enemy in pairs(GetEnemyHeroes()) do
		if not IsDead(enemy) and GetDistance(enemy) < rtMenu.trackRange:Value() then
			drawSprite(enemy,GetOrigin(enemy),2)
		end
	end
end
end)

function drawSprite(who,pos,team)
	local screenPosQQ = WorldToScreen(1,pos)
	local screenPos = WorldToScreen(0,pos)
	if IsVisible(who) then
		drawIT[GetNetworkID(who)] = true
	end
	if not screenPosQQ.flag or not IsVisible(who) then
		local drawX = screenPos.x
		local drawY = screenPos.y
		if screenPos.x < 0 then
			drawX = screenPos.x + math.abs(screenPos.x) + 30
		elseif screenPos.x > screen.x then
			drawX = screen.x - 30
		end
		if screenPos.y < 0 then
			drawY = screenPos.y + math.abs(screenPos.y) + 30
		elseif screenPos.y > screen.y then
			drawY = screen.y - 30
		end
		if drawIT[GetNetworkID(who)] == true then
			if team == 1 then
				DrawSprite(allyCircle,drawX-25,drawY-25,0,0,0,0,ARGB(255,255,255,255))
				if allies[GetNetworkID(who)] ~= 0 then
					DrawSprite(allies[GetNetworkID(who)],drawX-25,drawY-25,0,0,0,0,ARGB(255,255,255,255))
				else
					DrawSprite(placeHolder,drawX-25,drawY-25,0,0,0,0,ARGB(255,255,255,255))
				end
			elseif team == 2 then
				DrawSprite(enemyCircle,drawX-25,drawY-25,0,0,0,0,ARGB(255,255,255,255))
				if enemies[GetNetworkID(who)] ~= 0 then
					DrawSprite(enemies[GetNetworkID(who)],drawX-25,drawY-25,0,0,0,0,ARGB(255,255,255,255))
				else
					DrawSprite(placeHolder,drawX-25,drawY-25,0,0,0,0,ARGB(255,255,255,255))
				end
			end
			if not IsVisible(who) then
				DrawSprite(miss,drawX-25,drawY-25,0,0,0,0,ARGB(255,255,255,255))
			end
			drawHP(who,drawX,drawY,team)
		end
	end
end

function drawHP(who,x,y,team)
	DrawSprite(hpbar,x-22,y+20,0,0,0,0,ARGB(255,255,255,255))
	local multi = GetCurrentHP(who)/GetMaxHP(who)
	DrawSprite(hp,x-20,y+22,0,0,38*multi,4,ARGB(255,255,255,255))
	if rtMenu.showDistance:Value() then
		local color = ARGB(255,255,255,255)
		if team == 1 then
			color = ARGB(255,0,255,20)
		elseif team == 2 then
			color = ARGB(255,255,0,20)
		end
		DrawSprite(shadow,x-20,y+28,0,0,0,0,ARGB(130,255,255,255))
		DrawText(math.round(GetDistance(myHero,who)),9,x-9,y+27,color)
	end
end

OnProcessRecall(function(unit,recallProc)
	if drawIT[GetNetworkID(unit)] ~= nil then
		if drawIT[GetNetworkID(unit)] == true then
			if recallProc.isFinish == true then
				drawIT[GetNetworkID(unit)] = false
			end
		end
	end
end)

OnGainVision(function(unit)
	drawIT[GetNetworkID(unit)] = true
end)

end,0.5+(0.5*downloadActive))
end,0.1)
