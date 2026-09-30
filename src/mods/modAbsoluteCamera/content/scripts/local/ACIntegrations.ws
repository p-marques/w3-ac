// Absolute Camera 5.x - 2026, pMarK

@addField(CR4Player)
public var aCameraManager : CACameraManager;

@wrapMethod(CR4Player)
function OnSpawned(spawnData : SEntitySpawnData)
{
    var result : bool;
    if (aCameraManager)
        aCameraManager.ResetHorseCamera();
    result = wrappedMethod(spawnData);
    aCameraManager = new CACameraManager in this;
    aCameraManager.InitAC();
    return result;
}

@wrapMethod(CR4Player)
function UpdateCameraInterior(out moveData : SCameraMovementData, timeDelta : float)
{
	if (aCameraManager && aCameraManager.GetIsCurrentCameraOn())
		return;
	wrappedMethod(moveData, timeDelta);
}

@wrapMethod(CR4Player)
function EnableSprintingCamera(flag : bool)
{
	if (aCameraManager && aCameraManager.GetIsCurrentCameraOn())
		return;
	wrappedMethod(flag);
}

@wrapMethod(CR4Player)
function UpdateCameraCombatActionButNotInCombat(out moveData : SCameraMovementData, timeDelta : float)
{
	if (aCameraManager && aCameraManager.GetStopOutOfCombatActionZoomOut())
		return;
	wrappedMethod(moveData, timeDelta);
}

@wrapMethod(CR4Player)
function OnRunLoopStart()
{
	if (aCameraManager && aCameraManager.GetStopSprintCamShake())
		return false;
	return wrappedMethod();
}

@wrapMethod(CR4Player)
function GetExplorationCameraFov() : float
{
    if (aCameraManager && aCameraManager.GetIsCurrentCameraOn())
        return aCameraManager.GetFOV();
    return wrappedMethod();
}

@wrapMethod(CCameraPivotPositionControllerJump)
function GetFollowPos() : Vector
{
    var camera : CCustomCamera;
    if (thePlayer.aCameraManager && thePlayer.aCameraManager.GetIsCurrentCameraOn())
    {
        camera = theGame.GetGameCamera();
        camera.fov = thePlayer.aCameraManager.GetFOV();
    }
    return wrappedMethod();
}

@replaceMethod(CR4Player)
function OnGameCameraTick( out moveData : SCameraMovementData, dt : float )
{
		var targetRotation	: EulerAngles;
		var dist : float;
		var camera : CCustomCamera;
		var aCamera : SACamera;
		camera = theGame.GetGameCamera();
		if (aCameraManager)
			aCamera = aCameraManager.GetCamera();

		if( thePlayer.IsInCombat() )
		{
			dist = VecDistance2D( thePlayer.GetWorldPosition(), thePlayer.GetTarget().GetWorldPosition() );
			thePlayer.GetVisualDebug().AddText( 'dbg', dist, thePlayer.GetWorldPosition() + Vector( 0.f,0.f,2.f ), true, , Color( 0, 255, 0 ) );
		}

		if ( isStartingFistFightMinigame )
		{
			moveData.pivotRotationValue = fistFightTeleportNode.GetWorldRotation();
			isStartingFistFightMinigame = false;
		}

		if( substateManager.UpdateCameraIfNeeded( moveData, dt ) )
		{
			return true;
		}

		if (aCameraManager && aCameraManager.PrepareHorseCamera(moveData))
			return true;

		if(aCamera.IsOn)
		{
			theGame.GetGameCamera().ChangePivotRotationController( 'Exploration' );
			theGame.GetGameCamera().ChangePivotDistanceController( 'Default' );
			theGame.GetGameCamera().ChangePivotPositionController( 'Default' );
			moveData.pivotRotationController = theGame.GetGameCamera().GetActivePivotRotationController();
			moveData.pivotDistanceController = theGame.GetGameCamera().GetActivePivotDistanceController();
			moveData.pivotPositionController = theGame.GetGameCamera().GetActivePivotPositionController();

			moveData.pivotPositionController.SetDesiredPosition( thePlayer.GetWorldPosition() );
			moveData.pivotDistanceController.SetDesiredDistance( 3.5f );

			if(aCameraManager.GetIsPlayerMountingHorse())
				moveData.pivotPositionController.offsetZ = 2.3f;
			else
				moveData.pivotPositionController.offsetZ = 1.3f;

			if(aCameraManager.GetPicthMode() == 1 && GetIsSprinting())
				moveData.pivotRotationController.SetDesiredPitch( aCameraManager.GetDesiredPitch() );
			else if(aCameraManager.GetPicthMode() == 2)
				moveData.pivotRotationController.SetDesiredPitch( aCameraManager.GetDesiredPitch() );

			moveData.pivotRotationController.maxPitch = aCameraManager.GetMaxPitch();
			moveData.pivotRotationController.minPitch = aCameraManager.GetMinPitch();

			if(aCameraManager.GetAutoCenterMode() == 1 && GetIsSprinting())
				moveData.pivotRotationController.SetDesiredHeading(GetHeading());
			else if(aCameraManager.GetAutoCenterMode() == 2)
				moveData.pivotRotationController.SetDesiredHeading(GetHeading());

			DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector(aCamera.PosX, aCamera.PosY, aCamera.PosZ), 0.5f, dt );

			camera.fov = aCameraManager.GetFOV();

			return true;
		}

		if ( theGame.IsFocusModeActive() )
		{

			if( GetExplCamera() || IsModernExplorationCamera() )
			{

				return true;
			}

			theGame.GetGameCamera().ChangePivotRotationController( 'Exploration' );
			theGame.GetGameCamera().ChangePivotDistanceController( 'Default' );
			theGame.GetGameCamera().ChangePivotPositionController( 'Default' );

			moveData.pivotRotationController = theGame.GetGameCamera().GetActivePivotRotationController();
			moveData.pivotDistanceController = theGame.GetGameCamera().GetActivePivotDistanceController();
			moveData.pivotPositionController = theGame.GetGameCamera().GetActivePivotPositionController();

			moveData.pivotPositionController.SetDesiredPosition( thePlayer.GetWorldPosition() );

			moveData.pivotRotationController.SetDesiredPitch( -10.0f );
			moveData.pivotRotationController.maxPitch = 50.0;

			moveData.pivotDistanceController.SetDesiredDistance( 3.5f );

			if ( !interiorCamera )
			{
				moveData.pivotPositionController.offsetZ = 1.5f;
				DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.5f, 2.0f, 0.3f ), 0.20f, dt );
			}
			else
			{
				moveData.pivotPositionController.offsetZ = 1.3f;
				DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.5f, 2.3f, 0.5f ), 0.3f, dt );
			}

			return true;
		}

		if( customCameraStack.Size() > 0 )
		{

		}

		return false;
	}

