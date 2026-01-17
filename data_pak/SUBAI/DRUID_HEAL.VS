// void, Obj This, Obj target

Druid this;
Unit tgt;
int  amount;
point ptStart;
bool bFirstTarget;
bFirstTarget = true;


this = This.AsDruid();
tgt = target.AsUnit();

amount = GetConst("HealAmount") + .level;

	if (tgt.AsUnit().IsAlive())
	{
		if( tgt.AsShip().IsValid()) return;
		while (tgt.IsAlive()) 
		{
			if( !.IsValid ) 
				break;
			if( !.IsAlive )
				break;
			if(	.IsEnemy(tgt) || 
				tgt.InHolder  ||
				!.CanSee(tgt) || 
				tgt == this || 
				tgt.health == tgt.maxhealth || 
				tgt.GetSacrifice().IsValid())
					break;

			if (!.InRange(tgt)) 
			{
				.GotoAttack(tgt, 2000, false, 2500);
			}
			if (.InRange(tgt)) 
			{
				if(!.IsVisible) .SetVisible(true);
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
