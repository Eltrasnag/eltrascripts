// IncludeScript("eltrasnag/common.nut", this)
IncludeScript("eltrasnag/mapfunc.nut")

// CHRIST IS COMING
// A MAP BY ELTRA


// PLANNED ENDINGS:

// || "REGULAR" ENDINGS ||

// IN CIC V1:

// ENDING A: "NEUTRAL" -- NOT IMPLEMENTED
// Collect some shards and reach the chapel. If stages 2 and 3 were completed in casual mode, the map is set to this ending.
// Boss fight with Mariah. Upon her death, it is revealed that her death would instantly cause Jesus to be dropped
// into a pit of magma.
// You go home empty handed. Christmas is RUINED!!!!

// ENDING B: "GOOD" ENDING -- NOT IMPLEMENTED
// Collect all the Christ Shards and bring them to the top of the mountain. Jesus splits from Mariah and unveils her true identity,
// The Devil / "Endovus". Kill Endovus to free the mountain and recieve the Christmas Wish. ("Collect" as in find and press E on them)
// All stages must be completed in *NORMAL* mode.

// ENDING C: BAD ENDING -- NOT IMPLEMENTED
// Fail each stage at least 3 times, and arrive at the chapel on Noob mode without completing *any* objective.
// Mariah arrives at the chapel before you, recieving the Christmas Wish. Lois Griffin arrives in a rocket ship, and cutscene plays where we see Mariah destroy the planet.
// There is no bossfight for this ending, as the team is already really bad if they even met this criteria.



// PLANNED FOR CIC V2:

// ENDING C: "TRANSMISSION RECIEVED"
// Collect all radios in the map, and carry them to the end of their respective stage. (Like physically carry them)
// Jesus does not show up at the chapel, and the entire map begins falling apart.
// This triggers an escape sequence down the mountain, travelling backwards through all of the stages (with all doors/walls removed)
// as the mountain begins to dissolve out of existance. Mariah gets exploded, and players escape back to the Task Room. (spawn)

// ENDING D: "SUPERDEATH"
// Reach all of the secret item areas across all 3 stages.
// God will pass his judgement on you in a replica of the Ender Dragon boss fight.

// ENDING E: "THE TRUE LASER HELL"
//


// ENDING F: THE "NEXT STEP" / *REALLY* GOOD ENDING
// Replaces the good ending on Frostbitten mode.





// STAGE BRANCHES!!!


// NORMAL PATH: 1 -> 2A -> 3

// TRANSMISSION PATHWAY -> ->



// ::SKIAL_MODE <- false

// helper vars for template spawning

XMODE_MUSIC_PITCH <- 25

::oil <- "oil"
::water <- "water"
::tee <- "tee"
::phys <- "phys"
::grav <- "grav"
::heal <- "heal"

::rals <- "rals"
::maria <- "maria"
::lois <- "lois"
::bot <- "penguin"
::fur <- "fur"
::cat <- "cat"

DEV <- true
// ::GAMEEVENTS <- {}
const MONEY_MODEL = "models/eltra/li_laserbuck.mdl"
const DIALOGUE_CHAR_TIME = 0.02
const DIALOGUE_HOLD_TIME = 3
// ::ROOT <- getroottable()

// GAME_IS_TF2 <- true
::TIME_ROUND_START <- 0
::TIME_ROUND_END <- 0

::MAP_SPAWN_ORIGIN <- null;

::MINECRAFT_BLOCKS <- 0
::MAX_MINECRAFT_BLOCKS <- 200

::XMODE <- false //xtreme
::CIC_TOUHOU_SANTA <- "eltrasnag/christiscoming/touhou_boss_santa.nut"
const INTRO_STAGE_DELAY = 6
// Stage Specific Functions

// Stage 2 Gorkulator pressure pads
::GorkPlateActive <- 0

::GorkCheck <- function() {
	if (GorkPlateActive == 3) {
		QFire("s2_gorkplate_success","trigger")
	}
}


// Stage 3 Trampoline "Elevator"

function TrampolineBounce(activator) {
	if (ButtonPressed(activator, IN_JUMP)) {
		local aVel = activator.GetAbsVelocity()
		activator.SetAbsVelocity(Vector(aVel.x, aVel.y, aVel.z * -2))
	}
}

