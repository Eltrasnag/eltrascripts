const SALMON_DEV = false
hTarget <- null;
vStartPos <- self.GetOrigin();
vStartAng <- self.GetAbsAngles();
flStartZ <- vStartPos.z;

iHealth <- 500
iHealthAdd <- 119
const TargetMusic = "music/eltra/banban_targetted.mp3"
delta <- 0.01

bAltTick <- true
bAttackStart <- true
vLastAng <- vStartAng

next_teamcheck_time <- 0
teamcheck_wait <- 3

flChaseSpeed <- 5
flMaxChaseSpeed <- 1000
flCurrentSpeed <- 0

salmonella_movesubt <- 0.001
flJumpHeight <- 768

flNextPizzaTime <- 0
flPizzaWait <- 1

bIsFollowing <- false

// local hText = Entities.CreateByClassname()

// tHitList <- {
// 	"0" <- "STEAM_0:1:595146344" {

// 	}
// }

iAttackRound <- 0;

flNextAttackTime <- 0;
flNextReTargetTime <- 0;

iReTargetTime <- 7
iAttackTime <- 2
iHUDWait <- 0.5;
flNextHudTime <- 0;
enum SALMONELLA_ATTACKS{NONE, JUMP, PIZZA, BONNIE, WIND, DEV_END}

iCurrentAttack <- SALMONELLA_ATTACKS.NONE


function OnPostSpawn() {
	self.KeyValueFromInt("solid", 6)
	self.ConnectOutput("OnHealthChanged","OnHealthChanged")
	self.ConnectOutput("OnBreak","Die")
}


