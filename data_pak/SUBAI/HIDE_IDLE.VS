// void, Obj This

Sacrifice this;
int life, price, i;
ObjList ol;
Unit u;

this = This.AsSacrifice();
if (!this.IsValid()) return;
ol = Intersect(ObjsInSight(this, "Unit"), FriendlyObjs(.player, "Unit")).GetObjList;
[
  for(i = 0; i < ol.count; )
  {
  	u = ol[i];
	if(u.AsHero)
		ol.AddList(u.AsHero.army);
	if(!u.IsVisible || u.command == "help-sacrifice")
       ol.Remove(u);
	else
	   i+=1;
  }
]

ol.SetVisible(false);
ol.SetCommand("idle");

price = GetConst("HideToll");

//.pr("hide::idle: Sacrifice begins");


life = 1;

while (life > 0) {
	life = .Consume(price, 1000, true);
	//.pr("hide::idle: Got health: " + life);
   ol.AddList(.Druids);
   .Druids.SetVisible(false);
   ol.ClearDead();
   for(i = 0; i < ol.count; )
	{
		if(ol[i].IsVisible)
		{
			ol.Remove(ol[i]);
			continue;
		}
		if(.DistTo(ol[i]) > 2000)
		{
			u = ol[i].AsUnit;
			if(u.IsValid)
			{
				if(u.hero.IsValid)
				{
					if(!ol.Contains(u.hero))
					{
						ol[i].SetVisible(true);
						ol.Remove(ol[i]);
						continue;
					}
				} else
				{
					ol[i].SetVisible(true);
					ol.Remove(ol[i]);
					continue;
				}
			}
		}
		i += 1;		
	}
}

ol.SetVisible(true);
.Erase();

//.pr("hide::idle: Sacrifice has ended");


