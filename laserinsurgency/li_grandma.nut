
// LASERINSURGENCY - GRANDMA (THE DELTARUNE BOSS)
// CAN BE DEFEATED IN TWO WAYS: VIA LOWERING HER HEALTH TO ZERO, OR OUTLASTING HER BULLET PATTERNS


// const SND_BOSSMUSIC = "music/eltra/li_boss01.mp3"
SND_BOSSMUSIC <- "music/eltra/deltabattle.mp3"
SND_INTROMUSIC <- "music/eltra/grandma_intro.mp3"
SND_PHASE2MUSIC <- "music/eltra/li_boss01.mp3"
SND_LASER <- "eltra/deltalaser.mp3"
BOSS_MAX_HEALTH <- 100
SND_HURT <- "eltra/li_grandma_hit01.mp3"
SND_DELTASTART <- "eltra/deltastart.mp3"
SND_DELTAHIT <- "eltra/deltahit.mp3"
SND_DELTADAMAGE <- "eltra/deltadamage.mp3"
SND_DELTABREAK <- "eltra/deltabreak.mp3"
MDL_GRANDMA <- "models/eltra/li_grandma_boss.mdl"
MDL_DELTASOUL <- "models/eltra/deltasoul.mdl"
MDL_DELTASOUL_Z <- "models/eltra/deltasoul_z.mdl"
MDL_DELTASLAPPER <- "models/eltra/deltaslapper.mdl"
MDL_DELTABULLET <- "models/eltra/deltabullet.mdl"
SND_NOISE <- "eltra/deltanoise.mp3"
SND_DEATH <- "eltra/grandma_death.mp3"

HP_PER_PLAYER <- 10

// PHASE LENGTHS
const GPHASE_1_LENGTH = 1500
const GPHASE_2_LENGTH = 3280

hBossText <- null;

hBulletMaker <- Entities.FindByName(null, "boss_grandma_bullettemplate")

::DELTA_ACTIVE <- false
::vBattleOrigin <- Entities.FindByName(null, "deltabox").GetOrigin() + Vector(0,0,1);
vBattlePlayerOrigin <- Entities.FindByName(null, "deltabattle_boxtp").GetOrigin();
vBattleZombieOrigin <- Entities.FindByName(null, "deltabattle_zboxtp").GetOrigin();
vStartOrigin <- self.GetOrigin()

hModel <- null;

bDoHover <- true
bHurtTick <- true

const BASE_HOVER_X = 256
const BASE_HOVER_Y = 30
const BASE_HOVER_SPEED = 3

iSineSpeed <- 3
iHoverDistanceX <- BASE_HOVER_X
iHoverDistanceY <- BASE_HOVER_Y

tDeltaPlayers <- {}

iHealth <- BOSS_MAX_HEALTH;
hMusic <- null;
hIntroMusic <- null;
bActive <- false;
BOSS_GRANDMA_ATTACKTIME <- 80

function OnPostSpawn() {

	self.SetCollisionGroup(1)
	if (DEV) {
		QFire("mus_grandma_intro","playsound", "", 0.0, null)
		QFire("player", "AddOutput", "origin " + Entities.FindByName(null, "dest_grandma").GetOrigin().ToKVString(), 0.0, null)
	}
	self.DisableDraw()
	self.KeyValueFromInt("solid", 2)
	hModel = SpawnEntityFromTable("prop_dynamic", {
		model = MDL_GRANDMA,
		origin = self.GetOrigin()+Vector(0,0,10),
		angles = self.GetAbsAngles(),
		parent = self,
		modelscale = 2.0
	})
	hModel.AcceptInput("SetParent","!activator", self, null)
	Granimate("idle01")
	AddThinkToEnt(self,"IdleThink")
}

function DisableBoxCollision() {
	PlaySoundEX(SND_NOISE, vBattleOrigin, 10, RandomFloat(96,98))
	iDeltaBoxState = DELTABOX.DISABLED
	QFire("deltabox*", "AddOutput", "rendercolor 115 115 115", 0.0, null)
	QFire("deltabox*", "AddOutput", "solid 0", 0.0, null)
	QFire("deltabox_cheatertp", "Disable", "", 0.0, null)
}

