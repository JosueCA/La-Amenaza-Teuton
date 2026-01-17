// void, Obj This, point pt

Flying this;
point  newPos;
int    i, radius, circleSegs, angle, min, dist, start;

radius = 800;
circleSegs = 32;
this = This.AsFlying();
start = 0;

// find closest point to the 'hover circle'
min = 64000;
for( i = 0; i < circleSegs; i += 1 )
{
	angle = 360 * i / circleSegs;
	newPos = pt + GetVecByDir( GetDirByAngle( angle ), radius );
	dist = .DistTo( newPos );
	if( dist < min )
	{
		min = dist;
		start = i;
	}
}
// compose commands so eagle starts hovering from the closest point
newPos = pt + GetVecByDir( GetDirByAngle( 360 * start / circleSegs ), radius );
.AddCommand( false, "move", newPos );

newPos = pt + GetVecByDir( GetDirByAngle( 360 * ( start + circleSegs / 3 ) / circleSegs ), radius );
.AddCommand( false, "move", newPos );

newPos = pt + GetVecByDir( GetDirByAngle( 360 * ( start + circleSegs * 2 / 3 ) / circleSegs ), radius );
.AddCommand( false, "move", newPos );

newPos = pt + GetVecByDir( GetDirByAngle( 360 * ( start - circleSegs / 8 ) / circleSegs ), radius );
.AddCommand( false, "move", newPos );

.AddCommand( false, "lesser_hover", pt );