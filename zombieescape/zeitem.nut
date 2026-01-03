// IncludeScript("eltrasnag/common.nut)

ItemName <- "NoItemName"

Disabled <- false

enum ZITEM_FOLLOWMODES{CLASSIC, MODERN, SKIAL, FLAG}

FollowMode <- ZITEM_FOLLOWMODES.MODERN


FullFocus <- false // enable to make player only able to use the gun
ItemTeam <- TEAMS.HUMANS // set this to red to make it a zombie item
ItemGrabString <- "" // string which appears when you grab the item (only on the second time & beyond)
IdleScale <- 0.5 // item size when floating
FlagScale <- 0.75 // item size when on the player's back
ItemThrowForce <- 400
ItemFloatHeight <- 20
hOwner <- null
flNextCooldownEnd <- 0
iCooldownAdd <- 1
vNoAngle <- QAngle(0,90,0)
vRootOrigin <- self.GetOrigin()

enum ZITEM_ATTACKKEYS{LMB = 1, RMB = 2048, DUAL = 2049}
AttackKey <- ZITEM_ATTACKKEYS.RMB

Shootables <- ["base_boss", "player"] // entities which we can shoot, to kill

// classic = css imitation,
// teefloat = teeblaster's behaviour,
// skial = skial ze plugin item behaviour,
// CARRY : attach the item to the playermodel's left hand




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
iPickupScanRadius <- 64



iMuzzleOffset <- 46 // forward offset for particle

vDropOffset <- Vector(0,0,100)


// active mode positioning
iOffsetForward <- 0 // yeah
iOffsetLeft <- 0
iOffsetUp <- 0

iMaxShootDistance <- 4000
iShootRadius <- 64

iDamageMin <- 50
iDamageMax <- 70
iRotRandom <- RandomInt(0,150)
iKnockbackIntensity <- 1000

hDummyParent <- null

function MakeDummyParent(player) {
	ClearParent(self)
	if (ValidEntity(hDummyParent)) {
		hDummyParent.Destroy()
	}

	// hDummyParent = Spawn("prop_dynamic_ornament", {
	// 	origin = self.GetOrigin(),
	// 	targetname = "dummy",
	// 	model = "models/eltra/fetish_krusty.mdl",
	// 	rendermode = 10,
	// 	disableshadows = 1,
	// 	angles = self.GetAbsAngles(),
	// })
	hDummyParent = CreatePlayerWearable(player, "models/eltra/fetish_krusty.mdl")

	hDummyParent.DisableDraw()
	NetProps.SetPropInt(hDummyParent, "m_nRenderMode", 10)
	NetProps.SetPropInt(hDummyParent, "m_fEffects", Constants.FEntityEffects.EF_BONEMERGE + Constants.FEntityEffects.EF_BONEMERGE_FASTCULL)
	NetProps.SetPropInt(hDummyParent, "m_fEffects", Constants.FEntityEffects.EF_NOSHADOW)
	// hDummyParent.DisableDraw()
}

// function Precache() {
// 	try {
// 		self.KeyValueFromString("classnameoverride", "info_particle_system") // test
// 		NetProps.SetPropBool(self, "m_bValidatedAttachedEntity", true)
// 		// self.KeyValueFromString("", "info_particle_system") // test
// 	} catch (exception){

// 	}
// 	// self.
// }
function OnPostSpawn() {
	Init() // this allows sub-scripts to do their own postspawn functions.

	MarkForPurge(self)
	NetProps.SetPropFloat(self, "m_flMassOverride",  70)
	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()

	self.SetCollisionGroup(Constants.ECollisionGroup.COLLISION_GROUP_DEBRIS)
	local tclean = ItemName
	tclean = split(tclean, " ")
	local tfinal = ""
	foreach (i, word in tclean) {
		tfinal += "_" + word
	}
	tfinal += UniqueString("_zeitem")
	self.KeyValueFromString("targetname",tfinal)

	DropWeapon()

}


