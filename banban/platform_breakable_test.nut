function OnPostSpawn()
{
    if (RandomInt(0, 3)==RandomInt(0, 5))
    {
        // local MEMYSELFANDI = self
        printl("lalala i will break and kill evilly")
        QFireByHandle(self, "AddOutput", "spawnflags 2", 0.00, null, null)
        // EntityOutputs.AddOutput(self, "OnBreak", "banplatforms_counter", "Add", "1")
        EntityOutputs.AddOutput(self, "OnBreak", "banplatforms_counter", "Add", "1", 0.00, -1)
    }

}

function KillSound()
{
    // to do
}