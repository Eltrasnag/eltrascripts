DEV <- true
// ::GAMEEVENTS <- {}
const MONEY_MODEL = "models/eltra/li_laserbuck.mdl"
const DIALOGUE_CHAR_TIME = 0.02
const DIALOGUE_HOLD_TIME = 3
::ROOT <- getroottable()
::DELTA_ACTIVE <- false
if (!("GAMEEVENTS" in ::ROOT)) { // does spawnevents already exist?
	::GAMEEVENTS <- {};
}

if (!("BRUSHMODELS" in getroottable())) {
	::BRUSHMODELS <- {};
}

if (!("SPAWNERS" in getroottable())) {
	::SPAWNERS <- {};
}
SPAWNERS.clear()



::GAMEEVENTS.clear() // clear it so we don't duplicate

__CollectGameEventCallbacks(GAMEEVENTS)

::REMAININGLAURAS <- 0

CHARACTER_COLORS <- {
	"map" : "00FC11",
	"grandma" : "f754f5",
	"lois griffin" : "FC6D00",
	"lois" : "FC6D00",
	"grandma defense system" : "ff0004",
	"bjÖrk" : "cb0000",
}

DEST_CLASSROOM <- Entities.FindByName(null, "map_class_dest")

function GoToClassSelect(activator) {
	printl("dummy")
	activator.SetAbsAngles(DEST_CLASSROOM.GetAbsAngles())
	activator.SetOrigin(DEST_CLASSROOM.GetOrigin())
}

// function Precache() { // spawn the generic map ents so we don't need to copy paste them over all the map vmfs

// }


function MapIntro() {
	if (Entities.FindByName(null, "intro_camera")) {
		ScreenFade(null, 0, 0, 0, 255, 1, 3, 1)
		local IntroDelay = 0



		local hCam = Entities.FindByName(null, "intro_camera")



		for (local iPlayer = null; iPlayer = Entities.FindByClassname(iPlayer, "player");) {

			QFireByHandle(hCam, "Enable", "", 0.0, iPlayer, null);
			QFireByHandle(hCam, "Disable", "", IntroDelay + 16.0, iPlayer, null);

		}

		PrecacheSound("music/eltra/vv_intro_string_edit.mp3")
		local hIntroMus = MakeMusic("#music/eltra/vv_intro_string_edit.mp3")
		hIntroMus.AcceptInput("PlaySound", "", null, null)
		// hIntroMus.Kill()
		QFire("intro_camera_target", "Open", "", IntroDelay + 0.1, null)
		QFire("player", "RunScriptCode", "self.SetScriptOverlayMaterial(\"eltra/intro_mapname.vmt\")", IntroDelay + 0, null)
		QFire("player", "RunScriptCode", "self.SetScriptOverlayMaterial(\"eltra/intro_eltraname.vmt\")", IntroDelay + 7, null)
		QFire("player", "RunScriptCode", "self.SetScriptOverlayMaterial(\"\")", IntroDelay + 14, null)
		QFire("player", "RunScriptCode", "ScreenFade(null, 255, 255, 255, 255, 2, 0.0, 2)", 14, null)
		QFireByHandle(hIntroMus,"Volume","0",16,null,null)
		QFireByHandle(hIntroMus,"Kill","",17,null,null)
		QFireByHandle(self,"RunScriptCode","StageFunctions()",17,null,null)
	}


}

function StageFunctions() {
	switch (CURRENT_STAGE) {
		case 0:
			GenTriggers()
			QFire("mus_canal_intro","PlaySound", "", 0.0, null)

			break;

		default:
			break;
	}
}

