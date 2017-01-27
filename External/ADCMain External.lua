local supportedChamps = {
["Ashe"] = 0,["Caitlyn"] = 0,["Corki"] = 1,["Draven"] = 0,["Ezreal"] = 0,["Graves"] = 0,["Jinx"] = 0,["Kalista"] = 0,["Kennen"] = 0,["Kindred"] = 0,["KogMaw"] = 0,["Lucian"] = 0,["MissFortune"] = 0,["Quinn"] = 0,["Sivir"] = 0,["Tristana"] = 0,["Twitch"] = 0,["Urgot"] = 0,["Varus"] = 0,["Vayne"] = 0,["Jhin"] = 0,
}
if supportedChamps[myHero.charName] ~= 1 then return end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local CC = {
-- Aatrox
["AatroxQ"] 					= 	{ slot = _Q , champName = "Aatrox"				, spellType = "circular" 	, projectileSpeed = 2000		, spellDelay = 600	, spellRange = 650		, spellRadius = 285		, collision = false	}, 
["AatroxE"] 					= 	{ slot = _E , champName = "Aatrox"				, spellType = "line" 		, projectileSpeed = 1250		, spellDelay = 250	, spellRange = 1075		, spellRadius = 100		, collision = false	, projectileName = "AatroxBladeofTorment_mis.troy"}, 
-- Ahri
["AhriSeduce"] 					= 	{ slot = _E , champName = "Ahri"				, spellType = "line" 	 	, projectileSpeed = 1550		, spellDelay = 250	, spellRange = 1000		, spellRadius = 60		, collision = true	, projectileName = "Ahri_Charm_mis.troy"}, 
-- Alistar
["Pulverize"] 					= 	{ slot = _Q , champName = "Alistar"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 365		, spellRadius = 365		, collision = false	},
["Headbutt"] 					= 	{ slot = _W , champName = "Alistar"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 50	, spellRange = 800		, spellRadius = 50		, collision = false	},
-- Amumu
["BandageToss"] 				= 	{ slot = _Q , champName = "Amumu"				, spellType = "line" 	 	, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 1100		, spellRadius = 80		, collision = true	, projectileName = "Bandage_beam.troy"}, 
["CurseoftheSadMummy"] 			= 	{ slot = _R , champName = "Amumu"				, spellType = "aoe" 	 	, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 560		, spellRadius = 560		, collision = false	},
-- Anivia
["FlashFrostSpell"] 			= 	{ slot = _Q , champName = "Anivia"				, spellType = "line" 	 	, projectileSpeed = 850			, spellDelay = 250	, spellRange = 1250		, spellRadius = 110		, collision = false	, projectileName = "cryo_FlashFrost_mis.troy"}, 
-- Ashe
["EnchantedCrystalArrow"] 		= 	{ slot = _R , champName = "Ashe"				, spellType = "line" 	 	, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 20000	, spellRadius = 130		, collision = false	, projectileName = "EnchantedCrystalArrow_mis.troy"},
-- Bard
["BardQ"] 						= 	{ slot = _Q , champName = "Bard"				, spellType = "line" 	 	, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 950		, spellRadius = 60		, collision = true	, projectileName = "Bard_Base_Q_Missile_mis.troy"},
-- Blitzcrank
["RocketGrabMissile"] 			= 	{ slot = _Q , champName = "Blitzcrank"			, spellType = "line" 	 	, projectileSpeed = 1800		, spellDelay = 250	, spellRange = 1050		, spellRadius = 70		, collision = true	, projectileName = "FistGrab_mis.troy"},
["PowerFistAttack"] 			= 	{ slot = _E , champName = "Blitzcrank"			, spellType = "target" 	 	, projectileSpeed = math.huge	, spellDelay = 50	, spellRange = 500		, spellRadius = 70		, collision = false	},
-- Braum
["BraumQ"] 						= 	{ slot = _Q , champName = "Braum"				, spellType = "line" 	 	, projectileSpeed = 1200		, spellDelay = 250	, spellRange = 1000		, spellRadius = 100		, collision = true	, projectileName = ""},
["BraumRWrapper"] 				= 	{ slot = _R , champName = "Braum"				, spellType = "line" 	 	, projectileSpeed = 1125		, spellDelay = 500	, spellRange = 1250		, spellRadius = 100		, collision = false	, projectileName = ""},
-- Cassiopeia
["CassiopeiaPetrifyingGaze"]	= 	{ slot = _R , champName = "Cassiopeia"			, spellType = "line" 	 	, projectileSpeed = math.huge	, spellDelay = 500	, spellRange = 825		, spellRadius = 150		, collision = false	, projectileName = ""},
-- Chogath
["Rupture"] 					= 	{ slot = _Q , champName = "Chogath"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 1200	, spellRange = 950		, spellRadius = 250		, collision = false },
-- Darius
["DariusAxeGrabCone"] 			= 	{ slot = _E , champName = "Darius"				, spellType = "line" 		, projectileSpeed = math.huge	, spellDelay = 320	, spellRange = 570		, spellRadius = 150		, collision = false , projectileName = ""},
-- Diana
["DianaVortex"] 				= 	{ slot = _E , champName = "Diana"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 350		, spellRadius = 350		, collision = false	},
-- DrMundo
["InfectedCleaverMissileCast"] 	= 	{ slot = _Q , champName = "DrMundo"				, spellType = "line" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 1050		, spellRadius = 60		, collision = true	, projectileName = "DrMundo_Base_Q_mis.troy"},
-- Draven
["DravenDoubleShot"] 			= 	{ slot = _E , champName = "Draven"				, spellType = "line" 		, projectileSpeed = 1400		, spellDelay = 250	, spellRange = 1100		, spellRadius = 130		, collision = false	, projectileName = "Draven_E_mis.troy"},
-- Elise
["EliseHumanE"] 				= 	{ slot = _E , champName = "Elise"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 1100		, spellRadius = 70		, collision = true	, projectileName = "Elise_human_E_mis.troy"},
-- Evelynn
["EvelynnR"] 					= 	{ slot = _R , champName = "Evelynn"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 650		, spellRadius = 350		, collision = false },
-- FiddleSticks
["Terrify"] 					= 	{ slot = _Q , champName = "FiddleSticks"		, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 575		, spellRadius = 0		, collision = false },
-- Fizz
["FizzMarinerDoom"] 			= 	{ slot = _R , champName = "Fizz"				, spellType = "line" 		, projectileSpeed = 1350		, spellDelay = 250	, spellRange = 1275		, spellRadius = 120		, collision = false , projectileName = "Fizz_UltimateMissile.troy"}, --Test
-- Galio
["GalioResoluteSmite"] 			= 	{ slot = _Q , champName = "Galio"				, spellType = "circular" 	, projectileSpeed = 1200		, spellDelay = 250	, spellRange = 1040		, spellRadius = 235		, collision = false },
["GalioIdolOfDurand"] 			= 	{ slot = _R , champName = "Galio"				, spellType = "aoe" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 600		, spellRadius = 600		, collision = false },
-- Gnar
["gnarbigq"] 					= 	{ slot = _Q , champName = "Gnar"				, spellType = "line" 		, projectileSpeed = 2000		, spellDelay = 500	, spellRange = 1150		, spellRadius = 90		, collision = true  , projectileName = ""},
["GnarQ"] 						= 	{ slot = _Q , champName = "Gnar"				, spellType = "line" 		, projectileSpeed = 2400		, spellDelay = 250	, spellRange = 1185		, spellRadius = 60		, collision = true  , projectileName = ""},
["gnarbigw"] 					= 	{ slot = _W , champName = "Gnar"				, spellType = "line" 		, projectileSpeed = math.huge	, spellDelay = 600	, spellRange = 600		, spellRadius = 100		, collision = false , projectileName = ""},
["GnarR"] 						= 	{ slot = _R , champName = "Gnar"				, spellType = "aoe" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 500		, spellRadius = 500		, collision = false },
-- Gragas
["GragasE"] 					= 	{ slot = _E , champName = "Gragas"				, spellType = "line" 		, projectileSpeed = 1200		, spellDelay = 0	, spellRange = 950		, spellRadius = 200		, collision = true  , projectileName = ""},
["GragasR"] 					= 	{ slot = _R , champName = "Gragas"				, spellType = "circular" 	, projectileSpeed = 1750		, spellDelay = 250	, spellRange = 1050		, spellRadius = 350		, collision = false },
-- Hecarim
["HecarimUlt"] 					= 	{ slot = _R , champName = "Hecarim"				, spellType = "circular" 	, projectileSpeed = 1100		, spellDelay = 10	, spellRange = 1500		, spellRadius = 300		, collision = false },
-- Heimerdinger
["HeimerdingerE"] 				= 	{ slot = _E , champName = "Heimerdinger"		, spellType = "circular" 	, projectileSpeed = 1750		, spellDelay = 350	, spellRange = 925		, spellRadius = 135		, collision = false },
-- Irelia
["IreliaEquilibriumStrike"] 	= 	{ slot = _E , champName = "Irelia"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 425		, spellRadius = 0		, collision = false },
-- Janna
["HowlingGale"] 				= 	{ slot = _Q , champName = "Janna"				, spellType = "line" 		, projectileSpeed = 900			, spellDelay = 0	, spellRange = 1700		, spellRadius = 120		, collision = false , projectileName = "HowlingGale_mis.troy"},
["SowTheWind"] 					= 	{ slot = _W , champName = "Janna"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 600		, spellRadius = 0		, collision = false },
-- JarvanIV
["JarvanIVDragonStrike2"] 		= 	{ slot = _Q , champName = "JarvanIV"			, spellType = "line" 		, projectileSpeed = 1800		, spellDelay = 250	, spellRange = 845		, spellRadius = 120		, collision = false	, projectileName = ""},
-- Jayce
["JayceToTheSkies"] 			= 	{ slot = _Q , champName = "Jayce"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 600		, spellRadius = 100		, collision = false	},
["JayceThunderingBlow"] 		= 	{ slot = _E , champName = "Jayce"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 240		, spellRadius = 0		, collision = false	},
-- Karma
["KarmaQMissileMantra"] 		= 	{ slot = _Q , champName = "Karma"				, spellType = "line" 		, projectileSpeed = 1700		, spellDelay = 250	, spellRange = 1050		, spellRadius = 90		, collision = true	, projectileName = ""},
["KarmaQ"] 						= 	{ slot = _Q , champName = "Karma"				, spellType = "line" 		, projectileSpeed = 1700		, spellDelay = 250	, spellRange = 1050		, spellRadius = 90		, collision = true	, projectileName = ""},
["KarmaW"] 						= 	{ slot = _W , champName = "Karma"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 1000		, spellRadius = 0		, collision = false	}, -- Check spellname
-- Kassadin
["ForcePulse"] 					= 	{ slot = _E , champName = "Kassadin"			, spellType = "line" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 700		, spellRadius = 100		, collision = false	, projectileName = ""},
-- Kayle
["JudicatorReckoning"] 			= 	{ slot = _Q , champName = "Kayle"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 650		, spellRadius = 50		, collision = false	},
-- KhaZix
["KhazixW"] 					= 	{ slot = _W , champName = "KhaZix"				, spellType = "line" 		, projectileSpeed = 1700		, spellDelay = 250	, spellRange = 1100		, spellRadius = 70		, collision = true	, projectileName = "Khazix_W_mis_enhanced.troy"},
["khazixwlong"] 				= 	{ slot = _W , champName = "KhaZix"				, spellType = "line" 		, projectileSpeed = 1700		, spellDelay = 250	, spellRange = 1025		, spellRadius = 70		, collision = true	, projectileName = "Khazix_W_mis_enhanced.troy"},
-- KogMaw
["KogMawVoidOoze"] 				= 	{ slot = _E , champName = "KogMaw"				, spellType = "line" 		, projectileSpeed = 1400		, spellDelay = 250	, spellRange = 1360		, spellRadius = 120		, collision = false	, projectileName = "KogMawVoidOoze_mis.troy"},
-- LeBlanc
["LeblancSoulShackle"] 			= 	{ slot = _E , champName = "Leblanc"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 960		, spellRadius = 70		, collision = true	, projectileName = "leBlanc_shackle_mis.troy"},
["LeblancSoulShackleM"] 		= 	{ slot = _R , champName = "Leblanc"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 960		, spellRadius = 70		, collision = true	, projectileName = "leBlanc_shackle_mis_ult.troy"},
-- LeeSin
["BlindMonkQOne"] 				= 	{ slot = _Q , champName = "LeeSin"				, spellType = "line" 		, projectileSpeed = 1800		, spellDelay = 250	, spellRange = 1100		, spellRadius = 60		, collision = true	, projectileName = "blindMonk_Q_mis_01.troy"},
["BlindMonkRKick"] 				= 	{ slot = _R , champName = "LeeSin"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 375		, spellRadius = 0		, collision = false	},
-- Leona
["LeonaSolarFlare"] 			= 	{ slot = _R , champName = "Leona"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 1000	, spellRange = 1200		, spellRadius = 300		, collision = false	},
-- Lissandra
["LissandraW"] 					= 	{ slot = _W , champName = "Lissandra"			, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 450		, spellRadius = 450		, collision = false	},
["LissandraR"] 					= 	{ slot = _R , champName = "Lissandra"			, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 550		, spellRadius = 550		, collision = false	},
-- Lulu
["LuluQ"] 						= 	{ slot = _Q , champName = "Lulu"				, spellType = "line" 		, projectileSpeed = 1450		, spellDelay = 250	, spellRange = 950		, spellRadius = 80		, collision = false	, projectileName = "Lulu_Q_Mis.troy"},
["LuluW"] 						= 	{ slot = _W , champName = "Lulu"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 925		, spellRadius = 450		, collision = false	}, -- check spellname
-- Lux
["LuxLightBindingMis"] 			= 	{ slot = _Q , champName = "Lux"					, spellType = "line" 		, projectileSpeed = 1200		, spellDelay = 250	, spellRange = 1300		, spellRadius = 70		, collision = true	, projectileName = "LuxLightBinding_mis.troy"},
-- Malphite
["SeismicShard"] 				= 	{ slot = _Q , champName = "Malphite"			, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 625		, spellRadius = 0		, collision = false	},
["UFSlash"] 					= 	{ slot = _R , champName = "Malphite"			, spellType = "circular" 	, projectileSpeed = 2000		, spellDelay = 0	, spellRange = 1000		, spellRadius = 300		, collision = false	},
-- Malzahar
["AlZaharNetherGrasp"] 			= 	{ slot = _R , champName = "Malzahar"			, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 700		, spellRadius = 0		, collision = false	},
-- Maokai
["MaokaiTrunkLine"] 			= 	{ slot = _Q , champName = "Maokai"				, spellType = "line" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 600		, spellRadius = 100		, collision = false	, projectileName = ""},
["MaokaiW"] 					= 	{ slot = _W , champName = "Maokai"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 600		, spellRadius = 0		, collision = false	}, -- check spellname
-- Morgana
["DarkBindingMissile"] 			= 	{ slot = _Q , champName = "Morgana"				, spellType = "line" 		, projectileSpeed = 1200		, spellDelay = 250	, spellRange = 1300		, spellRadius = 80		, collision = true	, projectileName = "DarkBinding_mis.troy"},
["SoulShackles"] 				= 	{ slot = _R , champName = "Morgana"				, spellType = "aoe" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 600		, spellRadius = 600		, collision = false	},
-- Nami
["NamiQ"] 						= 	{ slot = _Q , champName = "Nami"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 1000	, spellRange = 875		, spellRadius = 200		, collision = false	},
["NamiR"] 						= 	{ slot = _R , champName = "Nami"				, spellType = "line" 		, projectileSpeed = 850			, spellDelay = 500	, spellRange = 2750		, spellRadius = 250		, collision = false	, projectileName = ""},
-- Nasus
["NasusW"] 						= 	{ slot = _W , champName = "Nasus"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 600		, spellRadius = 0		, collision = false	},
-- Nautilus
["NautilusAnchorDrag"] 			= 	{ slot = _Q , champName = "Nautilus"			, spellType = "line" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 1250		, spellRadius = 90		, collision = true	, projectileName = "Nautilus_Q_mis.troy"},
["NautilusR"] 					= 	{ slot = _R , champName = "Nautilus"			, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 825		, spellRadius = 0		, collision = false	}, -- check spellname
-- Nocturne
["NocturneUnspeakableHorror"]	= 	{ slot = _E , champName = "Nocturne"			, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 425		, spellRadius = 0		, collision = false	},
-- Nunu
["IceBlast"]					= 	{ slot = _E , champName = "Nunu"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 400	, spellRange = 425		, spellRadius = 0		, collision = false	},
-- Olaf
["OlafAxeThrowCast"]			= 	{ slot = _Q , champName = "Olaf"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 100		, spellRadius = 90		, collision = false	, projectileName = "olaf_axe_mis.troy"},
-- Orianna
--0
-- Pantheon
["PantheonW"]					= 	{ slot = _W , champName = "Pantheon"			, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 600		, spellRadius = 0		, collision = false	}, -- check spellname
-- Poppy
["PoppyHeroicCharge"]			= 	{ slot = _E , champName = "Poppy"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 600		, spellRadius = 0		, collision = false	},
-- Quinn
["QuinnQ"]						= 	{ slot = _Q , champName = "Quinn"				, spellType = "line" 		, projectileSpeed = 1550		, spellDelay = 250	, spellRange = 1050		, spellRadius = 80		, collision = true	, projectileName = "Quinn_Q_missile.troy"},
["QuinnE"]						= 	{ slot = _E , champName = "Quinn"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 700		, spellRadius = 0		, collision = false	},
-- Rammus
["PuncturingTaunt"]				= 	{ slot = _E , champName = "Rammus"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 325		, spellRadius = 0		, collision = false	},
-- Rengar
["RengarE"]						= 	{ slot = _E , champName = "Rengar"				, spellType = "line" 		, projectileSpeed = 1500		, spellDelay = 250	, spellRange = 1000		, spellRadius = 70		, collision = true	, projectileName = ""},
-- Riven
["RivenMartyr"]					= 	{ slot = _W , champName = "Riven"				, spellType = "aoe" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 280		, spellRadius = 280		, collision = false	},
-- Rumble
["RumbleGrenade"]				= 	{ slot = _E , champName = "Rumble"				, spellType = "line" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 950		, spellRadius = 90		, collision = true	, projectileName = "rumble_taze_mis.troy"},
-- Ryze
["RyzeW"]						= 	{ slot = _W , champName = "Ryze"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 600		, spellRadius = 0		, collision = false	},
-- Sejuani
["SejuaniArcticAssault"]		= 	{ slot = _Q , champName = "Sejuani"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 0	, spellRange = 900		, spellRadius = 70		, collision = false	, projectileName = ""},
["SejuaniGlacialPrisonCast"]	= 	{ slot = _R , champName = "Sejuani"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 1200		, spellRadius = 110		, collision = false	, projectileName = ""},
-- Shaco
["TwoShivPoison"]				= 	{ slot = _E , champName = "Shaco"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 625		, spellRadius = 0		, collision = false	},
-- Shen
["ShenShadowDash"]				= 	{ slot = _E , champName = "Shen"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 0	, spellRange = 650		, spellRadius = 50		, collision = false	, projectileName = ""},
-- Shyvana
["ShyvanaTransformCast"]		= 	{ slot = _R , champName = "Shyvana"				, spellType = "line" 		, projectileSpeed = 1100		, spellDelay = 10	, spellRange = 1000		, spellRadius = 160		, collision = false	, projectileName = ""},
-- Singed
["Fling"]						= 	{ slot = _E , champName = "Singed"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 125		, spellRadius = 0		, collision = false	},
-- Skarner
["SkarnerFracture"]				= 	{ slot = _E , champName = "Skarner"				, spellType = "line" 		, projectileSpeed = 1400		, spellDelay = 250	, spellRange = 1000		, spellRadius = 60		, collision = false	, projectileName = ""},
["SkarnerImpale"]				= 	{ slot = _R , champName = "Skarner"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 350		, spellRadius = 0		, collision = false	}, -- check spellname
-- Sona
["SonaR"]						= 	{ slot = _R , champName = "Sona"				, spellType = "line" 		, projectileSpeed = 2400		, spellDelay = 250	, spellRange = 1000		, spellRadius = 140		, collision = false	, projectileName = ""},
-- Swain
["SwainQ"]						= 	{ slot = _Q , champName = "Swain"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 625		, spellRadius = 0		, collision = false	}, -- check spellname
["SwainShadowGrasp"]			= 	{ slot = _W , champName = "Swain"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 1100	, spellRange = 900		, spellRadius = 250		, collision = false	},
-- Syndra
["syndrawcast"]					= 	{ slot = _W , champName = "Syndra"				, spellType = "circular" 	, projectileSpeed = 1450		, spellDelay = 250	, spellRange = 925		, spellRadius = 220		, collision = false	},
["SyndraE"]						= 	{ slot = _E , champName = "Syndra"				, spellType = "line" 		, projectileSpeed = 1500		, spellDelay = 250	, spellRange = 800		, spellRadius = 150		, collision = false	, projectileName = ""},
-- TahmKench
["TahmKenchQ"]					= 	{ slot = _Q , champName = "TahmKench"			, spellType = "line" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 950		, spellRadius = 90		, collision = true	, projectileName = ""},
["TahmKenchE"]					= 	{ slot = _E , champName = "TahmKench"			, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 250		, spellRadius = 0		, collision = false	}, -- check spellname
-- Teemo
["BlindingDart"]				= 	{ slot = _Q , champName = "Teemo"				, spellType = "target" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 580		, spellRadius = 0		, collision = false	},
-- Thresh
["ThreshQ"]						= 	{ slot = _Q , champName = "Thresh"				, spellType = "line" 		, projectileSpeed = 1900		, spellDelay = 500	, spellRange = 1100		, spellRadius = 70		, collision = true	, projectileName = ""},
["ThreshE"]						= 	{ slot = _E , champName = "Thresh"				, spellType = "line" 		, projectileSpeed = 2000		, spellDelay = 0	, spellRange = 1075/2	, spellRadius = 110		, collision = false	, projectileName = ""},
-- Tristana
["TristanaR"]					= 	{ slot = _R , champName = "Tristana"			, spellType = "target" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 669		, spellRadius = 0		, collision = false	},
-- Tryndamere
["MockingShout"] 				= 	{ slot = _W , champName = "Tryndamere"			, spellType = "aoe" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 400		, spellRadius = 400		, collision = false	},
-- Urgot
["UrgotR"]						= 	{ slot = _R , champName = "Urgot"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 850		, spellRadius = 0		, collision = false	}, -- check spellName
-- Varus
["VarusR"]						= 	{ slot = _R , champName = "Varus"				, spellType = "line" 		, projectileSpeed = 1950		, spellDelay = 250	, spellRange = 1200		, spellRadius = 100		, collision = false	, projectileName = ""},
-- Vayne
["VayneCondemn"]				= 	{ slot = _E , champName = "Vayne"				, spellType = "target" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 550		, spellRadius = 0		, collision = false	},
-- Veigar
["VeigarEventHorizon"]			= 	{ slot = _E , champName = "Veigar"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 500	, spellRange = 700		, spellRadius = 425		, collision = false	},
-- VelKoz
["VelkozQMissile"]				= 	{ slot = _Q , champName = "Velkoz"				, spellType = "line" 		, projectileSpeed = 1300		, spellDelay = 250	, spellRange = 1250		, spellRadius = 50		, collision = true	, projectileName = ""},
["VelkozQMissileSplit"]			= 	{ slot = _Q , champName = "Velkoz"				, spellType = "line" 		, projectileSpeed = 2100		, spellDelay = 0	, spellRange = 1100		, spellRadius = 45		, collision = true	, projectileName = ""},
["VelkozE"]						= 	{ slot = _E , champName = "Velkoz"				, spellType = "circular" 	, projectileSpeed = 1500		, spellDelay = 0	, spellRange = 950		, spellRadius = 225		, collision = false	},
-- Vi
["ViQMissile"]					= 	{ slot = _Q , champName = "Vi"					, spellType = "line" 		, projectileSpeed = 1500		, spellDelay = 0	, spellRange = 725		, spellRadius = 90		, collision = false	, projectileName = ""},
["ViR"]							= 	{ slot = _R , champName = "Vi"					, spellType = "line" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 800		, spellRadius = 0		, collision = false	, projectileName = ""}, -- check spellname
-- Viktor
["ViktorGravitonField"]			= 	{ slot = _W , champName = "Viktor"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 1500	, spellRange = 625		, spellRadius = 300		, collision = false	},
-- Warwick
["InfiniteDuress"]				= 	{ slot = _R , champName = "Warwick"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 0	, spellRange = 700		, spellRadius = 0		, collision = false	}, -- check spellname
-- Xerath
["XerathArcaneBarrage2"]		= 	{ slot = _W , champName = "Xerath"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 1125		, spellRadius = 60		, collision = false	},
["XerathMageSpear"]				= 	{ slot = _E , champName = "Xerath"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 750	, spellRange = 1100		, spellRadius = 280		, collision = true	, projectileName = ""},
-- Yasou
["yasuoq3w"]					= 	{ slot = _Q , champName = "Yasou"				, spellType = "line" 		, projectileSpeed = 1200		, spellDelay = 250	, spellRange = 1025		, spellRadius = 90		, collision = false	, projectileName = ""},
-- Zac
["ZacQ"]						= 	{ slot = _Q , champName = "Zac"					, spellType = "line" 		, projectileSpeed = math.huge	, spellDelay = 500	, spellRange = 550		, spellRadius = 120		, collision = false	, projectileName = ""},
["ZacE"]						= 	{ slot = _E , champName = "Zac"					, spellType = "circular" 	, projectileSpeed = 1500		, spellDelay = 0	, spellRange = 1800		, spellRadius = 300		, collision = false	}, -- check spellname, projectileSpeed
-- Ziggs
["ZiggsW"]						= 	{ slot = _W , champName = "Ziggs"				, spellType = "circular" 	, projectileSpeed = 3000		, spellDelay = 250	, spellRange = 2000		, spellRadius = 275		, collision = false	},
-- Zilean
["ZileanQ"]						= 	{ slot = _Q , champName = "Zilean"				, spellType = "circular" 	, projectileSpeed = 2000		, spellDelay = 300	, spellRange = 900		, spellRadius = 250		, collision = false	},
["TimeWarp"]					= 	{ slot = _E , champName = "Zilean"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 0	, spellRange = 550		, spellRadius = 0		, collision = false	},
-- Zyra
["ZyraGraspingRoots"]			= 	{ slot = _E , champName = "Zyra"				, spellType = "line" 		, projectileSpeed = 1400		, spellDelay = 250	, spellRange = 1150		, spellRadius = 70		, collision = false	, projectileName = ""},
["ZyraBrambleZone"]				= 	{ slot = _R , champName = "Zyra"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 500	, spellRange = 700		, spellRadius = 525		, collision = false	}
}

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

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function GetMode()
    if Orbwalker["Combo"].__active then return "Combo" end
    if Orbwalker["Farm"].__active then return "LaneClear" end
    if Orbwalker["LastHit"].__active then return "LastHit" end
    if Orbwalker["Harass"].__active then return "Harass" end
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

