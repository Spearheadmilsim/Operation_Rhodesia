// Nathan Stowwe
// Arma 3 Lightweight Logistics
// Post-spawn scripting
// 6-April-2020

/* _vic = The newly spawned vehicle
 * _caller = The unit that spawned the vehicle
 */
params ["_vic", "_caller"];

[ALiVE_SYS_LOGISTICS, "updateObject", _vic] call ALIVE_fnc_logistics;

//Uncomment this block to have the vehicle cargo cleared on spawn

clearWeaponCargoGlobal _vic;
clearMagazineCargoGlobal _vic;
clearBackpackCargoGlobal _vic;
clearItemCargoGlobal _vic;
