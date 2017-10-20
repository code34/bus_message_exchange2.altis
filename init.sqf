	call compilefinal preprocessFileLineNumbers "BME\init.sqf";

	if(local player) then {
		_log = "hello server, message send from client";
		["tologonserver", _log, "server"] call BME_fnc_publicvariable;
		sleep 2;
	};

	if(isserver) then {
		while {true} do {
			_message = "hello client, message send from server";
			["tohintonclient", _message, "client"] call BME_fnc_publicvariable;
			sleep 2;
		};
	};
