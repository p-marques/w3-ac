// Absolute Camera 4.x - 2022, pMarK
// Camera Struct

struct SACamera
{
	var IsOn : bool;
	var Mode : Int32;
	var PosX, PosY, PosZ : float;
	var UnlockedPos : Vector;
	var IsLocked : bool;
	var IsShoulderToggled : bool;
	var Name : string;

	default IsOn = false;
	default Mode = 0;
	default PosX = 0.0f;
	default PosY = 0.0f;
	default PosZ = 0.0f;
	default IsLocked = true;
	default IsShoulderToggled = false;
	default Name = "[NULL]";
}