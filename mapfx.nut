Expired <- false
Active <- false
LastFXScene <- ""
EffectScene <- self.GetName()

function OnPostSpawn() {
	AddThinkToEnt(self, "FXThink")
}

function FXThink() {

	if (FX_SCENE != LastFXScene) {
		if (FX_SCENE == EffectScene && Active == false) { // turn effect on
			self.AcceptInput("Start", "", null, null); // effect scene has matched up with global scene, start effect!
		}
		else if (Active == true) { // turn effect off
			self.Kill() // map has moved onto a different scene, do cleanup now
		}
	}

	LastFXScene = FX_SCENE

	return 0.8

}