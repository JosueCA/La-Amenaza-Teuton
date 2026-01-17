// void, Obj This, Obj obj

Hero  this;
Ship  ship;
bool  bThere;

this = This.AsHero;
ship = obj.AsShip;

ship.NotifyBoardUnit( this );

if( Dist( ship.pos, .pos ) > 700 )
{
	.FormSetupAndMoveTo( ship, 0, 0, false );
	while( .HasPath() && Dist( ship.pos, .pos ) > 700 )
	{
		.FormKeepMoving( 1500 );
	}
}
.army.SetCommand( "boardship", ship );
.AddCommand( true, "boardshipcommon", ship );