function IsValidTarget(unit, range, checkTeam, from)
  local range = range == nil and math.huge or range
  if type(range) ~= "number" then error("{IsValidTarget}: bad argument #2 (number expected, got "..type(range)..")") end
  if type(checkTeam) ~= "nil" and type(checkTeam) ~= "boolean" then error("{IsValidTarget}: bad argument #3 (boolean or nil expected, got "..type(checkTeam)..")") end
  if type(from) ~= "nil" and type(from) ~= "userdata" then error("{IsValidTarget}: bad argument #4 (vector or nil expected, got "..type(from)..")") end
  if unit == nil or not unit.valid or not unit.visible or unit.dead or not unit.isTargetable or IsImmune(unit) or (checkTeam and unit.isAlly) then 
    return false 
  end 
  return unit.pos:DistanceTo(from and from or myHero) < range 
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
          if buff.name == "MaokaiDrainDefense" > 0 then
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

local aa = {state = 1, tick = GetTickCount(), tick2 = GetTickCount(), target = myHero}
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
		if Game.Timer() + Game.Latency()/2000 + myHero.attackData.castFrame/100 > myHero.attackData.endTime - myHero.attackData.windDownTime and aa.state == 2 then
			aa.state = 3
			aa.tick2 = GetTickCount()
			-- print("OnProcessAttackComplete")
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
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local version = 0.1

