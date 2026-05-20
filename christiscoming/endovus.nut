IncludeScript("eltrasnag/npc/npc_base.nut")
IncludeScript("eltrasnag/npc/bossfunc.nut")

NPC_NAME <- "RENDERUS"
iHealth <- 9999999999
iHealthBase <- 1000
iHealthAdd <- 4000

ENDO_ORIGIN <- self.GetOrigin()

ENDO_DEV <- false // ease of testing
::ENDO_BOSS <- self
::ENDO_NPCS <- 0

NPC_AUTODECAY <- false
NPC_IS_CLIFF_SMART <- false
NPC_RESOLVES_COLLISIONS <- false

NPC_TURNSPEED <- 13

NPC_TARGET_RADIUS <- 0
NPC_GRAVITY <- 0
ANIM_FOLLOW <- "move_walk"
ANIM_DEATH <- "move_injured"
ANIM_IDLE <- "move_stand"

NPC_MOVEMENT_OVERRIDE <- true

NPC_ACCELERATION <- 1

NPC_ATTACKSTRENGTH <- 20

const STEP_INTERVAL_WALK = 0.5
StepInterval <- STEP_INTERVAL_WALK
NextStepTime <- 0
DoFootstep <- false

In_Cutscene <- true







enum ENDO_MODES{WALK, RUN, CHARGE, DEPLOY}
ENDO_MODE <- ENDO_MODES.WALK

::ENDO_BOUNDS_MAX <- Vector()
::ENDO_BOUNDS_MIN <- Vector()
::ENDO_BOUNDS_MID <- Vector()

ENDO_CHARGE_SPEED <- 60
ENDO_SPEED_WALK <- 300
ENDO_SPEED_RUN <- 1000

//ENDO MOVEMENT STUFF
ENDO_ORBIT_HEIGHT <- 256
ENDO_ORBIT <- true
ENDO_ORBIT_RADIUS <- 512

ENDO_ATTACK_COOLDOWN <- 8
ENDO_NEXT_ATTACK_TIME <- 0
ENDO_NEXT_RETARGET_TIME <- 0

ENDO_DANGER_RADIUS <- 1000 // boss-specific danger radius for attacks

ENDO_GRABBING_SPEED <- 50
ENDO_GRABBING <- false
ENDO_GRABBING_RADIUS <- 32

ENDO_DIVING <- false

ENDO_BOMBING <- false
ENDO_BOMBING_NEXT <- 0
ENDO_BOMBING_DELAY <- 0.6
ENDO_BOMBING_RADIUS <- 2000
ENDO_BOMBING_HEIGHT <- 512

// ! CompilePal::IncludeDirectory("sound/eltra/cic")
// PrecacheSound("eltrasnag/cic/ENDO_slip1.mp3")
// PrecacheSound("eltrasnag/cic/ENDO_slip2.mp3")
// PrecacheSound("eltrasnag/cic/ENDO_random1.mp3")

// !CompilePal::IncludeFile(materials/skybox/sky_quarry01up)
// !CompilePal::IncludeFile(materials/skybox/sky_quarry01dn)
// !CompilePal::IncludeFile(materials/skybox/sky_quarry01lf)
// !CompilePal::IncludeFile(materials/skybox/sky_quarry01rt)
// !CompilePal::IncludeFile(materials/skybox/sky_quarry01bk)
// !CompilePal::IncludeFile(materials/skybox/sky_quarry01ft)


CurrentAnimation <- ""

vWant <- Vector()



Cutscene1_StartAngle <- self.GetAbsAngles()
Cutscene1_EndQuat <- QAngle(Cutscene1_StartAngle.x, Cutscene1_StartAngle.y + 180, Cutscene1_StartAngle.z).ToQuat()


function Precache() {


	if (ENDO_DEV)

		::MapStage <- 2
}


// intro and boss cutscenes

function StartBoss() {
	NPC_GRAVITY = 0

	QFire("s3_mus_endoboss_a", "PlaySound", "", 0.1)


	if (ENDO_DEV) {
		GetListenServerHost().SetAbsOrigin(Entities.FindByName(null, "endo_dev_origin").GetOrigin())
		// BossActivate()
		return
	}

	// RunScriptCode(self, "AddThinkToEnt(self, `TurnFacePlayer`)", 1)




	local ENDO_bossactivate = 1
	RunScriptCode(self, "BossActivate()", ENDO_bossactivate)

}

