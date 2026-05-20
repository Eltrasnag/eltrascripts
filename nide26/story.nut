::STORYLINES <- {

	"hantavirus" : @"leshawna ball oc: hey guys lets go get to get burger at the store
	leshawna ball oc:i wish they had brugers down here instead of ony at the top of the spacen eedle but whatever
	leshawna ball oc: ok lets go",
	// "hantavirus" : @"leshawna ball oc: Hello everyone.
	// leshawna ball oc: I am glad you were able to come, under... well, let's just ssay....
	// leshawna ball oc: .Short.... notice.
	// leshawna ball oc: If you have seen the news... you will know that a crisis has come underway
	// leshawna ball oc: Ugly bitches are taking over PREGNANT CITY!!!!!! and we needto stop that
	// leshawna ball oc: Also i lowkirkenuinely really want to get a bruger but they put the mcdonaldsg at the top of the Heaven Point (Look up.)
	// leshawna ball oc: .Short.... notice.
	// leshawna ball oc: .Short.... notice."

	"leshawna_bridgegone" : @"leshawna ball oc: oh what the
	leshawna ball oc: wtfwhere did the bridge go
	leshawna ball oc: someone must have lsot it
	leshawna ball oc: ok lets take the ferryinstead guys                   ",


	"testguy_1" : @"testguy: HELLO MY FRIEND !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
	"leshawna_bridgegone_again" : @"leshawna ball oc: OMG
	leshawna ball oc: ofc fatass takes the bridge too..............
	leshawna ball oc: now we have to take..........THE RIVER ROUTE",
	"s2_leshawna_ipod" : @"leshawna ball oc: OMG the signal out here is dogshit......
	leshawna ball oc: i cant even tget my map music to play ...... 8(
	leshawna ball oc: its okay thougj gusy :D i vbought an ipod for 70 diollarsCAD on ebay ystrday sooo
	leshawna ball oc: its called going #analogue hunny",


	"s2_pizzadelight" : @"Bus Driver: Hoo hoo! This is my stop! I think I am going to leave you here for now. Good luck!
	Bus Driver: Hoo hoo!
	Bus Driver: Hoo hoo!
	leshawna ball oc: STFU !!!!!!!!!!!!😁😁😁",

	"s2_puter_entry" : @"da puter: Whats up.
	da puter: Do yall wanna go online.
	da puter: Is that whwat you want to do!
	da puter: Ok ill put you on the web. That sound alright ?
	da puter: ANd then u will be able to SURF the webz... To reach the Space Needle !!!!!!!!!!
	da puter: Ok babes. Sending you through. You can djump on into me in just a sec !!!!!!!"



}

::tCharacters <- CHARACTER_COLORS

getroottable().STORY <- {}

getroottable().STORY.DoStoryScene <- function(scene_name) {

	// local is_string = (type(scene_name) == "string")

	// if (!scene_name in STORYLINES) {
		// dprintl("Story ERROR: ", scene_name, " does not exist in STORYLINES!")
		// return
	// }

	local scene_array;

	if (scene_name in STORYLINES) {
		scene_array = STORYLINES[scene_name]
	} else {
		scene_array = scene_name
	}

	local scene = split(scene_array, "\n", true)
	// local scene = STORYLINES[scene_name]

	__DumpScope(1, scene)
	dprintl("Scene array dumped to console...")

	local dialogue_array = MakeDialogueArray(scene)

	__DumpScope(0, dialogue_array)
	DoDialogueArray(dialogue_array)
}

getroottable().STORY.MakeDialogueArray <- function(scene) {
local dialogue_array = []
foreach (i, dialogue in scene) {
	dprintl("Processing dialogue index ", i, ": '", dialogue, "'")
	local splitted = split(dialogue, ":")
	splitted[0] = strip(splitted[0])
	splitted[1] = strip(splitted[1])
	dialogue_array.append(splitted)
}
return dialogue_array
}

getroottable().STORY.DoDialogueScene <- getroottable().STORY.DoStoryScene









