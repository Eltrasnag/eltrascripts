TRIGGER_POS <- null

ENTITY1 <- null;
ENTITY2 <- null;

__CollectGameEventCallbacks(this)
RegisterScriptGameEventListener("player_say")

// buttons
const IN_ATTACK	= 1
const IN_USE	= 32
const IN_ATTACK2	= 2048

printl("TEST")

aOutputs <- [];


iOutputDelay <- 0
function DoPicker() {}

iDelay <- 0

iProgress <- 0;
vTriggerBoundLower <- null;
vTriggerOrigin <- null;
vTriggerBoundUpper <- null;
hTriggerEntity <- null;


strPreThink <- NetProps.GetPropString(self, "m_iszScriptThinkFunction")

function TriggerBBoxThink() {
	local TraceTable1 = {
		enthit = null,
		endpos = null,
		start = self.EyePosition(),
		end = self.EyePosition() + self.EyeAngles().Forward() * 99999,
		ignore = self,
		mask = 16449,
	}
	local strOutputs = ""


	TraceLineEx(TraceTable1)

	switch (iProgress) {
		case 0:
			ClientPrint(self, 4, "Select Origin")
			break;
		case 1:
			ClientPrint(self, 4, "Select Lower Corner")
			break;
		case 2:
			ClientPrint(self, 4, "Select Upper Corner")
			DebugDrawBox(vTriggerOrigin, vTriggerBoundLower, TraceTable1.endpos - vTriggerOrigin, 0, 255, 0, 30, 0.1)
			break;
		case 3:
			DebugDrawBox(vTriggerOrigin, vTriggerBoundLower, vTriggerBoundUpper, 0, 255, 0, 20, 0.1)
			ClientPrint(self, 4, "Select Target Entity")
			if (TraceTable1.enthit && TraceTable1.enthit.GetClassname() != "worldspawn") {
				TraceTable1.enthit.GetOrigin()
				DebugDrawLine(vTriggerOrigin, TraceTable1.enthit.GetOrigin(), 255, 0, 0, true, 0.1)
				// printl("enthit")

			}
			break;
	}

	if (vTriggerBoundUpper) {
		DebugDrawBox(vTriggerOrigin, vTriggerBoundLower, vTriggerBoundUpper, 0, 255, 0, 20, 0.1)
	}
	if (hTriggerEntity) {
		DebugDrawBox(vTriggerOrigin, vTriggerBoundLower, vTriggerBoundUpper, 0, 255, 0, 20, 0.1)
	}

	if (ButtonPressed(self, IN_USE) && iDelay >= 50) {
		iDelay = 0
		switch (iProgress) {
			case 0:
				vTriggerOrigin = TraceTable1.endpos
				iProgress++
				break;

			case 1:
				iProgress++
				vTriggerBoundLower = TraceTable1.endpos - vTriggerOrigin
				break;

			case 2:
				vTriggerBoundUpper = TraceTable1.endpos - vTriggerOrigin
				iProgress++
				break;

			case 3:
				printl("part 4 select")
				if (TraceTable1.enthit) {
					hTriggerEntity = TraceTable1.enthit

					GenerateSpawnString()
					AddThinkToEnt(self,"")
					return
				}
				break;

			default:
				break;
			}

	ClientPrint(self,3, "Position selected: "+TraceTable1.endpos.tostring())



	}


	// if (iOutputDelay >= 250) {
		// for (local i = 0; i < 10; i++) {
			// ClientPrint(null, 3, " ")
		// }
		// ClientPrint(null, 3, "\n\n\n\n\n\n\n\n\n\n|| ENTITY OUTPUTS ||\n")

	// 	foreach (OutputArray in aOutputs) {
	// 		local str = ""
	// 		foreach (thing in OutputArray) {
	// 			if (thing) {

	// 				str += (thing.tostring() + ", ")
	// 			}
	// 		}
	// 		ClientPrint(null, 3, str)
	// 	}
	// 	iOutputDelay = 0
	// }

	// iOutputDelay++
	iDelay++
	return -1
}

