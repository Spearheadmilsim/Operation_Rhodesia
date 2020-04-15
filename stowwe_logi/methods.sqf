// Nathan Stowwe
// Arma 3 Lightweight Logistics
// Methods
// 6-April-2020

/* Update the balance action view
 * 0 - The factory to update on
 */
stowwe_logi_updateBalanceView = {
	params ["_factory"];
	_action = _factory getVariable ["stowwe_logi_balAction", -1];

	_bal = _factory getVariable "stowwe_logi_credits";

	_factory removeAction _action;

	_nam = "";
	if (_bal >= 0) then {
		_nam = ["<t color='", call stowwe_logi_var_balanceColor, "'>Balance: ", _bal, "</t>"] joinString "";
	};
	if (_bal < 0) then {
		_nam = ["<t color='", call stowwe_logi_var_balanceColor, "'>Balance: Infinite</t>"] joinString "";
	};
	_action = _factory addAction [
	_nam,
	{},
	[],	// args to pass to the script.
	502,		// priority in the list. Try to keep this in the order of the whitelist. This number is arbitrary.
	false,		// show in center of window, not needed.
	true,		// hide on use, vanity.
	"",			// key to actiavte, not needed.
	"true",		// _target, _this
	call stowwe_logi_var_interactionRange			// radius in which it'll show up.
	];
	_factory setVariable ["stowwe_logi_balAction", _action];
};

/* Adds an object to the factory
 * 0 - The object to add, as its classname
 * 1 - The price of the object
 * 2 - The varname of the factory
 */
stowwe_logi_addObject = {
	params ["_object", "_price", "_factory"];

	_name = getText (configFile >> "cfgVehicles" >> _object >> "displayName");

	_priority = (_factory getVariable "stowwe_logi_numObjects");

	_factory addAction
	[
	(["<t color='", call stowwe_logi_var_buyColor, "'>Spawn ", _name, " (", _price, " credits)</t>"] joinString ""),
	{
		_object = _this select 3 select 0;
		_price = _this select 3 select 1;
		_factory = _this select 3 select 2;

		_cond = (_factory getVariable "stowwe_logi_condition");

		params ["_target", "_caller"];
		_clause = call compile _cond;

		if(!_clause) exitWith {};

		_balance = _factory getVariable "stowwe_logi_credits";
		_loc = _factory getVariable "stowwe_logi_marker";
		_azi = _factory getVariable "stowwe_logi_azimuth";

		if(_price > _balance && _balance >= 0) exitWith {};

		_vic = _object createVehicle (getMarkerPos _loc);
		_vic setdir _azi;
		[_vic, _caller] call compile preprocessFile "stowwe_logi\postSpawn.sqf";

		if(_balance >= 0) then {
			_balance = _balance - _price;
			_factory setVariable ["stowwe_logi_credits", _balance];
			[_factory] call stowwe_logi_updateBalanceView;
		};
	},
	[_object, _price, _factory],	// args to pass to the script.
	_priority,	// priority in the list. Try to keep this in the order of the whitelist.
	false,		// show in center of window, not needed.
	true,		// hide on use, vanity.
	"",			// key to actiavte, not needed.
	"true",		// _target, _this
	call stowwe_logi_var_interactionRange	// radius in which it'll show up.
	];

	_factory setVariable ["stowwe_logi_numObjects", _priority - 1];
};

/* Initialize a factory on an object.
 * 0 - The object to initialize the factory on.
 * 1 - The credits to start with. Set to anything below 0 for infinite.
 * 2 - A 2-D array of objects to spawn, with the first object being the name as
 * a strong, and the second being the cost as an integer.
 * 3 - A condition that must be true to allow some unit to use the factory, as
 * a string. The unit can be referenced with '_this', and the factory with '_target'
 * IMPORTANT: REPLACE ANY QUOTATION MARKS WITH APOSTROPHES, ELSE IT WILL BREAK THE SCRIPT!
 * 4 - The marker VARIABLE NAME (Not marker text!) to spawn the vehicle at, as a string.
 * 5 - The azimuth (rotation from 0* North clockwise) to spawn the vehicle at, as a number.
 * 6 - A friendly name for the factory
 */
