// void, Obj This

Settlement this;
Wagon      wagon;
point      ptGo;

this = This.AsBuilding().settlement;

wagon = .CreateBoatGold( 250 );
if( wagon.IsValid )
{
	ClearSelection( wagon.player );
	wagon.Select( wagon.player );
	ptGo = .GetCentralBuilding.GetExitVector();
	ptGo.Set( ptGo.x * 2, ptGo.y * 2 );
	wagon.AddCommand( false, "move", This.pos + ptGo );
	wagon.KillCommand();
}