function MainThink() { // the main thinker
	// Keep this at top of think!!!
	local flTime = Time()

	if (iHealth <= 0) {
		AddThinkToEnt(self,"")
		Die()
		return
	}

	if (bAltTick) {
		bAltTick = false
	}
	else {
		bAltTick = true
	}

	if (flTime >= flNextAttackTime) {
		bAttackStart = true
		if (iCurrentAttack != SALMONELLA_ATTACKS.NONE) {
			iCurrentAttack = SALMONELLA_ATTACKS.NONE
			flMaxChaseSpeed = flChaseSpeed
			flNextAttackTime = flTime + iAttackTime*2;
		}
		else {

			iCurrentAttack = RandomInt(SALMONELLA_ATTACKS.JUMP, SALMONELLA_ATTACKS.DEV_END - 1);
			flNextAttackTime = flTime + iAttackTime;
		}
	}


	if (flTime >= flNextHudTime) { // cubtoverflow my balllssss
		flNextHudTime = flTime + iHUDWait
		local GameText = SpawnEntityFromTable("game_text", { // temp
			message = "-= LESHAWNA BALL OC - " + iHealth.tostring() + " HP =-",
			fadein = 0.1,
			fadeout = 0.1,
			holdtime = 0.5,
			channel = 3,
			effect = 0,
			color = "180 0 255"
			spawnflags = 1,
			x = -1,
			y = 0.2,
		})
		QFireByHandle(GameText, "Display")
		GameText.Kill()

		local TargText = SpawnEntityFromTable("game_text", { // temp
			message = "| CURRENTLY CHASING : "+GetPlayerName(hTarget)+" |",
			fadein = 0.1,
			fadeout = 0.1,
			holdtime = 0.5,
			channel = 5,
			effect = 0,
			color = "255 0 0"
			spawnflags = 1,
			x = -1,
			y = 0.25,
		})
		QFireByHandle(TargText, "Display")
		TargText.Kill()
	}

	if (hTarget == null || !hTarget.IsValid() || flTime >= flNextReTargetTime || NetProps.GetPropInt(hTarget, "m_lifeState") == 3 || hTarget.GetTeam() == TEAMS.ZOMBIES) {
		if ((hTarget != null && hTarget.IsValid()) && !SALMON_DEV) {
			hTarget.SetScriptOverlayMaterial("")
			StopAmbientSoundOn(TargetMusic, hTarget)
		}
		// flCurrentSpeed = 0
		hTarget = RandomCT()
		if (!SALMON_DEV) {
			PrecacheSound(TargetMusic)
			hTarget.SetScriptOverlayMaterial("eltra/banban_run")
			EmitAmbientSoundOn(TargetMusic, 10.0, 100, 100, hTarget)
		}
		flNextReTargetTime = flTime + iReTargetTime

		return // reset function just to be safe
	}

	local vOrigin = self.GetOrigin()
	local vAng = self.GetAbsAngles()

	local vTargOrigin = hTarget.GetOrigin()
	local vTargAng = hTarget.GetAbsAngles()

	// angle lerp (?)
	// vAng = vAng + ((vAng - vStartAng) / FrameTime())
	if (flTime >= next_teamcheck_time) {
		next_teamcheck_time = flTime + teamcheck_wait
		local bluplayers = 0
		for (local p; p = Entities.FindByClassname(p, "player");) {
			if (p.GetTeam() == TEAMS.HUMANS) {
				bluplayers++
			}
		}
		if (bluplayers <= 5) {
			salmonella_movesubt = 1
		}
	}
	bIsFollowing = true
	local vLook = GetLookVector(self, hTarget)

	self.SetForwardVector(GetLookVector(hTarget, self) * -1)
	vAng = self.GetAbsAngles()

	switch (iCurrentAttack) {
		case SALMONELLA_ATTACKS.NONE:
		self.KeyValueFromInt("solid", 1)
		vOrigin.z = vStartPos.z + 500 + sin(flTime * 3)*128
		break;

		case SALMONELLA_ATTACKS.JUMP:
		if (bAttackStart) {
			bAttackStart = false
			vOrigin += Vector(RandomInt(-2000,2000),RandomInt(-2000,2000),0)
		}

		flCurrentSpeed = 20
		flMaxChaseSpeed = 30
		for (local ent; ent = Entities.FindInSphere(ent, vOrigin, 256);) {
			if (ValidEntity(ent) && ent.GetTeam() == TEAMS.HUMANS) {
				MapSys.Jumpscare(ent);
				ent.TakeDamage(15, Constants.FDmgType.DMG_ACID, null);

			}
			continue;
		}
		printl("i be jum[ing]")
		vAng.x = 0
		vAng.z = 0
		vOrigin.z = vStartPos.z + abs(sin(Time() * 5.0)*1000)
		break;

		case SALMONELLA_ATTACKS.PIZZA:


			if (flTime >= flNextPizzaTime) {
				print("pizzatime")
				flNextPizzaTime = flTime + flPizzaWait

				local tTrace = { // trace to put pizza on the ground
					start = vOrigin,
					end = vOrigin + Vector(0,0,-8000) + vLook * 512,
					mask = 131083,
					ignore = self,
				}


				TraceLineEx(tTrace)


				if ("endpos" in tTrace) {

					local vPizzaPos = tTrace.endpos

					local pizza = SpawnEntityFromTable("func_physbox_multiplayer", {
						model = BRUSHMODELS["salmonella_pizza_visual"],
						origin = vPizzaPos,
						health = 100,
						spawnflags = 49152
					})

					local pizza_trigger = SpawnEntityFromTable("trigger_multiple", {
						model = BRUSHMODELS["salmonella_pizza_triggerbox"],
						origin = vPizzaPos,
						spawnflags = 1

					})

					SetParentEX(pizza_trigger, pizza)

					pizza.ValidateScriptScope()

					local scope = pizza.GetScriptScope()

					EntityOutputs.AddOutput(pizza_trigger, "OnTrigger", "mapsys", "RunScriptCode", "LHPizza(activator)", 0.00, -1)

					scope.PizzaThink <- PizzaThink;
					scope.flDeathTime <- flTime + 8
					AddThinkToEnt(pizza,"PizzaThink")

				}


			}
		break;

		case SALMONELLA_ATTACKS.BONNIE:
			if (bAltTick) {
				flMaxChaseSpeed = 0
				flCurrentSpeed = 0
				local bonnie = SpawnEntityFromTable("func_breakable", {
					model = BRUSHMODELS["salmonella_bonnie"],
					origin = vOrigin + Vector(RandomInt(-1024,1024),RandomInt(-1024,1024),256),
					health = 1,
					solid = 0
				})
				bonnie.ValidateScriptScope()
				local scope = bonnie.GetScriptScope()
				scope.BonnieThink <- BonnieThink;
				scope.hTarget <- hTarget;
				AddThinkToEnt(bonnie,"BonnieThink")

			}

		break;

		case SALMONELLA_ATTACKS.WIND:
			self.KeyValueFromInt("solid", 0)
			local WindTarget = RandomCT()
			WindTarget.SetAbsVelocity(WindTarget.GetAbsVelocity() + (vLook * 3000 * sin(flTime * 2)))
			if (bAltTick) {

				PlaySoundEX("ambient/wind/windgust.wav", vTargOrigin)
			}
		break;


	}


	if (bIsFollowing) {
		// vAng.y = vLook.y * (PI/180)

		if (flCurrentSpeed < flMaxChaseSpeed) { // if we are too slow then do a speedup

			flCurrentSpeed += flChaseSpeed * delta * 2
		}
		vOrigin += (vLook * flCurrentSpeed * -1)
	}

	self.KeyValueFromVector("origin", vOrigin)
	self.SetAbsAngles(vAng)
	return delta
}