local icons = {	["Corki"] = "http://vignette2.wikia.nocookie.net/leagueoflegends/images/3/3d/CorkiSquare.png",
				["Sivir"] = "http://vignette4.wikia.nocookie.net/leagueoflegends/images/e/e1/SivirSquare.png",
				["Lucian"] = "http://vignette4.wikia.nocookie.net/leagueoflegends/images/1/1e/LucianSquare.png"
}

local 	ADCMenu = MenuElement({id = "ADCMainExt", name = "ADC in 2017 LUL | "..myHero.charName, type = MENU ,leftIcon = icons[myHero.charName] })
		ADCMenu:MenuElement({id = "Combo", name = "Combo", type = MENU})
		ADCMenu:MenuElement({id = "Harass", name = "Harras", type = MENU})
		ADCMenu:MenuElement({id = "Killsteal", name = "Killsteal", type = MENU})
		ADCMenu:MenuElement({id = "Items", name = "Items", type = MENU})
		ADCMenu:MenuElement({id = "Misc", name = "Misc", type = MENU})
		-- ADCMenu:MenuElement({id = "Key", name = "Key Settings", type = MENU})
		-- ADCMenu.Key:MenuElement({id = "Combo", name = "Combo", key = string.byte(" ")})
		-- ADCMenu.Key:MenuElement({id = "Harass", name = "Harass | Mixed", key = string.byte("C")})
		-- ADCMenu.Key:MenuElement({id = "Clear", name = "LaneClear | JungleClear", key = string.byte("V")})
		-- ADCMenu.Key:MenuElement({id = "LastHit", name = "LastHit", key = string.byte("X")})
		
