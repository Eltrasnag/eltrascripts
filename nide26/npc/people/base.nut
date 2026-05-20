IncludeScript("eltrasnag/nide26/shared.nut", this)
IncludeScript("eltrasnag/modules/ihealth.nut", this)
IncludeScript("eltrasnag/nide26/misc/guy_names.nut", this)
const GUY_SCRIPT_BASE = "eltrasnag/nide26/npc/people/base.nut"
const GUY_NAMEPLATE_OFFSET = 96
const PLAYER_USE_RADIUS = 80

iHealth <- 500;
b_TakeDamage <- false;
h_NamePlate <- null;
const GUY_VOX_PATH = "eltra/nide26/guyvox/"

const COLLISION_GROUP_INTERACTIVE_DEBRIS = 	3

i_VoxPitch <- RandomInt(85, 107)

i_ActiveDistance <- 1024
i_Sex <- RandomInt(0, 1);

const ASCII_CHAR_OFFSET = 65
// const AC_CHAR_OFFSET <-
const GUY_SKIN_COUNT = 16
enum SKIN { CONTROLTEAM1 = 0,
DOCTOR1 = 1,
DOCTOR2 = 2,
FARMER1 = 3,
FARMER2 = 4,
HUNTER1 = 5,
LIBRARIAN1 = 6,
MAILMAN1 = 7,
NUN1 = 8,
NUN2 = 9,
NURSE1 = 10,
NURSE2 = 11,
POLICE1 = 12,
POLICE2 = 13,
WAITRESS1 = 14,
WAITRESS2 = 15,
KATYPERRY1 = 16,
CHICKEN1 = 17
}

fl_NextSpeechTime <- 0;
fl_SpeechDelay <- 0.1
SPEECH_SOUND_QUEUE <- []


function PickGuyName(sex = i_Sex) {
	local name_array = GUY_NAMES[sex]
	return name_array[RandomInt(0, name_array.len()-1)]
}

str_Name <- PickGuyName(i_Sex);
b_IgnorePlayers <- false
i_WakeRadius <- 256

function OnPlayerUse() {
	// replace this in the inheriting script to use it
}

UseList <- [];

ThinkFunctions <- []



function SpawnAction() {
	// do something on spawn
}



function OnPostSpawn() {
	self.ValidateScriptScope()

	dprintl(str_Name, " has joined the game.")

	P_UTILS.SnapToFloor()
	// dprintl(self, "Okay so theres a guy here")

	local ctx = self.GetContext()
	foreach (key, val in ctx) {
		if (key in this) {
			dprintl("Found context override! setting ", key, " to ", val)
			this[key] <- val
		}
	}


	self.SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)



	if (b_IgnorePlayers == false) {
		AddThinkToEnt(self, "Think")
	}

	str_VoxPath <- GUY_VOX_PATH + i_Sex + "/"

	SpawnAction()

}

b_SpottedPlayer <- false
fl_HopEndTime <- 0

fl_HopLength <- 0.3
vec_HopOrigin <- Vector()

vec_SpawnOrigin <- self.GetOrigin()
b_Hopping <- false
fl_HopDistance <- 48
fl_HopSin <- 0
fl_HopSinAdd <- (PI / (fl_HopLength * 60.0))

vBaseAngles <- self.GetAbsAngles()

fl_NextUseTime <- 0
fl_UseWait <- 3

const SF_GUY_DEATH = "eltra/zobmie_die.mp3"

function DeathAction() {
	// do something when the  guy dies
}

function meta_TakeDamage() {
	PlaySoundNPC(SF_GUY_DEATH, self)
	self.SetModelScale(0.98, 0)
	QAcceptInput(self, "color", "255 0 0")
	self.SetModelScale(1, 0.1)
	QFireByHandle(self, "color", "255 255 255", 0.25)
	DamageAction()
}

fl_Seed <- RandomFloat(0, 1)
fl_SleepThinkReturn <- 1+fl_Seed

function SleepThink() {
	local p = Entities.FindByClassnameNearest("player", self.GetOrigin(), i_ActiveDistance)

	if (ValidEntity(p)) {
		AddThinkToEnt(self, "Think")
		return -1
	}
	return fl_SleepThinkReturn
}

