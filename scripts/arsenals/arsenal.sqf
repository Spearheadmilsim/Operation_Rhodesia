//Op Frostbite arsenal switcher
//Nathan Stowwe


params ["_caller"];

if    (_caller getUnitTrait "1-82") exitWith {

	hint "Opening 1-82 Arsenal...";
	sleep 1;
	[ars_182, _caller] call ace_arsenal_fnc_openBox;
	
}; if (_caller getUnitTrait "3id") exitWith {

	hint "Opening 3 ID Arsenal...";
	sleep 1;
	[ars_3id, _caller] call ace_arsenal_fnc_openBox;
	
	
}; if (_caller getUnitTrait "3idlead") exitWith {

	hint "Opening 3 ID Lead Arsenal...";
	sleep 1;
	[ars_3idlead, _caller] call ace_arsenal_fnc_openBox;
	
	
}; if (_caller getUnitTrait "3idhq") exitWith {

	hint "Opening 3 ID HQ Arsenal...";
	sleep 1;
	[ars_3idhq, _caller] call ace_arsenal_fnc_openBox;
	
}; if (_caller getUnitTrait "prae") exitWith {

	hint "Opening Prae Arsenal...";
	sleep 1;
	[ars_prae, _caller] call ace_arsenal_fnc_openBox;
	
	
}; if (_caller getUnitTrait "praelead") exitWith {

	hint "Opening Prae Lead Arsenal...";
	sleep 1;
	[ars_praelead, _caller] call ace_arsenal_fnc_openBox;
	
	
}; if (_caller getUnitTrait "praehq") exitWith {

	hint "Opening Prae HQ Arsenal...";
	sleep 1;
	[ars_praehq, _caller] call ace_arsenal_fnc_openBox;
	
}; if (_caller getUnitTrait "meu") exitWith {

	hint "Opening MEU Arsenal...";
	sleep 1;
	[ars_meu, _caller] call ace_arsenal_fnc_openBox;
	
	
}; if (_caller getUnitTrait "meulead") exitWith {

	hint "Opening MEU Lead Arsenal...";
	sleep 1;
	[ars_meulead, _caller] call ace_arsenal_fnc_openBox;
	
	
}; if (_caller getUnitTrait "meuhq") exitWith {

	hint "Opening MEU HQ Arsenal...";
	sleep 1;
	[ars_meuhq, _caller] call ace_arsenal_fnc_openBox;
	
}; if (_caller getUnitTrait "det7") exitWith {

	hint "Opening Det-7 Arsenal...";
	sleep 1;
	[ars_det7, _caller] call ace_arsenal_fnc_openBox;
	
	
}; if (_caller getUnitTrait "det7hq") exitWith {

	hint "Opening Det-7 HQ Arsenal...";
	sleep 1;
	[ars_det7hq, _caller] call ace_arsenal_fnc_openBox;
	
	
}; if (_caller getUnitTrait "Aviation") exitWith {
	
	hint "Opening Aviation Arsenal...";
	sleep 1;
	[ars_aviation, _caller] call ace_arsenal_fnc_openBox;


}; if (_caller getUnitTrait "Avipilot") exitWith {
	
	hint "Opening Aviation Pilot Arsenal...";
	sleep 1;
	[ars_avipilot, _caller] call ace_arsenal_fnc_openBox;


}; if (_caller getUnitTrait "Avihq") exitWith {
	
	hint "Opening Aviation HQ Arsenal...";
	sleep 1;
	[ars_avihq, _caller] call ace_arsenal_fnc_openBox;
};

//this should only be reached if they don't have an applicable unit
hint "Unit not found. Defaulting to 1-82 Arsenal... Please tell the mission developer!";
sleep 1;
[ars_182, _caller] call ace_arsenal_fnc_openBox;
