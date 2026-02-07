// void, Obj This, point pt

Hero this;
Obj attacker, target;
this = This.AsHero();

//.pr("hero::move: defensive move - attack if attacked");
.FormSetupAndMoveTo(pt, 0, 0, true);
while(.HasPath())
{
	attacker = .LastAttacker();
	if(.TimePastLastAttack() < 2500)
	if(attacker.IsAlive())
	{
		//.pr("hero::move:attacker!!!");
		.AddCommand(true, "sneak", pt);
		.AddCommand(true, "engage");
		return;
	}
	target = .BestTargetInSquadSight();
	if(target.IsValid())
	if(target.pos.Dist(pt) < .sight/2)
	{
		//.pr("hero::move:an enemy near destination");
		.AddCommand(true, "advance", pt);
		return;
	} else if (.AI) if (target.player < 9) if (.IsValidTarget(target)) if (target.maxattack > 0) {
		.AddCommand(true, "sneak", pt);
		.AddCommand(true, "engage");
		return;
  }
	.FormKeepMoving (1500);
}