hOwner <- null // player which "owns" us

iHealth <- 4

fDmgMult <- 1.0 // xmode multiplier

iGraceLength <- 2.0 // grace period after taking damage

iScore <- 0

vLastOrigin <- Vector(0,0,0)
iInvulnerabilityEndTime <- 0
bInvulnerable <- false
iframe <- false // iframe flashing

vVelocity <- Vector(0,0,0)
vAcceleration <- Vector(0,0,0)

fAccel <- 10
fFriction <- 2

iSpeed <- 0
hOrb1 <- null
hOrb2 <- null
iDeadSine <- 0
iDieDestroy <- 0


CameraName <- null;
CameraENT <- null;

fAccelRate <- 0.7

vPlayerColor <- Vector(RandomFloat(150, 255),RandomFloat(150, 255),RandomFloat(150, 255))

TOUHOU_SHOOT_COOLDOWN <- 0.02

bReady <- false

TOUHOU_VIS_ORB_LERPSPEED <- 0.1
TOUHOU_ORB_SEPARATION <- 32 // orb separation distance during normal gameplay
TOUHOU_GUARD_ORB_SEPARATION <- 8 // orb separation distance when guarding
TOUHOU_ACCELRATE <- 20
TOUHOU_SPACE_MULTIPLIER <- 100

// camera config
TOUHOU_CAMERA_LERPSPEED <- 100
TOUHOU_CAMERA_HEIGHT <- 250


TOUHOU_ORB_ROTATESPEED <- 4// mult of the rotation sin&cos values // update so apparently this isnt what happens in the game // NVM i forgot they rotated on their own too
TOUHOU_ORB_OFFSET <- 12 // distance from player the orbs will float

mCharName <- "reimu"
aCharNames <- ["marisa", "reimu"]
iShootLevel <- 0

vWantVec <- Vector(0,0,0)

fPlayerSpeed <- 0.5
fDamageMult <- 1.0

bOddFire <- false


TOUHOU_ANG_ORBROTATE <- QAngle(0, TOUHOU_ORB_ROTATEANGLE, 0)

TOUHOU_CAM_OFFSET_VECTOR <- Vector(0, (TOUHOU_VEC_UP * 128) * (TOUHOU_CAMERA_HEIGHT * 0.25) * 20, TOUHOU_CAMERA_HEIGHT)

TOUHOU_SHOOT_OFFSET <- TOUHOU_VEC_UP*600 + TOUHOU_VEC_Z_DOWN * 6

function ShowHUDInfo() {
	local hTextInfo =	Spawn(CUBT_GAMETEXT, {
			color = TOUHOU_COLOR_HEALTH,
			fadein = 0.1,
			fadeout = 0.1,
			holdtime = 0.25,
			message = TOUHOU_HUD_HEALTH_STR+iHealth.tostring()+TOUHOU_HUD_BORDER_STR
			channel = 2,
			x = 0.7,
			y = 0.7,
			spawnflags = 0,
		})
		sPurge(hTextInfo)
		hTextInfo.AcceptInput(CUBT_DISPLAY, CUBT_NOSTRING, hOwner, null)
		QFireByHandle(hTextInfo, CUBT_KILL)


	local score =	Spawn(CUBT_GAMETEXT, {
			color = "0 0 255",
			fadein = 0.01,
			fadeout = 0.01,
			holdtime = 1,
			message = ("<< Score: "+iScore.tostring()+" >>")
			channel = 3,
			x = 0.2,
			y = 0.15,
			spawnflags = 0,
		})
		sPurge(score)
		score.AcceptInput(CUBT_DISPLAY, CUBT_NOSTRING, hOwner, null)
		QFireByHandle(score, CUBT_KILL)
}

function ShowGuarding() {
	local hTextInfo =	Spawn(CUBT_GAMETEXT, {
			color = "255 255 0",
			fadein = 0.1,
			fadeout = 0.2,
			holdtime = 0.1,
			message = "|| < PRECISION MODE > ||"
			channel = 3,
			x = -1,
			y = 0.9,
			spawnflags = 0,
		})
		sPurge(hTextInfo)
		hTextInfo.AcceptInput(CUBT_DISPLAY, CUBT_NOSTRING, hOwner, null)
		QFireByHandle(hTextInfo, CUBT_KILL)
}

// some visual stuff


