IncludeScript("eltrasnag/nide26/shared.nut", this)

SF_FRIEND_WALK <- "eltra/72hr/footsteps/mariahstep1.wav"
function OnPostSpawn() {
	// dprintl("Friend has spawned.")
	// AddThinkToEnt(self, "Think")
}

function StartFollow() {
	AddThinkToEnt(self, "Think")
}

function SetFollow(toggle) {
	if (toggle) {
		AddThinkToEnt(self, "Think")
		return
	}
	P_UTILS.SnapToFloor()
	AddThinkToEnt(self, "")
}
// fl_GravAccel <- 500


hTarget <- null;
v_TargetOrigin <- self.GetOrigin()
hTargetOrigins <- [v_TargetOrigin,v_TargetOrigin,v_TargetOrigin,v_TargetOrigin,v_TargetOrigin]

fl_NextTargetTime <- 0;

i_ChaseThreshold <- 256;

fl_NextCheckpointTime <- 0;
fl_CheckpointInterval <- 0.25



function Think() {
	if (!ValidEntity(hTarget) || hTarget.GetTeam() != TEAMS.HUMANS) {
		Retarget()
		return -1
	}

	if (P_UTILS.BusStop("fl_NextTargetTime", RandomInt(7, 60))) {
		Retarget()
	}


	local vOrigin = self.GetOrigin()

	local vTargOrigin = hTarget.GetOrigin()

	local p_dist = GetDistance2D(vTargOrigin, vOrigin)

	// make leshawna follow the player
	if (p_dist > i_ChaseThreshold) {


		// track the players position...
		if (P_UTILS.BusStop("fl_NextCheckpointTime", fl_CheckpointInterval)) {
			// __DumpScope(1, hTargetOrigins)
			v_TargetOrigin = hTargetOrigins[0]
			hTargetOrigins.remove(0)
			hTargetOrigins.append(hTarget.GetOrigin())

		}

		local vMoveVec = GetMovementVector(v_TargetOrigin, vOrigin)

		self.LookAt(vOrigin + vMoveVec, 0.5)

		local vNextOrigin = (vOrigin + (vMoveVec * clamp((p_dist/i_ChaseThreshold) * 16, 1, 64)))
		local hopsin = (abs(sin(Time() * 40) * 32))

		vNextOrigin.z = v_TargetOrigin.z + hopsin

		if (hopsin < 16) {
			PlaySoundEX(SF_FRIEND_WALK, vOrigin)
		}

		self.KeyValueFromVector("origin", vNextOrigin)


	} else {
		// P_UTILS.FakeGravity()
		P_UTILS.SnapToFloor()

	}
}

function Retarget() {
	hTarget = RandomCT()
	if (ValidEntity(hTarget)) {
		hTargetOrigins <- array(5, hTarget.GetOrigin())
	}
	fl_NextCheckpointTime = 0
}