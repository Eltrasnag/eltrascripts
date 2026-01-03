IncludeScript("eltrasnag/zombieescape/zeitem.nut", this)

flNextCooldownEnd <- 0
iCooldownAdd <- 60

vNoAngle <- QAngle(0,90,0)
vRootOrigin <- self.GetOrigin()

iHealAmount <- 10
// interal stuff
NextPlayerScanTime <- 0
PlayerScanWait <- 0.5

flHealEndTime <- 0
strItemName <- "Temu Shitbox"
strModelName <- "models/eltra/propper/cic_itemtest/temu_heal.mdl"

// wep config
ShootParticle <- "healjar_1"
ShootSound <- "eltra/eat_hot_chip01.mp3"

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
iOffsetLeft <- -0
iOffsetUp <- 36

iMaxShootDistance <- 4000
iShootRadius <- 64

iDamageMin <- 50
iDamageMax <- 70

iKnockbackIntensity <- 1000



function OnPostSpawn() {

	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()

	if (self.GetClassname() != "prop_physics") {
		SpawnEntityFromTable("prop_physics", {
			origin = vOrigin,
			angles = vAngles,
			vscripts = NetProps.GetPropString(self, "m_iszVScripts"),
			spawnflags = 49152,
			solid = 6,
			model = strModelName
		})
		self.Destroy()
		return
	}

	self.SetCollisionGroup(Constants.ECollisionGroup.COLLISION_GROUP_DEBRIS)
	self.KeyValueFromString("targetname","item_temuheal")
	DropWeapon()
}


// function DroppedThink() {

// 	if (self.GetPhysVelocity().Length() < 10) {

// 		local vOrigin = self.GetOrigin()
// 		local traceparams = {
// 			start = vOrigin,
// 			end = vOrigin + Vector(0,0,-1000),
// 			pos = vOrigin // just incase
// 		}

// 		TraceLineEx(traceparams)

// 		vRootOrigin = traceparams.pos + Vector(0,0, 50)
// 		self.SetAngles(0,0,0) // iidc if this is obsolete its the only one which works
// 		DisableMotion(self)
// 		AddThinkToEnt(self, "IdleThink")
// 		return
// 	}

// 	return 0.5
// }

// function IdleThink() {
// 	local vOrigin = self.GetOrigin()
// 	local vAngles = self.GetAbsAngles()
// 	local time = Time()

// 	local vFloatOrigin = vRootOrigin

// 	vOrigin.z = vRootOrigin.z + sin(time* iIdleSpeed) * iFloatDist

// 	self.KeyValueFromVector("origin", vOrigin)

// 	vAngles.y += iIdleRot
// 	self.SetAbsAngles(vAngles)

// 	if (time > NextPlayerScanTime) {
// 		NextPlayerScanTime = time + PlayerScanWait

// 		for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, iPickupScanRadius);) {
// 			printl("play")
// 			printl(NetProps.GetPropInt(ply,"m_nButtons"))
// 			if (ply.GetTeam() == TEAMS.HUMANS && ply.IsUsingActionSlot()) {

// 				ply.ValidateScriptScope()
// 				local plyscope = ply.GetScriptScope()

// 				if (!"SeenItemTut" in plyscope || DEV == true) {
// 					printl("firsttime")
// 					ClientPrint(ply, Constants.EHudNotify.HUD_PRINTCENTER, "|| To use this item, press the >ACTION SLOT< key. To drop this item, duck, then press the >RIGHT MOUSE BUTTON< ||")

// 					plyscope.SeenItemTut <- true
// 				}
// 				printl("grab that shit NOW")
// 				PickupWeapon(ply)
// 				return
// 			}
// 		}
// 	}


// 	return 0.025
// }

// function ActiveThink() {
// 	if (hOwner == null || !ValidEntity(hOwner) || hOwner.GetTeam() != TEAMS.HUMANS || !hOwner.IsAlive()) {
// 		DropWeapon()
// 		return
// 	}

// 	self.SetDrawEnabled(true)

// 	local vOrigin = self.GetOrigin()
// 	local vAngles = self.GetAbsAngles()

// 	local time = Time()

// 	local vPlayerOrigin = hOwner.GetOrigin()
// 	local vPlayerAngles = hOwner.GetAbsAngles()

// 	local vEyePos = hOwner.EyePosition()
// 	local vEyeAng = hOwner.EyeAngles()

// 	local dummyangle = vPlayerAngles

// 	dummyangle.x = 0
// 	local vActiveOrigin = vPlayerOrigin + (vPlayerAngles.Forward() * iOffsetForward) + (vPlayerAngles.Left() * iOffsetLeft)
// 	hDummyParent.KeyValueFromVector("origin", vActiveOrigin)

// 	self.SetAbsAngles(vPlayerAngles + QAngle(0,90,0))
// 	hDummyParent.SetAbsAngles(dummyangle)