aTitleCards <- ["titlecard_1","titlecard_2","titlecard_3","titlecard_1","titlecard_2","titlecard_3","titlecard_4"]

// hTitleCard <- Entities.FindByName(null, "TitleCard") // bruh



if (!("GAMEEVENTS" in getroottable())) { // does spawnevents already exist?
	::GAMEEVENTS <- {};
}

if (!("BRUSHMODELS" in getroottable())) {
	::BRUSHMODELS <- {};
}

// if (!("SPAWNERS" in getroottable())) { // ?
// 	::SPAWNERS <- {};
// }

// SPAWNERS.clear()

::MapDest <- Entities.FindByName(null, "map_destination")

::REMAININGLAURAS <- 0

CHARACTER_COLORS <- {
	"map" : "00FC11",
	"grandma" : "f754f5",
	"lois griffin" : "FC6D00",
	"lois" : "FC6D00",
	"grandma defense system" : "ff0004",
	"bjÖrk" : "cb0000",
}

SFXExplosions <- ["ambient/explosions/explode_5.wav",]


function StageFunctions() {

	switch (MapStage) {
		case 0:
			Entities.FindByName(null, "tem_stage1").AcceptInput("ForceSpawn", "", null, null)

			// QFire("tem_stage1", "ForceSpawn","", 0)
			SetFXScene("s1_fx_start")
			QFire("s1_tp", "Enable", "", 6)
		break;
		case 1:
			Entities.FindByName(null, "tem_stage2").AcceptInput("ForceSpawn", "", null, null)

			QFire("s2_tp", "Enable", "", 6)
			// QFire("stage2_relay", "Trigger", INTRO_STAGE_DELAY.tostring())
		break;
		case 2:
			// QFire("stage3_relay", "Trigger", INTRO_STAGE_DELAY.tostring())
			Entities.FindByName(null, "tem_stage3").AcceptInput("ForceSpawn", "", null, null)
			QFire("s3_tp", "Enable", "", 6)
			// QFire("tem_stage1", "ForceSpawn","", 0)
			// QFire("tp_stage1", "Enable", "", 6)
		break;
		case 3:
			Entities.FindByName(null, "tem_stage1").AcceptInput("ForceSpawn", "", null, null)
			QFire("s1_tp", "Enable", "", 6)
			SetXMode(true)
			// QFire("stage1_relay", "Trigger", INTRO_STAGE_DELAY.tostring())
		break;
		case 4:
			// QFire("tem_stage2", "ForceSpawn","", 0)
			Entities.FindByName(null, "tem_stage2").AcceptInput("ForceSpawn", "", null, null)
			// stage 2 tries to set the fog again, overriding xmode
			// re-set the fog after the trigger has been triggered as a hacky way to avoid this
			QFireByHandle(self, "RunScriptCode", "MAPFUNC.SetFog(`fog_xmode`)", 6.1)


			SetXMode(true)
			QFire("s2_tp", "Enable", "", 6)
			// QFire("stage2_relay", "Trigger", INTRO_STAGE_DELAY.tostring())
		break;
		case 5:
			SetXMode(true)
			Entities.FindByName(null, "tem_stage3").AcceptInput("ForceSpawn", "", null, null)

			QFire("s3_tp", "Enable", "", 6)
			// QFire("stage3_relay", "Trigger", INTRO_STAGE_DELAY.tostring())
		break;
		case 6:
			QFire("tem_stage4", "ForceSpawn","", 0)
			QFire("rtv_tp", "Enable", "", 6)
			// QFire("rtv_relay", "Trigger", INTRO_STAGE_DELAY.tostring())
		break;
		default:
			break;
	}
}

FXParticles <- {
	"explosion" : "custom_particle_002"
}

::FX_Explosion <- function(entity) {

	if (typeof(entity).tolower() == "string") {
		entity = Entities.FindByName(null, entity)
	}

	local vOrigin = entity.GetOrigin()
	DispatchParticleEffect(FXParticles["explosion"], vOrigin, entity.GetAngles())
	PlaySound("eltra/npc_slap.mp3")
	PlaySound("ambient/explosions/explode_"+RandomInt(1, 9)+".wav")
}

