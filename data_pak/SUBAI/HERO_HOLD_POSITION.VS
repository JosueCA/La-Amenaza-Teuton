// void, Obj me

Hero this;
Unit u;
Building b;
point pt;
int i;
int lastHealthEffectTime;

this = me.AsHero();
lastHealthEffectTime = 0;

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
			// Monitoreo de salud durante el combate - ANTES de atacar
			if (.health > 0 && .health < (.maxhealth / 2))
			{
				if (GetTime() - lastHealthEffectTime > 250)
				{
					CreateFeedback("Damage2", .AsUnit());
					lastHealthEffectTime = GetTime();
				}
			}

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
					// Crear feedback antes de cada ataque adicional
					if (.health > 0 && .health < (.maxhealth / 2))
					{
						if (GetTime() - lastHealthEffectTime > 250)
						{
							CreateFeedback("Damage2", .AsUnit());
							lastHealthEffectTime = GetTime();
						}
					}

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

		// Monitoreo de salud cuando está idle
		if (.health > 0 && .health < (.maxhealth / 2))
		{
			if (GetTime() - lastHealthEffectTime > 250)
			{
				CreateFeedback("Damage2", .AsUnit());
				lastHealthEffectTime = GetTime();
			}
		}
	}
}