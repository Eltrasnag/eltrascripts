// Code for my dynamic locational templatting system :D
// Originally made for ze_christ_is_coming.

Context;
ScanRadius <- 1024;
ExitScanRadius <- ScanRadius * 1.5;
SpawnedEnts <- null;
Targetname <- self.GetName();
Active <- false;

function OnPostSpawn() {

	Context = GetContext(self)
	if ("scanradius" in Context) {
		ScanRadius = Context.ScanRadius
		ExitScanRadius = ScanRadius * 1.5
	}

	AddThinkToEnt(self, "Think")
}

function PostSpawn(ent_table) {
	printl("DYNATEMP: "+Targetname+" is now spawning entities!")
	foreach (i, ent in ent_table) {
		printl("DYNATEMP: "+Targetname+" has spawned entity "+ent)
	}
	SpawnedEnts <- ent_table;
}

function PreSpawnInstance(entity_class, entity_name) {
}

function Think() {

	local vOrigin = self.GetOrigin();
	local ply;


	if (!Active) { // while we're waiting to spawn, scan to see a player has entered our spawn radius
		local nearest = Entities.FindByClassnameNearest("player", vOrigin, ScanRadius);
		if (ValidEntity(nearest) && GetDistance2D(nearest.GetOrigin() < ScanRadius)) {
			printl("Player has entered spawn radius!");
			Active = true;
		}
		return 1
	}

	local nearest = Entities.FindByClassnameNearest("player", vOrigin, ExitScanRadius);
	if (ValidEntity(nearest) && GetDistance2D(nearest.GetOrigin() < ExitScanRadius)) {
		printl("DYNATEMP: (" + Targetname + ") No players in range! Cleaning entities...")
		foreach (i, ent in SpawnedEnts) {
			if (ValidEntity(ent)) {
				printl("DYNATEMP: Removing entity "+ent)
				ent.Kill()
			}
			continue;
		}
	}

	return 1
}