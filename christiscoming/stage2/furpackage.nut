culltime <- 0

const CIC_FURRY_TEMPLATE = "fur"
function OnPostSpawn() {
	self.SetPhysVelocity(Vector(RandomInt(-4000, 4000),RandomInt(-4000, 4000),RandomInt(-4000, 4000)))
	self.SetPhysVelocity(Vector(RandomInt(-4000, 4000),RandomInt(-4000, 4000),RandomInt(-4000, 4000)))
	// QFireByHandle(self, "RunScriptCode", "MakeDog()", 4)
	NetProps.SetPropFloat(self, "m_fMass", 10000)
	AddThinkToEnt(self, "Think")
}


function Think() {
	if (self.GetPhysVelocity().Length()< 10) {
		MakeDog()
		AddThinkToEnt(self, "")
		return
	}
}
function MakeDog() {
	local vOrigin = self.GetOrigin()
	SpawnTemplateEntity(CIC_FURRY_TEMPLATE, vOrigin)

	self.Kill()
}