function EnableBoxCollision() {

	PlaySoundEX(SND_NOISE, vBattleOrigin, 10, RandomFloat(96,98))
	iDeltaBoxState = DELTABOX.ENABLED
	QFire("deltabox*", "AddOutput", "rendercolor 255 255 255", 0.0, null)
	QFire("deltabox*", "AddOutput", "solid 6", 0.0, null)
	QFire("deltabox_cheatertp", "Enable", "", 0.0, null)
}

function StartIntro() {


	// hIntroMusic = MakeMusic(SND_INTROMUSIC)

	QFireByHandle(hIntroMusic, "PlaySound","", 0.1, null, null)
	// hIntroMusic.AcceptInput("PlaySound","",null,null)
	// DoDialogueArray(["1","2 22222222222","fuck 3"],"grandma")
	// DoDialogue("Inshallah you will be killed","grandma")
	MapSayArray(["SO. YOu want to get across the river.", "If you do that Inshallah they will kill you","If you truly wish to continue, you must prove to me that you are Strong enough to Withstand the Diabolical Natures and Trickeries on the other side.","We fight."],"grandma")

	QFire("deltabattle_intro","trigger","",0,null)
	QFire("mus_grandma_intro","fadeout","4",7,null)
	QFireByHandle(self, "RunScriptCode", "DeltaStart()",10,null,null)

}

strGranimation <- ""

::DeltifyPlayer <- function(hPlayer) {
	hPlayer.SetCollisionGroup(23)
	hPlayer.DisableDraw()

	local hSoul = SpawnEntityFromTable("prop_dynamic", {
		targetname = "DELTASOUL_"+UniqueString(),
		model = MDL_DELTASOUL,
		origin = hPlayer.GetOrigin(),
		angles = "0 0 0",
		rendercolor = Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255))
		parent = hPlayer
	})
	if (hPlayer.GetTeam() == TEAMS.HUMANS) {
		PrecacheModel(MDL_DELTASOUL)
		hSoul.SetModel(MDL_DELTASOUL)
	}

	if (hPlayer.GetTeam() == TEAMS.ZOMBIES) {
		PrecacheModel(MDL_DELTASOUL_Z)
		hSoul.SetModel(MDL_DELTASOUL_Z)
	}

	hSoul.AcceptInput("SetParent", "!activator", hPlayer, null)
	tDeltaPlayers[hPlayer] <- hSoul
}

function Granimate(strAnimation = "idle01") {
	if (strAnimation != strGranimation) {
		strGranimation = strAnimation
		printl("granimating")
		hModel.AcceptInput("SetAnimation", strAnimation, null,null)
	}
}

function DeltaStart() {
	local hStartSnd = MakeMusic(SND_DELTASTART)

	hStartSnd.AcceptInput("PlaySound","",null,null)

	hStartSnd.Kill()
	QFireByHandle(self, "RunScriptCode", "StartEncounter()",1.0,null,null)



	QFire("deltabattle_tower","break","",0,null)
	QFire("deltagrid","enable","",1,null)
	QFire("deltabox","enable","",1,null)
	self.SetAbsAngles(QAngle(-90,180,0))
	// hModel.SetModelScale(2,0.5)

	for (local hPlayer; hPlayer = Entities.FindByClassname(hPlayer, "player");) {
		QFire("deltacam","enable","",0,hPlayer)
		hPlayer.SetAbsAngles(QAngle(0,0,0))
		hPlayer.SnapEyeAngles(QAngle(0,0,0))
		DeltifyPlayer(hPlayer)
		switch (hPlayer.GetTeam()) {
			case TEAMS.ZOMBIES:
				hPlayer.SetAbsOrigin(vBattleZombieOrigin + Vector(0, 0, 0.1))
				break;
			case TEAMS.HUMANS:
				hPlayer.SetAbsOrigin(vBattlePlayerOrigin + Vector(0,0,0.1))
				break;
			default:
				break;

		}

	}


}





