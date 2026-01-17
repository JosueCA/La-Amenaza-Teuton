// void, Obj This, point pt

Flying  this;
point   vec, dir, newPos, straightDir, relativePos, newDir, middle;
int     angle, newAngle, straightAngle, animIdx, x, y, th, newZ, minHeight, maxHeight;
bool    bToward, bNewToward;

minHeight = 80;
maxHeight = 120;

this    = This.AsFlying;
dir     = .dir;
bToward = false;

x = pt.x;
y = pt.y;
if( x < 0 ) x = 0;
if( y < 0 ) y = 0;
if( x > MapSize()) x = MapSize();
if( y > MapSize()) y = MapSize();
pt.Set( x, y );

while( ! .IsInState ) Sleep( 50 );

.SetUser(0);

while( .DistTo( pt ) > 100 )
{
	angle = GetAngleByDir( dir );
	straightDir.Set( pt.x - .pos.x, pt.y - .pos.y );
	straightAngle = GetAngleByDir( straightDir );
// which side to rotate to (if not heading toward the target already)
	bNewToward = false;
	if( ! bToward )
	{
		relativePos.Set( pt.x - .pos.x, pt.y - .pos.y );
		if( OnLeft( dir, relativePos ))
		{
			newAngle = angle - 30;
			if( newAngle < 0 ) newAngle += 360;
			newDir = GetDirByAngle( newAngle );
			middle.Set( dir.x + newDir.x, dir.y + newDir.y );
			if( ! OnLeft( middle, relativePos )) bNewToward = true;
		}
		else
		{
			newAngle = angle + 30;
			newDir = GetDirByAngle( newAngle );
			middle.Set( dir.x + newDir.x, dir.y + newDir.y );
			if( OnLeft( middle, relativePos )) bNewToward = true;
		}
		if( newAngle < 0 ) newAngle += 360;
		if( bNewToward )
		{
			bToward = true;
			dir = straightDir;
		}
		else
		{
// rotate
			if (.IsInAir())
				vec = GetVecByDir( dir, 75 );
			else
				vec = GetVecByDir( dir, 120 );
			newPos.Set( .pos.x + vec.x, .pos.y + vec.y );
// correct z
			th = GetTerrainHeight( newPos );
			newZ = .z;
			if( th + minHeight > newZ )
				newZ = th + minHeight;
			if( th + maxHeight < newZ )
				newZ = th + maxHeight;

			if (.IsInAir())
				.PlayAnim( 0, newPos, newZ );
			else
				.PlayAnim(16, newPos, th+80);
			dir = GetDirByAngle( newAngle );
		}
	}
// fly straight to the target point
	if( bToward )
	{
		if (.IsInAir())
			vec = GetVecByDir( dir, 75 );
		else
			vec = GetVecByDir( dir, 120 );
		newPos.Set( .pos.x + vec.x, .pos.y + vec.y );
// correct z
		th = GetTerrainHeight( newPos );
		newZ = .z;
		if( th + minHeight > newZ )
			newZ = th + minHeight;
		if( th + maxHeight < newZ )
			newZ = th + maxHeight;

//		pr("th: " + th + " z: " + .z + " newZ: " + newZ );

		if (.IsInAir())
			.PlayAnim( 0, newPos, newZ );
		else
			.PlayAnim(16, newPos, th+80);
	}
}

newPos = .PickLandingPoint(120);
if (newPos.x>=0) {
	.PlayAnim(17, newPos, -1);
	.PlayAnim(18, .pos, -1); // Transition to idle
	Sleep(1);
	if (.IsInAir())
		pr("BUG");
	while (1) {
		.Idle(1300);
	}
}
