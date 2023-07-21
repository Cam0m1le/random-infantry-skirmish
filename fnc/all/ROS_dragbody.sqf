/*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ROS_DragBody.sqf v 1.4 by RickOShay

Legal stuff:
============
Full credit must be given in missions that make use of this script or derivative work if shared either
publicly or privately in any way including the Steam Workshop.

Features:
=========
* Adds the ability in MP games where vanilla revive is enabled to drag incapacitated players to safety
* Works with the vanilla BIS revive system. (not ace)

REQUIRED MODS:
==============
None

INSTRUCTIONS:
=============
Place the following line in your init.sqf

[] execvm "scripts\ROS_dragbody.sqf";

*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if (!isMultiplayer) exitWith {};

waitUntil {player == player};

if (isnil "MPRespawnEHadd") then {MPRespawnEHadd = false};

// Discourage attempts to revive on attach
/*_hurtunit = objNull;
waituntil {!IsNull (findDisplay 46)};
(findDisplay 46) displayAddEventHandler ["KeyDown", {
	params ["_display","_key"];
	_hurtunit = attachedObjects player select 0;
	if (!isNull _hurtunit && _hurtunit in allPlayers) then {
		if (_key == 57) then {
			hint "Do not try and revive while dragging!";
		};
	};
}];*/

// Drag and drop functions
ROS_drag_fnc = {
	params ["_hurtunit"];
	player setVariable ["dragging",true,true];
	_rankp = rank player +" "+ toupper name player;
	_ranku = rank _hurtunit +" "+ toupper name _hurtunit;
	[format ["%1\nis attempting to revive\n%2", _rankp, _ranku]] remoteExec ["hint",0,true];
	[_hurtunit, player] remoteExecCall ["disablecollisionwith", 0, _hurtunit];
	// Back of head
	_attachPos = _hurtunit modelToWorld [0,1.6,0];
	_pos = (_hurtunit modelToWorld _attachpos);
	[player, "grabDrag"] remoteExec ["playAction", 0];
	_hurtunit attachTo [player,[0, 1.04, 0.04]];
	_hurtunit setVariable ["dragged",true,true];
	[_hurtunit, 180] remoteExec ["setDir", 0];
	[_hurtunit, "AinjPpneMrunSnonWnonDb_grab"] remoteExec ["switchMove", 0];
	player forceWalk true;
	// Add release action to hurt unit
	ROS_dropAct = _hurtunit addaction ["<t color='#FFAF00'>RELEASE BODY</t>",{
		params ["_target", "_caller", "_actionId", "_arguments"];
		_target removeAction _actionId;
		[_target] spawn ROS_Release_fnc;
	},[],6,true,false,"","player == (attachedTo _target) && alive _target"];

	// Player is incap or dies while dragging
	[_hurtunit] spawn {
		params ["_hurtunit"];
		while {player getVariable "dragging" && _hurtunit getVariable "dragged"} do {
			if (!alive player or lifestate player == "INCAPACITATED") then {
				detach _hurtunit;
				player forceWalk false;
				[_hurtunit, "unconsciousrevivedefault"] remoteExec ["switchMove", 0];
				//[_hurtunit, player] remoteExecCall ["enablecollisionwith", 0, _hurtunit];
				_hurtunit removeAction ROS_dropAct;
				_hurtunit setVariable ["dragged",false,true];
				player setVariable ["dragging",false,true];
			};
			if (!alive _hurtunit && alive player) then {
				[player,""] remoteExec ["switchMove", player];
				[_hurtunit, "unconsciousrevivedefault"] remoteExec ["switchMove", 0];
				_hurtunit removeAction ROS_dropAct;
				[player, ""] remoteExec ["switchMove", 0];
				player forceWalk false;
				_hurtunit setVariable ["dragged",false,true];
				player setVariable ["dragging",false,true];
				[""] remoteExec ["hint",0,true];
			};
			sleep 1;
		};
	};
	// HU revived or dies
	[_hurtunit] spawn {
		params ["_hurtunit"];
		waitUntil {_hurtunit getVariable "dragged" && (lifeState _hurtunit == "HEALTHY" or !alive _hurtunit)};
		if (lifeState _hurtunit == "HEALTHY") then {
			[format ["%1\nrevived by\n%2",rank _hurtunit +" "+ toUpper name _hurtunit, rank player +" "+ toUpper name player]] remoteExec ["hint",0,true];
		};
	};
};

ROS_Release_fnc = {
	params ["_hurtunit"];
	player forceWalk false;
	[_hurtunit, "AinjPpneMstpSnonWrflDb_release"] remoteExec ["switchmove", 0];
	detach _hurtunit;
	[player, "released"] remoteExec ["playActionNow",0,true];
	sleep 0.6;
	[_hurtunit, "unconsciousrevivedefault"] remoteExec ["switchMove", 0];
	[_hurtunit, player] remoteExecCall ["enablecollisionwith", 0, _hurtunit];
	_hurtunit setVectorUp surfaceNormal position _hurtunit;
	[""] remoteExec ["hint",0,true];
	_hurtunit removeAction ROS_dropAct;
	_hurtunit setVariable ["dragged",false,true];
	player setVariable ["dragging",false,true];
};

/////////////////////////////////////////////////////////////////////////////////////////

if (isnil "ROS_dragActAdded") then {
	ROS_dragAct = player addaction ["<t color='#FFAF00'>DRAG BODY</t>",{
		params ["_target", "_caller", "_actionId", "_arguments"];
		[cursorobject] spawn ROS_drag_fnc;
	},[],20,true,false,"","player distance cursorObject <2.2 && lifestate cursorObject == 'INCAPACITATED' && animationState cursorObject == 'unconsciousrevivedefault' && abs ([getPos player, getDir player] call BIS_fnc_terrainGradAngle)<6"];
		ROS_dragActAdded = true;
};

if (!MPRespawnEHadd) then {
	player addMPEventHandler ["MPRespawn", {
		ROS_dragAct = player addaction ["<t color='#FFAF00'>DRAG BODY</t>",{
			params ["_target", "_caller", "_actionId", "_arguments"];
			[cursorobject] spawn ROS_drag_fnc;
		},[],20,true,false,"","player distance cursorObject <2.2 && lifestate cursorObject == 'INCAPACITATED' && animationState cursorObject == 'unconsciousrevivedefault' && abs ([getPos player, getDir player] call BIS_fnc_terrainGradAngle)<6"];
	}];
	MPRespawnEHadd = true;
};

