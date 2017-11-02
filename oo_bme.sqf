﻿	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016-2018 Nicolas BOITEUX

	CLASS OO_BME
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>. 
	*/

	#include "oop.h"

	CLASS("OO_BME")
		PRIVATE VARIABLE("array","sendspawnqueue");
		PRIVATE VARIABLE("array","receivespawnqueue");
		PRIVATE VARIABLE("array","sendcallqueue");
		PRIVATE VARIABLE("array","receivecallqueue");
		PRIVATE VARIABLE("scalar","transactid");
		
		PUBLIC FUNCTION("","constructor") {
			MEMBER("sendspawnqueue", []);
			MEMBER("receivespawnqueue", []);
			MEMBER("sendcallqueue", []);
			MEMBER("receivecallqueue", []);
			MEMBER("transactid", 0);

			["runReceiveCallQueue", 0.1] spawn _self;
			["runReceiveSpawnQueue", 0.1] spawn _self;
			["runSendCallQueue", 0.1] spawn _self;
			["runSendSpawnQueue", 0.1] spawn _self;
		};

		//  Entry function for remote spawn
		PUBLIC FUNCTION("array","remoteSpawn") {
			private _remotefunction 	= _this select 0;
			private _parameters 		=  _this select 1;
			private _destination		= tolower(_this select 2);
			private _targetid 		= _this select 3;
			
			if!(_remotefunction isEqualType "") exitwith { MEMBER("log", "BME: wrong type variablename parameter, should be STRING"); false; };
			if(isnil "_parameters") exitwith { MEMBER("log", format["BME:  parameters data for %1 handler is nil", _remotefunction]); false; };
			if!(_destination isEqualType "") exitwith { MEMBER("log", "BME: wrong type destination parameter, should be STRING"); false; };
			if!(_destination in ["client", "server", "all"]) exitwith {MEMBER("log", "BME: wrong destination parameter should be client|server|all"); false; };
			
			if(isNil "_targetid") then {
				MEMBER("sendspawnqueue", nil) pushBack [_remotefunction, _parameters, _destination];
			} else {
				MEMBER("sendspawnqueue", nil) pushBack [_remotefunction, _parameters, _destination, _targetid];
			};
			true;
		};

		// Entry function for remote call
		// Endpoint for loopback result
		PUBLIC FUNCTION("array","remoteCall") {
			private _remotefunction 	= _this select 0;
			private _parameters 		=  _this select 1;
			private _destination		= tolower(_this select 2);
			private _targetid 		= _this select 3;
			private _transactid 		= (MEMBER("transactid", nil) + 1);
			MEMBER("transactid", _transactid);
			
			if!(_remotefunction isEqualType "") exitwith { MEMBER("log", "BME: wrong type variablename parameter, should be STRING"); false; };
			if(isnil "_parameters") exitwith { MEMBER("log", format["BME:  parameters data for %1 handler is nil", _remotefunction]); false; };
			if!(_destination isEqualType "") exitwith { MEMBER("log", "BME: wrong type destination parameter, should be STRING"); false; };
			if!(_destination in ["client", "server"]) exitwith {MEMBER("log", "BME: wrong destination parameter should be client|server"); false; };
			if(_destination isEqualTo "server") then { _targetid = 0;};
			if(isNil "_targetid") exitwith {MEMBER("log", "BME: Client targetID must be define"); false; };
			
			MEMBER("sendcallqueue", nil) pushBack [_remotefunction, _parameters, _destination, clientOwner, _targetid, _transactid];
			while { (bme_answer select 1) isEqualTo _transactid } do { sleep 0.1;};
			bme_answer select 0;
		};

		// function call by addPublicVariableEventHandler
		// insert message in call queue for server / client
		// _function = _this select 0;
		// _parameters = _this select 0;
		// _destination = _this select 2;	
		// _sourceid = _this select 3;
		// _targetid = _this select 4;
		//_transactid = _this select 5;
		PUBLIC FUNCTION("array","addReceiveCallQueue") {
			diag_log format ["%1", _this];
			// insert message in the queue if its for server
			if((isserver) and ((_this select 2) isEqualTo "server")) then {
				MEMBER("receivecallqueue", nil) pushBack _this;
			};
			
			// insert message in the queue if its for specific client
			if((local player) and ((_this select 2) isEqualTo "client")) then {	
				MEMBER("receivecallqueue", nil) pushBack _this;
			};
		};
		
		// function call by addPublicVariableEventHandler
		// insert message in spawn queue for server / client / all
		// _destination = _this select 2;
		PUBLIC FUNCTION("array","addReceiveSpawnQueue") {
			diag_log format ["%1", _this];
			if((isserver) and (((_this select 2) isEqualTo "server") or ((_this select 2) isEqualTo "all"))) then {
				MEMBER("receivespawnqueue", nil) pushBack [_this select 0, _this select 1, "server", _this select 3, _this select 4];
			};
			
			// insert message in the queue if its for client or everybody
			// _destination = _this select 2;
			if((local player) and (((_this select 2) isEqualTo "client") or ((_this select 2) isEqualTo "all"))) then {	
				MEMBER("receivespawnqueue", nil) pushBack [_this select 0, _this select 1, "client", _this select 3, _this select 4];
			};
		};

		// send a loopback result
		// should be rewrite with a pool for transactif / stream feature
		PUBLIC FUNCTION("array","loopBack") {
			bme_answerqueue = [_this select 1, _this select 2];
			(_this select 0) publicVariableClient "bme_answerqueue";
		};

		// unpop queue of call receive messages
		// execute the corresponding code
		PUBLIC FUNCTION("scalar","runReceiveCallQueue") {
			private _parsingtime = _this;
			private _message = [];
			private _remotefunction = "";
			private _parameters = "";
			private _destination = "";
			private _sourceid = 0;
			private _targetid = 0;
			private _transactid = 0;
			private _code = nil;
			private _array = [];

			while { true } do {
				_message = MEMBER("receivecallqueue", nil) deleteAt 0;
				if(!isnil "_message") then {
					_remotefunction	= _message select 0;
					_parameters		= _message select 1;
					_destination 		= _message select 2;
					_sourceid		= _message select 3;
					_targetid		= _message select 4;
					_transactid		= _message select 5;
					_code 			= nil;
					
					if(isNil "_sourceid") then { 
						MEMBER("log", format["BME: call remote function without playerid for loopback %1", _remotefunction]);
						_sourceid = 0;
					};
					//Debug time - should be delete later
					diag_log format ["log: %1", _message];

					if(isserver and (_destination isEqualTo "server")) then {
						_code = (missionNamespace getVariable (format ["BME_netcode_server_%1", _remotefunction]));
						if!(isnil "_code") then {
							_array =  [_transactid, _sourceid, (_parameters call _code)];
							MEMBER("loopBack", _array);
						} else {
							MEMBER("log", format["BME: server handler function for %1 doesnt exist", _remotefunction]);
						};
					};

					if(local player and (_targetid isEqualTo clientOwner) and (_destination isEqualTo "client")) then {
						_code = (missionNamespace getVariable (format ["BME_netcode_client_%1", _remotefunction]));
						if!(isnil "_code") then {
							_array =  [_transactid, _sourceid, (_parameters call _code)];
							MEMBER("loopBack", _array);
						} else {
							MEMBER("log", format["BME: client handler function for %1 doesnt exist", _remotefunction]);
						};
					};
				};
				sleep _parsingtime;
			};
		};		

		// unpop queue of spawn receive messages
		// execute the corresponding code
		// return nothing
		PUBLIC FUNCTION("scalar","runReceiveSpawnQueue") {
			private _parsingtime = _this;
			private _message = [];
			private _remotefunction = "";
			private _parameters = "";
			private _destination = "";
			private _targetid = 0;
			private _code = nil;

			while { true } do {
				_message = MEMBER("receivespawnqueue", nil) deleteAt 0;
				if(!isnil "_message") then {
					_remotefunction	= _message select 0;
					_parameters		= _message select 1;
					_destination 		= _message select 2;
					_targetid		= _message select 3;
					_code 			= nil;
					
					if (isNil "_targetid") then { _targetid = 0;};
					//Debug time - should be delete later
					diag_log format ["log: %1", _message];

					if(isserver and ((_destination isEqualTo "server") or (_destination isEqualTo "all"))) then {
						_code = (missionNamespace getVariable (format ["BME_netcode_server_%1", _remotefunction]));
						if!(isnil "_code") then {
							_parameters spawn _code;
						} else {
							MEMBER("log", format["BME: server handler function for %1 doesnt exist", _remotefunction]);
						};
					};

					if(local player and (_targetid isEqualTo owner player) and ((_destination isEqualTo "client") or (_destination isEqualTo "all"))) then {
						_code = (missionNamespace getVariable (format ["BME_netcode_client_%1", _remotefunction]));
						if!(isnil "_code") then {
							_parameters spawn _code;
						} else {
							MEMBER("log", format["BME: client handler function for %1 doesnt exist", _remotefunction]);
						};
					};
				};
				sleep _parsingtime;
			};
		};

		// unpop queue of call send messages
		// execute the corresponding code
		PUBLIC FUNCTION("scalar","runSendCallQueue") {
			private _parsingtime = _this;
			private _destination = "";
			while { true } do {
				bme_addqueue = MEMBER("sendcallqueue", nil) deleteAt 0;
				if(!isnil "bme_addqueue") then {
					switch (bme_addqueue select 2) do {
						case "server": { publicvariableserver "bme_addqueue"; };
						case "client": {
							if!((bme_addqueue select 3) isEqualTo (bme_addqueue select 4)) then{
								(bme_addqueue select 3) publicvariableclient "bme_addqueue";
							} else {
								if((local player) and (isserver)) then { MEMBER("addReceiveQueue", bme_addqueue);	};
								publicvariable "bme_addqueue";
							};
						};
						default { };
					};
				};
				sleep _parsingtime;
			};
		};

		// unpop queue of spawn send messages
		// execute the corresponding code
		PUBLIC FUNCTION("scalar","runSendSpawnQueue") {
			private _parsingtime = _this;
			while { true } do {
				bme_addqueue = MEMBER("sendspawnqueue", nil) deleteAt 0;		
				if(!isnil "bme_addqueue") then {
					switch (bme_addqueue select 2) do {
						case "server": { publicvariableserver "bme_addqueue"; };

						case "client": {
							if(count bme_addqueue > 3) then {
								(bme_addqueue select 3) publicvariableclient "bme_addqueue";
							} else {
								if((local player) and (isserver)) then { MEMBER("addReceiveQueue", bme_addqueue);	};
								publicvariable "bme_addqueue";
							};
						};

						default {
							if(isserver) then {
								if!(local player) then { publicvariableserver "bme_addqueue"; };
							} ;
							if(local player) then { MEMBER("addReceiveQueue", bme_addqueue);	};
							publicvariable "bme_addqueue";
						};
					};
				};
				sleep _parsingtime;
			};
		};

		PUBLIC FUNCTION("string","log") {
			hint format["%1", _this];
			diag_log format["%1", _this];
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("sendspawnqueue");
			DELETE_VARIABLE("receivespawnqueue");
		};
	ENDCLASS;