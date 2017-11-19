		call compile preprocessFileLineNumbers "oo_bme.sqf";
		call compile preprocessFile "example.sqf";

		sleep 2;

		global_bme = "new" call OO_BME;	


		/*
			For better understanding the 3 remote functions above were declared into the example.sqf file
		*/


		if(local player) then {
			[] spawn { 
				while {true} do {
					_result= ["remoteCall", ["getServerName",  name player, "server"]] call global_bme;
					hint format ["RemoteCall: %1", _result];
					sleep 2;
				};
			};
		};


		if(local player) then {
			[] spawn { 
				while {true} do {
					_message = "hello server, message send from client";
					["remoteSpawn", ["sendServerMessage", _message, "server"]] call global_bme;
					sleep 2;
				};
			};
		};

		if(isserver) then {
			while {true} do {
				_message = "hello client, message send from server";
				["remoteSpawn", ["sendClientMessage", _message, "client"]] call global_bme;
				sleep 2;
			};
		};