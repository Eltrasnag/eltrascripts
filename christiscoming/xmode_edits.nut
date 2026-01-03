/////// XMODE EDITS \\\\\\\\\
/////PURPOSE: Spawns on xtreme, matches the stage, and edits it.

Triggers <- Entities.FindByClassname(null,"trigger_*")
StageEnts <- {}

function OnPostSpawn() {

	// get a clean list of the stage's entities for editing
	local ent;
	while (ent = Entities.FindByName(ent, "s"+(MapStage-3)+"*")) {
		StageEnts[ent.GetName()] <- ent
		printl("Found stage entity "+ent.GetName())
	}

	switch ((MapStage)) {
		case 3: // stage 1x
			Stage1Edits()
		break;

		case 4: // stage 2x
			Stage2Edits()
		break;

		case 5: // stage 3x
			Stage3Edits()
		break;
	}

}


function Stage1Edits() {

}


function Stage2Edits() {
	// stop tidalbed from being interrupted
	EntityOutputs.RemoveOutput(StageEnts["s2_door_6"], "OnOpen", "s2_mus_factory_1", "PlaySound", "")
	EntityOutputs.RemoveOutput(StageEnts["s2_door_6"], "OnOpen", "s2_mus_start", "StopSound", "")
}

function Stage3Edits() {

}