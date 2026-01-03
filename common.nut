// if (!("MAPFUNC" in getroottable())) { // redundant. map functions have been moved to MapFunc.nut. use the MAPFUNC table if you need toaccess them
// 	getroottable().MAPFUNC <- {
// 	    "eltramapvars version ": "1.0"
// 	};
// }
// if (!("GAMEEVENTS" in getroottable())) {
// 	::GAMEEVENTS <- {}
// }
// GAMEEVENTS.clear()


::css_scale <- true,
::css_scale_normal <- 1,
::css_scale_skial <- 0.70,
::css_scale_accurate <- 0.865 // but can't fit through doors!
::ROOT <- getroottable()
const DIALOGUE_CHAR_TIME = 0.02
const DIALOGUE_HOLD_TIME = 3
// if (!("ELT" in getroottable())) {
	// getroottable().ELT <- {

	    // "eltracommons version": "1.0"
	// };
// }

// if (!("ECONSTANTS" in getroottable())) {
// 	getroottable().ECONSTANTS <- {
// 		"eltraconstants version": "1.0",

const CUBT_ORIGIN = "origin"
const CUBT_NOSTRING = ""
const CUBT_RUNSCRIPTFILE = "RunScriptFile"
const CUBT_RUNSCRIPTCODE = "RUNSCRIPTCODE"
const CUBT_DISPLAY = "Display"
const CUBT_MESSAGE = "message "
const CUBT_KILL = "Kill"
const CUBT_GAMETEXT = "game_text"
const CUBT_FUNCBRUSH = "func_brush"
const CUBT_COLOR = "color"
// const // common colors
const COLOR_RED = "255 0 0"
const COLOR_BLUE = "0 0 255"
const COLOR_GREEN = "0 255 0"
const COLOR_WHITE = "255 255 255"
// const // my steamid
::ELTRA_STEAMID <- "[U:1:172776231]"
// const // fades
const FADE_IN = 1
const FADE_OUT = 2
const FADE_MODULATE = 4
const FADE_STAYOUT = 8
const FADE_PURGE = 16
// const // buttons
const IN_ATTACK = 1
const IN_JUMP = 2
const IN_DUCK = 4
const IN_FORWARD = 8
const IN_BACK = 16
const IN_USE = 32
const IN_CANCEL = 64
const IN_LEFT = 128
const IN_RIGHT = 256
const IN_MOVELEFT = 512
const IN_MOVERIGHT = 1024
const IN_ATTACK2 = 2048
const IN_RUN = 4096
const IN_RELOAD = 8192
const IN_ALT1 = 16384
const IN_ALT2 = 32768
const IN_SCORE = 65536
const IN_SPEED = 131072
const IN_WALK = 262144
const IN_ZOOM = 524288
const IN_WEAPON1 = 1048576
const IN_WEAPON2 = 2097152
const IN_BULLRUSH = 4194304
const IN_GRENADE1 = 8388608
const IN_GRENADE2 = 16777216
const IN_ATTACK3 = 33554432
const IN_MOVELEFT  = 512
const IN_MOVERIGHT  = 1024
// const // movetypes
const MOVETYPE_NONE = 0
const MOVETYPE_ISOMETRIC = 1
const MOVETYPE_WALK = 2
const MOVETYPE_STEP = 3
const MOVETYPE_FLY = 4
const MOVETYPE_FLYGRAVITY = 5
const MOVETYPE_VPHYSICS = 6
const MOVETYPE_PUSH = 7
const MOVETYPE_NOCLIP = 8
const MOVETYPE_LADDER = 9
const MOVETYPE_OBSERVER = 10
const MOVETYPE_CUSTOM = 11
const MOVETYPE_LAST = 11
// const // movecollides
const MOVECOLLIDE_DEFAULT = 0
const MOVECOLLIDE_FLY_BOUNCE = 1
const MOVECOLLIDE_FLY_CUSTOM = 2
const MOVECOLLIDE_FLY_SLIDE = 3
const MOVECOLLIDE_MAX_BITS = 3
const MOVECOLLIDE_COUNT = 4
// const // flags
::FL_ONGROUND <- 1
::FL_DUCKING <- 2
::FL_ANIMDUCKING <- 4
::FL_WATERJUMP <- 8
::PLAYER_FLAG_BITS <- 11
::FL_ONTRAIN <- 16
::FL_INRAIN <- 32
::FL_FROZEN <- 64
::FL_ATCONTROLS <- 128
::FL_CLIENT <- 256
::FL_FAKECLIENT <- 512
::FL_INWATER <- 1024
::FL_FLY <- 2048
::FL_SWIM <- 4096
::FL_CONVEYOR <- 8192
::FL_NPC <- 16384
::FL_GODMODE <- 32768
::FL_NOTARGET <- 65536
::FL_AIMTARGET <- 131072
::FL_PARTIALGROUND <- 262144
::FL_STATICPROP <- 524288
::FL_GRAPHED <- 1048576
::FL_GRENADE <- 2097152
::FL_STEPMOVEMENT <- 4194304
::FL_DONTTOUCH <- 8388608
::FL_BASEVELOCITY <- 16777216
::FL_WORLDBRUSH <- 33554432
::FL_OBJECT <- 67108864
::FL_KILLME <- 134217728
::FL_ONFIRE <- 268435456
::FL_DISSOLVING <- 536870912
::FL_TRANSRAGDOLL <- 1073741824
::FL_UNBLOCKABLE_BY_PLAYER <- 2147483648

// col masks
::MASK_ALL <- -1
::MASK_SPLITAREAPORTAL <- 48
::MASK_SOLID_BRUSHONLY <- 16395
::MASK_WATER <- 16432
::MASK_BLOCKLOS <- 16449
::MASK_OPAQUE <- 16513
::MASK_DEADSOLID <- 65547
::MASK_PLAYERSOLID_BRUSHONLY <- 81931
::MASK_NPCWORLDSTATIC <- 131083
::MASK_NPCSOLID_BRUSHONLY <- 147467
::MASK_CURRENT <- 16515072
::MASK_SHOT_PORTAL <- 33570819
::MASK_SOLID <- 33570827
::MASK_BLOCKLOS_AND_NPCS <- 33570881
::MASK_OPAQUE_AND_NPCS <- 33570945
::MASK_VISIBLE_AND_NPCS <- 33579137
::MASK_PLAYERSOLID <- 33636363
::MASK_NPCSOLID <- 33701899
::MASK_SHOT_HULL <- 100679691
::MASK_SHOT <- 1174421507
// const // fades (but with an F this time)
::FFADE_IN <- 1
::FFADE_OUT <- 2
::FFADE_MODULATE <- 4
::FFADE_STAYOUT <- 8
::FFADE_PURGE <- 16
// const // screenshakes
const SHAKE_START = 0
const SHAKE_STOP = 1
const SHAKE_AMPLITUDE = 2
const SHAKE_FREQUENCY = 3
const SHAKE_START_RUMBLEONLY = 4
const SHAKE_START_NORUMBLE = 5
// 	};

// }
const RunScriptCode = "runscriptcode"

// const css_scale_value = 0.875 // too big for half life doors :/

const css_scale_value = 0.70



const SPAWNFLAGS_PUPPET = 49153
::MAP_COLOR <- "255 255 255"
// stringtable optimizations










const ZE_TIMER_PREFIX = " ▷▷ "
const ZE_TIMER_SUFFIX = " SECONDS LEFT ◁◁ "

// surely it wont break like the touhou one did
::DownVec <- Vector(0,0,-1)
::UpVec <- Vector(0,0,1)







::VALID_BREAKABLES <- ["func_physbox", "func_physbox_multiplayer", "func_breakable", "base_boss", "prop_physics", "prop_physics_override", "prop_physics_multiplayer","func_brush", "func_door", "player"]; // for npc & weapon system.


::DEV <- true
::DEVELOPER_MODE <- DEV

::CHARACTER_COLORS <- {
	"map" : "00FC11",
	"grandma" : "f754f5",
	"lois griffin" : "FC6D00",
	"lois" : "FC6D00",
	"grandma defense system" : "ff0004",
	"bjÖrk" : "cb0000",
	"banban" : "a80000",
	"reimu" : "ff002e",
	"leshawna ball oc" : "e9dfad",
	"orange" : "fc681e",
	"taylor swift" : "ff1f50",
	"eltra" : "ff8412",
	"the incubus" : "ceff1c",
	"granny" : "e0cb6e",
	"santa claus" : "ff0015",
	"mario" : "eb3437",
	// dont forget to assign the colors to the cic characters :p
	"jesus christ" : "eb3437",
	"god" : "eb3437",
	"mariah carey" : "eb3437",
	"antygore" : "eb3437",
	"ferven" : "eb3437",
	"the mechanism" : "eb3437",
	"endovus" : "eb3437",
	"santa claus" : "eb3437",
	"granny mk. ii" : "eb3437",
}

::FX_SCENE <- "non" // for area particles.

enum TEAMS {
	HUMANS = 3,
	ZOMBIES = 2,
	SPECTATORS = 1,
	UNASSIGNED = 0,
}

// if (!("BRUSHMODELS" in getroottable())) {
// 	BRUSHMODELS <- {};
// }

// for banban map
::bFirstStage2 <- true


// __CollectGameEventCallbacks(this)


::SetFXScene <- function(scene_name = "") {
	FX_SCENE = scene_name
}