function LanaIntro() {
	// i am NOT a furry
	ScreenFade(null, 0, 0, 0, 255, 2, 3, 1)
	QFire("player", "RunScriptCode", "self.SetScriptOverlayMaterial(\"eltra/lana_intro.vmt\")", 0, null)
	local hLana = MakeMusic("eltra/lana.mp3")
	hLana.AcceptInput("PlaySound","",null,null)
}

raihax <- ELTRA_STEAMID;

function LaCucaracha(ply) {
	if (GetSteamID(ply) == raihax) {
		ply.ValidateScriptScope()
		local cuca = MakeMusicTF("music/eltra/cucaracha.mp3")
		cuca.KeyValueFromString("targetname", "cucaracha")
		cuca.KeyValueFromInt("health", 2)
		local scope = ply.GetScriptScope()
		scope.CucaThink <- CucaThink
		AddThinkToEnt(ply, "CucaThink")
	}
}

cic_regex <- regexp("ze_christ_is_coming")
function CucaThink() {
	local idx = self.GetEntityIndex()
	// printl("cucaNow")
	printl(PlayerVoiceListener.IsPlayerSpeaking(idx))
	if (PlayerVoiceListener.IsPlayerSpeaking(idx) == true) {
		if (PlayerVoiceListener.GetPlayerSpeechDuration(idx) < 0.75) {
			QFire("cucaracha", "PlaySound")
			// PrecacheSound("music/eltra/cucaracha.mp3")
			// QEmitSound("music/eltra/cucaracha.mp3", self)
		}
	} else {
		QFire("cucaracha", "StopSound")
		// StopAmbientSoundOn("music/eltra/cucaracha.mp3", self)
	}
	return -1
}

function Precache() {
	ShittyListenHooks({

		function OnGameEvent_player_spawn(params) {
			local ply = GetPlayerFromUserID(params.userid)

			MAPFUNC.PlayerSpawn(ply) // generic spawn functions before our special stuff (csscale, etc)
			if (XMODE == true) {
				SetFrostFX(ply, true)
			}

			ply.ValidateScriptScope() // does this even need to happen
			ply.TerminateScriptScope() // wipe the previous stale player scope so we can start anew
			ply.KeyValueFromString("ResponseContext", "") // clear contexts
			ply.ValidateScriptScope()
			local pscope = ply.GetScriptScope()
			IncludeScript("eltrasnag/christiscoming/cic_player.nut", pscope)
			ply.ValidateScriptScope()

			// LaCucaracha(ply) // prank

			if ("OnPostSpawn" in pscope) {
				pscope.OnPostSpawn() // fire the player's spawn function now

			}

		}

		function OnGameEvent_player_death(params) {
			local ply = GetPlayerFromUserID(params.userid)
			if (XMODE) {
				local context = GetContext(ply)
				if ("frostindex" in context) {
					local ent = EntIndexToHScript(context.frostindex)
					if (ent == null || !ent.IsValid()) {
						return
					}
					// printl("cleaning frost fx")
					ent.Kill()
				}
			}


		}

	})
}

