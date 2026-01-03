// NOTE: THIS NPC USES THE TF2 DAMAGE SYSTEM AND SHOULD BE SCALED AS SUCH!

NPC_NAME <- "NPC_BASE"

NPC_OVERRIDE_ANGLE <- QAngle(0,0,0)

SF_WAKEUP <- ""
SF_DEATH <- ""
SF_AGGRESSION <- ""
SF_HURT <- ""
SF_HURTPLAYER <- ""


ANIM_FOLLOW <- ""
ANIM_DEATH <- ""
ANIM_IDLE <- ""

NPC_TURNSPEED <- 10

NPC_AUTODECAY <- true
NPC_IS_CLIFF_SMART <- true
NPC_RESOLVES_COLLISIONS <- true

iHealth <- 2000;
iHealthBase <- self.GetHealth()
// Visuals
iBobDist <- 4 // distance to offset during hover
iBobSpeed <-  2.5 // speed of hover bobbing

// hVisual <- MakeParticleSystem("lois_master", false)
// hVisualSleeping <- MakeParticleSystem("lois_asleep", false)
hTarget <- null

DownAccel <- 10

iObstacles <- 0
iMaxObstacles <- 10
ROTATE_ANGLE <- QAngle(0,90,0)

iAttackCooldown <- 0.6;
iNextAttackTime <- 0;
DownVec <- Vector(0,0,-1)
iNextAggroSoundTime <- 0
AGGRESSION_COOLDOWN <- 4
// iNextAggroSoundTime <- 0

iDeathParticle <- "npc_gore01"

NPC_ATTACKSTRENGTH <- 25

HitboxModelName <- self.GetModelName()


// hBossBase <- SpawnEntityFromTable("base_boss", {
// 		targetname = "Raxsei",
// 		model = BRUSHMODELS["ralsei_hitbox"], // can only safely do this in onpostspawn
// 		health = 99999999,
// 		maxhealth = 99999999,
// 	})

hBossBase <- Spawn("base_boss", {
		targetname = NPC_NAME + "_bossbase",
		model = self.GetModelName(), // can only safely do this in onpostspawn
		solid = 2,
		rendermode = 10,
		health = 999999999,
		maxhealth = 999999999,
	})

// Time between returns in the ActiveThink function
iActiveDelta <- 0.05

// Gameplay

// If a player is within this radius, switch to ActiveThink mode
NPC_TARGET_RADIUS <- 256

// If we have waited this long without being activated, just kill ourselves
NPC_DECAYTIME <- 100

iSleepNextExpireTime <- 0

// Radius to attack players in
NPC_ATTACKRANGE <- 96

// Movement-Related Values
NPC_CHASE_SPEED <- RandomInt(300,400) // How fast should we follow player when fully accelerated
iMinFollowSpeed <- 10 // Speed we should slow down to when player is in "mercy" range

// Mercy
iMercyDistanceMult <- 0.1// multiplier for the mercy distance

// Acceleration
iCurAccel <- 0

NPC_ACCELERATION <- 0.2 // How much to accelerate per tick
iMaxAccel <- 2

UniqueName <- NPC_NAME+UniqueString()

vZero <- Vector(0,0,0)