::QFire <- function(target, action = "", value = "", delay = 0.0, activador = null) {
	EntFire(target, action, value, delay, activador)
	// is this necessary // it is!
	if (regex_runscriptcode.search(action.tolower())) {
		CleanString(value)
	}
	// local h1 = Spawn("info_target", {})

	// local h2 = Spawn("info_target", {})

	// local h3 = Spawn("info_target", {})

	// h1.KeyValueFromString("targetname", action)
	// h1.Kill()
	// h2.KeyValueFromString("targetname", value)
	// h2.Kill()
	// h3.KeyValueFromString("targetname", target)
	// h3.Kill()
}


::CleanString <- function(action) { // make entity
		local h1 = Spawn("info_target", {}) // is there a reason this is info target
		h1.KeyValueFromString("targetname", action)
		h1.Destroy()
}

::QFireByHandle <- function(entity, action = "", value = "", delay = 0.0, activador = null, cadder = null) {
	// try {
	EntFireByHandle(entity, action, value, delay, activador, cadder)

	if (regex_runscriptcode.search(action.tolower())) { // i think we only need to do this for runscriptcode ?
		// CleanString(action)
		CleanString(value)
	}

	// local h1 = Spawn("info_target", {})

	// local h2 = Spawn("info_target", {})

	// h1.KeyValueFromString("targetname", action)
	// h1.Kill()
	// h2.KeyValueFromString("targetname", value)
	// h2.Kill()

}

::GetLength <- function(vector) {
	// local v = vector

	// v.Length()
	// v = vector.Length()
	// printl("LENGTH:"+v)
	return v
}

::SafePurge <- function(ent) { // hopefully make entity clean itself up to minimize stringtable usage
	NetProps.SetPropBool(ent, "m_bForcePurgeFixedupStrings", true)
}

::sPurge <- function(ent) { // shorter wrapper fofr safepurge
	SafePurge(ent)
}

::EnableMotion <- function(ent) {
	ent.AcceptInput("EnableMotion","",null,null)
	return ent
}

::DisableMotion <- function(ent) {

	ent.AcceptInput("DisableMotion","",null,null)
	return ent
}

// RegisterScriptGameEventListener("player_spawn")




// events <- {
// function OnGameEvent_player_spawn(data) { // whati s your problem
// 	local ply = GetPlayerFromUserID(data.userid)
// 		if (ValidEntity(ply)) {
// 			SpawnFunc(ply)

// 		}
// 	}
// }


::DPrint <- function(msg = "NO MSG") {
	if (DEV) {
		printl("ELTRASCRIPTS: " + msg);
	}
}





function OnGameEvent_scorestats_accumulated_reset(event) {
}

::IsAlive <- function(hPlayer) {
	if ((NetProps.GetPropInt(hPlayer,"m_iHealth") < 1)) {
		return false
	}
	return true
}

function OnPostSpawn() {

	// ListenHooks(events)
	// RegisterScriptGameEventListener("scorestats_accumulated_reset")
	// RegisterScriptGameEventListener("scorestats_accumulated_update")
}

::DoDialogueArray <- function(aDialogues = ["ERR_NO_DIALOGUE"], strCharacter = "ERR_CHAR", iGlobal = 1) {

	local flDelay = 0.0

	foreach (strDialogue in aDialogues) {

		// printl("strDialogue: "+strDialogue.tostring())

		local strFireValue = "DoDialogue(\"" + strDialogue + "\",\"" + strCharacter + "\",false," + iGlobal.tostring() + ")"

		QFireByHandle(self, "CUBT_RUNSCRIPTCODE", strFireValue, flDelay, null, null) // queue all dialogues in sequence
		flDelay += DoDialogue(strDialogue, strCharacter, true) + 0.1
	}
}



::DoDialogue <- function(strDialogue = "ERR_NO_DIALOGUE", strCharacter = "ERR_CHAR", bTimeOnly = false, iGlobal = 1) {

	strDialogue = strCharacter.toupper() + ": " + strDialogue

	local flEnterTime = DIALOGUE_CHAR_TIME * strDialogue.len()
	local flLifeTime = (flEnterTime + DIALOGUE_HOLD_TIME)

	// printl("flEnterTime = "+flEnterTime.tostring())
	// printl("flLifeTime = "+ flLifeTime.tostring())

	if (bTimeOnly == true) {
		return flLifeTime
	}


	local vColor = Vector(255,255,255)

	if (strCharacter.tolower() in tCharacters) {
		vColor = tCharacters[strCharacter]
		// printl("Special character : "+strCharacter)
	}

	ClientPrint(null, 3, strDialogue)

	local hTheRapist = Spawn("game_text", { // temp
		color = vColor,
		// message = strDialogue,
		// fadein = DIALOGUE_CHAR_TIME,
		// fadeout = 0,
		holdtime = DIALOGUE_HOLD_TIME,
		channel = 2,
		effect = 0,
		spawnflags = 1,
		x = 0.0,
		y = 0.7,
	})


	hTheRapist.AcceptInput("Display","",null,null)

	local hText = Spawn("game_text", {
		color = vColor,
		message = strDialogue,
		fadein = DIALOGUE_CHAR_TIME,
		holdtime = DIALOGUE_HOLD_TIME,
		channel = 2,
		effect = 1,
		spawnflags = 1,
		x = 0.0,
		y = 0.7,
	})

	hText.AcceptInput("Display","",null,null)
	hText.AcceptInput("Kill","",null,null)
	hTheRapist.AcceptInput("Kill","",null,null)

}

::DoDialogueOnClient <- function(ply, strDialogue = "ERR_NO_DIALOGUE", strCharacter = "ERR_CHAR", bTimeOnly = false) {

	strDialogue = strCharacter.toupper() + ": " + strDialogue

	local flEnterTime = DIALOGUE_CHAR_TIME * strDialogue.len()
	local flLifeTime = (flEnterTime + DIALOGUE_HOLD_TIME)

	// printl("flEnterTime = "+flEnterTime.tostring())
	// printl("flLifeTime = "+ flLifeTime.tostring())

	if (bTimeOnly == true) {
		return flLifeTime
	}


	local vColor = Vector(255,255,255)

	if (strCharacter.tolower() in tCharacters) {
		vColor = tCharacters[strCharacter]
	}

	ClientPrint(ply, 3, strDialogue)

	// ClientPrint(ply, Constants.EHudNotify.HUD_PRINTTALK, strDialogue)
	local hTheRapist = Spawn("game_text", { // temp
		color = vColor,
		message = strDialogue,
		fadein = DIALOGUE_CHAR_TIME,
		fadeout = 0,
		holdtime = DIALOGUE_HOLD_TIME,
		channel = 2,
		effect = 2,
		spawnflags = 0,
		x = -1,
		y = 0.7,
	})

	hTheRapist.AcceptInput("Display","",ply,ply)
	hTheRapist.Kill()



}

function DialogueThink() {
	// printl("MAX LIFE "+flLifeTime.tostring())
	if (flLifeTime <= iTimer) {
		// printl("DIALOGUE SHOULD DIE NOW????")
		self.Destroy()
	}
	printl(iTimer)
	iTimer += 0.0166666666666667
	return -1
}

::GetUserID <- function(hPlayer) {
	return NetProps.GetPropInt(hPlayer, "m_iUserID")
}

::KillDelayed <- function(hEnt, flDelay) {
	QFireByHandle(hEnt, "KillHierarchy", "", flDelay, null, null)
}

::ClearParent <- function(ent) {
	ent.AcceptInput("ClearParent", "",null,null)
}

::ClearParent <- ClearParent

::SetParentEX <- function(iEnt,iParent, strAttachment = null) {
	if (iParent == null) {
		iEnt.AcceptInput("ClearParent","",null,null)
		return iEnt
	}

	iEnt.AcceptInput("SetParent", "!activator", iParent, iEnt)
	// CleanString(SetParent)
	// QFireByHandle(iEnt, "SetParent", "!activator", 0.0, iParent, null)

	// if (iParent.GetClassname() == "player") {
	// 	local hPlayer = iParent

	// }


	if (strAttachment) {
		// local iAttachID = iEnt.LookupAttachment(strAttachment)
		// iEnt.AcceptInput("SetParentAttachment", strAttachment, null, null)
		QFireByHandle(iEnt, "SetParentAttachment", strAttachment, 0.1,null,  null)
	}
	return iEnt
}

::GetAngleTo <- function(to, from)
{
	return QAngle(0, atan2(to.y - from.y, to.x - from.x) * 180 / PI, 0)
}

::MapSayArray <- function(aDialogues = ["ERR_NO_DIALOGUE"], strCharacter = null) {

	local flDelay = 0.0

	foreach (strDialogue in aDialogues) {


		local strFireValue = "MapSay(\"" + strDialogue + "\",\"" + strCharacter + "\")"

		QFireByHandle(self, "CUBT_RUNSCRIPTCODE", strFireValue, flDelay, null, null) // queue all dialogues in sequence
		flDelay += 1.5
	}

}


::MapSay <- function (strMsg = "ERR NO MESSAGE", strCharacter = "MAP")
{
	local strMessageColor = "\x07FAFCFF"
	strMsg = strMessageColor+strMsg
	if (strCharacter) {
		strCharacter = strCharacter.tolower()
		local strColor = "\x0700FC11"
		if (strCharacter in CHARACTER_COLORS) {

			if (strCharacter == "lois" || strCharacter == "lois griffin") { // whatsapp
				local textsound = MakeMusic("eltra/lois_text.mp3")
				textsound.AcceptInput("PlaySound","",null,null)
				textsound.Kill()
			}

			// printl("found you")
			strColor = "\x07"+CHARACTER_COLORS[strCharacter]+" " // no need to ToUpper this?
		}
		strMsg = strColor + strCharacter.toupper() + strMessageColor + " :  "  + strMsg
	}
	ClientPrint(null, 3, strMessageColor + strMsg);
	CleanString(strMessageColor)
	CleanString(strMsg)
	CleanString(strCharacter)
}

