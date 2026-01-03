IncludeScript("eltrasnag/npc/npc_base.nut", this)
// NOTE: THIS NPC USES THE TF2 DAMAGE SYSTEM AND SHOULD BE SCALED AS SUCH!


iHealth <- 1000;
iHealthBase <- self.GetHealth()
// Visuals
iBobDist <- 4 // distance to offset during hover
iBobSpeed <-  2.5 // speed of hover bobbing

hVisual <- MakeParticleSystem("lois_master", false)
hVisualSleeping <- MakeParticleSystem("lois_asleep", false)

iAttackCooldown <- 0.6;
iNextAttackTime <- 0;

iAttackDamage <- 25

HitboxModelName <- GetBrushModel(self)

hBossBase <- Spawn("base_boss", {
		targetname = "Lois",
		model = HitboxModelName,
		health = iHealth,
		maxhealth = 99999,
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
iFollowSpeed <- 60 // How fast should we follow player when fully accelerated
iMinFollowSpeed <- 10 // Speed we should slow down to when player is in "mercy" range

// Mercy
iMercyDistanceMult <- 0.1// multiplier for the mercy distance

// Acceleration
iCurAccel <- 0

iAccelRate <- 0.2 // How much to accelerate per tick
iMaxAccel <- 2



vZero <- Vector(0,0,0)

function OnPostSpawn() {

	// Setting up hitbox




	hBossBase.SetModelSimple(HitboxModelName)
	hBossBase.AcceptInput("SetSpeed","0",null,null)
	hBossBase.AcceptInput("SetStepHeight","0",null,null)
	hBossBase.AcceptInput("SetMaxJumpHeight","0",null,null)
	hBossBase.SetResolvePlayerCollisions(false)
	NetProps.SetPropBool(hBossBase, "m_bUseBossHealthBar", true)
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


				local vPlayerOrigin = activator.EyePosition()
				local vOrigin = self.GetOrigin()

				local DamageVec = GetMovementVector(vPlayerOrigin, vOrigin)

				// self.SetAbsOrigin(vOrigin + (iDamage * DamageVec))

				iCurAccel *= 0.8
			}
		}

	})

	// self.SetHealth(iHealth) // bad idea do connect input instead
	self.ConnectOutput("OnTakeDamage", "OnTakeDamage")
	local vOrigin = self.GetOrigin()

	hVisual.SetAbsOrigin(vOrigin)
	hVisualSleeping.SetAbsOrigin(vOrigin)

	SetParentEX(hVisual,self)
	SetParentEX(hVisualSleeping,self)

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
		hVisual.Kill()
		hVisualSleeping.Kill()
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

	if (!ValidEntity(hTarget) || !hTarget.IsAlive() || !hTarget.GetTeam() == TEAMS.HUMANS) { // verify if target is valid, if not then retarget
		if (!Retarget()) {
			Sleep()
		}
	}

	local time = Time()

	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()

	// player interaction code

	if (time >= iNextAttackTime) {
		iNextAttackTime = time + iAttackCooldown
		for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, iAttackRadius);) {
			printl("KILL "+ply.tostring())
			ply.TakeDamage(iAttackDamage + RandomInt(-5, 5), Constants.FDmgType.DMG_DISSOLVE, hBossBase)
		}

	}







	// movement code

	if (iCurAccel < iMaxAccel) { // calcualte acceleration


		iCurAccel = clamp((iCurAccel + clamp((iCurAccel * (iAccelRate)), 0.01, iAccelRate)), -iMaxAccel, iMaxAccel)

	}

	iCurAccel *= 0.9

	printl("Current Accel: "+iCurAccel.tostring())


	local vNextOrigin = vZero

	local vPlayerOrigin = hTarget.EyePosition() // trying out eyepos to see if it looks better
	local vPlayerAngles = hTarget.GetAbsAngles()

	local vMoveVec = GetMovementVector(vPlayerOrigin, vOrigin)

	// scale movement speed with player distance
	local iMercyMult = clamp(GetDistance(vOrigin, vPlayerOrigin) * iMercyDistanceMult, 0.5, 1)

	printl("Mercy mult: "+iMercyDistanceMult.tostring())

	local movespeed = clamp(iFollowSpeed * iMercyDistanceMult, iMinFollowSpeed, iFollowSpeed) * iCurAccel

	printl("speed "+movespeed.tostring())
	// create the next movement vector
	vNextOrigin += vMoveVec * movespeed

	// vNextOrigin *=
	// add a floaty effect bc orb
	vNextOrigin.z += sin(time * iBobSpeed)*iBobDist

	// vNextOrigin = VectorDivide(vNextOrigin, iActiveDelta) // compensate for think time interval

	// do the movement!
	self.KeyValueFromVector("origin", vOrigin + vNextOrigin)



	BossBaseSync()


	return iActiveDelta

}

function Retarget() {
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
	hVisual.AcceptInput("Stop", "", null, null);
	hVisualSleeping.AcceptInput("Start", "", null, null);


}

function Wake() {
	hVisual.AcceptInput("Start", "", null, null);
	hVisualSleeping.AcceptInput("Stop", "", null, null);
	DisableMotion(self)
	AddThinkToEnt(self, "ActiveThink")

}

function OnTakeDamage() {


}

function BaseBossHealthSync() {
	iHealth = hBossBase.GetHealth()

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

	hVisual.Kill()
	hVisualSleeping.Kill()
	self.Kill()
}