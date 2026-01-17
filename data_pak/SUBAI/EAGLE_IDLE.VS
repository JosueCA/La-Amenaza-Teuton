// void, Obj This

Flying  this;
point   oldPos, newPos, dir, vec;
int     animIdx, speed, angle;

this = This.AsFlying();

oldPos = .pos;

oldPos.Set( oldPos.x - 1500, oldPos.y - 1500 );
oldPos = oldPos.ClampToMap;
oldPos.Set( oldPos.x + 1500, oldPos.y + 1500 );

oldPos.Set( oldPos.x + 1500, oldPos.y + 1500 );
oldPos = oldPos.ClampToMap;
oldPos.Set( oldPos.x - 1500, oldPos.y - 1500 );

newPos.Set( oldPos.x + 1000 - rand( 2000 ), oldPos.y + 1000 - rand( 2000 ));

.AddCommand( true, "move", .ClipDestToMap( newPos ) );