function StartEncounter() {
	// DoBossScale()
	hBossText = SpawnEntityFromTable("game_text", {
		color = "247 84 245",
		fadein = 0,
		fadeout = 0,
		holdtime = 1,
		effect = 0,
		channel = 4,
		x = -1,
		y = 0.25,
		spawnflags = 1,
	})

	NetProps.SetPropInt(self, "m_iMinHealthDmg", 1)

	self.ConnectOutput("OnTakeDamage", "OnTakeDamage")
	hMusic = MakeMusic("#"+SND_BOSSMUSIC)

	hMusic.AcceptInput("PlaySound", "", null, null);

	bActive = true;
	self.SetAbsOrigin(vStartOrigin)
	AddThinkToEnt(self,"BossThink")
	Phase1()
}

function IdleThink() {
	local vOrigin = self.GetOrigin()
	local vAngles = self.GetAbsAngles()

	local vHoverOrigin = vStartOrigin + (vAngles.Up() * sin(Time() * iSineSpeed * 0.5) * 16)
	self.KeyValueFromVector("origin", vHoverOrigin )
}

enum GRANDMA_PHASES {
	PHASE_IDLE,
	PHASE_INTRO,
	PHASE_MAIN,
	PHASE_FINALE,
	PHASE_DEAD,
	PHASE_FINISHED,

}
iGPhase <- GRANDMA_PHASES.PHASE_INTRO
iGShootTimer <- 0

const MAX_GRANDMA_ATTACKS = 3
enum GRANDMA_ATTACKS { // attack enums
	ATTACK_IDLE,
	ATTACK_SHOOT,
	ATTACK_SLAPPERS,
	ATTACK_SPRAY,
	ATTACK_SPRAY_B,
	ATTACK_LASER,
	ATTACK_LASERSPRAY,
}

enum GRANIMATIONS { //
	ATTACK_IDLE = "idle_subtle",
	ATTACK_SHOOT = "LineIdle03",
	ATTACK_SLAPPERS = "breen_playerRelease",
	ATTACK_SPRAY = "jump_holding_glide",
	ATTACK_LASER = "Idle_Relaxed_SMG1_6",
	ATTACK_LASERSPRAY = "Idle_Relaxed_SMG1_6",

}

iAttackTimer <- 0
iCurrentAttack <- 0
bAttackFinished <- false

strGranimation <- GRANIMATIONS.ATTACK_IDLE;

iTimerPhase1 <- 0
iTimerPhase2 <- 0
iTimerPhase3 <- 0


enum DELTABOX {
	ENABLED,
	DISABLED
}

iDeltaBoxState <- DELTABOX.ENABLED

const BOSS_GRANDMA_LASEROFFSET = 1024

bWellShitPreventer <- false
iZombieReleaseTimer <- 0
iNextZombieReleaseTime <- 800

