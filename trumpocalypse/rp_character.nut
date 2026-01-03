Name <- "NO_NAME"

Health <- 10;

Job <- 0;

woman_models <- ["models/humans/group03/female_01.mdl","models/humans/group03/female_01_bloody.mdl","models/humans/group03/female_02.mdl","models/humans/group03/female_02_bloody.mdl","models/humans/group03/female_03.mdl","models/humans/group03/female_03_bloody.mdl","models/humans/group03/female_04.mdl","models/humans/group03/female_04_bloody.mdl","models/humans/group03/female_06.mdl","models/humans/group03/female_06_bloody.mdl","models/humans/group03/female_07.mdl","models/humans/group03/female_07_bloody.mdl","models/alyx.mdl","models/mossman.mdl"]
male_models <- ["models/humans/group03/male_01.mdl","models/humans/group03/male_01_bloody.mdl","models/humans/group03/male_02.mdl","models/humans/group03/male_02_bloody.mdl","models/humans/group03/male_03.mdl","models/humans/group03/male_03_bloody.mdl","models/humans/group03/male_04.mdl","models/humans/group03/male_04_bloody.mdl","models/humans/group03/male_05.mdl","models/humans/group03/male_05_bloody.mdl","models/humans/group03/male_06.mdl","models/humans/group03/male_06_bloody.mdl","models/humans/group03/male_07.mdl","models/humans/group03/male_07_bloody.mdl","models/humans/group03/male_08.mdl","models/humans/group03/male_08_bloody.mdl","models/humans/group03/male_09.mdl","models/humans/group03/male_09_bloody.mdl","models/breen.mdl","models/kleiner.mdl","models/eli.mdl"]



Gender <- RandomInt(0, 1)
GenderString <- ["male","female"]

Weapon <- null;
Weapon_Scope <- null;

Attack_Target <- null;

Is_Attacking <- false;

Idle_Time <- 0 // the time spent at one position or doing one action before npc gets "bored" and does something else
Desired_Position <- self.GetOrigin();
Current_Action <- 0 // current action npc is doing

Attack_End_Time <- 0
Think_Unlock_Time <- 0

enum Actions {
	idle = 0,
	wandering = 1,
	attacking = 2,
}


const Wander_Distance = 1024
const Use_Bits = 32
const Text_Offset = 80
const woman_models_max = 7
const man_models_max = 9

// player_scope <- null;

Name_List_Male <- ["Brandy","Bobby","Mike","David","Ted","Chud","Devon","Reiaylxeiaugh", "Charles", "Jimmiy Bibbibly Bop Ba"]
Name_List_Female <- ["Krystal","Dakota","Laura Palmer","Joanne","Moga","Melody","Reiaylxeiaugh","Samantha","Kelsey","Reba","Becky","Tammy","Jemma"]

Name_Text <- SpawnEntityFromTable("point_worldtext", {
	origin = self.GetOrigin() + Vector(0, 0, Text_Offset),
	color = RandomInt(15, 255)+" "+RandomInt(15, 255)+" "+RandomInt(15, 255)+" 255",
	message = Name,
	orientation = 2,
	font = 5,
})

enum Genders {
	male = 0,
	female = 1,
}

enum Jobs {
	citizen = 0,
	shopkeeper = 1,
	criminal = 2,
}

enum JobStates {
	incomplete = 0,
	complete = 1,
}

Busy <- false;





GetDistance <- function(vec2, vec1)
{

	local result = sqrt(pow(vec2.x - vec1.x, 2) + pow(vec2.y - vec1.y, 2));

	return result
}


function OnPostSpawn() {

	local is_named =  (self.GetName().len() > 1)
	if (!is_named) {
		Job = Jobs.citizen
		local mdlgen = RandomInt(0, 1)

		if (mdlgen == 0)
		{

			local model_path = male_models[RandomInt(0, male_models.len() - 1)]
			PrecacheModel(model_path)
			self.SetModel(model_path)
		}
		else
		{

			local model_path = woman_models[RandomInt(0, woman_models.len() - 1)]
			PrecacheModel(model_path)
			self.SetModel(model_path)
		}
	}

	// examine spawn conditions and determine role/gender
	local model_name = self.GetModelName()

	local searched = regexp("female").search(model_name)

	if (searched != null) {
		// printl("woman model detected")
		Gender = Genders.female
	}
	else {
		// printl("man model detected")
		Gender = Genders.male
	}

	if (!is_named) {
		switch (Gender) {
			case Genders.male:
				Name = Name_List_Male[RandomInt(0, Name_List_Male.len() - 1)]
				break;
			case Genders.female:
				Name = Name_List_Female[RandomInt(0, Name_List_Female.len() - 1)]
				break;
			default:
				break;
		}
	}
	else {
		local targetname = self.GetName()
		local targetname_length = targetname.len()

		local stage_regex = regexp("(s._)").search(targetname)


		if (stage_regex != null)

			targetname = targetname.slice(stage_regex.end, targetname.len())


		local true_name = targetname.slice(0, 1).toupper()+ targetname.slice(1, targetname.len())
		Name = true_name //takes its' targetname
	}



	self.AcceptInput("SetDefaultAnimation","idle_subtle",null,null)
	self.AcceptInput("SetAnimation","idle_subtle",null,null)


	EntityOutputs.AddOutput(self, "OnHealthChanged", "!self", "RunScriptCode", "TakeNPCDamage(activator)", 0.0, -1)
	Name_Text.KeyValueFromString("message", Name);
	AddThinkToEnt(self, "Think")
}




