
hOwner <- null
flNextCooldownEnd <- 0
iCooldownAdd <- 0.4

vNoAngle <- QAngle(0,90,0)
vRootOrigin <- self.GetOrigin()

flNextScrollTime <- 0

// interal stuff
const mineblock = "models/eltra/mineblock.mdl"
NextPlayerScanTime <- 0
PlayerScanWait <- 0.5
iNextInputScanTime <- 0

mc_outline <- null

// sound_table <- []
allowteam <- RandomInt(TEAMS.HUMANS,TEAMS.ZOMBIES)
mc_blocks <- [
	["Grass",1, "grass"],
	["Dirt", 2, "gravel"],
	// ["Wooden Planks", BRUSHMODELS["mc_woodplanks"]],

]
m_selectindex <- 0
mc_selected <- mc_blocks[0]
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

::MineBlockSize <- 32
::MineBlockSizeHalf <- MineBlockSize/2
::MineBlockSnapAdd <- Vector(MineBlockSize/2, MineBlockSize/2, MineBlockSize/2)
// MineBlockSnappedAdd <- Vector(MineBlockSize,MineBlockSize,MineBlockSize)

::MineGrid <- function(pos) { // convert regular coordinates to coordinates in the minecraft grid
	pos += MineBlockSnapAdd

	// snap to minecraft block grid

	pos.x = floor(pos.x / MineBlockSize)
	pos.y = floor(pos.y / MineBlockSize)
	pos.z = floor(pos.z / MineBlockSize)

	// pos += Vector(MineBlockSize)

	// scale back up to real position
	pos *= MineBlockSize

	// pos.z += MineBlockSizeHalf

	return pos
}

