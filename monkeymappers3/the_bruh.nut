player_scan_radius <- 1024
offset_vec <- Vector(0,0,128)

vEndingDist <- 1024
vEndPos <- Entities.FindByName(null, "fi_the_bruh_destpos").GetOrigin()


SFX_Disappear <- "eltra/rr_thud01.mp3"

function OnPostSpawn() {
    
    AddThinkToEnt(self, "Think")
}

function Think() {
    
    local vOrigin = self.GetOrigin()
    local vNextOrigin = vOrigin + Vector(0,0,(sin(Time() * 3)*1))


    local rapid_update = false
    local AddVec = Vector(0,0,0)
    for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, player_scan_radius);) {
        if (ply.GetTeam() == TEAMS.HUMANS) {
            local pOrigin = ply.EyePosition() + offset_vec


            AddVec += GetMovementVector(pOrigin, vOrigin) * (clamp(player_scan_radius/(GetDistance2D(pOrigin,vOrigin)) - 1, 0, 1)) * 1
            rapid_update = true            
        }
    }

    local end_dist = GetDistance2D(vOrigin, vEndPos)
    if (end_dist < vEndingDist) {
        vNextOrigin += GetMovementVector(vEndPos,  vOrigin) * 10
        self.SetAbsAngles(self.GetAbsAngles() + QAngle(0, 12, 0))
        AddVec *= 0
        rapid_update = true
    }
    if (end_dist < 4) {
        AddThinkToEnt(self, "")
        self.SetAbsAngles(QAngle(0,0,0))
        PlaySoundGlobal(SFX_Disappear)
        PlaySoundGlobal(SFX_Disappear)
        PlaySoundGlobal(SFX_Disappear)
        PlaySoundGlobal(SFX_Disappear)
        ScreenFade(null, 255, 255, 255, 255, 1, 0.1, FFADE_OUT)
        MapSys.BruhPassthrough()
        return
    }




    self.KeyValueFromVector("origin", vNextOrigin + AddVec)
    if (rapid_update) {
        return -1
    } else {
        return 0.5
    }
}

