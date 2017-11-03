		call compile preprocessFileLineNumbers "oo_bme.sqf";
		call compile preprocessFile "BME_clienthandler.sqf";
		call compile preprocessFile "BME_serverhandler.sqf";

		sleep 2;

		global_bme = "new" call OO_BME;	

		if(local player) then {
			while {true} do {
				_result= ["remoteCall", ["getServerName",  name player, "server"]] call global_bme;
				hint format ["result: %1", _result];
				sleep 2;
			};
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

		//if(local player) then {
		//	sleep 10;
		//	while {true} do {
		//		_message = "hello server, message send from client";
		//		_answer = ["remoteCall", ["hint", _message, "server", clientOwner]] call global_bme;
		//		hintc format ["answer %1", _answer];
		//		sleep 2;
		//	};
		//};

		//if(isserver) then {
		//	while {true} do {
		//		_message = "hello client, message send from server";
		//		["remoteSpawn", ["hint", _message, "client"]] call global_bme;
		//		sleep 2;
		//	};
		//};