// void, Obj This

Druid this;
Unit tgt;
int  amount;
point ptStart;
bool bFirstTarget;
Building bldEnter;

bFirstTarget = true;

this = This.AsDruid();

ptStart = .posRH;

amount = GetConst("HealAmount") + .level;
tgt = .FindUnit2HTL(1);

while (1) 
{
	if(.InHolder || !.IsVisible)
	{
		Sleep(2000);
		continue;
	}
	if( tgt.AsUnit().IsAlive())
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
			else
				Sleep( 1000 );
		}
	}
	if (.AI) if (.hero.IsValid) if (.hero.inherentlevel > .inherentlevel+2)
	{
		.AddCommand(true, "stand_position");
		.AddCommand(true, "learn", .hero);
		return;
	}
	.Idle(1000);
	tgt = .FindUnit2HTL(1);
}