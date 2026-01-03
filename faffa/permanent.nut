::Nights <- 1;
::firstnight <- true;
::WinnerWinnerChickenDinner <- false;

::LastNights <- 1;
::PreGame <- true

::DEV_Enable_BLU_To_Red_Death <- true;
::DEV_Enable_BLU_To_Red_Death_Failsafe <- true;
::DEV_TurboPhysics_Enabled <- true;
// DEV_Enable_Physics_Throwing <- true;
::BrushStates <- {}
::MapParameters <- Entities.CreateByClassname("info_map_parameters")

function OnPostSpawn() {
	GetBrushStates()
}