// 	if (time <= flHealEndTime) {
// 		for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, 512);) {
// 			if (ply.IsAlive() && ply.GetTeam() == TEAMS.HUMANS) {
// 				ply.SetHealth(ply.GetHealth() + iHealAmount)
// 				ScreenFade(ply, 97, 255, 255, 100, 0.5, 0.1, FADE_IN)
// 			}
// 		}
// 		ScreenShake(vEyePos, RandomInt(3,4), 0.05, 3, 512, 0, true)

// 		return 0.5
// 	}



// 	return -1
// }

// function DropWeapon() {
// 	// self.SetO
// 	self.SetModelScale(0.5, 0.0)
// 	ClearParent(self)

// 	if (ValidEntity(hOwner)) {
// 		SetItemUser(hOwner, false)
// 		hOwner = null
// 	}

// 	if (ValidEntity(hDummyParent)) {
// 		self.SetOrigin(hDummyParent.GetOrigin()+vDropOffset)
// 		hDummyParent.Destroy()
// 	}
// 	EnableMotion(self)
// 	AddThinkToEnt(self, "DroppedThink")
// }


function FireWeapon() {
	local vOrigin = self.GetOrigin()
	for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, 512);) {
		if (ply.IsAlive() && ply.GetTeam() == TEAMS.HUMANS) {
			// ply.SetHealth(ply.GetHealth() + iHealAmount)
			ScreenFade(ply, 97, 255, 255, 100, 0.5, 0.1, FADE_IN)
			local qfire_delay = 0
			// for (local i = 0; i < 50; i++) {
			// 	QFireByHandle(ply, "RunScriptCode", "self.SetHealth(self.GetHealth() + 1)", qfire_delay)
			// 	qfire_delay += 0.1
			// }
		}
	}
	ScreenShake(vOrigin, RandomInt(3,4), 0.05, 3, 512, 0, true)

}

// function FireWeapon() {
// 	flNextCooldownEnd = Time() + iCooldownAdd
// 	flHealEndTime = Time() + 5

// 	self.SetModelScale(0.1, 0)
// 	self.SetModelScale(1, iCooldownAdd)

// 	local vOrigin = self.GetOrigin()
// 	local vAngles = self.GetAbsAngles()

// 	local vForward = vAngles.Forward()

// 	local vEyePos = hOwner.EyePosition()
// 	local vEyeAng = hOwner.EyeAngles()

// 	PlaySoundEX(ShootSound,vOrigin)
// 	PlaySoundEX(ShootSound,vOrigin)
// 	PlaySoundEX(ShootSound,vOrigin)


// 	// local HitPos = QuickTrace(vEyePos + vEyeAng.Forward() * iMuzzleOffset, vEyePos + vEyeAng.Forward() * 4000, self).pos

// 	// local HitDist = GetDistanceTo(vEyePos, HitPos)

// 	// local pcf = DoEffect("cic_slowgun_hit", HitPos)

// 			// if (DEV) {
// 				// DebugDrawCircle(scanpos,Vector(0,255,0),255,iShootRadius, false, 0.5)
// //
// 			// }


// 	local pcf = DoEffect(ShootParticle, vOrigin + (vForward*iMuzzleOffset), 5)
// 	SetParentEX(pcf,self)

// }

vStupidOffset <- Vector(0,0,0.1)

function DoKnockback(player) {
	local kill = self.GetForwardVector()*iKnockbackIntensity
	printl("stupid velocity : " + kill.tostring())
	player.SetAbsVelocity(kill)
	player.SetAbsOrigin(player.GetOrigin()+vStupidOffset)

}

// function PickupWeapon(player) {
// 	if (CheckItemHolder(player)) {
// 		ClientPrint(player, Constants.EHudNotify.HUD_PRINTCENTER, "| You're already holding an item. |")
// 		return
// 	}
// 	GrabWeaponSound(player)
// 	self.SetModelScale(1,0)

// 	MakeDummyParent()
// 	DisableMotion(self)

// 	// if (ValidEntity(hOwner)) {
// 	SetItemUser(player, true)
// 		// hOwner = null
// 	// }

// 	// self.SetModelScale(1.0, 0.0)

// 	local vPlayerOrigin = player.GetOrigin()
// 	local vPlayerAngles = player.GetAbsAngles()

// 	local targpos = vPlayerOrigin + (vPlayerAngles.Forward() * iOffsetForward) + (vPlayerAngles.Left() * iOffsetLeft)

// 	self.SetOrigin(hDummyParent.GetOrigin())


// 	hDummyParent.SetAbsOrigin(vPlayerOrigin)
// 	hDummyParent.SetAbsAngles(vPlayerAngles)

// 	SetParentEX(self,hDummyParent)
// 	SetParentEX(hDummyParent, player)
// 	NetProps.SetPropInt(hDummyParent, "m_fEffects", Constants.FEntityEffects.EF_BONEMERGE + Constants.FEntityEffects.EF_BONEMERGE_FASTCULL)

// 	self.SetOrigin(targpos)

// 	hOwner = player
// 	AddThinkToEnt(self, "ActiveThink")
// }