self.ValidateScriptScope()
rdist <- RandomFloat(-512,512)
vStartPos <- self.GetOrigin();
iOffset <- RandomInt(1,7)
function OnPostSpawn() {
	print("fiona apil has formed..........");
	MapMaxApples++
	self.SetHealth(200);
	self.ConnectOutput("OnHealthChanged", "OnAppleHurt");
	self.ConnectOutput("OnBreak", "OnAppleBreak");
	AddThinkToEnt(self, "Think")
}

function Think() {
	// if (!MapFatty) {
		// self.SetHealth(200);
	// }
	local vOrigin = self.GetOrigin();
	local vAng = self.GetAbsAngles()

	vAng.y += 10

	local bobheight = 64
	self.SetAbsAngles(vAng);
	vOrigin.z = vStartPos.z - bobheight/2 + abs(sin(iOffset + Time() * 2) * bobheight)
	// printl(GetDistance2D(vOrigin,vStartPos))
	if (!self.GetMoveParent()) {

		vOrigin.x = vStartPos.x + sin(Time() * iOffset) * rdist
		vOrigin.y = vStartPos.y + cos(Time() * iOffset) * rdist
	} else {
		vOrigin = vStartPos
	}
	self.KeyValueFromVector("origin",vOrigin);
	// if (MapFatty) { // v3a test: just allow players to get al the apples whenever regardless of if banban was talked to
		for (local ply; ply = Entities.FindInSphere(ply, vOrigin, 128);) {
			if (ply.IsPlayer() && ply.GetTeam() == TEAMS.HUMANS) {
				ply.SetModelScale(clamp(ply.GetModelScale() + 0.2, 1,2), 2)
				ClientPrint(ply,Constants.EHudNotify.HUD_PRINTTALK,"\x05You have gotten fatter")
				self.AcceptInput("Break", "", null, null);
			}
		}

	// }
	return 0.01

}

function OnAppleHurt() {
	if (!MapFatty) {
		ClientPrint(activator, 3, "talk to ban ban to know ");
	}
	else {
		QFireByHandle(self, "color", "255 0 0");
		QFireByHandle(self, "color", "255 255 255", 0.1);
	}

}

function OnAppleBreak() {
	ze_map_say("an apil has been EATEN!!!!!!!! only " + (MapMaxApples - MapApples - 1).tostring() + "LEFT....."); // ??
	MapApples++
	if (MapApples >= MapMaxApples) {
		// ban ban talk
		MapSay("WOW!!!!! im STUFFED!!!!!!!!!!*BRUUUUUUUUUUUP", "Banban");
		MapSayDelay("i think im", "Banban", 0.5);
		MapSayDelay("i think im", "Banban", 1.6);
		MapSayDelay("i ...", "Banban", 3);
		MapSayDelay("IM GONNA BLOW!!!!!!!!!!!!!!!!!!!!!!!!", "Banban", 4);
		QFire("s2_banban", "Kill", "", 5);

		QFire("s2_apple_door", "Break", "", 10)
		MapSayDelay("Unrelated: Apple door has now opened to your West","map", 10)

		// continue !!!!
	}
}