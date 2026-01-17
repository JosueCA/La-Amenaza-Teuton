//void, Obj This

Building this;
ObjList l,p;
point pt;
int i, nOldPlayer;

this = This.AsBuilding();

nOldPlayer = .player;

if(.IsValid()) {
	while(true)	{
		if (.player != nOldPlayer) { //if was captured between sleeps
			nOldPlayer = .player; //to avoid multiple .player calls update this now
			//select a point to go to
			pt.Set(1,0);
			pt.SetLen(.radius);
			pt.Rot(rand(360));
			pt = pt + .pos;
			//get all non-mine units out!
			l = .settlement().Units();
			l.ClearDead();
			p.Clear();
			for (i=0; i< .settlement.UnitsCount(); i+=1) {
				Unit u;
				u = l[i].AsUnit();
				if (u.IsValid()) if (u.player != nOldPlayer) {
					if (!u.hero.IsValid())
						p.Add(u);
				}
			}
			p.SetCommand("advance", pt);
		}
		Sleep(1000);
	}
} else {
	Sleep(10000);//will restart after 10 seconds
}




//////////////////////////////////



if(.IsValid())
{
	while(true)
	{
		if(.settlement.loyalty < GetConst("LoyaltyUnitsOutTreshold")) {
			Obj o;
			Unit u;
			.pr("loyalty below treshold");

			pt.Set(1,1);
			pt.SetLen( rand(.sight-.radius) +  .radius );
			pt.Rot(rand(360));
			pt= pt + .pos;

			l = .settlement().Units();
			p.Clear();
			for(i = 0; i < l.count(); i = i + 1)
			{
				o = l[i];
				u = o.AsUnit();
				if(u.IsValid())
				{
					if(!u.hero().IsValid())
					{
						p.Add(o);
					}
				}
			}
			//Command Stack
			//p.AddCommand(true,"enter",this);
			p.AddCommand(true,"advance",pt);
			p.KillCommand();
		}

		Sleep(2000);
	}
}
else
{
	Sleep(10000);//will restart after 10 seconds
}