function BossThink() {

	switch (iGPhase) {
		case GRANDMA_PHASES.PHASE_INTRO:
			hBossText.KeyValueFromString("message", "-= GRANDMA =-")
			break;
		case GRANDMA_PHASES.PHASE_MAIN:
			hBossText.KeyValueFromString("message", " -= GRANDMA =-\n|" + iHealth.tostring() + "|")

	}

	hBossText.AcceptInput("display", "", null, null)

	if (iGPhase == GRANDMA_PHASES.PHASE_DEAD && iGPhase != GRANDMA_PHASES.PHASE_FINISHED) {
		if (!bWellShitPreventer) {
			bWellShitPreventer = true
			iGPhase == GRANDMA_PHASES.PHASE_FINISHED
			hMusic.AcceptInput("Volume","0",null,null)

			AddThinkToEnt(self,"")
			QFireByHandle(self, "RunScriptCode", "PostBattle()", 4, null, null)
			MapSay("Well shit","grandma")
			return
		}
	}

	QFire("predicted_viewmodel*", "RunScriptCode", "self.DisableDraw()",0.0,null)



	for (local hPlayer; hPlayer = Entities.FindByClassname(hPlayer, "player");) {
		if (ValidEntity(hPlayer)) {

		}
			// if (!ButtonPressed(hPlayer, IN_FORWARD)) && (!ButtonPressed(hPlayer, IN_LEFT))
			// if (hPlayer.GetBaseVelocity().Length() < 3) {
				// hPlayer.SetAbsVelocity(Vector(0,0,0))
			// }
			if (ButtonPressed(hPlayer, IN_ATTACK)) {

			}

			switch (iDeltaBoxState) {
				case DELTABOX.ENABLED:
					hPlayer.SnapEyeAngles(QAngle(0,0,0))

					break;
				case DELTABOX.DISABLED:
					local qEyeAngles = hPlayer.EyeAngles()
					if (qEyeAngles.x != 0) {
						qEyeAngles.x = 0
						hPlayer.SnapEyeAngles(qEyeAngles)

					}

					break;
			}
			hPlayer.SetFriction(50)
			// hPlayer.SetGravity(0)
			local vPlayerOrigin = hPlayer.GetOrigin()
			vPlayerOrigin.z = vBattlePlayerOrigin.z
			hPlayer.KeyValueFromVector("origin",vPlayerOrigin)
			NetProps.SetPropBool(hPlayer, "m_bDrawViewmodel",false)
			NetProps.SetPropInt(hPlayer, "m_iHideHUD",4)
			if (NetProps.GetPropInt(hPlayer, "m_iHealth") < 1 && hPlayer in tDeltaPlayers) {

				tDeltaPlayers[hPlayer].SetSkin(1)
				PrecacheSound(SND_DELTABREAK)
				// EmitAmbientSoundOn(SND_DELTABREAK, 100, 0.27,100,hPlayer)
				PlaySound(SND_DELTABREAK, vPlayerOrigin, 1.0)
				local hSoul = tDeltaPlayers[hPlayer]

				QFireByHandle(hSoul, "Kill", "", 1, null, null)
				tDeltaPlayers.rawdelete(hPlayer)
			}

	}

	if (iGPhase != GRANDMA_PHASES.PHASE_FINISHED)
	{

		if (iZombieReleaseTimer >= iNextZombieReleaseTime) { // zombie release stuff
			printl("do zombie thing")
			switch (iDeltaBoxState) {
				case DELTABOX.ENABLED:
					iNextZombieReleaseTime = RandomInt(100, 260)
					DisableBoxCollision()
					break;
				case DELTABOX.DISABLED:
					for (local hPlayer; hPlayer = Entities.FindByClassname(hPlayer, "player");) {
						if (ValidEntity(hPlayer) && hPlayer.GetTeam() == TEAMS.ZOMBIES) {
							hPlayer.SetAbsOrigin(vBattleZombieOrigin + Vector(0,0,0.1))
						}
					}
					iNextZombieReleaseTime = RandomInt(400, 600)
					EnableBoxCollision()
					break;
				default:
					break;
			}
			iZombieReleaseTimer = 0
		}
		iZombieReleaseTimer++

		switch (bHurtTick) {
			case true:
				bHurtTick = false
				break;
			case false:
				bHurtTick = true
				break;
		}

		local vOrigin = self.GetOrigin()
		local vAngles = self.GetAbsAngles()
		local vHoverOrigin = vStartOrigin + (vAngles.Left() * (sin(Time() * iSineSpeed * 0.5) * iHoverDistanceX)) + (vAngles.Up() * sin(Time() * iSineSpeed * 0.1) * iHoverDistanceY)


		if (iAttackTimer >= BOSS_GRANDMA_ATTACKTIME * 0.75) {
			iCurrentAttack = GRANDMA_ATTACKS.ATTACK_IDLE // give players some respite between attacks
		}


		if (iAttackTimer >= BOSS_GRANDMA_ATTACKTIME) { // shuffle attacks choose
			bDoHover = true
			iAttackTimer = 0
			switch (iGPhase) {
				case GRANDMA_PHASES.PHASE_INTRO:
					iCurrentAttack = RandomInt(GRANDMA_ATTACKS.ATTACK_SHOOT, GRANDMA_ATTACKS.ATTACK_SPRAY)
					break;
				case GRANDMA_PHASES.PHASE_MAIN:
					iCurrentAttack = RandomInt(GRANDMA_ATTACKS.ATTACK_SHOOT, GRANDMA_ATTACKS.ATTACK_LASERSPRAY)
					break;
				case GRANDMA_PHASES.PHASE_IDLE:
					iCurrentAttack = GRANDMA_ATTACKS.ATTACK_IDLE
					break;
				case GRANDMA_PHASES.PHASE_FINALE:
					iCurrentAttack = GRANDMA_ATTACKS.ATTACK_IDLE
					break;
			}
			bAttackFinished = false
			iSineSpeed = BASE_HOVER_SPEED
			iHoverDistanceY = BASE_HOVER_Y
			iHoverDistanceX = BASE_HOVER_X

			// if (iCurrentAttack in tGranimations)
		}




		if (iGPhase == GRANDMA_PHASES.PHASE_INTRO && iTimerPhase1 >= GPHASE_1_LENGTH) { // phase logic
			iGPhase = GRANDMA_PHASES.PHASE_IDLE
			hMusic.AcceptInput("FadeOut","3", null, null)
			MapSayArray(["Alright bitches. Im not kitten around no more.","It's getting real."],"grandma")
			QFireByHandle(self, "RunScriptCode", "Phase2()", 5, null, null)
		}
		else {
			iTimerPhase1++
		}

		if (iGPhase == GRANDMA_PHASES.PHASE_MAIN && iTimerPhase2 >= GPHASE_2_LENGTH) { // took too long, just end the battle atp
			MapSay("Slow ass bitches I grant you my GrandMercy","grandma")
			iGPhase = GRANDMA_PHASES.PHASE_DEAD
		}
		else {
			iTimerPhase2++
		}

		if (iGPhase == GRANDMA_PHASES.PHASE_FINALE && iHealth < 0) {
		}
		else {
		}


		switch (iCurrentAttack) { // GRANDMA ATTACKS sk !!!!

			case GRANDMA_ATTACKS.ATTACK_SLAPPERS:
				Granimate(GRANIMATIONS.ATTACK_SLAPPERS)
				if (!bAttackFinished && bHurtTick) {
					bAttackFinished = true
					Attack_Slappers()
					iAttackTimer = BOSS_GRANDMA_ATTACKTIME * 0.95
				}
				break;



			case GRANDMA_ATTACKS.ATTACK_SHOOT:
				if (bHurtTick) {

					Granimate(GRANIMATIONS.ATTACK_SHOOT)
					iSineSpeed = 5
					iHoverDistanceY = 10
					iHoverDistanceX = 512

					SpawnBullet(vOrigin, vAngles.Up() * -1, 5, 2)
				}
				break;


			case GRANDMA_ATTACKS.ATTACK_SPRAY:
				Granimate(GRANIMATIONS.ATTACK_SPRAY)
				iHoverDistanceY = 512
				iHoverDistanceX = 512
				SpawnBullet(vOrigin, QAngle(0, sin(Time()) * 360, 0).Forward(), 6, 2)
				break;

			case GRANDMA_ATTACKS.ATTACK_SPRAY_B:
				Granimate(GRANIMATIONS.ATTACK_SPRAY)
				iHoverDistanceY = 0
				iHoverDistanceX = 512
				iSineSpeed = 5
				local qShootAngle = vAngles.Up() * -1
				if (bHurtTick) {
					SpawnBullet(vOrigin, qShootAngle, 8, 2)

				}
				else {
					SpawnLaser(vOrigin, qShootAngle, 8, 1, 2)
				}
				break;


			case GRANDMA_ATTACKS.ATTACK_LASERSPRAY: // red laser

				Granimate(GRANIMATIONS.ATTACK_LASERSPRAY)
				bDoHover = false
				self.SetAbsOrigin(vBattleOrigin)
				if (bHurtTick && iAttackTimer >= BOSS_GRANDMA_ATTACKTIME * 0.3 && iAttackTimer <= BOSS_GRANDMA_ATTACKTIME * 0.7) {
					local qLaserAngle = QAngle(0, sin(Time()) * 360, 0).Forward()
					iHoverDistanceY = 512
					iSineSpeed = 5
					iHoverDistanceX = 512
					SpawnLaser(vBattleOrigin + qLaserAngle * 16, QAngle(0, sin(Time()) * 360, 0).Forward(), 2, 2, 1).KeyValueFromString("rendercolor", "255 0 0")
				}
				break;


			case GRANDMA_ATTACKS.ATTACK_LASER: // laser circle
				Granimate(GRANIMATIONS.ATTACK_LASER)
				bDoHover = false
				if (bHurtTick && iAttackTimer >= BOSS_GRANDMA_ATTACKTIME * 0.2 && iAttackTimer <= BOSS_GRANDMA_ATTACKTIME * 0.6) {
					local vLaserOrigin = vBattleOrigin + Vector(RandomInt(-BOSS_GRANDMA_LASEROFFSET,BOSS_GRANDMA_LASEROFFSET), RandomInt(-BOSS_GRANDMA_LASEROFFSET,BOSS_GRANDMA_LASEROFFSET), 0)
					self.SetAbsOrigin(vLaserOrigin)
					local qLaserAngle = GetAngleTo(vBattleOrigin, vLaserOrigin)
					local flLaserTime = BOSS_GRANDMA_ATTACKTIME* 0.6 - iAttackTimer
					printl("Laser lifetime: "+ flLaserTime.tostring())
					SpawnLaser(self.GetOrigin(), Vector(qLaserAngle.Forward()), 6, flLaserTime * 0.05).SetAbsAngles(qLaserAngle)
				}
				break;



			default:
				Granimate(GRANIMATIONS.ATTACK_IDLE)
				break;
		}




		if (bDoHover) {

			self.KeyValueFromVector("origin", vHoverOrigin )
		}
		iAttackTimer++
		return 0.05
	}
	self.StudioFrameAdvance()
	return 0.5

}