::RandomCT <- function() {
	local aHumans = []
	for (local i = null; i = Entities.FindByClassname(i, "player");) {
		if (i.GetTeam() == TEAMS.HUMANS) {
			aHumans.append(i)
		}
	}
	local iArrayLength = aHumans.len()
	if (iArrayLength != 0) {
		return aHumans[RandomInt(0,aHumans.len() - 1)]

	}
}

::GetMovementVector <- function(to, from) {
	local v1 = to - from
	v1.Norm()
	return v1
}

::GetNormalized <- function(vec) {
	local v = Vector(vec) // lazy qangle support
	v.Norm()
	return v
} // why dont this work...

::GetMovementVector2D <- function(to, from) {
	local v1 = to - from
	v1.z = 0
	v1.Norm()
	return v1
}

::GetDistance <- function(to, from) { // wrapper for below
	return GetDistanceTo(to, from)
}
::GetDistanceTo <- function(to, from) {
	return sqrt( pow(to.x - from.x, 2) + pow(to.y - from.y,2) + pow(to.z - from.z,2) )
}

::GetDistance2D <- function(to, from) {
	return sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y,2))
}

::GetDistance2DSquared <- function(to, from) {
	return pow(to.x - from.x, 2) + pow(to.y - from.y,2)
}

::GetPlayerName <- function(hPlayer) {
	return NetProps.GetPropString(hPlayer, "m_szNetname")
}

::GetSteamID <- function(hPlayer) {
	return NetProps.GetPropString(hPlayer, "m_szNetworkIDString")
}

::SetAnimation <- function(hEnt, strAnimation, bDoDefault = false) {
	if (ValidEntity(hEnt))
	{
		if (bDoDefault) {
			hEnt.AcceptInput("SetDefaultAnimation",strAnimation,null,null)
		}
		hEnt.AcceptInput("SetAnimation",strAnimation,null,null)
		CleanString(strAnimation)
	}
}



::MapSayDelayed <- function(text = "NOTEXT - MAPSAYDELAY", char = "MAP", delay = 0.0) {
	QFireByHandle(self, "CUBT_RUNSCRIPTCODE", "MapSay(`"+ text +"`,`"+ char +"`)", delay, null, null)
}

::MapSayDelay <- function(text = "NOTEXT - MAPSAYDELAY", char = "MAP", delay = 0.0) { // wrapper for mapsaydelayed
	MapSayDelayed(text, char, delay);
}


::ButtonPressed <- function(hPlayer, iButton) {
	if (NetProps.GetPropInt(hPlayer, "m_nButtons") & iButton) {
		return true
	}
	return false
}
::ButtonPressed <- ButtonPressed

::SetMapFX <- function(nam) {
	SetFXScene(nam)
}
::MakeParticleSystem <- function(name, starts_active = false) {
	// PrecacheParticle(name)
	local pcf = Spawn("info_particle_system",{ targetname = "item_fx", effect_name = name, start_active = starts_active })
	return pcf
}

::DoEffect <- function(name, origin = Vector(0, 0, 0), lifetime = 0.1, angle = QAngle(0, 0, 0)) {
	local pcf = MakeParticleSystem(name, true)
	pcf.SetAbsOrigin(origin)
	pcf.SetAbsAngles(angle)

	pcf.AcceptInput("Start","",null,null)
	QFireByHandle(pcf,"Kill","", lifetime)
	return pcf

	// pcf.Kill()
}

::DisablePlayerWeapons <- function(ply) {
	ply.RemoveCond(Constants.ETFCond.TF_COND_TAUNTING)
	// SetContext(ply, "ActiveWeaponSlot", NetProps.GetPropInt(ply, "m_iWeaponSlot"))
	if (ply.GetActiveWeapon() == null) {
		printl("ELTRACOMMONS: Not disabling player weapons..... something has gone wrong. Where isthe player weapon!")
		return
	}
	SetContext(ply, "ActiveWeaponSlot", ply.GetActiveWeapon().entindex())

	local gameui = Spawn("game_ui", {
		spawnflags = 64,
	})
	gameui.AcceptInput("Activate", "", ply, null)
	gameui.Kill()
}

::EnablePlayerWeapons <- function(ply) {
	ply.RemoveHudHideFlags(Constants.FHideHUD.HIDEHUD_WEAPONSELECTION);
	local gameui = Spawn("game_ui", {
		spawnflags = 64,
	})
	local wep = null
	local context = GetContext(ply)
	if ("ActiveWeaponSlot" in context) {
		// slot = context.ActiveWeaponSlot
		wep = EntIndexToHScript(context.ActiveWeaponSlot)
		printl("Slotty "+wep)
	} else {
		wep = NetProps.GetPropEntityArray(ply, "m_hMyWeapons", 0)
	}

	// NetProps.SetPropEntity(ply, "m_hActiveWeapon", NetProps.GetPropEntityArray(ply, "m_hMyWeapons", slot));
	// NetProps.SetPropEntity(ply, "m_hActiveWeapon", NetProps.GetPropEntityArray(ply, "m_hMyWeapons", slot));
	NetProps.SetPropEntity(gameui, "m_player", ply);


	ply.Weapon_Switch(wep)
	// gameui.AcceptInput("Activate", "", ply, null)
	gameui.AcceptInput("Deactivate", "", ply, null)
	// gameui.AcceptInput("Activate", "", ply, ply)
	gameui.Kill()
}

::QuickTrace <- function(vstart, vend, ignorething = null, mask = MASK_PLAYERSOLID_BRUSHONLY) {
		if (!(ignorething == null || ValidEntity(ignorething))) {
			printl("ELTRACOMMONS: QuickTrace error! 'Ignore' set to invalid entity, failing gracefully to not crash the game!")
			return
		}

		local traceparams = {
			start = vstart,
			end = vend,
			pos = vend, // just incase
			ignore = ignorething,
			hit = false,
			enthit = null, // one less null check
		}
		TraceLineEx(traceparams)
		return traceparams
}
// QuickTrace.bindenv(getroottable())
::QuickTrace <- QuickTrace

::QuickTraceHull <- function(vstart, vend, ihullmin, ihullmax, ignorething) {
		local traceparams = {
			start = vstart,
			end = vend,
			hullmin = ihullmin,
			hullmax = ihullmax,
			pos = vstart, // just incase
			ignore = ignorething
		}
		if (DEV) {
			DebugDrawBox(traceparams.start, traceparams.hullmin, traceparams.hullmax, 0, 0, 255, 15, 10)
		}
		TraceHull(traceparams)
		return traceparams
}
::QuickTraceHull <- QuickTrace


::PrecacheParticle <- function(name)
{
	PrecacheEntityFromTable({ classname = "info_particle_system", effect_name = name })
	return name
}





// clamp shorthands

::clamp <- function(value, min, max) {
	if (value < min) {
		return min
	}
	if (value > max) {
		return max
	}
	return value
}
::clamp <- clamp

::clampvec <- function(vec, vecmin, vecmax) {
	vec.x = clamp(vec.x, vecmin.x, vecmax.x)
	vec.y = clamp(vec.y, vecmin.y, vecmax.y)
	vec.z = clamp(vec.z, vecmin.z, vecmax.z)
	return vec
}

::clampmaxvelocity <- function(vec) {
	return clampvec(vec, Vector(-3000,-3000,-3000), Vector(3000,3000,3000))
}




::ValidEntity <- function(hHandle) {
	if (hHandle != null && hHandle.IsValid()) {
		return true
	}
	else {
		return false
	}
}
::ValidEntity <- ValidEntity

::ValidHandle <- function(hHandle) {
	if (hHandle != null) {
		return true
	}
	else {
		return false
	}
}

::GetAngleFromEntity <- function(to_ent, from_ent)
{
	local from = from_ent.GetOrigin();
	local to = to_ent.GetOrigin()
	return QAngle(0, atan2(from.y - to.y, from.x - to.x) * 180 / PI, 0)
}

::FindAng <- function(v1,v2)
{
    if (v1 && v2 != null)
    {
    local vangz = (v1.z-v2.z)
    local vangy = (v1.y-v2.y)
    local vangx = (v1.x-v2.x)
    return (QAngle(vangx,vangy,vangz))
    }
}

::GetLookVector <- function(from, target) {
	local vOrigin = from.GetOrigin()
	local rAng = FindAng(target.GetOrigin(),vOrigin)
	local ba = target.GetOrigin();
	local aa = vOrigin;
	local ldir = (aa - ba);
	ldir.Norm();
	return ldir
}

::GetLookVector2 <- function(v1, v2) {
	local ba = v2;
	local aa = v1;
	local ldir = (aa - ba);
	ldir.Norm();
	return ldir
}

::GetLookAngle <- function(from_origin, to_origin) // the above function done infinitely better
{
	return QAngle(0, atan2(to_origin.y - from_origin.y, to_origin.x - from_origin.x) * 180 / PI, 0)
}