@replaceMethod(CR4PlayerStateAimThrow)
function OnGameCameraTick( out moveData : SCameraMovementData, dt : float )
{
		var aCamera : SACamera;
		var cameraOffset : float;
		var currRotation : EulerAngles;
		var angledist : float;
		var rawToCamHeadingDiff	: float;
		var camOffsetVec 	: Vector;
		var heading			: float;
		var followPosition : Vector;

		var enableAimingLookAt : bool;

		if (parent.aCameraManager)
			aCamera = parent.aCameraManager.GetCamera();

		theGame.GetGameCamera().ChangePivotRotationController( 'AimThrow' );
		theGame.GetGameCamera().ChangePivotPositionController( 'Default' );

			theGame.GetGameCamera().ChangePivotDistanceController( 'AimThrow' );

		moveData.pivotRotationController = theGame.GetGameCamera().GetActivePivotRotationController();
		moveData.pivotDistanceController = theGame.GetGameCamera().GetActivePivotDistanceController();
		moveData.pivotPositionController = theGame.GetGameCamera().GetActivePivotPositionController();

		moveData.pivotPositionController.SetDesiredPosition( virtual_parent.GetWorldPosition(), 100.f );

		if(aCamera.IsOn)
		{
			DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector(aCamera.PosX, aCamera.PosY, aCamera.PosZ), 0.5f, dt );

			return true;
		}

		if ( parent.inv.IsItemRangedWeapon( parent.GetSelectedItemId() ) )
		{

			if ( parent.GetPlayerCombatStance() == PCS_AlertNear )
				followTarget = false;

			rawToCamHeadingDiff = AngleDistance( parent.rawPlayerHeading, moveData.pivotRotationValue.Yaw );

			if ( !parent.bLAxisReleased )

			{
				if ( rawToCamHeadingDiff > -45 && rawToCamHeadingDiff < 45 )
				{

					camOffsetVec.X = 0.5f;
					camOffsetVec.Y = 0.5f;
					camOffsetVec.Z = 0.18f;

				}
				else if ( rawToCamHeadingDiff >= 45 && rawToCamHeadingDiff < 135 )
				{

					camOffsetVec.X = 0.55f;
					camOffsetVec.Y = 0.55f;
					camOffsetVec.Z = 0.15f;

				}
				else if ( rawToCamHeadingDiff <= -45 && rawToCamHeadingDiff > -135 )
				{

					camOffsetVec.X = 0.55f;
					camOffsetVec.Y = 0.45f;
					camOffsetVec.Z = 0.18f;

				}
				else
				{

					camOffsetVec.X = 0.55f;
					camOffsetVec.Y = 0.6f;
					camOffsetVec.Z = 0.2f;

				}
			}
			else
			{

				camOffsetVec.X = 0.43f;
				camOffsetVec.Y = 0.52f;
				camOffsetVec.Z = 0.22f;

			}

			if ( parent.rangedWeapon && parent.rangedWeapon.GetCurrentStateName() == 'State_WeaponReload' )
			{

				camOffsetVec.X = 0.43f;
				camOffsetVec.Y = 0.1f;
				camOffsetVec.Z = 0.22f;

			}

			DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( camOffsetVec.X, camOffsetVec.Y, camOffsetVec.Z ), 0.2f, dt );

			{
				virtual_parent.oTCameraOffset = 17.f;
				virtual_parent.oTCameraPitchOffset = 5.f;
			}

			{
				heading = VecHeading(theCamera.GetCameraDirection());
				angledist = AngleDistance( heading, VecHeading(thePlayer.GetHeadingVector()) );

				if ( angledist < -50 || angledist > 25 )
				{
					isRotating = true;
					parent.SetCustomRotation( 'Crossbow', heading, 0.0f, 0.4f, false );

					if ( parent.bLAxisReleased )
					{
						thePlayer.SetBehaviorVariable( 'playerSpeedForOverlay', 0.1);
						thePlayer.SetBehaviorVariable( 'walkInPlace', 1.f );
					}
				}
				else if ( isRotating && ( angledist < -35 || angledist > 5 ) )
				{
					parent.SetCustomRotation( 'Crossbow', heading, 0.0f, 0.4f, false );

					if ( parent.bLAxisReleased )
					{
						thePlayer.SetBehaviorVariable( 'playerSpeedForOverlay', 0.1);
						thePlayer.SetBehaviorVariable( 'walkInPlace', 1.f );
					}
				}
				else
				{
					thePlayer.SetBehaviorVariable( 'walkInPlace', 0.f );
					isRotating = false;
				}
			}

		}

		else
		{
			virtual_parent.oTCameraOffset = 32.f;
			virtual_parent.oTCameraPitchOffset = 0.f;
			initialPitch = -15.f;

			heading = VecHeading(theCamera.GetCameraDirection());
			angledist = AngleDistance( heading, VecHeading(thePlayer.GetHeadingVector()) );

			if ( moveData.pivotRotationValue.Pitch < -20 )
				enableAimingLookAt =  false;

			if ( enableAimingLookAt )
				parent.SetBehaviorVariable( 'enableAimingLookAt', 1.f );
			else
				parent.SetBehaviorVariable( 'enableAimingLookAt', 0.f );

			if ( moveData.pivotRotationValue.Pitch < -20 )
			{
				parent.SetCustomRotation( 'BombThrow', heading-45, 0.0f, 0.1f, false );
			}
			else if ( isRotating || ( angledist < 30 || angledist > 60 ) )
			{
				isRotating = true;
				parent.SetCustomRotation( 'BombThrow', heading-45, 0.0f, 0.4f, false );
				parent.SetBehaviorVariable( 'enableAimingLookAt', 1.f );
			}

			if ( angledist > 40 && angledist < 50 )
				isRotating = false;

			camOffsetVec.X = ( ( ( -20 - moveData.pivotRotationValue.Pitch )/100 ) - 0.85 ) * -1;
			camOffsetVec.X = ClampF( camOffsetVec.X, 0.65f, 0.85f );
			camOffsetVec.Y = ( ( ( -20 - moveData.pivotRotationValue.Pitch )/-8 ) - 0.5 ) * -1;
			camOffsetVec.Y = ClampF( camOffsetVec.Y, 0.5f, 0.9f );
			camOffsetVec.Z = ( ( ( -20 - moveData.pivotRotationValue.Pitch )/-74.07 ) ) * -1;
			camOffsetVec.Z = ClampF( camOffsetVec.Z, 0.f, 0.27f );
		}

		if ( parent.GetDisplayTarget() )
			followPosition = GetAimPosition();

		if ( !( parent.GetPlayerCombatStance() == PCS_AlertNear && virtual_parent.delayOrientationChange ) || !parent.bRAxisReleased )
		{
			currRotation = VecToRotation( theCamera.GetCameraDirection() );
			moveData.pivotRotationController.SetDesiredPitch( moveData.pivotRotationValue.Pitch, 3.f );
		}
		else
			moveData.pivotRotationController.SetDesiredPitch( initialPitch, 3.f );

		if ( virtual_parent.delayOrientationChange )
		{
			if ( parent.GetPlayerCombatStance() == PCS_AlertNear && parent.GetDisplayTarget() )
				moveData.pivotRotationController.SetDesiredHeading( VecHeading( followPosition - theCamera.GetCameraPosition() ), 1.f );
			else
				moveData.pivotRotationController.SetDesiredHeading( moveData.pivotRotationValue.Yaw, 1.f );
		}
		else if ( thePlayer.bRAxisReleased && parent.GetDisplayTarget() && followTarget )
		{
			moveData.pivotRotationController.SetDesiredHeading( VecHeading( followPosition - theCamera.GetCameraPosition() ), 1.f );

			moveData.pivotRotationController.SetDesiredPitch( ProcessInitialPitch(), 1.f );

		}
		else
			moveData.pivotRotationController.SetDesiredHeading( moveData.pivotRotationValue.Yaw, 1.f );

		moveData.pivotDistanceController.SetDesiredDistance( 1.f );

		moveData.pivotPositionController.offsetZ = 1.5f;

		DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( camOffsetVec.X, camOffsetVec.Y, camOffsetVec.Z ), 0.2f, dt );

		return true;
	}

