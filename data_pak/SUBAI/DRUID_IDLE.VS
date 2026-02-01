// void, Obj This

Druid this;
Unit tgt;
int  amount;
point ptStart;
point pt;
int mist_range;
bool bGaul;
Building bldEnter;
int own, ally, enemy;


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

  // Combat magic for AI-controlled druids/priests
  if (.AI) {
    //pr("[DRUID_IDLE] Player " + .player + " mage is AI-controlled");
    if (.health >= .maxhealth / 2) {
      //pr("[DRUID_IDLE] Player " + .player + " has enough health (" + .health + "/" + .maxhealth + ")");
      if (rand(3) == 1) {
        //pr("[DRUID_IDLE] Player " + .player + " passed random check (50% chance)");

        // Cloud of Plague (Roman Priests)
        if (!bGaul && IsResearched(.player, "Cloud of Plague")) {
          //pr("[DRUID_IDLE] Player " + .player + " is Roman Priest with Cloud of Plague researched");

          Eval(.player, .pos, 3000, own, ally, enemy);
          //pr("[DRUID_IDLE] Player " + .player + " nearby forces - own:" + own + " ally:" + ally + " enemy:" + enemy);

          if (enemy > 15) {
            //pr("[DRUID_IDLE] Player " + .player + " enough enemies detected, searching for target");
            pt = .BestMDPos(0, 0, 15000, 1, true);
            //pr("[DRUID_IDLE] Player " + .player + " BestMDPos result: pt.x=" + pt.x + " pt.y=" + pt.y);

            if (pt.x >= 0) {
              //pr("[DRUID_IDLE] Player " + .player + " found valid target position");
              mist_range = GetConst("MistRange");
              if (.Goto(pt, mist_range, 2000, false, 2500)) {
                //pr("[DRUID_IDLE] Player " + .player + " CASTING CLOUD OF PLAGUE at (" + pt.x + "," + pt.y + ")");
                .AddCommand(true, "mist", pt);
                return;
              } //else {
                //pr("[DRUID_IDLE] Player " + .player + " failed to reach target position");
              //}
              continue;
            } //else {
              //pr("[DRUID_IDLE] Player " + .player + " no valid target found by BestMDPos");
            //}
          } //else {
            //pr("[DRUID_IDLE] Player " + .player + " not enough enemies for Cloud of Plague (enemy=" + enemy + ", need > 20)");
          //}
        } else if (bGaul && IsResearched(.player, "Ghoul Summoning")) {
          //pr("[DRUID_IDLE] Player " + .player + " is Gaul Druid with Ghoul Summoning researched");

          if (!.InHolder) {
            //pr("[DRUID_IDLE] Player " + .player + " not in holder, checking for enemies");
            Eval(.player, .pos, 1500, own, ally, enemy);
            //pr("[DRUID_IDLE] Player " + .player + " nearby forces - own:" + own + " ally:" + ally + " enemy:" + enemy);

            if (enemy > 15) {
              //pr("[DRUID_IDLE] Player " + .player + " SUMMONING GHOUL at current position");
              .AddCommand(true, "ghost", .pos);
              return;
            } //else {
              //pr("[DRUID_IDLE] Player " + .player + " not enough enemies for ghoul (enemy=" + enemy + ", need > 20)");
            //}
          } //else {
            //pr("[DRUID_IDLE] Player " + .player + " is in holder, cannot summon ghoul");
          //}
        } //else {
          //if (bGaul) {
            //pr("[DRUID_IDLE] Player " + .player + " is Gaul but Ghoul Summoning not researched");
          //} else {
            //pr("[DRUID_IDLE] Player " + .player + " is Roman but Cloud of Plague not researched");
          //}
        //}
      } //else {
        //pr("[DRUID_IDLE] Player " + .player + " failed random check (50% chance)");
      //}
    } //else {
      //pr("[DRUID_IDLE] Player " + .player + " has low health (" + .health + "/" + .maxhealth + ")");
    //}
  }

	if (tgt.IsValid && tgt.IsAlive())
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
				pt = bldEnter.GetEnterPoint(this);
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