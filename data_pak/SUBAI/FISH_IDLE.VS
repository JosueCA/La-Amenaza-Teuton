// void, Obj me

point pt, ptDir;
rect rcMap;
Unit this;

this = me.AsUnit;
.SetFeeding( false );
.SetNoselectFlag( true );
.SetMinimapFlag( true );

ptDir = .GetDir;

rcMap = GetMapRect;
Sleep(1000); // If the script gets breaked because of the Goto, this will prevent the nahgup of the game
while(1)
{
	ptDir.SetLen(.sight);
	ptDir.Rot(15+rand(30));
	pt = ptDir +.pos; 
	if(!pt.InRect(rcMap))
	{
		.Idle(50);
		continue;
	}
	if(!IsPointInWater(pt))
	{
		.Idle(50);
		continue;
	}
	while(!.Goto(pt, 0, 10000, true, 0) && .HasPath);
}