@replaceMethod(CR4PlayerStateExploration)
function OnGameCameraPostTick( out moveData : SCameraMovementData, dt : float )
{
		var acEnabled : bool;
		var buff : CBaseGameplayEffect;
		var angles	: EulerAngles;

		var playerVel : float;
		var tempVel	: float;

		var pos : Vector;
		var sprintingAngle : float;
		var encumberOffset : Vector;

		var dbgXOffset : float;
		var dbgYOffset : float;
		var dbgZOffset : float;
		var distVec : Vector;

		var dbgFov : float;
		var dbgPitch : float;

		var camera : CCustomCamera;
		var boneId : int;
		var bonePos : Vector;

		var jumpState : CExplorationStateJump;
		var jumpParams : SJumpParams;

		var jumpCamSmoothAlgo : int;
		var jumpUpTimeCoef : float;
		var isCiri : bool;

		var forceSlowSetPosMult : bool;
		var setPosMultToUse : float;
		var currentExplSubstate : name;
		var climbState : CExplorationStateClimb;

		acEnabled = parent.aCameraManager && parent.aCameraManager.GetIsCurrentCameraOn();

		lerpAmount += dt/2;
		lerpAmountModern += dt * lerpAmountModernCoef;
		DampFloatSpring( currentSetPosMult, setPosVel, 15.f, setPosMultSmoothTime, dt );
		if(cachedMoveType != parent.playerMoveType )
		{
			lerpAmount = 0;
		}
		if(cachedFocusMode != theGame.IsFocusModeActive() )
		{
			lerpAmount = 0.f;
			ResetModernCameraOffset( 2.f );
		}
		lerpAmount = ClampF(lerpAmount,0,1);
		lerpAmountModern = ClampF(lerpAmountModern,0,1);
		cachedMoveType = parent.playerMoveType;
		cachedFocusMode = theGame.IsFocusModeActive();
		cachedSprint = sprintLeft;

		if ( !constDamper )
		{
			constDamper = new ConstDamper in this;
			constDamper.SetDamp( 1.f );
		}

		if( parent.rangedWeapon && parent.rangedWeapon.GetCurrentStateName() != 'State_WeaponWait' )
		{
			moveData.pivotRotationController.SetDesiredHeading( moveData.pivotRotationValue.Yaw );
		}

		buff = parent.GetCurrentlyAnimatedCS();

		if ( ( parent.IsInCombatAction() || buff ) && !parent.IsInCombat() )
			parent.UpdateCameraCombatActionButNotInCombat( moveData, dt );

		playerVel = VecDistance( cachedPos, parent.GetWorldPosition() ) / dt ;
		cachedPos = parent.GetWorldPosition();

		if ( parent.rawPlayerSpeed <= 0 )
			constDamper.Reset();

		playerVel = constDamper.UpdateAndGet( dt, playerVel );

		if ( ( playerVel < 0.5f || parent.rawPlayerSpeed <= 0 ) && !parent.IsInCombatAction() )
		{
			moveData.pivotRotationController.SetDesiredHeading( moveData.pivotRotationValue.Yaw );
			moveData.pivotRotationController.SetDesiredPitch( moveData.pivotRotationValue.Pitch );
		}

		if ( parent.playerMoveType >= PMT_Run && parent.movementLockType == PMLT_Free && !acEnabled )
		{
			moveData.pivotDistanceController.SetDesiredDistance( 2.85f, 0.5 );

			angles = VecToRotation( parent.GetMovingAgentComponent().GetVelocity() );

			if ( AbsF( angles.Pitch ) < 5.f )
				moveData.pivotRotationController.SetDesiredPitch( -9.2f );

			DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, moveData.cameraLocalSpaceOffset + Vector(0,0,-0.15f), 1.f, dt);
		}

		if ( parent.IsModernExplorationCamera() || parent.GetExplCamera() )
		{
			currentExplSubstate = parent.substateManager.GetStateCur();

			if ( currentExplSubstate == 'Climb' )
			{
				climbState = (CExplorationStateClimb) parent.substateManager.GetStateByName( 'Climb' );
				if ( climbState )
				{
					cachedClimbHeightType = climbState.GetCurrentClimbHeightType();

					forceSlowSetPosMult = cachedClimbHeightType != ECHT_Step;
				}
			}

			if ( cachedExplSubstate == 'Climb' && cachedClimbHeightType != ECHT_Step && cachedExplSubstate != currentExplSubstate )
			{
				if ( parent.IsModernExplorationCamera() )
					ResetExplCameraSetPosMult( 3.f );
				else
					ResetExplCameraSetPosMult( 2.f );
			}
			cachedExplSubstate = currentExplSubstate;

			setPosMultToUse = !forceSlowSetPosMult ? currentSetPosMult : 0.5f;
		}

		if(!acEnabled && parent.GetExplCamera())
		{

			pos = parent.GetWorldPosition();

			moveData.pivotPositionController.SetDesiredPosition( pos, setPosMultToUse );
			moveData.pivotDistanceController.SetDesiredDistance( 1.5f );

			moveData.pivotPositionController.offsetZ = 1.15f;

			if(cachedEncumber != parent.HasBuff(EET_OverEncumbered))
			{
				lerpAmount = 0;
			}
			cachedEncumber = parent.HasBuff(EET_OverEncumbered);
			if(cachedEncumber)
				encumberOffset = Vector(-0.1,0.3,0);

			if( false && parent.climbingCam && parent.substateManager.GetStateCur() == 'Climb' )
			{
				theGame.GetGameCamera().ChangePivotPositionController('NGE_Climb');
				theGame.GetGameCamera().ChangePivotDistanceController('ExplorationInterior');

				moveData.pivotDistanceController = theGame.GetGameCamera().GetActivePivotDistanceController();
				moveData.pivotPositionController = theGame.GetGameCamera().GetActivePivotPositionController();

				DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.7f, -0.7f , 0.3f ), 0.5f, dt );
			}
			else
			{
				if(thePlayer.IsCiri())
				{
					if(cachedMoveType == PMT_Sprint)
					{
						sprintingAngle = AngleDistance(parent.GetHeading(), theCamera.GetCameraHeading());
						if(sprintingAngle > 20)
						{
							sprintLeft = true;
						}
						else if(sprintLeft && sprintingAngle > 10)
						{
							sprintLeft = true;
						}
						else
							sprintLeft = false;

						if(cachedSprint != sprintLeft)
							lerpAmount = 0;

						if(sprintLeft && theInput.LastUsedGamepad())
							moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, ciriSprintRV, lerpAmount);
						else
							moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, ciriSprintLV, lerpAmount);
					}
					else if(cachedMoveType == PMT_Run)
					{
						moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, ciriRunV, lerpAmount);
						moveData.cameraLocalSpaceOffsetVel = Vector(0,0,0);
						sprintLeft = false;
					}
					else
					{
						moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, ciriIdleV, lerpAmount);
						moveData.cameraLocalSpaceOffsetVel = Vector(0,0,0);
						sprintLeft = false;
					}
				}
				else
				{
					if(cachedMoveType == PMT_Sprint)
					{
						sprintingAngle = AngleDistance(parent.GetHeading(), theCamera.GetCameraHeading());
						if(sprintingAngle > 20)
						{
							sprintLeft = true;
						}
						else if(sprintLeft && sprintingAngle > 10)
						{
							sprintLeft = true;
						}
						else
							sprintLeft = false;

						if(cachedSprint != sprintLeft)
							lerpAmount = 0;

						if(sprintLeft && theInput.LastUsedGamepad())
						{
							moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, geraltSprintRV, lerpAmount);
						}
						else
						{
							moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, geraltSprintLV, lerpAmount);
						}

						moveData.cameraLocalSpaceOffsetVel = Vector(0,0,0);
					}
					else if(cachedMoveType == PMT_Run)
					{
						if ( cachedFocusMode )
							moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, geraltFocusV, lerpAmount);
						else
							moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, geraltRunV, lerpAmount);
						moveData.cameraLocalSpaceOffsetVel = Vector(0,0,0);
						sprintLeft = false;
					}
					else
					{

						if ( cachedFocusMode )
							moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, geraltFocusV, lerpAmount);
						else
							moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, geraltIdleV + encumberOffset, lerpAmount);

						moveData.cameraLocalSpaceOffsetVel = Vector(0,0,0);
						sprintLeft = false;
					}
				}

				if(thePlayer.IsInAir())
					DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.0f, 0.0f, 0.5f ), 1.0f, dt );
			}
		}

		else if ( !acEnabled && parent.IsModernExplorationCamera() )
		{
			if ( thePlayer.BehaviorNodeActivationNotificationReceived( 'RunQuickTurnStart' ) )
			{
				ResetExplCameraSetPosMult( 3.f );
			}

			isCiri = thePlayer.IsCiri();
			pos = parent.GetWorldPosition();
			boneId = parent.GetTorsoBoneIndex();

			if ( !isCiri && boneId > 0 )
			{
				bonePos = MatrixGetTranslation( parent.GetBoneWorldMatrixByIndex( boneId ) );
				bonePos.Z = pos.Z;
				moveData.pivotPositionController.SetDesiredPosition( bonePos, setPosMultToUse );
			}
			else
			{
				moveData.pivotPositionController.SetDesiredPosition( pos, setPosMultToUse );
			}

			dbgXOffset = StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue( 'RemasterCombat', 'ExplCamXOffset' ) );
			dbgYOffset = StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue( 'RemasterCombat', 'ExplCamYOffset' ) );
			dbgZOffset = StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue( 'RemasterCombat', 'ExplCamZOffset' ) );

			moveData.pivotDistanceController.SetDesiredDistance( 1.85f, 0.5f );

			distVec = Vector( dbgXOffset, dbgYOffset, dbgZOffset );

			if ( theGame.IsFocusModeActive() )
			{
				distVec.Y = 0.4f;
				distVec.X += 0.2f;
			}

			if ( !isCiri && currentExplSubstate == 'Jump' )
			{
				jumpState = (CExplorationStateJump) parent.substateManager.GetStateByName( 'Jump' );
				if ( jumpState )
				{
					if ( jumpState.GetCurrentSubstate() == JSS_TakingOff )
					{
						if ( jumpState.GetCurrentSubstate() != cachedJumpSubstate )
						{
							jumpParams = jumpState.GetCurrentJumpParams();

							jumpUpTimeCoef = StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue( 'RemasterCombat', 'ExplCamJumpUpTimeCoef' ) );
							if ( jumpUpTimeCoef <= 0 )
								jumpUpTimeCoef = 1.f;

							jumpCameraUpTimeSet = jumpParams.m_TakeOffTimeF * jumpUpTimeCoef;
							ResetModernCameraOffset( 1.f / jumpCameraUpTimeSet );
							jumpStartTime = theGame.GetEngineTimeAsSeconds();
							jumpCameraActive = true;
						}
					}
				}

				cachedJumpSubstate = jumpState.GetCurrentSubstate();
			}

			if ( jumpCameraActive && jumpStartTime + jumpCameraUpTimeSet <= theGame.GetEngineTimeAsSeconds() )
			{
				jumpCameraActive = false;
				ResetModernCameraOffset( StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue( 'RemasterCombat', 'ExplCamJumpDtCoefDown' ) ) );
			}

			if ( jumpCameraActive )
			{
				distVec.Z += StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue( 'RemasterCombat', 'ExplCamJumpZ' ) );
			}

			if ( !isModernCameraOffsetSet )
			{
				modernCameraOffsetAtStart = moveData.cameraLocalSpaceOffset;
				isModernCameraOffsetSet = true;
			}

			moveData.cameraLocalSpaceOffset.X = LerpF( lerpAmountModern, modernCameraOffsetAtStart.X, distVec.X );
			moveData.cameraLocalSpaceOffset.Y = LerpF( lerpAmountModern, modernCameraOffsetAtStart.Y, distVec.Y );

			jumpCamSmoothAlgo = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue( 'RemasterCombat', 'ExplCamJumpSmoothAlgo' ) );

			if ( jumpCamSmoothAlgo == 0 )
				moveData.cameraLocalSpaceOffset.Z = LerpF( lerpAmountModern, modernCameraOffsetAtStart.Z, distVec.Z );
			else if ( jumpCamSmoothAlgo == 1 )
				moveData.cameraLocalSpaceOffset.Z = SmoothstepF( lerpAmountModern, modernCameraOffsetAtStart.Z, distVec.Z );
			else if ( jumpCamSmoothAlgo == 2 )
				moveData.cameraLocalSpaceOffset.Z = SmootherstepF( lerpAmountModern, modernCameraOffsetAtStart.Z, distVec.Z );

			dbgFov = StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue( 'RemasterCombat', 'ExplCamFov' ) );
			if ( dbgFov <= 0 )
				dbgFov = 60;

			camera = theGame.GetGameCamera();
			if ( camera && camera.GetFov() != dbgFov )
			{
				DampFloatSpring( camera.fov, fovVel, dbgFov, 1.0, dt );
			}

			dbgPitch = StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue( 'RemasterCombat', 'ExplCamPitch' ) );
			moveData.pivotRotationController.SetDesiredPitch( dbgPitch );
		}

		else
		{
			lerpAmount = 0;
			lerpAmountModern = 0.f;
			parent.UpdateCameraSprint( moveData, dt );
		}

		super.OnGameCameraPostTick( moveData, dt );
	}

