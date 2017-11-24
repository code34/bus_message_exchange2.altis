	/*
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
	
	call compile preprocessFileLineNumbers "oo_bme.sqf";
	call compile preprocessFileLineNumbers "example.sqf";

	sleep 2;

	bmeclient = NEW(OO_BME, nil);

	if(local player) then {
		[] spawn { 
			while {true} do {
				_result= ["remoteCall", ["getServerName",  (name player), 2, "nothing"]] call bmeclient;
				hint format ["RemoteCall: %1", _result];
				sleep 1;
			};
		};
	};

	if(local player) then {
		[] spawn { 
			while {true} do {
				_message = "hello server, message send from client";
				["remoteSpawn", ["sendServerMessage", _message, "server"]] call bmeclient;
				sleep 3;
			};
		};
	};

	if(isserver) then {
		while {true} do {
			_message = "hello client, message send from server";
			["remoteSpawn", ["sendClientMessage", _message, "client"]] call bmeclient;
			sleep 4;
		};
	};