hTarget <- null;
iHealthAdd <- 50;
iHealthBase <- 100

NextAttackTime <- 0;
AttackWait <- 3;

vStartOrigin <- self.GetOrigin()

NextRetargetTime <- 0;
RetargetWait <- 3;

bShouldLook <- true
tSpinClasses <- ["prop_physics", "prop_physics_override", "player"];

::iBonnies <- 0;
iMaxBonnies <- 20;

flNextHudTime <- 0;
iHUDWait <- 0.5;
enum ORANGE_ATTACKS{NONE,SPIN_A,SPIN_B,SPIN_C,SPIN_D,SPIN_E,SPIN_F,DEV_MAX_ATTACKS}

CurrentAttack <- ORANGE_ATTACKS.SPIN_A

function OnPostSpawn() {
	self.ConnectOutput("OnBreak","Death")
}


function Death() {
	QFire("mus_s2_orange","Kill")
	QFire("bonniecube*", "Kill")
	QFire("boss_minecart_trigger", "Kill")
	QFire("boss_hurty_box", "KillHierarchy")
	QFire("minecart*", "Break")
	MapSay("oh i guess thats it then","leshawna ball oc")
	QFire("s2_bossexit_h", "Enable", "", 2)
	MapSayDelayed("zombies you camn leave in 10 seconds ok","Map",10)
	QFire("s2_bossexit_z", "Enable", "", 15)
}


function MakeBonnieCube(vOrigin) {
	local bon_origin = vOrigin + Vector(RandomFloat(-1024,1024),RandomFloat(-1024,1024),0)
	local bonnie = SpawnEntityFromTable("func_physbox_multiplayer", {
		model = BRUSHMODELS["salmonella_bonnie"],
		origin = bon_origin,
		targetname = "bonniecube",
		health = 10000,
		massScale = 100,
		material = 2,
		spawnflags = 16384,
		overridescript = "mass,1000"
	})

	bonnie.ValidateScriptScope()
	local scope = bonnie.GetScriptScope()
	scope.BonnieThink <- BonnieThink;
	scope.BonnieDeath <- BonnieDeath;
	bonnie.ConnectOutput("OnBreak","BonnieDeath")
	AddThinkToEnt(bonnie,"BonnieThink")



}
function MainThink() {

	if (self.GetHealth() <= 0) {
		AddThinkToEnt(self, "")
		Death()
		self.Kill()
		return
	}
	local time = Time()
	local vOrigin = self.GetOrigin()
	local vAng = self.GetAbsAngles()
	if (iBonnies < iMaxBonnies) {
		MakeBonnieCube(Vector(10742.430664, -9716.689453, -9175.416992)) // idegaf
		iBonnies++
	}
	// if (!ValidEntity(hTarget)) {
	// 	hTarget = RandomCT()
	// 	return
	// }

	if (time >= flNextHudTime) {
		flNextHudTime = time + iHUDWait
		local GameText = SpawnEntityFromTable("game_text", { // temp
			message = "-= ORANGE - " + self.GetHealth().tostring() + " HP =-",
			fadein = 0.1,
			fadeout = 0.1,
			holdtime = 0.5,
			channel = 3,
			effect = 0,
			color = "242 104 30"
			spawnflags = 1,
			x = -1,
			y = 0.2,
		})
		QFireByHandle(GameText, "Display")
		GameText.Kill()

		// local TargText = SpawnEntityFromTable("game_text", { // temp
		// 	message = "| CURRENTLY CHASING : "+GetPlayerName(hTarget)+" |",
		// 	fadein = 0.1,
		// 	fadeout = 0.1,
		// 	holdtime = 0.5,
		// 	channel = 5,
		// 	effect = 0,
		// 	color = "255 0 0"
		// 	spawnflags = 1,
		// 	x = -1,
		// 	y = 0.25,
		// })
		// QFireByHandle(TargText, "Display")
		// TargText.Kill()
	}

	// if (bShouldLook) {
	// 	self.SetForwardVector(GetLookVector(hTarget, self) * -1)

	// }

	if (NextAttackTime <= time) {
		NextAttackTime = time + AttackWait
		self.AcceptInput("skin", RandomInt(0, 11).tostring(), null, null)
		CurrentAttack = RandomInt(ORANGE_ATTACKS.SPIN_A, ORANGE_ATTACKS.DEV_MAX_ATTACKS - 1)
	}

	// if (NextRetargetTime <= time) {
		// hTarget = RandomCT()
		// NextRetargetTime = time + RetargetWait
	// }

	local ThrowStrength = 0
	// vAng = RotateOrientation(vAng, QAngle(0, 4, 0))
	switch (CurrentAttack) {
		case ORANGE_ATTACKS.SPIN_A:
			vAng = QAngle(sin(time * 0.5) * 360, cos(time * 0.1) * 360)
			ThrowStrength = 3000
		break;

		case ORANGE_ATTACKS.SPIN_B:
			vAng = QAngle(0, 0, 90)
			ThrowStrength = 10000
		break;

		case ORANGE_ATTACKS.SPIN_C:
			vAng = QAngle(0, 0, vAng.z + 5)
			ThrowStrength = 40000
		break;
		case ORANGE_ATTACKS.SPIN_D:
			vAng = QAngle(0, 90, 0)
			ThrowStrength = 20000
		break;
		case ORANGE_ATTACKS.SPIN_E:
			vAng = QAngle(0, 0, 0)
			ThrowStrength = 0
		break;
		case ORANGE_ATTACKS.SPIN_F:
			vAng = QAngle(vAng.z - 20, vAng.x+50, vAng.y+30)
			ThrowStrength = 99990
		break;
	}

	self.SetAbsAngles(vAng)

	for (local ent; ent = Entities.FindInSphere(ent, vOrigin, ThrowStrength);) {
		local entclass = ent.GetClassname()
		local vNewVelocity;

		if ((entclass == "func_physbox" || entclass == "func_physbox_multiplayer" || entclass == "prop_physics")) {
			if (entclass == "player") {
				vNewVelocity = ent.GetBaseVelocity()
			} else {
				vNewVelocity = ent.GetPhysVelocity()
			}
			vNewVelocity.y = cos(time * 1) * 2000
			local vEntOrigin = ent.GetOrigin();
			local vLocalOrigin = vOrigin - vEntOrigin;
			vNewVelocity += (vAng.Forward()*sin(time)*500)
			if (ent.GetName() == "minecart") {


				ent.SetPhysVelocity(ent.GetPhysVelocity() + (vNewVelocity * 0.01))
			}
			else {
				ent.SetPhysVelocity(ent.GetPhysVelocity() + vNewVelocity)
			}

		}

	}
	return 0.05
}