function Phase1() {
	MapSayArray(["oh freak........... looks like u are really in it now!!!!","i dont know that bitch grandma that you're fighting but i c","oops my matcha is here BRB just survive"],"lois griffin")
	BOSS_GRANDMA_ATTACKTIME = 80
	iTimerPhase1 = 0
	hModel.SetModelScale(2,0.0)
	iGPhase = GRANDMA_PHASES.PHASE_INTRO
}

function Phase2() {
	DoBossScale()
	MapSayArray(["Okay guys im back","so i think to kill her you just need to shoot her","Yeap", "good luck :D"],"lois griffin")
	hMusic.Kill()
	hMusic = MakeMusic("#"+SND_PHASE2MUSIC)
	hMusic.AcceptInput("PlaySound", "", null, null)
	BOSS_GRANDMA_ATTACKTIME = 60
	iTimerPhase2 = 0
	iGPhase = GRANDMA_PHASES.PHASE_MAIN

}




function Attack_Slappers() {

	local hSlapper = SpawnEntityFromTable("prop_dynamic", {
		model = MDL_DELTASLAPPER,
		origin = vBattleOrigin,
		DefaultAnim = "slappers1"

	})
	local hLeftHurt = SpawnHurter(50)
	local hRightHurt = SpawnHurter(50)
	SetParentEX(hLeftHurt, hSlapper, "attach.left")
	SetParentEX(hRightHurt, hSlapper, "attach.right")

	KillDelayed(hSlapper, 6.16)
}