scalemult <- 5000

hOrb1GuardOffset <- ((TOUHOU_VEC_UP * 25) + (TOUHOU_VEC_LEFT * TOUHOU_GUARD_ORB_SEPARATION))
hOrb2GuardOffset <- ((TOUHOU_VEC_UP * 25) + (TOUHOU_VEC_RIGHT * TOUHOU_GUARD_ORB_SEPARATION))

hOrb1Offset <- TOUHOU_VEC_LEFT * TOUHOU_ORB_OFFSET
hOrb2Offset <- TOUHOU_VEC_RIGHT * TOUHOU_ORB_OFFSET

bIsFiring <- false
bIsGuarding <- false

fNextShootTime <- 1

hClientProxy <- null
hNametag <- Spawn("point_worldtext", {
	orientation = 1,
	targetname = TOUHOU_PLAYER_TARGETNAME,
	message = "",
	textsize = 10,
	font = 0,
	color = vPlayerColor.ToKVString(),
	origin = self.GetOrigin() + (TOUHOU_VEC_Z_UP * RandomFloat(5, 6)) + (TOUHOU_VEC_UP * 22),
})

TOUHOU_VEC_P_INDICATOR <- self.GetOrigin() + (TOUHOU_VEC_Z_UP * 3) + (TOUHOU_VEC_UP * 22)

hIndicator <- null

mCurAni <- mCharName + TOUHOU_VIS_NORMAL
mLastCurAni <- null
mFlyLeft <- mCharName + TOUHOU_VIS_LEFT
mFlyRight <- mCharName + TOUHOU_VIS_RIGHT
mFlyNormal <- mCharName + TOUHOU_VIS_NORMAL

function Setup_MakeOrb() { // reimu spinning gun orbs or whatever
	local ent = Spawn(CUBT_FUNCBRUSH, {
		model = BRUSHMODELS[TOUHOU_ORB_MODELNAME],
		targetname = TOUHOU_PLAYER_TARGETNAME, // for easy cleanup
		spawnflags = 49153,
		disableshadows = true,
		// origin = self.GetOrigin(),
		modelscale = 2
	})
	// ent.SetModelScale(1.4,0)
	return ent
}

function OnPostSpawn() {
	// GetSetting()
	hOwner.ValidateScriptScope()
	self.SetAbsOrigin(TOUHOU_ORIGIN)
	local mdl = GetPreference(activator, "touhou")
	local scope = hOwner.GetScriptScope()
	if ("Settings" in scope && "touhou" in scope.Settings) {
		mCharName = aCharNames[scope.Settings.touhou]
	} else {
		mCharName = aCharNames[RandomInt(0, 1)]
	}
	TOUHOU_ENTITIES_LIMIT++

	ListenHooks({
	function OnGameEvent_scorestats_accumulated_reset(params) {
		if (!ValidEntity(self)) {
			return
		}
		if (ValidEntity(CameraENT)) {
			QFire(CameraName, "Kill", 0.01) // must have delay or player loses they viewmodels FOREVAR
		}
	}
	}	)

	// set player stuff
	// hOwner.SetMoveType(Constants.EMoveType.MOVETYPE_CUSTOM, Constants.EMoveCollide.MOVECOLLIDE_DEFAULT)

	self.KeyValueFromString("targetname", "TOUHOU_PLAYER_CHARACTER")

	SetParentEX(hNametag, self)

	hNametag.KeyValueFromString("message", GetPlayerName(hOwner))

	if (NetProps.GetPropString(hOwner, "m_szNetworkIDString") == ELTRA_STEAMID) {
		hNametag.KeyValueFromInt("rainbow", 1)
	}



	// make pointer ent
	hClientProxy = ClientProxy(hOwner)

	SetBrushModel(hClientProxy, "touhou_p_indicator")
	hClientProxy.SetAbsAngles(hClientProxy.GetAbsAngles() + QAngle(0,180,0))
	hClientProxy.SetOrigin(TOUHOU_VEC_P_INDICATOR)
	TOUHOU_ENTITIES_LIMIT++

	SetParentEX(hClientProxy, self)


	CameraENT = Touhou_MakeCam(self, hOwner)
	CameraName = CameraENT.GetName()
	TOUHOU_ENTITIES_LIMIT++

	SetViewControl(hOwner, CameraName, true)
	// printl("CameraEnt "+Camera)
	CameraENT.AcceptInput("Enable","",hOwner,null)
	hOwner.GetScriptScope().touhou_puppet <- self

	hOrb1 = Setup_MakeOrb()
	TOUHOU_ENTITIES_LIMIT++

	hOrb2 = Setup_MakeOrb()
	TOUHOU_ENTITIES_LIMIT++

	// mCharName = aCharNames[RandomInt(0,1)]
	// printl("bbbbbbbbb")


	SetInfo()

	AddThinkToEnt(self, "PlayerThink") // needs to always get called AFTER hOwner gets assigned.

}

