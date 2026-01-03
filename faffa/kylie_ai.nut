// CONSTANTS
const KYLIE_TRAVEL_DISTANCE = 1280.0;
const KYLIE_RAGE_ADD_AMOUNT = 0.5

::Kylie <- self

// VARIABLES
iDifficulty <- 0;
iAttention <- 0;
iRage <- 0;
iAttendees <- 0;
vBasePos <- Vector(0,0,0)
// flEndY <- self.GetOrigin() + Vector(0,KYLIE_TRAVEL_DISTANCE,0)
flEndY <- self.GetOrigin().y + KYLIE_TRAVEL_DISTANCE;
tAttendees <- [];

function OnPostSpawn() {
	vBasePos = self.GetOrigin()
	print("kylie spawned")
	AddThinkToEnt(self, "KylieThink")
}


function KylieThink() {

	local vOrigin = self.GetOrigin()
	local Progress = (KYLIE_TRAVEL_DISTANCE - abs(vOrigin.y - flEndY))/KYLIE_TRAVEL_DISTANCE
	local MusProgress = clamp(Progress*5, 0.1,100)
	foreach (hAttendee in tAttendees) {
		if (hAttendee != null && hAttendee.IsValid()) {
			local player_scope = hAttendee.GetScriptScope()
			hAttendee.GetScriptScope().iToxic++
		}
	}

	if (iDifficulty != 0) {
		if (iAttendees == 0) {
			iRage += KYLIE_RAGE_ADD_AMOUNT * iDifficulty

		}
		else {
			iRage -= 1/(iDifficulty*0.1)
		}

		local Rand1 = RandomInt(0,100)

		if (Rand1 <= iDifficulty) {
		}
	}
	local RageProgress = ((iRage*200/KYLIE_TRAVEL_DISTANCE))

	local mvPos = Vector(vBasePos.x, vBasePos.y + RageProgress, vBasePos.z)

	self.KeyValueFromVector("origin", mvPos)

	if (MusProgress > 2) {
		QFire("locomotion", "Volume", (MusProgress).tostring())

	}
	else {
				QFire("locomotion", "Volume", "0")
	}

	// printl("Kylie Progress : " + floor(Progress*100).tostring() + "%")
	if (iRage > iDifficulty) {
	}

	if (Progress >= 1) {
		// printl("It's over")
		AddThinkToEnt(self, "DoomThink")
		PrepareJumpscare()
		return
	}
	return 0.1
}

function PrepareJumpscare() {
	QFire("ambient_generic*", "Volume", "0")
	// QFire()
	ScreenFade(null, 0,0,0,255,0.1,777,0)
}

function DoomThink() {
	if (RandomInt(0, 20) == 2) {
		GlobalJumpscare(CHARACTERS.KYLIE)
		AddThinkToEnt(self,"")
		return
	}
	return 0.5
}

function AttentionStart() {
	// printl("someone is paying attention")
}

function AttentionStop() {
	// printl("no one is paying attention")
}

function AttentionAdd(activator) {
	activator.GetScriptScope().bPoisoned = true
	iAttendees++
	// printl("player  added to attention counter")
}

function AttentionSub(activator) {
	activator.GetScriptScope().bPoisoned = false

	iAttendees--
	// printl("player removed from attention counter")
}