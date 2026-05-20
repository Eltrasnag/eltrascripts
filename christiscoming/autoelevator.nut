
NextArrowTime <- 0
ArrowCooldown <- 0.5

DirAngle <- QAngle()

UpText <- "/\\"
DownText <- "\\/down"

DirText <- UpText

ArrowOffsetUp <- Vector(0, 0, -256)
ArrowOffsetDown <- ArrowOffsetUp * -1
ArrowOffset <- ArrowOffsetUp

function Precache() {
	self.KeyValueFromInt("dmg", 9999999) // stop fuckasses from blocking elevators
}

function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
	self.ConnectOutput("OnFullyClosed","OnFullyClosed")
	self.ConnectOutput("OnFullyOpen","OnFullyOpen")
}

function Think() {

	if (NextArrowTime <= Time()) {
		NextArrowTime = Time() + ArrowCooldown
		local arrow = Spawn("point_worldtext", {
			vscripts = "eltrasnag/christiscoming/autoelevator_indicator.nut",
			angles = DirAngle,
			origin = self.GetOrigin() + ArrowOffset,
			textsize = 20,
			message = DirText,
			color = "199 255 219 0",
			font = 11,
			orientation = 2,
		})

		SetParentEX(arrow, self)
	}

	return
}


function OnFullyClosed() {
	DirAngle.z = 0
	// DirAngle.y = 90
	DirText = UpText
	ArrowOffset = ArrowOffsetUp
}

function OnFullyOpen() {
	DirAngle.z = -180
	DirText = DownText
	ArrowOffset = ArrowOffsetDown
	// DirAngle.y= -90
}