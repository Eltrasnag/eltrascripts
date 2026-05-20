IncludeScript("eltrasnag/nide26/shared.nut", this)

SF_CHICKEN_WALK <- "eltra/72hr/footsteps/mariahstep1.wav"
CHICKEN_MODEL <- "models/eltra/nide26/guy.mdl"

CHICKEN_SOUND_PATH <- "eltra/nide26/chicken"

SEED <- RandomFloat(0,PI)// lol "seed" (You might get a reference to a certian..animal... >Here!)

fl_NextSpeak <- 0;
fl_SpeakWait <- 0.5 + SEED;

function OnPostSpawn() {
	// dprintl("Chicken has spawned.")
	self.SetModelSimple(CHICKEN_MODEL)
	self.SetSkin(17)
	// self.SetName("katy's chicken")
	self.SetName("chicken")
	self.SetModelScale(RandomFloat(0.5,0.8), 0)

	if (RandomInt(1, 100) == 1) {
		self.SetModelScale(2, 0)
		QAcceptInput(self, "color", "255 0 0")
	}

	AddThinkToEnt(self, "Think")
	P_UTILS.SnapToFloor()
}

function StartFollow() {
}

function SetFollow(toggle) {
	if (toggle) {
		AddThinkToEnt(self, "Think")
		return
	}
	P_UTILS.SnapToFloor()
	AddThinkToEnt(self, "")
}


hTarget <- null;
v_TargetOrigin <- self.GetOrigin()
hTargetOrigins <- [v_TargetOrigin,v_TargetOrigin,v_TargetOrigin,v_TargetOrigin,v_TargetOrigin]

fl_NextTargetTime <- 0;

i_ChaseThreshold <- 256;

fl_NextCheckpointTime <- 0;
fl_CheckpointInterval <- 0.25

i_MinChaseThreshold <- 32
i_Speed <- RandomInt(16,64)
b_ChickenLoose <- true

function Think() {
	if (!b_ChickenLoose) {
		return 1
	}
	if (P_UTILS.BusStop("fl_NextSpeak", fl_SpeakWait)) {
		ChickenSound()
	}

	if (!ValidEntity(hTarget) || hTarget.GetTeam() != TEAMS.HUMANS) {
		Retarget()
		return 0.5
	}

	if (P_UTILS.BusStop("fl_NextTargetTime", RandomInt(7, 60))) {
		Retarget()
		return 0.5
	}


	local vOrigin = self.GetOrigin()

	local vTargOrigin = hTarget.GetOrigin()

	local p_dist = GetDistance2D(vTargOrigin, vOrigin)

	// make leshawna follow the player
	local trace = (QuickTrace(vTargOrigin, vOrigin, self))
	if (p_dist < i_ChaseThreshold) {

		// track the position...
		if (P_UTILS.BusStop("fl_NextCheckpointTime", fl_CheckpointInterval)) {
			v_TargetOrigin = hTargetOrigins[0]
			hTargetOrigins.remove(0)
			hTargetOrigins.append(hTarget.GetOrigin())

		}

		local vMoveVec = GetMovementVector(v_TargetOrigin, vOrigin)

		self.LookAt(vOrigin + vMoveVec, 0.5)

		local vNextOrigin = (vOrigin + (vMoveVec * i_Speed))
		local hopsin = (abs(sin((Time()+SEED) * 40) * 32))

		vNextOrigin.z = v_TargetOrigin.z + hopsin

		if (hopsin < 16) {
			PlaySoundEX(SF_CHICKEN_WALK, vOrigin)
		}


		if (p_dist > i_MinChaseThreshold) {
			self.KeyValueFromVector("origin", vNextOrigin)
		}


	} else {
		Retarget()
		P_UTILS.SnapToFloor()
	}
}

function Retarget() {
	local nearest = i_ChaseThreshold

	local candidate = null;
	local vOrigin = self.GetOrigin()
	local vTargOrigin = vOrigin

	for (local t; t = Entities.FindByClassnameWithin(t, "player", self.GetOrigin(), i_ChaseThreshold);) {
		if (t.GetTeam() == TEAMS.HUMANS) {
			local o = t.GetOrigin()
			if (GetDistance2D(o, vOrigin) < nearest) {
				vTargOrigin = o
				candidate = t
			}
		}

	}

	hTarget = candidate

	if (ValidEntity(hTarget)) {
		hTargetOrigins <- array(5, vTargOrigin)
	}

	fl_NextCheckpointTime = 0

	return 0.1
}

function ChickenSound() {
		local sndstr = CHICKEN_SOUND_PATH + RandomInt(1,5) + ".mp3"
		local vOrigin = self.GetOrigin()
		local pitch = RandomInt(95, 110)
		PlaySoundEX(sndstr, vOrigin, 100, pitch)
		CleanString(sndstr)
}
