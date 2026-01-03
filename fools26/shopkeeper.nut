
NPC_NAMETAG <- Spawn("point_worldtext", {
	origin = self.GetOrigin(),
	color = "255 183 241",
	orientation = 2,
	message = "-Grandma-",
	parent = self,
	font = 3,
})

NANABANK <- {}

function OnPostSpawn() {
	SetParentEX(NPC_NAMETAG, self)
	MapSayDelay("In need of a Physics gun? Come to my shop and get as many as you can carry (1)!", "Grandma", 2)
	NPC_NAMETAG.SetLocalOrigin(Vector(0,0, 45))
}