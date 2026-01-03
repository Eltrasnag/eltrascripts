delta <- 0.5

function OnPostSpawn() {
	self.SetContext("money", 10)
	QFireByHandle(self, "RunScriptCode", "AddThinkToEnt(self, `Think`)", 0.5) // do this to avoid mapfunc's think clearing
}

function Think() {
	self.DisplayGameText("Bank Account: " + self.GetMoney() + "$", 0.3, 0.2, GAMETEXT.PLAYER, PLAYER_BANKCOLOR, delta)
	return delta
}

