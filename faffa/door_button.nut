enum DOORS {LEFT, RIGHT}
enum BUTTON_STATES {PRESSED,RELEASED,LOCKED}

const BUTTON_COLOR_OPEN = "255 0 0"
const BUTTON_COLOR_CLOSED = "0 255 12"
const BUTTON_COLOR_LOCKED = "133 176 255"
iButtonCooldown <- 0
bCooldown <- false
const DOOR_BUTTON_COOLDOWN_TIME = 5
iButtonType <- DOORS.LEFT
iButtonState <- BUTTON_STATES.LOCKED
hButtonPresser <- null

function OnPostSpawn() {
	local targetname = self.GetName()
	QFireByHandle(self, "color", BUTTON_COLOR_LOCKED)
	if (targetname == "door_button_left") {
		printl("LEFT door button registered!")
		iButtonType = DOORS.LEFT
	}

	if (targetname == "door_button_right") {
		printl("RIGHT door button registered!")
		iButtonType = DOORS.RIGHT
	}
}

function UnlockButton() {
	QFireByHandle(self, "color", BUTTON_COLOR_OPEN)

	iButtonState = BUTTON_STATES.RELEASED
}


function PressButton(player = null) {
	if (bCooldown) { return }

	local pscope = player.GetScriptScope()
	pscope.hButton = self
	if (player != null && (RightOccupied || LeftOccupied)) {
		pscope.iScore += 10
	}

	QFireByHandle(self, "PressIn")
	iButtonState = BUTTON_STATES.PRESSED
	switch (iButtonType) {
		case DOORS.LEFT:
			PressedLeft++
			break;
		case DOORS.RIGHT:
			PressedRight++
			break;
		default:
			break;
	}
		QFireByHandle(self, "color", BUTTON_COLOR_CLOSED)

}

function ReleaseButton(player = null) {
	bCooldown = true
	if (player != null && player.IsValid()) {
		player.ValidateScriptScope()
		// pscope = player.GetScriptScope()
		if ((LeftOccupied || RightOccupied)) {
			player.GetScriptScope().iScore -= 10
			player.GetScriptScope().hButton = null
		}

	}
	QFireByHandle(self, "PressOut")
	iButtonState = BUTTON_STATES.RELEASED
	switch (iButtonType) {
		case DOORS.LEFT:
			PressedLeft -= 1
			break;
		case DOORS.RIGHT:
			PressedRight -= 1
			break;
		default:
			break;
	}
	QFireByHandle(self, "color", BUTTON_COLOR_OPEN)


}

function Think() {
	iButtonCooldown++
	if (iButtonCooldown >= DOOR_BUTTON_COOLDOWN_TIME) {
		bCooldown = false
	}
	return 0.5
}