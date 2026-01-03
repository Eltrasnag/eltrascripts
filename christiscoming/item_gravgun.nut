IncludeScript("eltrasnag/zombieescape/zeitem.nut", this)


FullFocus <- true
ItemName <- "The Gravity Gun"
AllowedCarryables <- ["prop_physics", "prop_physics_multiplayer", "prop_physics_override", "func_physbox", "prop_ragdoll"]
// CarryFailTime <-
iCarryTime <- 0
iOffsetForward <- 10
iOffsetLeft <- 10
iOffsetUp <- 13
IdleScale <- 1
iCooldownAdd <- 0.4
PuntForce <- 3000
iMaxShootDistance <- 512
FXCore <- Spawn("info_particle_system", {
	effect_name = "cic_gravgun_core",
	start_active = true,
})

MaximumMass <- 1000
FXBeamTargetName <- UniqueString("_gravgunbeamfx")
beamparticlename <- "cic_gravgun_beam"
FXBeamTarget <- Spawn("info_particle_system", {
		targetname = FXBeamTargetName,
		origin = Vector(0,0,0)
})

FXBeam <- Spawn("info_particle_system", {
		effect_name = beamparticlename,
		start_active = false,
		cpoint2 = FXBeamTargetName,
		// cpoint1 = self.GetName(),
		// origin = self.GetOrigin() - globalviewoffset()
		// origin = self.GetOrigin()
})

using_sound <- "weapons/physcannon/hold_loop.wav"
shoot_sound <- "weapons/physcannon/superphys_launch3.wav"
shoot_sound_powerful <- "weapons/physcannon/superphys_launch4.wav"

hSoundPlayer <- Spawn("ambient_generic", {
	spawnflags = 16,
	message = using_sound,
	health = 1,
	radius = 256,
	origin = self.GetOrigin(),
	sourceentityname = self.GetName()
})

iMuzzleAttachID <- self.LookupAttachment("core")

GrabDistance <- 96
hTarget <- null
Convars.SetValue("sv_turbophysics", 0)
FollowMode <- ZITEM_FOLLOWMODES.MODERN

// function OnPostSpawn() {
// 	printl("who will run first?!?!?!? find out...")
// 	SetParentEX(FXBeam, self, "core")
// }
// hTargetGlow <- Spawn // tf glow doesnt work the way i thought it did :/
function CarryThink() {
	ActiveThink() // do the regular think stuff before our custom routine

	if (hTarget == null || !ValidEntity(hTarget) || !ValidEntity(hOwner) || !hOwner.IsAlive() || (hTarget.IsPlayer() && !hTarget.IsAlive())) {
		FXBeam.AcceptInput("Stop", "", null, null)
		if (hTarget != null) {
			if (hTarget.IsPlayer()) {

			} else {

				hTarget.SetCollisionGroup(Constants.ECollisionGroup.COLLISION_GROUP_INTERACTIVE)
			}

		}
		hTarget = null

		if (ValidEntity(hOwner) && hOwner.IsAlive()) {
			EnablePlayerWeapons(hOwner)
		}
		AddThinkToEnt(self, "ActiveThink")
		return -1
	}


	local vMuzzleOrigin = self.GetAttachmentOrigin(iMuzzleAttachID)



	// let's get to work.

	local vCarriedPos = hTarget.GetOrigin()
	local vOrigin = self.GetOrigin()
	local vEyePos = hOwner.EyePosition()
	local vEyeAng = hOwner.EyeAngles()

	local trace = QuickTrace(vEyePos, vEyePos + vEyeAng.Forward() * iMaxShootDistance, self)

	local nextvec = vEyePos + vEyeAng.Forward() * GrabDistance
	// local tracedist = GetDistance(trace.startpos, trace.pos)
	// if (tracedist > GrabDistance && trace.enthit == Entities.First()) {
		// nextvec = trace.pos
		// GrabDistance = tracedist
	// } else {

	// }
	local lerpvec = nextvec - vCarriedPos
	// local lerpvec = vLerp(vCarriedPos, nextvec, 0.5)
	local vdiff = (nextvec - vCarriedPos)
	// printl(vdiff)
	// CleanString(vdiff.tostring())
	hTarget.SetForwardVector(vEyeAng.Forward() * -1)



	hTarget.SetAbsVelocity(vdiff)
	hTarget.SetPhysVelocity(vdiff * 60)

	FXBeam.AcceptInput("Start", "", null,null)

	// the phygun beam effect.

	FXBeamTarget.SetAbsOrigin(vCarriedPos)
	// QFireByHandle(FXBeam, "Stop", "", 0.1)
	// if (hTarget == null || !ValidEntity(hTarget) || (!ButtonPressed(hOwner, IN_ATTACK2))) {
	if (hTarget == null || !ValidEntity(hTarget)) {
		hTarget = null
		if (ValidEntity(hOwner) && hOwner.IsAlive()) {
			EnablePlayerWeapons(hOwner)
		}
		AddThinkToEnt(self, "ActiveThink")
		return -1
	}

	if (ButtonPressed(hOwner, IN_ATTACK)) {
		FireWeapon()
	}

	if (iCarryTime >= 5 && hTarget.IsPlayer()) {
		FireWeapon()
	}

	iCarryTime += FrameTime()

	return -1
}

muzzleattachname <- "core"


