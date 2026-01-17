// void, Obj This, point pt
Hero this;
Obj target;

this = This.AsHero();
{
	.pr("hero::retreat:running away");
	.army.SetCommand("move", pt);
	while(!.Goto(pt, 0, 3000, false, 0))
	{
		if(.TimePastLastAttack() > 5000)
		{
			.pr("hero::retreat:seems safe to gather formation");
			.FormSetupAndMoveTo(pt, 0, 0, true);
			while(.HasPath())
				.FormKeepMoving(3000);
			return;
		}
	}
	.pr("hero::retreat:gathering formation move mode");
	.FormSetupAndMoveTo(pt+.GetDir(), 0, 0, true); // Ivko: GetDir hacks the case 'pt==.GetPos()', this should be fixed in the formations
	while(.HasPath())
	{
		.FormKeepMoving(1500);
	}

}
Sleep(2000);