@replaceMethod(CR4PlayerStateSwimming)
function OnGameCameraPostTick( out moveData : SCameraMovementData, dt : float )
{
		var aCamera : SACamera;
		var cameraRotation : EulerAngles;
		var cameraPosition : Vector;
		var waterLevel : float;
		var diff : float;

		var divePitch : float;
		var angleDistBetweenPlayerAndCamera : float;
		var playerToTargetVector : Vector;
		var playerToTargetAngles : EulerAngles;
		var playerToTargetPitch : float;

		if (parent.aCameraManager)
			aCamera = parent.aCameraManager.GetCamera();

		lerpAmount += dt/2;
		lerpAmount = ClampF(lerpAmount,0,1);

		cameraPosition = theCamera.GetCameraPosition();
		waterLevel = theGame.GetWorld().GetWaterLevel(cameraPosition, true);
		diff = cameraPosition.Z - waterLevel;

		UpdateDivingPitch();

		if ( cameraIsUnderwater && diff >= 0 )
		{
			parent.PlayEffect('water_effect_surfacing');
			cameraIsUnderwater = false;
			theSound.SoundEvent("fx_underwater_off");
		}
		else if ( !cameraIsUnderwater && diff < 0 )
		{
			cameraIsUnderwater = true;
			theSound.SoundEvent("fx_underwater_on");
		}

		{
			cameraRotation = theCamera.GetCameraRotation();
			cameraPitch = AngleNormalize180(cameraRotation.Pitch);

			angleDistBetweenPlayerAndCamera = AbsF(AngleDistance(parent.GetHeading(),VecHeading(theCamera.GetCameraDirection())));

			if ( ( cameraPitch < 0 && !OnAllowedDiveDown() ) || angleDistBetweenPlayerAndCamera > 135 )
				parent.SetBehaviorVariable( 'cameraPitch', 0.f);
			else
				parent.SetBehaviorVariable( 'cameraPitch', cameraPitch);
		}

		if ( parent.IsCameraLockedToTarget() )
		{
			playerToTargetVector = parent.GetDisplayTarget().GetWorldPosition() - parent.GetWorldPosition();

			moveData.pivotRotationController.SetDesiredHeading( VecHeading( playerToTargetVector ), 0.5f );

			playerToTargetAngles = VecToRotation( playerToTargetVector );
			playerToTargetPitch = playerToTargetAngles.Pitch + 10;
			moveData.pivotRotationController.SetDesiredPitch( playerToTargetPitch * -1, 0.5f );
		}
		else if ( moveData.pivotRotationController.controllerName == 'Diving' )
		{
			divePitch = parent.GetBehaviorVariable('divePitch');

			if ( divePitch <= -1.f )
			{
				moveData.pivotRotationController.SetDesiredPitch(-89.f);
				moveData.pivotRotationController.minPitch = -80.f;
				moveData.pivotRotationController.maxPitch = -60.f;
			}
			else if ( divePitch >= 1.f )
			{
				moveData.pivotRotationController.SetDesiredPitch(89.f);
				moveData.pivotRotationController.maxPitch = 80.f;
				moveData.pivotRotationController.minPitch = 60.f;
			}
			else
			{
				if ( !thePlayer.GetIsSprinting() )
					moveData.pivotRotationController.SetDesiredPitch(0.0);

				if ( isCiri )
				{
					moveData.pivotRotationController.minPitch = -45.f;
					moveData.pivotRotationController.maxPitch = 45.f;
				}
				else
				{
					moveData.pivotRotationController.minPitch = -70.f;
					moveData.pivotRotationController.maxPitch = 70.f;
				}
			}

		}
		else if ( divingEnd )
		{

			moveData.pivotRotationController.SetDesiredPitch(-10.0, 3.f);
			theGame.GetGameCamera().ForceManualControlHorTimeout();
		}
		else if ( moveData.pivotRotationController.controllerName == 'Swimming' )
		{
			moveData.pivotRotationController.SetDesiredPitch(-10.0);
		}

		if ( moveData.pivotPositionController.controllerName == 'Diving' )
		{
			if ( parent.rawPlayerSpeed == 0 )
			{
				moveData.pivotPositionController.offsetZ = 1.75f;
			}
			else
			{
				moveData.pivotPositionController.offsetZ = 1.15f;
			}
		}
		if ( theGame.IsFocusModeActive() )
		{

			moveData.pivotRotationController.SetDesiredHeading(VecHeading(theCamera.GetCameraDirection()));
			if(!parent.GetExplCamera())
			{
				DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.4f, 0.5f, -0.15f ), 0.40f, dt );
			}
		}

		else if ( moveData.pivotDistanceController.controllerName == 'Diving' )
		{
			if ( cameraPitch < 0 && diff >= -0.25 )
			{
				moveData.pivotDistanceController.SetDesiredDistance(0);
			}
			else if ( parent.rawPlayerSpeed == 0 )
			{
				moveData.pivotDistanceController.SetDesiredDistance(2.25);
			}
			else
			{
				moveData.pivotDistanceController.SetDesiredDistance(2.75);
			}
		}

		if(parent.GetExplCamera() && !aCamera.IsOn)
		{
			moveData.pivotPositionController.SetDesiredPosition( parent.GetWorldPosition(), 15.f );
			moveData.pivotDistanceController.SetDesiredDistance( 2.25f );

			moveData.pivotPositionController.offsetZ = 1.15f;

			moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, Vector(0.74,-0.38,0.345), lerpAmount);
			moveData.cameraLocalSpaceOffsetVel = Vector(0,0,0);
		}

		if(aCamera.IsOn)
		{
			moveData.pivotPositionController.SetDesiredPosition( parent.GetWorldPosition() );
			moveData.pivotDistanceController.SetDesiredDistance( 3.5f );

			DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector(aCamera.PosX, aCamera.PosY, aCamera.PosZ), 0.5f, dt );

			return true;
		}

		super.OnGameCameraPostTick( moveData, dt );
	}

@replaceMethod(CR4PlayerStateHorseRiding)
function OnGameCameraPostTick( out moveData : SCameraMovementData, dt : float )
{
		var aCamera : SACamera;
		var camera 					: CCustomCamera;
		var horseSpeed				: float;
		var horseComp				: W3HorseComponent;
		var shouldStopCamera		: bool;
		var angleDistanceBetweenCameraAndHorse : float;

		var mult : float;
		var sprintingAngle : float;

		var didTrace : bool;

		var camParams : SCamDistConfig;

		if (parent.aCameraManager)
			aCamera = parent.aCameraManager.GetCamera();

		if (parent.aCameraManager)
			parent.aCameraManager.PrepareHorseCamera(moveData);

		if ( isCarriage )
			camParams = camDistConfig_cart;
		else
			camParams = camDistConfig_horse;

		if ( !parent.IsAlive() )
		{
			moveData.pivotDistanceController.SetDesiredDistance( 4.0 );
			moveData.pivotPositionController.SetDesiredPosition( parent.GetWorldPosition() );

			return true;
		}

		camera = (CCustomCamera)theCamera.GetTopmostCameraObject();

		if ( super.OnGameCameraPostTick( moveData, dt ) )
		{
			if ( parent.IsCameraLockedToTarget() )
			{
				moveData.pivotDistanceController.SetDesiredDistance( 3.5f, 3.f );
				currDesiredDist = 3.5f;
			}
			else
			{
				moveData.pivotDistanceController.SetDesiredDistance( 2.2f, 3.f );
				currDesiredDist = 2.2f;
			}
			return true;
		}

		horseComp = (W3HorseComponent)vehicle;

		if (parent.aCameraManager && parent.aCameraManager.ApplyHorseCamera(moveData, dt, horseComp.inGallop || horseComp.inCanter))
			return true;

		if(aCamera.IsOn)
		{
			moveData.pivotPositionController.SetDesiredPosition( parent.GetWorldPosition() );
			moveData.pivotDistanceController.SetDesiredDistance( 3.5f );

			if(parent.aCameraManager.GetPicthMode() == 1 && (horseComp.inGallop || horseComp.inCanter))
				moveData.pivotRotationController.SetDesiredPitch( parent.aCameraManager.GetDesiredPitch() );
			else if(parent.aCameraManager.GetPicthMode() == 2)
				moveData.pivotRotationController.SetDesiredPitch( parent.aCameraManager.GetDesiredPitch() );
			else
				camera.SetAllowAutoRotation( false );

			moveData.pivotRotationController.maxPitch = parent.aCameraManager.GetMaxPitch();
			moveData.pivotRotationController.minPitch = parent.aCameraManager.GetMinPitch();

			if(parent.aCameraManager.GetAutoCenterMode() == 1 && (horseComp.inGallop || horseComp.inCanter))
				moveData.pivotRotationController.SetDesiredHeading(parent.GetHeading());
			else if(parent.aCameraManager.GetAutoCenterMode() == 2)
				moveData.pivotRotationController.SetDesiredHeading(parent.GetHeading());

			DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector(aCamera.PosX, aCamera.PosY, aCamera.PosZ), 0.5f, dt );

			camera.fov = parent.aCameraManager.GetFOV();

			return true;
		}

		if ( vehicleCombatMgr.IsInSwordAttackCombatAction() )
		{
			moveData.pivotDistanceController.SetDesiredDistance( 5.4f );
			currDesiredDist = 5.4;
		}
		else if ( !horseComp.inCanter && !horseComp.inGallop && !horseComp.OnCheckHorseJump() )
		{
			moveData.pivotDistanceController.SetDesiredDistance( camParams.far_default );
			currDesiredDist = camParams.far_default;
			if ( !parent.IsModernExplorationCamera() )
				DampFloatSpring( camera.fov, fovVel, camParams.fov_default, 1.0, dt );

			CalculateCurrentPitch(horseComp);
			didTrace = true;

			if ( !horseComp.OnCheckHorseJump() )
				moveData.pivotRotationController.SetDesiredPitch( currentPitch - 10 );
		}
		else if ( horseComp.inCanter && !horseComp.OnCheckHorseJump() )
		{
			moveData.pivotDistanceController.SetDesiredDistance( camParams.far_canter );
			currDesiredDist = camParams.far_canter;
			if ( !parent.IsModernExplorationCamera() )
				DampFloatSpring( camera.fov, fovVel, camParams.fov_canter, 1.0, dt );
		}
		else if ( horseComp.inGallop && !horseComp.OnCheckHorseJump() )
		{
			moveData.pivotDistanceController.SetDesiredDistance( camParams.far_gallop );
			currDesiredDist = camParams.far_gallop;
			if ( !parent.IsModernExplorationCamera() )
				DampFloatSpring( camera.fov, fovVel, camParams.fov_gallop, 1.0, dt );
		}

		if ( horseComp.OnCheckHorseJump() )
		{
			moveData.pivotDistanceController.SetDesiredDistance( currDesiredDist );
		}
		else
		{

			if(!didTrace)
				CalculateCurrentPitch(horseComp);

			moveData.pivotRotationController.SetDesiredPitch( currentPitch - 10 );
		}

		if ( vehicleCombatMgr.IsInSwordAttackCombatAction() || horseComp.inCanter )
		{
			shouldStopCamera = false;
		}
		else
			shouldStopCamera = false;

		if(parent.GetHorseCamera())
		{
			moveData.pivotDistanceController.SetDesiredDistance( 1.5f );
			moveData.pivotPositionController.offsetZ = 2.2f;

			sprintingAngle = AngleDistance(parent.GetHeading(), theCamera.GetCameraHeading());
			if(sprintingAngle > 8)
			{
				sprintLeft = true;
			}
			else if(sprintLeft && sprintingAngle > 7)
			{
				sprintLeft = true;
			}
			else
				sprintLeft = false;

			if(horseComp.inCanter)
			{
				mult = AbsF( sprintingAngle );
				mult = mult/180;
				mult = SqrF(mult) * -1;

				if(sprintLeft && theInput.LastUsedGamepad())
					DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.3f, camParams.close_canter + mult, 0.0f ), 0.7f, dt );
				else
					DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.8f, camParams.close_canter + mult, 0.0f ), 0.7f, dt );
			}
			else if(horseComp.inGallop)
			{
				if(sprintLeft && theInput.LastUsedGamepad())
					DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.3f, camParams.close_gallop, 0.1f ), 1.0f, dt );
				else
					DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.8f, camParams.close_gallop, 0.1f ), 1.0f, dt );
			}
			else
			{
				mult = AbsF( AngleDistance(camera.GetHeading(), thePlayer.GetHeading()) );
				mult = mult/180;
				mult = SqrF(mult) * -1;

				DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.8f, camParams.close_default + mult, 0.1f ), 1.0f, dt );
				sprintLeft = false;
			}
		}
		else

			DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector(0,0,0), 1.3f, dt );

		if( horseComp.cameraMode == 1 )
		{
			if( !camera.IsManualControledHor() && horseComp.inputApplied )
			{
				if( !horseComp.inCanter && !horseComp.inGallop && !vehicleCombatMgr.IsInSwordAttackCombatAction() )
				{
					if( trailCameraTimeStamp + trailCameraCooldown > theGame.GetEngineTimeAsSeconds() )
					{
						parent.OnGameCameraPostTick( moveData, dt );
						return shouldStopCamera;
					}
					else if( trailCameraTimeStamp + trailCameraCooldown < theGame.GetEngineTimeAsSeconds() && wasTrailCameraActive )
					{
						moveData.pivotRotationVelocity.Yaw = 0.0;
						wasTrailCameraActive = false;
					}

					angleDistanceBetweenCameraAndHorse = AbsF( AngleDistance( VecHeading( theCamera.GetCameraDirection() ), parent.GetHeading() ) );

					if( angleDistanceBetweenCameraAndHorse < 30.0 )
						moveData.pivotRotationController.SetDesiredHeading( parent.GetHeading(), 0.5 );
					else if( angleDistanceBetweenCameraAndHorse < 90.0 )
						moveData.pivotRotationController.SetDesiredHeading( parent.GetHeading(), 0.35 );
					else
						moveData.pivotRotationController.SetDesiredHeading( parent.GetHeading(), 0.2 );

					parent.OnGameCameraPostTick( moveData, dt );
					return true;
				}
				else
				{
					wasTrailCameraActive = true;
					trailCameraTimeStamp = theGame.GetEngineTimeAsSeconds();
				}
			}
			else
			{
				if( wasTrailCameraActive )
				{
					moveData.pivotRotationVelocity.Yaw = 0.0;
					wasTrailCameraActive = false;
				}
			}
		}

		parent.OnGameCameraPostTick( moveData, dt );

		return shouldStopCamera;
	}