function FireWeapon() {
	iCarryTime = 0

	local punchang = QAngle(-8,0,0)
	hOwner.ViewPunch(punchang)
	self.SetLocalAngles(punchang)

	flNextCooldownEnd = Time() + 0.5


	local vMuzzleOrigin = self.GetAttachmentOrigin(iMuzzleAttachID)

	local vEyePos = hOwner.EyePosition()
	local vEyeAng = hOwner.EyeAngles()
	local vAngles = self.GetAbsAngles()
	local EyeTrace = QuickTrace(vEyePos, vEyePos + vEyeAng.Forward() * iMaxShootDistance, hOwner, -1)


	// local selfname = UniqueString("_gravgun")
	// self.KeyValueFromString("targetname", selfname)




	// local context = GetContext(enthit)
	// if ("boss")

	// if (EyeTrace.enthit.GetName().len() == 0) {


	// }

	if (ButtonPressed(hOwner, IN_ATTACK)) { // punting behaviour

		ScreenFade(hOwner, 255, 255, 255, 30, 0.4, 0.1, 1)
		local bounce = hOwner.GetAbsVelocity() + vEyeAng.Forward() * -RandomInt(350, 600)
		hOwner.SetAbsVelocity(bounce)
		if (hTarget != null && hTarget.IsPlayer()) {

			hTarget.SetAbsVelocity(bounce * -1)
			hTarget.SnapEyeAngles(vEyeAng * -1)
		} else if (hTarget != null)  {
			hTarget.SetPhysVelocity(vEyeAng.Forward() * PuntForce)
		}
		FXBeam.AcceptInput("Start", "", null, null)

		QFireByHandle(FXBeam, "Stop", "", 0.1)

		ScreenShake(vEyePos, 10, 0.1, 1, 256, SHAKE_START, true)

		hOwner.ViewPunch(QAngle(20,0,0))

		flNextCooldownEnd = Time() + 1.25

		PlaySoundEX(shoot_sound_powerful, vMuzzleOrigin, 10, RandomInt(80,99))
	} else {
		PlaySoundEX(shoot_sound, vMuzzleOrigin, 3, RandomInt(105,120))

	}

	if (hTarget == null) { // grab on


		FXBeamTarget.SetAbsOrigin(EyeTrace.pos)
		FXBeam.AcceptInput("Start", "", null, null)

		QFireByHandle(FXBeam, "Stop", "", 0.1)
		// DebugDrawLine_vCol(EyeTrace.startpos, EyeTrace.pos, Vector(255, 255, 255), false, 0.2)
		if ((!EyeTrace.enthit || EyeTrace.enthit == Entities.First()) && hTarget == null) {
			return
		}


		QFireByHandle(FXBeam, "Stop", "", 0.1)
		CleanString("cic_gravgun_beam")

		// GrabDistance = GetDistance(vEyePos, EyeTrace.pos)

		QEmitSound( "ambient/machines/portalgun_rotate_loop1.wav", self)

		local ent = EyeTrace.enthit

		printl("gravgun: found something")


		hSoundPlayer.KeyValueFromString("message", using_sound)

		PrecacheSound(using_sound)
		QFireByHandle(hSoundPlayer, "PlaySound")


		local cname = ent.GetClassname()
		// printl("hit ent: "+cname)
		if ((ent.GetName().len() != 0) || !(cname in AllowedCarryables) || NetProps.GetPropFloat(ent, "m_fMass") >= MaximumMass) {
			return
		}
		ent.SetCollisionGroup(Constants.ECollisionGroup.COLLISION_GROUP_INTERACTIVE_DEBRIS)

		QFireByHandle(FXBeam, "Start")
		EnableMotion(ent)

		// FXBeam.SetAbsOrigin(EyeTrace.pos)
		// SetParentEX(FXBeam, ent)
		// printl("grab on")
		hTarget = EyeTrace.enthit
		// DisablePlayerWeapons(hOwner)
		AddThinkToEnt(self, "CarryThink")
	} else if (hTarget != null) { // grab off
		EnablePlayerWeapons(hOwner)
		// FXBeam.SetAbsOrigin(EyeTrace.pos)
		// SetParentEX(FXBeam, ent)
		hTarget.SetCollisionGroup(Constants.ECollisionGroup.COLLISION_GROUP_INTERACTIVE)
		QFireByHandle(hSoundPlayer, "StopSound")
		// printl("grab off")
		QFireByHandle(FXBeam, "Stop", "", 0.0)

		QFireByHandle(self, "addoutput","rendermode 3", 0.0)
		QFireByHandle(self, "addoutput", "renderamt 150", 0.0)
		// QFireByHandle(self, "rendermode", "0", 5.0)
		QFireByHandle(self, "addoutput","rendermode 0", iCooldownAdd)
		// QFireByHandle(self, "color", "255 255 255", 5.0)

		AddThinkToEnt(self, "ActiveThink")
		flNextCooldownEnd = Time() + iCooldownAdd

		if (ButtonPressed(hOwner, IN_ATTACK)) { // punting behaviour
			hTarget.SetPhysVelocity(vEyeAng.Forward() * PuntForce)
			FXBeam.AcceptInput("Start", "", null, null)
			QFireByHandle(FXBeam, "Stop", "", 0.1)
		}
		hTarget = null

		// QFireByHandle(FXCore, "StartS")
		// QFireByHandle(FXCore, "Start", "", 5)
		return

	}
}

function Init() {
	SetParentEX(FXBeam, self, "core")
	SetParentEX(FXCore, self, "core")
}