function SourceGrid(pos) {
	local newvec = pos
	pos.x *= MineBlockSize
	pos.y *= MineBlockSize
	pos.z *= MineBlockSize

	return pos
}
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

	switch (allowteam) {
		case TEAMS.HUMANS:
		QFireByHandle(self, CUBT_COLOR, "0 0 255")
		break;
		case TEAMS.ZOMBIES:
		QFireByHandle(self, CUBT_COLOR, "255 0 0")
		break;
	}
	self.SetCollisionGroup(Constants.ECollisionGroup.COLLISION_GROUP_DEBRIS)
	self.KeyValueFromString("targetname","item_minecraft")
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
			if (ply.GetTeam() == allowteam && ButtonPressed(ply, IN_ATTACK2)) {// zombie item
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
	if (hOwner == null || !ValidEntity(hOwner) || hOwner.GetTeam() != allowteam || !hOwner.IsAlive()) {
		DropWeapon()
	}

	self.SetDrawEnabled(true)
	local using = ButtonPressed(hOwner, IN_USE)

	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()

	local time = Time()

	local vPlayerOrigin = hOwner.GetOrigin()
	local vPlayerAngles = hOwner.GetAbsAngles()

	local vEyePos = hOwner.EyePosition()
	local vEyeAng = hOwner.EyeAngles()
	local vEyeAngForward = vEyeAng.Forward()


	// minecaft block stuff
	//mineblock
	local HitPos = QuickTrace(vEyePos, vEyePos + vEyeAngForward * 128, hOwner, MASK_SHOT_PORTAL).pos

	local mc_hitpos = MineGrid(HitPos) // where the hitpos is, with regards to the minecraft grid
	local mc_hitpos_pushed = MineGrid(HitPos + vEyeAngForward)
	local mc_overlapblock = BlockCheck(mc_hitpos_pushed)

	DebugDrawLine(HitPos, mc_hitpos_pushed, 0,255,0,false,0.1)

	local mc_overlappos = null
	local mc_outlinepos = mc_hitpos
	if (mc_overlapblock != null) {

		mc_overlappos = mc_overlapblock.GetOrigin()
		// mc_outlinepos = mc_overlappos
		mc_outlinepos = mc_hitpos_pushed
	} else {
		mc_outlinepos = mc_hitpos_pushed
	}
	// outline where owner will place block
	if (!ValidEntity(mc_outline)) { // create outline logic here

		mc_outline = Spawn("func_physbox", {
			spawnflags = SPAWNFLAGS_PUPPET,
			model = BRUSHMODELS["mc_outline"],
			disableshadows = 1,
			rendermode = 5,

			origin = mc_outlinepos
		})


	}

	if (!using) {
		mc_outline.KeyValueFromFloat("renderamt", 0)
	} else {
		mc_outline.KeyValueFromFloat("renderamt", 255)
	}
	// we can reliably assume the outline exists beyond here so no need to null check

	mc_outline.SetAbsOrigin(mc_outlinepos) // snap outline to the grid
	// mc_outline.KeyValueFromInt("renderamt", abs(sin(Time() * 2) )* 100) // flash the thing



	local dummyangle = vPlayerAngles

	dummyangle.x = 0
	local vActiveOrigin = vPlayerOrigin + (vPlayerAngles.Forward() * iOffsetForward) + (vPlayerAngles.Left() * iOffsetLeft)
	hDummyParent.KeyValueFromVector("origin", vActiveOrigin)

	self.SetAbsAngles(vEyeAng)
	hDummyParent.SetAbsAngles(dummyangle)





	local iPlayerFlags = hOwner.GetFlags()

	// player input stuff

	if (ButtonPressed(hOwner, IN_DUCK)) {
		local hOwnerVel = hOwner.GetAbsVelocity()
		local selstr = "|> Selected Block : "+mc_blocks[m_selectindex][0]+" <|"
		ClientPrint(hOwner, Constants.EHudNotify.HUD_PRINTCENTER, selstr)
		CleanString(selstr)

		hOwnerVel.x *= 0.0
		hOwnerVel.y *= 0.0

		hOwner.SetAbsVelocity(hOwnerVel)
		// hOwner.KeyValueFromString("basevelocity", "0 0 0")
	}
	if (ButtonPressed(hOwner, IN_DUCK) && (flNextScrollTime <= time)) {
		local scrolled = false

		if (ButtonPressed(hOwner, IN_MOVELEFT)) {
		flNextScrollTime = time + 0.66
			m_selectindex += 1
			scrolled = true
		}
		else if (ButtonPressed(hOwner, IN_MOVERIGHT)) {
			m_selectindex -= 1
		flNextScrollTime = time + 0.66
		scrolled = true

		}

		if (scrolled == true) {
			local sellen = mc_blocks.len()-1

			if (m_selectindex > sellen) {
				m_selectindex = 0
			}

			if (m_selectindex < 0) {
				m_selectindex = (sellen)
			}

			mc_selected = mc_blocks[m_selectindex]

		}
	}
	if (using && (flNextCooldownEnd <= time)) {
		// iNextInputScanTime = 01




		local block = BlockCheck(mc_hitpos)

		if (ButtonPressed(hOwner, IN_ATTACK) && mc_overlapblock != null) { // break blocks!

			flNextCooldownEnd = Time() + 0.03

			mc_overlapblock.ValidateScriptScope()
			local type = mc_overlapblock.GetScriptScope().iMaterial
			PlaySound(soundstr, mc_overlapblock)
			local soundstr = "eltra/mc/"+type+RandomInt(1,4).tostring()+".mp3"
			PlaySoundNPC(soundstr, mc_overlapblock)
			CleanString(soundstr)

			QFireByHandle(mc_overlapblock, "Break") // break block
		}
		else if (ButtonPressed(hOwner, IN_ATTACK2) && (MINECRAFT_BLOCKS < MAX_MINECRAFT_BLOCKS) && (block == null)) { // make blocks!

			flNextCooldownEnd = Time() + 0.15

			// obsoleted by BlockThink

			// if (type(mc_blocks[mc_selected]) == "array") { // grass block logic

				// scan above for blocks
				// local sealed = false

				// local checkpos = mc_hitpos + Vector(0,0, MineBlockSize)

				// if (BlockCheck(checkpos) != null) {
					// sealed = true
				// }

				// if (sealed == true) { // u can get around this by putting a block on an exposed one but it doesnt matter when this is literally a whole thing just for a ze item
					// blockmodel = blockmodel[1]
				// } else {
					// blockmodel = blockmodel[0]
				// }
			// }

			// dirt block check ijbol

			local blockname = mc_selected[0]
			local blockskin = mc_selected[1]




			block = Spawn("func_physbox", {
				targetname = "MINECRAFT_BLOCK",
				spawnflags = 32768,
				disableshadows = true,
				model = mineblock,
				health = 1,
				skin = blockskin,
				damagefilter = "filter_redonly",
				// rendermode = 1,
				origin = MineGrid(HitPos)
			})

			MINECRAFT_BLOCKS++

			block.ValidateScriptScope()
			local scope = block.GetScriptScope()
			scope.BlockThink <- BlockThink
			scope.iMaterial <- mc_selected[2]
			scope.TimeDie <- time + 8 // block decays after this length
			scope.BlockHurt <- BlockHurt
			scope.BlockBreak <- BlockBreak
			scope.BlockType <- blockname
			scope.MineBlockSize <- MineBlockSize
			block.ConnectOutput("OnDamaged", "BlockHurt")
			block.ConnectOutput("OnBreak", "BlockBreak")

			AddThinkToEnt(block, "BlockThink")

		}


		// FireWeapon()


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
	local vPlayerAngles = player.GetAbsAngles()

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

::BlockCheck <- function(pos) {

	for (local blk; blk = Entities.FindByClassnameNearest("func_physbox", pos, MineBlockSize);) {
		if (blk.GetName() == "MINECRAFT_BLOCK") {
			return blk
		}
		else {
			return null
		}
	}
	return
	// }
}

function BlockThink() { // block think func

	// replicate game grass behaviour
	if (BlockType == "Grass" || BlockType == "Dirt") {

		local dirtcheckpos = MineGrid(self.GetOrigin() + Vector(0,0, MineBlockSize))
		if (BlockCheck(dirtcheckpos) == null && (self.GetModelName() != BRUSHMODELS["mc_dirtblock"])) {
			// SetBrushModel(self, "mc_grassblock")
			self.SetSkin(1)

		} else {
			self.SetSkin(2)
			// SetBrushModel(self, "mc_dirtblock")
		}

	}

	if (Time() > TimeDie) {
		self.Destroy()
		return
	}
	return 1
}

function BlockHurt() { // block damaged

}

function BlockBreak() { // block broke
	MINECRAFT_BLOCKS--
}