@replaceMethod(CR4PlayerStateSailing)
function OnGameCameraTick( out moveData : SCameraMovementData, dt : float )
{
		var turnFactor  : float;
		var velocityRatio : float;
		var sailCameraOffset : float;

		var fovDistPitch : Vector;
		var offsetZ : float;
		var offsetUp : Vector;
		var sailOffset : float;
		var boatComponent: CBoatComponent;

		var boatPPC : CCustomCameraBoatPPC;
		var cameraToBoatDot : float;
		var turnFactorSum : float;

		var camera : CCustomCamera;
		var angleDist : float;

		parent.UpdateLookAtTarget();

		camera = (CCustomCamera)theCamera.GetTopmostCameraObject();

		if( theInput.LastUsedGamepad() )
		{
			angleDist = AngleDistance( parent.GetHeading(), camera.GetHeading() );

			if( thePlayer.GetAutoCameraCenter() || ( !m_shouldEnableAutoRotation && AbsF(angleDist) <= 30.0f ) )
			{
				m_shouldEnableAutoRotation = true;
			}
			else if( m_shouldEnableAutoRotation && !thePlayer.GetAutoCameraCenter() && camera.IsManualControledHor() )
			{
				m_shouldEnableAutoRotation = false;
			}
		}
		else
		{
			m_shouldEnableAutoRotation = thePlayer.GetAutoCameraCenter();
		}

		camera.SetAllowAutoRotation( m_shouldEnableAutoRotation );

		boatComponent = (CBoatComponent)vehicle;
		if( boatComponent )
		{
			boatComponent.localSpaceCameraTurnPercent = VecDot2D( camera.GetHeadingVector(), VecCross( boatComponent.GetHeadingVector(), Vector( 0.0f, 0.0f, 1.0f ) ) );

			if( AbsF( boatComponent.localSpaceCameraTurnPercent ) < 0.1f )
			{
				boatComponent.localSpaceCameraTurnPercent = 0.0f;
			}

			if( VecDot2D( camera.GetHeadingVector(), boatComponent.GetHeadingVector() ) < 0.0f )
			{
				boatComponent.localSpaceCameraTurnPercent = SgnF( boatComponent.localSpaceCameraTurnPercent );
			}
		}

		ShouldEnableBoatMusic();

		turnFactor	= theInput.GetActionValue( 'GI_AxisLeftX' );

		turnFactorSum = AbsF( turnFactor + boatComponent.localSpaceCameraTurnPercent );
		if( turnFactorSum > 1.0f )
		{
			turnFactorSum = AbsF( turnFactor * 2.0f + boatComponent.localSpaceCameraTurnPercent );
			turnFactor = ( turnFactor * 2.0f ) / turnFactorSum + boatComponent.localSpaceCameraTurnPercent / turnFactorSum;
		}
		else
		{
			turnFactor = turnFactor + boatComponent.localSpaceCameraTurnPercent;
		}

		LogChannel('Boat', "Rudder turn factor: " + turnFactor );

		rudderDamper = rudderDamper + dt * 6.f * ( turnFactor - rudderDamper );
		LogChannel('Boat', "Rudder damper: " + rudderDamper );

		boatLogic.SetRudderDir( virtual_parent, rudderDamper );

		if( this.vehicleCombatMgr.IsInCombatAction() )
		{
			moveData.pivotRotationController.SetDesiredHeading( moveData.pivotRotationValue.Yaw );
		}
		else
		{
			moveData.pivotRotationController.SetDesiredHeading( parent.GetHeading() - rudderDamper * 20.f );
		}

		if( vehicleCombatMgr.OnGameCameraTick( moveData, dt ) )
		{
			return true;
		}

		theGame.GetGameCamera().ChangePivotDistanceController( 'Boat_DC' );
		theGame.GetGameCamera().ChangePivotRotationController( 'Boat_RC' );

		moveData.pivotRotationController = theGame.GetGameCamera().GetActivePivotRotationController();
		moveData.pivotDistanceController = theGame.GetGameCamera().GetActivePivotDistanceController();
		moveData.pivotPositionController = theGame.GetGameCamera().GetActivePivotPositionController();

		if (!parent.aCameraManager || !parent.aCameraManager.GetControlSailingCameraZoom())
		{
			if( boatLogic.GameCameraTick( fovDistPitch, offsetZ, sailOffset, dt, false ) )
			{
				boatPPC = ( CCustomCameraBoatPPC )moveData.pivotPositionController;
				if( boatPPC )
				{
					offsetUp = Vector( 0.0f, 0.0f, offsetZ );
					boatPPC.SetPivotOffset( offsetUp );
				}

				moveData.pivotRotationController.SetDesiredPitch( fovDistPitch.Z );
				moveData.pivotDistanceController.SetDesiredDistance( fovDistPitch.Y );

				sailCameraOffset = boatLogic.GetSailTilt() * sailOffset;
				DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( sailCameraOffset, 0.f, 0.f ), 0.5f, dt );
			}

		}

		return true;
	}

