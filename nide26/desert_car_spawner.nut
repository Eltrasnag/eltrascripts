
car_table <- {
	targetname = "s1_desert_car"
	origin = self.GetOrigin() + Vector(0,0,16),
	angles = self.GetAbsAngles(),
	vscripts = "eltrasnag/nide26/desert_car.nut"
}

DESERT_CAR_ARRAY <- ["models/props_vehicles/truck001a.mdl","models/props_vehicles/car002a.mdl","models/props_vehicles/car002b.mdl", "models/props_vehicles/car003a.mdl", "models/props_vehicles/car003b.mdl", "models/props_vehicles/car004a.mdl", "models/props_vehicles/car005a.mdl", "models/props_vehicles/truck003a.mdl"]
const DESERT_CAR_SPEED = 128

DESERT_CAR_SPAWN_PI <- PI/12.0

function Setup() {
	AddThinkToEnt(self, "Think")
}

function Think() {
	local vOrigin = self.GetOrigin() + Vector(0,0,64)

	car_table.model <- DESERT_CAR_ARRAY[RandomInt(0, DESERT_CAR_ARRAY.len() - 1)]

	local car = Spawn("prop_dynamic_override", car_table)

	car.ValidateScriptScope()
	car.GetScriptScope().v_EndOrigin <- QuickTrace(vOrigin, vOrigin + (self.GetForwardVector()*100000)).pos

	AddThinkToEnt(car, "Think")

	return RandomInt(2, 8) * clamp(sin(Time() * DESERT_CAR_SPAWN_PI), 0.5, 8)
}