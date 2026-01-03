

tSpotlightTable <- {
	// targetname = "citadel_light"
	// rendercolor = "183 255 210",
	// spotlightlength = 1000,
	// spotlightwidth = 100,
	// spawnflags = 3,
	// origin = Vector(0, 0, 0),
	// angles = "0 0 0"

	effect_name = "li_citadel_spotlight_a",
	start_active = 1,
}

hSpot1 <- null

hSpot2 <- null

hSpot3 <- null
function OnPostSpawn() {

	hSpot1 = SpawnEntityFromTable("info_particle_system", tSpotlightTable)
	hSpot2 = SpawnEntityFromTable("info_particle_system", tSpotlightTable)
	hSpot3 = SpawnEntityFromTable("info_particle_system", tSpotlightTable)
	self.ValidateScriptScope()
	self.AcceptInput("SetAnimation","idle",null,null)
	printl("spotlight")




	printl(hSpot1)
	printl(hSpot2)
	printl(hSpot3)


	SetParentEX(hSpot1, self, "attach.lamp_lower")
	SetParentEX(hSpot2, self, "attach.lamp_middle")
	SetParentEX(hSpot3, self, "attach.lamp_upper")
	AddThinkToEnt(self, "CitadelThink")
}

function CitadelThink() {

	local vAttachLower = self.GetAttachmentOrigin(self.LookupAttachment("attach.lamp_lower"))
	local vAttachMiddle = self.GetAttachmentOrigin(self.LookupAttachment("attach.lamp_middle"))
	local vAttachUpper = self.GetAttachmentOrigin(self.LookupAttachment("attach.lamp_upper"))

	local qAttachLower = self.GetAttachmentAngles(self.LookupAttachment("attach.lamp_lower"))
	local qAttachMiddle = self.GetAttachmentAngles(self.LookupAttachment("attach.lamp_middle"))
	local qAttachUpper = self.GetAttachmentAngles(self.LookupAttachment("attach.lamp_upper"))

	if (hSpot1 != null) {

		hSpot1.SetAbsOrigin(vAttachLower)
		hSpot2.SetAbsOrigin(vAttachMiddle)
		hSpot3.SetAbsOrigin(vAttachUpper)

		hSpot1.SetAbsAngles(qAttachLower)
		hSpot2.SetAbsAngles(qAttachMiddle)
		hSpot3.SetAbsAngles(qAttachUpper)
	}
}