function SetInfo() {
	mFlyLeft <- mCharName + TOUHOU_VIS_LEFT
	mFlyRight <- mCharName + TOUHOU_VIS_RIGHT
	mFlyNormal <- mCharName + TOUHOU_VIS_NORMAL
}

iHealthTime <- 0.05
iNextHealthTime <- 0

function PlayerThink() {

	// if (bReady == false) {
		// return
	// }

	if (!ValidEntity(hOwner) || hOwner.GetTeam() != TEAMS.HUMANS || !hOwner.IsAlive()  || hOwner.GetHealth() <= 0) {
		TouhouDeath()
		// printl("DEAD")
		return
	}


	// add player nullcheck here


	local fTime = Time()
	local vOrigin = self.GetOrigin()
	local delta = FrameTime()




	hOwner.SetHealth(999999)

	// hOwner.SetAbsOrigin(vOrigin)
	// MOVEMENT
	local vWant = Vector(0,0,0)

	if (ValidEntity(CameraENT)) {
		hOwner.SetAbsOrigin(CameraENT.GetOrigin() + TOUHOU_VEC_Z_UP * 20)
		local corigin = CameraENT.GetOrigin()
		local cwant;
		if (TOUHOU_CAMERALOCK) { // touhou trigger MUST cover camera area or bugs happen!
			TOUHOU_CAMERA_HEIGHT = 512
			cwant = TOUHOU_ORIGIN + TOUHOU_CAM_OFFSET_VECTOR
		} else {
			cwant = vOrigin + TOUHOU_CAM_OFFSET_VECTOR
		}

		local cdiff = cwant - corigin
		CameraENT.KeyValueFromVector("origin", corigin + (cdiff * 0.07))
	}
	// there must be a better way to do this
	// if (ButtonPressed(hOwner, IN_FORWARD) && ButtonPressed(hOwner, IN_MOVERIGHT)) {
		// vWant += (TOUHOU_VEC_UP + TOUHOU_VEC_RIGHT) * TOUHOU_DOTCONST;
	// } else if (ButtonPressed(hOwner, IN_BACK) && ButtonPressed(hOwner, IN_MOVERIGHT)) {
		// vWant += (TOUHOU_VEC_DOWN + TOUHOU_VEC_RIGHT) * TOUHOU_DOTCONST;
	// } else if (ButtonPressed(hOwner, IN_FORWARD) && ButtonPressed(hOwner, IN_MOVELEFT)) {
		// vWant += (TOUHOU_VEC_UP + TOUHOU_VEC_LEFT) * TOUHOU_DOTCONST;
	// } else if (ButtonPressed(hOwner, IN_BACK) && ButtonPressed(hOwner, IN_MOVELEFT)) {
		// vWant += (TOUHOU_VEC_DOWN + TOUHOU_VEC_LEFT) * TOUHOU_DOTCONST;
	local iButtons = 0

	// local taccel = fAccel
	local taccel = 1

	if (ButtonPressed(hOwner, IN_FORWARD)) {
		vWant += TOUHOU_VEC_UP;
		// printl("up")
		iButtons += 1
	}

	if (ButtonPressed(hOwner, IN_BACK)) {
		vWant += TOUHOU_VEC_DOWN;
		// printl("down")
		iButtons += 1
	}

	if (ButtonPressed(hOwner, IN_MOVELEFT)) {
		// printl("left")
		vWant += TOUHOU_VEC_LEFT;
		iButtons += 1
	}

	if (ButtonPressed(hOwner, IN_MOVERIGHT)) {
		// printl("right")
		vWant += TOUHOU_VEC_RIGHT;
		iButtons += 1
	}

	if (iButtons >= 2) {
		vWant *= TOUHOU_DOTCONST
	}




	// vWant *=  // add in the player speed to our movement vector

	// visual character logic

	mLastCurAni = mCurAni

	if (vWant.x < 0) { // player is going left
		mCurAni = mFlyLeft
	} else if (vWant.x > 0) { // player is going right
		mCurAni = mFlyRight
	} else { // player is not moving horizontally
		mCurAni = mFlyNormal
	}

	if (mLastCurAni != mCurAni) {
		switch (mCurAni) {
			case mFlyLeft:

				// SetBrushModel(self, mFlyLeft)
				SetBrushModel(self, mFlyLeft)
				// self.KeyValueFromString("model",mFlyLeft)
				break;
				case mFlyRight:
				// self.KeyValueFromString("model",mFlyRight)
				// SetBrushModel(self, mFlyRight)
				SetBrushModel(self, mFlyRight)
				break;
				case mFlyNormal:
				// self.KeyValueFromString("model",mFlyNormal)
				// SetBrushModel(self, mFlyNormal)
				SetBrushModel(self, mFlyNormal)
			break;
		}
	}



	// invuln stuff

	if (bInvulnerable) {

		if (iframe) {
			iframe = false
		} else {
			iframe = true
		}

		switch (iframe) {
			case true:
			self.DisableDraw()
			break;
			case false:
			self.EnableDraw()
			break;
		}

		if (fTime >= iInvulnerabilityEndTime) {
			bInvulnerable = false
			self.EnableDraw()
			// self.KeyValueFromInt("rendermode", 0)
		}

	}




	// orb logic

	local hOrb1Pos = hOrb1.GetOrigin()
	local hOrb2Pos = hOrb2.GetOrigin()

	if (ButtonPressed(hOwner, IN_ATTACK)) { // shooting
		if (fNextShootTime <= fTime) {
			fNextShootTime = TOUHOU_SHOOT_COOLDOWN + fTime

			if (bOddFire) {
				bOddFire = false
			} else {
				bOddFire = true
			}
			TPlayerShoot()


		}
	}

	local doAccelerate = true


	// orb and attack logic

	local o1wantvec = vOrigin
	local o2wantvec = vOrigin



	local orblerp = TOUHOU_VIS_ORB_LERPSPEED
	// orb movement and visual and lerp

	if (ButtonPressed(hOwner, IN_JUMP)) { // guarding
		bIsGuarding = true
		fPlayerSpeed = 0.7
		// doAccelerate = false
		// this will annihilate the server
		o1wantvec += hOrb1GuardOffset
		o2wantvec += hOrb2GuardOffset
		orblerp = 0.25
	} else {
		fPlayerSpeed = 1
		bIsGuarding = false
		orblerp = 1
		o1wantvec += hOrb1Offset
		o2wantvec += hOrb2Offset
	}

	o1wantvec = vLerp(hOrb1Pos, o1wantvec, orblerp)
	o2wantvec = vLerp(hOrb2Pos, o2wantvec, orblerp)

	hOrb1.KeyValueFromVector(CUBT_ORIGIN, o1wantvec )
	hOrb2.KeyValueFromVector(CUBT_ORIGIN, o2wantvec )

	// orb rotation
	hOrb1.SetAbsAngles(hOrb1.GetAbsAngles() + TOUHOU_ANG_ORBROTATE * TOUHOU_ORB_ROTATESPEED)
	hOrb2.SetAbsAngles(hOrb2.GetAbsAngles() + TOUHOU_ANG_ORBROTATE * -TOUHOU_ORB_ROTATESPEED)


	if (ButtonPressed(hOwner, IN_DUCK)) { // "sprint"
		// if (bIsGuarding) {
			// fPlayerSpeed = 0.5
		// }
		doAccelerate = false
		vVelocity *= 0
	}

	// collision tracing
	local stupidbitch = (vOrigin - ((vOrigin - vLastOrigin)*200)) + TOUHOU_VEC_Z_UP * 80
	// local MoveTrace = QuickTrace(vOrigin + TOUHOU_VEC_Z_UP * 80, stupidbitch, self, MASK_WATER) // check a little bit further than the direction player *wants* to go

	if (true) {
		// move player

		local norigin;


		// vWant = vLerp(Vector(0,0,0), vWant, fAccel * delta)

		// vVelocity = Vector(0,0,0)

		local rspeed = fPlayerSpeed * TOUHOU_BASESPEED
		vWant *= (rspeed)
		if (doAccelerate) {

			if (iButtons > 0) {

				vVelocity = vLerp(vVelocity, vWant, fAccel * delta)
			} else {
				vVelocity = vLerp(vVelocity, vWant, fFriction * delta)
			}
			norigin = vVelocity * (rspeed)

		} else {

			// iSpeed = 0
			norigin = (vWant * (rspeed))
		}

		local moving = -1

		// vVelocity
		// vVelocity.x += clamp(vVelocity.x + norigin.x * moving, -fPlayerSpeed * TOUHOU_BASESPEED, 50)
		// vVelocity.y = clamp(vVelocity.y + norigin.y * moving, -fPlayerSpeed * TOUHOU_BASESPEED, fPlayerSpeed * TOUHOU_BASESPEED)
		// vVelocity.z = clamp(vWant.z + vVelocity.z) // this always zero it dont  matter

		local MoveTrace = QuickTrace(vOrigin+TOUHOU_VEC_Z_UP*8, vOrigin + (vVelocity*16)+TOUHOU_VEC_Z_UP*8, self, MASK_WATER) // check a little bit further than the direction player *wants* to go
		// DebugDrawLine_vCol(MoveTrace.startpos, MoveTrace.pos, Vector(255, 255, 255), false, 1)
		// DebugDrawText(stupidbitch, "Dumb bitch hello", true, 2)
		if (MoveTrace.hit == true) {
			vVelocity *= 0
			norigin *= -2
			fPlayerSpeed = 0
			printl("Yep")
			vWantVec *= 0
			vWant *= 0

		}
		// vVelocity *= (fFriction * delta)
		self.KeyValueFromVector(CUBT_ORIGIN, vOrigin + norigin)
			// self.SetAbsOrigin(norigin)

	}


	// show any info texts :D
	if (iNextHealthTime <= fTime) {
		ShowHUDInfo()
		if (!doAccelerate) {

			ShowGuarding()
		}
		iNextHealthTime = fTime + iHealthTime
	}

	// velocity and acceleration stupid stuff
	vLastOrigin = self.GetOrigin()



	return -1

}




