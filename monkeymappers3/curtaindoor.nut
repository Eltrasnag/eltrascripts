
SFX_Disappear <- "eltra/rr_thud01.mp3"

function OnPostSpawn() {
    self.ConnectOutput("OnUser1", "Open")    
}

function Open() {
    AddThinkToEnt(self, "OpenThink")
}

curtain_accel_rate <- 0.25
curtain_accel <- 0.25

function OpenThink() {
    local vAngles = self.GetAbsAngles()
    local vOrigin = self.GetOrigin()

    curtain_accel += (curtain_accel_rate * curtain_accel)
    
    self.KeyValueFromVector("origin", vOrigin + (vAngles.Forward() * curtain_accel))

    local world_trace = QuickTrace(vOrigin, vOrigin)
    if (world_trace.allsolid) {
        // printl("curtain INSIDE WORLD!!!!!!!!")
        AddThinkToEnt(self, "")
        PlaySoundGlobal(SFX_Disappear)
        PlaySoundGlobal(SFX_Disappear)
        PlaySoundGlobal(SFX_Disappear)
        PlaySoundGlobal(SFX_Disappear)
        self.Kill()
        return
    }


}