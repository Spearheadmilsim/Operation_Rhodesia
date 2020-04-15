params ["_box"];
_box addAction  
[  
 "<t color='#96afff'>--Open ACE Virtual Arsenal--</t>",  
 {
   params ["_null", "_caller"]; 
   [_caller] call compile preprocessFile "scripts\arsenals\arsenal.sqf";
 },
 [],
 2,
 true,
 true,
 "",
 "true",
 10
];