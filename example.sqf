	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2013-2018 Nicolas BOITEUX

	Bus Message Exchange (BME)
	Example file only containing example function that could be your own code
	
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

	Usage: 
		remotefunction = { code to execute };
	*/

	sendClientMessage = {
		hint format["BME: client side: %1", _this];
		diag_log format["BME: client side: %1", _this];
	};

	sendServerMessage = {
		hint format["BME: server side: %1", _this];
		diag_log format["BME: server side: %1", _this];
	};

	getServerName = {
		if(isNil "counterserver") then { counterserver = 0;};
		counterserver = counterserver + 1;
		format ["hello %1, my name is server%2 and i return you a result", _this, counterserver];
	};