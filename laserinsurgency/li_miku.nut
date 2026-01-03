iMikuMoney <- 0;
hText <- SpawnEntityFromTable("point_worldtext", {
    color = "242 226 225 255",
    font = 5,
    message = "",
    orientation = 1,
    origin = self.GetOrigin() + Vector(0,0,64),
    parent = self,
})

function PlayAnimation(strAnimName) {
	self.AcceptInput("SetAnimation", strAnimName, null, null)
}

function OnPostSpawn() {

}

function GiveMoney(iAmount = 1) {
	local activator_scope = activator.GetScriptScope()
	
	if (activator_scope.iMoney > 0) {
		activator_scope.iMoney--
		iMikuMoney++
		
		hText.AcceptInput("AddOutput","message MONEY : "+iMikuMoney.tostring(), null, null)

		PrecacheSound("eltra/cash_register.mp3")
		EmitAmbientSoundOn("eltra/cash_register.mp3", 100, 0.2, 100, self)
	}

	if (iMikuMoney == 50) {
		QFire("s2_mikumover", "StartForward", "", 0.0, null)
		QFire("s2_mikumoneybutton", "Kill", "", 0.0, null)
		
	}
}