@replaceMethod(CR4PlayerStateCombat)
function OnGameCameraPostTick( out moveData : SCameraMovementData, dt : float )
{
		var useNativeCloseCamera : bool;
		var enemies : array<CActor> = parent.GetMoveTargets();
		var buff : CBaseGameplayEffect;
		var targetCapsuleHeight : float;
		var offset	:  float;
		var playerToTargetVector	: Vector;

		var pos, targetPos, camPos, distanceAndHeightOffset, screenPos : Vector;
		var heading, offsetSide, offsetPitch, distanceOffset, heightOffset, vecHeadingTarget, vecHeadingPlayer, zDiff, screenPosMultiplier : float;
		var right, normalize, dodging, closeSignCam, usingController : bool;
		var target : CActor;
		var camera : CCustomCamera;
		var hostileEnemies : array<CActor>;

		var i : int;
		var now : float;
		var isOnScreen : bool;
		var canZoomIn : bool;
		var shouldZoomOut : bool;

		var zoomSpeed : float;

		var possibleExtraDistance : float;
		var camMaxDistPosition : Vector;

		var headPos : Vector;
		var targets : array<CActor>;
		var height : float;
		var boneId : int;

		// Keep the selected native mode intact while AC controls this context.
		useNativeCloseCamera = parent.GetCmbtCamera() && !(parent.aCameraManager && parent.aCameraManager.GetIsCurrentCameraOn());

		camera = theCamera.GetTopmostCamera();

		lerpAmount += dt/2;
		lerpAmount = ClampF(lerpAmount,0,1);

		usingController = theInput.LastUsedGamepad();

		if( parent.movementLockType == PMLT_NoRun && !GetWitcherPlayer().HasBuff( EET_Mutation11Immortal ) && !useNativeCloseCamera )
		{
			if ( enemies.Size() == 1 )
			{
				if ( parent.IsCombatMusicEnabled() || parent.GetPlayerMode().GetForceCombatMode() )
					UpdateCameraInterior( moveData, dt );
				else
					parent.UpdateCameraInterior( moveData, dt );

				return true;
			}
			else if ( !parent.IsCombatMusicEnabled() && !parent.IsInCombatAction() )
			{
				parent.UpdateCameraInterior( moveData, dt );
				return true;
			}
		}

		buff = parent.GetCurrentlyAnimatedCS();
		if ( ( ( parent.IsInCombatAction() || buff  ) && ( !parent.IsInCombat() || !( parent.moveTarget && parent.moveTarget.IsAlive() && parent.IsThreat( parent.moveTarget ) ) ) )
				|| ( parent.GetPlayerCombatStance() == PCS_AlertFar && !thePlayer.GetFlyingBossCamera() ) )
			parent.UpdateCameraCombatActionButNotInCombat( moveData, dt );

		if ( !parent.IsInCombatAction() )
			virtual_parent.UpdateCameraSprint( moveData, dt );

		if ( virtual_parent.UpdateCameraForSpecialAttack( moveData, dt ) )
		{
			lerpAmount = 0;
			return true;
		}

		if ( ( parent.IsCameraLockedToTarget()  ) && !cameraChanneledSignEnabled )
		{
			UpdateCameraInterior( moveData, dt );
			if(!useNativeCloseCamera)
				return true;
		}

		if ( parent.GetPlayerCombatStance() == PCS_AlertNear && !useNativeCloseCamera )
		{
			if ( enemies.Size() <= 1 && parent.moveTarget)
			{
				targetCapsuleHeight = ( (CMovingPhysicalAgentComponent)parent.moveTarget.GetMovingAgentComponent() ).GetCapsuleHeight();
				if ( targetCapsuleHeight > 2.f )
				{
					playerToTargetVector = parent.moveTarget.GetWorldPosition() - parent.GetWorldPosition();
					offset = ( 2 - ( targetCapsuleHeight + playerToTargetVector.Z ) )/(-2);
					offset = ClampF( offset, 0.f, 3.f );
					DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( moveData.cameraLocalSpaceOffset.X, moveData.cameraLocalSpaceOffset.Y, moveData.cameraLocalSpaceOffset.Z + offset ), 1.f, dt );
				}
			}
		}

		if(useNativeCloseCamera  )
		{
			pos = parent.GetWorldPosition();
			target = parent.GetTarget();
			targetPos = target.GetWorldPosition();
			camPos = camera.GetWorldPosition();
			heading = parent.GetHeading();

			zDiff = ClampF((targetPos.Z - pos.Z) * 3, -30.f, 30.f);

			moveData.pivotPositionController.SetDesiredPosition( pos, 15.f );
			moveData.pivotPositionController.offsetZ = 1.15f;

			hostileEnemies = parent.GetHostileEnemies();
			distanceOffset = parent.GetHostileEnemiesCount();
			distanceOffset = ClampF(distanceOffset, 1,4);

			offsetSide = 6.f;

			if(target && usingController)
			{

				if(VecDistanceSquared(pos,targetPos) < VecDistanceSquared(camPos,targetPos))
				{
					vecHeadingTarget = VecHeading(targetPos - camPos);
					vecHeadingPlayer = VecHeading(pos - camPos);

					if( AbsF(vecHeadingTarget) > 100 )
					{
						normalize = true;
					}

					if(normalize)
					{
						if(AngleNormalize(vecHeadingTarget) > AngleNormalize(vecHeadingPlayer) )
						{
							offsetSide *= 0.25;
							right = true;
						}
					}
					else
					{
						if(vecHeadingTarget > vecHeadingPlayer )
						{
							offsetSide *= 0.25;
							right = true;
						}
					}
				}

				if(cachedRight != right)
				{
					lerpAmount = 0;
				}
				cachedRight = right;

				GetBaseScreenPosition(screenPos, target);
				if(screenPos.X == 0)
					screenPosMultiplier = 1.f;
				else
				{
					screenPosMultiplier = AbsF(ClampF(screenPos.X - 960, -1920, 1920 ));
					screenPosMultiplier = 1 - (screenPosMultiplier / 1920);
				}

				if(parent.GetSoftLockCameraAssist() && !thePlayer.GetIsSprinting() && target.IsAlive())
				{
					if(thePlayer.IsHardLockEnabled())
					{
						if(right)
							moveData.pivotRotationController.SetDesiredHeading( VecHeading(targetPos - pos) - 15, parent.lockCameraSpeed );
						else
							moveData.pivotRotationController.SetDesiredHeading( VecHeading(targetPos - pos) + 15, parent.lockCameraSpeed );
					}
					else
					{
						if(right)
							moveData.pivotRotationController.SetDesiredHeading( VecHeading(targetPos - pos) - 15, 0.6f + screenPosMultiplier);
						else
							moveData.pivotRotationController.SetDesiredHeading( VecHeading(targetPos - pos) + 15, 0.6f + screenPosMultiplier);
					}

					if(parent.GetBehaviorVariable( 'combatActionType' ) == (int)CAT_CiriDodge)
						moveData.pivotRotationController.SetDesiredHeading( VecHeading(targetPos - pos), 2 );
				}
			}

			if(target.IsHuman())
			{
				if(target && !thePlayer.IsHardLockEnabled())
					moveData.pivotRotationController.SetDesiredPitch( ClampF( -12 + zDiff, -25, 5 ) );
			}
			else if ( !parent.isDynamicCombatCameraEnabled )
			{
				targetCapsuleHeight = ( (CMovingPhysicalAgentComponent)target.GetMovingAgentComponent() ).GetCapsuleHeight();

				if(targetCapsuleHeight >= 1.81f && !((CNewNPC)target).IsFlying())
				{
					offsetPitch = ( -VecDistance(pos,targetPos) + targetCapsuleHeight ) * 2;

					if(target)
						moveData.pivotRotationController.SetDesiredPitch( ClampF( offsetPitch + zDiff, -25, 5 ) );

					distanceOffset = ClampF(distanceOffset + targetCapsuleHeight/2, 1,5);
				}
				else
				{
					if(target && !thePlayer.IsHardLockEnabled())
						moveData.pivotRotationController.SetDesiredPitch( -12 + zDiff );
				}
			}

			distanceOffset = distanceOffset / 1.3;
			heightOffset = distanceOffset / 1.5;

			distanceOffset = MaxF(distanceOffset, 1);
			heightOffset = MaxF(heightOffset, 1);

			if(thePlayer.IsFistFightMinigameEnabled())
				distanceOffset = 0.3;

			if(cachedDistanceOffset != distanceOffset || cachedHeightOffset != heightOffset)
				lerpAmount = 0;
			cachedDistanceOffset = distanceOffset;
			cachedHeightOffset = heightOffset;
			distanceAndHeightOffset = Vector(0, -cachedDistanceOffset * 0.2, cachedHeightOffset * 0.1);

			dodging = parent.IsCurrentlyDodging();
			if(cachedDodging != dodging)
			{
				lerpAmount = 0;
			}
			cachedDodging = dodging;

			if(!thePlayer.IsCiri() && cachedDodging)
			{

				moveData.pivotDistanceController.SetDesiredDistance( 3.0f );
				moveData.pivotPositionController.SetDesiredPosition( pos, 25.f );
				moveData.pivotPositionController.offsetZ = 1.15f;

				if(thePlayer.IsHardLockEnabled())
					DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( offsetSide * 1.4, -3.1f* distanceOffset, 1.2f * heightOffset ), 5.0f, dt );
				else
					DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( offsetSide, -3.1f* distanceOffset, 1.2f * heightOffset ), 5.0f, dt );
			}
			else
			{

				moveData.pivotDistanceController.SetDesiredDistance( 1.5f );

				closeSignCam = parent.GetCloseSignCam();
				if(cachedSignCam != closeSignCam)
				{
					lerpAmount = 0;
				}
				cachedSignCam = closeSignCam;

				if( cachedSignCam && usingController )
				{
					if( cachedRight )
						moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, geraltCmbtSignV + distanceAndHeightOffset, lerpAmount);
					else
						moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, geraltCmbtV + distanceAndHeightOffset, lerpAmount);
				}
				else if ( cachedRight && usingController )
					moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, geraltCmbtRightV + distanceAndHeightOffset, lerpAmount);
				else
					moveData.cameraLocalSpaceOffset = LerpV(moveData.cameraLocalSpaceOffset, geraltCmbtV + distanceAndHeightOffset, lerpAmount);
				moveData.cameraLocalSpaceOffsetVel = Vector(0,0,0);
			}

			if ( parent.isDynamicCombatCameraEnabled )
			{

				parent.GetVisibleEnemies( targets );
				for ( i = 0; i < targets.Size(); i += 1 )
				{
					if ( VecDistance2D( targets[i].GetWorldPosition(), parent.GetWorldPosition() ) <= 5 )
					{
						AddRecentActorTarget( targets[i] );
					}
				}

				if ( recentActorTargets.Size() )
				{
					possibleExtraDistance = moveData.pivotDistanceController.maxDist - moveData.pivotDistanceValue;
					camMaxDistPosition = camPos - ( camera.GetWorldForward() * possibleExtraDistance );

					now = theGame.GetEngineTimeAsSeconds();
					canZoomIn = true;

					for ( i = recentActorTargets.Size() - 1; i >= 0 ; i = i - 1 )
					{
						if ( !recentActorTargets[i].IsAlive() || now - 7.5 > recentActorTargetsTime[i] )
						{
							RemoveRecentActorTarget( i );
							continue;
						}

						screenPos = Vector( 0, 0, 0 );
						isOnScreen = theCamera.TestWorldVectorToViewRatio( recentActorTargets[i].GetWorldPosition(), screenPos.X, screenPos.Y, camMaxDistPosition, camera.GetWorldRotation() );
						if ( !isOnScreen || AbsF( screenPos.X ) > 0.7f || AbsF( screenPos.Y ) > 0.8f )
						{
							continue;
						}

						screenPos = Vector( 0, 0, 0 );
						isOnScreen = theCamera.WorldVectorToViewRatio( recentActorTargets[i].GetWorldPosition(), screenPos.X, screenPos.Y );
						if ( !isOnScreen || AbsF( screenPos.X ) > 0.8f || AbsF( screenPos.Y ) > 0.9f )
						{
							shouldZoomOut = true;
							canZoomIn = false;
						}
						else if ( AbsF( screenPos.X ) > 0.7f || AbsF( screenPos.Y ) > 0.8f )
						{
							canZoomIn = false;
						}

						pos = recentActorTargets[i].GetWorldPosition();
						if ( recentActorTargetsHeadHeightCheckTime[i] + 0.2f < now )
						{
							targetCapsuleHeight = ( (CMovingPhysicalAgentComponent)recentActorTargets[i].GetMovingAgentComponent() ).GetCapsuleHeight();
							boneId = recentActorTargets[i].GetHeadBoneIndex();

							if ( boneId > 0 )
							{
								headPos = MatrixGetTranslation( target.GetBoneWorldMatrixByIndex( boneId ) );
								height = headPos.Z + 0.5f - pos.Z;
								if ( height > targetCapsuleHeight )
								{
									AddRecentActorTargetHeadHeight( i, height );
									recentActorTargetsHeadHeightCheckTime[i] = now;
								}
							}
						}

						screenPos = Vector( 0, 0, 0 );

						height = GetRecentActorTargetHeadHeightMedian( i );

						if ( height > recentActorTargetsMaxHeight[i] )
						{
							recentActorTargetsMaxHeight[i] = height;
						}

						pos.Z += recentActorTargetsMaxHeight[i];

						isOnScreen = theCamera.WorldVectorToViewRatio( pos, screenPos.X, screenPos.Y );
						if ( !isOnScreen || AbsF( screenPos.X ) > 0.8f || AbsF( screenPos.Y ) > 0.9f )
						{
							shouldZoomOut = true;
							canZoomIn = false;
						}
						else if ( AbsF( screenPos.X ) > 0.7f || AbsF( screenPos.Y ) > 0.8f )
						{
							canZoomIn = false;
						}
					}

					if ( canZoomIn )
					{
						if ( combatCameraZoomInRequestedTime == -1 )
							combatCameraZoomInRequestedTime = theGame.GetEngineTimeAsSeconds();
						else if ( combatCameraZoomInRequestedTime + 3 < theGame.GetEngineTimeAsSeconds() )
							combatCameraDesiredDistance = 1.5f;
					}
					else
					{
						combatCameraZoomInRequestedTime = -1;

						if ( shouldZoomOut )
							combatCameraDesiredDistance = 5.f;
						else
							combatCameraDesiredDistance = moveData.pivotDistanceValue;
					}

					if ( !parent.IsHardLockEnabled() && !parent.IsCameraLockedToTarget() )
						moveData.pivotRotationController.SetDesiredHeading( moveData.pivotRotationValue.Yaw, 1.f );
				}
				else
				{
					combatCameraDesiredDistance = 1.5f;
				}

				zoomSpeed = 0.5f;
				moveData.pivotDistanceController.SetDesiredDistance( combatCameraDesiredDistance, zoomSpeed );

			}
		}
		else
		{
			lerpAmount = 0;

			pos = parent.GetWorldPosition();
			target = parent.GetTarget();
			targetPos = target.GetWorldPosition();
			if(target && theInput.LastUsedGamepad())
			{
				if(parent.GetSoftLockCameraAssist() && !thePlayer.GetIsSprinting() && target.IsAlive())
				{
					if(right)
						moveData.pivotRotationController.SetDesiredHeading( VecHeading(targetPos - pos) - 15 );
					else
						moveData.pivotRotationController.SetDesiredHeading( VecHeading(targetPos - pos) + 15 );

					if(parent.GetBehaviorVariable( 'combatActionType' ) == (int)CAT_CiriDodge)
						moveData.pivotRotationController.SetDesiredHeading( VecHeading(targetPos - pos), 2 );
				}
			}
		}

		super.OnGameCameraPostTick( moveData, dt );
	}

