sf_plate <- ""; // add pressure plate sound plz
vOrigin <- self.GetOrigin()

function OnPostSpawn() {
	DPrint("CICPlate has spawned")
}

function DoPress(pressed) {
	if (GorkPlateActive == 3) { // if all activated, we are done here
		return
	}

	if (pressed == true) {
		PlaySound(sf_plate, vOrigin)
		GorkPlateActive++
	} else {
		PlaySound(sf_plate, vOrigin)
		GorkPlateActive--
	}
	GorkCheck()
}
