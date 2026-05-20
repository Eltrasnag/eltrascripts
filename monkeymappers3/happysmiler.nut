
Victims <- []

function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
}

HomeOrigin <- self.GetOrigin()
AlertColor <- "255 0 0"
AttackTraceDistance <- 1024
NextAttackScanTime <- 0

function PlayerArray(ply, adding) {
	if (!ValidEntity(ply) || ply.GetTeam() != TEAMS.HUMANS)
		return


	local ply_in_array = Victims.find(ply)

	if (adding == true && !ply_in_array) {
		Victims.append(ply)
		print("Add player " + ply + " to array")

	}

	if (adding == false && ply_in_array != null) {

		Victims.remove(ply_in_array)

		printl("Remove player " + ply + " from array")
	}


}

function Think() {

	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()

	local flTime = Time()

	local next_return = 0.2

	local text_sine = (sin(flTime*5)+0.5)* 0.5

	if (flTime >= NextAttackScanTime) {
		QuickTrace(vOrigin, vOrigin + vAngles.Forward() * AttackTraceDistance)
	}

	foreach (i, ply in Victims) {
		next_return = 0.025
		printl("index = "+i+", victim = " + ply)
		if (!ValidEntity(ply) || ply.GetTeam() != TEAMS.HUMANS || !IsAlive(ply)) {
			Victims.remove(i)
			continue
		}



		local pOrigin = ply.EyePosition()
		local pAngles = ply.EyeAngles()

		local trace = QuickTrace(vOrigin  + Vector(0,0,64), pOrigin, self)

		if (developer() != 0) {
			DebugDrawLine(trace.startpos, trace.endpos, 255, 0, 0, false, next_return)
		}
		// printl()
		if (!trace.hit) {

			ShowTextOnClient("RUN NOW", ply, text_sine,  RandomFloat(0.4, 0.6), 1, AlertColor)

			self.KeyValueFromVector("origin", vOrigin + GetMovementVector(pOrigin, vOrigin) * 256)
			vOrigin = self.GetOrigin()
			if (GetDistance2D(vOrigin, pOrigin) <= 64) {
				ply.TakeDamage(40, 0, self)
			}

		} else {
			continue
		}


	}

	local HomeDistance2D = GetDistance(vOrigin, HomeOrigin)

	if (HomeDistance2D >= 128) {
		self.KeyValueFromVector("origin", vOrigin + GetMovementVector(HomeOrigin, vOrigin) * 200)

	}

	for (local i = 0; i < Victims.len(); i++) {

	}

	return next_return
}