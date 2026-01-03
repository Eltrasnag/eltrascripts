iHealth <- 5000

hTarget <- null
hProjectile <- null

ActiveRadius <- 4000
ScanRadius <- 256
ReturnRate <- 0.1
Moving <- true
BaseAngle <- self.GetAbsAngles()
vTarget <- Vector(0,0,0)
// turret settings
ReturnRate_Tracking <- 0.025
ReturnRate_Scanning <- 0.1
ScanSpeed <- 0.6
ScanAngle <- 80
ProjectileSpeed <- 2000
ProjectileExplodeRadius <- 512
ProjectileDamage <- 50
SineOffset <- RandomInt(1,250)

MarauderMode <- 0

HitboxModelName <- "marauder_turret_model"

TrackingRate <- 0.04

hBossBase <- Spawn("base_boss", {
	targetname = "npc_marauder_hurtbox",
	// model = BRUSHMODELS[HitboxModelName],
	model = "models/propper/eltra/weapon_marauder.mdl",
	// model = "models/error.mdl",
	health = 99999999,
	maxhealth = 99999999,
	width = 200,
})

Active <- true

WaitFlash <- 0
ShootProjectileTime <- 0
FlashWaitTime <- 0.4

UniqueName <- "npcMaurauder_"+UniqueString()
hLaserTarget <- Spawn("logic_relay", {targetname = UniqueName+"target",

})
hLaser <- null

function OnPostSpawn() {
	local spawnflagsint = 0
	if (XMODE)
		TrackingRate *= 3
		// ScanSpeed *= 2 // too unfair
		ScanRadius *= 2
		ScanAngle *= 2
	local context = GetContext(self)
	if ("beamtype" in context) {
		MarauderMode = context.beamtype
	}

	if ("active" in context && context.active == 0) {
		Active = false
	}

	if (MarauderMode == 0) {
		spawnflagsint = 1
	} else {
		spawnflagsint = 97
	}

	hLaser = Spawn("env_laser", {targetname = UniqueName+"laser",
		LightningStart = UniqueName+"laser",
		LaserTarget = UniqueName+"target",
		spawnflags = 97,
		texture = "sprites/laser.vmt",
		EndSprite = "sprites/redglow2.vmt",
		BoltWidth = 100,
		width = 20,
		rendercolor = "255 0 0",
		decalname = "hl2_leak/decals/smscorch3",

	})

	if (MarauderMode == 1) {
		hLaser.KeyValueFromInt("dissolvetype", 0)
		hLaser.KeyValueFromInt("damage", 30)
		hLaser.KeyValueFromInt("NoiseAmplitude", 5)

	}
	self.DisableDraw()
	self.SetSolid(Constants.ESolidType.SOLID_NONE)
	MarkForPurge(self)
	// self.KeyValueFromString("targetname", UniqueName) // breaks i/o system interactions, plus is un-needed
	hBossBase.AcceptInput("SetSpeed","0",null,null)
	hBossBase.AcceptInput("SetStepHeight","0",null,null)
	hBossBase.AcceptInput("SetMaxJumpHeight","0",null,null)
	hBossBase.ValidateScriptScope()
	hBossBase.SetOwner(self)
	hBossBase.GetScriptScope().BossBaseThink <- BossBaseThink

	// set up visuals
	hLaser.SetAbsOrigin(self.GetOrigin() + self.GetForwardVector() * 135)
	SetParentEX(hLaser, self)

	AddThinkToEnt(self, "Think")
	AddThinkToEnt(hBossBase, "BossBaseThink")
	ListenHooks({
		function OnScriptHook_OnTakeDamage(params) {
				if (params.const_entity == hBossBase && params.inflictor != null && params.inflictor.IsPlayer()) {

					local iDamage = params.damage
					local activator = params.attacker

					iHealth -= params.damage
					QFireByHandle(hBossBase, "color", "255 0 0")
					QFireByHandle(hBossBase, "color", "255 255 255", 0.075)
					local vPlayerOrigin = activator.EyePosition()
					local vOrigin = self.GetOrigin()

					// local DamageVec = GetMovementVector(vPlayerOrigin, vOrigin) // this npc doesn't move!

			}
		}
		function OnGameEvent_scorestats_accumulated_update(_) {
			if (ValidEntity(hLaser)) {
				// hLaser.AcceptInput("TurnOff", "", null, null)
				QAcceptInput(hLaser, "TurnOff")
				hLaser.Kill() // why does env_laser create persistent env_sprites!!!! is it stupid!!!

			}

		}
	})
}

// function ScanThink() {
// 	// scan for player

// }

function BossBaseThink() {
	self.SetAbsOrigin(self.GetOwner().GetOrigin())
	self.SetAbsAngles(self.GetOwner().GetAbsAngles())

	return -1
}