function TPlayerGuard() {
	local vOrigin = self.GetOrigin()
	local hOrbPos1 = hOrb1.GetOrigin()
	local hOrbPos2 = hOrb2.GetOrigin()

	local vDiff1 = hOrbPos1-hOrb1GuardOffset
	local vDiff2 = hOrbPos2-hOrb2GuardOffset

}
function TPlayerShoot() {

	local vOrigin = self.GetOrigin()

	// local vOrb1 = hOrb1.GetOrigin()
	// local vOrb2 = hOrb2.GetOrigin()

	switch (iShootLevel) {
		case TOUHOU_SHOOTLVL.BASIC:
			MakeBullet(vOrigin + TOUHOU_SHOOT_OFFSET, 3)
			// MakeBullet(vOrb1)
		break;
	}
	// to-do
}

function MakeBullet(targpos = null, type = 4, speed = 1.3, colorstr = TOUHOU_SHOOTCOL_BASIC, targent = null) {

	local org;

	if (bOddFire) {
		org = hOrb1.GetOrigin()
	} else {
		org = hOrb2.GetOrigin()
	}

	local b = Spawn("func_door", {
		model = BRUSHMODELS[TOUHOU_BULLET_PREFIX+type.tostring()],
		disableshadows = true,

		vscripts = TOUHOU_BULLET_SCRIPT,
		rendermode = 5,
		renderamt = 140,
		spawnflags = 2052,
		targetname = TOUHOU_BULLET_NAME_P,
		origin = org,
	})
	b.AcceptInput(CUBT_COLOR, colorstr, null, null)
	b.AcceptInput(CUBT_RUNSCRIPTFILE, TOUHOU_BULLET_SCRIPT, null, null)
	b.ValidateScriptScope()
	local scope = b.GetScriptScope()

	if (targpos == null) {
		targpos = org + TOUHOU_VEC_UP * 1024
	}

	scope.Friendly <- true
	scope.vTargPos <- targpos
	scope.iSpeed <- speed
	scope.PlayerOwner <- self

	if (targent != null) {
		scope.hTarget <- targent
	}

	AddThinkToEnt(b, "Think")

	return b
}