::absVec <- function(vecA) {
	return Vector(abs(vecA.x), abs(vecA.y), abs(vecA.z))
}
::divVec <- function(vecA, vecB) {


	return Vector(vecA.x / vecA.x, vecA.y / vecB.y, vecA.z / vecB.z)
}
::multVec <- function(vecA, vecB) {


	return Vector(vecA.x * vecA.x, vecA.y * vecB.y, vecA.z * vecB.z)
}
::vecAng <- function(vecA, vecB) {
	// local vecP1 = vecB - vecA;
	// local vecP2 = vec

	local ret1 = QAngle(atan2(vecB.x - vecA.x, vecB.y - vecA.y), atan2(vecB.y - vecA.y, vecB.x - vecA.x), atan2(vecB.x - vecA.x, vecB.z - vecA.z))
	// printl("vecAng: "+ret1.tostring())
	return ret1
}

::GetBrushModel <- function(ent) {
	return NetProps.GetPropString(ent, "m_ModelName")
}

::PlaySound <- function(strSoundName, vPos, flVol = 0.8) {
	PrecacheSound(strSoundName)
	// printl("play sound ?")
	EmitSoundEx({
		sound_name = strSoundName,
		channel = 1, // CHAN_AUTO
		origin = vPos,
		volume = flVol,
		sound_level = 0.5
	})
}

::PlaySoundEX <- function(strSoundName, vPos = Vector(0,0,0), flVol = 10, flPitch = 100, sourceentity = null, iradius = 2048) {
	PrecacheSound(strSoundName)
	local paramstable = {
		message = strSoundName,
		origin = vPos,
		health = flVol,
		radius = iradius,
		pitch = flPitch,
		spawnflags = 48,
	}

	if (sourceentity) {
		paramstable.SourceEntityName <- sourceentity.GetName()
	}

	local hSound = Spawn("ambient_generic", paramstable)

	hSound.AcceptInput("PlaySound","",null,null)
	if (!sourceentity) {
		hSound.Kill()
	} else {
		QFireByHandle(hSound, "Kill", "", 10)
	}
	CleanString(strSoundName)
}

const SF_ITEM_EQUIP = "eltra/item_get.mp3"

::GrabWeaponSound <- function(ent) {
	// EntSound(ent, SF_ITEM_EQUIP)
	PlaySoundEX(SF_ITEM_EQUIP, ent.GetOrigin())
}

::EntSound <- function(sourceentity, strSoundName, sradius = 1024, flVol = 10, flPitch = 100) {
	PrecacheSound(strSoundName)
	local paramstable = {
		message = strSoundName,
		origin = sourceentity.GetOrigin(),
		health = flVol,
		radius = sradius,
		// SourceEntityName = sourceentity.GetName(),
		spawnflags = 48,
	}

	local hSound = Spawn("ambient_generic", paramstable)

	hSound.AcceptInput("PlaySound","",null,null)
	hSound.Kill()
}

::WeapInitTF <- function(ent) {
	local hWearable = ent
		// local hWearable = SpawnEntityFromTable("tf_wearable",
			// {
				// classname = "0",
				// origin = hPlayer.GetOrigin(),
				// angles = hPlayer.EyeAngles()
			// });
			// ent.KeyValueFromString("classname", "0")

			// MarkForPurge(hWearable);
			// NetProps.SetPropIntArray(hWearable, "m_nModelIndex", PrecacheModel("models/props_2fort/miningcrate002.mdl"), 0);
			// NetProps.SetPropBool(hWearable, "m_bValidatedAttachedEntity", true);
			// NetProps.SetPropBool(hWearable, "m_AttributeManager.m_Item.m_bInitialized", true);
			// NetProps.SetPropInt(hWearable, "m_fEffects", Constants.FEntityEffects.EF_NODRAW);

			// hWearable.SetOwner(hPlayer);
			// hWearable.AcceptInput("SetParent", "!activator", hPlayer, null);
			// SetParentEX(iEnt, hWearable)
			// hWearable.KeyValueFromInt("rendermode",10)
			// hWearable.DisableDraw()
}


// MUSIC RELATED FUNCTIONS

::MakeMusicTF <- function(strSoundName, tname = "") {

	PrecacheSound(strSoundName)

	local tSoundTable = {
		targetname = tname,
		message = strSoundName,
		health = 10,
		spawnflags = 17,

	}
	local hSound = Spawn("ambient_generic", tSoundTable)

	return hSound
}


::MakeMusic <- function(strSoundName) {
	PrecacheSound(strSoundName)

	local tSoundTable = {
		message = strSoundName,
		spawnflags = 49,
		health = 10,

	}

	local hSound = Spawn("ambient_generic", tSoundTable)
	return hSound


}

::PlaySoundGlobal <- function(strSoundName) {
	PrecacheSound(strSoundName)

	local tSoundTable = {
		message = strSoundName,
		spawnflags = 49,
		health = 10,

	}

	local hSound = Spawn("ambient_generic", tSoundTable)
	QAcceptInput(hSound, "PlaySound")
	hSound.Kill()
	// return hSound


}

// MUSIC END




::AmbientGeneric <- function(strSoundName, pos, sradius = 1024, looped = true) {
	PrecacheSound(strSoundName)

	local tSoundTable = {
		message = strSoundName,
		spawnflags = 16,
		health = 10,
		radius = sradius,
		origin = pos,
	}

	if (looped == false) {
		tSoundTable.spawnflags = 48
	}

	local hSound = Spawn("ambient_generic", tSoundTable)
	return hSound


}




::MarkForPurge <- function(hEntity = null) // thanks berke (erases entity's script id and targetname from string table when entity is killed)
{
    if (hEntity == null) {
    	hEntity = self; // what?

    }

    NetProps.SetPropBool(hEntity, "m_bForcePurgeFixedupStrings", true);
}

::MakeEnt <- function(classname, kv) { // safe wrapper for SpawnEntityFromTable which automatically enables stringtable cleanup
	local e = SpawnEntityFromTable(classname, kv)
	sPurge(e)
	return e
}

::Spawn <- function(classname, kv) {
	return MakeEnt(classname, kv) // wrapper for wrapper
}


// ::Spawn <- function(classname, kv) {
// 	return Spawn(classname, kv) // wrapper for wrapper
// }

// BRFUH

::ze_map_say <- function(text = "ZE_MAP_SAY GENERIC") { // mimic of skial plugin text functionality because i dont like boitgier

	ClientPrint(null,3,"\x07"+MAPFUNC.MAP_COLOR_HEX+text)
	// you must hope that you get a number with 3 characters in ze map say  or telse the map brexaks forever
	local reg = regexp(" (.*) SECONDS")
	local matched = reg.capture(text.toupper())
	// printl("match" + reg.capture(text.toupper()))
	if (matched != null) {
		// the "BEST" way to do this would be having the round clock as a global variable
		// which we set at each round reset
		// and then the timers only have to check if their death time
		// is less than the timer's current time
		// but i dont want to
		local waitlen = text.slice(matched[1].begin, matched[1].end).tointeger()
		local txt = Spawn("game_text", {
			// message = printf("-="
			message = "",
			fadein = 0.1,
			fadeout = 0.1,
			holdtime = 1,
			channel = 0, // channel is ALWAYS 0 for timers
			// thinkfunction = "ze_map_timer_think",
			effect = 0,
			color = MAPFUNC.MAP_COLOR,
			spawnflags = 1,
			x = -1,
			y = 0.2,
		})

		local cext = ""

		if (GAME_IS_TF2 == true) {

			local traw = GetTimeLeft() - waitlen

			local min = (traw/60)
			local min_pretty = floor(min);
			local sec_pretty = ceil(floor(min * 60) % 60);

			local prettytimeleft = min_pretty.tostring() + ":"+ sec_pretty.tostring()

			cext = "☞" + prettytimeleft + "☜" // IJBOL there IS a faster way to do this but i dont have much time to program this D:

		}


		txt.ValidateScriptScope()
		local scope = txt.GetScriptScope()
		scope.ClockExtra <- cext

		txt.GetScriptScope().ze_map_think <- ze_map_timer_think
		scope.DeathTime <- Time() + waitlen



		AddThinkToEnt(txt, "ze_map_think")


	}

	local GameText = Spawn("game_text", { // temp
		message = text,
		fadein = 1.5,
		fadeout = 0.5,
		holdtime = 5,
		channel = 1, // mapsay is ALWAYS channel 1
		effect = 0,
		color = MAP_COLOR,
		spawnflags = 1,
		x = 0.05,
		y = 0.4,
	})
	QFireByHandle(GameText, "Display")
	GameText.Kill()
}



// for ze map timers
::ze_map_timer_think <- function() {
	local fTime = Time()
	local timeleft = ceil(DeathTime - fTime)

	if (fTime >= DeathTime) {
		self.Destroy()
		return
	}
	QFireByHandle(self, "Display")
	self.KeyValueFromString("message", ZE_TIMER_PREFIX + timeleft + ZE_TIMER_SUFFIX + "\n" + ClockExtra)
	return 1

}


::PlayerParentTF <- function(hPlayer, mdl) {
	hWearable = Spawn("tf_wearable",
    {
        classname = "0",
        origin = hPlayer.GetOrigin(),
        angles = hPlayer.EyeAngles()
    });
    MarkForPurge(hWearable);
    NetProps.SetPropIntArray(hWearable, "m_nModelIndex", PrecacheModel(mdl), 0);
    NetProps.SetPropBool(hWearable, "m_bValidatedAttachedEntity", true);
    NetProps.SetPropBool(hWearable, "m_AttributeManager.m_Item.m_bInitialized", true);
    NetProps.SetPropInt(hWearable, "m_fEffects", 0);
    hWearable.SetOwner(hPlayer);
    hWearable.AcceptInput("SetParent", "!activator", hPlayer, null);
}

