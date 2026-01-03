# recreation of team_round_timer functionality for burgercss

timer_length <- 300 // seconds after """setup""" ends
::setup_length <- 15
::timer_progress <- 0

function OnPostSpawn() {
	timer_progress = 0
	// imitate set-up period
	AddThinkToEnt(self, "TimeSyncThink")
}

SyncTime <- floor(Time() + 1)

function Think() {
	switch (timer_progress) {
		case setup_length: // tf2: setup ends, round begins. fires OnSetupFinished output
			OnSetupFinished()
			break;
		case timer_length: // tf2: timer ends, fires OnFinished output
			OnFinished()
			break;
		default:
			break;
	}
	timer_progress++
	return 1
}

function TimeSyncThink() {
	if (Time() >= SyncTime) {
		AddThinkToEnt(self, "Think")
		QFire("my_fat_penis_child*", "Kill")

		printl("Game time has been synced. Commencing...")
	}
}


function OnSetupFinished() {
	if (PreGame == false) {
		QFire("door_button_*", "RunScriptCode", "UnlockButton()")
		QFireByHandle(self, "FireUser2")
		RoundStarted = true
		// QFireByHandle(self, "FireUser2", "", 0.0, null, null)

		// mimic of setup finish
	}
}

function OnFinished() {
	QFireByHandle(self, "FireUser1")

	// mimic of round ending

}

::IsInWaitingForPlayers <- function() {
	if (timer_progress <= setup_length) {
		return true
	}
	return false
}