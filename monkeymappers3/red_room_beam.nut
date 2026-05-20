function OnPostSpawn() {
    self.ConnectOutput("OnStartTouch", "StartTouch")
    self.ConnectOutput("OnEndTouch", "EndTouch")
}

const rr_flLookThreshold = -60

function StartTouch() {
    activator.ValidateScriptScope()
    local scope = activator.GetScriptScope()
    scope.PlayerRiseThink <- PlayerRiseThink
    AddThinkToEnt(activator, "PlayerRiseThink")
    
}

function EndTouch() {
    AddThinkToEnt(activator, "")

}

function PlayerRiseThink() {
    local delta = FrameTime()

    local vAngles = self.EyeAngles()
    local vOrigin = self.GetOrigin()

    if (vAngles.Pitch() <= rr_flLookThreshold) {
        // go up now
        ScreenFade(null,255,0,0,25,0.5,-1,FADE_IN)
        self.KeyValueFromVector("basevelocity", Vector(0,0,600))
        self.SetAbsOrigin(vOrigin + Vector(0,0,10))
    }
    return -1
}