tMapCams <- {}

// scan for sky cameras and copy properties when the map starts
function InitSkyCameras() {
	for (local hCam; hCam = Entities.FindByClassname(hCam, "sky_camera");) {
		local tKeyvalues = {}

		// set the keyvalues YAAAAY!!!!!!!!!!!!!
		tKeyvalues = {}
		// this might be a string array?
		tKeyvalues.scale = NetProps.GetPropString(hCam, "m_skyboxData.scale")
		tKeyvalues.origin = NetProps.GetPropString(hCam, "m_skyboxData.origin")
		tKeyvalues.fogenable = NetProps.GetPropString(hCam, "m_skyboxData.fog.enable")
		tKeyvalues.fogblend = NetProps.GetPropString(hCam, "m_skyboxData.fog.blend")
		tKeyvalues.fogdir = NetProps.GetPropString(hCam, "m_skyboxData.fog.dirPrimary")
		tKeyvalues.fogdir = NetProps.GetPropString(hCam, "m_skyboxData.fog.dirPrimary")
	}// i didnt finish this :D
}

// SetSkyCamera <- function(sky_camera_name) {
//}

// // This handles all the dirty work, just copy paste it into your code // i stole this from  team fortrsss wiki :Steamhappy
// CollectEventsInScope <- function(events)
// {
// 	local events_id = UniqueString()
// 	getroottable()[events_id] <- events

// 	foreach (name, callback in events)
// 		events[name] = callback.bindenv(this)

// 	local cleanup_user_func, cleanup_event = "OnGameEvent_scorestats_accumulated_update"
// 	if (cleanup_event in events)
// 		cleanup_user_func = events[cleanup_event]

// 	events[cleanup_event] <- function(params)
// 	{
// 		if (cleanup_user_func)
// 			cleanup_user_func(params)

// 		delete getroottable()[events_id]
// 	}
// 	__CollectGameEventCallbacks(events)
// }

// // CollectEventsInScope
// // ()

::CollectEventsInScope <- function(events)
{
	local events_id = UniqueString()
	getroottable()[events_id] <- events
	local events_table = getroottable()[events_id]
	local Instance = self
	foreach (name, callback in events)
	{
		local callback_binded = callback.bindenv(this)
		events_table[name] = @(params) Instance.IsValid() ? callback_binded(params) : delete getroottable()[events_id]
	}
	__CollectGameEventCallbacks(events_table)
}






::CollectEventsInScopeB <- function(events)
{
	local events_id = UniqueString()
	getroottable()[events_id] <- events
	local events_table = getroottable()[events_id]
	local Instance = self
	foreach (name, callback in events)
	{
		local callback_binded = callback.bindenv(this)
		events_table[name] = @(params) Instance.IsValid() ? callback_binded(params) : delete getroottable()[events_id]
	}
	// printl("\n\n\n\nK done\n\n\n\n")
	__CollectGameEventCallbacks(this)
}

// ShittyListenHooks <- function(hook_table) { // safe and mostly working ?

// 	local unique = UniqueString()
// 	getroottable()[unique] <- hook_table

// 	local rooted_hooks = getroottable()[unique]

// 	foreach (fname, func in rooted_hooks) {
// 		rooted_hooks[fname] = func.bindenv(this)
// 	}

// 	rooted_hooks.OnGameEvent_scorestats_accumulated_update <- function(param) {
// 		try {
// 			if (unique in getroottable()) {
// 				delete getroottable()[unique]
// 			}

// 		} catch (exception){
// 			printl("shittylistenhooks has hit a wall: "+exception)
// 			// i literally dont care  and i think you should kill yourself
// 		}
// 	}


// 	__CollectGameEventCallbacks(getroottable()[unique])

// }

::ShittyListenHooks <- function(hook_table) {

	local new_table_name = UniqueString()
	// local ROOT = getroottable()
	// fuck you i hate you and youshould die stupid fufcking game  I HATE YOU !!!!!!!!!!!!!!!!😡😡😡😡💢💢💢
	hook_table.OnGameEvent_scorestats_accumulated_reset <- function(params) {
		if ("GAMEEVENTS" in getroottable()) {
			delete getroottable().GAMEEVENTS

		}
	}
	local uname = UniqueString()
	if (!("GAMEEVENTS" in getroottable())) {
		::GAMEEVENTS <- {}
	}


	getroottable().GAMEEVENTS[new_table_name] <- hook_table
	// local myscope = self
	// printl("ME "+self)
	// printl("Here it is" + GAMEEVENTS[hook_table])
	foreach (name, method in getroottable().GAMEEVENTS[new_table_name]) {
		getroottable().GAMEEVENTS[new_table_name][name] <- method.bindenv(this)
	}
	// }

	__CollectGameEventCallbacks(getroottable().GAMEEVENTS[new_table_name])
	// printl("fuck you")
}



// wrappers
::ListenHooks <- ShittyListenHooks
::ListenEvents <- ShittyListenHooks


// ListenHooks <- function(hook_table) {
	// ShittyListenHooks(hook_table)
// 	local EventsID = UniqueString()
// 	local root = getroottable()
// 	if (!("ELTRA_EVENTS" in getroottable())) {
// 		ELTRA_EVENTS <- {}
// 	} else {
// 		ELTRA_EVENTS.clear()


// 		hook_table.OnGameEvent_scorestats_accumulated_update <- function(_) {
// 			ELTRA_EVENTS.clear()
// 		}
// 	}


// 	getroottable().ELTRA_EVENTS[EventsID] <- hook_table

// // {
// 	// 	OnScriptHook_OnTakeDamage = function(params)
// 	// 	{
// 		// 		printl("OnScriptHook_OnTakeDamage")
// 		// 		if (params.const_entity.IsPlayer())
// 		// 		{
// 			// 			__DumpScope(1, params) // show parameters
// 			// 			params.damage = 0
// 			// 		}
// 		// 	}

// 	// 	// Cleanup events on round restart
// 	// }
// local EventsTable = getroottable().ELTRA_EVENTS[EventsID]
// 	foreach (name, callback in hook_table) {
		// EventsTable[name] = callback.bindenv(getroottable().ELTRA_EVENTS[EventsID])
// 	}
// 	// __CollectGameEventCallbacks(EventsTable)
// 	__CollectGameEventCallbacks(getroottable().ELTRA_EVENTS[EventsID])
// 	printl("ELTRACOMMONS: Now collecting hooks for "+self.tostring())
// }
// getroottable().CBaseEntity.CollectEventsInScope <- CollectEventsInScope

// ListenHooks <- function(tbl) { // i dont know how but this one seems to work?????????????????
// 	local hook_table = clone tbl // ?
// 	local EventsID = UniqueString()
// 	hook_table.OnGameEvent_scorestats_accumulated_update <- function(_) {
// 			delete getroottable()[EventsID]
// 	}

// 	getroottable()[EventsID] <- hook_table

// 	local EventsTable = getroottable()[EventsID]

// 	foreach (name, callback in EventsTable) {
		// EventsTable[name] = callback.bindenv(this)
// 	}

// 	// printl("Taylor Swift")
// 	__CollectGameEventCallbacks(EventsTable)
// 	// printl("ELTRACOMMONS: Now collecting hooks for "+this)
// }

// ListenHooks <- function(events) { // stupid wrapper test
// 	ShittyListenHooks(events)
// }


::VectorDivide <- function(vec, div) {
	vec.z /= div
	vec.x /= div
	vec.y /= div
	return vec
}

::SetBrushModel <- function(ent, mdl) {
	printl("MDL: "+mdl)
	try {
		if (mdl in BRUSHMODELS && mdl in BRUSHMODELINDEXES) {
			// PrecacheModel(mdl)
			ent.SetModel(BRUSHMODELS[mdl])
			// printl("hello?: "+mdl)
			// ent.KeyValueFromString("model", mdl)
			// NetProps.SetPropInt(ent, "m_nModelIndex", BRUSHMODELINDEXES[mdl])
		} else {
			printl("ELTRACOMMONS: ERROR! Tried setting brush model to " + mdl + ", which DOES NOT exist in the BRUSHMODEL table!")
		}

	} catch (exception){
		printl("ELTRACOMMONS: Failed setting brush model!\n\n" +exception)
	}
}

::SetItemUser <- function(ply, enabled) {
	// ply.ValidateScriptScope()
	local kv = GetContext(ply)
	// local plyscope = ply.GetScriptScope()
	if (enabled) {
		SetContext(ply, "itemholder", 1)
		// plyscope.bItemHolder <- true
	} else {
		SetContext(ply, "itemholder", 0)
		// plyscope.bItemHolder <- false
	}
}


::CheckItemHolder <- function(ply) {
	// old method
	// ply.ValidateScriptScope()
	// local plyscope = ply.GetScriptScope()
	// if ("bItemHolder" in plyscope && plyscope.bItemHolder == true) {
		// return plyscope.bItemHolder
	// }

	// new method

	local kv = GetContext(ply)
	if ("itemholder" in kv && kv.itemholder == 1) {
		return true
	}

	return false
}


::easeOutCubic <- function (x) {
	return 1 - pow(1 - x, 3);
}

