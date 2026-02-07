// void, Obj me

Unit this, u;
point pt;
this = me.AsUnit();

while (!.Stop(1000));

//.pr("idle: started");
while(1)
{
	u = .BestTargetInSquadSight();
	if(.IsVisible)
	if(u.IsAlive())
	if(u.maxattack > 0)
	{
		//.pr("found enemy!");
		.AddCommand( true, "engage");
		return;
	}
	{
		//.pr("idle: no enemy in sight");
		if (.Stop(2000))
		{
			//.pr("idle: doing nothing");
			if(.hero.IsValid)
			if(.hero.GetHolderSett.IsValid)
			if(!(.hero.GetHolderSett == .GetHolderSett) && !.hero.GetHolderSett.GetCentralBuilding.IsHeirOf("BaseRuins"))
			{
				.AddCommand(true, "enter", .hero.GetHolderSett.GetCentralBuilding);
				return;
			}
			.Idle(1900 + rand(100));
			if (rand(10)==0) {
				pt = .GetDir();
				if (pt.x!=0 || pt.y!=0) {
					pt.SetLen(100);
					pt.Rot(rand(60)-30);
					.Face(pt + .pos);
				}
			}
		}
	}
}