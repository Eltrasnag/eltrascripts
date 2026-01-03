::HappyActive <- false

const careymdl = "models/eltra/72hr/snipermariah.mdl"
::HappyNumber <- RandomInt(10,25)
::XMAS_VICTIMS <- 0
::Diary <- {} // money tracker for ticketguys
enum TEAMS {
	HUMANS = 3,
	ZOMBIES = 2,
	SPECTATORS = 1,
	UNASSIGNED = 0,
}
const css_scale_value = 0.70


MapNPCs <- {
	"npc_chica" : "npc_chica",
}



const careymdl = "models/eltra/72hr/snipermariah.mdl"
const lifeguardmdl = "models/eltra/72hr/lifeguardscout.mdl"

::ffield <- Entities.FindByName(null,"ticketforcefield")

MapSpawnOrigin <- Entities.FindByName(null, "spawnorigin").GetOrigin()

zload_regex <- regexp("!zload")
mario_regex <- regexp("mario")
bot_regex <- regexp("bot ")
tiannanmen_taylorswift <- regexp("1989")
// SysEvents <- {

// }


// ::ThePlayerSpawnFunction() {}

function OnPostSpawn() {
	// MAP_COLOR = "245 72 66" // our fancy hud color!
	// MAP_COLOR_HEX = "f54842" // our fancy hud color!

	ffield.ValidateScriptScope()
	local fscope = ffield.GetScriptScope()
	fscope.AllowList <- []
	fscope.TestPlayer <- function(ply) {
		if (ply.GetTeam() == TEAMS.HUMANS) {
			ply.ValidateScriptScope()
			local scope = ply.GetScriptScope()
			if ("TicketPaid" in scope && scope.TicketPaid == true) {
				ScreenFade(ply, 0, 255,0,150,1, 0.1, FFADE_IN)
			}
			else {
				ScreenFade(ply, 255, 0,0,150,1, 0.1, FFADE_IN)
				GaySex(ply)
			}
		}
	}

	// ListenHooks(Hookz) // spawn hook for playermodel and whatever
	AddThinkToEnt(self, "MapThink")
	// local bruh = {
	QFire("cache*", "Kill")
	SetFXScene("fx_spawn")
	// }
	MapSay("Type zload and we will kill you instantly")

	// ListenHooks(bruh)
	// HookEvent("spawn")
	// ListenHooks(getroottable().bruh) // ok this workx because fuck you i guess

	// HookEvent(OnGameEvent_player_spawn)
	// ListenHooks(stupid)
	// CollectEventsInScopeB(this)
	ShittyListenHooks({
		function OnGameEvent_player_say(params) {
				printl(params.text)
				if (zload_regex.search(params.text) != null) {
					local ply = GetPlayerFromUserID(params.userid)
					ply.TakeDamage(9999999, Constants.FDmgType.DMG_NERVEGAS, ply)
					ClientPrint(ply,Constants.EHudNotify.HUD_PRINTCENTER, "This map doesnt really like ZLoad on this map")
				}
				if (mario_regex.search(params.text) != null) {
					local ply = GetPlayerFromUserID(params.userid)
					ply.TakeDamage(9999999, Constants.FDmgType.DMG_NERVEGAS, ply)
					ClientPrint(ply,Constants.EHudNotify.HUD_PRINTCENTER, "Super Duper Mario")
				}
				if (bot_regex.search(params.text) != null) {
					local ply = GetPlayerFromUserID(params.userid)
					ply.TakeDamage(9999999, Constants.FDmgType.DMG_NERVEGAS, ply)
					MapSay("Bottiger 殭屍逃脫創作 2019 年 1 月 27 日 M時代勳爵 Free Skial  管理員超級殭屍要塞地圖 ")
					MapSay("sts 謝爾比地圖港口 Luffaren Pissed  再見老聖誕老人 Mr. Skial Revolution 再見謝爾比 Girlfriend Stolen 宅男對抗 Uber.tf 地圖保護我們討厭彼此")
					MapSay(" Shell Community 新常客夏季 聖誕老人報告 New Regulars ~2020 聖殿的形成 The Nerf™️ 沒有更多的霰彈槍迷你槍 Temple of Bottiger March 伯克事件 GFL 激光地獄映射器 Ascension T-Rev 常客的倦怠上升映射器保存")
					MapSay("Skial 聖誕老人暗殺賽跑 TRUTH WIN 澤波爾斯 extreme runs 桿 ")
					ply.SetScriptOverlayMaterial("")
				}

				if (tiannanmen_taylorswift.search(params.text) != null) {
					local ply = GetPlayerFromUserID(params.userid)
					ply.TakeDamage(9999999, Constants.FDmgType.DMG_NERVEGAS, ply)
					MapSay("Bottiger 殭屍逃脫創作 2019 年 1 月 27 日 M時代勳爵 Free Skial  管理員超級殭屍要塞地圖 ")
					MapSay("Bottiger 殭屍逃脫創作 2019 年 1 月 27 日 M時代勳爵 Free Skial  管理員超級殭屍要塞地圖 ")
					MapSay("sts 謝爾比地圖港口 Luffaren Pissed  再見老聖誕老人 Mr. Skial Revolution 再見謝爾比 Girlfriend Stolen 宅男對抗 Uber.tf 地圖保護我們討厭彼此")
					MapSay(" Shell Community 新常客夏季 聖誕老人報告 New Regulars ~2020 聖殿的形成 The Nerf™️ 沒有更多的霰彈槍迷你槍 Temple of Bottiger March 伯克事件 GFL 激光地獄映射器 Ascension T-Rev 常客的倦怠上升映射器保存")
					MapSay("Skial 聖誕老人暗殺賽跑 TRUTH WIN 澤波爾斯 extreme runs 桿 ")
					ply.SetScriptOverlayMaterial("")
				}
			}

			function OnGameEvent_player_spawn(params) {
				local ply = GetPlayerFromUserID(params.userid)
				ScreenFade(ply, 255, 0, 0, 0, 2, 0.2, 0)
				// ply.SetModelScale(css_scale_value,0.1)
				SpawnFunc(ply) // commons spawnfunc just incase it doesnt run automatically
				ply.ValidateScriptScope()
				local scope = ply.GetScriptScope()
				scope.iMoney <- 0
				scope.TicketPaid <- false
				// there should not be cosmetics on this map
				for (local wearable; wearable = Entities.FindByClassname(wearable, "tf_wearable");) {
						wearable.Kill() // no wearables on maraihskin or game dies ?
				}

				if (ply.GetTeam() == TEAMS.HUMANS) {

					if (ply.GetPlayerClass() == 2) {
						// printl("STUPID UGLY FAG")
						// set up custom """"Class"""" loadout
						// for (local weapon; weapon = Entities.FindByClassname(weapon, "tf_weapon_sniperrifle*");) {
							// weapon.Destroy()
							// }


							// skial ze 2021 shotgun (tm)
							// local shotgun = Spawn("tf_weapon_shotgun_primary", {
							// 	model = "models/eltra/72hr/w_shotgun.mdl"
							// })
							scope.WepThink <- function() { // weapon thinker.........
								if ("iMoney" in this) {
									local hTheRapist = Spawn("game_text", { // temp
										color = "0 237 0",
										message = "BANK ACCOUNT: "+iMoney.tostring()+" MX$",
										// fadein = DIALOGUE_CHAR_TIME,
										// fadeout = 0,

										holdtime = 1,
										channel = 2,
										effect = 0,
										spawnflags = 0,
										x = 0.2,
										y = 0.15,
									})
									hTheRapist.AcceptInput("Display", "", self, null)
									// hTheRapist.AcceptInput("Kill", "", null, null)
									hTheRapist.Destroy()
								}


								for (local i = 0; i < NetProps.GetPropArraySize(self, "m_hMyWeapons"); i++) {
									local wep = NetProps.GetPropEntityArray(self,"m_hMyWeapons",i)
									if (!ValidEntity(wep)) {
										continue
									}
									wep.SetClip1(999)
									NetProps.SetPropBool(wep, "m_bBeingRepurposedForTaunt", true);

								}
								return 1
							}
							AddThinkToEnt(ply, "WepThink")
							local shotgun = SpawnWeapon("tf_weapon_shotgun_primary", 9)

							shotgun.SetModelSimple("models/eltra/72hr/w_shotgun.mdl")
							NetProps.GetPropEntityArray(ply, "m_hMyWeapons", 0).Kill() // delete sniper rifle
							local shottyindex = PrecacheModel("models/eltra/72hr/v_shotgun.mdl")
							shotgun.SetCustomViewModelModelIndex(shottyindex)
							NetProps.SetPropInt(shotgun, "m_nModelIndex", PrecacheModel("models/eltra/72hr/w_shotgun.mdl"))
							// NetProps.SetPropInt(smg, "m_nModelIndex", shottyindex)
							ply.Weapon_Equip(shotgun)
							SetParentEX(shotgun,ply)
							NetProps.SetPropBool(shotgun, "m_bBeingRepurposedForTaunt", true);
							ply.Weapon_Switch(shotgun)


							local smg = SpawnWeapon("tf_weapon_smg", 16)

							NetProps.GetPropEntityArray(ply, "m_hMyWeapons", 1).Kill() // delete sniper secondary
							smg.SetModelSimple("models/eltra/72hr/w_smg1.mdl")
							local smgindex = PrecacheModel("models/eltra/72hr/v_smg1.mdl")
							smg.SetCustomViewModelModelIndex(smgindex)
							ply.Weapon_Equip(smg)
							NetProps.SetPropBool(smg, "m_bBeingRepurposedForTaunt", true);
							// NetProps.SetPropInt(smg, "m_nModelIndex", smgindex)


							local crowbar = SpawnWeapon("tf_weapon_club", 264)

							NetProps.GetPropEntityArray(ply, "m_hMyWeapons", 2).Kill() // delete sniper melee
							crowbar.SetModelSimple("models/eltra/72hr/w_crowbar.mdl")
							local crowbarindex = PrecacheModel("models/eltra/72hr/v_crowbar.mdl")
							crowbar.SetCustomViewModelModelIndex(crowbarindex)

							// NetProps.SetPropInt(smg, "m_nModelIndex", PrecacheModel("models/eltra/72hr/w_crowbar.mdl"))
							ply.Weapon_Equip(crowbar)
							NetProps.SetPropBool(crowbar, "m_bBeingRepurposedForTaunt", true);


							// NetProps.SetPropEntityArray(ply, "m_hMyWeapons", shotgun, 0) // set sniper rifle
							// shotgun.DispatchSpawn()
							// SetParentEX(shotgun,ply, "effect_hand_R")
							// shotgun.SetOwner(ply)
							// ply.Weapon_Equip(shotgun)
							// ply.Weapon_Switch(shotgun)

							// shotgun.StudioFrameAdvance()
							// SetAnimation(shotgun, "fire")

							// the gordon crowbar
							// local crowbar = Spawn("tf_weapon_club", {
								// model = "models/eltra/72hr/w_crowbar.mdl"
							// })
							// NetProps.SetPropEntityArray(ply, "m_hMyWeapons", crowbar,2) // set sniper melee

							// crowbar.DispatchSpawn()
							// SetParentEX(crowbar,ply)
							// crowbar.SetOwner(ply)
							// crowbar.SetCustomViewModelModelIndex(PrecacheModel("models/eltra/72hr/v_crowbar.mdl"))
							// ply.Weapon_Equip(crowbar)
							// crowbar.SetModelSimple("models/eltra/72hr/w_crowbar.mdl")
							// crowbar.StudioFrameAdvance()

							// the le smg
							// local smg = Spawn("tf_weapon_smg", {
								// model = "models/eltra/72hr/w_smg1.mdl"
							// })
							// NetProps.SetPropEntityArray(ply, "m_hMyWeapons", smg, 1) // set sniper rifle

							// smg.DispatchSpawn()
							// SetParentEX(smg,ply)
							// smg.SetOwner(ply)
							// smg.SetModelSimple("models/eltra/72hr/w_smg1.mdl")
							// smg.SetCustomViewModelModelIndex(PrecacheModel("models/eltra/72hr/v_smg1.mdl"))
							// ply.Weapon_Equip(smg)
							// smg.StudioFrameAdvance()




							PrecacheModel(careymdl)
							ply.SetCustomModelWithClassAnimations(careymdl)

					} else {
						ply.SetPlayerClass(2)
						NetProps.SetPropInt(ply, "m_Shared.m_iDesiredPlayerClass", 2)
						QFireByHandle(ply, "RunScriptCode", "self.ForceRegenerateAndRespawn()",0.1)
						// ply.ForceRegenerateAndRespawn()
					}
				}
				if (ply.GetTeam() == TEAMS.ZOMBIES) {

					if (ply.GetPlayerClass() == 1) {

							PrecacheModel(lifeguardmdl)
							ply.SetCustomModelWithClassAnimations(lifeguardmdl)

					} else {
						ply.SetPlayerClass(1)
						NetProps.SetPropInt(ply, "m_Shared.m_iDesiredPlayerClass", 1)
						ply.ForceRegenerateAndRespawn()
					}
				}

			}
			function OnGameEvent_player_death(params) {
				local ply = GetPlayerFromUserID(params.userid)
				PrecacheSound("eltra/li_laura_die.mp3")
				PrecacheSound("eltra/72hr/deathscream.mp3")
				PlaySoundEX("eltra/li_laura_die.mp3", ply.GetOrigin())
				PlaySoundEX("eltra/72hr/deathscream.mp3", ply.GetOrigin())
				DoEffect("npc_gore01", ply.GetOrigin(), 0.4)

				// if (ply.GetTeam() == TEAMS.ZOMBIES) {
					// local plypos = ply.GetOrigin()
					// local plyang = ply.GetAbsAngles()

				ply.ForceRegenerateAndRespawn() // testing to fix z respawn on skial
//
					// ply.SetAbsOrigin(plypos)
				// }
			}


})
	for (local ply; ply = Entities.FindByClassname(ply, "player");) { // i went to the hack convention and everybody knew you
		ply.ForceRegenerateAndRespawn()
	}
	// RegisterScriptGameEventListener("player_say")
	// RegisterScriptGameEventListener("player_spawn")
	// RegisterScriptGameEventListener("player_death")
	// CollectEventsInScope(SysEvents)
	ze_map_say(" << "+GetMapName()+" >>")

	QFireByHandle(self, "RunScriptCode", "ze_map_say(`<< MAP CREATED BY ELTRA FOR THE TF2MAPS 72HR MAPPING JAM (2025) >>`)", 3)
	QFireByHandle(self, "RunScriptCode", "ze_map_say(`<< YOU ARE: MARIAH CAREY. >>`)", 6)
	QFireByHandle(self, "RunScriptCode", "ze_map_say(`<< YOUR OBJECTIVE: GIVE GIFTS >>`)", 8)
	QFireByHandle(self, "RunScriptCode", "ze_map_say(`<< GIVE LIFE >>`)", 11)
	QFire("xmas_mus_picker01", "PickRandom")




}

