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

	// only for debug purpose
	profilenamespace setvariable ["BIS_fnc_init_displayErrors",true];

	_bmeclient = NEW(OO_BME, nil);

	// First Example - remoteCall - synchronous call
	if(local player) then {
		private _count = 0;
		while {_count < 10} do {
			_result= ["remoteCall", ["getServerName",  (name player), 2, "nothing"]] call _bmeclient;
			hint format ["RemoteCall from client: %1", _result];
			_count = _count + 1;
			sleep 1;
		};
	};

	// Second Example - remoteSpawn - asynchronous call
	if(local player) then {
		private _count = 0;
		while {_count < 10} do {
			_message = "hello server, remoteSpawn message send from client";
			["remoteSpawn", ["sendServerMessage", _message, "server"]] call _bmeclient;
			_count = _count + 1;
			sleep 1;
		};
	};

	// Third Example - remotespawn - asynchronous call from server to client
	if(isserver) then {
		private _count = 0;
		while {_count < 10} do {
			_message = "hello client, message send from server";
			["remoteSpawn", ["sendClientMessage", _message, "client"]] call _bmeclient;
			_count = _count + 1;
			sleep 1;
		};
	};