// void, Obj This, point pt

Hero this;
this = This.AsHero();

if(.TimePastLastAttack() < 2500)
{
	if(pt.Dist(.posRH) < .sight/2)
	{
		.pr("hero::move:moving hero around the fight");
		while(!.Goto(pt, 0, 1000, false, -1))
			if (.TimeWithoutWalking()>0)
				break;
		Sleep(7000);
		return;
	} else 
	{
		.pr("hero::move:running away");
		.AddCommand(true, "retreat", pt);
		return;
	}
} else
{
	.pr("hero::move:sneaking");
	.AddCommand(true, "sneak", pt);
	return;
}