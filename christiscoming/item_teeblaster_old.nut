
hOwner <- null
flNextCooldownEnd <- 0
iCooldownAdd <- 1

vNoAngle <- QAngle(0,90,0)
vRootOrigin <- self.GetOrigin()

// interal stuff
NextPlayerScanTime <- 0
PlayerScanWait <- 0.5


// wep config
ShootParticle <- "cic_slowgun_shoot"
ShootSound <- "eltra/item_teeblaster_fire.mp3"

// VARS FOR WHEN WE ARE IN "IDLE" MODE

iFloatDist <- 6 // ground travelled while floating in idle
iIdleRot <- 2 // bob rotate speed
iIdleSpeed <- 2 // bob up speed

// radius to check for +use-ing players
iPickupScanRadius <- 128



iMuzzleOffset <- 46 // forward offset for particle

vDropOffset <- Vector(0,0,100)


// active mode positioning
iOffsetForward <- 64 // yeah
iOffsetLeft <- -32
iOffsetUp <- 36

iMaxShootDistance <- 4000
iShootRadius <- 64

iDamageMin <- 50
iDamageMax <- 70

iKnockbackIntensity <- 1000

hDummyParent <- null

function MakeDummyParent() {
	ClearParent(self)
	if (ValidEntity(hDummyParent)) {
		hDummyParent.Destroy()

	}

	hDummyParent = Spawn("prop_dynamic_ornament", {
		origin = self.GetOrigin(),
		model = "models/error.mdl",
		rendermode = 10,
		disableshadows = 1,
		angles = self.GetAbsAngles(),
	})
	NetProps.SetPropInt(hDummyParent, "m_fEffects", Constants.FEntityEffects.EF_NOSHADOW)
	// hDummyParent.DisableDraw()
}
function OnPostSpawn() {

	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()


	self.SetCollisionGroup(Constants.ECollisionGroup.COLLISION_GROUP_DEBRIS)
	self.KeyValueFromString("targetname","item_teeblaster")
	DropWeapon()
}


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

function IdleThink() {
	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()
	local time = Time()

	local vFloatOrigin = vRootOrigin

	vOrigin.z = vRootOrigin.z + sin(time* iIdleSpeed) * iFloatDist

	self.KeyValueFromVector("origin", vOrigin)

	vAngles.y += iIdleRot
	self.SetAbsAngles(vAngles)

	if (time > NextPlayerScanTime) {
		NextPlayerScanTime = time + PlayerScanWait

		for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, iPickupScanRadius);) {
			printl(NetProps.GetPropInt(ply,"m_nButtons"))
			if (ply.GetTeam() == TEAMS.HUMANS && ButtonPressed(ply, IN_ATTACK2)) {
				ply.ValidateScriptScope()
				local plyscope = ply.GetScriptScope()

				if (!"SeenItemTut" in plyscope || DEV == true) {
					printl("firsttime")
					ClientPrint(ply, Constants.EHudNotify.HUD_PRINTCENTER, "|| To use this item, press the >SCROLL WHEEL<. To drop this item, crouch, and then press jump ||")
					plyscope.SeenItemTut <- true
				}
				printl("grab that shit NOW")
				PickupWeapon(ply)
				return
			}
		}
	}


	return 0.025
}

function ActiveThink() {
	if (hOwner == null || !ValidEntity(hOwner) || hOwner.GetTeam() != TEAMS.HUMANS || !hOwner.IsAlive()) {
		DropWeapon()
		return
	}

	self.SetDrawEnabled(true)

	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()

	local time = Time()

	local vPlayerOrigin = hOwner.GetOrigin()
	local vPlayerAngles = hOwner.GetAbsAngles()

	local vEyePos = hOwner.EyePosition()
	local vEyeAng = hOwner.EyeAngles()

	local dummyangle = vPlayerAngles

	dummyangle.x = 0
	local vActiveOrigin = vPlayerOrigin + (vPlayerAngles.Forward() * iOffsetForward) + (vPlayerAngles.Left() * iOffsetLeft)
	hDummyParent.KeyValueFromVector("origin", vActiveOrigin)

	self.SetAbsAngles(vEyeAng)
	hDummyParent.SetAbsAngles(dummyangle)





	local iPlayerFlags = hOwner.GetFlags()

	// player input stuff

	if (flNextCooldownEnd <= time && ButtonPressed(hOwner, IN_USE) ) {
		FireWeapon()
		printl("fire")
	}

	if (ButtonPressed(hOwner, IN_DUCK) && ButtonPressed(hOwner, IN_JUMP) && (iPlayerFlags & FL_ONGROUND)) {
		printl("Drop item now")
		DropWeapon()
		return
	}



	return -1
}