function OnPostSpawn() { // ON SPAWN
	// printl("MAPSYS1") // DEBUG

	MAPFUNC.SetFog("fog_vista")
	SetSkyboxTexture("sky_cic")
	// printl("MAPSYS2") // DEBUG




	QFire("cache*", "Kill") // CAUSING PROBLEMS!
	// printl("MAPSYS3") // DEBUG


	// printl("MAPSYS4") // DEBUG

	MAPFUNC.MAP_COLOR <- "115 190 255" // hud text color
	// printl("MAPSYS5") // DEBUG



	QFire("global_overlays", "kill") // cic legacy ent, obsoleted by new vscript card system // CAUSING PROBLEMS!

	// printl("MAPSYS6") // DEBUG






	if (cic_regex.search(GetMapName()) != null) {
		MAP_SPAWN_ORIGIN = Entities.FindByName(null, "map_dest_origin").GetOrigin()

		printl("Map detected as Christ Is Coming, performing set-up logic...")
		QFire("levelcase", "Kill")
		StageFunctions() // stage-specific setup (tps, etc.)
		// printl("MAPSYS7") // DEBUG

		TitleCard() // show the stage's intro card
		// printl("MAPSYS8") // DEBUG

		if (XMODE == true) { // set frostbitten fog if applicable
			// MAPFUNC.SetFog("fog_xmode")
			SetFrostFX(true)
			// printl("MAPSYS9") // DEBUG
		} else {
			MAPFUNC.SetFog("fog_vista")
			// printl("MAPSYS10") // DEBUG

		}

		printl("MAPSYS11")
		for (local snd; snd = Entities.FindByClassname(snd, "ambient_generic");) {
			// this all seems like a very roundabout way of doing this when we could just call runscriptfile ?
			snd.TerminateScriptScope()
			// printl("MAPSYS12") // DEBUG
			snd.ValidateScriptScope()
			// printl("MAPSYS13") // DEBUG
			local scope = snd.GetScriptScope()
			// printl("MAPSYS14") // DEBUG
			scope.IncludeScript("eltrasnag/christiscoming/cic_musicplayer.nut", scope)
			// printl("MAPSYS15") // DEBUG

			// snd.AcceptInput("RunScriptFile", "eltrasnag/christiscoming/cic_musicplayer.nut",null,null)

		}
		// printl("MAPSYS16") // DEBUG
	}
	// printl("MAPSYS17") // DEBUG

	// QFireByHandle(self, "RunScriptCode", "ScanPlayers()", 6.1) // wait til finished with titlecards to do preference check // obsolete
}

function ScanPlayers() {
	for (local ply; ply = Entities.FindByClassname(ply, "player");) {
		if (ply.GetTeam() != TEAMS.SPECTATORS) {
			CheckPreferences(ply)
		}
	}
}
function ThePunishment(activator) {
	// add something scary here which gives the same aura as the guy holding mouth gif
}

function Mario(activator) {
	// Total evisceration.
	local aOrigin = activator.GetOrigin()
	PlaySound("eltra/maribubble.mp3",aOrigin)
	PrecacheScriptSound("Cic.Jumpscare")
	EmitSoundOnClient("Cic.Jumpscare", activator)
	activator.SetScriptOverlayMaterial("eltra/touhou/mario_jumpscare")
	// activator.SetAbsOrigin(999999,0,0)
	activator.TakeDamage(9999999999, Constants.FDmgType.DMG_REMOVENORAGDOLL, null)
	QFireByHandle(activator, "RunScriptCode", "self.SetScriptOverlayMaterial(``)",0.5)
	MapSay("Please do not invade my personal buble. It makes me very uncomfortable.....","mario")

}

function Splash(activator) {
	local vOrigin = activator.GetOrigin()
	DoEffect("cic_watersplash", vOrigin)

	PlaySoundEX("eltra/minecraft_watersplash.mp3", vOrigin)
	activator.Teleport(true, MAP_SPAWN_ORIGIN, false, QAngle(0, 0, 0), true, Vector(0,0,0))
	// you fell in water
}

function TitleCard() {

	// "titlecard_frostbitten"
	// try {

	// set player title card
	// QFireByHandle(self,)
	SetViewControlAll("TitleCamera", true)

	local title = Entities.FindByName(null, "TitleCard")
	title.DisableDraw()
	// local tstr = BRUSHMODELS[aTitleCards[MapStage]]
	QFireByHandle(title, "RunScriptCode", "SetBrushModel(self, `"+ aTitleCards[MapStage] +"`)", 0.1) // delay this just a little bit so brush can get index


		// Hate
	ScreenFade(null, 0,0,0,255,0.01,1, FFADE_OUT) // INITIAL DARKNESS
	QFireByHandle(self, "RunScriptCode", "ScreenFade(null, 0,0,0,255,0.01,1, FFADE_OUT)", 0.01) // FADING INTO THE TITLE CARD
	QFireByHandle(title, "RunScriptCode", "self.EnableDraw()", 1)
	QFireByHandle(self, "RunScriptCode", "ScreenFade(null, 0,0,0,255,1,0.01, FFADE_IN)", 1) // FADING INTO THE TITLE CARD
	QFireByHandle(self, "RunScriptCode", "ScreenFade(null, 0,0,0,255,1,0.01, FFADE_OUT)", 5) // FADING TO DARKNESS BEFORE STAGE TELEPORT
	QFireByHandle(self, "RunScriptCode", "ScreenFade(null, 0,0,0,255,1,0, FFADE_IN)", 6) // FADING BACK INTO STAGE


	// frostbite v normal functionality
	if (XMODE) {
		QFire("sf_title_x", "PlaySound","",0.1)
		QFire("titlecard_frostbitten", "Enable","", 3.0)
		// printl("tst")
		// QFireByHandle(self, "RunScriptCode", "ScreenFade(null, 255,0,0,60,0.25,0.1, 2)", 3.0) // RED FLASH WITH X SOUND
		// MapSay("EXTREEEEMEE!!!!!")
	} else {
		QFire("sf_title", "PlaySound","",0.1)
	}



		QFireByHandle(self, "RunScriptCode", "SetViewControlAll(`TitleCamera`, false)", 6) // DEACTIVATE THE TITLECARD CAMERA
	// } catch (exception) {
		// printl(exception)
	// }
}

