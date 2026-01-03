IncludeScript("eltrasnag/zombieescape/zeitem.nut", this)


FullFocus <- true

ItemName <- "The Physics Gun"
AllowedCarryables <- ["prop_physics", "prop_physics_multiplayer", "prop_physics_override", "func_physbox", "prop_ragdoll", "player"]

MaximumMass <- 1000

AttackKey <- ZITEM_ATTACKKEYS.LMB
// CarryFailTime <-
iOffsetForward <- 10
iOffsetLeft <- 10
iOffsetUp <- 10
IdleScale <- 1
FXCore <- Spawn("info_particle_system", {
	effect_name = "cic_physgun_core",
	start_active = true,
})


FXBeamTargetName <- UniqueString("_physgunbeamfx")
beamparticlename <- "cic_physgun_beam"
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

using_sound <- "weapons/physcannon/superphys_hold_loop.wav"
shoot_sound <- "weapons/physcannon/superphys_launch1.wav"

hSoundPlayer <- Spawn("ambient_generic", {
	spawnflags = 16,
	message = using_sound,
	health = 1,
	radius = 256,
	origin = self.GetOrigin(),
	sourceentityname = self.GetName()
})

iMuzzleAttachID <- self.LookupAttachment("core")

GrabDistance <- 0
hTarget <- null
iCooldownAdd <- 4
Convars.SetValue("sv_turbophysics", 0)
FollowMode <- ZITEM_FOLLOWMODES.MODERN

// function OnPostSpawn() {
// 	printl("who will run first?!?!?!? find out...")
// 	SetParentEX(FXBeam, self, "core")
// }
// hTargetGlow <- Spawn // tf glow doesnt work the way i thought it did :/
function CarryThink() {
	ActiveThink() // do the regular think stuff before our custom routine

	if (hTarget == null || !ValidEntity(hTarget) || !ValidEntity(hOwner) || !hOwner.IsAlive()) {
		FXBeam.AcceptInput("Stop", "", null, null)
		hTarget = null

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
	local tracedist = GetDistance(trace.startpos, trace.pos)
	if (tracedist > GrabDistance && trace.enthit == Entities.First()) {
		nextvec = trace.pos
		GrabDistance = tracedist
	} else {

	}

	local lerpvec = nextvec - vCarriedPos
	// local lerpvec = vLerp(vCarriedPos, nextvec, 0.5)
	local vdiff = (nextvec - vCarriedPos) * 10
	printl(vdiff)
	CleanString(vdiff.tostring())

	hTarget.SetAbsVelocity(vdiff)
	hTarget.SetPhysVelocity(vdiff)

	// the phygun beam effect.

	FXBeamTarget.SetAbsOrigin(vCarriedPos)
	FXBeam.AcceptInput("Start", "", null, null)
	// QFireByHandle(FXBeam, "Stop", "", 0.1)
	// if (hTarget == null || !ValidEntity(hTarget) || (!ButtonPressed(hOwner, IN_ATTACK2))) {
	if (hTarget == null || !ValidEntity(hTarget)) {
		hTarget = null

		AddThinkToEnt(self, "ActiveThink")
		return -1
	}



	return -1
}

muzzleattachname <- "core"


function FireWeapon() {

	if (Time() < flNextCooldownEnd) { // hack
		return
	}

	flNextCooldownEnd = Time() + 0.5


	local vMuzzleOrigin = self.GetAttachmentOrigin(iMuzzleAttachID)

	local vEyePos = hOwner.EyePosition()
	local vEyeAng = hOwner.EyeAngles()
	local vAngles = self.GetAbsAngles()
	local EyeTrace = QuickTrace(vEyePos, vEyePos + vEyeAng.Forward() * iMaxShootDistance, hOwner, -1)


	// local selfname = UniqueString("_physgun")
	// self.KeyValueFromString("targetname", selfname)




	// local context = GetContext(enthit)
	// if ("boss")

	// if (EyeTrace.enthit.GetName().len() == 0) {

	// }
		PlaySoundEX(shoot_sound, vMuzzleOrigin, 2, RandomInt(95,120))

	if (hTarget == null) { // grab on


		FXBeamTarget.SetAbsOrigin(EyeTrace.pos)
		FXBeam.AcceptInput("Start", "", null, null)
		QFireByHandle(FXBeam, "Stop", "", 0.1)
		// DebugDrawLine_vCol(EyeTrace.startpos, EyeTrace.pos, Vector(255, 255, 255), false, 0.2)
		if ((!EyeTrace.enthit || EyeTrace.enthit == Entities.First()) && hTarget == null) {
			return
		}

		FXBeam.AcceptInput("Start", "", null,null)

		QFireByHandle(FXBeam, "Stop", "", 0.1)
		CleanString("cic_physgun_beam")

		GrabDistance = GetDistance(vEyePos, EyeTrace.pos)

		QEmitSound( "ambient/machines/portalgun_rotate_loop1.wav", self)

		local ent = EyeTrace.enthit

		printl("physgun: found something")


		hSoundPlayer.KeyValueFromString("message", using_sound)

		PrecacheSound(using_sound)
		QFireByHandle(hSoundPlayer, "PlaySound")


		local cname = ent.GetClassname()
		// printl("hit ent: "+cname)
		if ((ent.GetName().len() != 0) || (!cname in AllowedCarryables) || NetProps.GetPropFloat(ent, "m_fMass") >= MaximumMass) {
			return
		}
		QFireByHandle(FXBeam, "Start")
		EnableMotion(ent)

		// FXBeam.SetAbsOrigin(EyeTrace.pos)
		// SetParentEX(FXBeam, ent)
		// printl("grab on")
		hTarget = EyeTrace.enthit

		AddThinkToEnt(self, "CarryThink")
	} else if (hTarget != null) { // grab off
		// FXBeam.SetAbsOrigin(EyeTrace.pos)
		// SetParentEX(FXBeam, ent)
		QFireByHandle(hSoundPlayer, "StopSound")
		// printl("grab off")
		QFireByHandle(FXBeam, "Stop", "", 0.0)

		QFireByHandle(self, "addoutput","rendermode 3", 0.0)
		QFireByHandle(self, "addoutput", "renderamt 150", 0.0)
		// QFireByHandle(self, "rendermode", "0", 5.0)
		// QFireByHandle(self, "color", "255 255 255", 5.0)

		AddThinkToEnt(self, "ActiveThink")


		if (ButtonPressed(hOwner, IN_ATTACK2)) {
			DisableMotion(hTarget)
			QFireByHandle(hTarget, "enablemotion", "", 4)
			flNextCooldownEnd = Time() + iCooldownAdd
		} else {
			flNextCooldownEnd = Time() + 0.25
		}
		hTarget = null

		QFireByHandle(self, "addoutput", "rendermode 0", flNextCooldownEnd - Time())
		// QFireByHandle(FXCore, "StartS")
		// QFireByHandle(FXCore, "Start", "", 5)
		return

	}
}

function Init() {
	SetParentEX(FXBeam, self, "core")
	SetParentEX(FXCore, self, "core")
}

function CustomPickup(player) {
	// DisablePlayerWeapons(player)
}

function CustomDrop() {

}

function CustomThink() {
	if (ButtonPressed(hOwner, IN_ATTACK2)) {
		FireWeapon()
	}
}