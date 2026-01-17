delta <- 0.5

function OnPostSpawn() {
	self.SetContext("money", 10)
	if (DEV)
		self.SetContext("money", 1000)

	QFireByHandle(self, "RunScriptCode", "AddThinkToEnt(self, `Think`)", 0.5) // do this to avoid mapfunc's think clearing
	local modelpath = "models/eltra/playermodels/male07tf.mdl"
	PrecacheModel(modelpath)
	self.SetCustomModelWithClassAnimations("models/eltra/playermodels/male07tf.mdl")
	// self.SetSize(Vector(-1,-1,-1), Vector(1,1,1))
}

function Think() {
	local wearable_size = NetProps.GetPropArraySize(self, "m_hMyWearables");
	for (local i = 0; i < wearable_size - 1; i++) {

		local hWearable = NetProps.GetPropEntityArray(self, "m_hMyWearables", i)
		if (!ValidEntity(hWearable))
			continue
		hWearable.Kill()
	}
				local tall = 36.5
			local wide = 136.5
			local bound = Vector(wide, wide, tall)
			self.SetSolid(Constants.ESolidType.SOLID_BBOX)
			self.SetSize(bound * -1, bound)
	self.DisplayGameText("Bank Account: " + self.GetMoney() + "$", 0.3, 0.2, GAMETEXT.PLAYER, PLAYER_BANKCOLOR, delta)
	NetProps.SetPropFloat(self, "m_flLaggedMovementValue", 2000)
	return delta
}


