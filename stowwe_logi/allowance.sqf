//Op Frostbite logi allowance
//Nathan Stowwe

FACTORY_ALLOWANCE = 1000;	//Allowance of credits per turnover
FACTORY_TURNOVER = 120;		//Time between turnovers, in minutes
FACTORY_STARTFUNDS = 50000;

_val = "logicredits" call ALiVE_fnc_ProfileNameSpaceLoad;
FACTORY_STARTFUNDS call compile preprocessFile "stowwe_logi\rhodesia.sqf";

//The value will be "SCALAR" if it was saved, "BOOL" if not. If its a bool, then the first statement will initialize it based off of the startfunds.
//if it was a scalar, it'll drop down to the else and just load that.
	if (typeName _val != "SCALAR") then {
	["logicredits", FACTORY_STARTFUNDS] call ALiVE_fnc_ProfileNameSpaceSave;
	stowwe_factory setVariable ["stowwe_logi_credits", FACTORY_STARTFUNDS];
	_msg = ["[BASE] First time initialization detected, adding default value of", FACTORY_STARTFUNDS, "to creation factory."] joinString " ";
	systemChat _msg;
} else {
	stowwe_factory setVariable ["stowwe_logi_credits", _val];
};

[stowwe_factory] call stowwe_logi_updateBalanceView;

while {true} do {
	_turnover = FACTORY_TURNOVER * 60;

	sleep _turnover;
	_current = stowwe_factory getVariable "stowwe_logi_credits";
	_current = _current + FACTORY_ALLOWANCE;


	//save the credits on each turnover of the allowance.
	stowwe_factory setVariable ["stowwe_logi_credits", _current, true];
	["logicredits", _current] call ALiVE_fnc_ProfileNameSpaceSave;
	[stowwe_factory] call stowwe_logi_updateBalanceView;

	_msg = (["[BASE]", FACTORY_ALLOWANCE, "Credits have been added to the factory, totalling", _current, "credits."] joinString " ");
	systemChat _msg;

};
