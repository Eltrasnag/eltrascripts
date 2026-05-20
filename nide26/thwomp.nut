IncludeScript("eltrasnag/modules/ihealth.nut", this)
IncludeScript("eltrasnag/nide26/shared.nut", this)

i_WakeRadius <- 1024
iHealth <- 2500

iHealthScaleMult <- 1.0/iHealth
fl_Mass <- 10000
SF_THWOMP <- SOUND_DIR + "/npc_thwomp.mp3"

vSpawnOrigin <- self.GetOrigin()
vSpawnAngles <- self.GetAbsAngles()

function OnPostSpawn() {
	AddThinkToEnt(self, "SleepThink")
	NetProps.SetPropFloat(self, "m_flMassOverride", 1000)
    ListenHooks({
        OnScriptHook_OnTakeDamage = function(params) {
            if (params.const_entity == self && params.inflictor && ValidEntity(params.inflictor) && params.inflictor.IsPlayer()) {

                self.SetPhysVelocity( (params.damage_force * 0.01) + self.GetPhysVelocity() )
            }
        }
    })


}

function SleepThink() {

	local vOrigin = self.GetOrigin()
	local vVelocity = self.GetPhysVelocity()


	if (GetDistance2D(vSpawnOrigin, vOrigin) < 100) {
		// DisableMotion(self)
		self.KeyValueFromVector("origin",  vOrigin + (GetMovementVector(vSpawnOrigin, vOrigin) * 100))
	}

	for (local p; p = Entities.FindByClassnameWithin(p, "player", vOrigin, i_WakeRadius);) {
		EnableMotion(self)
		AddThinkToEnt(self, "ActiveThink")
		return -1

	}
	return 0.05
}

fl_NextAttackTime <- 0
fl_AttackDelay <- 2
fl_LastPhaseTime <- 0

i_AttackPhase <- 0


fl_NextThwompSound <- 0
fl_ThwompSoundDelay <- 3

fl_NextLaunchTime <- 0
fl_LaunchDelay <- 2

fl_NextScanTime <- 0
fl_ScanDelay <- 10


function ActiveThink() {

	if (iHealthAlive() == false) {
		AddThinkToEnt(self, "")
		OnDeath()
		return -1
	}

	local vOrigin = self.GetOrigin()
	local vVelocity = self.GetPhysVelocity()
	local vAngles = self.GetAbsAngles()


	if ( P_UTILS.BusStop("fl_NextAttackTime", fl_AttackDelay) ) {
		fl_LastPhaseTime <- Time()
		i_AttackPhase++
		if (i_AttackPhase >= 3) {
			i_AttackPhase = 0
		}
		dprintl("Attack phase increases : ", i_AttackPhase)
	}

	local distance_to_spawn = GetDistance(vSpawnOrigin, vOrigin)

	local ply = Entities.FindByClassnameNearest("player", vOrigin, i_WakeRadius)


	switch (i_AttackPhase) {
		case 0:

			local vMoveVec = GetMovementVector(vSpawnOrigin, vOrigin)
			// self.SetPhysVelocity(vMoveVec * distance_to_spawn * vVelocity.Length())

			local vNextAngles = (vSpawnAngles - (vAngles * 0.25))
			self.SetPhysAngularVelocity(Vector(vNextAngles.x, vNextAngles.y, vNextAngles.z) * 20)


			break;

		case 1:
			if (!ValidEntity(ply)) {
				break;
			}

			local vPlyOrigin = ply.EyePosition()

			// local vLookAngles = GetLookAngle(vOrigin, vPlyOrigin)
			local vLookAngles = self.LookingAt(vPlyOrigin)

			local tdelt = (Time() - fl_LastPhaseTime) * 10

			vLookAngles.z += RandomInt(-1,1) * tdelt
			vLookAngles.y += RandomInt(-1,1) * tdelt


			self.SetPhysAngles(vLookAngles)
			self.SetPhysVelocity(vVelocity * Vector(0,0,1))

		break;

		case 2:
			local ground_trace = QuickTrace(vOrigin, vOrigin + Vector(0,0,-10))


			if (!ValidEntity(ply)) {
				break;
			}
			local vPlyOrigin = ply.EyePosition()
			self.SetPhysAngles(self.LookingAt(vPlyOrigin))


			if (ValidEntity(ply) && (P_UTILS.BusStop("fl_NextLaunchTime", fl_LaunchDelay))) {
				self.SetPhysVelocity((GetMovementVector(vPlyOrigin, vOrigin) * 500) * GetDistance2D(vPlyOrigin, vOrigin) + (vVelocity))
			}
			if (ground_trace.hit == true) {
				if (P_UTILS.BusStop("fl_NextThwompSound", fl_ThwompSoundDelay)) {
					PlaySoundEX(SF_THWOMP, vOrigin, 100, 100, 7000)
				}

			}
		break;

		case 3:

		break;
	}

	if (P_UTILS.BusStop("fl_NextScanTime", fl_ScanDelay)) {
		for (local i; i = Entities.FindByClassnameWithin(i, "player", vOrigin, i_WakeRadius);) {
			return -1
		}

		dprintl("No pleayers ... ,,..")
		i_AttackPhase = -1
		AddThinkToEnt(self, "SleepThink")
		return -1
	}

	return -1
}

function LifeCheck() {

}

function OnDeath() {
	AddThinkToEnt(self, "")
	self.Kill()
}

function meta_TakeDamage() {
	local scaled = iHealth*iHealthScaleMult
	NetProps.SetPropFloat(self, "m_flMassOverride", fl_Mass * scaled)
	if (scaled > 0.25)
		self.SetModelScale(iHealth * iHealthScaleMult, 0.1)
		return
	self.SetModelScale(0.25, 0.1)
}