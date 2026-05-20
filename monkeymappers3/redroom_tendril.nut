RandomSeed <- RandomFloat(0.001, 0.5)

SFX_TendrilMoan <- "ambient/animal/cow.wav"

NextMoanTime <- 0

MoanWaitLength <- RandomFloat(9, 20)

function OnPostSpawn() {
    self.ConnectOutput("OnUser1", "Start")
}

function Start() {
    AddThinkToEnt(self, "RotThink")
}

function RotThink() {
    local vAngles = self.GetAbsAngles()
    local vOrigin = self.GetOrigin()
    // printl("test")
    if ((Time() >= NextMoanTime) && (RandomInt(0,15) == 1)) {
        NextMoanTime = Time() + MoanWaitLength + RandomInt(-2,2)
        PlaySoundEX(SFX_TendrilMoan, self, 10, RandomInt(25, 40), self, 99999)
    }
    vAngles += QAngle(0, RandomSeed, 0)
    // self.KeyValueFromInt("maxspeed", abs(sin(Time() * 0.5) * 4))
    self.SetAbsAngles(vAngles)
    
    return 0.05
}