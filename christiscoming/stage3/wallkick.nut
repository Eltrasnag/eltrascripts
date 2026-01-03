// // IncludeScript("eltrasnag/common.nut", this)
// IncludeScript("eltrasnag/common.nut", this)

players <- {}

kickforce <- 450
upvec <- Vector(0,0,1)

function OnPostSpawn() {
	self.ConnectOutput("OnStartTouch", "OnStartTouch")
	self.ConnectOutput("OnEndTouch", "OnEndTouch")
	AddThinkToEnt(self, "PadThink")
	// printl("i just spawned")
}
function OnStartTouch() {
	// local vel = activator.GetAbsVelocity()
	// activator.SetAbsVelocity(Vector(vel.x,vel.y,0))
	activator.ValidateScriptScope()
	activator.GetScriptScope().InWallkick <- false
	// activator.SetGravity(0)
	players[activator.GetEntityIndex()] <- activator
}

function OnEndTouch() {
	printl("exit")
	// activator.SetGravity(1)
	if (activator.GetEntityIndex() in players) {
		activator.ValidateScriptScope()


		activator.GetScriptScope().InWallkick <- false
		delete players[activator.GetEntityIndex()]
		// delete playeres[activator]
	}
}

function PadThink() {
	foreach (i, player in players) {


		if (player != null && player.IsValid()) {
			player.ValidateScriptScope()
			local scope = player.GetScriptScope()

			if (NetProps.GetPropInt(player, "m_afButtonLast") == NetProps.GetPropInt(player, "m_afButtonPressed") || ("InWallkick" in scope  && scope.InWallkick == true)) { // button has not changed
				continue;
			}


			local pvel = player.GetAbsVelocity()
			local pang = player.EyeAngles()
			local porigin = player.EyePosition() // this is more fair, even if it doesn't make as much sense
			pang.x = 0
			local pfor = pang.Forward()
			local leftvec = pang.Left()

			local lefttrace = QuickTrace(porigin, porigin - leftvec * 64, player, 48)
			local righttrace = QuickTrace(porigin, porigin + leftvec * 64, player, 48)
			// DebugDrawLine_vCol(lefttrace.startpos, lefttrace.pos, Vector(255, 255, 255), false, 0.1)
			// DebugDrawLine_vCol(righttrace.startpos, righttrace.pos, Vector(255, 255, 255), false, 0.1)
			local kickvec = Vector(0,0,0);
			local hit = false

			if (lefttrace.hit && ButtonPressed(player, IN_MOVERIGHT)) { // this might be too hard with the direction key requirement
				// printl("left has hit")

				kickvec = leftvec * kickforce
				hit = true
			}
			if (righttrace.hit && ButtonPressed(player, IN_MOVELEFT)) {
				// printl("right has hit")
				kickvec = leftvec * -kickforce

				hit = true
			}
			if (hit == true) {

				// player.SetMoveType(Constants.EMoveType.MOVETYPE_WALK, Constants.EMoveCollide.MOVECOLLIDE_DEFAULT)
				ScreenFade(player, 0, 255, 0, 1, 1, 0.5, 1)
				player.ViewPunch(QAngle(-4,0,0))
				kickvec.z = 0

				PlaySoundEX("eltra/portal_open1.wav", porigin, 10, RandomInt(80,90))
				DoEffect("cic_wallkick", porigin)
				kickvec += Vector(0, 0, clamp((pvel.z * -1), 200, 800)) + (pfor * kickforce)
				// NetProps.SetPropVector(player, "m_vecBaseVelocity", kickvec)

				player.SetAbsVelocity(kickvec)
				scope.InWallkick <- true

			}





		}
	}
	return -1
}