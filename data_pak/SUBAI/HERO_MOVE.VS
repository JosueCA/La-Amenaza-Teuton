// void, Obj This, point pt
Hero this;
point ptOrg, ptNew;
int i;
int lastHealthEffectTime;

//.pr("hero::move");
this = This.AsHero();
lastHealthEffectTime = 0;
ptOrg = .pos;

// Ivko: Always walk in formation, so newly attached units automatically enter formation
.FormSetupAndMoveTo (pt, 0, 0, true);
while (.HasPath ())
{
  .FormKeepMoving (1500);

  // Monitoreo de salud
  if (.health > 0 && .health < (.maxhealth / 2))
  {
	  if (GetTime() - lastHealthEffectTime > 250)
	  {
		  CreateFeedback("Damage2", .AsUnit());
		  lastHealthEffectTime = GetTime();
	  }
  }
}

if (.IsAlive)
if (.HasArmy)
	if (.CmdCount == 1)
	{
		.army.SetCommand("stand_position");
		.AddCommand(false, "stand_position");
	}
