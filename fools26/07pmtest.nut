IncludeScript("eltrasnag/common.nut", this)

function OnPostSpawn() {
	ShittyListenHooks({
		function OnGameEvent_player_spawn(params) {
			local ply = GetPlayerFromUserID(params.userid)
			local path = "models/eltra/playermodels/male07tf.mdl"
			PrecacheModel(path)
			// local mdl = CreatePlayerWearable(ply, path)
			// local mdl = Spawn("prop_dynamic_ornament", {model = path})
			// SetParentEX(mdl, ply)
			// mdl.SetEFlags(Constants.FEntityEffects.EF_BONEMERGE)
			ply.SetCustomModelWithClassAnimations(path)
			// ;

			local tall = 36.5
			local wide = 136.5
			local bound = Vector(wide, wide, tall)
			ply.SetSolid(Constants.ESolidType.SOLID_BBOX)
			ply.SetSize(bound * -1, bound)
			printl("boundset")
		}
	})
}