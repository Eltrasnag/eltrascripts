IncludeScript("eltrasnag/npc/npc_base.nut", this)
// NOTE: THIS NPC USES THE TF2 DAMAGE SYSTEM AND SHOULD BE SCALED AS SUCH!

SF_HIT <- "eltra/ra_hit.mp3"
SF_DEATH <- "eltra/ra_die.mp3"
SF_AGGRESSION <- "eltra/ra_spotted2.mp3"

iHealth <- 250;
iHealthBase <- self.GetHealth()
// Visuals
iBobDist <- 4 // distance to offset during hover
iBobSpeed <-  2.5 // speed of hover bobbing

// hVisual <- MakeParticleSystem("lois_master", false)
// hVisualSleeping <- MakeParticleSystem("lois_asleep", false)

iObstacles <- 0
iMaxObstacles <- 10
ROTATE_ANGLE <- QAngle(0,45,0)

iAttackCooldown <- 0.6;
iNextAttackTime <- 0;
DownVec <- Vector(0,0,-1)
iNextAggroSoundTime <- 0
iNextAggroSoundWait <- 4
// iNextAggroSoundTime <- 0

iDeathParticle <- "npc_gore01"

iAttackDamage <- 25

HitboxModelName <- BRUSHMODELS["ralsei_hitbox"]


// hBossBase <- SpawnEntityFromTable("base_boss", {
// 		targetname = "Raxsei",
// 		model = BRUSHMODELS["ralsei_hitbox"], // can only safely do this in onpostspawn
// 		health = 99999999,
// 		maxhealth = 99999999,
// 	})

hBossBase <- Spawn("base_boss", {
		targetname = "Raxsei",
		model = BRUSHMODELS["ralsei_hitbox"], // can only safely do this in onpostspawn
		health = 999999999,
		maxhealth = 999999999,
	})

// Time between returns in the ActiveThink function
iActiveDelta <- 0.05

// Gameplay

// If a player is within this radius, switch to ActiveThink mode
iAlertRadius <- 256

// If we have waited this long without being activated, just kill ourselves
iSleepExpireTime <- 100

iSleepNextExpireTime <- 0

// Radius to attack players in
iAttackRadius <- 96

// Movement-Related Values
iFollowSpeed <- 200 // How fast should we follow player when fully accelerated
iMinFollowSpeed <- 10 // Speed we should slow down to when player is in "mercy" range

// Mercy
iMercyDistanceMult <- 0.1// multiplier for the mercy distance

// Acceleration
iCurAccel <- 0

iAccelRate <- 0.2 // How much to accelerate per tick
iMaxAccel <- 2

UniqueName <- "NPC_RALSEI_"+UniqueString()

vZero <- Vector(0,0,0)

function OnPostSpawn() {

	// Setting up hitbox
	// hBossBase <- Spawn("base_boss", {
	// 	targetname = "Raxsei",
	// 	model = BRUSHMODELS["ralsei_hitbox"], // can only safely do this in onpostspawn
	// 	health = 999999999,
	// 	maxhealth = 999999999,
	// })

	self.KeyValueFromString("targetname", UniqueName)
	hBossBase.SetModelSimple(HitboxModelName)
	hBossBase.AcceptInput("SetSpeed","0",null,null)
	hBossBase.AcceptInput("SetStepHeight","0",null,null)
	hBossBase.AcceptInput("SetMaxJumpHeight","0",null,null)
	hBossBase.SetResolvePlayerCollisions(true)
	// NetProps.SetPropBool(hBossBase, "m_bUseBossHealthBar", true)

	BossBaseSync()

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

				iHealth -= params.damage


				local vPlayerOrigin = activator.EyePosition()
				local vOrigin = self.GetOrigin()

				local DamageVec = GetMovementVector(vPlayerOrigin, vOrigin)


				// self.SetAbsOrigin(vOrigin + (iDamage * DamageVec))

				iCurAccel *= 0.8
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

	Sleep()
}

