		call compilefinal preprocessFileLineNumbers "oo_bme.sqf";
		call compilefinal preprocessFile "BME_clienthandler.sqf";
		call compilefinal preprocessFile "BME_serverhandler.sqf";

		global_bme = "new" call OO_BME;

		"bme_addqueue" addPublicVariableEventHandler {
			["addReceiveQueue", _this select 1] call global_bme;
		};

		if(local player) then {
			while {true} do {
				_message = "hello server, message send from client";
				["remoteSpawn", ["hint", _message, "server"]] call global_bme;
				sleep 2;
			};
		};

		if(isserver) then {
			while {true} do {
				_message = "hello client, message send from server";
				["remoteSpawn", ["hint", _message, "client"]] call global_bme;
				sleep 2;
			};
		};