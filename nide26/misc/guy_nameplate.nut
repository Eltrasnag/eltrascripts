function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
}


function Think() {
	// local vOrigin = self.GetOrigin()
	// self.SetLocalOrigin()
	if (ValidEntity(self)) {
		self.SetLocalOrigin(Vector(0, 0, sin(Time() * 4) * 5 + GUY_NAMEPLATE_OFFSET) )
		return 0.1
	}

}