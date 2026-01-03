
function OnPostSpawn() {
	SpawnMoney(self.GetOrigin())
	self.Kill()
}