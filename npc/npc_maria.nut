IncludeScript("eltrasnag/npc/npc_base.nut", this)
// NOTE: THIS NPC USES THE TF2 DAMAGE SYSTEM AND SHOULD BE SCALED AS SUCH!

SF_HIT <- "eltra/jumpscare_maria_marilla.mp3"
SF_DEATH <- "eltra/ra_die.mp3"
SF_AGGRESSION <- "eltra/fnaf_door_alert.mp3"
SF_MUSICBOX1 <- "eltra/puppet_song.mp3"
MDL_MUSIC_BOX <- "models/eltra/burgeria/eltra/musicbox.mdl"
PrecacheModel(MDL_MUSIC_BOX)
iHealth <- 1400;
iHealthBase <- self.GetHealth()
// Visuals
iBobDist <- 4 // distance to offset during hover
iBobSpeed <-  2.5 // speed of hover bobbing

// hVisual <- MakeParticleSystem("lois_master", false)
// hVisualSleeping <- MakeParticleSystem("lois_asleep", false)

iAttackCooldown <- 0.6;
iNextAttackTime <- 0;

iNextAggroSoundTime <- 0
// iNextAggroSoundTime <- 0

VisualAngleOffset <- QAngle(0,90,0)

// maria stuff
iTeleportWait <- 0.34
iNextTeleportTime <- 0
iVanishWait <- iTeleportWait*0.99
iNextVanishTime <- 0
tValidMariaAnimations <- ["pos1", "pos2", "pos3", "pos4","pos5","door"]
MariaAnimTableSize <- tValidMariaAnimations.len() - 1
iNextAggroSoundWait <- iTeleportWait

hMusicBox <- Spawn("prop_dynamic", {
	model = MDL_MUSIC_BOX,
	parent = self,
	origin = self.GetOrigin(),
	angles = self.GetAbsAngles()
})

hMaria <- Spawn("prop_dynamic", {
	model = self.GetModelName(),
	parent = self,
	origin = self.GetOrigin(),
	angles = self.GetAbsAngles()
})

hSound <- null
iDeathParticle <- "npc_gore01"

iAttackDamage <- 25

HitboxModelName <- BRUSHMODELS["maria_hitbox"]


hBossBase <- Spawn("base_boss", {
		targetname = "Maria",
		model = BRUSHMODELS["maria_hitbox"], // can only safely do this in onpostspawn
		// rendermode = 0,
		health = 99999999,
		maxhealth = 99999999,
	})
printl(hBossBase)

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
iFollowSpeed <- 128 // How fast should we follow player when fully accelerated
// iMinFollowSpeed <- 1000 // Speed we should slow down to when player is in "mercy" range

// Mercy
iMercyDistanceMult <- 0.1// multiplier for the mercy distance

// Acceleration
// iCurAccel <- 1

// iAccelRate <- 1 // How much to accelerate per tick
// iMaxAccel <- 2

UniqueName <- "NPC_MARIA_"+UniqueString()

vZero <- Vector(0,0,0)

function OnPostSpawn() {
	self.DisableDraw() // hide ourselves so the true maria model can do its work
	hMaria.DisableDraw() // hide ourselves so the true maria model can do its work

	// Setting up hitbox

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

				// iCurAccel *= 0.8
			}
		}

	})

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

	if (!ValidEntity(hTarget) || hTarget.IsAlive() == false || !hTarget.GetTeam() == TEAMS.HUMANS) { // verify if target is valid, if not then retarget
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
			EntSound(self, SF_HIT, 512)
			ply.TakeDamage(iAttackDamage + RandomInt(-5, 5), Constants.FDmgType.DMG_DISSOLVE, hBossBase)
			ScreenFade(ply, 255, 0, 0, 1, 1, 0.1, FFADE_IN) // too strong?

		}

	}

	if (time >= iNextAggroSoundTime) {
		iNextAggroSoundTime = time + iNextAggroSoundWait

		PrecacheSound(SF_AGGRESSION)
		// EmitAmbientSoundOn(SF_AGGRESSION, 10, 0.25, RandomInt(95,105), self)
	}





	if (time >= iNextVanishTime) {
		iNextVanishTime = iVanishWait + time
		hMaria.DisableDraw()
		SetAnimation(hMaria, tValidMariaAnimations[RandomInt(0, MariaAnimTableSize)])
	} else {
		hMaria.EnableDraw()
	}

	// movement code

	if (time >= iNextTeleportTime) {

		// PlaySoundNPC(SF_AGGRESSION,self)
		PlaySoundEX(SF_AGGRESSION, vOrigin)
		PlaySoundEX(SF_AGGRESSION, vOrigin)
		PlaySoundEX(SF_AGGRESSION, vOrigin)
		PlaySoundEX(SF_AGGRESSION, vOrigin)

		// PlaySoundEX(SF_AGGRESSION, vOrigin, 10, RandomInt(95,105), self)




		local AngToPlayer = GetAngleTo(vPlayerOrigin, vOrigin)


		local NextAngle;
		self.SetAbsAngles((QuaternionSlerp(vAngles.ToQuat(), AngToPlayer.ToQuat(), 0.8)).ToQAngle());


		local vMoveVec = GetMovementVector(vPlayerOrigin, vOrigin)

		local iMercyMult = clamp(GetDistance(vOrigin, vPlayerOrigin) * iMercyDistanceMult, 0.5, 1)


		local movespeed = iFollowSpeed


		// create the next movement vector
		vNextOrigin += (self.GetForwardVector() * movespeed)

		// do the movement!

		// self.KeyValueFromVector("origin", vOrigin + vNextOrigin)
		self.SetAbsOrigin(vOrigin + vNextOrigin)

		iNextTeleportTime = time + iTeleportWait
	}



	BossBaseSync()

	hMaria.SetAbsOrigin(self.GetOrigin())
	hMaria.SetAbsAngles(self.GetAbsAngles() - VisualAngleOffset)

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
	hSound <- AmbientGeneric(SF_MUSICBOX1, hMaria.GetOrigin(), 1024)
	hSound.AcceptInput("PlaySound","",null,null)
	hMusicBox.EnableDraw()
	hMusicBox.SetAbsOrigin(self.GetOrigin())
	hMusicBox.SetAbsAngles(self.GetAbsAngles())

	iSleepNextExpireTime = Time() +  iSleepExpireTime
	// hMaria.DisableDraw()

	AddThinkToEnt(self, "SleepThink");
	SetAnimation(hMaria, "box_1")


}

function Wake() {
	if (ValidEntity(hSound)) {
		hSound.AcceptInput("StopSound","",null,null)
		hSound.Destroy()
	}
	hMusicBox.DisableDraw()

	hMaria.EnableDraw()

	AddThinkToEnt(self, "ActiveThink")
	SetAnimation(hMaria, "pos1")

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

	hMaria.Kill()
	hMusicBox.Kill()
	if (ValidEntity(hSound)) {
		hSound.Kill()
	}
	local vOrigin = self.GetOrigin()
	DoEffect(iDeathParticle,vOrigin, 0.5)
	PlaySoundNPC(SF_DEATH, self)
	SetAnimation(self, "die")
	QFireByHandle(self, "Kill", "", 1)
}

