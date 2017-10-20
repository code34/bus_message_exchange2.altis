	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2013-2018 Nicolas BOITEUX

	Bus Message Exchange (BME)
	
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

	private ["_garbage", "_parsingtime"];

	BME_fnc_receivequeue	= compilefinal preprocessFile "BME\BME_receivequeue.sqf";
	BME_fnc_sendqueue		= compilefinal preprocessFile "BME\BME_sendqueue.sqf";
	BME_fnc_eventhandler		= compilefinal preprocessFile "BME\BME_eventhandler.sqf";
	BME_fnc_log			= compilefinal preprocessFile "BME\BME_log.sqf";
	BME_fnc_clienthandler		= compilefinal preprocessFile "BME\BME_clienthandler.sqf";

	_parsingtime = 0.01;

	if(isserver) then {
		BME_fnc_serverhandler = compilefinal preprocessFile "BME\BME_serverhandler.sqf";
		bme_queue = [];
		bme_send_queue = [];
		
		_garbage = [] call BME_fnc_eventhandler;
		_garbage = [] call BME_fnc_serverhandler;
		_garbage = _parsingtime spawn BME_fnc_receivequeue;
		_garbage = _parsingtime spawn BME_fnc_sendqueue;
	};
	
	if((local player) and !(isserver)) then {
		bme_queue = [];
		bme_send_queue = [];

		_garbage = [] call BME_fnc_eventhandler;
		_garbage = _parsingtime spawn BME_fnc_receivequeue;
		_garbage = _parsingtime spawn BME_fnc_sendqueue;
	};

	if(local player) then {
		_garbage = [] call BME_fnc_clienthandler;
	};