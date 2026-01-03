
function OnPostSpawn() {

	local strPortalColor = null

	switch (CURRENT_STAGE) {
		case 0: //s1
			strPortalColor = "52 158 235"
			break;
		case 1:
			strPortalColor = "230 48 78"
			break;
		default:

			break;
	}

	self.AcceptInput("color", strPortalColor, null, null)
}