function CheckPreferences(activator) {
	activator.ValidateScriptScope()
	local pscope = activator.GetScriptScope()

	if (!("Settings" in pscope) || DEV) {
		SetPreferences(activator)
		return false
	}
	return true
}

function TESTTHINK() {
	local maptime = GetTimeLeft()
	printl("timeleft: "+maptime.tostring())
	local minutes = maptime / 60
	printl("minutes: "+minutes.tostring())
	local seconds = minutes / 60
	printl("seconds: "+seconds.tostring())
	return 0.1
}
// ::SetPreferences <- function (activator) {
// 	if (DEV == true) {
// 		return
// 	}
// 	activator.ValidateScriptScope()
// 	local ascope = activator.GetScriptScope()
// 	AddThinkToEnt(activator, "")

// 	ascope.PreferenceThink <- this.PreferenceThink
// 	ascope.BeforePos <- activator.GetOrigin()
// 	ascope.iLastPrefStage <- -1
// 	ascope.iSelection <- 0
// 	ascope.iPrefStage <- 0
// 	ascope.iNextInputScan <- 0
// 	ascope.mCurSettingName <- "none"
// 	ascope.aOptions <- null
// 	ascope.iWarnInterval <- PREF_TIMEOUT_WARNWAIT
// 	ascope.iNextTimeoutWarning <- 0
// 	ascope.iPrefTimeout <- Time() + PREF_TIMEOUT
// 	ascope.bPrefDead <- false
// 	ascope.Settings <- {}


// 	AddThinkToEnt(activator, "PreferenceThink")

// }

::SetPreferences <- function(activator) {
	// obsolete
}

::GetPreference <- function(activator, setting) {
	activator.ValidateScriptScope()
	local ascope = activator.GetScriptScope()

	if ("Settings" in ascope) {
		if (setting in ascope.Settings) {
			return ascope.Settings[setting]
		}
		return false
	}

	SetPreferences(activator)
	return false
}

const PREF_TIMEOUT = 30
const PREF_TIMEOUT_WARNWAIT = 5

const PREF_OVERLAY_LEFT = "eltra/choose_selectL.vmt"
const PREF_OVERLAY_RIGHT = "eltra/choose_selectR.vmt"

const SF_MENU_HOVER = "Cic.MenuSelect"
const SF_MENU_OK = "Cic.MenuHover"
const SF_MENU_END = "Cic.MenuEnd"

enum TOUHOU_CHARACTERS{REIMU,MARISA}
enum PREFSELECT{SELECT_LEFT, SELECT_RIGHT}

const PREF_WAIT_HOVER = 0.01
const PREF_WAIT_SELECT = 0.5

