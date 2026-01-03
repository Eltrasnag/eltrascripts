const MONEY_SOUND = "eltra/sfx_money.mp3"
const MONEY_PARTICLE_NAME = "li_money_pickup"
Coin_Pos <- self.GetOrigin() + Vector(0,0,20)




function OnPostSpawn() {
	self.SetAbsOrigin(Coin_Pos)
	self.AcceptInput("SetAnimation","rotate",null,null)
	AddThinkToEnt(self, "Think")
}

function Think() {
	try {
		local self_pos = self.GetOrigin()

		local time_val = Time()
		if (self.GetClassname() == "prop_dynamic") {

			self.SetAbsOrigin(Coin_Pos + Vector(0, 0, sin(time_val*2)))

			// self.SetAbsAngles(self.GetAbsAngles()+QAngle(0,time_val*0.5,0))

		}
		for (local i = null; i = Entities.FindByClassnameWithin(i, "player", self_pos, 64);) {
			if (ValidEntity(i)) {

				i.ValidateScriptScope()

				local p_scope = i.GetScriptScope()
				PrecacheSound(MONEY_SOUND)
				EmitSoundEx({
					sound_name = MONEY_SOUND,
					origin = i.GetOrigin(),
					channel = 3,
					volume = 1.0,
					sound_level = 0.27,
				})
				PrecacheParticle(MONEY_PARTICLE_NAME)
				DispatchParticleEffect(MONEY_PARTICLE_NAME, Coin_Pos, Vector(0,0,0))
				p_scope.AddMoney(1)
				self.Destroy()
			}
		}

	} catch (exception){
		// girl whatever
	}

}