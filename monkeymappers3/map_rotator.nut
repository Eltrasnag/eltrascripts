function OnPostSpawn() {
    self.ConnectOutput("OnUser1", "StartRotation")
}

function StartRotation() {
    AddThinkToEnt(self, "RotThink")
    QFireByHandle(self, "StartForward")
}

function RotThink() {
    local vAngles = self.GetAbsAngles()
    local vOrigin = self.GetOrigin()

    if (vAngles.Pitch() >= 5) {
        QFireByHandle(self, "StartBackward")
    }
    if (vAngles.Pitch() <= -5) {
        QFireByHandle(self, "StartForward")
    }
    
    // KeyValue
    self.KeyValueFromInt("maxspeed", abs(sin(Time() * 0.5) * 4))
    

}