if (!("SPAWNERS" in getroottable())) {
	::SPAWNERS <- {};
}

function OnPostSpawn() {
	SPAWNERS[self.GetName().tostring()]
}