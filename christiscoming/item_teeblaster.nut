IncludeScript("eltrasnag/zombieescape/zeitem.nut", this)

// item config.
ItemName <- "The Tee-Blaster"
FollowMode <- ZITEM_FOLLOWMODES.MODERN
IdleScale <- 0.25
iDamageMin <- 40,
iDamageMax <- 70

iOffsetForward <- 0
iOffsetLeft <- 20
iOffsetUp <- 0

ShootParticle <- "cic_slowgun_shoot"
ShootSound <- "eltra/item_teeblaster_fire.mp3"
iMuzzleOffset <- 46 // forward offset for particle

iCooldownAdd <- 1


// wep config

iMuzzleOffset <- 46 // forward offset for particle
// active mode positioning

iMaxShootDistance <- 4000
iShootRadius <- 128

iDamageMin <- 50
iDamageMax <- 70

iKnockbackIntensity <- 1000


// function OnPostSpawn() {

	// local vOrigin = self.GetOrigin()
	// local vAngles = self.GetAbsAngles()


	// self.SetCollisionGroup(Constants.ECollisionGroup.COLLISION_GROUP_DEBRIS)
	// self.KeyValueFromString("targetname","item_teeblaster")
	// DropWeapon()
// }


function DroppedThink() {

	if (self.GetPhysVelocity().Length() < 10) {

		local vOrigin = self.GetOrigin()
		local traceparams = {
			start = vOrigin,
			end = vOrigin + Vector(0,0,-1000),
			pos = vOrigin // just incase
		}

		TraceLineEx(traceparams)

		vRootOrigin = traceparams.pos + Vector(0,0, 50)
		self.SetAngles(0,0,0)
		DisableMotion(self)
		AddThinkToEnt(self, "IdleThink")
		return
	}

	return 0.5
}



function ShotThink() { // the shoot animation.
	// local vAngles = self.GetAbsAngles()
	// self.SetLocalAngles(QuaternionSlerp(vAngles, QAngle(0,0,0), FrameTime() * 4).ToQuat())
	// if (vAngles.x < 1) {
		// self.SetLocalAngles(QAngle(0,0,0))
		// AddThinkToEnt(self,"ActiveThink")
	// }
	// ActiveThink()
	return -1
}

function FireWeapon() {
	flNextCooldownEnd = Time() + iCooldownAdd
	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()

	local vForward = vAngles.Forward()

	local vEyePos = hOwner.EyePosition()
	local vEyeAng = hOwner.EyeAngles()

	// AddThinkToEnt(self, "ShotThink")
	local sndpos = vEyePos + hOwner.GetForwardVector() * 20
	PlaySoundEX(ShootSound, sndpos, 100, RandomInt(70, 90))
	PlaySoundEX(ShootSound, sndpos, 100, RandomInt(70, 90))
	PlaySoundEX(ShootSound, sndpos, 100, RandomInt(70, 90))
	// PlaySoundEX(ShootSound,vOrigin)
	// PlaySoundEX(ShootSound,vOrigin)

	ScreenShake(vEyePos, RandomInt(30,60), 10, 1, 256, 0, true)

	local HitPos = QuickTrace(vEyePos + vEyeAng.Forward() * iMuzzleOffset, vEyePos + vEyeAng.Forward() * 4000, self).pos

	local HitDist = GetDistanceTo(vEyePos, HitPos)

	local pcf = DoEffect("cic_slowgun_hit", HitPos, 0.1, vEyeAng)

	// this should be moved to a different weapon.
	// for (local i = 0; i < HitDist; i+=iShootRadius) {
	// 	local scanpos = vEyePos + vForward*i
	// 	// printl("Scanning at position " + scanpos.tostring())
	// 	for (local ent; ent = Entities.FindInSphere(ent, scanpos, iShootRadius*1.5);) {
	// 		local eclass = ent.GetClassname()
	// 			if (eclass == "player" && ent.GetTeam() == TEAMS.ZOMBIES && (ent != hOwner)) {
	// 				// printl(hOwner)
	// 				// printl("\nFound player "+ent)
	// 				ent.TakeDamage(RandomInt(iDamageMin, iDamageMax), Constants.FDmgType.DMG_BLAST, hOwner)

	// 				local kbvec = ((vEyeAng.Forward() * iKnockbackIntensity) + ent.GetAbsVelocity())
	// 				kbvec.z = 500
	// 				ent.SetAbsVelocity(kbvec)
	// 				continue;
	// 			}

	// 			if (eclass in Shootables) {
	// 				ent.TakeDamage(RandomInt(iDamageMin, iDamageMax) * 3, Constants.FDmgType.DMG_SLOWBURN, hOwner)
	// 			}
	// 		}
	// }

	local boom = Spawn("env_physexplosion", {
		origin = HitPos,
		inner_radius = iShootRadius*0.3,
		radius = iShootRadius * 0.75,
		magnitude = 500,
		spawnflags = 3
	})
	for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", HitPos, iShootRadius);) {
		if (ply.GetTeam() == TEAMS.ZOMBIES) {
				ply.TakeDamage(RandomInt(iDamageMin, iDamageMax), Constants.FDmgType.DMG_BLAST, hOwner)
				DoKnockback(ply)
		}
	}

	if (!(hOwner.GetFlags() & FL_ONGROUND)) {
		hOwner.SetAbsVelocity(hOwner.GetAbsVelocity() + (vEyeAng.Forward() * -400))
	}
	QFireByHandle(boom, "Explode")
	QFireByHandle(boom, "Kill", "", 0.1)
	local pcf = DoEffect(ShootParticle, vOrigin + (vForward*iMuzzleOffset), 0.2, vEyeAng)
	SetParentEX(pcf,self)
	ScreenFade(hOwner, 0, 255, 150, 20, 0.2, 0.1, 1)
	self.SetLocalAngles(QAngle(-40, 0, 0) + self.GetLocalAngles())
	hOwner.ViewPunch(QAngle(-15,0,0))


}

vStupidOffset <- Vector(0,0,0.1)