function DroppedThink() {

	if (self.GetPhysVelocity().Length() < 3 && (Disabled == false)) {
		AddThinkToEnt(self, "IdleThink")

		local vOrigin = self.GetOrigin()

		// local traceparams = {
		// 	start = vOrigin,
		// 	end = vOrigin + Vector(0,0,-1000),
			// pos = vOrigin // just incase
		// }

		// TraceLineEx(traceparams)


		local trace = QuickTrace(vOrigin, vOrigin + Vector(0, 0, -1000), self)

		local Context = GetContext(self)

		if ("floating" in Context && Context.floating == 1)
			trace.pos = vOrigin
			SetContext(self, "floating", 0)


		vRootOrigin = trace.pos + Vector(0,0, ItemFloatHeight)
		// self.SetAngles(0,0,0)
		self.SetOrigin(vRootOrigin)
		DisableMotion(self)
		self.SetSolid(Constants.ESolidType.SOLID_NONE)
		self.SetModelScale(IdleScale, 0.6) // do NOT set scale before disabling motion or the server WILL die
		idle_think_rate = -1
		return -1
	}

	return 0.1
}

idle_think_rate_high <- -1
idle_think_rate_low <- 0.2
idle_think_rate <- idle_think_rate_low

function IdleThink() {
	local vOrigin = self.GetOrigin()
	local vAngles = QAngle(0, Time() * -80 + iRotRandom, 0)
	local time = Time()

	local ply = Entities.FindByClassnameNearest("player", vOrigin, 1024)

	if (ValidEntity(ply)) {
		idle_think_rate = idle_think_rate_high
	} else {
		idle_think_rate = idle_think_rate_low
	}


	local vFloatOrigin = vRootOrigin
	local delta = FrameTime()
	vOrigin.z = vRootOrigin.z + (sin(time * iIdleSpeed) * iFloatDist)

	self.KeyValueFromVector("origin", vOrigin)

	// vAngles.y =
	self.SetAbsAngles(vAngles)

	if (time > NextPlayerScanTime) {
		NextPlayerScanTime = time + PlayerScanWait

		for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, iPickupScanRadius);) {
			if (ply.GetTeam() != ItemTeam || !ply.IsAlive()) {
				continue;
			}
			local pickstr = "|| Press the >LEFT MOUSE BUTTON< button to pick up item - "+ItemName.toupper()+". ||"
			ClientPrint(ply, Constants.EHudNotify.HUD_PRINTCENTER, pickstr)
			CleanString(pickstr)
			// if (ply.GetTeam() == ItemTeam && (NetProps.GetPropInt(ply,"m_afButtonLast") & IN_ATTACK2)) {
			if (ply.GetTeam() == ItemTeam && NetProps.GetPropInt(ply, "m_afButtonLast") & IN_ATTACK) {
				ply.ValidateScriptScope()
				local plyscope = ply.GetScriptScope()

				if (!"SeenItemTut" in plyscope || DEV == true) {
					ClientPrint(ply, Constants.EHudNotify.HUD_PRINTCENTER, "|| To use this item, press the >RIGHT MOUSE BUTTON<. To drop this item, duck, then press the >JUMP< button. ||")
					plyscope.SeenItemTut <- true
				} else {

					ClientPrint(ply, Constants.EHudNotify.HUD_PRINTCENTER, ItemGrabString)
				}
				// printl("grab that shit NOW")
				PickupWeapon(ply)
				return -1
			}
		}
	}


	return idle_think_rate
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

	local dummyangle = vEyeAng

	dummyangle.x = 0

	// local vActiveOrigin = vPlayerOrigin + (vPlayerAngles.Forward() * iOffsetForward) + (vPlayerAngles.Left() * iOffsetLeft)

	switch (FollowMode) { // FOLLOW MODE ACTIVE BEHAVIOURS
		case ZITEM_FOLLOWMODES.MODERN:
			// local vNextOrigin = vEyePos



			// viewbob ??
			// printl("bruh")
			// self.KeyValueFromVector("origin", vNextOrigin)
			local lerpang = QuaternionSlerp( self.GetAbsAngles().ToQuat(), hOwner.EyeAngles().ToQuat(), 4* FrameTime()).ToQAngle()
			// self.SetAngles(lerpang.x, lerpang.y, lerpang.z  )
			self.SetAbsAngles(lerpang)
			self.SetLocalOrigin(vLerp(self.GetLocalOrigin(), localviewoffset(), FrameTime() * 30))
			// hDummyParent.SetAbsOrigin(Vector(0,0,0))
		break;

		case ZITEM_FOLLOWMODES.FLAG:
			// hDummyParent.SetAbsOrigin(vEyePos)
			// hDummyParent.SetAbsAngles(QAngle(0,0,0))
			// self.SetAbsAngles(vEyeAng)
			// hDummyParent.SetLocalAngles(vEyeAng)
		break;

		default:
			hDummyParent.SetAbsAngles(dummyangle)
		break;

	}


	// hDummyParent.KeyValueFromVector("origin", vActiveOrigin)

	// self.SetAbsAngles(vEyeAng)





	local iPlayerFlags = hOwner.GetFlags()

	// player input stuff

	if (flNextCooldownEnd <= time && ButtonPressed(hOwner, AttackKey) ) {
	// if (flNextCooldownEnd <= time && hOwner.IsUsingActionSlot() ) {
		FireWeapon()
		// printl("fire")
	}

	if (ButtonPressed(hOwner, IN_DUCK) && ButtonPressed(hOwner, IN_JUMP) && (iPlayerFlags & FL_ONGROUND)) {
		// printl("Drop item now")
		DropWeapon()
		return -1
	}

	CustomThink()

	return -1
}

