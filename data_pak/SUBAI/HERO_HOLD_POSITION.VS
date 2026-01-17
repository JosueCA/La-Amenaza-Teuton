// void, Obj me

Hero this;
Unit u;
Building b;
point pt;
int i;
  
this = me.AsHero();

pt = .posRH;

.FormSetupAndMoveTo(pt,0,0,true);
while(.HasPath())
{
	.FormKeepMoving(1500);
}

.army.SetCommand("hold_position");

u = .BestTargetForPos();
while(1)
{
	if(u.IsAlive())
	{
		while(u.IsAlive())
		{
			while(!.Attack(u))
			{
				u = .BestTargetForPos();
				if(!u.IsValid()) break;
			}
			if(!.IsVisible)
				.SetVisible(true);
			if(u.IsAlive)
			{
				for(i = 0; i < 3; i+=1)
				{
					if(!.Attack(u))
						break;
					 if(!.IsVisible) .SetVisible(true);	 
				}
			}
			u = .BestTargetForPos();
		}
	}
	else
	{
		.Idle(2000);
		u = .BestTargetForPos();
	}
}