// NOTE: THIS NPC USES THE TF2 DAMAGE SYSTEM AND SHOULD BE SCALED AS SUCH!

iBeacons <- 4

iNextGrinchHealTime <- 0
HealWait <- 2

iGrinchStarthealth <- 0

SF_HIT <- "eltra/ra_hit.mp3"
SF_DEATH <- "eltra/ra_die.mp3"
SF_AGGRESSION <- "eltra/ra_spotted2.mp3"
vTrueZ <- self.GetOrigin().z + -100
hTarget <- null
iHealth <- 500;
iHealthAdd <- 1300
iHealthPerSegment <- 1
iHealthBarSegments <- 20
QModelOffset <- QAngle(0,-90,0)
vBossBaseOffset <- Vector(0,0,256)
// Visuals
iBobDist <- 4 // distance to offset during hover
iBobSpeed <-  2.5 // speed of hover bobbing
iHoverHeight <- 256
// hVisual <- MakeParticleSystem("lois_master", false)
// hVisualSleeping <- MakeParticleSystem("lois_asleep", false)
iTurnAccel <- 0.02
iObstacles <- 0
iMaxObstacles <- 10
ROTATE_ANGLE <- QAngle(0,45,0)
iNextRetargetTime <- 0
iThisAttack <- 1
iLastAttack <- -1



iAttackCooldown <- 0.01; // player damage logic cooldown
iNextAttackTime <- 0;
DownVec <- Vector(0,0,-1)
iNextBossAttack <- 0
iBossAttackWait <- 5
// iNextBossAttack <- 0

iDeathParticle <- "npc_gore01"

iAttackDamage <- 512
iAttackRadius <- 500

HitboxModelName <- BRUSHMODELS["grinch_hitbox"]


hBossBase <- SpawnEntityFromTable("base_boss", {
		targetname = "grinchhurtbox",
		model = BRUSHMODELS["grinch_hitbox"], // can only safely do this in onpostspawn // was htis lie
		health = 99999999,
		maxhealth = 99999999,
	})

// Time between returns in the ActiveThink function
iActiveDelta <- 0.05

// Gameplay

// If a player is within this radius, switch to ActiveThink mode
// iAlertRadius <- 256

// If we have waited this long without being activated, just kill ourselves
// iSleepExpireTime <- 100

// iSleepNextExpireTime <- 0

// Radius to attack players in

// Movement-Related Values
iFollowSpeed <- 1000 // How fast should we follow player when fully accelerated
iMinFollowSpeed <- 10 // Speed we should slow down to when player is in "mercy" range

// Mercy
iMercyDistanceMult <- 0.1// multiplier for the mercy distance

// Acceleration
iCurAccel <- 0

// iAccelRate <- 0.2 // How much to accelerate per tick
iMaxAccel <- 2

UniqueName <- "NPC_grinch_"+UniqueString()

vZero <- Vector(0,0,0)
iHealthMax <- 0
function HealthScale() {
	iHealth = 0
	for (local ply; ply = Entities.FindByClassname(ply, "player") ;) {
		if (ply.GetTeam() == TEAMS.HUMANS) {
			iHealth += iHealthAdd

		}
	}
	iHealthPerSegment = iHealth/iHealthBarSegments
	iHealthMax = iHealth
}

function OnPostSpawn() {
	// if (XMODE) {
	// 	iHealthAdd *= 1.5
	// }

	// Setting up hitbox
	// hBossBase = SpawnEntityFromTable("base_boss", {
	// 	targetname = "Raxsei",
	// 	model = BRUSHMODELS["ralsei_hitbox"], // can only safely do this in onpostspawn
	// 	health = iHealth,
	// 	maxhealth = 99999,
	// })

	// self.SetModelSimple("models/eltra/propper/ze_mariah_carey_christmas_massacre_v1/ginch.mdl")

	self.KeyValueFromString("targetname", "grinch")
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

				// iCurAccel *= 20
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
}


function Activate() {
	HealthScale()
	QFire("mus_grinch", "PlaySound")
	ze_map_say("*** - grinch - ***")
	AddThinkToEnt(self, "ActiveThink")
}

function SleepThink() {

	if (iHealth <= 0 || !ValidEntity(hBossBase)) {
		Death()
		return
	}

	BossBaseSync()


	local time = Time()


	local vOrigin = self.GetOrigin()
	if (Retarget()) {
		Wake()
	}

	return 1
}

function BossBaseSync() {
	hBossBase.SetAbsAngles(self.GetAbsAngles())
	hBossBase.SetAbsOrigin(self.GetOrigin() + vBossBaseOffset)
}