local DragonPos = Vector(9821,-71.25,4384.1)
local BaronPos = Vector(4971.5,-71.25,10415.6)

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
	ADCMenu.Combo:MenuElement({id = "OrbKey", name = "Orbwalker Key", key = string.byte(" ")})
	ADCMenu.Combo:MenuElement({id = "moveDelay", name = "Delay between movement clicks", value = 160, min = 0, max = 250, step = 1})
	
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
	if GetMode() == "Combo" or (ADCMenu.Combo.Orb:Value() and ADCMenu.Combo.OrbKey:Value()) then
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
		if (ADCMenu.Combo.Orb:Value() and ADCMenu.Combo.OrbKey:Value()) then
			if target and GetDistance(myHero.pos,target.pos) < self.range + 50 then
				if aa.state == 1 and aa.state ~= 2 and castSpell.state ~= 1 then
					Control.Attack(target)
				elseif aa.state == 3 and aa.state ~= 2 and castSpell.state ~= 1 and GetTickCount() - lastMove > ADCMenu.Combo.moveDelay:Value() then
					Control.Move()
					lastMove = GetTickCount()
				end
			else
				if aa.state ~= 2 and castSpell.state ~= 1 and GetTickCount() - lastMove > ADCMenu.Combo.moveDelay:Value() then
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
	self.sivirQ = { delay = 0.25, speed = 1350, width = 80, range = 1250 }
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
	ADCMenu.Combo:MenuElement({id = "useRonXE", name = "R | If more than X enemies around", value = 3, min = 1, max = 5, step = 1})
	ADCMenu.Combo:MenuElement({id = "useRonXA", name = "R | If more than X allies around", value = 3, min = 0, max = 4, step = 1})

	ADCMenu.Harass:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.spellIcons.Q})
	ADCMenu.Harass:MenuElement({id = "useQCC", name = "Use Q only on CC", value = true, leftIcon = self.spellIcons.Q})
	ADCMenu.Harass:MenuElement({id = "manaQ", name = " Q | Mana-Manager", value = 60, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})
	ADCMenu.Harass:MenuElement({id = "useW", name = "Use W", value = true, leftIcon = self.spellIcons.W})
	ADCMenu.Harass:MenuElement({id = "manaW", name = " W | Mana-Manager", value = 40, min = 0, max = 100, step = 1, leftIcon = "http://vignette1.wikia.nocookie.net/leagueoflegends/images/1/1d/Mana_Potion_item.png"})

	ADCMenu.Misc:MenuElement({id = "autoE", name = "Use auto E agains CC", value = true, leftIcon = self.spellIcons.E})
	ADCMenu.Misc:MenuElement({id = "saveDelay", name = "E | Safety delay", value = 250, min = 150, max = 500, step = 10})