function WaitingThink() { // waiting to select a target

}

function ChasingThink() { // chasing a player


}

function OnHealthChanged() {
	iHealth--


	flCurrentSpeed -= salmonella_movesubt
	self.AcceptInput("color", "255 0 0", null, null);
	QFireByHandle(self, "color", "255 255 255", 0.01);
	// printl("ow")
	PlaySoundEX("eltra/pussy.mp3", self.GetOrigin(), RandomInt(9,10), RandomFloat(60,160))

}


function Triggered() {
	QFire("mus_s2_salmonella","PlaySound")
	QFire("mus_s2_sabslide","StopSound")
	AddThinkToEnt(self,"MainThink")
	for (local ply; ply = Entities.FindByClassname(ply, "player");) {
		if (ply.GetTeam() == TEAMS.HUMANS) {
			iHealth += 119

		}
	}
}

function BonnieThink() {
	if (self == null || !self.IsValid()) {
		return
	}
	local vOrigin = self.GetOrigin()
	if (!ValidEntity(hTarget)) {

		hTarget = RandomCT()
	}
	local lvec = GetLookVector(self, hTarget)

	self.SetForwardVector(lvec)
	vOrigin += lvec * -15
	self.KeyValueFromVector("origin", vOrigin)
	local distance = GetDistance2D(hTarget.GetOrigin(), vOrigin)

	if (distance < 32) {
		for (local ent; ent = Entities.FindInSphere(ent, vOrigin, 128);) {
			if (ValidEntity(ent) && ent.GetTeam() == TEAMS.HUMANS) {
				MapSys.Jumpscare(ent);
				ent.TakeDamage(2, Constants.FDmgType.DMG_ACID, null);

			}
		}
		self.Kill()
		return 0.1
	}

	return -1
}

function PizzaThink() {
	if (Time() >= flDeathTime) {
		self.AcceptInput("KillHierarchy", "", null, null);
	}
}

function Die() {
	QFire("mus_s2_salmonella", "StopSound")
	QFire("s2_salmonella_postdoors", "Break","",2)
	ze_map_say("*** LESHAWNA BALL OC.... IS DEAD ***")
	MapSayDelay("Ok lets continue now","Map", 2.0)
	QFire("mus_s2_intestines", "PlaySound","",2)
	for (local ply; ply = Entities.FindByClassname(ply, "player");)	{
		ply.SetScriptOverlayMaterial("")
	}
	local vOrigin =self.GetOrigin()
	PlaySound("eltra/what_da_hell.mp3",vOrigin)
	PlaySound("eltra/what_da_hell.mp3",vOrigin)
	PlaySound("eltra/what_da_hell.mp3",vOrigin)

}