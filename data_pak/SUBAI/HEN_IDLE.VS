// void, Obj This

Unit        this;
int         setIdx, maxSetIdx, dist, maxDist, x, y, try;
Settlement  set, maxSet;
point       center, pt, pt2;
bool        bSleep, bWalked;

this = This.AsUnit;

maxDist = 2000000;
maxSetIdx = MaxSetIdx();
for( setIdx = 0; setIdx < maxSetIdx; setIdx += 1 )
{
	Sleep(10);
	set = IdxToSet( setIdx );
	if( ! set.IsValid ) continue;
	if( ! set.IsVillage ) continue;
	dist = .DistTo( set.GetCentralBuilding.pos );
	if( dist < maxDist )
	{
		maxDist = dist;
		maxSet = set;
	}
}
center = maxSet.GetCentralBuilding.pos;
Sleep( rand( 1000 ));
bWalked = false;
while( 1 )
{
	bSleep = true;
	if( rand( 20 ) < 4 && ! bWalked )
	{
		if( maxSet.IsValid && Dist( .pos, center ) > 600 )
			pt = GetVecByDir( .pos - center, 500 ) + center;
		else
			pt = .pos;
		for( try = 0; try < 5; try += 1 )
		{
			pt2 = pt + RandomOffset(200);
			if( IsPassable3x3( pt2 )) break;
		}
		if( try < 5 )
			while( ! .Goto( pt2, 0, 2000, true, -1 )) bSleep = false;
		if( bSleep ) Sleep( 2000 );
		bWalked = true;
	}
	else
	{
		bWalked = false;
		pt2 = .pos + RandomOffset(20);
		if( pt2.x == .pos.x && pt2.y == .pos.y ) pt2.Set( 10, 10 );
		.Face( pt2 );
		.ForceIdle();
		.Idle( 2000 );
	}
}