function GenTriggers() {
	switch (CURRENT_STAGE) {
		case 0:

			//AUTO-GENERATED VIA TRIGGERGEN//
			//CREATING TRIGGER//
			local triggeronce__b70d3_ = SpawnEntityFromTable("trigger_once", {
				spawnflags = 1,
				origin = Vector(-12841.8, -12932.9, 0.03125 ),
			});
			triggeronce__b70d3_.SetSolid(2);
			triggeronce__b70d3_.SetSize(Vector(-229.084, -245.801, 0 ), Vector(-63.7637, 282.784, 299.708 ));
			//ENTITY OUTPUTS//
			EntityOutputs.AddOutput(triggeronce__b70d3_,"OnTrigger", "mapsys", "RunScriptCode", "MapSayArray([\"gHoly fliop\",\"we have GOT to get out of the city\",\"i've got you on WhatsApp so i'll keep you updated\",\"for now just RUN\"],\"lois griffin\")", 0.0, -1);


			//AUTO-GENERATED VIA TRIGGERGEN//
			//CREATING TRIGGER//
			local triggeronce__794d1_ = SpawnEntityFromTable("trigger_once", {
				spawnflags = 1,
				origin = Vector(-8719.86, -11520, 192.34 ),
			});
			triggeronce__794d1_.SetSolid(2);
			triggeronce__794d1_.SetSize(Vector(-136.377, -264.585, -160.309 ), Vector(91.9639, -0, 51.307 ));
			//ENTITY OUTPUTS//
			EntityOutputs.AddOutput(triggeronce__794d1_,"OnTrigger", "entity", "input", "parameter", 0.0, -1);



// local hTrigger_s1_sewerdoor_a_1f680_= SpawnEntityFromTable("trigger_once", {
// spawnflags = 1,
// origin = Vector(-8693.1, -11297.4, 32.0312 ),
// });
// hTrigger_s1_sewerdoor_a_1f680_.SetSolid(2);
// hTrigger_s1_sewerdoor_a_1f680_.SetSize(Vector(-109.688, -508.111, -32 ), Vector(137.755, 222.531, 215.344 ));
// EntityOutputs.AddOutput(hTrigger_s1_sewerdoor_a_1f680_,"OnTrigger", "s1_sewerdoor_a", "Open", "", 15, -1);
// EntityOutputs.AddOutput(hTrigger_s1_sewerdoor_a_1f680_,"OnTrigger", "RunScriptCode", "!self", "MapSay(`*** SEWER DOOR OPENS IN 15 SECONDS ***`)", 0, -1);



			break;
		case 2:
			break;
		default:
			break;
	}
}

function LanaIntro() {
	// i am NOT a furry
	ScreenFade(null, 0, 0, 0, 255, 2, 3, 1)
	QFire("player", "RunScriptCode", "self.SetScriptOverlayMaterial(\"eltra/lana_intro.vmt\")", 0, null)
	local hLana = MakeMusic("eltra/lana.mp3")
	hLana.AcceptInput("PlaySound","",null,null)


}

function OnPostSpawn() { // ON SPAWN`
	ROUNDS++
	// do intro (if it exists)
	if (ROUNDS == 2) {
		QFireByHandle(self, "RunScriptCode", "MapIntro()", 11, null, null)
		QFireByHandle(self, "RunScriptCode", "LanaIntro()", 0, null, null)

	}




	SpawnEntityFromTable("filter_activator_team", {
		targetname = "filter_ct",
		filterteam = TEAMS.HUMANS,
		Negated = 0,
	})

	SpawnEntityFromTable("point_servercommand", {
		targetname = "cmd",
	})

	SpawnEntityFromTable("filter_activator_team", {
		targetname = "filter_t",
		filterteam = TEAMS.ZOMBIES,
		Negated = 0,
	})
	// printl("\n\n\n\nBRUSHMODELS: " )
	foreach (index in BRUSHMODELS) {
		printl(index)
	}
	// printl("Hello it spawned ?")
	// create the two main team filters




	for (local i = null; i = Entities.FindByClassname(i, "player");) {
		i.AcceptInput("ClearParent", "", null, null)
		i.SetAbsAngles(QAngle(0,0,0))
	}
	for (local i = null; i = Entities.FindByName(i, "extraordinary_temptarget");) {
		// i.AcceptInput("ClearParent", "", null, null)
		i.Kill()
		// i.SetAbsAngles(QAngle(0,0,0))
	}
	// QFire("player*","ClearParent","",0.0,null)
	// QFire("player*","RunScriptCode","self.SnapEyeAngles(QAngle(0,0,0))",0.1,null)


}


MarkForPurge <- function(hEntity = null) // thanks berke (erases entity's script id and targetname from string table when entity is killed)
{
    if (!hEntity)
        hEntity = self;

    NetProps.SetPropBool(hEntity, "m_bForcePurgeFixedupStrings", true);
}

::SpawnMoney <- function(input) {

	local spawn_pos = null

	local type_of = typeof input
	// printl("TYPE OF : "+type_of)
	switch (type_of) {
		case "String":
			spawn_pos = Entities.FindByName(null, spawn_pos_targetname).GetOrigin()
			break;
		case "Instance":
			spawn_pos = input.GetOrigin()
			break;
		case "Vector":
			spawn_pos = input;
			break;
		default:
			return null
	}

	local money = SpawnEntityFromTable("prop_dynamic", {
		model = MONEY_MODEL,
		vscripts = "eltrasnag/laserinsurgency/li_money.nut"
		origin = spawn_pos
	})
}

PrecacheParticle <- function(name)
{
	PrecacheEntityFromTable({ classname = "info_particle_system", effect_name = name })
}

