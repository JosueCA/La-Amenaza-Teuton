// void, Obj This

Druid this;
Unit tgt;
int  amount;
point ptStart;
bool bGaul;
Building bldEnter;


this = This.AsDruid();
bGaul = (.class == "GDruid");


ptStart = .posRH;
if (!.InShip && .InHolder) 
	bldEnter = .GetHolderSett.GetCentralBuilding;

amount = GetConst("HealAmount") + .level;

while (1) 
{
	tgt = .FindUnit2HTL(1);

	if (.hero.IsValid) if (.hero.command=="teleport") {
		Sleep(2000);
		continue;
	}
	if (!.AI)
	if(.InHolder || !.IsVisible)	{
    Sleep(2000);
		continue;
	}

	if (.hero.IsValid) if (!.hero.InHolder)
		if (.DistTo(.hero)>250)// This will go near the hero if we're far
			{ 
				.Goto(.hero, 250, 2000, false, -1);
				ptStart = .pos;
			}

  if (.AI) if (.health >= .maxhealth / 2) if (AIVar(.player, AIV_CombatMagic) != 0) if (rand(8)==1)
    if (!bGaul && IsResearched(.player, "Cloud of Plague")) {
      point pt; pt = .BestMDPos(100, 200, 1500, 1000, true);
      if (pt.x >= 0) {
        int mist_range; mist_range = GetConst("MistRange");
        if (.Goto(pt, mist_range, 2000, false, 2500)) {
          .AddCommand(true, "mist", pt);
          return;
        }
        continue;
      }
    } else if (!.InHolder) if (IsResearched(.player, "Ghoul Summoning")) {
      point pt; pt = .BestMDPos(250, 0, 1000, 500, false);
      if (pt.x >= 0) {
        .AddCommand(true, "ghost", .pos);
        return;
      }
    }

	if (tgt.AsUnit().IsAlive())
	{
		while (tgt.IsAlive()) 
		{
			if(.IsEnemy(tgt) || 
				tgt.InHolder  ||
				!.CanSee(tgt) || 
				tgt == this || 
				tgt.health == tgt.maxhealth || 
				tgt.GetSacrifice().IsValid() ||
				!.IsVisible)
					break;

			if (!.InRange(tgt) || .InHolder) 
			{
				if (!.hero.IsValid) if(.DistTo(ptStart) > .sight)
					break;
				.GotoAttack(tgt, 2000, false, 2500);
			}
			if (tgt.IsValid) if (.InRange(tgt)) 
			{
				.StartAnim(17, tgt.pos);
				Sleep(.TimeToActionMoment());
				if (tgt.IsAlive())
				if (!.IsEnemy(tgt) && 
					.CanSee(tgt) && 
					tgt.health < tgt.maxhealth && 
					!tgt.GetSacrifice().IsValid()) 
				{
					tgt.Heal(amount);
					CreateFeedback("Heal", tgt);
				}
				Sleep(.TimeToAnimFinish());
			}
		}
	}
	else if (.AI) if (.hero.IsValid) if (.hero.inherentlevel > .inherentlevel+2)
	{
		.AddCommand(true, "learn", .hero);
		return;
	}
  
  if (.InHolder) {
    Sleep(2000);
    tgt = .FindUnit2HTL(1);
		continue;
  }
	
	if (.hero.IsValid)
		{
			if (.DistTo(.hero.dest)>250)
				{
					if (.Goto(.hero.dest, 200, 2000, false, -1))
						.Idle(1000);
				}
			else
				.Idle(1000);
		}
	else
		.Idle(1000);
			
	tgt = .FindUnit2HTL(1);
	while (1)
	{
		if(tgt.IsAlive())
		if(tgt.DistTo(ptStart) - .range < .sight)
		{
			.GotoAttack(tgt, 2000, false, 2500);
			break;
		}

		if (.hero.IsValid)
			break;
		if (bldEnter.IsValid) {
			if (!.IsEnemy(bldEnter)) {
				point pt; pt = bldEnter.GetEnterPoint(this);
				if (!.GotoEnter(pt, 0, 1000, true, 5000))
					continue;
				.AddCommand(true, "enter", bldEnter);
				return;
			} else {
				bldEnter.Clear;
				ptStart = .posRH;
			}
		}

		if(.Goto(ptStart, 0, 2000, true, 1000))
			{ .Idle(2000); break; }
		tgt = .FindUnit2HTL(1);
	}
}