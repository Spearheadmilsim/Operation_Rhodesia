//Op Frostbite support arsenal
//Nathan Stowwe

params ["_caller"];
if (_caller getUnitTrait "Support") then {
	hint "Opening Support Arsenal...";
	sleep 1;
	[ars_support, _caller] call ace_arsenal_fnc_openBox;
} else {
	hint "You don't have permission to access the support arsenal!"
};