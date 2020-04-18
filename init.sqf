// Bush Wars Initialization
// Mission by MacMerritt
// Scripting by Nate Stowwe
// Not all code is mine

//----------------- START HC
if (!hasInterface && !isDedicated) then {
	headlessClients = [];
	headlessClients set [(count headlessClients), player];
	publicVariable "headlessClients";
	isHC = true;
};
//----------------- END HC
//----------------- START ALIVE AUTOSAVE
14400 call ALiVE_fnc_AutoSave_PNS;
//----------------- END ALIVE AUTOSAVE

call compile preprocessFile "stowwe_logi\init.sqf";
execVM "stowwe_logi\allowance.sqf";

_n = [] spawn
{
sleep 5;
while {true} do
{
sleep 2;
if ((cameraOn == player) and (animationState player == "horse_rider") and !(isNull attachedTo player)) then
{
sleep 1;
// We check same condition twice because these conditions are true for a split second when player
// chooses "Get Off" action. By waiting a bit, we know player is truly stuck.
if ((cameraOn == player) and (animationState player == "horse_rider") and !(isNull attachedTo player)) then
{
sleep .5;
_horse = attachedTo player;
player switchMove "";
detach player;
player setVelocityModelSpace [-2,0,-2];
removeAllActions _horse; // remove get off action then add get on action
_hossmount = _horse addaction ["GetOn","\dbo\dbo_horses\scripts\horse_mount.sqf",nil,1.5,true,true,"","true",4,false,""];
_horse setobjecttexture [0,"\dbo\dbo_horses\data\tack_co.paa"];
_horse setobjecttexture [1,""];
};
};
};
};