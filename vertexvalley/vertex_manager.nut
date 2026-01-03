

DEV <- true;

enum Teams {
	ct = 3,
	t = 2,
}

enum Stages {
    WaitingForPlayers = 0,
    Stage1 = 1,
    Stage2 = 2,
}


Preserved <- Entities.FindByName(null, "vv_preserved")

function OnPostSpawn() {
    StageSwitch()
}

function StageSwitch() {

    if (DEV) {
        DEV_SHOWCASE()
    }

    switch (Stage) {
        case Stages.WaitingForPlayers:

            break;
        case Stages.Stage1:
            QFire("intro_relay", "Trigger", "", 0.0, null)
            break;
        default:
            break;
    }
}

function DEV_SHOWCASE() {
    printl("DEV MODE IS ENABLED!!")

    CharSpeak("intro_DEV_textpos_b", "joe dev", "THIS IS DEV TEXT!!!!!!!!!!!")
}






// function MakeDialogue(target_entity = null, char = "NO_CHAR", lines = "NO_LINE") { // brah did i really write this twice am i stupid

//     lines_split = lines.split("\n")

//     local line_delay = 0
//     local line_lifetime = 5

//     for (local line = 0; line < lines_split; line++) {
//         printl("Dialogue line: "+lines_split[line])
//         printl("Spoken by character: "+char)
//         MakeTextEntity()

//     }


// }




function MakeTestVehicle(position = Vector(0,0,0)) {
    SpawnEntityFromTable("prop_vehicle_driveable", {
        vehiclescript = "scripts/vehicles/jeep_test.txt",
        actionScale = 1.0,
        model = "hummer.mdl",
        vscripts = "prop_vehicle_driveable.nut"
    })
}