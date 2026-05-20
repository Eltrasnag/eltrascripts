// save this to a new file in your /scripts/vscripts/ folder and set the `vscripts` keyvalue on the entity to the filename.
function OnPostSpawn()
{
    // m_angRotation will fail to hit 360,000.0, reset it a bit earlier
    local maxangle = 359000.0
    local xyz = array(3, 0.0)

    self.ValidateScriptScope()
    local scope = self.GetScriptScope()

    // if using your own think function, copy the contents from this function to yours and delete this.
    scope.RotateFixThink <- function() {

        for (local i = 0; i < 3; i++)
        {
            xyz[i] = NetProps.GetPropFloat(self, format("m_angRotation[%d]", i))

            if ( xyz[i] == 0.0 || xyz[i] < maxangle) continue

            xyz[i] %= 360.0
            self.SetLocalAngles(QAngle(xyz[0], xyz[1], xyz[2]))
            break
        }
        return -1
    }
    // remove this if setting your own think separately.
    AddThinkToEnt(self, "RotateFixThink")

    scope.noise <- NetProps.GetPropString(self, "m_NoiseRunning")

    // see OnDestroy callback on the script functions page.
    scope.setdelegate({}.setdelegate({
        id       = self.GetScriptId()
        index    = self.entindex()
        parent   = scope.getdelegate()
        _delslot = function(k)
        {
            if (k == id)
            {
                local ent = EntIndexToHScript(index)
                StopAmbientSoundOn(ent.GetScriptScope().noise, ent)
            }
            delete parent[k];
        }
    }))
}