function Triggered() {
	self.ConnectOutput("OnTakeDamage","OnTakeDamage")

	local humanz = 0
	for (local ply; ply = Entities.FindByClassname(ply, "player");) {
		if (ply.GetTeam() == TEAMS.HUMANS) {
			humanz++
		}
	}
	self.SetHealth(iHealthBase + (humanz * iHealthAdd))
	AddThinkToEnt(self, "MainThink")
	local bonnies = 0
	// while (bonnies < 20) {
	// 	MakeBonnieCube(vStartOrigin + Vector(0,0,-500))
	// 	bonnies++
	// }
}

function BonnieDeath() {
	iBonnies--
}
function BonnieThink() {
	if (self == null || !self.IsValid()) {
		return
	}


	local vOrigin = self.GetOrigin()

	// self.ApplyAbsVelocityImpulse(Vector(RandomInt(-1024,1024),RandomInt(-1024,1024),RandomInt(-1024,1024)))

	for (local ent; ent = Entities.FindInSphere(ent, vOrigin, 128);) {
		if (ValidEntity(ent) && ent.GetTeam() == TEAMS.HUMANS) {
			MapSys.Jumpscare(ent);
			ent.TakeDamage(2, Constants.FDmgType.DMG_ACID, null);

		}

	}
	return 0.5
}

function OnTakeDamage() {
	self.AcceptInput("color","255 0 0",null,null)
	QFire("orange", "color", "255 255 255", 0.1)
	self.SetHealth(self.GetHealth() - 1)
}