end

function Sivir:Tick()
if OnProcessSpellComplete(myHero,_W) then
	aa.state = 1
end
	local target = GetTarget(1000)
	Draw.Circle(target)
	if GetMode() == "Combo" then
		if target then
			Item:useItem(target)
			self:Combo(target)
		end
	elseif GetMode() == "Harass" then
		if target then
			self:Harass(target)
		end
	end
	
	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isEnemy then
			Item:ksItem(hero)
		end
	end	
	
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

function Sivir:Draw()
Draw.Text(aa.state,20,700,500)
	Draw.Text(myHero.attackData.state,20,700,530)
end

function Sivir:Combo(target)
	self:useW(target)
	self:useQ(target)
end

function Sivir:Harass(target)
	local mp = 100*myHero.mana/myHero.maxMana
	if ADCMenu.Harass.manaW:Value() <= mp then
		self:useW(target)
	end
	if ADCMenu.Harass.manaQ:Value() <= mp then
		self:useQ(target)
	end
end

function Sivir:useQ(target)
	if ADCMenu.Combo.useQ:Value() and CanUseSpell(_Q) then
		-- local qPred = target:GetPrediction(self.sivirQ.speed,self.sivirQ.delay)
		local qPred = GetPred(target,self.sivirQ.speed,self.sivirQ.delay)
		self:useQonAA(target,qPred)
		self:useQ2(target,qPred)
	end
