SHOPITEM_HOVER_DISTANCE <- 8
SHOPITEM_ROT_SPEED <- 20

BaseAngle <- self.GetAbsAngles()
BaseOrigin <- self.GetOrigin()
BobOffset <- RandomInt(0,360)
function OnPostSpawn() {
	AddThinkToEnt(self, "ItemFloat")
}

function ItemFloat() {
	self.KeyValueFromVector("origin", BaseOrigin + Vector(0, 0 sin(Time() + BobOffset) * SHOPITEM_HOVER_DISTANCE))
	self.SetAbsAngles(BaseAngle + QAngle(0, Time() * SHOPITEM_ROT_SPEED, 0))
	return 0.05
}