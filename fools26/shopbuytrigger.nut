SHOP_ITEMNAME <- "ITEM_NONAME"
SHOP_ITEMTEMPLATENAME <- "tem_none"
SHOP_ITEMTEMPLATE <- null;
SHOP_ITEMPRICE <- 0

players <- {}
poorheads <- {}

function OnPostSpawn() {
	local Context = GetContext(self)

	SHOP_ITEMNAME <- self.GetName().toupper()
	SHOP_ITEMTEMPLATENAME <- NetProps.GetPropString(self, "m_target")
	SHOP_ITEMTEMPLATE <- Entities.FindByName(null, SHOP_ITEMTEMPLATENAME)
	if ("price" in Context) {
		SHOP_ITEMPRICE <- Context.price
	}

	self.ConnectOutput("OnStartTouch", "Enter")
	self.ConnectOutput("OnEndTouch", "Exit")

	AddThinkToEnt(self, "Think")
}

function Enter() {
	players[activator] <- activator
}

function Think() {

	foreach (i, ply in players) {
		ClientPrint(ply, Constants.EHudNotify.HUD_PRINTCENTER, ">> Press [RIGHT CLICK] to buy item - "+SHOP_ITEMNAME+" for "+SHOP_ITEMPRICE+"$ <<")

		if (ButtonPressed(ply, IN_ATTACK2)) {

			local context = GetContext(ply)
			local cash

			if (!("money" in context))
				// SetContext(ply, "money", 0)
				context.money <- 0
				// context = ply.GetContext()
				// __DumpScope(1, context)


			cash = context.money
			if (cash < SHOP_ITEMPRICE) { // player can't afford item
				// ClientPrint(ply, EHudNotify, ">> You are too poor to afford this item. <<")
				DoDialogueOnClient(ply, "Uh oh, looks like you're too poor for that one! Come back when you're a little bit more.... Penniful.", "grandma")

				// poorheads[ply] <- ply // this might be unneccessasry actually
				delete players[ply]
				continue;
			}

			if (cash >= SHOP_ITEMPRICE) {
				// QAcceptInput(SHOP_ITEMTEMPLATE, "ForceSpawn")
				QFireByHandle(SHOP_ITEMTEMPLATE, "ForceSpawn")
				SetContext(ply, "money", cash - SHOP_ITEMPRICE)
				DoDialogueOnClient(ply, "We appreciate your purchase!", "grandma")
				PlaySoundEX("eltra/cash_register.mp3", ply.GetOrigin())
				if (ply in players) {
					delete players[ply]
				}
				continue;
			}
		}
	}
	return -1
}

function Exit() {
	if (activator in players) {
		delete players[activator]
	}
	if (activator in poorheads) {
		delete poorheads[activator]
	}
}