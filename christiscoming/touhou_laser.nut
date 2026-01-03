iLifeTime <- 0
iLiveTime <- 3
iSpeed <- 100
iSize <- 1

function OnPostSpawn() {
    TOUHOU_ENTITIES_LIMIT ++
	
    if (TouhouOverflow()) {
		self.Destroy()
		printl("ELTRACOMMONS: Not spawning entity due to TOUHOU_MAXENTITIES overflow!")
		return
	}

    iLifeTime = Time() + iLiveTime
    AddThinkToEnt(self, "Think")

}

function Think() {

    if (Time() >= iLiveTime) {
        AddThinkToEnt(self, "")
        self.Destroy()
        TOUHOU_ENTITIES_LIMIT--
        return
    }
    local vOrigin = self.GetOrigin()
    local vForward = self.GetForwardVector()

    self.KeyValueFromVector("origin", vOrigin + ((vForward * iSpeed) * FrameTime()))

    for (local ply; ply = Entities.FindByClassnameWithin(ply, "func_door", vOrigin - (vForward * 8 * iSize), iSize * 40) ;) { // subt forward from trace to give some mercy to high pingers
        ply.ValidateScriptScope()
        local scope = ply.GetScriptScope()
        if (ply.GetName() == TOUHOU_PLAYERNAME && "TakeTouhouDamage" in scope) {
            scope.TakeTouhouDamage()
        }
    }

    return 0.5
}