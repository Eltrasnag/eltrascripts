::iFanSpeed <- 0

FanPropDecayTime <- 100

NextSpawnTime <- 0

hVisFan <- Entities.FindByName(null, "fi_fan_vis")

ModelArray <- [
    "models/props_vehicles/van001a_physics.mdl",
    "models/props_wasteland/boat_fishing01a.mdl",
    "models/props_wasteland/coolingtank01.mdl",
    "models/props_wasteland/cargo_container01b.mdl",
    "models/props_wasteland/cargo_container01c.mdl",
    "models/props_junk/pushcart01a.mdl",
    "models/props_wasteland/horizontalcoolingtank04.mdl",
    "models/props_wasteland/medbridge_base01.mdl",
    "models/props_wasteland/powertower01_old.mdl",
    "models/props_wasteland/rockgranite01c.mdl",
    "models/props_wasteland/watertower02.mdl",
    "models/props_wasteland/watertower03.mdl",
    "models/props_vehicles/car003b_physics.mdl",
    "models/props_wasteland/wreckingball001.mdl",
    "models/props_vehicles/car003a_physics.mdl",
    "models/props_junk/watermelon01.mdl",
    "models/props_junk/wood_crate001a.mdl",
 ]

iFanRadius <- 656

vForward <- null;

function StartFan() {
    vForward = self.GetForwardVector()
    AddThinkToEnt(self, "FanThink")
    ze_map_say("YOU WILL FIND DANGER WHERE THE WIND BLOWS")
    QFire("mapsys", "RunScriptCode", "ze_map_say(`BE VIGILANT OF THAT WHICH MAY PUNCTURE YOU`)", 2)
}

function StopFan() {
    AddThinkToEnt(self, "")
}


NextFanShakeTime <- 0;

function PropThink() {
	if (iLifetime >= iDecayTime) {
		self.Kill()
		return
	}
    // DebugDrawText(self.GetOrigin(), "Prop here", false, 1)
    // self.SetOrigin(self.GetOrigin() + vForward * 20)
	self.ApplyAbsVelocityImpulse(vForward * iFanSpeed * 1000)
	iLifetime++
	return 0.1
}


FanShakeTime <- 1

NextFanSoundTime <- 0
FanSoundInterval <- 0.5

FanSounds <- ["eltra/mm3/tear_terrain0.mp3",
"eltra/mm3/tear_terrain1.mp3",
"eltra/mm3/tear_terrain2.mp3",
"eltra/mm3/tear_terrain3.mp3",
"eltra/mm3/tear_terrain4.mp3"]
FanSoundsMax <- FanSounds.len() - 1

function FanThink() {
    
    if (!hVisFan) {
        return
    }

    local vOrigin = self.GetOrigin()
    local vAngles = self.GetAbsAngles()
    local vis_angles = hVisFan.GetAbsAngles()
    local flTime = Time()

    vis_angles.z += iFanSpeed * 200


    hVisFan.SetAbsAngles(vis_angles)


    if (flTime >= NextFanSoundTime && iFanSpeed > 0) {
        PlaySoundGlobal(FanSounds[RandomInt(0, FanSoundsMax)], clamp(iFanSpeed * 100, 75, 100))
        NextFanSoundTime = flTime + FanSoundInterval
    }

    if (flTime >= NextFanShakeTime) {
        NextFanShakeTime = Time() + FanShakeTime
        ScreenShake(vOrigin ,16 * iFanSpeed * 2, 0.01, FanShakeTime*2, 9999999, SHAKE_START, true)
    }


    if (flTime >= NextSpawnTime) {
        NextSpawnTime = flTime += 0.25


        // make a doom prop

		local strModel = ModelArray[RandomInt(0, ModelArray.len() - 1)]
		PrecacheModel(strModel)

		local hProp = Spawn("prop_physics_override", {
			origin = Vector(vOrigin.x + RandomInt(-iFanRadius, iFanRadius), vOrigin.y + RandomInt(-iFanRadius, iFanRadius), vOrigin.z),
			model = strModel,
			overridescript = "friction,0.1,rotdamping,0",
			angles = RandomInt(0,360).tostring()+" "+RandomInt(0,360).tostring()+" "+RandomInt(0,360).tostring(),
			massScale = 20,
		})

		hProp.ValidateScriptScope()
		local hPropScope = hProp.GetScriptScope()

		// hProp.ApplyAbsVelocityImpulse(Vector(0,-RandomInt(70000,20000), RandomInt(1000,5000)))
        hProp.ApplyAbsVelocityImpulse((vForward * RandomInt(7000, 2000) * iFanSpeed) + (vAngles.Up() * RandomInt(-5000,5000)))
		hPropScope.PropThink <- PropThink
		hPropScope.iLifetime <- 0
		hPropScope.iDecayTime <- FanPropDecayTime
        hPropScope.vForward <- vForward
		AddThinkToEnt(hProp, "PropThink")



    }

    local fan_sine = sin(flTime * 0.25)
    iFanSpeed = clamp(fan_sine, 0, 1)
    

    return 0.1
}