::easeSine <- function (x) {
	return abs(-(cos(PI * x) - 1) / 2)
}

/// stolen easing functions

::easeInBack <- function(x) {
	local c1 = 1.70158;
	local c3 = c1 + 1;

	return c3 * x * x * x - c1 * x * x;

}

// taken from wikipedia LOL

// slerp <- function(q0, q1, t) {
	// local agony = quaternion_multiply(q0, quatpow(quaternion_multiply(q0.Invert(),q1), t))
	// local agony = q0.Norm() * (q0.Invert())
	// printl(agony)
	// return agony
// }

::quatpow <- function(q, t) {
	return Quaternion( pow(q.x, t), pow(q.y, t), pow(q.z, t), pow(q.w, t))
}

::quaternion_multiply <- function(q1, q2) {
    // w0, x0, y0, z0 = q2
    // w1, x1, y1, z1 = q1
	// return Quaternion(q1.x * q2.x, q1.y * q2.y, q1.z * q2.z, q1.w * q2.w)
	// return Quaternion(-q1.x * q2.x - q1.y * q2.y - q1.z * q2.z + q1.w * q2.w,q1.x * q2.x + q1.y * q2.y - q1.z * q2.y + q1.w * q2.w, -q1.x * q2.z + q1.y * q2.w + q1.z * q2.x + q1.w * q2.y,q1.x * q2.y - q1.y * q2.x + q1.z * q2.w + q1.w * q2.z)

    // return np.array([-q1.x * q2.x - q1.y * q2.y - q1.z * q2.z + q1.w * q2.w,
                    //  q1.x * q2.x + q1.y * q2.y - q1.z * q2.y + q1.w * q2.w,
                    //  -q1.x * q2.z + q1.y * q2.w + q1.z * q2.x + q1.w * q2.y,
                    //  q1.x * q2.y - q1.y * q2.x + q1.z * q2.w + q1.w * q2.z], dtype=np.float64)

}


::fmodf <- function(a, b) // for ease of stealing valve code
{
	return a % b

}

::AngleDiff3D <- function(destAngle, srcAngle) {

	// return QAngle(AngleDiff(destAngle.x, srcAngle.x), AngleDiff(destAngle.y, srcAngle.y), AngleDiff(destAngle.z, srcAngle.z))
	return QAngle(AngleDiff(destAngle.x, srcAngle.x), AngleDiff(destAngle.y, srcAngle.y), AngleDiff(destAngle.z, srcAngle.z))
}



::ApproachAngle3D <- function(destAngle, srcAngle, speed) {

	// return QAngle(AngleDiff(destAngle.x, srcAngle.x), AngleDiff(destAngle.y, srcAngle.y), AngleDiff(destAngle.z, srcAngle.z))
	return QAngle(ApproachAngle(destAngle.x, srcAngle.x, speed), ApproachAngle(destAngle.y, srcAngle.y, speed), ApproachAngle(destAngle.z, srcAngle.z, speed))
}

::AngleDiff <- function(destAngle, srcAngle)
{
	local delta;

	delta = fmodf(destAngle - srcAngle, 360.0);
	if ( destAngle > srcAngle )
	{
		if ( delta >= 180 )
			delta -= 360;
	}
	else
	{
		if ( delta <= -180 )
			delta += 360;
	}
	return delta;
}

::anglemod <- function(angle) {
	return angle % 360.0;
}

::ApproachAngle <- function( target, value, speed )
{
	target = anglemod( target );
	value = anglemod( value );

	local delta = target - value;

	// Speed is assumed to be positive
	if ( speed < 0 )
		speed = -speed;

	if ( delta < -180 )
		delta += 360;
	else if ( delta > 180 )
		delta -= 360;

	if ( delta > speed )
		value += speed;
	else if ( delta < -speed )
		value -= speed;
	else
		value = target;

	return value;
}


// ApproachAngle <- function( target, value, speed )
// {
// 	target = anglemod( target );
// 	value = anglemod( value );

// 	float delta = target - value;

// 	// Speed is assumed to be positive
// 	if ( speed < 0 )
// 		speed = -speed;

// 	if ( delta < -180 )
// 		delta += 360;
// 	else if ( delta > 180 )
// 		delta -= 360;

// 	if ( delta > speed )
// 		value += speed;
// 	else if ( delta < -speed )
// 		value -= speed;
// 	else
// 		value = target;

// 	return value;
// }

::FollowTarget <- function(angles, vecGoal, ent, tracking_rate = 1) {

		// local ent = self


		if (angles.y > 360)
			angles.y -= 360;

		if (angles.y < 0)
			angles.y += 360;

		ent.SetLocalAngles( angles );

		local dx = vecGoal.x - ent.GetLocalAngles().x;
		local dy = vecGoal.y - ent.GetLocalAngles().y;

		if (dx < -180)
			dx += 360;
		if (dx > 180)
			dx = dx - 360;

		if (dy < -180)
			dy += 360;
		if (dy > 180)
			dy = dy - 360;

		local vecAngVel;
		vecAngVel = QAngle( dx * 40 * (FrameTime() * tracking_rate), dy * 40 * (FrameTime()  * tracking_rate), ent.GetAngularVelocity().z );
		return vecAngVel
		// ent.SetAngularVelocity(vecAngVel.x,vecAngVel.y,vecAngVel.z);
}

// ::FollowTarget <- function(angles, vecGoal, ent, tracking_rate = 1) {

// 		// local ent = self

// 		if (angles.y > 360)
// 			angles.y -= 360;

// 		if (angles.y < 0)
// 			angles.y += 360;

// 		ent.SetLocalAngles( angles );

// 		local dx = vecGoal.x - ent.GetLocalAngles().x;
// 		local dy = vecGoal.y - ent.GetLocalAngles().y;

// 		if (dx < -180)
// 			dx += 360;
// 		if (dx > 180)
// 			dx = dx - 360;

// 		if (dy < -180)
// 			dy += 360;
// 		if (dy > 180)
// 			dy = dy - 360;

// 		local vecAngVel;
// 		vecAngVel = QAngle( dx * 40 * (FrameTime() * tracking_rate), dy * 40 * (FrameTime()  * tracking_rate), ent.GetAngularVelocity().z );
// 		return vecAngVel
// 		// ent.SetAngularVelocity(vecAngVel.x,vecAngVel.y,vecAngVel.z);
// }

::VectorAngles <- function( forward, angles )
{
	// Assert( s_bMathlibInitialized );
	local tmp;
	local yaw;
	local pitch;

	if (forward.y == 0 && forward.x == 0)
	{
		yaw = 0;
		if (forward.z > 0)
			pitch = 270;
		else
			pitch = 90;
	}
	else
	{
		yaw = (atan2(forward.y, forward.x) * 180 / PI);
		if (yaw < 0)
			yaw += 360;

		tmp = sqrt(forward.x*forward.x + forward.y*forward.y);
		pitch = (atan2(-forward.z, tmp) * 180 / PI);
		if (pitch < 0)
			pitch += 360;
	}

	return QAngle(pitch, yaw, 0)

}

::TrackPosition <- function(ent, v2, t = 1.0) {
	local v1 = ent.GetOrigin()
	local oldforv = ent.GetForwardVector()
	local newforv = GetLookVector2(v2, v1)
	local lerped = vLerp(oldforv,newforv,t)

	ent.SetForwardVector(lerped)
}

::QuaternionSlerp <- function(p, q, t)
{
	// local q2 = Quaternion(0,0,0,0);
	// 0.0 returns p, 1.0 return q.
	p = QuatArray(p)
	q = QuatArray(q)
	// decide if one of the quaternions is backwards
	local q2 = QuaternionAlign( p, q );
	// printl("q2 check 1 : "+q2.tostring())
	q2 = QuaternionSlerpNoAlign( p, q2, t );
	// printl("q2 check 2 : "+q2.tostring())
	return Quaternion(q2[0], q2[1], q2[2], q2[3])
}

::QuaternionSlerpNoAlign <- function( p, q, t )
{
	// float omega, cosom, sinom, sclp, sclq;
	p = QuatArray(p)
	q = QuatArray(q)

	local omega;
	local cosom;
	local sinom;
	local sclp;
	local sclq;

	local qt = [0,0,0,0]

	local i;

	// 0.0 returns p, 1.0 return q.

	cosom = p[0]*q[0] + p[1]*q[1] + p[2]*q[2] + p[3]*q[3];

	if ((1.0 + cosom) > 0.000001) {
		if ((1.0 - cosom) > 0.000001) {
			omega = acos( cosom );
			sinom = sin( omega );
			sclp = sin( (1.0 - t)*omega) / sinom;
			sclq = sin( t*omega ) / sinom;
		}
		else {
			// TODO: add short circuit for cosom == 1.0f?
			sclp = 1.0 - t;
			sclq = t;
		}
		for (i = 0; i < 4; i++) {
			qt[i] = sclp * p[i] + sclq * q[i];
		}
	}
	else {
		// Assert( qt != q );

		qt[0] = -q[1];
		qt[1] = q[0];
		qt[2] = -q[3];
		qt[3] = q[2];
		sclp = sin( (1.0 - t) * (0.5 * PI));
		sclq = sin( t * (0.5 * PI));
		for (i = 0; i < 3; i++) {
			qt[i] = sclp * p[i] + sclq * qt[i];
		}
	}

	return qt
	// Assert( qt.IsValid() );
}


