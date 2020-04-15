params ["_ply"];
_id = getPlayerUID _ply;

_whitelist = [
"76561198025627975",	//SPR CO - Dodds
"76561198069335401",	//SPR XO - DoubleA

"76561197983395630",	//3ID CO - Ronin
"76561197989531615",	//3ID XO - Jebudiah

"76561198021843132",	//MEU CO - Refoogee
"76561197985157882",	//MEU XO - MacMerritt
"76561198091180252",	//MEU NC - Elk

"76561198027365826",	//AVI CO - Cannon
"76561198004211060",	//AVI XO - seven10

"76561198300877325",	//Nate
"_SP_PLAYER_", //debug
"_SP_AI_"
];

_id in _whitelist