function SleepThink() {

	if (iHealth <= 0 || !ValidEntity(hBossBase)) {
		Death()
		return
	}

	BossBaseSync()


	local time = Time()

	if (time >= iSleepNextExpireTime) { // apoptosis
		// hVisual.Kill()
		// hVisualSleeping.Kill()
		self.Kill()
		printl("Despawning due to inactivity")
		return
	}

	local vOrigin = self.GetOrigin()
	if (Retarget()) {
		Wake()
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

	if (!ValidEntity(hTarget) || !hTarget.IsAlive() || !hTarget.GetTeam() == TEAMS.HUMANS || iObstacles > iMaxObstacles) { // verify if target is valid, if not then retarget
		if (!Retarget()) {
			Sleep()
		}
	}


	local time = Time()

	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()
	local vNextOrigin = vZero




	local vPlayerOrigin = hTarget.EyePosition() // trying out eyepos to see if it looks better
	local vPlayerAngles = hTarget.GetAbsAngles()

	// player interaction code

	if (time >= iNextAttackTime) {
		iNextAttackTime = time + iAttackCooldown
		for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, iAttackRadius);) {
			printl("KILL "+ply.tostring())
			ply.TakeDamage(iAttackDamage + RandomInt(-5, 5), Constants.FDmgType.DMG_DISSOLVE, hBossBase)
		}

	}

	// if (time >= iNextAggroSoundTime) { // annoying
	// 	iNextAggroSoundTime = time + iNextAggroSoundWait
	// 	PlaySoundEX(SF_AGGRESSION, vOrigin, 10, RandomInt(95,105), self)

	// 	PrecacheSound(SF_AGGRESSION)
	// 	// EmitAmbientSoundOn(SF_AGGRESSION, 10, 0.25, RandomInt(95,105), self)
	// }







	// movement code

	if (iCurAccel < iMaxAccel) { // calcualte acceleration


		// iCurAccel = clamp((iCurAccel + clamp((iCurAccel * (iAccelRate)), 0.1, iAccelRate)), -iMaxAccel, iMaxAccel)/iMaxAccel
		iCurAccel = clamp(iCurAccel + iAccelRate/iMaxAccel, -1, 1)

	}

	iCurAccel *= 0.9

	printl("Current Accel: "+iCurAccel.tostring())

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
	self.SetAbsAngles((QuaternionSlerp(vAngles.ToQuat(), AngToPlayer.ToQuat(), 0.1)).ToQAngle());


	local vMoveVec = GetMovementVector(vPlayerOrigin, vOrigin)

	// scale movement speed with player distance
	local iMercyMult = clamp(GetDistance(vOrigin, vPlayerOrigin) * iMercyDistanceMult, 0.5, 1)

	printl("Mercy mult: "+iMercyDistanceMult.tostring())

	local movespeed = clamp(iFollowSpeed * iMercyDistanceMult, iMinFollowSpeed, iFollowSpeed) * easeInBack(iCurAccel)

	printl("speed "+movespeed.tostring())

	// create the next movement vector
	vNextOrigin += (self.GetForwardVector() * movespeed)


	local tOrigin = vOrigin + vNextOrigin + UpVec * 32
	local groundtrace = QuickTrace(tOrigin, tOrigin + (DownVec*64), self)
	DebugDrawLine_vCol(groundtrace.startpos, groundtrace.pos,Vector(0,255,0), false, 0.1)
	local facetrace = QuickTrace(tOrigin, tOrigin + vAngles.Forward()*10, self)
	DebugDrawLine_vCol(facetrace.startpos, facetrace.pos, Vector(255,0,0), false, 0.1)

	if ((groundtrace.hit == false || (facetrace.hit == true))) {
		vNextOrigin *= -1 // reverse the planned movement
		self.SetAbsAngles(vAngles + ROTATE_ANGLE) // rotate to get outselves out of this situation
		iObstacles++ // increase obstacles counter
	}
	if (groundtrace.hit == true) {

		vNextOrigin = groundtrace.pos - vOrigin
	}
	// do the movement!
	self.KeyValueFromVector("origin", vOrigin + vNextOrigin)



	BossBaseSync()


	return iActiveDelta

}

function Retarget() {
	iObstacles = 0 // reset obstacles now that we have a new target
	local vOrigin = self.GetOrigin()

	for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, iAlertRadius);) {
		if (ply.GetTeam() == TEAMS.HUMANS && ply.IsAlive()) {
			hTarget <- ply
			return true
		}
	}
	return false
}

function Sleep() {

	EnableMotion(self)
	iSleepNextExpireTime = Time() +  iSleepExpireTime

	AddThinkToEnt(self, "SleepThink");
	SetAnimation(self, "idle")


}

function Wake() {
	// DisableMotion(self)
	// PlaySoundEX(SF_AGGRESSION, self.GetOrigin(), 10, RandomInt(95, 105), self)
	PlaySoundNPC(SF_AGGRESSION, self)

	AddThinkToEnt(self, "ActiveThink")
	SetAnimation(self, "running")

}

function OnTakeDamage() {


}

function BaseBossHealthSync() {
	// iHealth = hBossBase.GetHealth()
	// ?
}
// CollectEventsInScope({

// 	function OnScriptHook_OnTakeDamage(params) {
// 		if (params.const_entity == self) {
// 			printl("Ouch")
// 			self.SetAbsOrigin(self.GetOrigin() + damage_force)

// 		}
// 	}

// })

function Death() {
	AddThinkToEnt(self, "")
	if (ValidEntity(hBossBase)) {
		hBossBase.Kill()
	}
	local vOrigin = self.GetOrigin()
	DoEffect(iDeathParticle,vOrigin, 0.5)
	PlaySoundNPC(SF_DEATH, self)
	SetAnimation(self, "die")
	QFireByHandle(self, "Kill", "", 1)
}