function Think() {
	if (b_TakeDamage && iHealthAlive() == false) {

		Die()
		return -1
	}



	local vOrigin = self.GetOrigin()
	local p = Entities.FindByClassnameNearest("player", vOrigin, i_ActiveDistance)

	if (!ValidEntity(p)) {
		AddThinkToEnt(self, "SleepThink")
		return
	}


	local ply = Entities.FindByClassnameNearest("player", vOrigin, i_WakeRadius)

	if (ValidEntity(ply) && (ply.GetTeam() == TEAMS.HUMANS)) {

		if (!ValidEntity(h_NamePlate)) {
			h_NamePlate = Spawn("point_worldtext", {
				origin = self.GetOrigin() + Vector(0, 0, GUY_NAMEPLATE_OFFSET),
				color = RandomInt(15, 255)+" "+RandomInt(15, 255)+" "+RandomInt(15, 255)+" 255",
				message = str_Name,
				orientation = 2,
				font = 5,
				vscripts = "eltrasnag/nide26/misc/guy_nameplate.nut"
			})
			SetParentEX(h_NamePlate, self)
			// h_NamePlate(SetLocalOffset)
		}

		if (!b_SpottedPlayer) {
			dprintl(self, ": FRIEND DETECTED !!!!!")
			b_SpottedPlayer = true
			fl_HopEndTime = Time() + fl_HopLength
			vec_HopOrigin = vOrigin
			b_Hopping = true
		}

		if (Time() <= fl_HopEndTime && b_SpottedPlayer) {
			self.KeyValueFromVector("origin", vec_HopOrigin + Vector(0,0, fl_HopDistance*sin(fl_HopSin)))
			fl_HopSin += fl_HopSinAdd
		} else if (b_Hopping) {
			b_Hopping = false
			self.KeyValueFromVector("origin", vec_HopOrigin)
		}

		local vAngles = self.GetAbsAngles()



		local vPlayerOrigin = ply.GetOrigin()

		vPlayerOrigin.z = vOrigin.z

		// local LookAngles = QuaternionSlerp()
		self.LookAt(vPlayerOrigin, 0.1)


		for (local p; p = Entities.FindByClassnameWithin(p, "player", vOrigin, PLAYER_USE_RADIUS);) {
			// dprintl(p)

			local use_list_idx = UseList.find(p)

			if (ButtonPressed(p, IN_USE)) {
				if (use_list_idx != null) {
					continue
				}
				UseList.append(p)
				local eyepos = p.EyePosition()
				local eyeang = p.EyeAngles()
				local use_trace = QuickTrace(eyepos, eyepos + eyeang.Forward() * PLAYER_USE_RADIUS)

				if (use_trace.hit && use_trace.enthit == self && P_UTILS.BusStop("fl_NextUseTime", fl_UseWait)) {
					OnPlayerUse(p)
					self.QAcceptInput("FireUser1", "", p, p)
				}
			} else{
				if (use_list_idx != null) {
					UseList.remove(use_list_idx)
				}
			}
		}

		if ((SPEECH_SOUND_QUEUE.len() != 0) && P_UTILS.BusStop("fl_NextSpeechTime", DIALOGUE_CHAR_TIME)) {
			PlaySoundEX(str_VoxPath + (SPEECH_SOUND_QUEUE[0] - ASCII_CHAR_OFFSET).tointeger() + ".wav", vOrigin, 100, i_VoxPitch)
			SPEECH_SOUND_QUEUE.remove(0)


		}

		return -1
	}
	P_UTILS.SnapToFloor()
	fl_HopSin = 0
	b_SpottedPlayer = false

	if (ValidEntity(h_NamePlate)) {
		h_NamePlate.Kill()
	}

	foreach (i, func in ThinkFunctions) {
		func.call(this)
	}

	return 0.25

}



function AddNPCThink(func) {
	if ((ThinkFunctions.find(func) == null)) {
		ThinkFunctions.append(func)
		return
	}
	// dprintl(__FILE__, ": Can't add function ", func, ", already exists in ThinkArray!")
}

function RemoveNPCThink(func) {
	local idx = ThinkFunctions.find(func)
	if (idx != null) {
		ThinkFunctions.remove(idx)
		return
	}
	// dprintl(__FILE__, ": Can't remove function ", func, ", it is not in the ThinkArray!")
}

function SpeakLine(line, ply = null) {

	DoDialogue(line, str_Name, 0, false, ply)

	foreach (i, char in str_Name) {
		SPEECH_SOUND_QUEUE.append(-1)
	}
	foreach (i, char in line.toupper()) {
		if (char >= ASCII_CHAR_OFFSET) {
			SPEECH_SOUND_QUEUE.append(char.tointeger())
			// PlaySoundNPC((char - ASCII_CHAR_OFFSET).tointeger() + ".wav", self)
		}
	}
}

function Die() {
	DeathAction()
	AddThinkToEnt(self, "")
	self.Kill()
}

function DamageAction() {
	// do something when damaged
}

// function PlayerThink()


function RandomArray(ary) {
	local l = ary.len()
	return ary[RandomInt(0, l-1)]
}