function TOrbLerp(vec1, vec2, speed) {
	local fdelta = FrameTime()

	local vOrigin = self.GetOrigin()
	vec1 = vec1 - vOrigin;
	vec2 = vec2 - vOrigin;
	local hOrbPos1 = hOrb1.GetOrigin() - vOrigin;
	local hOrbPos2 = hOrb2.GetOrigin() - vOrigin;

	if (fTime % 2 == 0) {

	}

	// local vDiff1 = (hOrbPos1 - vec1) * easeInOutSine(GetDistance2D(hOrbPos1, vec1))
	// local vDiff2 = (hOrbPos2 - vec2) * easeInOutSine(GetDistance2D(hOrbPos2, vec2))

	hOrb1.KeyValueFromVector("origin", (vDiff1))
	hOrb2.KeyValueFromVector("origin", (vDiff2))



}

function CleanUp() {
	AddThinkToEnt(self, "")
	hOrb1.Destroy()
	TOUHOU_ENTITIES_LIMIT--
	hOrb2.Destroy()
	TOUHOU_ENTITIES_LIMIT--
	hNametag.Destroy()
	TOUHOU_ENTITIES_LIMIT--
	hClientProxy.Destroy()
	TOUHOU_ENTITIES_LIMIT--

	if (ValidEntity(hOwner)) {
		hOwner.GetScriptScope().touhou_puppet <- null
		if (hOwner.IsAlive()) {
			hOwner.SetMoveType(MOVETYPE_WALK, MOVECOLLIDE_DEFAULT)
			hOwner.SnapEyeAngles(QAngle(0,90,0))
			if (hOwner.GetTeam() == TEAMS.HUMANS) {
				hOwner.SetHealth(hOwner.GetMaxHealth())
			}

		}
		ScreenFade(hOwner, 255,255,255,255,0.01,0.3,FFADE_IN)

	}
	if (ValidEntity(CameraENT)) {
		TOUHOU_ENTITIES_LIMIT--
		SetViewControl(hOwner, CameraName, false)
		QFire(CameraName, "Kill", 0.01) // must have delay or player loses they viewmodels FOREVAR
	}


	TOUHOU_ENTITIES_LIMIT--
	self.Destroy()
}

