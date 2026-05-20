v_EndOrigin <- Vector()

const DESERT_CAR_IMPACT_SOUND = "eltra/explode"

function OnPostSpawn() {
	// self.SetModelSimple()
}
const DESERT_CAR_DANGER_RADIUS = 96

function Think() {
	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()

	if (GetDistance2D(v_EndOrigin, vOrigin) < DESERT_CAR_SPEED) {
		AddThinkToEnt(self, "")
		self.Kill()
		return
	}

	self.KeyValueFromVector("origin", vOrigin + vAngles.Forward() * DESERT_CAR_SPEED)

	local p;
	while (p = Entities.FindByClassnameWithin(p, "player", vOrigin, DESERT_CAR_DANGER_RADIUS)) {
		p.SetAbsVelocity(vAngles.Forward() * DESERT_CAR_SPEED + Vector(0,0,1000))
		local impact_str = DESERT_CAR_IMPACT_SOUND + RandomInt(1,3) + ".mp3"
		local pitch = RandomInt(95, 105)

		PlaySoundEX(impact_str, p.GetOrigin(), 100, pitch)
		PlaySoundEX(impact_str, p.GetOrigin(), 100, pitch)

		p.TakeDamage(99999999, DMG_AIRBOAT, self)
		MapSay("dipshit got hit by a car LOL")
		CleanString(impact_str)
	}
	return 0.1

}