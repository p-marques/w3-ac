// Absolute Camera 4.x - 2022, pMarK
// Manager Class

class CACameraManager {

	private var gConfig : CInGameConfigWrapper;
	private var AimCamera, SignsCamera, ClueCamera, MeditationCamera, WitcherSensesCamera, WitcherSensesInteriorCamera, WitcherSensesHorseCamera, SwimWitcherSensesCamera, SwimCamera, HorseRidingCombatCamera, HorseRidingCamera, FistCombatCamera, CombatLockedCamera, CombatCamera, SprintCamera, ExplorationCamera, SailingCamera, InteriorCamera : SACamera;

	private var isPlayerMountingHorse, cameraHasBeenToggled : bool;
	default cameraHasBeenToggled = false;

	private var DebugMode : bool;
		default DebugMode = false;

	public function InitAC()
	{
		gConfig = theGame.GetInGameConfigWrapper();

		ACameraSetupInputs();
		InitialMenuMaintenance();
	}

	public function GetCamera() : SACamera
	{
		var grpName : name;
		var camera : SACamera;
		grpName = GetMenuGroupName();
		camera = GetCameraByState(grpName);

		if(camera.IsShoulderToggled || cameraHasBeenToggled && GetIsUniversalShoulderToggle())
			camera.PosX *= -1;

		return camera;
	}

	public function GetIsCurrentCameraOn() : bool
	{
		var camera: SACamera;

		camera = GetCamera();

		return camera.IsOn;
	}