function Think() {


	if (Think_Unlock_Time <= Time()) // ez way to wait for things
	{
		// variables which we will be reusing throughout the function
		local self_pos = self.GetOrigin()
		local eye_pos = self.EyePosition()

		// local Attack_Victim = Entities.FindByNameNearest("player", self_pos, 100)

		// if (Is_Attacking) {


		// }

		// if (Attack_Victim && (!Attacking) && (Job == 0)) {

		// 	StartAttack(Attack_Victim)
		// }

		// update nameplate pos
		Name_Text.KeyValueFromVector("origin", (self_pos + Vector(0, 0, Text_Offset)))


		// do boredom actions
		switch (Current_Action) {
			case Actions.idle:



				// QFireByHandle(self, "RunScriptCode", "Busy = false", RandomFloat(8, 18), null, null)
				break;

			case Actions.wandering:

				self.AcceptInput("SetAnimation","run_all",null,null)
				self.AcceptInput("SetDefaultAnimation","run_all",null,null)
				local new_vec = self_pos + (self.GetAbsAngles().Forward() * 15)
				local new_angles = QAngle(0,atan2(new_vec.z - self_pos.z, new_vec.x - self_pos.x) * (180/PI),0)



				local obstruction_trace = {
					start = self_pos,
					end = new_vec + (self.EyeAngles().Forward() * 100),
					ignore = self,
				}

				TraceLineEx(obstruction_trace)


				// DebugDrawLine(self_pos,new_vec,255,0,255,false,0.05)
				// DebugDrawLine(obstruction_trace.startpos,obstruction_trace.endpos,0,0,255,false,0.05)

				// DebugDrawText(new_vec, Name.tolower()+" want go here", false, 0.1)






				if (((obstruction_trace.hit) && (obstruction_trace.enthit)) && ((obstruction_trace.enthit.GetClassname() == "player") || (obstruction_trace.enthit.GetClassname() == "prop_dynamic") )) {
					local player = obstruction_trace.enthit

					if (!Is_Attacking)
					{

						StartAttack(player)
						break;

						// return 1.0
						// QFireByHandle(self, "RunScriptCode", "AddThinkToEnt(Weapon, `GunThink`)", 1, null, null);


					}
					else
					{

					}


					// return 1.0
				}
				else {
					// if (Is_Attacking)
						// StopAttacking()

				}

				if (obstruction_trace.hit) { // there goes the neighbourhood
					// printl("ÈI AM  STUCKHELP")
					new_angles.y = RandomInt(-360, 360)
					self.AcceptInput("SetAnimation","idle_subtle",null, null)
					Current_Action = Actions.idle
					Busy = false

				}

				self.KeyValueFromString("angles", ((new_angles)).ToKVString())
				self.KeyValueFromVector("origin", (new_vec))


				break;

			case Actions.attacking:
				Busy = true
				if ((Attack_Target == null) || (Time() > Attack_End_Time)) {
					StopAttacking()
					// printl("I SHOULD STOP ATTACKING")
					break;
				}

				if ((Attack_Target != null) && (Attack_Target.IsValid())) {

					LookAtEntity(Attack_Target)
				}
				self.AcceptInput("SetAnimation","shootp1",null,null)

				Weapon_Scope.FireWeapon()
				// if (RandomInt(0, 5) == RandomInt(0, 5)) {


				// }

				// Wait(RandomFloat(0.3, 0.9))0

				break;
			default:
				break;
		}

		// get bored
		if (Job != Jobs.shopkeeper)

			if ((!Busy) && (!Is_Attacking)) {
				// printl(Name+" : Idle_Time is " + Idle_Time)
				if (Idle_Time >= 26) {
					local random = RandomInt(1, 14)
					local random_match = 14

					if (random == random_match)
					{
						printl("new action for "+Name)
						Busy = true
						Idle_Time = 0
						local actions_max = 1
						local random_action = RandomInt(0, actions_max)

						Current_Action = random_action
						switch (Current_Action) {
							case Actions.idle:
								self.AcceptInput("SetDefaultAnimation","idle_subtle",null,null)
								self.AcceptInput("SetAnimation","idle_subtle",null,null)
								break;
							case Actions.wandering:
								self.AcceptInput("SetAnimation","run_all",null,null)
								self.AcceptInput("SetDefaultAnimation","run_all",null,null)
								// RollNewDesiredPosition()`
								// Desired_Position = Vector(self_pos.x + RandomFloat(-Wander_Distance, Wander_Distance), 0, self_pos.z + RandomFloat(-Wander_Distance, Wander_Distance))
								break;
							default:
								break;
						}
					}

				}
				else {
				Idle_Time += 1

				}
			}













			// for (local node = null; node = Entities.FindByNameWithin(node, "npc_node", self_pos, 1024);)









		// check for players in radius, if found then check for use key, etc
		for (local i = null; i = Entities.FindByClassnameWithin(i, "player", self_pos, 256);) {
			local buttons = NetProps.GetPropInt(i, "m_nButtons")
			if (buttons & Use_Bits) {
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
					if (!Busy)
					{
						LookAtEntity(player)
						player.ValidateScriptScope()
						local player_scope = player.GetScriptScope()

						player_scope.employer_scope <- self.GetScriptScope()
						player_scope.job_status <- JobStates.incomplete




						printl("do shopkeeper function here")
					}
					else {
						printl("NPC is busy right now!")
					}


				}


			}
		}


		// snap npc to floor
		local ft_origin = self.GetOrigin()
		local floor_trace = {
			start = ft_origin,
			end = ft_origin + Vector(0,0,-100.0),
			ignore = self,
		}
		TraceLineEx(floor_trace)


		self.KeyValueFromVector("origin", (floor_trace.endpos))
		// printl("Think")
		// self.StudioFrameAdvance()

	}
	return 0.1
}