function OnTakeDamage() { // grandma takes dmg ouch

	if (bActive && activator.GetClassname() == "player" && iGPhase == GRANDMA_PHASES.PHASE_MAIN) { // ensure that it is player doing damage, not her own attack
		iHealth--
		hModel.SetModelScale(RandomFloat(2.5,2.2),0) // visual feedback
		hModel.SetModelScale(2,0.1)
		// hModel.AcceptInput("rendercolor", "255 0 0", null, null)
		hModel.KeyValueFromString("rendercolor", "255 0 0")
		QFireByHandle(hModel, "color", "255 255 255", 0.1, null, null)
		PlaySoundEX(SND_HURT, self.GetOrigin(), 2, RandomFloat(85,120))
		PlaySoundEX(SND_DELTADAMAGE, self.GetOrigin(), 5, RandomFloat(85,120))

		if (iHealth <= 0) {
			bActive = false
			iGPhase = GRANDMA_PHASES.PHASE_DEAD
		}
	}
}


function SpawnHurter(flDamage = 5, strModelName = "deltabullet_hitbox") {
	// local hHurt = SpawnEntityFromTable("point_hurt", {
	// 	spawnflags = 1,
	// 	DamageType = 4194304,
	// 	Damage = flDamage * 100,
	// 	DamageRadius = flRadius,
	// })

	local hHurt = SpawnEntityFromTable("trigger_hurt", {
		spawnflags = 1,
		damageType = 4194304,
		damage = flDamage * 2,
		// DamageRadius = flRadius,
		model = BRUSHMODELS[strModelName]
	})

	return hHurt
}

