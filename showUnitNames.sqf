_crew = crew (vehicle player);
_viewDistance = 0.6 * viewDistance;
 
{
    if ((_x != player) and { (_x distance player) <= _viewDistance } and { (side _x) == playerSide }
        and { !(_x in _crew) }) then {
        _position = getPosASLVisual _x;
 
        _position set [2, ((eyePos _x) select 2) + 0.5];
 
        drawIcon3D ["", [1, 1, 1, 1], ASLToAGL _position, 0, 0, 0, name _x, 2];
    };
} forEach allPlayers;