hVisModel <- Spawn("prop_dynamic", { model = self.GetModelName(), modelscale = self.GetModelScale(), origin = self.GetOrigin(), angles = self.GetAbsAngles()})
function OnPostSpawn() {

	// Setting up hitbox
	// hBossBase <- Spawn("base_boss", {
	// 	targetname = "Raxsei",
	// 	model = BRUSHMODELS["ralsei_hitbox"], // can only safely do this in onpostspawn
	// 	health = 999999999,
	// 	maxhealth = 999999999,
	// })
	self.KeyValueFromString("targetname", UniqueName)
	hBossBase.SetModelSimple(self.GetModelName())
	hBossBase.AcceptInput("SetSpeed","0",null,null)
	hBossBase.SetSize(self.GetBoundingMinsOriented(), self.GetBoundingMaxsOriented())
	hBossBase.AcceptInput("SetStepHeight","1",null,null)
	hBossBase.AcceptInput("SetMaxJumpHeight","1",null,null)
	hBossBase.SetResolvePlayerCollisions(NPC_RESOLVES_COLLISIONS)
	hBossBase.SetSolid(2)
	// NetProps.SetPropBool(hBossBase, "m_bUseBossHealthBar", true)
	self.DisableDraw()
	// BossBaseSync()
	SetParentEX(hVisModel, self)
	hBossBase.SetOwner(self)
	hVisModel.SetLocalAngles(NPC_OVERRIDE_ANGLE)


	self.KeyValueFromInt("solid", 1)

	if (self.GetClassname() == "func_physbox" || self.GetClassname() == "func_physbox_multiplayer" ) { // are we a brush-based entity?
		hBossBase.SetModelScale(4,1)
	}


	self.SetCollisionGroup(Constants.ECollisionGroup.COLLISION_GROUP_DEBRIS)
	hBossBase.SetCollisionGroup(Constants.ECollisionGroup.COLLISION_GROUP_INTERACTIVE_DEBRIS)

	BossBaseSync()

	// SetParentEX(hBossBase, self)
	local hooks = {

		function OnScriptHook_OnTakeDamage(params) {
			// printl("damage hook")
			if (params.const_entity == hBossBase && params.inflictor != null && params.inflictor.IsPlayer()) {

				// printl(__DumpScope(1, params))
				local iDamage = params.damage
				local activator = params.attacker
				QAcceptInput(hVisModel, "color", "255 0 0")
				QFireByHandle(hVisModel, "color", "255 255 255", 0.02)
				iHealth -= params.damage
				hVisModel.SetLocalAngles(NPC_OVERRIDE_ANGLE + QAngle(RandomInt(-1,1),0,RandomInt(-1,1)))
				QFireByHandle(self,"RunScriptCode", "hVisModel.SetLocalAngles(NPC_OVERRIDE_ANGLE)", 0.06)


				local vPlayerOrigin = activator.EyePosition()
				local vOrigin = self.GetOrigin()

				local DamageVec = GetMovementVector(vPlayerOrigin, vOrigin)


				// self.SetAbsOrigin(vOrigin + (iDamage * DamageVec))

				iCurAccel *= 0.95
			}
		}

	}
	ShittyListenHooks(hooks)

	// self.SetHealth(iHealth) // bad idea do connect input instead
	self.ConnectOutput("OnTakeDamage", "OnTakeDamage")
	local vOrigin = self.GetOrigin()

	// hVisual.SetAbsOrigin(vOrigin)
	// hVisualSleeping.SetAbsOrigin(vOrigin)

	// SetParentEX(hHitbox,self)
	// SetParentEX(hVisualSleeping,self)
	CustomSpawn()
	Sleep()
}

function SleepThink() {

	if (iHealth <= 0 || !ValidEntity(hBossBase)) {
		Death()
		return
	}

	BossBaseSync()


	local time = Time()

	if (time >= iSleepNextExpireTime && NPC_AUTODECAY) { // apoptosis
		// hVisual.Kill()
		// hVisualSleeping.Kill()
		self.Kill()
		// printl("Despawning due to inactivity")
		return
	}

	local vOrigin = self.GetOrigin()
	if (Retarget()) {
		Wake()
		return -1
	}

	return 1
}

function BossBaseSync() {
	hBossBase.SetAbsAngles(self.GetAbsAngles())
	hBossBase.KeyValueFromVector("origin",self.GetOrigin())
}

