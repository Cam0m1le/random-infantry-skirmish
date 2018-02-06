/*
	Function:
	RSTFGC_fnc_attach

	Description:
	Attaches garbage collector to specificed object. Once the object is uselees, it'll be enqueued for deletion.

	Parameter(s):
	_object - object to be watched [Object]
	_cleanDelay - removal delay in seconds [Scalar, defaults to 30]
	_vehicle - is object vehicle, improves obsoleteness detection [Boolean, defaults to false]

	Author:
	Jan Zípek
*/

private _object = param [0];
private _cleanDelay = param [1, 30];
private _vehicle = param [2, false];

_object setVariable ["GC_delay", _cleanDelay];
_object setVariable ["GC_queued", false];
_object setVariable ["GC_vehicle", _vehicle];

if (_vehicle) then {
	RSTFGC_TRACKED pushBack _object;

	// @TODO: How much performance does this require?
	// _object addEventHandler ["Dammaged", RSTFGC_fnc_dammaged];
};

_object addEventHandler ["Killed", RSTFGC_fnc_killed];

_object;