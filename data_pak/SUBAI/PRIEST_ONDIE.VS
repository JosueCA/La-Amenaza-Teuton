// void, Obj THIS

Unit u;
Druid this;
this = THIS.AsDruid;

if (.InHolder())
	return;

if(EnvReadString(.player, "Wrath of Jupiter") != "researched")
	return;

u = .GetJupiterAngerTarget;

if(u.IsAlive)
{
if(u.AsHero)
	u.Damage(50);
else
	u.Damage(300);
CreateFeedback("Lightning3", u);
}