function TurnFacePlayer() { // align ENDO with players in cutscene
	self.SetAbsAngles(QuaternionSlerp(self.GetAbsAngles().ToQuat(), Cutscene1_EndQuat, 0.1).ToQAngle())
	// printl("look at me")
	return 0.05
}


// actual bossfight code beyond this point

function BossActivate() {
	RunScriptCode(self, "ScreenFade(null, 255, 255, 255, 255, 0.7,0.1, FFADE_IN)", 0.84)
	In_Cutscene = false
	RunScriptCode(self, "Wake()", 0.84)
	RunScriptCode(self, "HealthScale()", 0.5)

	// QFire("s3_mus_ENDOboss_a", "StopSound")

	QFire("s3_mus_ENDOboss_a", "PlaySound")
}


function CustomSpawn() {
	self.KeyValueFromString("targetname", "endovus")
	// DoAnimation("move_stand") // ENDO is praying, players see her from elevator.
	RunScriptCode(hVisModel, "SetAnimation(self, `tuff`)", 0.1)
	if (ENDO_DEV)
		::MapStage <- 2
		local tp = Entities.FindByName(null, "ENDO_dev_spawn")
		GetListenServerHost().SetAbsOrigin(tp.GetOrigin())
		GetListenServerHost().SnapEyeAngles(tp.GetAbsAngles())

}

In_Charge <- false // is ENDO actively charging someone?
Waiting <- false // dummy waiting variable for attacks to use
WaitEnd <- 0 // the end of the above's waiting period

ENDO_HOVER_SPEED <- 2
ENDO_HOVER_DISTANCE <- 100
function CustomActive() {

	ShowBossBar()
	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()
	local vNextOrigin = vOrigin
	local hTargOrigin = hTarget.EyePosition()
	local flTime = Time()
	local flHoverOffset = sin(flTime * ENDO_HOVER_SPEED) * ENDO_HOVER_DISTANCE

	if (flTime >= ENDO_NEXT_RETARGET_TIME) {
		printl("retarget")
		ENDO_NEXT_RETARGET_TIME = RandomInt(6,12) + flTime
		hTarget = RandomCT()
		return -1
	}


	// if (ValidEntity(hTarget) && hTarget.GetOrigin().z < ENDO_BOUNDS_MIN.z) {
		// hTarget = RandomCT()
		// return -1
	// }

	if (Time() >= WaitEnd) {
		Waiting = false

	}

	if (Waiting) { // simple wait system for the boss fight
		return 0.1
	}

	if (flTime >= ENDO_NEXT_ATTACK_TIME) {
		RandomAttack()
	}


	if (ENDO_ORBIT) { // endo is orbitting around player
		vNextOrigin = vLerp(vOrigin, Vector(sin(flTime) * ENDO_ORBIT_RADIUS + hTargOrigin.x, cos(flTime) * ENDO_ORBIT_RADIUS + hTargOrigin.y, hTargOrigin.z + flHoverOffset), 0.05)
		TrackPosition(self, hTargOrigin + Vector(0,0, -200), 0.2)
		DoAnimation("fly1")
	}


	if (ENDO_BOMBING) {
		if (flTime >= ENDO_BOMBING_NEXT) {
			local vBombOrigin = ENDO_ORIGIN + Vector(RandomInt(-ENDO_BOMBING_RADIUS, ENDO_BOMBING_RADIUS), RandomInt(-ENDO_BOMBING_RADIUS, ENDO_BOMBING_RADIUS), ENDO_BOMBING_HEIGHT)

			vNextOrigin = vBombOrigin
			PrecacheModel("models/eltra/cic/endovus_laserbomb.mdl")
			local hBomb = Spawn("prop_dynamic", {
				model = "models/eltra/cic/endovus_laserbomb.mdl",
				modelscale = 0,
				vscripts = "eltrasnag/christiscoming/endovus_laserbomb.nut",
				origin = vBombOrigin + Vector(0, 0, 512)
			})



			ENDO_BOMBING_NEXT = ENDO_BOMBING_DELAY + flTime
			// SetAnimation(self, "bomb1")
			SetAnimation(hVisModel, "bomb1")
		}
	}

	if (ENDO_GRABBING) {
		local ply;
		ENDO_ORBIT = false

		while (ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, ENDO_GRABBING_RADIUS)) { // looking for grabbable player
			if (ply.GetTeam() == TEAMS.HUMANS)
				printl("caught you bitch")
				break;
		}

		if (ply) {
			vNextOrigin = vLerp(vOrigin, vOrigin + Vector(RandomInt(-200, 200), RandomInt(-200, 200), 100), 0.1) // caught player
			DoAnimation("carry1_b")
			TrackPosition(self, vWant, 0.04)
			ply.KeyValueFromVector("origin", vOrigin)
			ply.SnapEyeAngles(QuaternionSlerp(GetAngleTo(vOrigin, ply.EyePosition()).ToQuat(), ply.EyeAngles().ToQuat(), 0.1).ToQAngle())
		} else { // lunge
			DoAnimation("carry1")
			TrackPosition(self, hTargOrigin, 0.08)
			vNextOrigin = vLerp(vOrigin, vOrigin + vAngles.Forward() * ENDO_GRABBING_SPEED, 0.3)

		}
	}

	local vMoveWant = GetMovementVector(vWant, vOrigin) // movement vector to the vWant position

	if (NPC_MOVEMENT_OVERRIDE) {
		self.KeyValueFromVector("origin", vNextOrigin)
	}
	// return 0.01
}

