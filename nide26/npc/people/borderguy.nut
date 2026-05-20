self.ValidateScriptScope()
IncludeScript("eltrasnag/nide26/npc/people/base.nut", this)


a_BorderLines <- {
	mad = ["HEY HEY HEY watch it tough guy!!!!!!!!!!!!!!!!!!!!!!", "i will shove this STICK UP YOUR ASS!!!!!!!!!!!!!!!!!!", "FUCK OFDF or i WILL get ..............MAD!!!!!!!!!!!!!!!!"]
}

function SpawnAction() {
	str_Name <- "John Border"

	AddNPCThink(BorderThink)
}

Passported <- []


function SceneStart() {
	PassportTime = true

}
function TestPassport(activator) {
	if (Passported.find(activator) != null) {
		return
	} else {
		activator.TakeDamage(999999, 0, self)
		SpeakLine("HEY HEY HEY fuck youj tough guy !!!!!!!!!!!!!!!!!!!!!! You dont get to..... play aorund here.")
	}
}



function OnPlayerUse(ply) {
	if (!(self.GetName() == "s1_johnborder")) {
		SpeakLine("HEY HEY HEY watch it tough guy!!!!!!!!!!!!!!!!!!!!!!")
		return
	}

	if ((PassportTime==true) && (Passported.find(ply) == null)) {
		SpeakLine("Thank you sir!!!!!!!!!!!!!!!😀 You may now pass throughj. .... SAFELY", ply)
		Passported.append(ply)
	}

}

PassportTime <- false

function BorderThink() {
	// if (PassportTime == true) {

	// }
}


