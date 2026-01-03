// NOTE: THIS NPC USES THE TF2 DAMAGE SYSTEM AND SHOULD BE SCALED AS SUCH!
hTarget <- null
MikuOffset <- Vector(0,0,35)
SF_HIT <- "eltra/ra_hit.mp3"
SF_DEATH <- "eltra/ra_die.mp3"
SF_AGGRESSION <- "eltra/ra_spotted2.mp3"

hVisual <- Spawn("prop_dynamic", {disableshadows = true, DisableBoneFollowers = true})
WanderDest <- self.GetOrigin()
iHealth <- 250;
iHealthBase <- self.GetHealth()
// Visuals
iBobDist <- 4 // distance to offset during hover
iBobSpeed <-  2.5 // speed of hover bobbing

// hVisual <- MakeParticleSystem("lois_master", false)
// hVisualSleeping <- MakeParticleSystem("lois_asleep", false)
iNextIdleActionTime <- 0
bIsWalking <- true
iObstacles <- 0
iMaxObstacles <- 10
ROTATE_ANGLE <- QAngle(0,45,0)

iAttackCooldown <- 0.6;
iNextAttackTime <- 0;
DownVec <- Vector(0,0,-1)
iNextAggroSoundTime <- 0
iNextAggroSoundWait <- 4

iDeathParticle <- "npc_gore01"

iAttackDamage <- 25

HitboxModelName <- BRUSHMODELS["victim_hitbox"]


hBossBase <- SpawnEntityFromTable("base_boss", {
		targetname = "Raxsei",
		model = BRUSHMODELS["victim_hitbox"], // can only safely do this in onpostspawn
		health = 99999999,
		maxhealth = 99999999,
	})

// Time between returns in the ActiveThink function
iActiveDelta <- 0.05

// Gameplay

// If a player is within this radius, switch to ActiveThink mode
iAlertRadius <- 256

// If we have waited this long without being activated, just kill ourselves
iSleepExpireTime <- 100000

iSleepNextExpireTime <- 0

// Radius to attack players in
iAttackRadius <- 96

// Movement-Related Values
iFollowSpeed <- 200 // How fast should we follow player when fully accelerated
iMinFollowSpeed <- 10 // Speed we should slow down to when player is in "mercy" range

// Mercy
iMercyDistanceMult <- 0.1// multiplier for the mercy distance
SpawnPoint <- self.GetOrigin()
// Acceleration
iCurAccel <- 0

iAccelRate <- 0.2 // How much to accelerate per tick
iMaxAccel <- 2

UniqueName <- "NPC_victim_"+UniqueString()

vZero <- Vector(0,0,0)
WanderTries <- 0

function FindWanderTarget() {
	if (WanderTries > 2 ) {
		self.SetAbsOrigin(SpawnPoint)
		return
	}
	WanderTries++
	local vOrigin = self.GetOrigin()
	local targpos = vOrigin + Vector(RandomInt(-1024, 1024),RandomInt(-1024, 1024),0)
	local offset = Vector(0,0,100)
	local pathtrace = QuickTrace(vOrigin + offset, targpos + offset, self)
	// DebugDrawLine_vCol(vOrigin+offset, targpos+offset,Vector(0,255,0), false, 2)

	if (pathtrace.hit == false) {
		WanderDest = targpos
	}
	else {
		// WanderDest = self.GetOrigin()
		FindWanderTarget()
	}
}



// bad idea?