function AnglesToPosition(from,to) {
	local new_angles = QAngle(0,atan2(from.y - to.y, from.x - to.x) * (180/PI),0)
	return new_angles
}

function GunThink() {
	FireWeapon()
	return RandomFloat(0.1, 0.7)
}

function TakeNPCDamage(caller) {

	if ((self != null && self.IsValid()))
	{

		local soundpath = "vo/npc/"+GenderString[Gender]+"01/pain0"+RandomInt(1, 9)+".wav"
		PrecacheSound(soundpath)
		EmitSoundEx({
			sound_name = soundpath,
			speaker_entity = self,
			entity = self,
			channel = 2,
			sound_level = 0.5,
			pitch = RandomFloat(98, 102),

		})

		local soundpath_b = "physics/wood/wood_box_impact_bullet1.wav"

		PrecacheSound(soundpath_b)
		EmitSoundEx({
			sound_name = soundpath_b,
			origin = self.GetOrigin(),
			sound_level = 0.5,
			pitch = RandomFloat(94, 107),

		})
		// feedback
		self.AcceptInput("color","255 0 0",null,null)
		self.AcceptInput("SetModelScale","0.98",null,null)

		QFireByHandle(self, "SetModelScale", "1", 0.02, null, null)
		QFireByHandle(self, "color", "255 255 255", 0.02, null, null)

		if (Job != Jobs.shopkeeper){
			if (Health > 0)
				{
					printl(Health)

					Health -= 1
				}
			if (Health == 0) {

				local pos = self.GetOrigin()
				for (local i = 0; i < RandomInt(1, 3); i++){

					MakePeso(pos + Vector(RandomInt(-32, 32), RandomInt(-32, 32), pos.z))
				}

				Health = -1

				local new_body = SpawnEntityFromTable("prop_ragdoll", {
					origin = self.GetOrigin(),
					angles = self.GetAngles(),
					model = self.GetModelName(),
					spawnflags = 32772,
				})

				if ((caller != null && self != null) && (caller.IsValid() && self.IsValid()))
					new_body.ApplyAbsVelocityImpulse((AnglesToPosition(caller.GetOrigin(), pos).Forward()) * -100)


				if (Weapon != null) {
					Weapon.AcceptInput("SetParent","!activator",new_body,null)
					QFireByHandle(Weapon, "SetParentAttachment", "anim_attachment_RH", 0.1, null, null);
					QFireByHandle(Weapon, "Kill", "", 5, null, null)
				}
				if (Name_Text != null && Name_Text.IsValid()) {
					Name_Text.AcceptInput("Kill","",null,null)

				}
				AddThinkToEnt(self, "")
				// self.BecomeRagdollOnClient(Vector)
				// QFireByHandle(self, "BecomeRagdoll", "", 0.1, null, null)
				QFireByHandle(new_body, "Kill", "", 5, null, null);
				QFireByHandle(self, "Kill", "", 0.1, null, null);
				// QFireByHandle(self, "Kill", "", 0.0, null, null)
			}

		}
		if (!Is_Attacking) {
			StartAttack(caller)
		}
	}

}