::QuaternionMult <- function(p, q)
{
	// Assert( s_bMathlibInitialized );
	// Assert( p.IsValid() );
	// Assert( q.IsValid() );

	p = QuatArray(p)
	q = QuatArray(q)

	local qt = [0,0,0,0]

	if (p == qt)
	{
		local p2 = p;
		p2 = QuaternionMult( p2, q );
		return p2;
	}

	// decide if one of the quaternions is backwards
	local q2 = QuaternionAlign( p, q );

	qt.x =  p.x * q2.w + p.y * q2.z - p.z * q2.y + p.w * q2.x;
	qt.y = -p.x * q2.z + p.y * q2.w + p.z * q2.x + p.w * q2.y;
	qt.z =  p.x * q2.y - p.y * q2.x + p.z * q2.w + p.w * q2.z;
	qt.w = -p.x * q2.x - p.y * q2.y - p.z * q2.z + p.w * q2.w;

	return Quaternion(qt[0], qt[1], qt[2], qt[3])
}

::QuatArray <- function(p) {
	if (type(p) == "array") {
		return p
	}
	return [p.x, p.y, p.z, p.w]
}

::QuaternionAlign <- function( p, q )
{

	// FIXME: can this be done with a quat dot product?

	p = QuatArray(p)
	q = QuatArray(q)

	local qt = [0,0,0,0]

	local i;

	// decide if one of the quaternions is backwards
	local a = 0.0;
	local b = 0.0;
	for (i = 0; i < 4; i++)
	{
		a += (p[i]-q[i])*(p[i]-q[i]);
		b += (p[i]+q[i])*(p[i]+q[i]);
	}
	if (a > b)
	{
		for (i = 0; i < 4; i++)
		{
			qt[i] = -q[i];
		}
	}
	else if (qt != q)
	{
		for (i = 0; i < 4; i++)
		{
			qt[i] = q[i];
		}
	}
	return Quaternion(qt[0], qt[1], qt[2], qt[3])
}

::PlaySoundNPC <- function(sound_name, ent) { // lazy wrapper for playsoundex
	PlaySoundEX(sound_name, ent.GetOrigin(), 10, RandomInt(95,105), ent)

}

::SetViewControl <- function(player, vc, active) {
	local ent = Entities.FindByName(null, vc)
	if (!ent) {
		return false
		printl("\n\nSETVIEWCONTROL : cam dont exist :(")
	}

	// player.ValidateScriptScope() // obsolete
	// local scope = player.GetScriptScope()

	if (active == true) {

		QFire(vc, "Enable","", 0.0, player)
		SetContext(player, "CurrentViewControl", ent.entindex())
		// scope.CurrentViewControl <- vc

	} else {
		QFire(vc, "Disable","", 0.0, player)
		SetContext(player, "CurrentViewControl", "")
		// local kv = GetContext(player)
		// if ("CurrentCameraName" in kv) {
			// scope
		// }
	}
}


::easeInOutSine <- function(number) {
	return -(cos(PI * number) - 1) / 2;
}

// mashallah he must steal more valve code
::LerpFloat <- function( x0, x1, t )
{
	return x0 + (x1 - x0) * t;
}


::Vlerp <- function(v1, v2, t) {
	v1.x = LerpFloat(v1.x, v2.x, t)
	v1.y = LerpFloat(v1.y, v2.y, t)
	v1.z = LerpFloat(v1.z, v2.z, t)

	return v1
}

::vLerp <- function(v1,v2,t) { // wrapper for Vlerp
	return Vlerp(v1,v2,t)
}

::ClientProxy <- function(player) {

	local proxy_entity = Entities.CreateByClassname("obj_teleporter") // not using SpawnEntityFromTable as that creates spawning noises
	// proxy_entity.SetAbsOrigin(Vector(0, -320, -150))
	proxy_entity.KeyValueFromString("targetname", "script_additional")
	proxy_entity.DispatchSpawn()
	PrecacheModel("models/error.mdl")
	proxy_entity.SetModel("models/error.mdl")
	// proxy_entity.DisableDraw()
	proxy_entity.AddEFlags(Constants.FEntityEFlags.EFL_NO_THINK_FUNCTION) // prevents the entity from disappearing
	proxy_entity.SetSolid(Constants.ESolidType.SOLID_NONE)
	NetProps.SetPropBool(proxy_entity, "m_bPlacing", true)
	NetProps.SetPropInt(proxy_entity, "m_fObjectFlags", 2) // sets "attachment" flag, prevents entity being snapped to player feet

	// m_hBuilder is the player who the entity will be networked to only
	NetProps.SetPropEntity(proxy_entity, "m_hBuilder", player)

	return proxy_entity

}


::EBossBar <- function(health, healthpersegment, maxsegments, c = COLOR_RED) {

	if (iHealth == 0) {
		return

	}

	// local hpstring = "</\\ SANTA : ";

	local hpstring = CUBT_NOSTRING
	local iter = 0
	// add blox

	local bars = health/healthpersegment

	for (local i = 0; i < bars; i++) {
		hpstring += "█"
		iter = i
	}
	// add blanx
	for (local i = 0; i < (maxsegments-iter); i++) {
		hpstring += "░"
	}

	local hTextInfo =	Spawn(CUBT_GAMETEXT, {
			color = COLOR_RED,
			fadein = 0.1,
			fadeout = 0.1,
			holdtime = 0.25,
			message = hpstring,
			channel = 4,
			x = -1,
			y = 0.2,
			spawnflags = 1,
	})

	sPurge(hTextInfo)
	hTextInfo.AcceptInput(CUBT_DISPLAY, CUBT_NOSTRING, null, null)
	QFireByHandle(hTextInfo, CUBT_KILL)
	CleanString(hpstring)

}

::SpawnTemplateEntity <- function(name, pos, dir = QAngle(0,0,0)) {
	local maker = SpawnEntityFromTable("env_entity_maker", {
		origin = pos,
		EntityTemplate = name,
		PostSpawnDirection = dir,
	})
	// printl("trying to spawn ent template "+name+" at pos "+pos.ToKVString())
	// maker.AcceptInput("ForceSpawn","",null,null)
	maker.SpawnEntity()
	maker.Destroy()
}

::SpawnTemplate <- function(template_name) {
	SpawnTemplateEntity(template_name, self.GetOrigin())
}

::SetViewControlAll <- function(cam, enabled = true) {
	local playarz = []
	printl("setvcontrolall")
	for (local _i; _i = Entities.FindByClassname(_i, "player");) {

		if (_i.GetTeam() != TEAMS.SPECTATORS) {
			playarz.append(_i)
		}

	}

	switch (enabled) {
		case true:


			foreach (i, ply in playarz) {
				// ply.ValidateScriptScope()
				// local scope = ply.GetScriptScope()
				SetViewControl(ply, cam, true)
			}


		break;
		case false:

			foreach (i, ply in playarz) {
				SetViewControl(ply, cam, false)
			}

		break;
	}
}

::GetTimeLeft <- function () {
	return (NetProps.GetPropFloat(MAPFUNC.TF_ROUNDTIMER, "m_flTimerEndTime") - Time())
	// return (NetProps.GetPropFloat(MAPFUNC.TF_ROUNDTIMER, "m_flTimeRemaining") - (Time() - NetProps.GetPropFloat(MAPFUNC.TF_ROUNDTIMER, "m_flStartTime")) + 0.5).tointeger()
}

::ButtonSound <- function(ent) {
	// PlaySound("")
	local snd = "buttons/button3.wav"
	PrecacheSound("buttons/button3.wav")
	EmitAmbientSoundOn("buttons/button3.wav", 100, 0.2, 100, ent)
}
ButtonSound.bindenv(getroottable()) // backwards compatibility with maps made before the ecommons refactoring

::QEmitSound <- function(sound_name, ent, volume = 100, pitch = 100, sound_level = 1.25) {
	// this is broken do not use it // fixed!
	PrecacheSound(sound_name)
	EmitAmbientSoundOn(sound_name, volume, sound_level, pitch, ent)
	CleanString(sound_name)
}

