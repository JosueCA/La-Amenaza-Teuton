// void, Obj me, Obj target

Unit tgt;
Hero this;
str class;
point pt;
ObjList ol;
this = me.AsHero;
tgt = target.AsUnit;
class = tgt.class;
pt = tgt.posRH;


.FormSetupAndMoveTo (pt, 0, 0, false);
// Wait for army to exit
while(!.IsArmyOutside())
	.FormKeepMoving(500);
while(.HasPath())
{
	if(tgt.IsAlive)
	{
		pt = tgt.posRH;
	}
	if(.DistTo(pt) < .sight)
	{
		//.pr("hero::move:an enemy near destination");
		if(!tgt.IsAlive)
		{
			ol = Intersect(ObjsInSight(this, class), EnemyObjs(.player, class)).GetObjList;
			if(ol.count > 0)
			{
				tgt = ol[0];
			}
		}
		if(tgt.IsAlive)
		{
			.AddCommand(true, "engage_unit_type", tgt);
		} else
		{
			.AddCommand(true, "engage");
		}
		return;
	}

	.FormKeepMoving (1500);
}	
