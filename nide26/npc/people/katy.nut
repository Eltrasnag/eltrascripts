IncludeScript(GUY_SCRIPT_BASE, this)

str_Name <- "Katy Perry"

::i_MaxChickens <- 32
::i_MinChickens <- 16
::i_InitialChickens <- RandomInt(i_MinChickens, i_MaxChickens)

::ChickenCount <- i_InitialChickens

h_ChickenCounter <- Entities.FindByName(null, "chicken_counter")

KatyTalk <- {
	"greet": @"katy perry: Hi guys. I had to go fwork on the farm because my last album (flop) 173 didnt do to owell....
	katy perry: butu mmm.... something went WRONG!!!!!!!!!!!!!
	katy perry: and ALL. MY. CHICKENS. ESCAPED!!!!!!!!!!!!!!!!!!!!!!!!
	katy perry: like .......    SHIT !!!!!!!!!!!!!!!!!!!!!!!!!!!!
	katy perry: can you guys go putmy cheickens back into the chicken pens.
	katy perry: if you do that i will OPEN THE DOOR and let you go to the highway., Okay?
	katy perry: Thanks gouys"
}

chicken_range <- [1024, 896]

function SpawnAction() {
	dprintl("Hello. Katy OPerty!")
}

v_ChickenOrigin <- Entities.FindByName(null, "chicken_origin").GetOrigin()
i_KatySegment <- 0

function StartFarm() {
	i_KatySegment = 1
	STORY.DoDialogueScene(KatyTalk.greet)
	local chicken_trigger;

	QFire("mus_funnysong", "PlaySound")

	while (chicken_trigger = Entities.FindByName(chicken_trigger, "trigger_chicken_zone")) {
		EntityOutputs.AddOutput(chicken_trigger, "OnStartTouch", "katy", "RunScriptCode", "TestChicken(activator)", 0, -1)
	}


	for (local i = 0; i < i_InitialChickens; i++) {
		local chicken = Spawn("prop_dynamic", {
			model = "models/eltra/nide26/guy.mdl",
			vscripts = "eltrasnag/nide26/npc/npc_chicken.nut",
			origin = Vector(RandomInt(-chicken_range[0], chicken_range[0]), RandomInt(-chicken_range[0], chicken_range[0]), 0) + v_ChickenOrigin

		})
	}
	AddThinkToEnt(self, "KatyThink")

	RunScriptCode(self, "i_KatySegment = 2", 10)
}

function OnPlayerUse(activator) {
	switch (i_KatySegment) {
		case 0:
			StartFarm()
			// SpeakLine("Hi gorgeous shouldnt you be colecting my chickens !!!!!")
		break;

		case 1:
		break;

		case 2:

			SpeakLine("Hi gorgeous shouldnt you be colecting my chickens !!??????!!!")
		break;
	}
}

function TestChicken(activator) {
	if (activator.GetName() == "chicken" ) {
		dprintl("This is chicken yes")
	}
}

function KatyThink() {
	if (ValidEntity(h_ChickenCounter)) {
		local cnumstr = (i_InitialChickens - ChickenCount).tostring()
		h_ChickenCounter.KeyValueFromString("message", cnumstr)
		CleanString(cnumstr)
	}
	return 0.5
}