	private function GetCameraByState(grpName : name) : SACamera
	{
		var workingPresetCam : SAPresetCamera;

		switch(grpName)
		{
			case 'ACaim' :
				AimCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				AimCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				AimCamera.Name = "Aim Camera";

				if(AimCamera.IsLocked)
				{
					if(AimCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						AimCamera.Name += " Preset by " + workingPresetCam.Author;

						AimCamera.PosX = workingPresetCam.PosX;
						AimCamera.PosY = workingPresetCam.PosY;
						AimCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						AimCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						AimCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						AimCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					AimCamera.Name += " [Unlocked]";
					AimCamera.PosX = AimCamera.UnlockedPos.X;
					AimCamera.PosY = AimCamera.UnlockedPos.Y;
					AimCamera.PosZ = AimCamera.UnlockedPos.Z;
				}

				return AimCamera;
			case 'ACsign' :
				SignsCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				SignsCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				SignsCamera.Name = "Sign Camera";

				if(SignsCamera.IsLocked)
				{
					if(SignsCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						SignsCamera.Name += " Preset by " + workingPresetCam.Author;

						SignsCamera.PosX = workingPresetCam.PosX;
						SignsCamera.PosY = workingPresetCam.PosY;
						SignsCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						SignsCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						SignsCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						SignsCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					SignsCamera.Name += " [Unlocked]";
					SignsCamera.PosX = SignsCamera.UnlockedPos.X;
					SignsCamera.PosY = SignsCamera.UnlockedPos.Y;
					SignsCamera.PosZ = SignsCamera.UnlockedPos.Z;
				}

				return SignsCamera;
			case 'ACclue' :
				ClueCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				ClueCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				ClueCamera.Name = "Clue Investigation Camera";

				if(ClueCamera.IsLocked)
				{
					if(ClueCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						ClueCamera.Name += " Preset by " + workingPresetCam.Author;

						ClueCamera.PosX = workingPresetCam.PosX;
						ClueCamera.PosY = workingPresetCam.PosY;
						ClueCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						ClueCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						ClueCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						ClueCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					ClueCamera.Name += " [Unlocked]";
					ClueCamera.PosX = ClueCamera.UnlockedPos.X;
					ClueCamera.PosY = ClueCamera.UnlockedPos.Y;
					ClueCamera.PosZ = ClueCamera.UnlockedPos.Z;
				}

				return ClueCamera;
			case 'ACmed' :
				MeditationCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				MeditationCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				MeditationCamera.Name = "Meditation Camera";

				if(MeditationCamera.IsLocked)
				{
					if(MeditationCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						MeditationCamera.Name += " Preset by " + workingPresetCam.Author;

						MeditationCamera.PosX = workingPresetCam.PosX;
						MeditationCamera.PosY = workingPresetCam.PosY;
						MeditationCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						MeditationCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						MeditationCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						MeditationCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					MeditationCamera.Name += " [Unlocked]";
					MeditationCamera.PosX = MeditationCamera.UnlockedPos.X;
					MeditationCamera.PosY = MeditationCamera.UnlockedPos.Y;
					MeditationCamera.PosZ = MeditationCamera.UnlockedPos.Z;
				}

				return MeditationCamera;
			case 'ACws' :
				WitcherSensesCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				WitcherSensesCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				WitcherSensesCamera.Name = "Witcher Senses Camera";

				if(WitcherSensesCamera.IsLocked)
				{
					if(WitcherSensesCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						WitcherSensesCamera.Name += " Preset by " + workingPresetCam.Author;

						WitcherSensesCamera.PosX = workingPresetCam.PosX;
						WitcherSensesCamera.PosY = workingPresetCam.PosY;
						WitcherSensesCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						WitcherSensesCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						WitcherSensesCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						WitcherSensesCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					WitcherSensesCamera.Name += " [Unlocked]";
					WitcherSensesCamera.PosX = WitcherSensesCamera.UnlockedPos.X;
					WitcherSensesCamera.PosY = WitcherSensesCamera.UnlockedPos.Y;
					WitcherSensesCamera.PosZ = WitcherSensesCamera.UnlockedPos.Z;
				}

				return WitcherSensesCamera;
			case 'ACwsInt' :
				WitcherSensesInteriorCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				WitcherSensesInteriorCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				WitcherSensesInteriorCamera.Name = "Witcher Senses Interiors Camera";

				if(WitcherSensesInteriorCamera.IsLocked)
				{
					if(WitcherSensesInteriorCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						WitcherSensesInteriorCamera.Name += " Preset by " + workingPresetCam.Author;

						WitcherSensesInteriorCamera.PosX = workingPresetCam.PosX;
						WitcherSensesInteriorCamera.PosY = workingPresetCam.PosY;
						WitcherSensesInteriorCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						WitcherSensesInteriorCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						WitcherSensesInteriorCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						WitcherSensesInteriorCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					WitcherSensesInteriorCamera.Name += " [Unlocked]";
					WitcherSensesInteriorCamera.PosX = WitcherSensesInteriorCamera.UnlockedPos.X;
					WitcherSensesInteriorCamera.PosY = WitcherSensesInteriorCamera.UnlockedPos.Y;
					WitcherSensesInteriorCamera.PosZ = WitcherSensesInteriorCamera.UnlockedPos.Z;
				}

				return WitcherSensesInteriorCamera;
			case 'ACwsHorse' :
				WitcherSensesHorseCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				WitcherSensesHorseCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				WitcherSensesHorseCamera.Name = "Witcher Senses Horse Camera";

				if(WitcherSensesHorseCamera.IsLocked)
				{
					if(WitcherSensesHorseCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						WitcherSensesHorseCamera.Name += " Preset by " + workingPresetCam.Author;

						WitcherSensesHorseCamera.PosX = workingPresetCam.PosX;
						WitcherSensesHorseCamera.PosY = workingPresetCam.PosY;
						WitcherSensesHorseCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						WitcherSensesHorseCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						WitcherSensesHorseCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						WitcherSensesHorseCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					WitcherSensesHorseCamera.Name += " [Unlocked]";
					WitcherSensesHorseCamera.PosX = WitcherSensesHorseCamera.UnlockedPos.X;
					WitcherSensesHorseCamera.PosY = WitcherSensesHorseCamera.UnlockedPos.Y;
					WitcherSensesHorseCamera.PosZ = WitcherSensesHorseCamera.UnlockedPos.Z;
				}

				return WitcherSensesHorseCamera;
			case 'ACwsSwim' :
				SwimWitcherSensesCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				SwimWitcherSensesCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				SwimWitcherSensesCamera.Name = "Witcher Senses Swim Camera";

				if(SwimWitcherSensesCamera.IsLocked)
				{
					if(SwimWitcherSensesCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						SwimWitcherSensesCamera.Name += " Preset by " + workingPresetCam.Author;

						SwimWitcherSensesCamera.PosX = workingPresetCam.PosX;
						SwimWitcherSensesCamera.PosY = workingPresetCam.PosY;
						SwimWitcherSensesCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						SwimWitcherSensesCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						SwimWitcherSensesCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						SwimWitcherSensesCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					SwimWitcherSensesCamera.Name += " [Unlocked]";
					SwimWitcherSensesCamera.PosX = SwimWitcherSensesCamera.UnlockedPos.X;
					SwimWitcherSensesCamera.PosY = SwimWitcherSensesCamera.UnlockedPos.Y;
					SwimWitcherSensesCamera.PosZ = SwimWitcherSensesCamera.UnlockedPos.Z;
				}

				return SwimWitcherSensesCamera;
			case 'ACswim' :
				SwimCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				SwimCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				SwimCamera.Name = "Swimming Camera";

				if(SwimCamera.IsLocked)
				{
					if(SwimCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						SwimCamera.Name += " Preset by " + workingPresetCam.Author;

						SwimCamera.PosX = workingPresetCam.PosX;
						SwimCamera.PosY = workingPresetCam.PosY;
						SwimCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						SwimCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						SwimCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						SwimCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					SwimCamera.Name += " [Unlocked]";
					SwimCamera.PosX = SwimCamera.UnlockedPos.X;
					SwimCamera.PosY = SwimCamera.UnlockedPos.Y;
					SwimCamera.PosZ = SwimCamera.UnlockedPos.Z;
				}

				return SwimCamera;
			case 'AChorseCbt' :
				HorseRidingCombatCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				HorseRidingCombatCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				HorseRidingCombatCamera.Name = "Horse Riding Combat Camera";

				if(HorseRidingCombatCamera.IsLocked)
				{
					if(HorseRidingCombatCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						HorseRidingCombatCamera.Name += " Preset by " + workingPresetCam.Author;

						HorseRidingCombatCamera.PosX = workingPresetCam.PosX;
						HorseRidingCombatCamera.PosY = workingPresetCam.PosY;
						HorseRidingCombatCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						HorseRidingCombatCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						HorseRidingCombatCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						HorseRidingCombatCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					HorseRidingCombatCamera.Name += " [Unlocked]";
					HorseRidingCombatCamera.PosX = HorseRidingCombatCamera.UnlockedPos.X;
					HorseRidingCombatCamera.PosY = HorseRidingCombatCamera.UnlockedPos.Y;
					HorseRidingCombatCamera.PosZ = HorseRidingCombatCamera.UnlockedPos.Z;
				}

				return HorseRidingCombatCamera;
			case 'AChorse' :
				HorseRidingCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				HorseRidingCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				HorseRidingCamera.Name = "Horse Riding Camera";

				if(HorseRidingCamera.IsLocked)
				{
					if(HorseRidingCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						HorseRidingCamera.Name += " Preset by " + workingPresetCam.Author;

						HorseRidingCamera.PosX = workingPresetCam.PosX;
						HorseRidingCamera.PosY = workingPresetCam.PosY;
						HorseRidingCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						HorseRidingCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						HorseRidingCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						HorseRidingCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					HorseRidingCamera.Name += " [Unlocked]";
					HorseRidingCamera.PosX = HorseRidingCamera.UnlockedPos.X;
					HorseRidingCamera.PosY = HorseRidingCamera.UnlockedPos.Y;
					HorseRidingCamera.PosZ = HorseRidingCamera.UnlockedPos.Z;
				}

				if(isPlayerMountingHorse)
				{
					HorseRidingCamera.PosY -= 1.f;
				}

				return HorseRidingCamera;
			case 'ACfist' :
				FistCombatCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				FistCombatCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				FistCombatCamera.Name = "Fists Combat Camera";

				if(FistCombatCamera.IsLocked)
				{
					if(FistCombatCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						FistCombatCamera.Name += " Preset by " + workingPresetCam.Author;

						FistCombatCamera.PosX = workingPresetCam.PosX;
						FistCombatCamera.PosY = workingPresetCam.PosY;
						FistCombatCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						FistCombatCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						FistCombatCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						FistCombatCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					FistCombatCamera.Name += " [Unlocked]";
					FistCombatCamera.PosX = FistCombatCamera.UnlockedPos.X;
					FistCombatCamera.PosY = FistCombatCamera.UnlockedPos.Y;
					FistCombatCamera.PosZ = FistCombatCamera.UnlockedPos.Z;
				}

				return FistCombatCamera;
			case 'AClck' :
				CombatLockedCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				CombatLockedCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				CombatLockedCamera.Name = "Combat Locked to Target Camera";

				if(CombatLockedCamera.IsLocked)
				{
					if(CombatLockedCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						CombatLockedCamera.Name += " Preset by " + workingPresetCam.Author;

						CombatLockedCamera.PosX = workingPresetCam.PosX;
						CombatLockedCamera.PosY = workingPresetCam.PosY;
						CombatLockedCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						CombatLockedCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						CombatLockedCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						CombatLockedCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					CombatLockedCamera.Name += " [Unlocked]";
					CombatLockedCamera.PosX = CombatLockedCamera.UnlockedPos.X;
					CombatLockedCamera.PosY = CombatLockedCamera.UnlockedPos.Y;
					CombatLockedCamera.PosZ = CombatLockedCamera.UnlockedPos.Z;
				}

				return CombatLockedCamera;
			case 'ACcbt' :
				CombatCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				CombatCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				CombatCamera.Name = "Combat Camera";

				if(CombatCamera.IsLocked)
				{
					if(CombatCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						CombatCamera.Name += " Preset by " + workingPresetCam.Author;

						CombatCamera.PosX = workingPresetCam.PosX;
						CombatCamera.PosY = workingPresetCam.PosY;
						CombatCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						CombatCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						CombatCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						CombatCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					CombatCamera.Name += " [Unlocked]";
					CombatCamera.PosX = CombatCamera.UnlockedPos.X;
					CombatCamera.PosY = CombatCamera.UnlockedPos.Y;
					CombatCamera.PosZ = CombatCamera.UnlockedPos.Z;
				}

				return CombatCamera;
			case 'ACsprint' :
				SprintCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');

				if(!SprintCamera.IsOn) { break; }

				SprintCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				SprintCamera.Name = "Sprint Camera";

				if(SprintCamera.IsLocked)
				{
					if(SprintCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						SprintCamera.Name += " Preset by " + workingPresetCam.Author;

						SprintCamera.PosX = workingPresetCam.PosX;
						SprintCamera.PosY = workingPresetCam.PosY;
						SprintCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						SprintCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						SprintCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						SprintCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					SprintCamera.Name += " [Unlocked]";
					SprintCamera.PosX = SprintCamera.UnlockedPos.X;
					SprintCamera.PosY = SprintCamera.UnlockedPos.Y;
					SprintCamera.PosZ = SprintCamera.UnlockedPos.Z;
				}

				return SprintCamera;
			case 'ACboat' :
				SailingCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				SailingCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				SailingCamera.Name = "Sailing Camera";

				if(SailingCamera.IsLocked)
				{
					if(SailingCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						SailingCamera.Name += " Preset by " + workingPresetCam.Author;

						SailingCamera.PosX = workingPresetCam.PosX;
						SailingCamera.PosY = workingPresetCam.PosY;
						SailingCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						SailingCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						SailingCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						SailingCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					SailingCamera.Name += " [Unlocked]";
					SailingCamera.PosX = SailingCamera.UnlockedPos.X;
					SailingCamera.PosY = SailingCamera.UnlockedPos.Y;
					SailingCamera.PosZ = SailingCamera.UnlockedPos.Z;
				}

				return SailingCamera;
			case 'ACint' :
				InteriorCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				InteriorCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				InteriorCamera.Name = "Interiors Camera";

				if(InteriorCamera.IsLocked)
				{
					if(InteriorCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						InteriorCamera.Name += " Preset by " + workingPresetCam.Author;

						InteriorCamera.PosX = workingPresetCam.PosX;
						InteriorCamera.PosY = workingPresetCam.PosY;
						InteriorCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						InteriorCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						InteriorCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						InteriorCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					InteriorCamera.Name += " [Unlocked]";
					InteriorCamera.PosX = InteriorCamera.UnlockedPos.X;
					InteriorCamera.PosY = InteriorCamera.UnlockedPos.Y;
					InteriorCamera.PosZ = InteriorCamera.UnlockedPos.Z;
				}

				return InteriorCamera;
			case 'ACexp' :
				ExplorationCamera.IsOn = gConfig.GetVarValue(grpName, 'ACamON');
				ExplorationCamera.Mode = StringToInt( gConfig.GetVarValue( grpName, 'ACmode' ) );
				ExplorationCamera.Name = "Exploration Camera";

				if(ExplorationCamera.IsLocked)
				{
					if(ExplorationCamera.Mode == 1)
					{
						workingPresetCam = GetPresetCamera(grpName);
						ExplorationCamera.Name += " Preset by " + workingPresetCam.Author;

						ExplorationCamera.PosX = workingPresetCam.PosX;
						ExplorationCamera.PosY = workingPresetCam.PosY;
						ExplorationCamera.PosZ = workingPresetCam.PosZ;
					}
					else
					{
						ExplorationCamera.PosX = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetX' ) );
						ExplorationCamera.PosY = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetY' ) );
						ExplorationCamera.PosZ = StringToFloat( gConfig.GetVarValue( grpName, 'ACOffsetZ' ) );
					}
				}
				else
				{
					ExplorationCamera.Name += " [Unlocked]";
					ExplorationCamera.PosX = ExplorationCamera.UnlockedPos.X;
					ExplorationCamera.PosY = ExplorationCamera.UnlockedPos.Y;
					ExplorationCamera.PosZ = ExplorationCamera.UnlockedPos.Z;
				}

				return ExplorationCamera;
		}

		return ExplorationCamera;
	}

	private function GetPresetCamera(grpName : name) : SAPresetCamera
	{
		var presetCamera : SAPresetCamera;

		switch(grpName)
		{
			case 'ACaim' : 		presetCamera = GetACPresetAim();						break;
			case 'ACsign' : 	presetCamera = GetACPresetSigns(); 	 					break;
			case 'ACclue' : 	presetCamera = GetACPresetClue();	 					break;
			case 'ACmed' : 		presetCamera = GetACPresetMeditation(); 		 		break;
			case 'ACws' : 		presetCamera = GetACPresetWitcherSenses(); 		 		break;
			case 'ACwsInt' : 	presetCamera = GetACPresetWitcherSensesInteriors();		break;
			case 'ACwsHorse' : 	presetCamera = GetACPresetWitcherSensesHorse(); 		break;
			case 'ACwsSwim' : 	presetCamera = GetACPresetWitcherSensesSwimming(); 		break;
			case 'ACswim' : 	presetCamera = GetACPresetSwimming();					break;
			case 'AChorseCbt' : presetCamera = GetACPresetHorseRidingCombat(); 			break;
			case 'AChorse' : 	presetCamera = GetACPresetHorseRiding(); 	 			break;
			case 'ACfist' : 	presetCamera = GetACPresetFistsCombat(); 	 			break;
			case 'AClck' : 		presetCamera = GetACPresetCombatLockedToTarget(); 		break;
			case 'ACcbt' : 		presetCamera = GetACPresetCombat(); 					break;
			case 'ACsprint' : 	presetCamera = GetACPresetSprint();						break;
			case 'ACexp' :		presetCamera = GetACPresetExploration();				break;
			case 'ACboat' :		presetCamera = GetACPresetSailing(); 					break;
			case 'ACint' : 		presetCamera = GetACPresetInteriors(); 					break;
		}

		return presetCamera;
	}

	private function GetMenuGroupName() : name
	{
		var grpName : name;
		grpName = 'NULL';

		if(thePlayer.GetCurrentStateName() == 'AimThrow')
		{
			grpName = 'ACaim';
		}
		else if( thePlayer.IsCurrentSignChanneled() && thePlayer.GetCurrentlyCastSign() != ST_Quen && thePlayer.GetCurrentlyCastSign() != ST_Yrden )
		{
			grpName = 'ACsign';
		}
		else if(thePlayer.GetPlayerAction() == PEA_ExamineGround)
		{
			grpName = 'ACclue';
		}
		else if(thePlayer.GetCurrentStateName() == 'ExplorationMeditation' ||
			( thePlayer.GetPlayerAction() == PEA_Meditation && gConfig.GetVarValue('ACmed', 'ACexpMedForPoPON')))
		{
			grpName = 'ACmed';
		}
		else if(thePlayer.IsSwimming())
		{
			if(theGame.IsFocusModeActive())
			{
				grpName = 'ACwsSwim';
			}
			else
			{
				grpName = 'ACswim';
			}
		}
		else if (theGame.IsFocusModeActive())
		{
			if (thePlayer.IsInInterior())
			{
				grpName = 'ACwsInt';
			}
			else if(thePlayer.GetCurrentStateName() == 'HorseRiding')
			{
				grpName = 'ACwsHorse';
			}
			else
			{
				grpName = 'ACws';
			}
		}
		else if( thePlayer.IsInInterior() && !thePlayer.IsInCombat())
		{
			grpName = 'ACint';
		}
		else if( thePlayer.GetCurrentStateName() == 'Sailing' )
		{
			grpName = 'ACboat';
		}
		else if (thePlayer.GetCurrentStateName() == 'HorseRiding' || thePlayer.GetCurrentStateName() == 'MountHorse')
		{
			isPlayerMountingHorse = false;

			if(thePlayer.GetCurrentStateName() == 'MountHorse')
				isPlayerMountingHorse = true;

			if(thePlayer.IsInCombat())
			{
				grpName = 'AChorseCbt';
			}
			else
			{
				grpName = 'AChorse';
			}
		}
		else if (thePlayer.IsInCombat())
		{
			if (thePlayer.IsInCombatFist())
			{
				grpName = 'ACfist';
			}
			else if (thePlayer.IsCameraLockedToTarget())
			{
				grpName = 'AClck';
			}
			else
			{
				grpName = 'ACcbt';
			}
		}
		else if(thePlayer.GetCurrentStateName() == 'Exploration')
		{
			if(thePlayer.GetIsSprinting())
			{
				grpName = 'ACsprint';
			}
			else
			{
				grpName = 'ACexp';
			}
		}

		return grpName;
	}

	public function GetIsPlayerMountingHorse() : bool
	{
		return isPlayerMountingHorse;
	}

	public function GetStopOutOfCombatActionZoomOut() : bool
	{
		return gConfig.GetVarValue('ACcbt', 'ACcbtZoomOutCtrl');
	}

	public function GetStopSprintCamShake() : bool
	{
		return gConfig.GetVarValue('ACsprint', 'ACamStopCamShake');
	}

	public function GetControlSailingCameraZoom() : bool
	{
		return gConfig.GetVarValue('ACboat', 'ACboatZoomCtrl');
	}

	public function GetFOV() : float
	{
		return StringToFloat( gConfig.GetVarValue( 'ACfovgroup', 'ACFOV' ) );
	}

	public function GetAutoCenterMode() : Int32
	{
		var ACautoCenter : Int32;
		ACautoCenter = StringToInt(gConfig.GetVarValue('ACautoCenterPitch', 'ACautoCenter'));

		if( ACautoCenter < 0 || ACautoCenter > 2 )
		{
			gConfig.SetVarValue( 'ACautoCenterPitch', 'ACautoCenter', 0);
			theGame.SaveUserSettings();
		}

		return ACautoCenter;
	}

	public function GetPicthMode() : Int32
	{
		var pitchMode : Int32;
		pitchMode = StringToInt(gConfig.GetVarValue('ACautoCenterPitch', 'ACpitchOptions'));

		if( pitchMode < 0 || pitchMode > 2 )
		{
			gConfig.SetVarValue( 'ACautoCenterPitch', 'ACpitchOptions', 2);
			theGame.SaveUserSettings();
		}

		return pitchMode;
	}

	public function GetMinPitch() : float
	{
		var minPitch : float;
		minPitch = StringToFloat( gConfig.GetVarValue( 'ACautoCenterPitch', 'ACminPitch' ) );

		if(minPitch < -80.0f || minPitch > -10.0f)
		{
			theGame.GetInGameConfigWrapper().SetVarValue( 'ACautoCenterPitch', 'ACminPitch', -60.0 );
			theGame.SaveUserSettings();
		}

		return minPitch;
	}

	public function GetMaxPitch() : float
	{
		var maxPitch : float;
		maxPitch = StringToFloat( gConfig.GetVarValue( 'ACautoCenterPitch', 'ACmaxPitch' ) );

		if(maxPitch < 10.0f || maxPitch > 80.0f)
		{
			theGame.GetInGameConfigWrapper().SetVarValue( 'ACautoCenterPitch', 'ACmaxPitch', 60.0 );
			theGame.SaveUserSettings();
		}

		return maxPitch;
	}

	public function GetDesiredPitch() : float
	{
		var desiredPitch : float;
		desiredPitch = StringToFloat( gConfig.GetVarValue( 'ACautoCenterPitch', 'ACdesiredPitch' ) );

		if(desiredPitch < -80.0f || desiredPitch > 80.0f)
		{
			theGame.GetInGameConfigWrapper().SetVarValue( 'ACautoCenterPitch', 'ACdesiredPitch', -80.0 );
			theGame.SaveUserSettings();
		}

		return desiredPitch;
	}

	private function GetIsUniversalShoulderToggle() : bool
	{
		return gConfig.GetVarValue('RGTotherSettings', 'ACUST');
	}

	private function InitialMenuMaintenance()
	{
		var movAmount : float;
		var fov : float;
		movAmount = StringToFloat( gConfig.GetVarValue( 'RGTotherSettings', 'RGToffsetPerHit' ) );
		fov = StringToFloat( gConfig.GetVarValue( 'ACfovgroup', 'ACFOV' ) );

		if(movAmount < 0.1)
		{
			gConfig.SetVarValue( 'RGTotherSettings', 'RGToffsetPerHit', 0.1 );
			theGame.SaveUserSettings();
		}

		if(fov < 40.0 || fov > 90.0)
		{
			gConfig.SetVarValue( 'ACfovgroup', 'ACFOV', 60.0 );
			theGame.SaveUserSettings();
		}
	}

	private function LockCamera(stateName : name)
	{
		switch(stateName)
		{
			case 'ACaim' : 		if(!AimCamera.IsLocked) { AimCamera.IsLocked = true; } 										break;
			case 'ACsign' : 	if(!SignsCamera.IsLocked) { SignsCamera.IsLocked = true; } 									break;
			case 'ACclue' : 	if(!ClueCamera.IsLocked) { ClueCamera.IsLocked = true; } 									break;
			case 'ACmed' : 		if(!MeditationCamera.IsLocked) { MeditationCamera.IsLocked = true; } 						break;
			case 'ACws' : 		if(!WitcherSensesCamera.IsLocked) { WitcherSensesCamera.IsLocked = true; } 					break;
			case 'ACwsInt' : 	if(!WitcherSensesInteriorCamera.IsLocked) { WitcherSensesInteriorCamera.IsLocked = true; } 	break;
			case 'ACwsHorse' : 	if(!WitcherSensesHorseCamera.IsLocked) { WitcherSensesHorseCamera.IsLocked = true; } 		break;
			case 'ACwsSwim' : 	if(!SwimWitcherSensesCamera.IsLocked) { SwimWitcherSensesCamera.IsLocked = true; } 			break;
			case 'ACswim' : 	if(!SwimCamera.IsLocked) { SwimCamera.IsLocked = true; } 									break;
			case 'AChorseCbt' : if(!HorseRidingCombatCamera.IsLocked) { HorseRidingCombatCamera.IsLocked = true; } 			break;
			case 'AChorse' : 	if(!HorseRidingCamera.IsLocked) { HorseRidingCamera.IsLocked = true; } 						break;
			case 'ACfist' : 	if(!FistCombatCamera.IsLocked) { FistCombatCamera.IsLocked = true; } 						break;
			case 'AClck' : 		if(!CombatLockedCamera.IsLocked) { CombatLockedCamera.IsLocked = true; } 					break;
			case 'ACcbt' : 		if(!CombatCamera.IsLocked) { CombatCamera.IsLocked = true; } 								break;
			case 'ACsprint' : 	if(!SprintCamera.IsLocked) { SprintCamera.IsLocked = true; } 								break;
			case 'ACexp' : 		if(!ExplorationCamera.IsLocked) { ExplorationCamera.IsLocked = true; } 						break;
			case 'ACboat' :		if(!SailingCamera.IsLocked) { SailingCamera.IsLocked = true; }								break;
			case 'ACint' :		if(!InteriorCamera.IsLocked) { InteriorCamera.IsLocked = true; }							break;
		}

		if(DebugMode) { thePlayer.DisplayHudMessage("[DEBUG] (" + stateName +") Camera Locked"); }
	}

	private function SetCameraMode(grpName : name, mode : Int32)
	{
		if(mode == 0 || mode == 1)
		{
			gConfig.SetVarValue( grpName, 'ACmode', mode );
			theGame.SaveUserSettings();
		}
	}

	private function UnlockCamera(stateName : name)
	{
		switch(stateName)
		{
			case 'ACaim' :
				AimCamera.IsLocked = false;
				AimCamera.UnlockedPos = Vector(AimCamera.PosX, AimCamera.PosY, AimCamera.PosZ);
				break;
			case 'ACsign' :
				SignsCamera.IsLocked = false;
				SignsCamera.UnlockedPos = Vector(SignsCamera.PosX, SignsCamera.PosY, SignsCamera.PosZ);
				break;
			case 'ACclue' :
				ClueCamera.IsLocked = false;
				ClueCamera.UnlockedPos = Vector(ClueCamera.PosX, ClueCamera.PosY, ClueCamera.PosZ);
				break;
			case 'ACmed' :
				MeditationCamera.IsLocked = false;
				MeditationCamera.UnlockedPos = Vector(MeditationCamera.PosX, MeditationCamera.PosY, MeditationCamera.PosZ);
				break;
			case 'ACws' :
				WitcherSensesCamera.IsLocked = false;
				WitcherSensesCamera.UnlockedPos = Vector(WitcherSensesCamera.PosX, WitcherSensesCamera.PosY, WitcherSensesCamera.PosZ);
				break;
			case 'ACwsInt' :
				WitcherSensesInteriorCamera.IsLocked = false;
				WitcherSensesInteriorCamera.UnlockedPos = Vector(WitcherSensesInteriorCamera.PosX, WitcherSensesInteriorCamera.PosY, WitcherSensesInteriorCamera.PosZ);
				break;
			case 'ACwsHorse' :
				WitcherSensesHorseCamera.IsLocked = false;
				WitcherSensesHorseCamera.UnlockedPos = Vector(WitcherSensesHorseCamera.PosX, WitcherSensesHorseCamera.PosY, WitcherSensesHorseCamera.PosZ);
				break;
			case 'ACwsSwim' :
				SwimWitcherSensesCamera.IsLocked = false;
				SwimWitcherSensesCamera.UnlockedPos = Vector(SwimWitcherSensesCamera.PosX, SwimWitcherSensesCamera.PosY, SwimWitcherSensesCamera.PosZ);
				break;
			case 'ACswim' :
				SwimCamera.IsLocked = false;
				SwimCamera.UnlockedPos = Vector(SwimCamera.PosX, SwimCamera.PosY, SwimCamera.PosZ);
				break;
			case 'AChorseCbt' :
				HorseRidingCombatCamera.IsLocked = false;
				HorseRidingCombatCamera.UnlockedPos = Vector(HorseRidingCombatCamera.PosX, HorseRidingCombatCamera.PosY, HorseRidingCombatCamera.PosZ);
				break;
			case 'AChorse' :
				HorseRidingCamera.IsLocked = false;
				HorseRidingCamera.UnlockedPos = Vector(HorseRidingCamera.PosX, HorseRidingCamera.PosY, HorseRidingCamera.PosZ);
				break;
			case 'ACfist' :
				FistCombatCamera.IsLocked = false;
				FistCombatCamera.UnlockedPos = Vector(FistCombatCamera.PosX, FistCombatCamera.PosY, FistCombatCamera.PosZ);
				break;
			case 'AClck' :
				CombatLockedCamera.IsLocked = false;
				CombatLockedCamera.UnlockedPos = Vector(CombatLockedCamera.PosX, CombatLockedCamera.PosY, CombatLockedCamera.PosZ);
				break;
			case 'ACcbt' :
				CombatCamera.IsLocked = false;
				CombatCamera.UnlockedPos = Vector(CombatCamera.PosX, CombatCamera.PosY, CombatCamera.PosZ);
				break;
			case 'ACsprint' :
				SprintCamera.IsLocked = false;
				SprintCamera.UnlockedPos = Vector(SprintCamera.PosX, SprintCamera.PosY, SprintCamera.PosZ);
				break;
			case 'ACexp' :
				ExplorationCamera.IsLocked = false;
				ExplorationCamera.UnlockedPos = Vector(ExplorationCamera.PosX, ExplorationCamera.PosY, ExplorationCamera.PosZ);
				break;
			case 'ACboat' :
				SailingCamera.IsLocked = false;
				SailingCamera.UnlockedPos = Vector(SailingCamera.PosX, SailingCamera.PosY, SailingCamera.PosZ);
				break;
			case 'ACint' :
				InteriorCamera.IsLocked = false;
				InteriorCamera.UnlockedPos = Vector(InteriorCamera.PosX, InteriorCamera.PosY, InteriorCamera.PosZ);
				break;
		}

		if(DebugMode) { thePlayer.DisplayHudMessage("[DEBUG] (" + stateName +") Camera Unlocked"); }
	}

	private function SaveCamera()
	{
		var grpName : name;
		var camera : SACamera;
		grpName = GetMenuGroupName();
		camera = GetCameraByState(grpName);

		if(!camera.IsLocked)
		{
			gConfig.SetVarValue( grpName, 'ACOffsetX', camera.UnlockedPos.X );
			gConfig.SetVarValue( grpName, 'ACOffsetY', camera.UnlockedPos.Y );
			gConfig.SetVarValue( grpName, 'ACOffsetZ', camera.UnlockedPos.Z );
			theGame.SaveUserSettings();

			thePlayer.DisplayHudMessage(camera.Name + " Camera Saved");
			LockCamera(grpName);

			if(camera.Mode == 1)
				SetCameraMode(grpName, 0);
		}
	}

	private function DisplayCameraInfo()
	{
		var camera : SACamera;
		var camName : string;
		var msg : string;
		camera = GetCamera();
		camName = camera.Name;

		if(camera.IsOn)
			msg = camName + " (X=" + camera.PosX + ", Y=" + camera.PosY + ", Z=" + camera.PosZ + ")";
		else
			msg = camName + " Camera is OFF";

		thePlayer.DisplayHudMessage(msg);
	}

	private function ToggleCameraOnOff()
	{
		var msg : string;
		var grpName : name;
		var camera : SACamera;
		msg = "Camera Toggled";
		grpName = GetMenuGroupName();
		camera = GetCameraByState(grpName);

		// Sprint Problem HACK
		if(grpName == 'ACsprint')
			camera = SprintCamera;

		gConfig.SetVarValue( grpName, 'ACamON', !camera.IsOn);
		theGame.SaveUserSettings();

		if(DebugMode)
		{
			if(!camera.IsOn)
				msg += " ON";
			else
				msg += " OFF";

			thePlayer.DisplayHudMessage(grpName + " " + msg);
		}
	}

	private function ToggleShoulder()
	{
		var grpName : name;
		grpName = GetMenuGroupName();

		switch(grpName)
		{
			case 'ACaim' : 		AimCamera.IsShoulderToggled = !AimCamera.IsShoulderToggled; 										break;
			case 'ACsign' : 	SignsCamera.IsShoulderToggled = !SignsCamera.IsShoulderToggled;										break;
			case 'ACclue' : 	ClueCamera.IsShoulderToggled = !ClueCamera.IsShoulderToggled;										break;
			case 'ACmed' : 		MeditationCamera.IsShoulderToggled = !MeditationCamera.IsShoulderToggled;							break;
			case 'ACws' : 		WitcherSensesCamera.IsShoulderToggled = !WitcherSensesCamera.IsShoulderToggled; 					break;
			case 'ACwsInt' : 	WitcherSensesInteriorCamera.IsShoulderToggled = !WitcherSensesInteriorCamera.IsShoulderToggled; 	break;
			case 'ACwsHorse' : 	WitcherSensesHorseCamera.IsShoulderToggled = !WitcherSensesHorseCamera.IsShoulderToggled;			break;
			case 'ACwsSwim' : 	SwimWitcherSensesCamera.IsShoulderToggled = !SwimWitcherSensesCamera.IsShoulderToggled; 			break;
			case 'ACswim' : 	SwimCamera.IsShoulderToggled = !SwimCamera.IsShoulderToggled;										break;
			case 'AChorseCbt' : HorseRidingCombatCamera.IsShoulderToggled = !HorseRidingCombatCamera.IsShoulderToggled;				break;
			case 'AChorse' : 	HorseRidingCamera.IsShoulderToggled = !HorseRidingCamera.IsShoulderToggled;							break;
			case 'ACfist' : 	FistCombatCamera.IsShoulderToggled = !FistCombatCamera.IsShoulderToggled;							break;
			case 'AClck' : 		CombatLockedCamera.IsShoulderToggled = !CombatLockedCamera.IsShoulderToggled;						break;
			case 'ACcbt' : 		CombatCamera.IsShoulderToggled = !CombatCamera.IsShoulderToggled;									break;
			case 'ACsprint' : 	SprintCamera.IsShoulderToggled = !SprintCamera.IsShoulderToggled;									break;
			case 'ACexp' : 		ExplorationCamera.IsShoulderToggled = !ExplorationCamera.IsShoulderToggled;							break;
			case 'ACboat' :		SailingCamera.IsShoulderToggled = !SailingCamera.IsShoulderToggled;									break;
			case 'ACint' :		InteriorCamera.IsShoulderToggled = !InteriorCamera.IsShoulderToggled;								break;
		}

		if(DebugMode) { thePlayer.DisplayHudMessage("[DEBUG] (" + grpName +") Shoulder Toggled"); }

		cameraHasBeenToggled = !cameraHasBeenToggled;
	}

	private function MoveCamera(stateName : name, actionName : name)
	{
		var movAmount : float;
		movAmount = StringToFloat( gConfig.GetVarValue( 'RGTotherSettings', 'RGToffsetPerHit' ) );

		switch(stateName)
		{
			case 'ACaim' :
				if(actionName == 'plusX') { AimCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { AimCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { AimCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { AimCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { AimCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { AimCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACsign' :
				if(actionName == 'plusX') { SignsCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { SignsCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { SignsCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { SignsCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { SignsCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { SignsCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACclue' :
				if(actionName == 'plusX') { ClueCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { ClueCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { ClueCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { ClueCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { ClueCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { ClueCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACmed' :
				if(actionName == 'plusX') { MeditationCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { MeditationCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { MeditationCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { MeditationCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { MeditationCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { MeditationCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACws' :
				if(actionName == 'plusX') { WitcherSensesCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { WitcherSensesCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { WitcherSensesCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { WitcherSensesCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { WitcherSensesCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { WitcherSensesCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACwsInt' :
				if(actionName == 'plusX') { WitcherSensesInteriorCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { WitcherSensesInteriorCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { WitcherSensesInteriorCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { WitcherSensesInteriorCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { WitcherSensesInteriorCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { WitcherSensesInteriorCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACwsHorse' :
				if(actionName == 'plusX') { WitcherSensesHorseCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { WitcherSensesHorseCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { WitcherSensesHorseCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { WitcherSensesHorseCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { WitcherSensesHorseCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { WitcherSensesHorseCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACwsSwim' :
				if(actionName == 'plusX') { SwimWitcherSensesCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { SwimWitcherSensesCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { SwimWitcherSensesCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { SwimWitcherSensesCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { SwimWitcherSensesCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { SwimWitcherSensesCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACswim' :
				if(actionName == 'plusX') { SwimCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { SwimCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { SwimCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { SwimCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { SwimCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { SwimCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'AChorseCbt' :
				if(actionName == 'plusX') { HorseRidingCombatCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { HorseRidingCombatCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { HorseRidingCombatCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { HorseRidingCombatCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { HorseRidingCombatCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { HorseRidingCombatCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'AChorse' :
				if(actionName == 'plusX') { HorseRidingCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { HorseRidingCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { HorseRidingCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { HorseRidingCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { HorseRidingCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { HorseRidingCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACfist' :
				if(actionName == 'plusX') { FistCombatCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { FistCombatCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { FistCombatCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { FistCombatCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { FistCombatCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { FistCombatCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'AClck' :
				if(actionName == 'plusX') { CombatLockedCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { CombatLockedCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { CombatLockedCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { CombatLockedCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { CombatLockedCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { CombatLockedCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACcbt' :
				if(actionName == 'plusX') { CombatCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { CombatCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { CombatCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { CombatCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { CombatCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { CombatCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACsprint' :
				if(actionName == 'plusX') { SprintCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { SprintCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { SprintCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { SprintCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { SprintCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { SprintCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACexp' :
				if(actionName == 'plusX') { ExplorationCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { ExplorationCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { ExplorationCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { ExplorationCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { ExplorationCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { ExplorationCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACboat' :
				if(actionName == 'plusX') { SailingCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { SailingCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { SailingCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { SailingCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { SailingCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { SailingCamera.UnlockedPos.Z -= movAmount; }
				break;
			case 'ACint' :
				if(actionName == 'plusX') { InteriorCamera.UnlockedPos.X += movAmount; }
				else if(actionName == 'plusY') { InteriorCamera.UnlockedPos.Y += movAmount; }
				else if(actionName == 'plusZ') { InteriorCamera.UnlockedPos.Z += movAmount; }
				else if(actionName == 'minuX') { InteriorCamera.UnlockedPos.X -= movAmount; }
				else if(actionName == 'minuY') { InteriorCamera.UnlockedPos.Y -= movAmount; }
				else if(actionName == 'minuZ') { InteriorCamera.UnlockedPos.Z -= movAmount; }
				break;
		}
	}

	// Inputs
	private function ACameraSetupInputs()
	{
		theInput.RegisterListener( this, 'OnCommRGTCheckStatus', 'RGTcheckOffsets' );
		theInput.RegisterListener( this, 'OnCommACResetCamera', 'ACResetCamera' );
		theInput.RegisterListener( this, 'OnCommACToggleOnOff', 'ACToggleOnOff' );
		theInput.RegisterListener( this, 'OnCommRGTShoulderToggle', 'RGTShoulderToggle' );
		theInput.RegisterListener( this, 'OnCommRGTsaveCamera', 'RGTsaveCamera' );
		theInput.RegisterListener( this, 'OnCommRGTAddOffsetX', 'RGTAddOffsetX' );
		theInput.RegisterListener( this, 'OnCommRGTAddOffsetY', 'RGTAddOffsetY' );
		theInput.RegisterListener( this, 'OnCommRGTAddOffsetZ', 'RGTAddOffsetZ' );
		theInput.RegisterListener( this, 'OnCommRGTRemOffsetX', 'RGTRemOffsetX' );
		theInput.RegisterListener( this, 'OnCommRGTRemOffsetY', 'RGTRemOffsetY' );
		theInput.RegisterListener( this, 'OnCommRGTRemOffsetZ', 'RGTRemOffsetZ' );
	}

	event OnCommRGTCheckStatus( action:SInputAction )
	{
		if( IsPressed( action ) )
		{
			DisplayCameraInfo();
		}
	}

	event OnCommACResetCamera(action:SInputAction)
	{
		if(IsPressed(action))
		{
			if(GetIsCurrentCameraOn())
				LockCamera(GetMenuGroupName());
		}
	}

	event OnCommACToggleOnOff( action:SInputAction )
	{
		if( IsPressed( action ) )
		{
			ToggleCameraOnOff();
		}
	}

	event OnCommRGTShoulderToggle( action:SInputAction )
	{
		if(IsPressed(action))
		{
			ToggleShoulder();
		}
	}

	event OnCommRGTsaveCamera( action:SInputAction )
	{
		if( IsPressed( action ) )
		{
			if(GetIsCurrentCameraOn())
				SaveCamera();
		}
	}

	event OnCommRGTAddOffsetX( action:SInputAction )
	{
		var grpName : name;
		var camera : SACamera;
		grpName = GetMenuGroupName();
		camera = GetCameraByState(grpName);

		if(IsPressed(action))
		{
			if(camera.IsOn)
			{
				if(camera.IsLocked)
				{
					UnlockCamera(grpName);
				}

				MoveCamera(grpName, 'plusX');
			}
		}
	}

	event OnCommRGTAddOffsetY( action:SInputAction )
	{
		var grpName : name;
		var camera : SACamera;
		grpName = GetMenuGroupName();
		camera = GetCameraByState(grpName);

		if(IsPressed(action))
		{
			if(camera.IsOn)
			{
				if(camera.IsLocked)
				{
					UnlockCamera(grpName);
				}

				MoveCamera(grpName, 'plusY');
			}
		}
	}

	event OnCommRGTAddOffsetZ( action:SInputAction )
	{
		var grpName : name;
		var camera : SACamera;
		grpName = GetMenuGroupName();
		camera = GetCameraByState(grpName);

		if(IsPressed(action))
		{
			if(camera.IsOn)
			{
				if(camera.IsLocked)
				{
					UnlockCamera(grpName);
				}

				MoveCamera(grpName, 'plusZ');
			}
		}
	}

	event OnCommRGTRemOffsetX( action:SInputAction )
	{
		var grpName : name;
		var camera : SACamera;
		grpName = GetMenuGroupName();
		camera = GetCameraByState(grpName);

		if(IsPressed(action))
		{
			if(camera.IsOn)
			{
				if(camera.IsLocked)
				{
					UnlockCamera(grpName);
				}

				MoveCamera(grpName, 'minuX');
			}
		}
	}

	event OnCommRGTRemOffsetY( action:SInputAction )
	{
		var grpName : name;
		var camera : SACamera;
		grpName = GetMenuGroupName();
		camera = GetCameraByState(grpName);

		if(IsPressed(action))
		{
			if(camera.IsOn)
			{
				if(camera.IsLocked)
				{
					UnlockCamera(grpName);
				}

				MoveCamera(grpName, 'minuY');
			}
		}
	}

	event OnCommRGTRemOffsetZ( action:SInputAction )
	{
		var grpName : name;
		var camera : SACamera;
		grpName = GetMenuGroupName();
		camera = GetCameraByState(grpName);

		if(IsPressed(action))
		{
			if(camera.IsOn)
			{
				if(camera.IsLocked)
				{
					UnlockCamera(grpName);
				}

				MoveCamera(grpName, 'minuZ');
			}
		}
	}
}

function GetACameraManager() : CACameraManager
{
	return thePlayer.aCameraManager;
}