::PreferenceThink <- function () {
	// if (iLastPrefStage != iPrefStage) {
		// printl("a difference")
	// }
	// iLastPrefStage = iPrefStage

	if ((self.GetTeam() != TEAMS.HUMANS) || !self.IsAlive()) {
		printl("i DIED")
		delete Settings
		AddThinkToEnt(self, "")
		return
	}

	// if (!self.IsAlive()) {
	// 	bPrefDead = true
	// } else if (bPrefDead = true) {
	// 	AddThinkToEnt(self, "")
	// 	bPrefDead = false
	// 	// SetPreferences(self)
	// }
	self.SetAbsVelocity(Vector(0,0,0))

	local fTime = Time()

	if (fTime >= iNextTimeoutWarning) {

		local tdelt = ceil(iPrefTimeout - fTime)
		printl(iPrefTimeout - Time())

		ClientPrint(self, Constants.EHudNotify.HUD_PRINTTALK, "!! YOU MUST SELECT YOUR PREFERENCES IN "+tdelt.tostring()+" SECONDS OR YOU WILL BE KILLED. !!")

		if (tdelt <= 5) {
			iWarnInterval = 1
		}

		iNextTimeoutWarning = fTime + 1

	}

	if (fTime >= iPrefTimeout) {
		ClientPrint(self, Constants.EHudNotify.HUD_PRINTCENTER, "!! YOU TOOK TOO LONG TO SELECT YOUR PREFERENCES. BETTER LUCK NEXT TIME. !!")

		AddThinkToEnt(self, "")
		self.TakeDamage(99999999, Constants.FDmgType.DMG_ALWAYSGIB, null)

	}

	if (iPrefStage != iLastPrefStage) {
		printl("new")
		self.SetScriptOverlayMaterial("")
		switch (iPrefStage) {
			case 0: // intro
			SetViewControl(self, "pref_cam_1", true)
			break;

			case 1: // choose touhou char
			SetViewControl(self, "pref_cam_1", false)
			SetViewControl(self, "pref_cam_2", true)
			mCurSettingName = "touhou"

			break;

			case 2: // end (for now)
				SetViewControl(self, "pref_cam_2", false)
				SetViewControl(self, "pref_cam_3", true)

			break;
		}
	}





	if (fTime >= iNextInputScan ) {
		if (iPrefStage > 0 && iPrefStage < 2) {

			if (ButtonPressed(self, IN_MOVELEFT) && iSelection != PREFSELECT.SELECT_LEFT) {

				iNextInputScan = fTime + PREF_WAIT_HOVER

				self.SetScriptOverlayMaterial(PREF_OVERLAY_LEFT)

				iSelection = PREFSELECT.SELECT_LEFT
				PrecacheScriptSound(SF_MENU_HOVER)
				EmitSoundOnClient(SF_MENU_HOVER, self)
				return // bad idea?
			} else if (ButtonPressed(self, IN_MOVERIGHT) && iSelection != PREFSELECT.SELECT_RIGHT) {

				iNextInputScan = fTime + PREF_WAIT_HOVER

				self.SetScriptOverlayMaterial(PREF_OVERLAY_RIGHT)

				iSelection = PREFSELECT.SELECT_RIGHT

				PrecacheScriptSound(SF_MENU_HOVER)
				EmitSoundOnClient(SF_MENU_HOVER, self)
				return

			}
		}

		if (ButtonPressed(self, IN_JUMP)) {
				if (aOptions != null) {
					Settings[mCurSettingName] <- aOptions[iSelection]
				}
				ScreenFade(self,0,0,0,255,0.1,0.1, FFADE_IN)

				iNextInputScan = fTime + PREF_WAIT_SELECT

				self.SetScriptOverlayMaterial("")

				iSelection = PREFSELECT.SELECT_RIGHT

				if (iPrefStage < 2) {
					PrecacheScriptSound(SF_MENU_HOVER)
					EmitSoundOnClient(SF_MENU_HOVER, self)

				} else { // return to normal world :)
					PrecacheScriptSound(SF_MENU_END)
					EmitSoundOnClient(SF_MENU_END, self)
					ScreenFade(self,0,0,0,255,0.5,0.1, FFADE_IN)
					AddThinkToEnt(self, "")

					SetViewControl(self, "pref_cam_3", false)
					return
				}
				iPrefStage++
				return
			}
			iNextInputScan = fTime + 0.01
		}
	iLastPrefStage = iPrefStage
	return -1
// } catch (exception) {
// }
}

MapNPCs <- {
	"ralsei": "rals",
	"maria" : "maria",
	"bottiger" : "bot",
	"bomber" : "cat",
	"orb" : "lois",
	"furry" : "fur",
}



