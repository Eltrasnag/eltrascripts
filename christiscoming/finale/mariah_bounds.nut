function OnPostSpawn() {
	local vOrigin = self.GetOrigin()
	::MARIAH_BOUNDS_MIN <- self.GetBoundingMins() + vOrigin
	printl("min bounds: "+MARIAH_BOUNDS_MIN)
	::MARIAH_BOUNDS_MAX <- self.GetBoundingMaxs() + vOrigin
	printl("max bounds: "+MARIAH_BOUNDS_MAX)
}