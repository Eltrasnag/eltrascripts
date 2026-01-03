
OverrideOrigin <- Vector(0,0,0)

function PreSpawnInstance(entity_class, entity_name) {
	local origin = OverrideOrigin
	return origin
}