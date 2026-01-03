iActiveNPCs <- 0
iMaxNPCs <- 20
iNPCsLeft <- 10
iNPCRatio <- 2

iNextNPCSpawnTime <- 0
iNextNPCWaitTime <- 3

PackageMakers <- []

function StartBoss() {
	getroottable().FURBOSS <- this
	local ent;
	QFire("s2_mus_furryboss", "PlaySound")

	while (ent = Entities.FindByName(ent, "furry_boss_maker*")) {
		PackageMakers.append(ent)
	}

	local plys = []
	local ply;
	while (ply = Entities.FindByClassname(ply, "player")) {
		if (ply.GetTeam() == TEAMS.HUMANS && ply.IsAlive()) {
			plys.append(ply)
		} else {
			continue;
		}
	}

	iNPCsLeft = iNPCRatio * plys.len()

	if (XMODE) iNPCsLeft *= 2



	MapSay("Start furry boss now")
	AddThinkToEnt(self, "BossThink")
}

function BossThink() {
	local flTime = Time()

	if (iNextNPCSpawnTime <= flTime && iActiveNPCs < iNPCsLeft && iActiveNPCs < iMaxNPCs) {
		MakePackage()
		iNextNPCSpawnTime = flTime + iNextNPCWaitTime
	}

	if (iNPCsLeft > 0) {
		local text = MakeGameText("- THE WOLF PACK -\n ⤨ "+iNPCsLeft+" LEFT TO DESTROY ⤪", -1, 0.2, "242 94 2")
		QAcceptInput(text, "Display")
		text.Kill()

	} else {
		AddThinkToEnt(self, "")
		Defeat()
		return -1
	}


	return 0.1
}

function MakePackage() {
	local spawner = PackageMakers[RandomInt(0, PackageMakers.len() - 1)];

	local vOrigin = spawner.GetOrigin()
	local package = Spawn("func_physbox_multiplayer", {
		model = BRUSHMODELS["furry_package_model"],
		origin = vOrigin,
		material = 4,
		angles = QAngle(RandomInt(0,360),RandomInt( 0,360),RandomInt(0,360)),
		vscripts = "eltrasnag/christiscoming/stage2/furpackage.nut"
	})



}

function Defeat() {
	QFire("mus_s2_furryboss", "Fadeout", "5")
	local text = MakeGameText("- GREAT JOB! -", -1, 0.2, "242 94 2")
	QAcceptInput(text, "Display")
	text.Kill()
	ze_map_say("[ DOGGY GENERATION HAS TERMINATED. WE THANK YOU FOR YOUR PARTICIPATION IN THIS EXCITING GRANNY SCIENCE ENRICHMENT EXPERIMENT! ]")

	QFire("s2_mus_pboss", "PlaySound","", 0)
	QFireByHandle(self, "runscriptcode","ze_map_say(`[ THE GATE WILL NOW BE OPENED FOR YOU. HAVE A WONDERFUL DAY! ]`)", 3)
	QFireByHandle(self, "runscriptcode","ze_map_say(`*** MINECART ESCAPE GATE WILL OPEN IN 5 SECONDS ***`)", 5)
	QFire("s2_door_mariah", "Open", "", 10)
	QFireByHandle(self, "runscriptcode","ze_map_say(`*** MINECART ESCAPE GATE HAS OPENED. BOARD IMMEDIATELY!! ***`)", 10)

}