clamp <- function(value, min, max) {
	if (value < min) {
		return min
	}
	if (value > max) {
		return max
	}
	return value
}

ValidEntity <- function(hHandle) {
	if (hHandle != null && hHandle.IsValid()) {
		return true
	}
	else {
		return false
	}
}

ValidHandle <- function(hHandle) {
	if (hHandle != null) {
		return true
	}
	else {
		return false
	}
}

GetAngleFromEntity <- function(to, from_ent)
{
	local from = from_ent.GetOrigin();
	return QAngle(0, atan2(from.y - to.y, from.x - to.x) * 180 / PI, 0)
}

GetLookAngle <- function(from_origin, to_origin) // the above function done infinitely better
{
	return QAngle(0, atan2(to_origin.y - from_origin.y, to_origin.x - from_origin.x) * 180 / PI, 0)
}

absVec <- function(vecA) {
	return Vector(abs(vecA.x), abs(vecA.y), abs(vecA.z))
}
divVec <- function(vecA, vecB) {


	return Vector(vecA.x / vecA.x, vecA.y / vecB.y, vecA.z / vecB.z)
}
multVec <- function(vecA, vecB) {


	return Vector(vecA.x * vecA.x, vecA.y * vecB.y, vecA.z * vecB.z)
}
vecAng <- function(vecA, vecB) {
	// local vecP1 = vecB - vecA;
	// local vecP2 = vec

	local ret1 = QAngle(atan2(vecB.x - vecA.x, vecB.y - vecA.y), atan2(vecB.y - vecA.y, vecB.x - vecA.x), atan2(vecB.x - vecA.x, vecB.z - vecA.z))
	// printl("vecAng: "+ret1.tostring())
	return ret1
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

PlaySoundEX <- function(strSoundName, vPos = Vector(0,0,0), flVol = 10, flPitch = 100) {
	PrecacheSound(strSoundName)
	local hSound = SpawnEntityFromTable("ambient_generic", {
		message = strSoundName,
		origin = vPos,
		health = flVol,
		spawnflags = 48,
	})

	hSound.AcceptInput("PlaySound","",null,null)
	hSound.Kill()
}

MakeMusic <- function(strSoundName) {
	PrecacheSound(strSoundName)
	local tSoundTable = {
		message = strSoundName,
		spawnflags = 49,
		health = 10,
	}
	local hSound = SpawnEntityFromTable("ambient_generic", tSoundTable)
	return hSound


}



::ButtonPressed <- function(hPlayer, iButton) {
	if (NetProps.GetPropInt(hPlayer, "m_nButtons") & iButton) {
		return true
	}
	return false
}

__CollectGameEventCallbacks(this)
RegisterScriptGameEventListener("player_death")

function OnGameEvent_player_death(params) {
	printl("PLAYE DEAD")
	local hPlayer = GetPlayerFromUserID(params.userid)
	local hScope = hPlayer.GetScriptScope()


	if (hScope.iPlayerHClass == HCLASSES.LI_CLASS_LAURAPALMER) {

		for (local i; i = Entities.FindByClassname(i, "player");) {
			if (ValidEntity(i)) {

				if (i.GetScriptScope().iPlayerHClass == HCLASSES.LI_CLASS_LAURAPALMER) {
					PrecacheSound(SND_LAURA_DEATH)
					EmitSoundOn(SND_LAURA_DEATH, i)
					local iIdiot = NetProps.GetPropInt(i, "m_iHealth");
					if (ValidHandle(iIdiot)) {

						NetProps.SetPropInt(i, "m_iHealth", NetProps.GetPropInt(i,"m_iHealth") - 25)
					}
					ScreenFade(i, 194, 23, 23, 150, 0.4, 0, 1)
					ClientPrint(i, 4, "| YOU FEEL THE LAURTESSENCE GETTING WEAKER |")
					continue;

				}
				if (i.GetTeam() == TEAMS.HUMANS) {
					local iMaxHP = NetProps.GetPropInt(i,"m_iMaxHealth")
					NetProps.SetPropInt(i, "m_iHealth", iMaxHP)
					ScreenFade(i, 79, 255, 177, 150, 0.3, 0, 1)
					ClientPrint(i, 4, "| LAURA HAS GRACED YOU... |")

				}
			}
		}
		hScope.iPlayerHClass = HCLASSES.LI_CLASS_STRAIGHT
		::REMAININGLAURAS--


	}
}

::DoDialogueArray <- function(aDialogues = ["ERR_NO_DIALOGUE"], strCharacter = "ERR_CHAR", iGlobal = 1) {

	local flDelay = 0.0

	foreach (strDialogue in aDialogues) {

		printl("strDialogue: "+strDialogue.tostring())

		local strFireValue = "DoDialogue(\"" + strDialogue + "\",\"" + strCharacter + "\",false," + iGlobal.tostring() + ")"

		QFireByHandle(self, "RunScriptCode", strFireValue, flDelay, null, null) // queue all dialogues in sequence
		flDelay += DoDialogue(strDialogue, strCharacter, true) + 0.1
	}
}



DoDialogue <- function(strDialogue = "ERR_NO_DIALOGUE", strCharacter = "ERR_CHAR", bTimeOnly = false, iGlobal = 1) {

	strDialogue = strCharacter.toupper() + ": " + strDialogue

	local flEnterTime = DIALOGUE_CHAR_TIME * strDialogue.len()
	local flLifeTime = (flEnterTime + DIALOGUE_HOLD_TIME)

	printl("flEnterTime = "+flEnterTime.tostring())
	printl("flLifeTime = "+ flLifeTime.tostring())

	if (bTimeOnly == true) {
		return flLifeTime
	}


	local vColor = Vector(255,255,255)

	if (strCharacter.tolower() in tCharacters) {
		vColor = tCharacters[strCharacter]
		printl("Special character : "+strCharacter)
	}

	ClientPrint(null, 3, strDialogue)

	local hTheRapist = SpawnEntityFromTable("game_text", { // temp
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

	local hText = SpawnEntityFromTable("game_text", {
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

function DialogueThink() {
	printl("MAX LIFE "+flLifeTime.tostring())
	if (flLifeTime <= iTimer) {
		printl("DIALOGUE SHOULD DIE NOW????")
		self.Destroy()
	}
	printl(iTimer)
	iTimer += 0.0166666666666667
	return -1
}

GetUserID <- function(hPlayer) {
	return NetProps.GetPropInt(hPlayer, "m_iUserID")
}

KillDelayed <- function(hEnt, flDelay) {
	QFireByHandle(hEnt, "KillHierarchy", "", flDelay, null, null)
}

SetParentEX <- function(iEnt,iParent, strAttachment = null) {
	QFireByHandle(iEnt, "SetParent", "!activator", 0.0, iParent, null)

	if (strAttachment) {
		// local iAttachID = iEnt.LookupAttachment(strAttachment)
		// iEnt.AcceptInput("SetParentAttachment", strAttachment, null, null)
		QFireByHandle(iEnt, "SetParentAttachment", strAttachment, 0.1,null,  null)
	}
	return iEnt
}

GetAngleTo <- function(to, from)
{
	return QAngle(0, atan2(to.y - from.y, to.x - from.x) * 180 / PI, 0)
}

MapSayArray <- function(aDialogues = ["ERR_NO_DIALOGUE"], strCharacter = null) {

	local flDelay = 0.0

	foreach (strDialogue in aDialogues) {


		local strFireValue = "MapSay(\"" + strDialogue + "\",\"" + strCharacter + "\")"

		QFireByHandle(self, "RunScriptCode", strFireValue, flDelay, null, null) // queue all dialogues in sequence
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

			printl("found you")
			strColor = "\x07"+CHARACTER_COLORS[strCharacter].toupper()
		}
		strMsg = strColor + strCharacter.toupper() + strMessageColor + ": "  + strMsg
	}
	ClientPrint(null, 3, strMessageColor + strMsg);
}

RandomCT <- function() {
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

GetMovementVector <- function(to, from) {
	local v1 = to - from
	v1.Norm()
	return v1
}

GetMovementVector2D <- function(to, from) {
	local v1 = to - from
	v1.z = 0
	v1.Norm()
	return v1
}

GetDistanceTo <- function(to, from) {
	return sqrt( pow(to.x - from.x, 2) + pow(to.y - from.y,2) + pow(to.z - from.z,2) )
}

GetPlayerName <- function(hPlayer) {
	return NetProps.GetPropString(hPlayer, "m_szNetname")
}

SetAnimation <- function(hEnt, strAnimation, bDoDefault = false) {
	if (ValidEntity(hEnt))
	{
		if (bDoDefault) {
			hEnt.AcceptInput("SetDefaultAnimation",strAnimation,null,null)
		}
		hEnt.AcceptInput("SetAnimation",strAnimation,null,null)

	}
}

::IsAlive <- function(hPlayer) {
	if ((NetProps.GetPropInt(hPlayer,"m_iHealth") < 1)) {
		return false
	}
	return true
}

::MapSayDelayed <- function(text = "NOTEXT - MAPSAYDELAY", char = "MAP", delay = 0.0) {
	QFireByHandle(self, "RunScriptCode", "MapSay(`"+ text +"`,`"+ char +"`)", delay, null, null)
}