// gun shoot logic
function FireWeapon() {
	local gun_pos = self.GetOrigin()
	local gun_angles = self.GetAbsAngles()

	local max_randomness = 2048

	local shoot_vec = gun_pos + (gun_angles.Forward() * 10000) + Vector(RandomFloat(-max_randomness, max_randomness),RandomFloat(-max_randomness, max_randomness),RandomFloat(-max_randomness, max_randomness))
	local gunfire_trace = {
		start =	gun_pos,
		end = shoot_vec,
		ignore = self,
	}

	TraceLineEx(gunfire_trace)

	DebugDrawLine(gunfire_trace.startpos, gunfire_trace.endpos, 255, 0, 0, false, 0.25)

	if (gunfire_trace.hit && gunfire_trace.enthit) {

		local victim = gunfire_trace.enthit
		local victim_classname = gunfire_trace.enthit.GetClassname()


		switch (victim_classname) { // what to do depending on what we hit
			case "player":
				victim.ValidateScriptScope()
				victim.TakeDamage(RandomFloat(5, 7), 2, self)

				break;
			case "prop_dynamic":

				if (victim != Owner && victim.ValidateScriptScope() && (victim.GetScriptScope().Job != null))
					{
						QFireByHandle(victim, "RunScriptCode", "TakeNPCDamage(activator)", 0.0, self, null);
					}

				break;
			default:
				break;
		}

	}




	PrecacheScriptSound("Weapon_M249.Single")

	EmitSoundOn("Weapon_M249.Single", self)

	local Angle_To = QAngle(0,atan2(gun_pos.y - shoot_vec.y, gun_pos.x - shoot_vec.x) * (180/PI),0)

	local shooter_name = "npc_shooter_"+rand()

	local shooter_target = SpawnEntityFromTable("info_teleport_destination", {
		origin = shoot_vec,
		targetname = shooter_name
	})

	local shooter = SpawnEntityFromTable("env_gunfire", {
		origin = gun_pos + (gun_angles.Forward() * 10),
		collisions = 1,
		angles = gun_angles
		target = shooter_name,
	})



	shooter.AcceptInput("Enable","",null,null);
	QFireByHandle(shooter, "Kill", "", 0.1, null, null);
	QFireByHandle(shooter_target, "Kill", "", 0.1, null, null);

}

function Wait(wait_time = 0) {
	Think_Unlock_Time = Time() + wait_time
}

function GetDistanceTo(from,to) {
	return sqrt(pow(to.x - from.x, 2) + pow(to.z - from.z, 2))
}

function RollNewDesiredPosition() {
	local origin = self.GetOrigin()
	Desired_Position = Vector(origin.x + RandomFloat(-1000, 1000), origin.y, origin.z + RandomFloat(-1000, 1000))
}

function LookAtEntity(entity_to_look_at = null) {

	local new_angles = QAngle(0,0,0)

	if ((entity_to_look_at))
		new_angles = AnglesToPosition(entity_to_look_at.GetOrigin(),self.GetOrigin())


	self.KeyValueFromString("angles", (new_angles).ToKVString())
}

function StartAttack(victim_entity) {
	local soundpath = "vo/npc/"+GenderString[Gender]+"01/cps0"+RandomInt(1, 2)+".wav"
	PrecacheSound(soundpath)
	self.QEmitSound(soundpath)

	self.AcceptInput("SetDefaultAnimation","reload_pistol",null,null);

	Weapon <- SpawnEntityFromTable("prop_physics", {
		origin = Vector(0,0,0),
		spawnflags = 12,
		model = "models/weapons/w_pist_deagle.mdl"
	})

	Attack_Target = victim_entity
	Weapon.AcceptInput("SetParent","!activator",self,null);
	QFireByHandle(Weapon, "SetParentAttachment", "anim_attachment_RH", 0.1, null, null);

	Weapon.ValidateScriptScope()
	Weapon_Scope <- Weapon.GetScriptScope()
	Weapon_Scope = Weapon.GetScriptScope() //i  swear to god


	// Weapon_Scope.AnglesToPosition <-
	Weapon_Scope.FireWeapon <- FireWeapon
	Weapon_Scope.Owner <- self

	Is_Attacking = true
	printl("I AM GOING TO KILL YOU")
	Current_Action = Actions.attacking
	Attack_End_Time = Time() + RandomFloat(3, 6)
	// Wait(1)
}

function StopAttacking() {
	Current_Action = Actions.idle
	Attack_Target = null
	Is_Attacking = false
	Weapon.Kill()
	Weapon = null
	Weapon_Scope = null
	self.AcceptInput("SetAnimation","idle_subtle",null,null)
	self.AcceptInput("SetDefaultAnimation","idle_subtle",null,null)
	Busy = false
	// Wait(1.0)
}