enum TextTypes {
    Dialogue = 0,
    Objective = 1,
    Item = 3,
}

TextFonts <- [10,8,]
TextColors <- ["255 255 255 255","255 204 70 255","70 255 253 255"]
TextSizes <- [15, 30, 30]
TextOrientations <- [2,1,1]


::CharSpeak <- function(ent_name = null, line_character = "NO_CHARACTER", lines = "NO_LINES") {

    local speaking_ent = Entities.FindByName(null, ent_name)
    if (!speaking_ent) {
        return
    }
    local lines_split = split(lines,"\n")

    local line_lifetime = 4

    local delay = 0

    for (local line = 0; line < lines_split.len(); line++) {
        printl("Dialogue line: "+lines_split[line])

        local Text = MakeTextEntity(line_character + ": " + lines_split[line], speaking_ent.GetOrigin());

        QFireByHandle(Text, "SetColor", TextColors[0], delay, null, null);
        QFireByHandle(Text, "Kill", "", delay + line_lifetime, null, null);

        delay += line_lifetime
    }

}


::MakeTextEntity <- function(text_message = "NO_MESSAGE", text_position = Vector(0,0,0), text_color = TextColors[0], text_size = TextSizes[0], text_font = TextFonts[0], text_orientation = TextOrientations[0]) {

    local text = SpawnEntityFromTable("point_worldtext", {
        origin = text_position,
        orientation = text_orientation,
        message = text_message,
        font = text_font,
        textsize = text_size,
        color = "0 0 0 0",


    })



    return text
}