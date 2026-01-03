
const DefaultTextSize = 30

StartTime <- 0;
EndTime <- 0;

Alpha <- 0
TextColor <- "255 255 255 "

TextColors <- ["255 255 255 255","255 204 70 255","70 255 253 255"]
TextSizes <- [15, 30, 30]

TextType <- 0;

enum TextTypes {
    Dialogue = 0,
    Objective = 1,
    Item = 3,
}



function OnPostSpawn() {

    self.KeyValueFromString("color", TextColors[TextType])
    self.KeyValueFromString("message", TextColors[TextType])

    switch (TextType) {
        case Dialogue:
            break;
        case Objective:
            break;
        case Item:
            break;
        default:
            break;
    }
    self.KeyValueFromFloat("textsize", DefaultTextSize)

}

function SetDialogueText(character = "NO_CHAR", dialogue = "NO_TEXT") {

}

function SetText(text = "NO_TEXT") {
	self.KeyValueFromString("message", text)

}

function LineThink() {


    if (StartTime < Time()) {
        self.KeyValueFromString("color", TextColor)
    }

    return 0.1
}