function OnPostSpawn() {
	for (local ply; ply = Entities.FindByClassname(ply, "player");) {

		if (NetProps.GetPropString(ply, "m_szNetworkIDString") == ELTRA_STEAMID) {

			SetParentEX(self, ply, "partyhat")

		}
	}
}