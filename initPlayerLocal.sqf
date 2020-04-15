//fuck the default loadouts

player addEventHandler ["KILLED",{
	PLAYERGEAR = [objNull, [_this select 0]] call ALiVE_fnc_setGear;
}];
player addEventHandler ["RESPAWN", {
	[] spawn {waituntil {!isnull player};
		_hdl = [objNull, [player,PLAYERGEAR]] spawn ALiVE_fnc_getGear;
		sleep 3;
		titleText ["", "PLAIN"];
	};
}];
player addItem "ItemMap";