function TakeTouhouDamage() {
	if (bInvulnerable == false) {
		iInvulnerabilityEndTime = Time() + (iGraceLength)
		iHealth --
		// vVelocity *= 0
		bInvulnerable = true
		iframe = false
	}

	if (iHealth <= 0) {
		TouhouDeath()
	}

}

function TouhouDeath() {
	AddThinkToEnt(self, "")
	bInvulnerable = true
	if (!ValidEntity(self)) {
		CleanUp()
	}
	hNametag.DisableDraw()
	hOrb1.DisableDraw()
	hOrb2.DisableDraw()
	hClientProxy.DisableDraw()
	iDieDestroy = self.GetOrigin().y - 10
	AddThinkToEnt(self, "DeadThink")
}

function DeadThink() {
	local vOrigin = self.GetOrigin()
	if (!ValidEntity(self)) {
		CleanUp()
	}

	// printl(vOrigin)// turbulence  + (TOUHOU_VEC_LEFT*RandomInt(-100,100))
	self.SetOrigin(vLerp(vOrigin, vOrigin + (TOUHOU_VEC_DOWN * -cos(iDeadSine * 2) * 360) + (TOUHOU_VEC_LEFT*RandomInt(-100,100)*3), 0.5 * FrameTime()))
	self.SetAbsAngles(QAngle(0,Time()* 2200,0))
	// self.SetAbsVelocity(Vector(0,0,0))
	// self.SetVelocity(0,0,0)
	if (vOrigin.y <= iDieDestroy) {
		AddThinkToEnt(self, "")
		DoEffect("unusual_spire_snowball_poofcontrol", vOrigin)
		if (ValidEntity(hOwner) && hOwner.IsAlive()) {
			hOwner.TakeDamage(9999999, 0, null)
			ScreenFade(hOwner, 255, 0, 0, 255, 0.7, 0.1, FFADE_IN)
		}
		CleanUp()
		return
	}
	iDeadSine+=FrameTime()*2.4

	return -1
}