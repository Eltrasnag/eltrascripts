function Stage2Events_iPod() {
    QFire("mus_leshawna_ipod", "PlaySound")
    STORY.DoStoryScene("s2_leshawna_ipod")

} // leshawna's ipod


function DoBusTravel(activator) {
    if (!("s2_bus_dest" in this) ) {
        s2_bus_dest <- Entities.FindByName(null, "s2_bus_dest");

    }
    ScreenFade(activator, 255, 255, 255, 255, 1, 0.5, FFADE_IN)
    activator.SnapEyeAngles(s2_bus_dest.EyeAngles())
    activator.SetOrigin(s2_bus_dest.GetOrigin())
}

function Stage2Events_FirstSky() {
    SetSky(PREG_SKY.DESERT)
    SetSkyboxModel("models/eltra/nide26/skybox/sky_desert.mdl", "s2_sky_origin_desert1")
    // SetSkyModel("")
}