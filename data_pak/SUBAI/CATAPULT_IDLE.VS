//void, Obj This

Catapult this;//the hero of this story
int emptytimestartdamage, maxunits, minunits, buildspeed, decayspeed; //building constants taken from const.ini
int cycletime; //how much time it takes to run the building loop (constant)
int emptytime, healthleft, unitsinside;//variables
int origsight;

this = This.AsCatapult();

if(!.IsValid) return;
if(!.IsAlive) return;

cycletime = 500;

if(!.IsBuilt)
{//catapult building

	//fundamental constants init
	origsight = .sight;
	.SetSight(GetConst("CatapultBuildSight"));
	emptytimestartdamage = GetConst("CatapultBuildOnEmptyStartDamageTime");
	maxunits             = GetConst("CatapultMaxUnits");
	minunits             = GetConst("CatapultBuildUnits");
	buildspeed           = GetConst("CatapultBuildSpeed");
	decayspeed           = GetConst("CatapultDecaySpeed");

	//variables init
	emptytime = 0;
	healthleft = .maxhealth - 1;

	.StartDelayedAnim(1, .pos, -1);
	while(.IsAlive)
	{
		if (.IsBuilt) break;
		unitsinside = .settlement.UnitsCount();
		if(unitsinside > 0)
		{
			if(unitsinside >= minunits)
			{
				int healamount;

				emptytime = 0;
				healamount = .maxhealth * buildspeed * unitsinside / (maxunits * 100);//percents of .maxhealth to heal, per second
				healamount = healamount * cycletime / 1000;//the above calculated health is 'per second'

				if(healthleft > healamount)
				{
					healthleft -= healamount;
					.Heal(healamount);
					.SetBuildFrame(healthleft);
				}
				else
				{
					.Heal(healthleft);
					healthleft = 0;
					.SetBuilt;
				}
			}
		}
		else
		{//no units inside
			int damageamount;
			damageamount = (.maxhealth * decayspeed * cycletime) / 100000;// 100000 is 100(damagespeed is percents) * 1000(which is one second)

			.SetBuildFrame(healthleft);

			emptytime += cycletime;
			if(emptytime > emptytimestartdamage)
			{
				.Damage(damageamount);
				healthleft += damageamount;
				if(healthleft > .maxhealth) healthleft = .maxhealth;
			}
		}
		Sleep(cycletime);
	}
	.SetSight(origsight);
	ExploreCircle(.player, .pos, .sight);
	.AddCommand(true, "autofire");
}
else
{//looking around
	if(.settlement.UnitsCount == 0)
	{
		int damageamount;
		damageamount = (.maxhealth * decayspeed * cycletime) / 100000;// 100000 is 100(damagespeed is percents) * 1000(which is one second)

		emptytime += cycletime;
		if(emptytime > emptytimestartdamage)
		{
			.Damage(damageamount);
		}
	}
	else emptytime = 0;
	Sleep(cycletime);
}