// void, Obj This, point pt

Ship this;
this = This.AsShip;

while( ! .Goto( pt, 0, 1000, true, -1 ))
{
	if( .TimeWithoutWalking > 0 ) break;
}
.UnboardAllUnits();