end

function Sivir:useQonAA(target,qPred)
	if GetTickCount() - aa.tick2 < 100 and GetDistance(target.pos,myHero.pos) <= self.range + myHero.boundingRadius + target.boundingRadius and GetDistance(myHero.pos,qPred) <= self.sivirQ.range then
		Control.CastSpell(HK_Q,qPred)
	end
end

function Sivir:useQ2(target,qPred)
	local sivirDelay = (self.sivirQ.range + (self.sivirQ.range - qPred:DistanceTo(myHero.pos)))/self.sivirQ.speed + 0.25
	local qPred2 = GetPred(target,math.huge,sivirDelay)
	local checkPoint = myHero.pos + Vector(myHero.pos,qPred2):Normalized() * qPred:DistanceTo(myHero.pos)
	if GetDistance(checkPoint,qPred) < self.sivirQ.width + target.boundingRadius and GetDistance(target.pos,qPred2) > 1 and GetDistance(myHero.pos,qPred2) <= self.sivirQ.range then
		Control.CastSpell(HK_Q,qPred)
	end
end

function Sivir:useW(target)
	if ADCMenu.Combo.useW:Value() and CanUseSpell(_W) then
		if GetTickCount() - aa.tick2 < 100 then
			Control.CastSpell(HK_W)
		end
	end
