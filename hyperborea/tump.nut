
position <- 0;
last_position <- null;
next_position <- 0;
next_position_vector <- null;
// tump_offset <- 0;
const tump_offset = 100;
desired_position <- 0;
tump_map_positions <- [];
tump_map_position_prefix <- "s5_tump_pos"
next_pos_vector <- self.GetOrigin();
travelling <- false;
travelspeed <- 35;

enum poi { // update when stage is done
	twitter_door_open = 4,
	twitter_post_door_open = 5,
	twitter_portal_enter = 6,
}

function TumpTeleport(next_pos) {

	position = next_pos
	desired_position = next_pos
	self.SetAbsOrigin(tump_map_positions[next_pos][0])
	self.SetAbsAngles(tump_map_positions[next_pos][1])

}

function TumpAdvance() {
	desired_position += 1
	printl("tump going to position: "+desired_position)

	next_position_vector = tump_map_positions[position][0]
	travelling = true
}

function TumpGoTo(next_pos, speed = 40) {
	desired_position = next_pos
	PrecacheScriptSound("eltra/foxyrun.mp3")
	EmitSoundOn("eltra/foxyrun.mp3", self)
	self.AcceptInput("SetAnimation", "run2", null, null)
	self.AcceptInput("SetDefaultAnimation", "run2", null, null)
	printl("Tump desires to go to: "+next_pos)
	travelspeed = speed
	if (desired_position < position) {
		next_position = position - 1
	}
	if (desired_position > position) {
		next_position = position + 1
	}
	printl("Tump must first go to: "+next_position)
	travelling = true
}

// function SetTumpOrigin(vector) { // tump model is not correctly positioned to origin so this compensates for that
// 	// local tumpvec = Vector(0, 0, tump_offset)
// 	self.SetAbsOrigin(vector)
// }

function OnPostSpawn() {
	GetTumpPositions()
	self.SetAbsOrigin(tump_map_positions[0][0])
	AddThinkToEnt(self, "TumpThink")
}


function GetTumpPositions() { // STUPID FUCKIGN FUNCTION TO GET THE FUCKING TRUMP POSITION RELAYS AND STORE THJEM IN THE FUCKIJNG TABLE WHATEVER I DONT CARE I FUCKING HATE THIS FUNCTION FOR ITS STUPID FUCKING RETYARDED FUCKING FAGGOTTRY
	// local i_tumppos = null;
	local iteramt = 0
	local postable = {};
	local tumplen = tump_map_position_prefix.len()
	for (local i_tumppos; i_tumppos = Entities.FindByName(i_tumppos, tump_map_position_prefix + "*");)
	{

		local posID = i_tumppos.GetName()

		local pos_vector = i_tumppos.GetOrigin()
		local pos_angles = i_tumppos.GetAbsAngles()
		local info_table = [pos_vector, pos_angles]
		postable[posID] <- clone info_table;
		// printl("Added tump pos "+posID+" with info table "+info_table+" to the tump positions dict")
		iteramt += 1
		i_tumppos.Kill()
	}

	for (local slot = 0; slot < 8; slot += 1) {
		local little_gassed_jew = tump_map_position_prefix+slot;
		// printl("LITTLE GASSED JEWS! OOPS! HITLER'S COMING! "+little_gassed_jew)
		local shithole = postable[little_gassed_jew]

		tump_map_positions = tump_map_positions.append(clone shithole)
	}

	// MapSay("tumpty pos: "+postable["s5_tump_pos3"][0])
	// MapSay("CAN YOU FUCKING BE SERIOUS PLEASE")

}
moving <- false;

function TumpThink() {
	try {
		if (last_position != position) {
			TumpAction()
			// printl("fat slag")
		}
		last_position = position
		// printl(position)

		if (travelling == true) {

			next_pos_vector = tump_map_positions[next_position][0]

			if (GetDistance(next_pos_vector, self.GetOrigin()) > travelspeed) {
				local next_look = LookAtFromPos(next_pos_vector, self)
				next_look.y += 180
				self.SetAbsAngles(next_look)
				local nextpos = self.GetOrigin() - (GetMoveDelta(next_pos_vector, self.GetOrigin()) * travelspeed)

				self.KeyValueFromVector("origin", nextpos )
			}

			else {
				travelling = false

				position = next_position
				// printl("tump within range, travel stops")

				if (position == desired_position) {
					// MapSay("Padlomba")

				}
				else {
					if (desired_position < position) {
						next_position = position - 1
					}
					if (desired_position > position) {
						next_position = position + 1
					}
					travelling = true

				}


				}
		}

	} catch (exception){
		printl("EXCEPTION IN TUMPTHINK CODE: "+exception)
	}

	return 0.1
}

function TumpAction() {

	last_position = position
	switch (position)
	{
		case 0:
			printl("tump at SPAWN")
			QFire("s5_spawndoor", "Open", "", 0.0, null);
			break;
		case 2:
			QFire("s5_spawndoor", "Close", "", 0.0, null);

			break;
		case 8:
			TumpAnim("long_jump")
			break;
		case 10:
			printl("tump go home now :D")
			TumpTeleport(1)
			break;
		case 7:
			TumpTeleport(1)
			break;
		default:
			if (travelling) {
				TumpAnim("run2")
			}
			else {

				TumpAnim("deep_idle")
			}
			if (position == desired_position) {
				TumpAnim("deep_idle")
				self.SetAbsAngles(tump_map_positions[position][1])
			}
			break;
	}


}

function TumpAnim(anim) {
	self.AcceptInput("SetAnimation", anim, null, null);
	self.AcceptInput("SetDefaultAnimation", anim, null, null);
}