// void, Obj This, Obj Other

Unit  this;
Ship  ship;
point pt;
int   time;
int   dist;

this = This.AsUnit;

ship = Other.AsShip;
pt = ship.pos;
time = 0;
while( 1 )
{
	if( .DistTo(pt) > 500)
		{ if( .Goto( pt, 120, 2000, true, -1 )) Sleep( 100 ); }
	else
		{ if( .GotoEnter( pt, 120, 2000, true, -1 )) Sleep( 100 ); }
  if (!ship.IsAlive) return;
	time += 2000;
	dist = Dist( .posRH, ship.pos );
	if( ( dist > 4000 && time > 12000 ) ||
		( dist > 2000 && time > 8000 ) ||
		( dist > 1000 && time > 4000 ) ||
		( dist < 500 ))
	{
		pt = ship.pos;
		time = 0;
	}
	if( ship.BoardUnit( this )) return;
	if( ship.UnitsCount == ship.UnitsMax ) return;
	if( ship.NumUnitsToBoard == 0 ) return;
}