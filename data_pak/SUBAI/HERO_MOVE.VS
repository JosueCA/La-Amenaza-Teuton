// void, Obj This, point pt
Hero this;
point ptOrg, ptNew;
int i;

//.pr("hero::move");
this = This.AsHero();
ptOrg = .pos;

// Ivko: Always walk in formation, so newly attached units automatically enter formation
.FormSetupAndMoveTo (pt, 0, 0, true);
while (.HasPath ())
{
  .FormKeepMoving (1500);
}

if (.IsAlive)
if (.HasArmy)
	if (.CmdCount == 1)
	{
		.army.SetCommand("stand_position");
		.AddCommand(false, "stand_position");
	}
