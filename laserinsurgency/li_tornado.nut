hParticle <- null;

ModelArray <- ["models/propper/li_stage2/tornado_building_01.mdl", "models/props_wasteland/boat_fishing01a.mdl", "models/props_wasteland/coolingtank01.mdl", "models/props_wasteland/cargo_container01b.mdl","models/props_wasteland/cargo_container01c.mdl", "models/props_wasteland/crane01a.mdl", "models/props_wasteland/horizontalcoolingtank04.mdl", "models/props_wasteland/medbridge_base01.mdl", "models/props_wasteland/powertower01_old.mdl", "models/props_wasteland/rockgranite01c.mdl", "models/props_wasteland/watertower02.mdl", "models/props_wasteland/watertower03.mdl", "models/props_wasteland/watertower03.mdl", "models/props_wasteland/wreckingball001.mdl", "models/props_farm/renault_yl_physic.mdl", ""]

iWaitTime <- 0.5
iTime <- 0

iFunnelRadius <- 4544

function OnPostSpawn() {
	hParticle = SpawnEntityFromTable("info_particle_system", {
		effect_name = "f5_funnel",
		targetname = "f5_fx",
		start_active = 1,
		angles = "0 0 0",
		origin = "0 0 0"
	})
	AddThinkToEnt(self,"TornadoThink")
	// SetParentEX(hParticle, self)
}

function TornadoThink() {

	local vOrigin = self.GetOrigin()

	if (iTime >= iWaitTime && RandomInt(0,4) == 2) {
		iTime = 0
		local strModel = ModelArray[RandomInt(0, ModelArray.len() - 1)]
		PrecacheModel(strModel)
		local hProp = SpawnEntityFromTable("prop_physics_override", {
			origin = Vector(vOrigin.x + RandomInt(-iFunnelRadius, iFunnelRadius), vOrigin.y - 2018, vOrigin.z + RandomInt(128,2048)),
			model = strModel,
			overridescript = "friction,0.1,rotdamping,0",
			angles = RandomInt(0,360).tostring()+" "+RandomInt(0,360).tostring()+" "+RandomInt(0,360).tostring(),
			massScale = 20,
		})

		hProp.ValidateScriptScope()
		local hPropScope = hProp.GetScriptScope()

		hProp.ApplyAbsVelocityImpulse(Vector(0,-RandomInt(70000,20000), RandomInt(1000,5000)))
		hPropScope.PropThink <- PropThink
		hPropScope.iLifetime <- 0
		hPropScope.iDecayTime <- 50
		AddThinkToEnt(hProp, "PropThink")

	}
	iTime++
	return 0.5
}

function PropThink() {
	if (iLifetime >= iDecayTime) {
		self.Kill()
		return
	}
	self.ApplyAbsVelocityImpulse(Vector(0,-1000,0))
	iLifetime++
	return 0.5
}