end

function Sivir:useR(target)
	if ADCMenu.Combo.useR:Value() and CanUseSpell(_R) then
		if ADCMenu.Combo.useRonXE:Value() <= CountEnemiesInRange(myHero.pos, 1000) and ADCMenu.Combo.useRonXA:Value() <= CountAlliesInRange(myHero.pos, 1000) then
			Control.CastSpell(HK_R)
		end
	end
end

function Sivir:GetSkillshots()
	for i = 1, Game.MissileCount() do
		local missile = Game.Missile(i)
		-- if missile and (missile.missileData.owner > 0) and (missile.missileData.speed > 0) and missile.isEnemy and (missile.team < 300) and missile.missileData.target == myHero.networkID then
			-- Draw.Circle(missile.pos,missile.missileData.width,Draw.Color(100,0xFF,0xFF,0xFF))
		-- end
		if missile and (missile.missileData.owner > 0) and (missile.missileData.speed > 0) and (missile.missileData.width > 0) and (missile.missileData.range > 0) and missile.isEnemy and (missile.team < 300)  then
			if (self.res.x*2 >= missile.pos2D.x) and (self.res.x*-1 <= missile.pos2D.x) and (self.res.y*2 >= missile.pos2D.y) and (self.res.y*-1 <= missile.pos2D.y) then --draw skillshots close to our screen, probably we need to exclude global ultimates
				-- if missile.missileData.ePos ~= nil then
					Draw.Circle(missile.pos,missile.missileData.width,Draw.Color(100,0xFF,0xFF,0xFF))
					DrawRectangleOutline(missile.missileData.startPos.x,missile.missileData.startPos.y,missile.missileData.startPos.z,missile.missileData.endPos.x,missile.missileData.endPos.y,missile.missileData.endPos.z,missile.missileData.width,drawColor);
					-- print(GetDistance(missile.missileData.ePos,missile.missileData.startPos))
				-- end
				if CC[missile.missileData.name] ~= nil then
					if self.incSpells[missile.missileData.name] == nil then
						if CC[missile.missileData.name].spellType == "line" then
							print("Added: "..missile.missileData.name)
							self.incSpells[missile.missileData.name] = {sPos = missile.pos, ePos = missile.missileData.endPos, pos = missile.pos, radius = missile.missileData.width, speed = CC[missile.missileData.name].projectileSpeed, sType = CC[missile.missileData.name].spellType, createTime = GetTickCount()}
						-- elseif CC[missile.missileData.name].spellType == "circular" then
							-- self.incSpells[missile.missileData.name] = {sPos = missile.pos, ePos = missile.missileData.ePos, delay = missile.missileData.delay, radius = missile.missileData.width, speed = CC[missile.missileData.name].projectileSpeed, sType = CC[missile.missileData.name].spellType, createTime = GetTickCount()}
						end
					end
				else
					print(missile.missileData.name)
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
	if v.sType == "line" then
		local spellOnMe = v.sPos + Vector(v.sPos,v.ePos):Normalized() * GetDistance(who.pos,v.sPos)
		local spellPos = v.sPos + Vector(v.sPos,v.ePos):Normalized() * (v.speed/1000*(GetTickCount()-v.createTime))
		local timeToDodge = 100 + ADCMenu.Misc.saveDelay:Value() + Game.Latency()
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







---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
