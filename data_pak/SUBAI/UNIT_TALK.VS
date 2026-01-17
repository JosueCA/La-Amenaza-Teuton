// void, Obj obj, Obj other

Unit this;

this = obj.AsUnit;

if( other.IsAlive())
{
	while( ! .Stop( 1000 ));
	while( ! .Goto( other, 20, 2000, false, 0 ))
	{
		if( ! other.IsAlive()) break;
		.pr("walking");
	}
}
if( other.IsAlive())
{
	.Face( other.posRH );
	.Idle( 3000 + rand( 200 ));
}