function OnPostSpawn() {
	local tempa =
	// Setting up hitbox
	// hBossBase = SpawnEntityFromTable("base_boss", {
	// 	targetname = "Raxsei",
	// 	model = BRUSHMODELS["victim_hitbox"], // can only safely do this in onpostspawn
	// 	health = iHealth,
	// 	maxhealth = 99999,
	// })
	self.KeyValueFromString("targetname", UniqueName)
	hBossBase.SetModelSimple(HitboxModelName)
	hBossBase.AcceptInput("SetSpeed","0",null,null)
	hBossBase.AcceptInput("SetStepHeight","0",null,null)
	hBossBase.AcceptInput("SetMaxJumpHeight","0",null,null)
	hBossBase.SetResolvePlayerCollisions(false)
	// NetProps.SetPropBool(hBossBase, "m_bUseBossHealthBar", true)
	self.DisableDraw()
	// set up actual visible world model
	hVisual.SetAbsOrigin(self.GetOrigin())
	hVisual.SetAbsAngles(self.GetAbsAngles())
	hVisual.SetModelSimple(self.GetModelName())
	SetParentEX(hVisual,self)
	SetAnimation(hVisual, "idle")

	BossBaseSync()

	self.KeyValueFromInt("solid", 1)

	if (self.GetClassname() == "func_physbox" || self.GetClassname() == "func_physbox_multiplayer" ) { // are we a brush-based entity?
		hBossBase.SetModelScale(4,1)
	}

	self.SetCollisionGroup(Constants.ECollisionGroup.COLLISION_GROUP_DEBRIS)
	hBossBase.SetCollisionGroup(Constants.ECollisionGroup.COLLISION_GROUP_INTERACTIVE_DEBRIS)

	BossBaseSync()

	// SetParentEX(hBossBase, self)
	ListenHooks({
			function OnScriptHook_OnTakeDamage(params) {
				// printl("damage hook")

				if (params.const_entity == hBossBase && params.inflictor != null && params.inflictor.IsPlayer()) {
					// printl(__DumpScope(1, params))
					local iDamage = params.damage
					local activator = params.attacker

					iHealth -= params.damage
					QFireByHandle(hVisual, "Color", "255 0 0")
					QFireByHandle(hVisual, "Color", "255 255 255", 0.02)

					local vPlayerOrigin = activator.EyePosition()
					local vOrigin = self.GetOrigin()

					local DamageVec = GetMovementVector(vPlayerOrigin, vOrigin)


					// self.SetAbsOrigin(vOrigin + (iDamage * DamageVec))
					if (self.GetScriptThinkFunc() != "ActiveThink") {
						hTarget = params.inflictor
						Wake()
					}
					// iCurAccel *= 0.8
				}
			}
	})
// 	ListenHooks(
// {


// 	)

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

	// walking around and stuff


	if (Time() > iNextIdleActionTime) {
		iNextIdleActionTime = time + RandomInt(3,7)


		if (bIsWalking == true) { // entering idle stance
			bIsWalking = false
			SetAnimation(hVisual, "idle")
			// printl("stop walk")
		} else { // wandering around
			WanderTries = 0
			FindWanderTarget()
			SetAnimation(hVisual, "walk2handed")
			bIsWalking = true
			// printl("start walk")
		}
	}

	// Wandering movement logic
	if (bIsWalking == true) {
		local vAngles = self.GetAbsAngles()
		local vOrigin = self.GetOrigin()
		if (GetDistance2DSquared(vOrigin, WanderDest) < 1000) {
			WanderTries = 0
			FindWanderTarget()
		}

		local movespeed = 0.4
		local AngToPos = GetAngleTo(WanderDest, vOrigin)

		self.SetAbsAngles((QuaternionSlerp(vAngles.ToQuat(), (AngToPos).ToQuat(), 0.1)).ToQAngle());
		local vNextOrigin = vAngles.Forward() * movespeed


		/// this code works :D \/\/\/\/\/\/
		vNextOrigin += (self.GetForwardVector() * movespeed)


		local tOrigin = vOrigin + (vNextOrigin*2) + UpVec * 32

		local groundtrace = QuickTrace(tOrigin, tOrigin + (DownVec*96), self) // trace for the ground


		// DebugDrawLine_vCol(groundtrace.startpos, groundtrace.pos,Vector(0,255,0), false, 0.1)
		local facetrace = QuickTrace(tOrigin, tOrigin + vAngles.Forward()*60, self, MASK_SHOT_PORTAL)
		// DebugDrawLine_vCol(facetrace.startpos, facetrace.pos, Vector(255,0,0), false, 0.1)

		if (groundtrace.hit == false || facetrace.hit == true && facetrace.enthit == Entities.First()) {
			vNextOrigin *= 0 // reverse the planned movement

			vAngles.y += RandomInt(0, 360)
			self.SetAbsAngles(vAngles) // rotate to get outselves out of this situation
			iObstacles++ // increase obstacles counter
		}
		else {

			vNextOrigin = (groundtrace.pos - vOrigin) + MikuOffset
		}
		// do the movement!
		self.KeyValueFromVector("origin", vOrigin + vNextOrigin)
		/// this code works :D ^^^^^
	}








	if (time >= iSleepNextExpireTime) { // apoptosis
		// hVisual.Kill()
		// hVisualSleeping.Kill()
		self.Kill()
		return
	}

	local vOrigin = self.GetOrigin()
	// if (Retarget()) {
	// 	Wake()
	// }

	return 0.01
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

	if (!(ValidEntity(hTarget) && hTarget.IsAlive() && hTarget.GetTeam() == TEAMS.HUMANS) || iObstacles > iMaxObstacles) { // verify if target is valid, if not then retarget

		if (!Retarget()) {
			Sleep()
		}
		return
	}
	// printl("pass")

	local time = Time()

	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()
	local vNextOrigin = vZero




	local vPlayerOrigin = hTarget.EyePosition() // trying out eyepos to see if it looks better
	local vPlayerAngles = hTarget.GetAbsAngles()

	// player interaction code

	// if (time >= iNextAttackTime) {
		// iNextAttackTime = time + iAttackCooldown
		// for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, iAttackRadius);) {
			// printl("KILL "+ply.tostring())
			// ply.TakeDamage(iAttackDamage + RandomInt(-5, 5), Constants.FDmgType.DMG_DISSOLVE, hBossBase)
		// }

	// }

	if (time >= iNextAggroSoundTime) { // annoying\
		iNextAggroSoundTime = time + iNextAggroSoundWait
		RandomScream()

	}







	// movement code

	if (iCurAccel < iMaxAccel) { // calcualte acceleration


		// iCurAccel = clamp((iCurAccel + clamp((iCurAccel * (iAccelRate)), 0.1, iAccelRate)), -iMaxAccel, iMaxAccel)/iMaxAccel
		iCurAccel = clamp(iCurAccel + iAccelRate/iMaxAccel, -1, 1)

	}

	iCurAccel *= 0.9


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
	self.SetAbsAngles((QuaternionSlerp(vAngles.ToQuat(), (RotateOrientation(AngToPlayer, QAngle(0,180,0))).ToQuat(), 0.07)).ToQAngle());


	local vMoveVec = GetMovementVector(vPlayerOrigin, vOrigin)

	// scale movement speed with player distance
	local iMercyMult = clamp(GetDistance(vOrigin, vPlayerOrigin) * iMercyDistanceMult, 0.5, 1)


	local movespeed = clamp(iFollowSpeed * iMercyDistanceMult, iMinFollowSpeed, iFollowSpeed) * easeInBack(iCurAccel)


	// create the next movement vector



	/// this code works :D \/\/\/\/\/\/
	vNextOrigin += (self.GetForwardVector() * movespeed)


	local tOrigin = vOrigin + (vNextOrigin*2) + UpVec * 32

	local groundtrace = QuickTrace(tOrigin, tOrigin + (DownVec*128), self) // trace for the ground


	// DebugDrawLine_vCol(groundtrace.startpos, groundtrace.pos,Vector(0,255,0), false, 0.1)
	local facetrace = QuickTrace(tOrigin, tOrigin + vAngles.Forward()*60, self, MASK_SHOT_PORTAL)
	// DebugDrawLine_vCol(facetrace.startpos, facetrace.pos, Vector(255,0,0), false, 0.1)

	if (groundtrace.hit == false || facetrace.hit == true && facetrace.enthit == Entities.First()) {
		vNextOrigin *= 0 // reverse the planned movement

					vAngles.y += RandomInt(0, 360)

		self.SetAbsAngles(vAngles) // rotate to get outselves out of this situation
		iObstacles++ // increase obstacles counter
	}
	else {

		vNextOrigin = (groundtrace.pos - vOrigin) + MikuOffset
	}
	// do the movement!
	self.KeyValueFromVector("origin", vOrigin + vNextOrigin)
	/// this code works :D ^^^^^



	BossBaseSync()


	return iActiveDelta

}

