// void, Obj obj
Ship this;
this = obj.AsShip;

while( ! .Goto( .GetTransPt(), 0, 1000, true, -1 ))
{
	if( .TimeWithoutWalking > 0 ) break;
}
.ApplyAiTransport();