function ActiveThink() {

	if (iHealth <= 0 || !ValidEntity(hBossBase)) {
		Death()
		return
	}


	if (!ValidEntity(hTarget) || !hTarget.IsAlive() || !hTarget.GetTeam() == TEAMS.HUMANS || iObstacles > iMaxObstacles) { // verify if target is valid, if not then retarget
		if (!Retarget()) {
			// QFire("redwin", "RoundWin") // everyone died // this is kind of dangerous lets jsut let the plugin handle thsi scenario
		}
	}

	if (Time() >= iNextRetargetTime) {
		printl("BOSS RETARGET NOW")
		Retarget()
	}


	local time = Time()

	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()
	local vNextOrigin = vZero

	if (time >= iNextGrinchHealTime) {
		iNextGrinchHealTime = time + HealWait
		iHealth = clamp(iHealth + (iBeacons * 2200), 0, iHealthMax)
	}

	local vPlayerOrigin = hTarget.EyePosition() // trying out eyepos to see if it looks better
	local vPlayerAngles = hTarget.GetAbsAngles()

	// player interaction code

	if (time >= iNextAttackTime) { // grinch kills player by ejecting them from the map
		iNextAttackTime = time + iAttackCooldown
		for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, iAttackRadius);) {
			if (ply.GetTeam() != TEAMS.HUMANS) {
				continue;
			}
			if (ply != hTarget) {
				ply.TakeDamage(45, Constants.FDmgType.DMG_ACID, hBossBase)

			}
			// QFireByHandle(ply, "SpeakResponseConcept", "MP_CONCEPT_PLAYER_PAIN", 0.1)
			ScreenFade(ply, 255, 0, 0, 25, 0.5, 0.09, FFADE_IN)
			// ply.SetAbsOrigin(vLerp(ply.GetOrigin(), vOrigin + Vector(0,0,500), 0.1))
			local porigin = ply.EyePosition()
			local maptrace = QuickTrace(porigin, porigin, ply, MASK_SOLID_BRUSHONLY) // if we have put the player out of the map bounds, it's time for the kill
			if (maptrace.hit) {
				ply.TakeDamage(10000, Constants.FDmgType.DMG_ACID, hBossBase)
			}
		}

	}

	// *BOSS* attack code
	if (iThisAttack != iLastAttack) { // do attack behaviours
		SetAnimation(self, "idle")
		iFollowSpeed = 1200
		iTurnAccel = 0.3
		switch (iThisAttack) {
			case 0:
				// vOrigin = vPlayerOrigin + Vector(0, 0, 1000)
				break;
				case 1:
				iFollowSpeed = 250
				iTurnAccel = 0.001

			break;


			case 2:

			break;
			case 3:
			break;
			case 4:
			break;
		}
	}
	iLastAttack = iThisAttack



	EBossBar(iHealth, iHealthPerSegment, iHealthBarSegments)

	if (time >= iNextBossAttack) { // annoying
		iNextBossAttack = time + iBossAttackWait
		// PlaySoundEX(SF_AGGRESSION, vOrigin, 10, RandomInt(95,105), self)
		iThisAttack = RandomInt(0,4)
		// PrecacheSound(SF_AGGRESSION)
	}







	// movement code

	// if (iCurAccel < iMaxAccel) { // calcualte acceleration


	// 	// iCurAccel = clamp((iCurAccel + clamp((iCurAccel * (iAccelRate)), 0.1, iAccelRate)), -iMaxAccel, iMaxAccel)/iMaxAccel
	// 	iCurAccel = clamp(iCurAccel + iAccelRate/iMaxAccel, -1, 1)

	// }

	// iCurAccel *= 0.9

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
	self.SetAbsAngles((QuaternionSlerp(vAngles.ToQuat(), (AngToPlayer+ QModelOffset).ToQuat(), iTurnAccel)).ToQAngle());


	local vMoveVec = GetMovementVector(vPlayerOrigin, vOrigin)

	// scale movement speed with player distance
	local iMercyMult = clamp(GetDistance(vOrigin, vPlayerOrigin) * iMercyDistanceMult, 0.5, 1)

	// printl("Mercy mult: "+iMercyDistanceMult.tostring())

	local movespeed = 15

	// printl("speed "+movespeed.tostring())

	// create the next movement vector
	vNextOrigin += (vAngles.Left() * movespeed)


	local tOrigin = vOrigin + vNextOrigin + UpVec * 32
	local groundtrace = QuickTrace(tOrigin, tOrigin + (DownVec*64), self, MASK_SOLID_BRUSHONLY)

	// DebugDrawLine_vCol(groundtrace.startpos, groundtrace.pos,Vector(0,255,0), false, 0.1)
	// local facetrace = QuickTrace(tOrigin, tOrigin + vAngles.Forward()*10, self)
	// DebugDrawLine_vCol(facetrace.startpos, facetrace.pos, Vector(255,0,0), false, 0.1)

	// if ( (facetrace.hit == true)) {
		// vNextOrigin *= -1 // reverse the planned movement
		// self.SetAbsAngles(vAngles + ROTATE_ANGLE) // rotate to get outselves out of this situation
		// iObstacles++ // increase obstacles counter
		// }
		if (iThisAttack == 1) {
			vOrigin.z = vTrueZ + abs((sin(time * 1)) * 500)

		// vNextOrigin = groundtrace.pos - vOrigin
		} else {

		vOrigin.z = LerpFloat(vOrigin.z, hTarget.GetOrigin().z + 512, 0.1)
		}
	// do the movement!
	// }
	self.KeyValueFromVector("origin", vOrigin - vNextOrigin)



	BossBaseSync()


	return iActiveDelta

}

function Retarget() { // previous method was flawed and would always return the same player
	iNextRetargetTime = Time() + RandomInt(5,15)
	iObstacles = 0 // reset obstacles now that we have a new target
	local vOrigin = self.GetOrigin()

	local ply = RandomCT()

	if (ply && ply.IsAlive()) {
		hTarget = ply
	}

	return true // ?
}

function Sleep() {

	// EnableMotion(self)
	// // iSleepNextExpireTime = Time() +  iSleepExpireTime

	// AddThinkToEnt(self, "SleepThink");
	// SetAnimation(self, "idle")


}

function Wake() {
	// DisableMotion(self)

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
	QFireByHandle(self, "FireUser1")
	local vOrigin = self.GetOrigin()
	DoEffect(iDeathParticle,vOrigin, 0.5)
	PlaySoundNPC(SF_DEATH, self)
	SetAnimation(self, "die")
	QFireByHandle(self, "Kill", "", 1)
}