function DropWeapon() {
	// self.SetO
	self.SetModelScale(0.5, 0.0)
	ClearParent(self)

	if (ValidEntity(hOwner)) {
		SetItemUser(hOwner, false)
		hOwner = null
	}

	if (ValidEntity(hDummyParent)) {
		self.SetOrigin(hDummyParent.GetOrigin()+vDropOffset)
		hDummyParent.Destroy()
	}
	EnableMotion(self)
	AddThinkToEnt(self, "DroppedThink")
}

function FireWeapon() {
	flNextCooldownEnd = Time() + iCooldownAdd

	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()

	local vForward = vAngles.Forward()

	local vEyePos = hOwner.EyePosition()
	local vEyeAng = hOwner.EyeAngles()

	PlaySoundEX(ShootSound,vOrigin)
	PlaySoundEX(ShootSound,vOrigin)
	PlaySoundEX(ShootSound,vOrigin)

	ScreenShake(vEyePos, RandomInt(3,4), 0.1, 1, 128, 0, true)

	local HitPos = QuickTrace(vEyePos + vEyeAng.Forward() * iMuzzleOffset, vEyePos + vEyeAng.Forward() * 4000, self).pos

	local HitDist = GetDistanceTo(vEyePos, HitPos)

	local pcf = DoEffect("cic_slowgun_hit", HitPos)

	for (local i = 0; i < HitDist; i+=iShootRadius) {
		local scanpos = vEyePos + vForward*i
		printl("Scanning at position " + scanpos.tostring())
		for (local ent; ent = Entities.FindInSphere(ent, scanpos, iShootRadius*1.5);) {
			local eclass = ent.GetClassname()
				if (eclass == "player" && ent != hOwner) {
					printl(hOwner)
					printl("\nFound player "+ent)
					ent.TakeDamage(RandomInt(iDamageMin, iDamageMax), Constants.FDmgType.DMG_BLAST, hOwner)

					local kbvec = ((vEyeAng.Forward() * iKnockbackIntensity) + ent.GetAbsVelocity())
					kbvec.z = 500
					ent.SetAbsVelocity(kbvec)
					continue;
				}

				if (eclass in VALID_BREAKABLES) {
					ent.TakeDamage(RandomInt(iDamageMin, iDamageMax) * 3, Constants.FDmgType.DMG_SLOWBURN, hOwner)
				}
			}
			// if (DEV) {
				// DebugDrawCircle(scanpos,Vector(0,255,0),255,iShootRadius, false, 0.5)
//
			// }
	}


	local pcf = DoEffect(ShootParticle, vOrigin + (vForward*iMuzzleOffset), 0.2, vAngles)
	SetParentEX(pcf,self)

}

vStupidOffset <- Vector(0,0,0.1)

function DoKnockback(player) {
	local kill = self.GetForwardVector()*iKnockbackIntensity
	printl("stupid velocity : " + kill.tostring())
	player.SetAbsVelocity(kill)
	player.SetAbsOrigin(player.GetOrigin()+vStupidOffset)

}

function PickupWeapon(player) {
	if (CheckItemHolder(player)) {
		ClientPrint(player, Constants.EHudNotify.HUD_PRINTCENTER, "| You're already holding an item. |")
		return
	}
	GrabWeaponSound(player)
	MakeDummyParent()
	SetItemUser(player, true)
	DisableMotion(self)
	self.SetModelScale(1.0, 0.0)

	local vPlayerOrigin = player.GetOrigin()
	local vPlayerAngles = player.EyeAngles()

	local targpos = vPlayerOrigin + (vPlayerAngles.Forward() * iOffsetForward) + (vPlayerAngles.Left() * iOffsetLeft)

	self.SetOrigin(hDummyParent.GetOrigin())


	hDummyParent.SetAbsOrigin(vPlayerOrigin)
	hDummyParent.SetAbsAngles(vPlayerAngles)

	SetParentEX(self,hDummyParent)
	SetParentEX(hDummyParent, player)
	NetProps.SetPropInt(hDummyParent, "m_fEffects", Constants.FEntityEffects.EF_BONEMERGE + Constants.FEntityEffects.EF_BONEMERGE_FASTCULL)

	self.SetOrigin(targpos)

	hOwner = player
	AddThinkToEnt(self, "ActiveThink")
}