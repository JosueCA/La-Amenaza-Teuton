// void, Obj me, Obj h

Unit this;
Hero hero;
point ptoffset, ptEnter;
Obj teleport;

hero = h.AsHero();
this = me.AsUnit();

Breakpoint();

if(.HasFreedom) {
	return;
}

ptoffset.Set(rand(600) - 300, rand(600) - 300);

if (this.AsHero.IsValid()) return; 
if (!hero.IsValid()) return;
if (!hero.IsAlive()) return;
if (this.IsEnemy(hero)) return;

//.pr("attaching to hero");

while(1)
{
	if( .SameHolderAs( hero ))
		if( .AttachTo( hero ))
			break; // success

	if(!hero.IsAlive()) break;//fail
	if(.IsEnemy(hero)) break;//fail
	if(hero.IsEnemy(this)) break;//fail
	if( .InShip ) break; // fail
	if( hero.InShip ) break; // fail
	if( !.InHolder && !hero.InHolder && .posRH.Dist(hero.posRH) < 1500 )
	if(.AttachTo(hero)) break;//success
	
	teleport = FindTeleport(.player, .posRH, hero.posRH);
	if (!.AI) if (teleport.IsValid) if (.posRH.Dist(teleport.pos) > 1000) teleport.Clear;
	if (teleport.IsValid) {
	  	.AddCommand(true, "attach", hero);
  		.AddCommand(true, "teleport", teleport);
		return;
	}
	
	if( hero.InHolder ) 
		if( !hero.GetHolderSett.GetCentralBuilding.IsHeirOf("BaseRuins"))
	{
		Building bld;
		bld = hero.GetHolderSett().GetCentralBuilding();
		if (!bld.IsValid()) break;//fail
		ptEnter = bld.GetEnterPoint(this);
		.SetEntering(true);
		while(!.GotoEnter(ptEnter, 0, 1500, true, 2500) && hero.InHolder());
		.SetEntering(false);
		if(hero.InHolder())
		{
			hero.GetHolderSett().AddUnit(this);
			if(hero.IsHeroArmyFull()) break;//fail
			continue;
		}
	}
	else
		Sleep( 100 );
	if(hero.IsHeroArmyFull()) {
		.AddCommand(true, "protect", hero);
		break;//fail
	}
	if(.Goto(hero.posRH + ptoffset, 1, 1500, true, 5000))
	{
		ptoffset.Set(0, 0);
	}
}
while(!.Stop(1000));
	