@replaceMethod(CR4Player)
function OnGameCameraPostTick( out moveData : SCameraMovementData, dt : float )
{
		var ent : CEntity;
		var entPos : Vector;
		var playerPos : Vector;
		var angles : EulerAngles;
		var zOffset : float;
		var lookAtOffset	: Vector;
		var alpha : float;

		var distance : float;

		if(GetExplCamera() && substateManager.GetStateCur() == 'Interaction' && !(aCameraManager && aCameraManager.GetIsCurrentCameraOn()))
		{
			moveData.pivotDistanceController.SetDesiredDistance( 1.5f );
			DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.7f, -0.3f, 0.3f ), 0.5f, dt );
		}

		if (questCameraOffsetRequest.active || questCameraOffsetRequest.restore)
		{
			if (questCameraOffsetRequest.active)
			{
				alpha = (theGame.GetEngineTimeAsSeconds() - questCameraRequest.requestTimeStamp)/questCameraOffsetRequest.lerpTime;
				alpha = ClampF(alpha, 0.0f, 1.0f);
			}
			else
			{
				alpha = (theGame.GetEngineTimeAsSeconds() - cameraRequestTimeStamp)/questCameraOffsetRequest.lerpTime;
				alpha = ClampF(alpha, 0.0f, 1.0f);
				alpha = 1.0f - alpha;
			}

			if (questCameraOffsetRequest.cachedZ <= -99.f)
				questCameraOffsetRequest.cachedZ = moveData.cameraLocalSpaceOffset.Z;

			zOffset = LerpF(alpha, questCameraOffsetRequest.cachedZ, questCameraOffsetRequest.zOffset);
			lookAtOffset = LerpV(questCameraOffsetRequest.cachedLookAt, questCameraOffsetRequest.lookAtOffset, alpha);
			distance = LerpF(alpha, moveData.pivotDistanceValue, questCameraOffsetRequest.distance);
			moveData.cameraLocalSpaceOffset = Vector(moveData.cameraLocalSpaceOffset.X, moveData.cameraLocalSpaceOffset.Y, zOffset);
			if (questCameraOffsetRequest.requestDistance)
				moveData.pivotDistanceController.SetDesiredDistance( distance );

			if (alpha <= 0.f && questCameraOffsetRequest.restore)
			{
				questCameraOffsetRequest.restore = false;
				questCameraOffsetRequest.requestDistance = false;
				questCameraOffsetRequest.cachedZ = -99.f;
				thePlayer.EnableManualCameraControl( true, 'QuestCameraZOffset' );
				return true;
			}
		}

		if ( questCameraRequest.requestTimeStamp > 0 )
		{
			if ( questCameraRequest.duration > 0 && questCameraRequest.requestTimeStamp + questCameraRequest.duration < theGame.GetEngineTimeAsSeconds() )
			{
				ResetQuestCameraRequest();
				return false;
			}

			if( questCameraRequest.lookAtTag )
			{
				ent = theGame.GetEntityByTag( questCameraRequest.lookAtTag );
				entPos = ent.GetWorldPosition();
				entPos.Z -= zOffset;
				playerPos = GetWorldPosition();
				playerPos.Z += 1.8f;

				angles = VecToRotation( (entPos + (lookAtOffset*ent.GetHeadingVector())) - playerPos);

				moveData.pivotRotationController.SetDesiredHeading( angles.Yaw );
				moveData.pivotRotationController.SetDesiredPitch( -angles.Pitch );
			}
			else
			{
				if( questCameraRequest.requestYaw )
				{
					angles = GetWorldRotation();
					moveData.pivotRotationController.SetDesiredHeading( angles.Yaw + questCameraRequest.yaw );
				}

				if( questCameraRequest.requestPitch )
				{
					moveData.pivotRotationController.SetDesiredPitch( questCameraRequest.pitch );
				}
			}
		}
	}

@replaceMethod(W3PlayerWitcherStateMeditation)
function OnGameCameraPostTick( out moveData : SCameraMovementData, dt : float )
{
		var rotation : EulerAngles = parent.GetWorldRotation();

		if( isLeavingState )
		{
			if( parent.GetExplCamera() && !(parent.aCameraManager && parent.aCameraManager.GetIsCurrentCameraOn()) )
			{
				moveData.pivotDistanceController.SetDesiredDistance( 1.5f, 0.25f );
			}
			else if ( parent.IsModernExplorationCamera() && !(parent.aCameraManager && parent.aCameraManager.GetIsCurrentCameraOn()) )
			{
				moveData.pivotDistanceController.SetDesiredDistance( 2.25f, 0.25f );
			}
			moveData.pivotRotationController.SetDesiredHeading( rotation.Yaw, 0.5f );
		}
	}

@wrapMethod(CR4PlayerStateSailing)
function OnGameCameraPostTick(out moveData : SCameraMovementData, dt : float)
{
	var camera : CCustomCamera;
	var aCamera : SACamera;
	var result : bool;
	camera = theGame.GetGameCamera();
	if (parent.aCameraManager)
		aCamera = parent.aCameraManager.GetCamera();
	result = wrappedMethod(moveData, dt);
	if (result)
		return result;

	if(aCamera.IsOn)
	{
		if(parent.aCameraManager.GetPicthMode() == 1 && boatLogic.GetCurrentGear() > 2)
			moveData.pivotRotationController.SetDesiredPitch( parent.aCameraManager.GetDesiredPitch() );
		else if(parent.aCameraManager.GetPicthMode() == 2)
			moveData.pivotRotationController.SetDesiredPitch( parent.aCameraManager.GetDesiredPitch() );
		else
			camera.SetAllowAutoRotation( false );

		moveData.pivotRotationController.maxPitch = parent.aCameraManager.GetMaxPitch();
		moveData.pivotRotationController.minPitch = parent.aCameraManager.GetMinPitch();

		if(parent.aCameraManager.GetAutoCenterMode() == 1 && boatLogic.GetCurrentGear() > 2)
			moveData.pivotRotationController.SetDesiredHeading(parent.GetHeading());
		else if(parent.aCameraManager.GetAutoCenterMode() == 2)
			moveData.pivotRotationController.SetDesiredHeading(parent.GetHeading());

		DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector(aCamera.PosX, aCamera.PosY, aCamera.PosZ), 0.5f, dt );

		camera.fov = parent.aCameraManager.GetFOV();

		return true;
	}
	return result;
}

@wrapMethod(W3PlayerWitcherStateMeditationBase)
function OnGameCameraTick( out moveData : SCameraMovementData, dt : float )
{
    var commonMenuRef : CR4CommonMenu;

    commonMenuRef = theGame.GetGuiManager().GetCommonMenu();
    // The clock menu can open before the seated meditation camera is ready.
    if ((!commonMenuRef || commonMenuRef.m_had_meditation) &&
        parent.aCameraManager && parent.aCameraManager.GetIsCurrentCameraOn())
    {
        if (virtual_parent.OnGameCameraTick(moveData, dt))
            return true;
    }

    return wrappedMethod(moveData, dt);
}

@wrapMethod(W3PlayerWitcherStateMeditation)
function OnGameCameraTick( out moveData : SCameraMovementData, dt : float )
{
    // Native meditation stops calling its base camera while standing up.
    if (IsLeavingState() && parent.aCameraManager && parent.aCameraManager.GetIsCurrentCameraOn())
    {
        if (virtual_parent.OnGameCameraTick(moveData, dt))
            return true;
    }

    return wrappedMethod(moveData, dt);
}

@wrapMethod(CR4PlayerStateMountHorse)
function OnGameCameraPostTick( out moveData : SCameraMovementData, dt : float )
{
    if (parent.aCameraManager && parent.aCameraManager.ApplyHorseCamera(moveData, dt, parent.GetIsSprinting()))
        return true;

    return wrappedMethod(moveData, dt);
}