function ActiveThink() {

	if (iHealth <= 0 || !ValidEntity(hBossBase)) {
		Death()
		return
	}

	if (hTarget == null || !ValidEntity(hTarget) || !hTarget.IsAlive() || !hTarget.GetTeam() == TEAMS.HUMANS || iObstacles > iMaxObstacles) { // verify if target is valid, if not then retarget
		if (!Retarget()) {
			Sleep()
			return -1
		}
	}


	local time = Time()

	local vOrigin = self.GetOrigin()
	// local vAngles = RotateOrientation(self.GetAbsAngles(), NPC_OVERRIDE_ANGLE * -1)
	local vAngles = self.GetAbsAngles()
	local vNextOrigin = vZero




	local vPlayerOrigin = hTarget.EyePosition() // trying out eyepos to see if it looks better
	// add noise to player vector to alleiviate npc stacking (i.e. cic furry boss)
	vPlayerOrigin.x += RandomInt(-128, 128)
	vPlayerOrigin.y += RandomInt(-128, 128)

	local vPlayerAngles = hTarget.GetAbsAngles()

	// player interaction code

	if (time >= iNextAttackTime) {
		iNextAttackTime = time + iAttackCooldown
		for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, NPC_ATTACKRANGE);) {
			// printl("KILL "+ply.tostring())
			ply.TakeDamage(NPC_ATTACKSTRENGTH + RandomInt(-5, 5), Constants.FDmgType.DMG_DISSOLVE, hBossBase)
		}

	}

	// if (time >= iNextAggroSoundTime) { // annoying
	// 	iNextAggroSoundTime = time + AGGRESSION_COOLDOWN
	// 	PlaySoundEX(SF_AGGRESSION, vOrigin, 10, RandomInt(95,105), self)

	// 	PrecacheSound(SF_AGGRESSION)
	// 	// EmitAmbientSoundOn(SF_AGGRESSION, 10, 0.25, RandomInt(95,105), self)
	// }







	// movement code

	if (iCurAccel < iMaxAccel) { // calcualte acceleration


		// iCurAccel = clamp((iCurAccel + clamp((iCurAccel * (NPC_ACCELERATION)), 0.1, NPC_ACCELERATION)), -iMaxAccel, iMaxAccel)/iMaxAccel
		iCurAccel = clamp(iCurAccel + NPC_ACCELERATION/iMaxAccel, -1, 1)

	}

	iCurAccel *= 0.9

	// printl("Current Accel: "+iCurAccel.tostring())

	// local AngDiff = QAngle(LookVec) - vAngles
	// local AngToPlayer = FindAng(vOrigin, vPlayerOrigin)
	local AngToPlayer = GetAngleTo(vPlayerOrigin, vOrigin)

	// local AngDiff = vAngles - LookAng

	local NextAngle;

	// NextAngle = vAngles - AngleDiff3D(AngToPlayer, vAngles)*0.1
	// NextAngle = vAngles - AngleDiff3D(AngToPlayer, vAngles)*0.1


	// AngleDiff3D()
	// NextAngle


	// NextAngle = NextAngle.ToQAngle()
	// NextAngle.z = 0


	// self.SetAbsAngles(AngleDiff3D(AngToPlayer, vAngles)*-0.1)
	self.SetAbsAngles((QuaternionSlerp(vAngles.ToQuat(), AngToPlayer.ToQuat(), NPC_TURNSPEED * FrameTime())).ToQAngle())


	local vMoveVec = GetMovementVector(vPlayerOrigin, vOrigin)

	// scale movement speed with player distance
	local iMercyMult = clamp(GetDistance(vOrigin, vPlayerOrigin) * iMercyDistanceMult, 0.5, 1)

	// printl("Mercy mult: "+iMercyDistanceMult.tostring())

	local movespeed = clamp(NPC_CHASE_SPEED * iMercyDistanceMult, iMinFollowSpeed, NPC_CHASE_SPEED) * easeInBack(iCurAccel)

	// printl("speed "+movespeed.tostring())

	// create the next movement vector
	vNextOrigin += (self.GetForwardVector() * movespeed)


	local tOrigin = vOrigin + vNextOrigin + UpVec * 32
	local tmask = 65547
	local groundtrace = QuickTrace(tOrigin, tOrigin + (DownVec*64), self, MASK_ALL)
	DebugDrawLine_vCol(groundtrace.startpos, groundtrace.pos,Vector(0,255,0), false, 0.1)
	local facetrace = QuickTrace(tOrigin, tOrigin + vAngles.Forward(), self, MASK_SHOT)
	DebugDrawLine_vCol(facetrace.startpos, facetrace.pos, Vector(255,0,0), false, 0.1)

	if (((groundtrace.hit == false && NPC_IS_CLIFF_SMART) || (facetrace.hit == true && !facetrace.enthit.IsPlayer()))) {
		vNextOrigin *= -1 // reverse the planned movement
		self.SetAbsAngles(vAngles + ROTATE_ANGLE * RandomInt(-1,1)) // rotate to get outselves out of this situation
		iObstacles++ // increase obstacles counter
	}

	if (groundtrace.hit == false && !NPC_IS_CLIFF_SMART) {
		vNextOrigin.z -= 2 * DownAccel
		DownAccel = clamp(DownAccel + (DownAccel * FrameTime()), 0, 100)

	} else if (groundtrace.hit == true && facetrace.hit == false) {
		vNextOrigin = groundtrace.pos - vOrigin
	}



	// do the movement!
	self.KeyValueFromVector("origin", vOrigin + vNextOrigin)



	BossBaseSync()
	CustomActive()

	return iActiveDelta

}

