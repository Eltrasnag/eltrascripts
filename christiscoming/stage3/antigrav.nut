// IncludeScript("eltrasnag/common.nut", this)
const IN_FORWARD = 8
const IN_MOVELEFT = 512
const IN_MOVERIGHT = 1024
const IN_BACK = 16

gravspeed <- 400
vzero <- Vector(0,0,0)

players <- {}
function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
	self.ConnectOutput("OnStartTouch", "Enter")
	self.ConnectOutput("OnEndTouch", "Exit")
}

function Enter() {
	// activator.SetForceLocalDraw(true)
	local eang = activator.EyeAngles()
	// activator.SnapEyeAngles(QAngle(eang.x,eang.y,180))
	// activator.SetMoveType(Constants.EMoveType.MOVETYPE_STEP, Constants.EMoveCollide.MOVECOLLIDE_FLY_SLIDE)
	players[activator] <- activator
		EmitAmbientSoundOn(portalsnd, 100, 0, 100, activator)
	activator.SetGravity(-0.7)
	// activator.SetForcedTauntCam(1)
}
portalsnd <- "ambient/levels/citadel/field_loop3.wav"

function Exit() {
	// activator.SetForceLocalDraw(false)

	// activator.SetMoveType(Constants.EMoveType.MOVETYPE_WALK, Constants.EMoveCollide.MOVECOLLIDE_DEFAULT)
	// local eang = activator.EyeAngles()
	// activator.SnapEyeAngles(QAngle(eang.x,eang.y,0))
	// activator.SetForcedTauntCam(0)

	if (activator in players) {
		delete players[activator]
	}
	activator.SetGravity(1)
	StopAmbientSoundOn(portalsnd, activator)

}


function Think() {
	foreach (i, player in players) {
		local pvel = player.GetAbsVelocity()

		// pvel.z = 0
		PrecacheScriptSound(portalsnd)
		local buttons = NetProps.GetPropInt(player, "m_nButtons")

		local vAngles = player.EyeAngles()
		// vAngles.x = 0
		local eyeleft = vAngles.Left()
		local eyefor = vAngles.Forward()

		local wantvec = vzero
		player.SetHealth(clamp(player.GetHealth() + 1, 1, player.GetMaxHealth()))
		local moving = false
		if (buttons & IN_FORWARD) {
			wantvec += eyefor
			moving = true
		}
		if (buttons & IN_MOVELEFT) {
			wantvec -= eyeleft
			moving = true
		}
		if (buttons & IN_MOVERIGHT) {
			wantvec += eyeleft
			moving = true
		}
		if (buttons & IN_BACK) {
			wantvec -= eyefor
			moving = true
		}

		if (moving == false) {
			// player.SetAbsVelocity(player.GetAbsVelocity()*0.96)
		}
		wantvec *= gravspeed
		ScreenFade(player, 0, 0, 255, 20, 0.25, 0.1, 1)
		wantvec.z = LerpFloat(wantvec.z, pvel.z, FrameTime() * 5)
		// wantvec.z += pvel.z

		player.SetAbsVelocity(vLerp(pvel, wantvec, FrameTime() * 2))
		// wantvec = clampvec(wantvec, Vector(-2, -2 -2), Vector(2,2,2))
		// NetProps.SetPropVector(player, "m_vecBaseVelocity", wantvec)

		// NetProps.SetPropVector(player, "m_vecBaseVelocity", wantvec)

		DoEffect("cic_antigravity", player.GetOrigin())

	}
	return -1
}