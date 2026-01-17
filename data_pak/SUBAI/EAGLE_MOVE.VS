// void, Obj This, point pt

Flying  this;
point   vec, dir, newPos, straightDir, relativePos, newDir, middle;
int     angle, newAngle, straightAngle, animIdx, speed, x, y, th, newZ, minHeight, maxHeight;
bool    bToward, bNewToward;

minHeight = 150;
maxHeight = 300;

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
			animIdx = 17;
			if( ! OnLeft( middle, relativePos )) bNewToward = true;
		}
		else
		{
			newAngle = angle + 30;
			newDir = GetDirByAngle( newAngle );
			middle.Set( dir.x + newDir.x, dir.y + newDir.y );
			animIdx = 18;
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
			vec = GetVecByDir( dir, .speed / 2 );
			newPos.Set( .pos.x + vec.x, .pos.y + vec.y );
// correct z
			th = GetTerrainHeight( newPos );
			newZ = .z;
			if( th + minHeight > newZ )
				newZ = th + minHeight;
			if( th + maxHeight < newZ )
				newZ = th + maxHeight;

			.PlayAnim( animIdx, newPos, newZ );
			dir = GetDirByAngle( newAngle );
		}
	}
// fly straight to the target point
	if( bToward )
	{
		if( rand( 30 ) < 6 )
		{
			animIdx = 0;
			speed = .speed;
		}
		else
		{
			animIdx = 4;
			speed = .speed * .GetAnimDuration( 4 ) / .GetAnimDuration( 0 );
		}
		vec = GetVecByDir( dir, speed );
		newPos.Set( .pos.x + vec.x, .pos.y + vec.y );
// correct z
		th = GetTerrainHeight( newPos );
		newZ = .z;
		if( th + minHeight > newZ )
			newZ = th + minHeight;
		if( th + maxHeight < newZ )
			newZ = th + maxHeight;

//		pr("th: " + th + " z: " + .z + " newZ: " + newZ );

/*		if( newZ == .z )
			if( newZ - th < (minHeight + maxHeight) / 2 )
				newZ -= 5;
*/		.PlayAnim( animIdx, newPos, newZ );
	}
}