::GaySex <- function(activator) {
	QFireByHandle(activator, "RunScriptCode", "self.SetScriptOverlayMaterial(`eltra/72hr/saygex.vmt`)")
	QFireByHandle(activator, "RunScriptCode", "self.SetScriptOverlayMaterial(``)",5)
	if (activator.GetTeam() == TEAMS.HUMANS) {
		// activator.TakeDamageCustom(null, null, null, Vector(0, 0, 9999999), Vector(0, 6, 0), 999999, Constants.FDmgType.DMG_RADIATION, Constants.ETFDmgCustom.TF_DMG_CUSTOM_MERASMUS_ZAP)
		activator.TakeDamage(99999999, Constants.ETFDmgCustom.TF_DMG_CUSTOM_MERASMUS_ZAP, activator)
	} else {
		SafeTeleport(activator)
		activator.SetAbsVelocity(Vector(0,0,0))
		activator.SetAbsOrigin(MapSpawnOrigin)
	}
}

function MapThink() {
	for (local wearable; wearable = Entities.FindByClassname(wearable, "tf_wearable");) {
			wearable.Kill() // no wearables on maraihskin or game dies ?
	}
	for (local weapon; weapon = Entities.FindByClassname(weapon, "tf_weapon_*");) {
		weapon.SetClip1(9999999)
		// weapon.SetClip2(9999999) // dont exist in tf2
	}
	return 6
}
::GrannySpeakIndex <- 0
::iSteamHappies <- 0
function GrannySpeak() {
	switch (GrannySpeakIndex) {
		case 0:
		local hoostr = "Hoo hoo! I dropped my "+HappyNumber.tostring()+" steamhappies all over the floor! Hoo hoo! I need you to go and find them for me! Hoo hoo!"
		MapSay(hoostr, "granny")
		MapSay(hoostr, "granny")
		MapSay(hoostr, "granny")
		MapSay(hoostr, "granny")
		MapSay(HappyNumber.tostring() + "th one will Ruin you", "granny")
		QFire("mus_bob", "PlaySound", "", 6)
		QFire("mus_afterboss", "FadeOut", "6")
		QFire("sf_grannymod_" + RandomInt(1, 2).tostring(), "PlaySound")
		QFire("mus_afterboss", "StopSound", "", 6)
		HappyActive = true
		MakeHappies()
		GrannySpeakIndex = 1
		break;
		case 1:
		if (iSteamHappies == 7) {

			QFire("sf_grannymod_2", "PlaySound")
			QFire("sf_grannymod_2", "PlaySound","",0.25)
			QFire("sf_grannymod_2", "PlaySound","",0.5)
			MapSay("Hoo hoo! Incredible! I will opening the door up for you now! Hoo hoo! Good luck! Hoo hoo!", "granny")
			QFire("grannyfence", "Break")
			GrannySpeakIndex = 2
		} else {
			QFire("sf_im_sorry", "PlaySound")
			MapSay("Hoo hoo! I don't think so! There are still "+(7-iSteamHappies).tostring()+" for you to find! Hoo hoo!", "granny")
		}
		break;
		case 2:
			QFire("sf_poo_on_you", "PlaySound")
			MapSay("Hoo hoo! That's all I have to say! Good bye! Hoo hoo!", "granny")
			QFire("granny", "kill")
			QFire("grannyfence", "break")
		break;

	}
}