@replaceMethod(CR4PlayerStateMountHorse)
function OnEnterState( prevStateName : name )
{
		var instantMount : bool;
		instantMount = false;
		if (parent.aCameraManager)
			parent.aCameraManager.BeginHorseCamera(mountType == MT_instant);

		super.OnEnterState( prevStateName );

		thePlayer.HideUsableItem();

		thePlayer.AddBuffImmunity( EET_Pull, 'HorseRidingBuffImmunity', true );

		horseComp = (W3HorseComponent)vehicle;

		if( vehicle.GetEntity().HasTag( 'carriage_horse' ) )
		{
			thePlayer.SetBehaviorVariable( 'isRidingCart', 1.f, true );
		}

		if( horseComp )
		{
			horseComp.canDismount = false;
			this.ProcessMountHorse();
		}
		else
		{
			LogAssert( vehicle, "MountHorse::ProcessMountTheVehicle, 'vehicle' is not set" );
		}

		if( mountType == MT_instant )
		{
			instantMount = true;
		}

		if ( !IsMountsRemasterEnabled() )
		{

			if (!parent.aCameraManager || !parent.aCameraManager.SuppressNativeHorseCamera(instantMount))
				theGame.ActivateHorseCamera( true, instantMount ? 0.f : 0.4f, instantMount );
		}

		if ( (W3ReplacerCiri)thePlayer )
		{
			theInput.SetContext( 'Horse_Replacer_Ciri' );
		}
		else
			theInput.SetContext( 'Horse' );
	}

@replaceMethod(CBTTaskRidingManagerPlayerHorseMount)
function Main() : EBTNodeStatus
{
        var vehicleEntity		: CEntity;
		var vehicleComponent	: W3HorseComponent;
		var riderActor			: CActor;
		var exploration 		: SExplorationQueryToken;
		var queryContext 		: SExplorationQueryContext;
		var success 			: bool = true;
		var useNewMount 		: bool = true;
		var startDist 			: float;
		var entrySpeed 			: float;

        vehicleEntity      = riderData.sharedParams.GetHorse();
        vehicleComponent   = ((CNewNPC)vehicleEntity).GetHorseComponent();
		riderActor         = GetActor();

		riderData.ridingManagerMountError = false;
		vehicleComponent.useEarlyExploration = false;

		useNewMount = !vehicleComponent.isCart && !thePlayer.IsCiri() && !riderData.ridingManagerInstantMount && IsMountsRemasterEnabled();


		if ( useNewMount )
		{
			startDist = VecDistance2D( vehicleEntity.GetWorldPosition(), riderActor.GetWorldPosition() );
			entrySpeed = VecLength2D( riderActor.GetMovingAgentComponent().GetVelocity() );
			useNewMount = startDist > 3.0 && entrySpeed > 1.9;
		}




		if ( !useNewMount )
		{
			if (!thePlayer.aCameraManager || !thePlayer.aCameraManager.SuppressNativeHorseCamera(riderData.ridingManagerInstantMount))
				theGame.ActivateHorseCamera( true, riderData.ridingManagerInstantMount ? 0.f : 0.4f, riderData.ridingManagerInstantMount );
			riderActor.EnableCharacterCollisions( false );
			MountActor( riderData, 'VehicleHorse', vehicleComponent );
			return BTNS_Completed;
		}

		vehicleComponent.useEarlyExploration = true;












		if ( success )
		{

			if ( vehicleComponent.GetCurrentStateName() == 'Exploration' )
			{
				vehicleComponent.PopState( true );
			}


			OnMountStarted( riderData, 'VehicleHorse', vehicleComponent );

			if ( riderData.ridingManagerInstantMount == false )
			{
				success = MountHorse_Remaster_Running( vehicleComponent );
			}
		}

		if ( success )
		{
			OnMountFinishedSuccessfully( riderData, 'VehicleHorse', vehicleComponent );
		}
		else
		{
			OnMountFailed( riderData, vehicleComponent );
		}


        return BTNS_Completed;
    }

@replaceMethod(CBTTaskRidingManagerPlayerHorseMount)
function MountHorse_Remaster_Running( horseComponent : W3HorseComponent ) : bool
{
		var riderActor			: CActor;
		var vehicleEntity		: CEntity;
		var movAdj				: CMovementAdjustor;
		var isMoving			: bool;
		var animName			: name;
		var horseMac			: CMovingAgentComponent;
		var riderMac			: CMovingAgentComponent;
		var horsePredictedPos	: Vector;
		var horsePredictedRot	: float;
		var rotDelta			: float;
		var posDelta			: float;
		var approachVec			: Vector;
		var approachAngle		: float;
		var approachDist		: float;
		var iteration			: int;
		var useBackAnim 		: bool = false;
		var i					: int;
		var debugBool			: bool;
		var debugVec			: Vector;

		riderActor 		= GetActor();
        vehicleEntity 	= riderData.sharedParams.GetHorse();
		horseMac 		= ((CActor)vehicleEntity).GetMovingAgentComponent();
		riderMac 		= riderActor.GetMovingAgentComponent();


		debugBool = false;

		horseComponent.OnEarlyExplorationMountStart( riderActor );

		if ( 1 )
		{
			riderActor.EnableCharacterCollisions( true );





			isMoving = false;
			while ( 1 )
			{
				if ( 1 )

				{







					if ( VecLength2D( horseMac.GetVelocity() ) > VecLength2D( riderMac.GetVelocity() ) * 1.2 )
					{
						riderActor.ActionCancelAll();
						return false;
					}

					horsePredictedPos = vehicleEntity.GetWorldPosition();
					horsePredictedRot = vehicleEntity.GetHeading();
					posDelta = VecLength2D( horseMac.GetVelocity() ) * 0.05;
					rotDelta = ClampF( horseComponent.rotSpeed, -90, 90 ) * 0.05;



					for ( i = 0; i < 2; i += 1 )
					{
						for ( iteration = 0; iteration < 5; iteration += 1 )
						{
							horsePredictedPos += VecFromHeading( horsePredictedRot ) * posDelta;
							horsePredictedRot += rotDelta;
						}




















						approachVec = horsePredictedPos - riderActor.GetWorldPosition();
						approachAngle = AngleDistance( horsePredictedRot, VecHeading( -approachVec ) );
						approachDist = VecLength2D( approachVec );








						if ( i == 1 )
						{
							approachDist = approachDist - 0.35;
						}


						if ( approachAngle > 0 )
						{
							if ( approachAngle < 61.89 )
							{
								if ( approachDist <= 3.11 ) animName = 'mount_jump_right_front_45_remaster';
							}
							else if ( approachAngle < 101.25 )
							{
								if ( approachDist <= 3.00 ) animName = 'mount_jump_right_side_remaster';
							}
							else if ( approachAngle < 135.63 )
							{
								if ( approachDist <= 2.65 ) animName = 'mount_jump_right_back_45_remaster';
							}
							else if ( approachAngle < 165.07 || !useBackAnim )
							{
								if ( approachDist <= 1.95 ) animName = 'mount_jump_right_back_remaster';
							}
							else {
								if ( approachDist <= 3.08 ) animName = 'mount_jump_back_remaster';
							}
						}
						else
						{
							if ( approachAngle > -60.91 )
							{
								if ( approachDist <= 3.72 ) animName = 'mount_jump_left_front_45_remaster';
							}
							else if ( approachAngle > -110.87 )
							{
								if ( approachDist <= 3.50 ) animName = 'mount_jump_left_side_remaster';
							}
							else if ( approachAngle > -143.84 )
							{
								if ( approachDist <= 2.75 ) animName = 'mount_jump_left_back_45_remaster';
							}
							else if ( approachAngle > -166.42 || !useBackAnim )
							{
								if ( approachDist <= 2.56 ) animName = 'mount_jump_left_back_remaster';
							}
							else {
								if ( approachDist <= 3.08 ) animName = 'mount_jump_back_remaster';
							}
						}

						if ( animName )
						{
							break;
						}
					}

					if ( animName )
					{
						break;
					}

					if ( debugBool )
					{
						return false;
					}

					if ( !isMoving )
					{



						riderActor.ActionMoveToAsync( horsePredictedPos + VecNormalize2D( approachVec ) , MT_Sprint, 1.0, 0.1 );
						isMoving = true;
					}
					else
					{
						riderActor.ActionMoveToChangeTargetAsync( horsePredictedPos + VecNormalize2D( approachVec ), MT_Sprint, 1.0, 0.1 );
					}
				}
				else
				{
					return false;
				}

				SleepOneFrame();
			}

			riderActor.ActionCancelAll();


			riderActor.EnableCharacterCollisions( false );
		}











		riderActor.SetInteractionPriority( IP_Max_Unpushable );


		mountType = 'horse_mount_B_01';




		isFirstAdjPos = true;
		isFirstAdjRot = true;












		((CR4PlayerStateMountHorse)thePlayer.GetState('MountHorse')).OnMountAnimStarted();
		debugBool = riderActor.ActionPlaySlotAnimation( 'PLAYER_SLOT', animName, 0.2, 0, false );
		if ( !debugBool )
		{

			((CR4PlayerStateMountHorse)thePlayer.GetState('MountHorse')).OnMountAnimCancelled();

			riderActor.RestoreOriginalInteractionPriority();
			return false;
		}

		movAdj = riderActor.GetMovingAgentComponent().GetMovementAdjustor();
		movAdj.CancelByName( 'AdjustMountT1' );
		movAdj.CancelByName( 'AdjustMountR1' );
		movAdj.CancelByName( 'AdjustMountT2' );
		movAdj.CancelByName( 'AdjustMountR2' );



		if (!thePlayer.aCameraManager || !thePlayer.aCameraManager.SuppressNativeHorseCamera(false))
			theGame.ActivateHorseCamera( true, 0.4f, false );


		riderActor.RestoreOriginalInteractionPriority();


		riderActor.SignalGameplayEvent( 'HorseRidingOn' );

		return true;
	}

@wrapMethod(CR4PlayerStateMountHorse)
function OnLeaveState( nextStateName : name )
{
    if (parent.aCameraManager && nextStateName != 'HorseRiding')
        parent.aCameraManager.ResetHorseCamera();
    return wrappedMethod(nextStateName);
}

@wrapMethod(CR4PlayerStateHorseRiding)
function OnLeaveState( nextStateName : name )
{
    if (parent.aCameraManager)
        parent.aCameraManager.ResetHorseCamera();
    return wrappedMethod(nextStateName);
}

@wrapMethod(CR4PlayerStateMountHorse)
function OnDeath( damageAction : W3DamageAction )
{
    if (parent.aCameraManager)
        parent.aCameraManager.ResetHorseCamera();
    return wrappedMethod(damageAction);
}

@wrapMethod(CR4PlayerStateHorseRiding)
function OnDeath( damageAction : W3DamageAction )
{
    if (parent.aCameraManager)
        parent.aCameraManager.ResetHorseCamera();
    return wrappedMethod(damageAction);
}
