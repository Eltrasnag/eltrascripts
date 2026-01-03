hTowerMain <- Entities.FindByName(null, "endovus_tower_geo");
hTowerLight <- Entities.FindByName(null, "endovus_tower_lightparent");

function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
}
function Think() {
	local qLightAngles = hTowerLight.GetAbsAngles()
	local qTowerAngles = hTowerMain.GetAbsAngles()

	hTowerMain.KeyValueFromVector("angles", Vector(qTowerAngles.Pitch() + sin(Time() * 0.5) * 0.1, qTowerAngles.Yaw(), qTowerAngles.Roll()))
	// hTowerMain.SetAbsAngles(QAngle(qTowerAngles.Pitch() + sin(Time() * 0.1) * 0.1, qTowerAngles.Yaw(), qTowerAngles.Roll()))
	hTowerLight.SetAbsAngles(QAngle(qLightAngles.Left() + Vector(qLightAngles.Left() * 0.1)))

	// hTowerLight.SetAbsAngles(QAngle(qLightAngles.Left() + Vector(qLightAngles.Left() * 0.1)))
	print("tower think")
	return 0.01
}