function Nightmare() {
	MapSay("This is a request by muatu3 muatu3 for Lois and Meg Griffin of Family Guy in the same peril as Francine and Haley Smith of American Dad.")
	MapSay(" https://www.furaffinity.net/view/50165159/ Lois Patrice Griffin (née Pewterschmidt) is the wife of Peter Griffin and")
	MapSay("mother of Meg, Chris, and Stewie Griffin. Lois lives at 31 Spooner Street with her family and also Brian, the anthropomorphic family dog. In The Real Live Griffins, she is portrayed by Fran Drescher.")
	MapSay(" Born Lois Pewterschmidt, Lois was brought up in an")
	MapSay("extremely wealthy household with her sister, Carol. They also have a long-lost older brother, Patrick, who was sent to a ")
	MapSay("mental asylum after he became a serial Gift Giver. She met Peter when he was employed as a towel boy by her aunt. Her rich father,")
	MapSay("Carter Pewterschmidt, cannot stand Peter and makes rude comments at every chance he gets. Peter seems to unintentionally do his absolute best to be a")
	MapSay(" Joy in her side. She also alludes to have studied at The North Pole University. Megan, aka Megatron")
	MapSay("\"Meg\" Griffin is the oldest child of Lois and Peter Griffin, and the sister of Chris and Stewie Griffin.")
	MapSay(" She is currently attending James Woods Regional High School. Meg explainsers: in \"A Great Time of Meg\" that her father changed her birth")
	MapSay("certificate to \"Megatron\" after her mother had already selected Megan. Despite this, she is still commonly called Megan such as by Mr. Berler in \"Let'")
	MapSay("s Go to the Hop\". Meg is a self-conscious and insecure adolscent girl. She is treated unfairly by")
	MapSay("various people and has numerous insecurities that prompt her to try to be part of the \"in-crowd\". However, this only results in ")
	MapSay("her getting rebuffed by the many bullies of this circle, particularly Connie D'Amico, the head cheerleader of the local high")
	QFire("player*", "RunScriptCode", "self.SetScriptOverlayMaterial(`eltra/72hr/HELP.vmt`)")
	QFire("sf_nightmare", "PlaySound")
	QFire("player*", "RunScriptCode", "self.SetScriptOverlayMaterial(``), 0.1")
	MapSay("")

}

function Mario(activator) {
	activator.TakeDamage(4658297624, Constants.FDmgType.DMG_AIRBOAT, null)
}

function SafeTeleport(activator) {
	activator.ValidateScriptScope()

	local scope = activator.GetScriptScope()

	if ("vehicle" in scope && ValidEntity(scope.vehicle)) {
		scope.vehicle.ValidateScriptScope()
		scope.vehicle.GetScriptScope().Exit(false, false)
	}

}

function MakeHappies() {
	local happyorigin = Entities.FindByName(null, "happyorigin").GetOrigin()
	for (local i = 0; i < HappyNumber; i++) {
		printl("make happy")
		SpawnTemplateEntity("tem_steamhappy", happyorigin)
	}
}