function DropWeapon() {
	// self.SetO
	CustomDrop()
	// self.SetModelScale(IdleScale, 0.0) // dont do this the server will crash LOL
	local vOrigin = self.GetOrigin()
	ClearParent(self)






	self.SetModelScale(1, 0)
	self.SetSolid(Constants.ESolidType.SOLID_VPHYSICS)
	EnableMotion(self)

	if (ValidEntity(hDummyParent)) {
		self.SetOrigin(vOrigin + vDropOffset)
		// self.SetAbsOrigin(hDummyParent.GetOrigin()+vDropOffset)
		hDummyParent.Destroy()
	}

	if (ValidEntity(hOwner)) {
		EnablePlayerWeapons(hOwner)

		local logstr = "ELTRAPICKUPS: user " + GetPlayerName(hOwner) + " has just dropped item "+ItemName+" at position " + vOrigin.ToKVString()
		printl(logstr)
		CleanString(logstr)
		self.SetOrigin(hOwner.GetOrigin() + vDropOffset)
		self.SetPhysVelocity(hOwner.EyeAngles().Forward()*ItemThrowForce)
		// self.SetAbsOrigin(hOwner.EyePosition())
		SetItemUser(hOwner, false)
		hOwner = null
	}

	self.SetPhysAngularVelocity(Vector(90,45, 20))
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
		// printl("Scanning at position " + scanpos.tostring())
		for (local ent; ent = Entities.FindInSphere(ent, scanpos, iShootRadius*1.5);) {
			local eclass = ent.GetClassname()
				if (eclass == "player" && ent != hOwner) {
					// printl(hOwner)
					// printl("\nFound player "+ent)
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
	player.SetAbsVelocity(kill)
	player.SetAbsOrigin(player.GetOrigin()+vStupidOffset)

}

function PickupWeapon(player) {
	if (CheckItemHolder(player)) {
		ClientPrint(player, Constants.EHudNotify.HUD_PRINTCENTER, "| You're already holding an item. |")
		return
	}


	local pickstr = GetPlayerName(player).toupper()+" HAS GRABBED AN ITEM - "+ItemName.toupper()
	MapSay(pickstr)
	CleanString(pickstr)

	GrabWeaponSound(player)
	MakeDummyParent(player)

	// SetContext(player, "ActiveWeaponSlot", NetProps.GetPropInt(player, "m_iWeaponSlot"))


	if (FullFocus)
		DisablePlayerWeapons(player)

	SetItemUser(player, true)
	DisableMotion(self)
	self.SetModelScale(1.0, 0.0)

	local vPlayerOrigin = player.EyePosition()
	local vPlayerAngles = player.EyeAngles()

	local vAngles = self.GetAbsAngles()
	local targpos = vPlayerOrigin + (vPlayerAngles.Forward() * iOffsetForward) + (vPlayerAngles.Left() * iOffsetLeft)

	local vOffset = (vAngles.Forward() * iOffsetForward) + (vAngles.Left() * iOffsetLeft) + (vAngles.Up() * iOffsetUp)



	// FOLLOW MODE PARENTING BEHAVIOURS
	switch (FollowMode) {
		case ZITEM_FOLLOWMODES.FLAG:
			self.SetModelScale(FlagScale, 0.0)
			SetParentEX(self,hDummyParent) // testing
			SetParentEX(hDummyParent, player, "flag")
			hDummyParent.SetLocalAngles(QAngle(-90,0,0))
			// hDummyParent.SetLocalOrigin(Vector(-90,0,0))
			self.SetLocalAngles(QAngle(90,-90,0))
			self.SetLocalOrigin(localviewoffset() + Vector(0,10,-4))

		break;

		case ZITEM_FOLLOWMODES.MODERN:
			NetProps.SetPropInt(hDummyParent, "m_fEffects", Constants.FEntityEffects.EF_BONEMERGE + Constants.FEntityEffects.EF_BONEMERGE_FASTCULL)


			// i dont even care anymore
			SetParentEX(self, hDummyParent) // parent the us ent to the dunny
			SetParentEX(hDummyParent, player) // parent the dummy ent to the player

			// local EyeHeight = abs(vPlayerOrigin.z - player.GetOrigin().z)
			// hDummyParent.SetLocalOrigin(Vector(0, 0, EyeHeight))
			// hDummyParent.SetLocalOrigin(Vector(0, 0, 0))
			hDummyParent.SetLocalAngles(QAngle(0, 0, 0))

			self.SetLocalAngles(QAngle(0, 0, 0))
			self.SetLocalOrigin(localviewoffset())

			// DisableMotion(self) // double check to ensure motion is disabled
			// self.AcceptInput("disablemotion", "", null, null)

			// local pOrigin = player.GetOrigin()
			// send both ents to world spawn before we start transforming them
			// self.SetOrigin(Vector(0,0,0))
			// self.SetLocalAngles(QAngle(0,0,0))
			// hDummyParent.SetAbsOrigin(Vector(0,0,0))
			// hDummyParent.SetLocalAngles(QAngle(0,0,0))

			// self.SetOrigin(vOffset)




			// local pos = Vector(iOffsetLeft * -1, iOffsetForward, iOffsetUp) // create the transform vector
			// // self.SetLocalOrigin(pos) // set the transform vector


			// // get the player's eye angles, clean out the pitch so we're still axis aligned
			// local vEyeAng = vPlayerAngles
			// vEyeAng.x = 0

			// hDummyParent.SetAbsAngles(vEyeAng) // set the dummy ent to the cleaned eye angles

			// self.SetLocalOrigin(vOffset)
			// hDummyParent.SetLocalOrigin(Vector(0,0,0)) // set the dummy ent's position to the player's


			// NetProps.SetPropInt(self, "m_fEffects", Constants.FEntityEffects.EF_BONEMERGE + Constants.FEntityEffects.EF_BONEMERGE_FASTCULL)

		break;

		default:
			self.SetOrigin(hDummyParent.GetOrigin())
			hDummyParent.SetAbsOrigin(vPlayerOrigin)

			SetParentEX(self,hDummyParent)
			hDummyParent.SetAbsAngles(vPlayerAngles)

			SetParentEX(hDummyParent, player)
			self.SetOrigin(targpos)
			NetProps.SetPropInt(hDummyParent, "m_fEffects", Constants.FEntityEffects.EF_BONEMERGE + Constants.FEntityEffects.EF_BONEMERGE_FASTCULL)
			self.SetAbsOrigin(hDummyParent.GetOrigin())
			self.SetAbsAngles(hDummyParent.GetAbsAngles())

		break;
		}
	// SetParentEX(self, NetProps.GetPropEntityArray(player, "m_hMyWeapons", 0))

	// SetParentEX(hDummyParent, NetProps.GetPropEntityArray(player, "m_hMyWeapons", 0))
	// NetProps.SetPropInt(self, "m_fEffects", Constants.FEntityEffects.EF_BONEMERGE + Constants.FEntityEffects.EF_BONEMERGE_FASTCULL)


	hOwner = player
	AddThinkToEnt(self, "ActiveThink")
	CustomPickup(player)

}


function localviewoffset() {
	local vAngles = self.GetLocalAngles()

	// if (ValidEntity(hOwner)) {
	// 	vAngles = hOwner.EyeAngles()
		// vAngles.x = 0
	// }
	return (vAngles.Forward() * iOffsetForward) + (vAngles.Left() * -iOffsetLeft) + (vAngles.Up() * iOffsetUp)
}

function viewoffset() {
	local vAngles = self.GetAbsAngles()
	return (vAngles.Forward() * iOffsetForward) + (vAngles.Left() * -iOffsetLeft) + (vAngles.Up() * iOffsetUp)
}

function Init() {
	// to avoid errors. don't fill this out
}

function CustomPickup(player) {

}

function CustomDrop() {

}

function CustomThink() {

}