function SpawnBullet(vOrigin, qDirection, vSpeed = 5.0, iDamage = 80, flLifetime = 10.0) { // spawn a bullet
	vOrigin.z = vBattleOrigin.z
	PlaySoundEX(SND_NOISE, vOrigin, 5, RandomFloat(96,98))
	// local hBullet = hBulletMaker.SpawnEntityAtLocation(vOrigin, qDirection)

	local hBullet = SpawnEntityFromTable("prop_dynamic", {
		model = MDL_DELTABULLET,
		origin = vOrigin

	})
	// local hBulletHurter =
	SetParentEX(SpawnHurter(iDamage), hBullet, "bullet.attach")


	hBullet.SetForwardVector(qDirection)
	hBullet.ValidateScriptScope()
	local hScope = hBullet.GetScriptScope()

	hScope.vSpeed <- vSpeed
	hScope.BulletThink <- BulletThink
	hScope.qDirection <- qDirection

	AddThinkToEnt(hBullet,"BulletThink")

	KillDelayed(hBullet, flLifetime)
}

const MDL_DELTALASER = "models/eltra/deltalaser.mdl"

function SpawnLaser(vOrigin, qDirection, vSpeed = 2.0, flDelayTime = 1.0, iDamage = 2, flLifetime = 10.0) { // spawn a laser
	vOrigin.z = vBattleOrigin.z


	local hLaser = SpawnEntityFromTable("prop_dynamic", {
		model = MDL_DELTALASER,
		origin = vOrigin
		angles = "0 0 0"
	})
	hLaser.SetForwardVector(qDirection)
	SetParentEX(SpawnHurter(iDamage,"deltalaser_hitbox"), hLaser, "laser.attach")
	PlaySoundEX(SND_LASER, vOrigin, 5)


	hLaser.ValidateScriptScope()
	local hScope = hLaser.GetScriptScope()

	hScope.vSpeed <- vSpeed
	hScope.BulletThink <- BulletThink
	// hScope.qDirection <- qDirection

	QFireByHandle(hLaser, "RunScriptCode", "AddThinkToEnt(self,\"BulletThink\")", flDelayTime, null, null)

	KillDelayed(hLaser, flLifetime + flDelayTime)
	return hLaser
}

function BulletThink() {
	self.KeyValueFromVector("origin", self.GetOrigin() + self.GetForwardVector() * vSpeed)
	return -1
}

function DoBossScale() {
	local iPlayerCount = 0
	for (local i = null; i = Entities.FindByClassname(i, "player");) {
		if (i.GetTeam() == TEAMS.HUMANS) {
			iPlayerCount++
		}
	}
	iHealth = clamp(BOSS_MAX_HEALTH * (iPlayerCount / 16.0), 40, 2000)
}

function EndEncounter() { // clean up clean up everybody shake your hands
	QFire("predicted_viewmodel*", "RunScriptCode", "self.EnableDraw()",0.0,null)
	local aPlayers = tDeltaPlayers.keys()
	foreach (aPlayer in aPlayers) {
		if (ValidEntity(aPlayer)) {
			QFire("deltacam","disable","",0,aPlayer)
			aPlayer.SetCollisionGroup(8)
			aPlayer.EnableDraw()
			local hSoul = tDeltaPlayers[aPlayer]
			if (ValidEntity(hSoul)) {
				hSoul.Kill()
			}
		}
	}

}

function PostBattle() {
	Granimate("EliMossy_comfort_Post")
	bActive = false
	MapSayArray(["Well it appears you are stronger than I thought!", "You will do just fine ahead.","I'll get the boat ready, so you can cross the river. But for now, take some time to rest until I'm back.", "You've earned it."],"grandma")
	self.SetAbsOrigin(vStartOrigin)
	self.SetAbsAngles(QAngle(0,45,0))
	EndEncounter()
	AddThinkToEnt(self,"IdleThink")
	hModel.SetModelScale(2,0.0)
	QFire("deltagrid","Kill","",0,null)
	QFire("deltabox_cheatertp","Kill","",0,null)
	QFire("deltabox*","Kill","",0,null)
}