function Retarget() {
	iObstacles = 0 // reset obstacles now that we have a new target
	local vOrigin = self.GetOrigin()
	hTarget = null
	local targ;
	while (targ = Entities.FindByClassnameNearest("player", vOrigin, NPC_TARGET_RADIUS)) {
		if (targ.GetTeam() == TEAMS.HUMANS && targ.IsAlive()) {
			hTarget = targ
			return true
		}
		else break;
	}
	// Sleep()
	return false
}

function Sleep() {
	EnableMotion(self)
	iSleepNextExpireTime = Time() +  NPC_DECAYTIME

	AddThinkToEnt(self, "SleepThink");
	SetAnimation(hVisModel, "idle")
	CustomSleep()


}


function Wake() {
	PlaySoundNPC(SF_WAKEUP, self)
	AddThinkToEnt(self, "ActiveThink")
	SetAnimation(hVisModel, ANIM_FOLLOW)
	// QFireByHandle(self, "SetPlaybackRate", RandomFloat(0.9,1.1).tostring())
	CustomWake()
}
iRemoveTime <- 0
AlphaDecayRate <- 0
function Death() {
	CustomDeath()

	SetAnimation(hVisModel, ANIM_DEATH)
	AddThinkToEnt(self, "")
	if (ValidEntity(hBossBase)) {
		hBossBase.Kill()
	}
	local vOrigin = self.GetOrigin()
	DoEffect(iDeathParticle,vOrigin, 0.5)
	PlaySoundNPC(SF_DEATH, self)
	iRemoveTime = Time() + 10
	AddThinkToEnt(self, "FadeThink")
	// QFireByHandle(self, "Kill", "", 10)
	AlphaDecayRate = (iRemoveTime - Time() - 3)/255
	QAcceptInput(hVisModel, "rendermode", "1")

}

iDeadTime <- 0

function FadeThink() {
	iDeadTime += FrameTime()
	if (iDeadTime >= 3) {

		hVisModel.KeyValueFromInt("renderamt", NetProps.GetPropInt(hVisModel, "m_nRenderFX") - ceil(AlphaDecayRate))
	}

	if (iRemoveTime <= Time()) {
		self.Kill()
	}

	return -1
}

function CustomSpawn() {
}

function CustomDeath() {

}

function CustomWake() {

}

function CustomIdle() {

}

function CustomSleep() {

}