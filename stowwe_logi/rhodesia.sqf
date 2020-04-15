params ["_funds"];
_whitelist = [

//Air
["ARMSCor_AlouetteIII_SF_Rhodesia_I", 5000],
["RSF_Aloutte", 5000],
["ARMSCor_AlouetteIII_KCAR_Rhodesia_I", 6000],
["CUP_I_SA330_Puma_HC1_RACS", 8000],
["CUP_I_UH1H_Slick_RACS", 10000],
["UNS_skymaster_CAS", 10000],
["RSF_Dekota", 10000],
["uns_ov10_usaf_CAS", 20000],
["uns_f100b_CAS", 50000],
["UNS_F111_D_CAS", 90000]

];

[
	stowwe_factory,					// The object to perform the action on
	_funds,							// The amount of credits to start with. A negative value will yield infinite credits!
	_whitelist,						// The vehicles to allow
	"_caller call compile preprocessFile 'stowwe_logi\logiWhitelist.sqf'",		// Script that must return true in order for a player to use this
	"vic_spawnpoint",				// The marker to spawn a vehicle at.
	0,							// The azimuth (degrees clockw	ise from North) to have the vehicle face
	"Rhodesia Air Vehicle Pool",		// A friendly name for the factory
	false							// Debug mode
] call stowwe_logi_initFactory;

_whitelist2 = [

//Ground
["CUP_C_Tractor_Old_CIV", 500],
["RSF_LandRover_Transport", 1000],
["RSF_LandRover_HMG", 1500],
["CUP_B_LR_Special_M2_GB_W", 2500],
["ARMSCor_Eland_90_SADF_I", 4500],
["RSF_MTVR_Ammo", 3000],
["RSF_MTVR_Refuel", 3000],
["RSF_MTVR_Repair", 3000],
["CFP_B_MLARMY_T34_01", 10000],
["CFP_B_MLARMY_T55_01", 25000]
];

[
	ramranch,
	-1,
	_whitelist2,
	"_caller call compile preprocessFile 'stowwe_logi\logiWhitelist.sqf'",
	"ramranchreallyrocks",
	245,
	"Rhodesia Ground Vehicle Pool",
	false
] call stowwe_logi_initFactory;