// stolen cockroach code
::SpawnWeapon <- function (classname, itemindex = 10) {
	try {
		local hWeapon = Entities.CreateByClassname(classname);
		NetProps.SetPropInt(hWeapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", itemindex);
		NetProps.SetPropInt(hWeapon, "m_AttributeManager.m_Item.m_iEntityLevel", 1);

		NetProps.SetPropBool(hWeapon, "m_bBeingRepurposedForTaunt", true);
		NetProps.SetPropBool(hWeapon, "m_AttributeManager.m_Item.m_bInitialized", true);
		NetProps.SetPropBool(hWeapon, "m_bValidatedAttachedEntity", true);
		MarkForPurge(hWeapon);
		hWeapon.DispatchSpawn();
		return hWeapon

	} catch (exception){
		printl("\n\n\n\n\nFail:"+exception)
	}
}
::DEV_TP_ALL <- function() {
	for (local ply; ply = Entities.FindByClassname(ply, "player");) {
		ply.SetAbsOrigin(GetListenServerHost().GetOrigin() + Vector(RandomFloat(-512, 512), RandomFloat(-512, 512), 0));
	}
}

// DEV_TP_ALL.bindenv(getroottable())

::SpawnNPCwave <- function(template, spawner) {

	if (template in MapNPCs) { // allow shorthands aswell as full template names if ever that is necessary
		template = MapNPCs[template]
	}

	for (local sp; sp = Entities.FindByName(sp, spawner);) {
		SpawnTemplateEntity(template, sp.GetOrigin(), sp.GetAbsAngles())
	}

}
SpawnNPCwave.bindenv(getroottable()) // compat





// my new method of easily and quickly storing player data !!!!!!!!!!! without needing to fuck with scopes !!!!!!!!!!
// well ints only but whatever thats good enoguh


::GetContext <- function(ent) { // get basic keyvalues table (format: [key:int]) from an entity
	local contexts = NetProps.GetPropString(ent, "m_iszResponseContext")
	local keyvalues = {}
	local split1 = split(contexts, ",")
	foreach (i, splitstr in split1) {
		local ktable = split(splitstr, ":")
		if (ktable.len() == 1) {
			continue
		}
		keyvalues[ktable[0]] <- ktable[1].tointeger()
	}
	return keyvalues

}

::SetContext <- function(ent, key = "NULLKEY", val = 0) { // assign a context keyvalue to an entity
	local kvs = GetContext(ent)
	kvs[key] <- val

	local cstring = ""
	foreach(key, value in kvs){
		cstring += key + ":" + value + ","
	}
	// printl("Contextstring: "+cstring)
	ent.KeyValueFromString("ResponseContext", cstring)
	CleanString(cstring)
	CleanString(key)
}

// wrapper because i keep oopsing when doing context on ctfplayer!
getroottable().CTFPlayer.GetContext <- function() {
	return ::GetContext(this)
}

getroottable().CTFPlayer.SetContext <- function(key = "NULLKEYCTF", value = 0) {
	local me = this
	getroottable().SetContext(this, key, value)
}





const TF_COND_TAUNTING = 7

::ForceTaunt <- function(player, taunt_id)
{
	local weapon = Entities.CreateByClassname("tf_weapon_bat")
	local active_weapon = player.GetActiveWeapon()
	player.StopTaunt(true) // both are needed to fully clear the taunt
	player.RemoveCond(TF_COND_TAUNTING)
	weapon.DispatchSpawn()
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", taunt_id)
	NetProps.SetPropBool(weapon, "m_AttributeManager.m_Item.m_bInitialized", true)
	NetProps.SetPropBool(weapon, "m_bForcePurgeFixedupStrings", true)
	NetProps.SetPropEntity(player, "m_hActiveWeapon", weapon)
	NetProps.SetPropInt(player, "m_iFOV", 0) // fix sniper rifles
	player.HandleTauntCommand(0)
	NetProps.SetPropEntity(player, "m_hActiveWeapon", active_weapon)
	weapon.Kill()
}

// test
getroottable().CTFPlayer.GetSteamID <- function() {
	return NetProps.GetPropString(this, "m_szNetworkIDString")
}

getroottable().CTFPlayer.IsEltra <- function() {
	if (this.GetSteamID() == ELTRA_STEAMID) {
		return true
	} else {
		return false
	}
}

::ExplosionSounds <- ["eltra/explode3.mp3", "eltra/explode4.mp3", "eltra/explode5.mp3"]
::ExplosionSoundsLength <- ExplosionSounds.len()

::CTFPlayer.Explode <- function() {
	// local vOrigin = this.self.GetOrigin()
	local vOrigin = this.GetOrigin()
	DoEffect("cic_explosion", vOrigin)
	PlaySoundEX(ExplosionSounds[RandomInt(0, ExplosionSoundsLength - 1)], vOrigin, 100, RandomInt(95,105))
}

// θ = arccos((A·B) / (|A| × |B|))

// ::FindAngComponent <- function(v2, v1) {
	// return acos((v1 * v2) / (abs(v1) * abs(v2)))
// }

::deg2rad <- function(deg) { // how is this not a default function
	return deg * (180/PI)
}
::rad2deg <- function(rad) { // how is this not a default function
	return rad * (PI/180)
}

::DotProduct <- function(a, b) {
	return( a.x*b.x + a.y*b.y + a.z*b.z );
}

::AngleVectors <- function(angles)
{
	local forward = Vector(0, 0, 0);
	// float	sp, sy, cp, cy;
	local ay = deg2rad(angles.Yaw())
	local ap = deg2rad(angles.Pitch())

	local sp = sin(ap)
	local sy = sin(ay);
	local cp = cos(ap)
	local cy = cos(ay)
	// SinCos(deg2rad(angles.Yaw()), & sy, & cy);
	// SinCos( deg2rad( angles.Pitch() ), &sp, &cp );

	forward.x = cp*cy;
	forward.y = cp*sy;
	forward.z = -sp;

	return forward
}

// ::FollowVector <- function(ent, vecGoal, tracking_rate = 1) {
// 	// __DumpScope(1, this)
// 	local ent = ent

// 	local angles = ent.GetLocalAngles()


// 	if (angles.y > 360)
// 		angles.y -= 360;

// 	if (angles.y < 0)
// 		angles.y += 360;

// 	ent.SetLocalAngles( angles );

// 	local dx = vecGoal.x - ent.GetLocalAngles().x;
// 	local dy = vecGoal.y - ent.GetLocalAngles().y;

// 	if (dx < -180)
// 		dx += 360;
// 	if (dx > 180)
// 		dx = dx - 360;

// 	if (dy < -180)
// 		dy += 360;
// 	if (dy > 180)
// 		dy = dy - 360;

// 	local vecAngVel;
// 	vecAngVel = QAngle( dx * 40 * (FrameTime() * tracking_rate), dy * 40 * (FrameTime()  * tracking_rate), ent.GetAngularVelocity().z );
// 	return vecAngVel
// 	// ent.SetAngularVelocity(vecAngVel.x,vecAngVel.y,vecAngVel.z);
// }

::regex_runscriptcode <- regexp("runscriptcode")

::QAcceptInput <- function(ent, p1 = "", p2 = "", acti = null, calli = null) {
	ent.AcceptInput(p1, p2, acti, calli)

	// is this necessary?
	if (regex_runscriptcode.search(p1.tolower())) {
		// CleanString(p1)
		CleanString(p2)
	}
}

::IgnitePlayer <- function(ply) {
	local trig = Spawn("trigger_ignite" {
		burn_duration = 5,
		damage_percent_per_second = 10,
		ignite_sound_name = "ambient/fire/ignite.wav",
		ignite_particle_name = "burningplayer_flyingbits"

	})
	trig.SetSize(Vector(-1,-1,-1), Vector(1,1,1))
	QAcceptInput(trig, "StartTouch", "", ply, ply)
	trig.Kill()
}

::CreatePlayerWearable <- function(hPlayer, model) {
	local hWearable = Spawn("tf_wearable",
		{
			classname = "0",
			origin = hPlayer.GetOrigin(),
			angles = hPlayer.EyeAngles()
		});
		MarkForPurge(hWearable);

		local events = {
			function OnGameEvent_scorestats_accumulated_update(_) {
				if (ValidEntity(hWearable)) {
					hWearable.Kill()
				}
			}
		}

		ShittyListenHooks(events)

		NetProps.SetPropIntArray(hWearable, "m_nModelIndex", PrecacheModel(model), 0);
		NetProps.SetPropBool(hWearable, "m_bValidatedAttachedEntity", true);
		NetProps.SetPropBool(hWearable, "m_AttributeManager.m_Item.m_bInitialized", true);
		NetProps.SetPropInt(hWearable, "m_fEffects", 0);
		hWearable.SetOwner(hPlayer);
		return hWearable // we'll leave the parenting up to whoever is calling this function.
		// hWearable.AcceptInput("SetParent", "!activator", hPlayer, null);

}

enum GAMETEXT{ ALL = 1, PLAYER = 0}
::MakeGameText <- function(msg = "NO_MESSAGE", xpos = -1,ypos = -1, spawnflag = 1, cola = MAP_COLOR, channel = RandomInt(0,5)) {
	return Spawn("game_text", { // temp
		message = msg,
		fadein = 0.1,
		fadeout = 0.5,
		holdtime = 0.5,
		channel = channel,
		effect = 0,
		color = cola,
		spawnflags = spawnflag,
		x = xpos,
		y = ypos,
	})
}

::CTFPlayer.DisplayGameText <- function(msg = "NO_MESSAGE", xpos = -1,ypos = -1, spawnflag = 1, cola = MAP_COLOR, lifetime = 0.5) {

	local txt = Spawn("game_text", { // temp

		message = msg,
		fadein = 0.1,
		fadeout = 0.1,
		holdtime = lifetime,
		channel = RandomInt(2,6), // pick random channel outside of the zemapsay/timer range
		effect = 0,
		color = cola,
		spawnflags = spawnflag,
		x = xpos,
		y = ypos,
	})
	QAcceptInput(txt, "Display", "", this)
	txt.Kill()
}

::FindOpenTextChannel <- function() {
	local TEXT_CHANNELS = [0,1,2,3,4,5]

	local USED_CHANNELS = []

	local text;

	while (text = Entities.FindByClassname(text, "game_text")) {
		local channel = NetProps.GetPropInt(text, "m_textParms.channel")
		if (!channel in USED_CHANNELS)
			printl("found a used channel:")
			USED_CHANNELS.append(channel)
	}


	for (local i = 0; i < TEXT_CHANNELS.len() - 1; i++) {
		if (!(i in USED_CHANNELS))
			printl("ELTRACOMMONS: Found open game_text channel : "+i)
		return i
	}
	printl("ELTRACOMMONS: no used channels ? picking a random one")

	return RandomInt(0,5) // couldn't find a free channel, so just return a random one
}