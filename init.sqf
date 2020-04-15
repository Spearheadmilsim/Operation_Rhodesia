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