function CustomWake() {
	// self.
}

function DoAnimation(anim = "ref", delay = 0) {
	if (CurrentAnimation != anim)
		SetAnimation(hVisModel, anim, delay, true)
		CurrentAnimation = anim
}

function RandomArenaPos() {
	return Vector(RandomInt(ENDO_BOUNDS_MIN.x, ENDO_BOUNDS_MAX.x), RandomInt(ENDO_BOUNDS_MIN.y, ENDO_BOUNDS_MAX.y), ENDO_BOUNDS_MIN.z)
}

function CustomSleep() { // this is boss!!! we cant be sleeping!!
	// if (In_Cutscene == false)
		// hTarget = RandomCT()
		// Wake()
}



SF_FOOTSTEP <- "eltra/72hr/footsteps/ENDOstep"
SF_FOOTSTEP_OFFSET <- Vector(0,0,-192)


// function Footstep() {
	// PlaySoundEX(SF_FOOTSTEP + RandomInt(1,4) + ".wav", self.GetOrigin() - SF_FOOTSTEP_OFFSET, 10, RandomInt(96,103))
// }

function AttackStop() {
	ENDO_ORBIT = false
	ENDO_GRABBING = false
	ENDO_BOMBING = false
	ENDO_DIVING = false

}

function RandomAttack() {
	AttackStop()

	switch (RandomInt(0,3)) {
		case 0:
			AttackStop()
			ENDO_ORBIT = true
		break;
		case 1:
			AttackStop()
			ENDO_GRABBING = true
		break;
		case 2:
			AttackStop()
			ENDO_BOMBING = true
		break;
		case 3:
			AttackStop()
			ENDO_DIVING = true
		break;
	}
	SpeakLine("random"+RandomInt(2,6))
	// NPC_MOVEMENT_OVERRIDE = false
	ENDO_NEXT_ATTACK_TIME = RandomInt(7,12) + Time()
}

function SpeakLine(line) {
	local pos = self.GetOrigin()
	PlaySoundEX("eltra/cic/endo_"+line+".mp3", self, 100, 100, null, 10000)
	// PlaySoundEX("eltra/cic/endo_"+line+".mp3", pos, 100, 100, null, 10000)
	// PlaySoundEX("eltra/cic/endo_"+line+".mp3", pos, 100, 100, null, 10000)
}

function CustomDamage(params) {
	SpeakLine("hurt0"+RandomInt(1,3))

	if (params.inflictor == hTarget) {
		iCurAccel *= 0.5
	}
}

function BossEnd() {
	AddThinkToEnt(self, "")
	// hBossBase.Kill()
	QFire("s3_mus_endovus_a", "StopSound", "3")
	// QFire("s3_mus_ENDOboss_b", "FadeOut", "3")
	RunScriptCode(self, "SpeakLine(`rip`)", 2)

}

function CustomDeath() {
	BossEnd()
}


