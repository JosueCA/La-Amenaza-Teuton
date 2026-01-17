// void, Obj me, Obj target

Unit tgt;
Unit this;
str class;
point pt;
ObjList ol;
this = me.AsUnit;
tgt = target.AsUnit;
class = tgt.class;
pt = tgt.posRH;


while(!.Goto(pt, 0, 4000, true, 0))
{

	if(tgt.IsAlive)
	{
		pt = tgt.posRH;
	}
	if(.DistTo(pt) < .sight*2/3)
	{
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
}	