function Retarget() {
	iObstacles = 0 // reset obstacles now that we have a new target
	local vOrigin = self.GetOrigin()

	for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, iAlertRadius);) {
		if (ply.GetTeam() == TEAMS.HUMANS && ply.IsAlive()) {
			hTarget = ply
			return true
		}
		else {
			hTarget = RandomCT()
		}
	}
	return false
}

function Sleep() {

	EnableMotion(self)
	iSleepNextExpireTime = Time() + iSleepExpireTime

	AddThinkToEnt(self, "SleepThink");
	SetAnimation(hVisual, "idle")


}

function RandomScream() {
	local screamstr = "eltra/72hr/mikuscream"+RandomInt(1,5).tostring()+".mp3"
	// PlaySoundEX(screamstr, self.GetOrigin(), 10, RandomInt(95, 105), self)
	PlaySoundNPC(screamstr, self)
	CleanString(screamstr)
}

function Wake() {
	// DisableMotion(self)
	AddThinkToEnt(self, "ActiveThink")
	SetAnimation(hVisual, "run2")

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
	if ("XMAS_VICTIMS" in getroottable()) {
		XMAS_VICTIMS++
	}
	local vOrigin = self.GetOrigin()
	for (local i = 0; i < RandomInt(3,5); i++) {
		Spawn("prop_dynamic", {
			model = "models/eltra/mexican_peso.mdl",
			vscripts = "eltrasnag/jam25/peso.nut"
			origin = vOrigin + Vector(RandomInt(-32,32),RandomInt(-32,32),10)
		})
	}

	SetAnimation(hVisual, "die_forwards")
	local vOrigin = self.GetOrigin()
	DoEffect(iDeathParticle,vOrigin, 0.5)
	PlaySoundNPC(SF_DEATH, self)
	SetAnimation(self, "die")
	QFireByHandle(self, "Kill", "", 1)
}

