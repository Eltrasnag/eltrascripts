
// IncludeScript("eltrasnag/common.nut", this)

startrise <- Time() + 0.25
endorigin <- self.GetOrigin() + Vector(0,0,160)
killtime <- 0
victim <- null
ip_address <- RandomInt(190,198) + "." + RandomInt(90,130)+ "." + RandomInt(1,99)+ "." + RandomInt(100,140)
const SF_BOBEXPLODE = "eltra/explode3.mp3"
function OnPostSpawn() {
	AddThinkToEnt(self, "BobWait")
	local iptext = Spawn("game_text", {
		message = ip_address,
		fadein = 1,
		fadeout = 0.0,
		holdtime = 0.3,
		effect = 1,
		fxtime = 2,
		color = "255 255 255",
		channel = 3,
		x = -1,
		y = -1,
	})
	QFireByHandle(iptext, "Display", "", 0.0, victim)
	iptext.Kill()
	PlaySoundEX("eltra/bob_cipher_short.mp3", endorigin)
}

function BobWait() {
	if (Time() > startrise) {
		AddThinkToEnt(self, "BobRise")
		return -1
	}
}

function BobRise() {
	local vOrigin = self.GetOrigin()
	if (endorigin.z-1 >= vOrigin.z) {
		// if (ValidEntity(victim)) {
		// 	ClientPrint(victim, Constants.EHudNotify.HUD_PRINTCENTER, ip_address)
		// }
		self.KeyValueFromVector("origin", vLerp(vOrigin, endorigin, FrameTime() * 20))
	} else {
		killtime = Time() + 0.75
		AddThinkToEnt(self, "BobKill")
		return -1
	}
	return -1
}

function BobKill() {
	if (Time() >= killtime) {
		local vOrigin = self.GetOrigin()
		AddThinkToEnt(self, "")
		local boom = SpawnEntityFromTable("env_explosion", {
			origin = vOrigin,
			iMagnitude = 150,
			iRadiusOverride = 200,
			DamageForce = 700.0
		})
		if (ValidEntity(victim)) {
			ScreenFade(victim, 255, 0, 0, 255, 1, 0.1, 1)
			victim.TakeDamage(9999999, Constants.FDmgType.DMG_ALWAYSGIB, null)
			DoEffect("cic_explosion", victim.GetOrigin())
		}
		PlaySoundEX(SF_BOBEXPLODE, vOrigin)
		self.Kill()
		return -1
	}
	return 0.1
}