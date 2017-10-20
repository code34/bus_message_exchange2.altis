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

	Create a main bus message between clients & server
	
	Usage:
		put the directory BEM in your mission directory
		put this code into your mission init.sqf
		call compilefinal preprocessFileLineNumbers "BME\init.sqf";

	See example mission in directory: bus_exchange_message.Altis
	
	Licence: 
	You can share, modify, distribute this script but don't remove the licence and the name of the original author

	logs:
		0.3 - Fix:
			- fix mp handler call
			- fix reset code
		0.2 - Fix:
			- add performance improvement of @Prodavec
			- add private variable declaration
			- fix iteration call
			- add logs 
			- change calling line
		0.1 - BUS message Exchange original from A2 - Warcontext