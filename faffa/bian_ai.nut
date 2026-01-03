function CanMove()
{
    local compare1 = RandomInt(1, 2000);
    local compare2 = RandomInt(1, 200000);
    if (compare2==compare1)
    {
        Office();
    }
}
function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
}

function Think() {
	CanMove();
	return 20
}

function Office()
{
    self.SetAbsOrigin(Vector(0, -1560, 0))
    QFire("sf_door_alert", "PlaySound", "", 0.00, null);
}