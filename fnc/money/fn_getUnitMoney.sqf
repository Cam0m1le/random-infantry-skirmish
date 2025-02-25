/*
	Function:
	RSTF_fnc_getUnitMoney

	Description:
	Fetches money for unit specified by it's ID

	Parameter(s):
	_id - unit id [String]

	Returns:
	Money of unit [Number]
*/
private _id = param [0];
RSTF_MONEY getOrDefault [_id, RSTF_MONEY_START];
