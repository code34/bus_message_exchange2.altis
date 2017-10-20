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

	private ["_code", "_destination", "_garbage", "_message", "_variable", "_handlername", "_parsingtime"];

	_parsingtime = _this;

	while { true } do {
		bme_addqueue = bme_send_queue deleteAt 0;
		if(!isnil "bme_addqueue") then {
			_destination 	= bme_addqueue select 2;
			switch (_destination) do {
				case "server": {
					publicvariableserver "bme_addqueue";
				};

				case "client": {
					if(count bme_addqueue > 3) then {
						(bme_addqueue select 3) publicvariableclient "bme_addqueue";
					} else {
						if((local player) and (isserver)) then {
							bme_addqueue call BME_fnc_addqueue;
						};
						publicvariable "bme_addqueue";
					};
				};

				default {
					if(isserver) then {
						if!(local player) then {
							publicvariableserver "bme_addqueue";
						};
					} ;
					if(local player) then {
						bme_addqueue call BME_fnc_addqueue;
					};
					publicvariable "bme_addqueue";
				};
			};
		};
		sleep _parsingtime;
	};

