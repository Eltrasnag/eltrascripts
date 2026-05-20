BrianColors <- ["255 0 0", "245 190 118", "119 247 228", "157 107 227", "245 118 163", "151 255 122", "255 129 122"]

BrianColorMax <- BrianColors.len() - 1
BrianColorIndex <- RandomInt(1,BrianColorMax)
SFX_BrianApply <- "eltra/brian_gem.mp3"
LastBrianColorIndex <- BrianColorIndex

Active <- true


function OnPostSpawn() {
    NetProps.SetPropInt(self, "m_takedamage", 1)
    AddThinkToEnt(self, "BrianThink")
    self.ConnectOutput("OnHealthChanged", "HealthChanged")
    BrianColorIndex = RandomInt(1,BrianColorMax)
    BrianCount += 1
}

function BrianThink() {

    if (!Active) {
        return 10
    }

    if (BrianColorIndex != LastBrianColorIndex) {
        self.SetModelScale(RandomFloat(1.1, 1.18), 0)
        if (BrianColorIndex < 0) {
            BrianColorIndex = BrianColorMax
        } else if (BrianColorMax < BrianColorIndex) {
            BrianColorIndex = 0
        }

        PlaySoundGlobal(SFX_BrianApply, (120 + BrianColorIndex * 10))
        self.KeyValueFromString("rendercolor", BrianColors[BrianColorIndex])

        local brianarray_idx = CorrectBrians.find(self)

        if (BrianColorIndex == CorrectBrianColor) {
            if (!brianarray_idx) {
                MapSys.CorrectBrians.append(self)
                // printl("Grace.")

                if (MapSys.CorrectBrians.len() == BrianCount) {
                    printl("All brians are content. Open portal")
                    MapSys.OpenRedRoomPortal()
                    AddThinkToEnt(self, "")
                    return
                }
            }
        }
        else if (brianarray_idx && brianarray_idx != null && CorrectBrians && self in CorrectBrians) {

            {
                CorrectBrians.erase(MapSys.CorrectBrians.find(self))
            }
        }
        self.SetModelScale(1, 0.23)

    }

    LastBrianColorIndex = BrianColorIndex





    return 0.1
}

function HealthChanged() {
    BrianColorIndex += 1

}
