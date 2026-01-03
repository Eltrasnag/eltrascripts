const IN_USE = 32
const IN_ATTACK = 1


Price <- 5
Team <- 3 // ct is 3, t is 2


function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
}

function Think() {
	// printl("gunthinky")
	local self_pos = self.GetOrigin()

	for (local i = null; i = Entities.FindByClassnameWithin(i, "player", self_pos, 256);) {
		local buttons = NetProps.GetPropInt(i, "m_nButtons")
		if ((buttons & IN_USE) || (buttons & IN_ATTACK)) {
			local player = i
			local eyepos = player.EyePosition()

			local trace = {
				start = eyepos,
				end = eyepos + player.EyeAngles().Forward() * 300,
				ignore = player,
			}

			TraceLineEx(trace)
			// DebugDrawLine(trace.startpos,trace.endpos,255,255,255,false,0.05)
			// printl(trace.enthit)
			if ((trace.hit) && (trace.enthit) && (trace.enthit == self))
			{


					// LookAtEntity(player)
					player.ValidateScriptScope()
					local player_scope = player.GetScriptScope()

					if (player_scope.Money >= Price)
					{
						if ((player_scope.Purchase_Array.find(self) == null))
						{
							player_scope.Purchase_Array.append(self)
							player_scope.Money -= Price
							local p_pos = player_scope.self.GetOrigin()
							local weap = SpawnEntityFromTable(self.GetClassname(), {
								origin = p_pos
							})

						}
						else {
							ClientPrint(player, 4, "-= You either aren't allowed to buy this, or you already own it! =-")
						}
					}
					else {
						ClientPrint(player, 4, "-= YOU ARE TOO POOR!!!!!! COME BACK WHEN YOU HAVE A LITTLE BIT MORE .... 'PESO-WRY'")
					}


			}


		}
	}

	return -1

}