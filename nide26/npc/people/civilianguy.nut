self.ValidateScriptScope()
IncludeScript("eltrasnag/nide26/npc/people/base.nut", this)
IncludeScript("eltrasnag/nide26/misc/civilian_dialogues.nut", this)

b_TakeDamage <- true;

i_Sex <- RandomInt(0,1)
str_Name <- PickGuyName(i_Sex)

PUNCTUTATION_ARRAY <- [".", "!", "?", "...", ".", "l", "!!!!!!!"]
function CivilianThink() {
	// printl("Hello")

	if (RandomInt(0,10000) == 14) {

		Die()
		// iHealth = 0
	}

}

fl_NextWhineTime <- 0;
fl_WhineDelay <- 0.5
function SpawnAction() {
	ListenEvents({
		OnScriptHook_OnTakeDamage = function(params)  {
			if (params.const_entity == self && "inflictor" in params) {
				HurtRage(params.inflictor)
			}
		}
	})
	CIVILIANS_ALIVE++



	AddNPCThink(CivilianThink)
	self.SetSkin(RandomInt(0, GUY_SKIN_COUNT-1))
}


function Punctuation() {
	return PUNCTUTATION_ARRAY[RandomInt(0, PUNCTUTATION_ARRAY.len()-1)]

}




function GenerateSentence() {
	local wordcount = RandomInt(2, 6)

	local subject = RandomArray(CIVILIAN_DICTIONARY[(CDICT.SUBJECT)]);



	local sentence = ""

	for (local i = 0; i < wordcount; i++) {
		local seed = RandomInt(0,10)
		local random = RandomInt(0,10)
		local sentence_add = "";
		switch (true) {
			case (random == 0 && i >= 2):
				switch (RandomInt(0,2)) {
					case 0:
						sentence_add = RandomArray(CIVILIAN_DICTIONARY[(CDICT.SUBJECT)])
					case 1:
						sentence_add = "I"
					case 2:
						sentence_add = RandomArray(CIVILIAN_DICTIONARY[(CDICT.OBJECT)])
					// sentence_add =
				}
			break;
			case (random <= 3):
				sentence_add = RandomArray(CIVILIAN_DICTIONARY[(CDICT.CONJUNCTION)])
			break;
			case (random <= 6):
				sentence_add = RandomArray(CIVILIAN_DICTIONARY[(CDICT.VERB)])
				break;

			case (random <= 8):
				sentence_add = RandomArray(CIVILIAN_DICTIONARY[(CDICT.ADVERB)])
			break;


			default:
				sentence_add = RandomArray(CIVILIAN_DICTIONARY[(CDICT.ADJECTIVE)])
				if (iHealth <= 250) {
					if (RandomInt(0,1) == 0) {
						sentence_add = RandomArray(CIVILIAN_DICTIONARY[CDICT.SLUR]).toupper()
					}
				}
				break;
		}


		if (RandomInt(0,7) == 0 && i < wordcount-2) {
			sentence_add += Punctuation()
		}

		if (seed < 1) {
			local slen = sentence_add.len()
			local cut = RandomInt(0, sentence_add.len())
			local s1 = sentence_add.slice(0, cut)
			local s2 = sentence_add.slice(cut, slen)
			local nonsense = ""
			for (local i = 0; i < seed; i++) {
				nonsense += RandomInt(0, 117).tochar()
			}
			sentence_add = s1 + nonsense + s2
		}

		sentence += " " + sentence_add
	}
	sentence = strip(sentence)

	return sentence[0].tochar().toupper() + sentence.slice(1, sentence.len())  + Punctuation()
}

function OnPlayerUse(ply) {
	local sentence = GenerateSentence()
	MapSay(sentence, str_Name)
	SpeakLine(sentence, ply)
}

function HurtRage(ply) {
	if (RandomInt(1,2) == 1 && P_UTILS.BusStop("fl_NextWhineTime", fl_WhineDelay)) {
		local rage_count = RandomInt(0,4)
		local name_word = RandomInt(0, rage_count)
		local rage = ""
		for (local i = 0; i < rage_count; i++) {
			local slur = RandomArray(CIVILIAN_DICTIONARY[CDICT.SLUR])
			if (i == name_word) {
				slur = GetPlayerName(ply).tolower()
			}
			if (RandomInt(0,1) == 1) {
				slur = slur.toupper()
			}
			rage += slur + " "

		}
		for (local i = 0; i < 6; i++) {
			rage += Punctuation()
		}
		MapSay(rage, str_Name)
		SpeakLine(rage, ply)
	}
}

function DeathAction() {
	CIVILIANS_ALIVE--
	if (str_Name == "Maria") {
		Maria()
	}
}