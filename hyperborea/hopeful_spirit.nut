
is_carried <- false;
the_hero <- null;

function OnPostSpawn() {
	nexus_hope_active = true
}
function HopeThink() {
	// if (is_carried != true) {
	// 	local i_player = null
	// 	while (i_player = Entities.FindInSphere(i_player, self.GetOrigin(), 128))
	// 	{
	// 		if (i_player.GetClassname() == "player")
	// 		{
	// 			if (i_player.GetTeam() == 3) {
	// 				// ClientPrint(i_player, 4, "***  ***")
	// 			}
	// 		}
	// 	}
	// }
	// if (the_hero != null && !the_hero.IsValid()) {
	// 	Dropped()
	// }
}

function Destroy() {
	printl(" hope is dead")
	nexus_hope_active = false
}

function SetCarryBy(carrier) {
	if (!is_carried) {
		// the_hero = carrier
		// is_carried = true
		ClientPrint(carrier, 4, "*** DEPLOY THE DEVICE AT THE TRAPDOOR UP ABOVE ***")
		// QFireByHandle(self, "SetParent", "!activator", 0.0, carrier, null)

	}

}


function Dropped() {
	self.ClearParent()
	is_carried = false
	the_hero = null
}