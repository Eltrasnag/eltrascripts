


Origin <- self.GetOrigin()
rand <- RandomInt(1,100)


function OnPostSpawn() {
	SpawnPos()
	AddThinkToEnt(self, "Think")
	self.SetModelScale(0.75, 0)
}

function SpawnPos() {

	local happytrace = QuickTrace(self.GetOrigin(), self.GetOrigin() + Vector(RandomInt(-3024, 3024), RandomInt(-3024, 3024), 0), self, MASK_SHOT_PORTAL)
	local groundtrace = QuickTrace(happytrace.pos, happytrace.pos - Vector(0, 0, 10000), self, MASK_SHOT_PORTAL)

	Origin = groundtrace.pos + Vector(0,0,32)

}

function Think() {
	if (!HappyActive) {
		self.DisableDraw()
		return 1
	} else {
		self.EnableDraw()
	}

	local vOrigin = Origin + Vector(0,0, (sin(Time() * 2 + rand)*4))
	local vAngles = QAngle(0, Time()*360 + rand, 0)
	for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", Origin, 64);) {
		if (ply.GetTeam() == TEAMS.HUMANS) {
			local partysound = "misc/happy_birthday_tf_"+RandomInt(10,29).tostring()+".wav"
			PlaySoundEX(partysound, vOrigin)
			CleanString(partysound)
			HappyUpdate()
			return
		}
	}

	self.SetAbsAngles(vAngles)
	self.KeyValueFromVector("origin", vOrigin)
	return 0.03
}

function HappyUpdate() {
		iSteamHappies++
		if (iSteamHappies == HappyNumber) {
			GrannySpeakIndex = 2
			QFire("mapsys", "RunScriptCode", "GrannySpeak()")
		} else {
			local dialoguestr =
			MapSay("Hoo hoo! You found one of my "+HappyNumber.tostring()+" steamhappies! Hoo hoo! Only "+(HappyNumber-iSteamHappies).tostring()+" left to find! Good luck! Hoo hoo! Hoo hoo!","granny")
		}
		self.Kill()
}