function Incinerate(activator) {
	// lava/Electro death
	local vOrigin = activator.GetOrigin()
	DoEffect("cic_lavasplash", vOrigin)
	activator.TakeDamage(999999, Constants.FDmgType.DMG_FALL, self)
	PlaySoundEX("eltra/minecraft_watersplash.mp3", vOrigin)
}

// 		// local subproxy = Spawn("prop_dynamic_override", {model = "models/eltra/frostbite_proxy.mdl"})
		// local subproxy2 = Spawn("prop_dynamic_override", {model = "models/eltra/frostbite_proxy.mdl", origin = ply.GetOrigin()})

		// subproxy.SetAbsOrigin(ply.EyePosition())
		// fx.SetAbsOrigin(ply.EyePosition())
		// SetParentEX(subproxy, proxy)
		// SetContext(ply, "frostindex", fx.entindex())
		// local fx = Spawn("info_particle_system", { effect_name = "cic_blizzard", start_active = true })
		// NetProps.SetPropInt(fx, "m_fEffects", Constants.FEntityEffects.EF_BONEMERGE + Constants.FEntityEffects.EF_BONEMERGE_FASTCULL)
		// printl(proxy)
		// proxy.SetAbsOrigin(ply.EyePosition())
		// SetParentEX(fx, ply)
		// SetParentEX(fx, proxy)
		// SetParentEX(proxy, ply)

function SetFrostFX(ply, want) {
	if (want == true) {
		QFireByHandle(ply, "SetFogController", "fog_xmode", 0.1)
		local proxy = ClientProxy(ply)

		SetParentEX(proxy, ply)
		NetProps.SetPropInt(proxy, "m_fEffects", Constants.FEntityEffects.EF_BONEMERGE + Constants.FEntityEffects.EF_BONEMERGE_FASTCULL)
		proxy.SetModelSimple("models/eltra/frostbite_proxy.mdl")
		NetProps.SetPropInt(proxy, "m_nModelIndex", PrecacheModel("models/eltra/frostbite_proxy.mdl"))

		SetContext(ply, "frostindex", proxy.entindex())

	} else {
		local context = GetContext(ply)
		if ("frostindex" in context) {
			local ent = EntIndexToHScript(context.frostindex)
			if (ent == null || !ent.IsValid()) {
				return
			}
			ent.Kill()
		}

	}


}



function SetXMode(mode) {
	if (mode == true) {
		local musent;

		local mus_regex = regexp("mus_")
		QFireByHandle(self, RunScriptCode, "SetXModeDelayed()", 6)
		// QFire("ambient_generic*", "pitch", XMODE_MUSIC_PITCH.tostring(), 6)
		QFire("tem_xmode", "ForceSpawn") // all the "new" stage triggers and whatevers
		SetSkyboxTexture("sky_frostbitten_")
		XMODE = true;
		for (local ply; ply = Entities.FindByClassname(ply, "player");) {
			SetFrostFX(ply, true)
		}
		MAPFUNC.SetFog("fog_xmode")
	} else {
		for (local ply; ply = Entities.FindByClassname(ply, "player");) {
			SetFrostFX(ply, false)
		}
		MAPFUNC.SetFog("fog_vista")
	}
}

::HalfLifeExplosion <- function(ent) {
	local origin = ent.GetOrigin()
	DoEffect("cic_explosion", origin)
	PlaySoundEX("eltra/explode"+RandomInt(3,5)+".mp3", origin, 100, RandomInt(90,110), null, 10000)
	PlaySoundEX("eltra/explode"+RandomInt(3,5)+".mp3", origin, 100, RandomInt(90,110), null, 10000)
	PlaySoundEX("eltra/explode"+RandomInt(3,5)+".mp3", origin, 100, RandomInt(90,110), null, 10000)
}

function SetXModeDelayed() {
	Spawn("info_teleport_destination", { vscripts = "eltrasnag/christiscoming/xmode_edits.nut", targetname = "!XMODE_EDITS"})
	for (local i = 0; i < 3; i++) {
		local windsfx = MakeMusicTF("eltra/gmsc/scorched/scorched_ambient_loop.wav")
		QAcceptInput(windsfx, "PlaySound")
	}
}