screen <- Entities.FindByName(null, "o_cameras");
fx <- Entities.FindByName(null, "camera_switch_fx");
sf <- Entities.FindByName(null, "sf_camera_swap");

function ChangeCamera(name)
{
    QFire("cams_buttons", "Lock", "", 0.00, null);

    QFireByHandle(sf, "PlaySound", "", 0.00, null, null);
    QFireByHandle(screen, "SetCamera", "camera_"+name.tostring()+"", 0.1, null, null);
    QFire("camera_"+name, "SetOnAndTurnOthersOff", "", 0.05, null);
    QFireByHandle(fx, "Enable", "", 0.00, null, null);
    QFireByHandle(fx, "Disable", "", 0.5, null, null);
    EmitAmbientSoundOn("eltra/camera_switch.mp3", 100.00, 100, RandomInt(90, 105), screen);
    QFire("ccmd", "Command", "playgamesound eltra/camera_switch.mp3", 0.00, null);
    QFire("cams_buttons", "Unlock", "", 1.00, null);
}