// IncludeScript("eltrasnag/common.nut", this)
boostplayers <- {}
boostspeed <- 50
boostvector <- Vector(0,0,0)
function OnPostSpawn() {
	AddThinkToEnt(self, "BoostThink")
	local ang = self.GetAbsAngles()
	ang.x = -45
	boostvector = RotateOrientation(ang, QAngle(0, 0, 0)).Forward()
	self.SetAbsAngles(QAngle(0,0,0))
	boostvector.z = 1
	local ckeys = GetContext(self)
	// __DumpScope(1, ckeys)

	if ("speed" in ckeys) {
		boostspeed = ckeys.speed.tointeger() * 10
	}

	self.ConnectOutput("OnStartTouch","OnStartTouch")
	self.ConnectOutput("OnEndTouch","OnEndTouch")

}

function OnStartTouch() {
	local vOrigin = activator.GetOrigin()
	vOrigin.z += 10
	activator.SetAbsOrigin(vOrigin)
	PlaySoundEX("misc/halloween/spell_fireball_impact.wav", vOrigin)
	ScreenFade(activator, 155,155,0, 10, 0.5, 0.1, 1)
	boostplayers[activator] <- activator
}

function OnEndTouch() {
	if (activator in boostplayers) {
		delete boostplayers[activator]
		activator.ViewPunch(QAngle(-15,0,0))
		SetAnimation(activator, "a_jumpstart_MELEE_ALLCLASS")
		// local avel = activator.GetAbsVelocity()
		// local vOrigin = activator.GetOrigin()
		// local pfor = activator.EyeAngles().Forward()
		// vOrigin.z += 1
		// avel.z += 100
		// activator.SetAbsVelocity(avel)

		// activator.SetAbsOrigin(vOrigin)
		// activator.SetAbsVelocity(avel + pfor * boostspeed) // there is no world where a boost exploit does not get created with htis

	}
}

function BoostThink() {
	foreach (i, player in boostplayers) {
		if (player != null && player.IsValid()) {
			local pvel = player.GetBaseVelocity()
			local pfor = player.EyeAngles()
			pfor.x = 0
			pfor = pfor.Forward()

			pvel += (boostvector * boostspeed)
			// pvel += pfor * (boostspeed)

			player.ViewPunchReset(0)

			// local pvel = Vector(0,0,0)
			DoEffect("cic_speedpad", player.GetOrigin())
			player.SetAbsVelocity(clampmaxvelocity(pvel))
			// NetProps.SetPropVector(player, "m_vecBaseVelocity", pvel)
		}
	}
	return 0.05
}