players <- []
bluplayers <- []
tt <- 0
hptext <- Entities.FindByName(null,"boss_text");
vMainOrigin <- self.GetOrigin()
hTarget <- null;
flNextTargetTime <- 0;
iTaylorSpeed <- 300;
iHealthAdd <- 400;

function OnPostSpawn()
{
    local pindex = 0
    local maxplayers = MaxClients().tointeger()
    for (local p1 = 1;p1 < maxplayers;p1++)
    {

        players.push(EntIndexToHScript(p1))
        // printl(players[pindex])
        pindex++
    }

    foreach (player in players)
    {
        if (player != null && player.IsValid() && self != null && self.IsValid() && player.GetTeam() == 3)
        {
            bluplayers.push(player)
        }
    }
    AddThinkToEnt(self, "The_thinker")
    self.SetHealth(bluplayers.len()*iHealthAdd)
}

function The_thinker()
{
	if (self == null || !self.IsValid()) {
		return
	}

	local vAddVec = Vector(0,0,0)
	local vOrigin = self.GetOrigin()
	if (hTarget == null || !hTarget.IsValid() || Time() >= flNextTargetTime) {
		ReTarget()
	}
	if (hTarget != null && hTarget.IsValid()) {
		local angs = GetAngleFromEntity(hTarget, self)
		self.SetAbsAngles(angs)
		vAddVec += angs.Forward() * -(iTaylorSpeed + RandomInt(-50, 200)) * 0.01
		if (vOrigin.z > hTarget.GetOrigin().z) {

		}
	}

    // printl(tt)
    if (tt >= 1000)
    {
        if (taylors <= 1000)
        {
        QFire("incubus_taylorspawners*", "Trigger", "", 0.00, null);
        }
        tt = 0
    }
    tt++

	local vOrigin = self.GetOrigin()
	vOrigin.z = vMainOrigin.z + sin(Time()*2) * 20 + vAddVec.z
	self.KeyValueFromVector("origin",vOrigin + vAddVec)

    if(hptext.IsValid()&&hptext)
    {
        hptext.KeyValueFromString("message", "-=INCUBUS - "+self.GetHealth()+" HP=-")
        hptext.AcceptInput("Display","",null,null)
    }
    return 0.05

}

function ReTarget() {
	hTarget = RandomCT()
}