AddThinkToEnt(self, "TriggerBBoxThink")

function GenerateSpawnString() {
	local szSpawnString = ""

	// if (vTriggerBoundLower.Length() < vTriggerBoundUpper.Length()) {
	// 	vTriggerBoundLower = vTriggerBoundUpper
	// 	vTriggerBoundUpper = mediator
	// }

	local strTriggerName = "triggeronce_"+UniqueString()

	if (hTriggerEntity) {
		strTriggerName+= hTriggerEntity.GetName()
	}

	// uuughghhhhhh
	local mediator = vTriggerBoundLower

	if (vTriggerBoundLower.x > vTriggerBoundUpper.x) {
		vTriggerBoundLower.x *= -1
		vTriggerBoundUpper.x *= -1
	}
	if (vTriggerBoundLower.z > vTriggerBoundUpper.z) {
		vTriggerBoundLower.z *= -1
		vTriggerBoundUpper.z *= -1
	}
	if (vTriggerBoundLower.y > vTriggerBoundUpper.z) {
		vTriggerBoundLower.y *= -1
		vTriggerBoundUpper.y *= -1
	}

	// vTriggerBoundLower += vTriggerOrigin
	// vTriggerBoundUpper += vTriggerOrigin




	local Trigger = "\n\n\n\n	//AUTO-GENERATED VIA TRIGGERGEN//\n	//CREATING TRIGGER//\n	local " + strTriggerName + " = SpawnEntityFromTable(\"trigger_once\", {\n		spawnflags = 1,\n		origin = Vector(" + vTriggerOrigin.x + ", " + vTriggerOrigin.y + ", " + vTriggerOrigin.z + " ),\n	});	\n	" + strTriggerName + ".SetSolid(2);	\n	" + strTriggerName + ".SetSize(Vector(" + vTriggerBoundLower.x + ", " + vTriggerBoundLower.y + ", " + vTriggerBoundLower.z + " ), " + "Vector(" + vTriggerBoundUpper.x + ", " + vTriggerBoundUpper.y + ", " + vTriggerBoundUpper.z + " )" + ");"

	Trigger += "\n	//ENTITY OUTPUTS//"
	if (ValidEntity(hTriggerEntity) && hTriggerEntity.GetClassname() != "worldspawn") {
		Trigger += "\n	EntityOutputs.AddOutput(" + strTriggerName + ",\"OnTrigger\", \"" + hTriggerEntity.GetName() + "\", \"input\", \"parameter\", 0.0, -1);\n"
	}
	else {
		Trigger += "\n	EntityOutputs.AddOutput(" + strTriggerName + ",\"OnTrigger\", \"entity\", \"input\", \"parameter\", 0.0, -1);\n"
	}


	Trigger += "\n\n\n\n"
	ClientPrint(null,4,"Finished, check console for script-pastable string")
	printl(Trigger)

}

// function OnGameEvent_player_say(params) {

// 	local remove_user = regexp(" :  ")
// 	local strMessage = remove_user.capture(params.text)

// 	foreach (i,x in strMessage) {
// 		printl(x)
// 	}

// 	if (startswith(strMessage, "!addoutput")) {
// 		local strClean = split(strMessage, "!addoutput")[0] // remove addoutput
// 		printl("sm : "+strClean)


// 		local Outputs = split(strClean, "|", false)



// 		for (local i = 0; i < 6; i++) {
// 			if (i < Outputs.len() && i in Outputs) {
// 				printl("specified: "+Outputs[i].tostring())
// 				// aOutput[i] = Outputs[i];
// 				return;
// 			}
// 			printl("unspecified")
// 			switch (i) {
// 				case 3: // parameter
// 					Outputs.append("")
// 				break;
// 				case 4:
// 					Outputs.append(0)
// 					break;

// 				case 5:
// 					Outputs.append(-1)
// 					break;

// 				default:
// 					break;
// 			}
// 		}

// 		aOutputs.append(Outputs)
// 	}




// }

// function MakeOutput(strText) {


// }