function Think() {
	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()
	local ply = Entities.FindByClassnameNearest("player", vOrigin, ActiveRadius)
	if (!Active || !ply ||!ValidEntity(hLaser)|| !ValidEntity(hLaserTarget)) {
		return 3
	}

	if (iHealth <= 0) {
		AddThinkToEnt(self, "")
		DoEffect("cic_explosion")
		hBossBase.Kill()
		QAcceptInput(hLaser, "TurnOff")
		hLaser.Kill()
		hLaserTarget.Kill()

		HalfLifeExplosion(self)
		QFireByHandle(self, "RunScriptCode", " HalfLifeExplosion(self) ", 0.5)
		QFireByHandle(self, "RunScriptCode", " HalfLifeExplosion(self) ", 1)

		QFireByHandle(self, "RunScriptCode", " HalfLifeExplosion(self) ", 1.75) // oh, the tension!
		QFireByHandle(self, "Kill", "", 1.75)
		return
	}
	// if (assert(ValidEntity(hBossBase))) {
		// hBossBase.SetForwardVector(self.GetForwardVector())
		// }
	PrecacheSound("ambient/machines/beam_platform_loop1.wav")
	EmitAmbientSoundOn("ambient/machines/beam_platform_loop1.wav", 100.0, 3.0, 100, self)

	ReturnRate = ReturnRate_Scanning
	local fronttrace = QuickTrace(vOrigin+ vAngles.Forward()*32, vOrigin + vAngles.Forward() * 9999, self)
	// DebugDrawLine_vCol(fronttrace.startpos, fronttrace.pos, Vector(255, 255, 255), false, 0.1)
	hLaserTarget.SetAbsOrigin(fronttrace.pos)

	local pitch = 15
	if (XMODE)
		pitch = 15 + (cos((3 * Time()) * ScanSpeed + SineOffset)*64)

	if (((!ValidEntity(hTarget)) || GetDistance2D(hTarget.EyePosition(), vOrigin) > ScanRadius || !hTarget.IsAlive())) {
		hTarget = null
		if ((ValidEntity(ply) && GetDistance2D(ply.GetOrigin(), vOrigin) < ScanRadius)) {
			hTarget = ply
		}
	}
	if (ValidEntity(hTarget)) { // tracking

		ReturnRate = ReturnRate_Tracking
		vTarget = hTarget.EyePosition()


		TrackPosition(self, vTarget, TrackingRate)
	} else { // idle behaviour
		local aang = QuaternionSlerp(vAngles.ToQuat(), QAngle(pitch, BaseAngle.y + sin(Time() * ScanSpeed + SineOffset) * ScanAngle, 0).ToQuat(), 0.04).ToQAngle()
		self.SetAbsAngles(aang)
	}

	if (!fronttrace.hit) {
		return ReturnRate
	}

	if (MarauderMode == 0) {

		hLaser.KeyValueFromString("rendercolor", "120 255 120")
		if (fronttrace.hit == true && fronttrace.enthit.GetClassname() == "player") {
			// printl("Kill you")
			PlaySoundEX("weapons/rocket/rocket_locked_beep1.wav", vOrigin)
			ShootProjectileTime = Time() + FlashWaitTime*4
			AddThinkToEnt(self, "ShootThink")
			hProjectile = Spawn("prop_dynamic", {solid = 0, model = "models/eltra/portal/props_bts/rocket.mdl", origin = vOrigin, angles = vAngles, modelscale = 2})
			return -1
		}
	} else {
		if (fronttrace.hit == true && fronttrace.enthit.GetClassname() == "player") {
			fronttrace.enthit.TakeDamage(6, Constants.FDmgType.DMG_DISSOLVE, hBossBase)
			IgnitePlayer(fronttrace.enthit)
		}
		// PlaySoundEX("ambient/energy/spark" + RandomInt(1, 5)+".wav", hLaserTarget.GetOrigin())
		PlaySoundEX("beams/beamstart5.wav", hLaserTarget.GetOrigin(), RandomInt(11,20), RandomInt(90,110))

		hLaser.KeyValueFromString("rendercolor", "255 0 0")
	}

	return ReturnRate
}

function ShootThink() {
	if ((Time()) < ShootProjectileTime) {
		if (Time()  > WaitFlash) {
			WaitFlash = Time() + FlashWaitTime
			PlaySoundNPC("weapons/rocket/rocket_locking_beep1.wav", self)

		}
		return 0.1
	}

	if (ValidEntity(hProjectile)) {

		local pOrigin = hProjectile.GetOrigin()
		local vNext = pOrigin + hProjectile.GetForwardVector() * (ProjectileSpeed * FrameTime())
		hProjectile.KeyValueFromVector("origin", vNext)
		local worldtrace = QuickTrace(vNext, vNext, self, MASK_ALL)
		if (worldtrace.hit) {
			HalfLifeExplosion(hProjectile)
			hProjectile.Destroy()
			local hEnt;
			while  (hEnt = Entities.FindByClassnameWithin(hEnt, "player", pOrigin, ProjectileExplodeRadius)) {
				hEnt.TakeDamage(ProjectileDamage, Constants.FDmgType.DMG_ACID, hBossBase)

			}
		}
	} else {
		hProjectile = null

		AddThinkToEnt(self, "Think")
		return -1
	}
	return 0.05
}

function InputFireUser1() { // marauder ON
	AddThinkToEnt(self, "Think")
	QAcceptInput(hLaser, "TurnOn")
	Active = true;
}

function InputFireUser2() { // marauder off
	AddThinkToEnt(self, "")
	QAcceptInput(hLaser, "TurnOff")
	Active = false;
}