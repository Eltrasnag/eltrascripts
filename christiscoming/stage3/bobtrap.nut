// IncludeScript("eltrasnag/common.nut", this)

bobmodel <- null
function OnPostSpawn() {
	// if (!("BRUSHMODELS" in getroottable()) || !("bobmodel" in BRUSHMODELS)) {
	// 	return
	// }
	// bobmodel =
	self.ConnectOutput("OnStartTouch", "Enter")
	self.ConnectOutput("OnEndTouch", "Exit")
}

function Enter() {
	DoBob(activator)

}

function DoBob(ply) {
	local game_ui = Spawn("game_ui", {
		spawnflags = 96,
	})
	game_ui.DispatchSpawn()
	ply.SetMoveType(Constants.EMoveType.MOVETYPE_CUSTOM, Constants.EMoveCollide.MOVECOLLIDE_DEFAULT)
	ply.SetAbsVelocity(Vector(0,0,0))
	game_ui.AcceptInput("Activate", "", ply, ply)
	game_ui.Destroy()
	// QFireByHandle(game_ui, "Activate", "", 0.01, ply)
	QFireByHandle(game_ui, "Kill", "", 4)
	local vOrigin = ply.GetOrigin()
	local vAngles = ply.EyeAngles()
	vAngles.x = 0 // no pitch please
	local bob = Spawn("func_brush", {
		model = BRUSHMODELS["bob_trap_model"],
		targetname = "bob",
		origin = vOrigin + (ply.GetForwardVector() * 128) + Vector(0,0,-160),
		angles = vAngles
		vscripts = "eltrasnag/christiscoming/stage3/bobpanel.nut"
	})
	bob.ValidateScriptScope()
	bob.GetScriptScope().victim <- ply
	bob.SetAbsAngles(RotateOrientation(bob.GetAbsAngles(), QAngle(0,-90,0)))
	bob.DispatchSpawn()

	ply.SnapEyeAngles(vAngles)

}


function Exit() {

}