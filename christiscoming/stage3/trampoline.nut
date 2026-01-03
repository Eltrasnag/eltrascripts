// IncludeScript("eltrasnag/common.nut", this)
const IN_JUMP = 2
const IN_FORWARD = 8

scanradius <- 0;
heighttolerance <- 64
boostvec <- self.GetAbsAngles().Up()

function OnPostSpawn() {
	AddThinkToEnt(self, "SleepThink")
	scanradius = self.GetBoundingMaxs().Length2D()
}

function SleepThink() { // trampoline is waiting on standby for players to get close enough

	local vOrigin = self.GetOrigin()

	// DebugDrawCircle(vOrigin, Vector(255, 255, 255), 20, 512, false, 0.1)

	for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", self.GetOrigin(), 512);) { // if we find *anything* then we must activate
		AddThinkToEnt(self, "ActiveThink")
		return -1
	}
	return 1
}

// rx_trampojumped <- regexp("jumpedtrampoline:true")
function ActiveThink() { // trampoline is close enough to players
	local vOrigin = self.GetOrigin()
	vOrigin.z += scanradius*0.5
	// DebugDrawCircle(vOrigin, Vector(255, 255, 255), 90, scanradius, false, 0.1)

	local in_range = false

	for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, scanradius);) { // if we find *anything* then we must activate
		local pOrigin = ply.GetOrigin()
		local heightdiff = abs(pOrigin.z - vOrigin.z)
		local pvel = ply.GetAbsVelocity()

		if (heightdiff > heighttolerance || pvel.z > 0) {
			continue;
		}
		pvel.z = 0

		local context = GetContext(ply)


		if ("trampojumped" in context && context.trampojumped == 1) {
			continue;
		} else {
			QFireByHandle(ply, "RunScriptCode", "SetContext(self, `trampojumped`, 0)", 0.25)
			SetContext(ply, "trampojumped", 1)
		}

		PrecacheSound("eltra/small_hop01.mp3")
		PlaySoundEX("eltra/small_hop01.mp3", vOrigin, 10, RandomInt(120,150))

		in_range = true
		ply.ViewPunch(QAngle(-20, 0, 0))
		pvel.z = clamp(abs(pvel.z), 300, 3000)

		pvel += boostvec * 200
		if (ButtonPressed(ply, IN_FORWARD)) {
			pvel += ply.GetAbsAngles().Forward() * 300
		}

		// NetProps.SetPropVector(ply, "m_vecBaseVelocity", pvel)
		ply.SetAbsVelocity(pvel)
		// if (ButtonPressed(ply, IN_JUMP)) {



		// }
	}
	if (in_range == false) { // out of player range, go into standby
		AddThinkToEnt(self, "SleepThink")
		return -1
	}
	// QuickTraceHull()

	return -1
}