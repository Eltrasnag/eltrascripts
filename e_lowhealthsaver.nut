
function lhs_Set(activator, enabled, dest_name, thresh_health) {
	try {

		activator.ValidateScriptScope()
		local ascope = activator.GetScriptScope()

		if (enabled) {
			local dest = Entities.FindByName(null, dest_name)
			ascope.lhs_min_health <- thresh_health
			ascope.lhs_dest_origin <- dest.GetOrigin()
			ascope.lhs_dest_angles <- dest.GetAbsAngles()
			ascope.lhs_Think <- lhs_Think

			AddThinkToEnt(activator, "lhs_Think")
		} else {
			AddThinkToEnt(activator, "")
		}



	} catch (exception){
		printl("something went wrong :(")
		printl(exception+"\n\n\n\n\n")
	}
}


function lhs_Think() {
	try { // I DIDNT TEST THIS LOL
		if (self.GetHealth() <= lhs_min_health) {
			self.SetAbsOrigin(lhs_dest_origin)
			self.SetAbsAngles(lhs_dest_angles)
		}
	} catch (exception){
		printl("something went wrong in lhs_Think :(")
		printl(exception+"\n\n\n\n\n")
	}
	return 0.1
}