stowwe_logi_initFactory = {
	params ["_factory", "_credits", "_whitelist", "_condition", "_marker", "_azi", "_name", "_debug"];


	// A: Pre-init sanity checks
	// 0 - Factory object
	if (typeName _factory != "OBJECT" || typeOf _factory == "") exitWith {
		hint (["ERROR: Factory with var name '", _factory, "' does not seem to be an object (or exist?)."] joinString "");
	};

	if (_factory getVariable "stowwe_logi_isFactory") then {
		if(_debug) then {
			//continue on
		} else {
			hint ("ERROR: Factory is already initialized! Deinit it with [factory] call stowwe_logi_deInitFactory")
		};
	};

	// 1 - Credits
	if (typeName _credits != "SCALAR") exitWith {
		hint ("ERROR: The entered credits don't seem to be valid... The data type should be a number.")
	};

	// 2 - Whitelist
	if (typeName _whitelist != "ARRAY" && typeName (_whitelist select 0) != "ARRAY") exitWith {
		hint ("ERROR: The vehicle whitelist does not seem to be correct...")
	};

	// 3 - Condition
	if (typeName _condition != "STRING") exitWith {
		hint ("ERROR: The condition does not seem to be a string...")
	};

	// 4 - Location
	if (typeName _marker != "STRING" || (getMarkerType _marker) == "") exitWith {
		hint ("ERROR: The marker does not seem to be valid (or exist?)")
	};

	// 5 - Azimuth
	if (typeName _azi != "SCALAR") exitWith {
		hint ("ERROR: The azimuth does not seem to be a number...")
	};

	// 6 - Condition
	if (typeName _name != "STRING") exitWith {
		hint ("ERROR: The name does not seem to be a string...")
	};

	if (_debug) then {
		hint (["Factory with name '", _name, "' passed sanity checks!"] joinString "");
	};

	// B: set the vars in the object for easy access later
	_factory setVariable ["stowwe_logi_isFactory", true];
	_factory setVariable ["stowwe_logi_credits", _credits];
	_factory setVariable ["stowwe_logi_whitelist", _whitelist];
	_factory setVariable ["stowwe_logi_condition", _condition];
	_factory setVariable ["stowwe_logi_marker", _marker];
	_factory setVariable ["stowwe_logi_azimuth", _azi];
	_factory setVariable ["stowwe_logi_name", _name];
	_factory setVariable ["stowwe_logi_numObjects", 500];

	// C: Initialize actions on the factory
	_nam = ["<t color='", call stowwe_logi_var_nameColor, "'>", _name, "</t>"] joinString "";
	_factory addAction [_nam, {}, [], 503, false, true, "", "true", call stowwe_logi_var_interactionRange];
	// Let's first add an eventless action with a high priority with the balance
	[_factory] call stowwe_logi_updateBalanceView;
	// and now a line just below it for vanity
	_factory addAction ["--------------------", {}, [], 501, false, true, "", "true", call stowwe_logi_var_interactionRange];



	// D: Vehicle buys
	{
		_vic = _x select 0;
		_price = _x select 1;
		[_vic, _price, _factory] call stowwe_logi_addObject;
	} forEach _whitelist;

	hint "Complete!";

};

stowwe_logi_deInitFactory = {
	params ["_factory"];
	_factory setVariable ["stowwe_logi_isFactory", nil];
	_factory setVariable ["stowwe_logi_credits", nil];
	_factory setVariable ["stowwe_logi_whitelist", nil];
	_factory setVariable ["stowwe_logi_condition", nil];
	_factory setVariable ["stowwe_logi_marker", nil];
	_factory setVariable ["stowwe_logi_azimuth", nil];
	_factory setVariable ["stowwe_logi_name", nil];
	_factory setVariable ["stowwe_logi_numObjects", nil];
	_factory setVariable ["stowwe_logi_balAction", nil];
	removeAllActions _factory;

	"Successfully de-initialized this factory."
};

stowwe_logi_setCredits = {
	params ["_factory", "_credits"];
	_factory setVariable ["stowwe_logi_credits", _credits];
};
