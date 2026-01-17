// void, Obj This
{
	Unit  this;
	point pt;
	
	this = This.AsUnit ();

	.FormAcceptMove ();
	while (.HasPath ())
	{
		.FormKeepMoving (1000);
	}
	if( .hero.IsValid )
	{
		pt.Set( .pos.x + .hero.GetDir.x, .pos.y + .hero.GetDir.y );
		.Face( pt );
	}
}